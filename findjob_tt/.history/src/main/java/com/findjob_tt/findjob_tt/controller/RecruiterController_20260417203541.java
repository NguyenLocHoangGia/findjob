package com.findjob_tt.findjob_tt.controller;

import java.io.File;
import java.nio.file.Paths;
import java.security.Principal; // THÊM IMPORT NÀY
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.model.CompanyProfile;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.Notification;
import com.findjob_tt.findjob_tt.model.User; // THÊM IMPORT NÀY
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.CategoryRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.NotificationRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository; // THÊM IMPORT NÀY
import com.findjob_tt.findjob_tt.service.UploadFileService;

@Controller
public class RecruiterController {

    @Autowired
    private JobRepository jobRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UploadFileService uploadFileService;

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private ApplicationRepository applicationRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    private String getEmailFromPrincipal(Principal principal) {
        if (principal == null) {
            return null;
        }
        if (principal instanceof OAuth2AuthenticationToken oauthToken) {
            OAuth2User oauth2User = oauthToken.getPrincipal();
            return oauth2User.getAttribute("email");
        }
        return principal.getName();
    }

    // 1. Trang Dashboard
    @GetMapping("/recruiter/dashboard")
    public String showRecruiterDashboard(Model model, Principal principal) {
        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        User user = userRepository.findByEmail(email);
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("userFullName", user.getFullName());

        List<Job> jobs = user.getJobs();
        model.addAttribute("jobs", jobs);

        // --- BỔ SUNG LOGIC TÍNH TOÁN THỐNG KÊ Ở ĐÂY ---
        int totalJobs = jobs.size();
        int totalCandidates = 0;
        int pendingCandidates = 0;

        for (Job job : jobs) {
            totalCandidates += job.getApplications().size();
            for (Application app : job.getApplications()) {
                // Đếm những đơn có status là PENDING hoặc chưa có status (null)
                if ("PENDING".equals(app.getStatus()) || app.getStatus() == null) {
                    pendingCandidates++;
                }
            }
        }

        // Truyền các con số này ra ngoài giao diện JSP
        model.addAttribute("totalJobs", totalJobs);
        model.addAttribute("totalCandidates", totalCandidates);
        model.addAttribute("pendingCandidates", pendingCandidates);
        // ----------------------------------------------
        return "recruiter/dashboard";
    }

    // 2. Logic Xóa công việc
    @GetMapping("/recruiter/delete-job/{id}")
    public String deleteJob(@PathVariable("id") Long id, Principal principal, RedirectAttributes ra) {
        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        Job job = jobRepository.findById(id).orElse(null);

        // Bảo mật: Kiểm tra quyền sở hữu
        if (job != null && job.getUser().getEmail().equals(email)) {
            jobRepository.delete(job);
            ra.addFlashAttribute("successMsg", "Đã xóa công việc và các hồ sơ liên quan thành công!");
        } else {
            ra.addFlashAttribute("errorMsg", "Bạn không có quyền thực hiện thao tác này!");
        }
        return "redirect:/recruiter/dashboard";
    }

    // 3. Xem ứng viên theo từng Job
    @GetMapping("/recruiter/job/{id}/candidates")
    public String showCandidatesByJob(@PathVariable("id") Long jobId, Model model, Principal principal) {
        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        Job job = jobRepository.findById(jobId).orElse(null);

        if (job == null || !job.getUser().getEmail().equals(email)) {
            return "redirect:/recruiter/dashboard?error=access_denied";
        }

        model.addAttribute("job", job);
        model.addAttribute("applications", job.getApplications());
        return "recruiter/job-candidates";
    }

    @PostMapping("/recruiter/register-company")
    public String processRegisterCompany(
            @RequestParam("companyName") String companyName,
            @RequestParam("companyAddress") String companyAddress,
            @RequestParam("description") String description,
            @RequestParam("logoFile") MultipartFile logoFile,
            @RequestParam("licenseFile") MultipartFile licenseFile, // Khai báo file giấy phép
            Principal principal,
            RedirectAttributes redirectAttributes) {

        try {
            // Bước 1: Lấy thông tin User hiện tại
            String email = getEmailFromPrincipal(principal);
            if (email == null || email.isBlank()) {
                return "redirect:/login";
            }

            User user = userRepository.findByEmail(email);
            if (user == null) {
                return "redirect:/login";
            }

            // Bước 2: Xử lý file Logo và file Giấy phép kinh doanh
            String logoFileName = null;
            if (logoFile != null && !logoFile.isEmpty()) {
                logoFileName = uploadFileService.handleSaveUploadFile(logoFile, "company_logos");
            }

            String licenseFileName = null;
            if (licenseFile != null && !licenseFile.isEmpty()) {
                // Lưu vào thư mục business_licenses
                licenseFileName = uploadFileService.handleSaveUploadFile(licenseFile, "business_licenses");
            }

            // Bước 3: Khởi tạo và lưu thông tin vào CompanyProfile
            CompanyProfile companyProfile = user.getCompanyProfile();
            if (companyProfile == null) {
                companyProfile = new CompanyProfile();
                companyProfile.setUser(user);
            }
            companyProfile.setCompanyName(companyName);
            companyProfile.setCompanyAddress(companyAddress);
            companyProfile.setDescription(description);
            companyProfile.setStatus("PENDING"); // Khóa ở trạng thái chờ duyệt

            if (logoFileName != null) {
                companyProfile.setCompanyLogo(logoFileName);
            }

            // LƯU TÊN FILE GIẤY PHÉP VÀO DATABASE
            if (licenseFileName != null) {
                companyProfile.setBusinessLicense(licenseFileName);
            }

            user.setCompanyProfile(companyProfile);

            // ========================================================================
            // ĐÃ XÓA BƯỚC 4 VÀ 5 CỦA BẠN.
            // Lý do: Quyền ROLE_RECRUITER chỉ được cấp khi Admin ấn nút "Duyệt"
            // ở trang quản trị. Tuyệt đối không cấp ở đây!
            // ========================================================================

            // Lưu thông tin công ty xuống Database
            userRepository.save(user);

            // Đẩy về TRANG CHỦ với thông báo bắt họ chờ
            redirectAttributes.addFlashAttribute("successMsg",
                    "Gửi yêu cầu thành công! Vui lòng chờ Ban quản trị xét duyệt hồ sơ và giấy phép doanh nghiệp của bạn.");
            return "redirect:/";

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMsg", "Có lỗi xảy ra khi tải file hoặc lưu thông tin công ty!");
            return "redirect:/switch-to-recruiter"; // Trả về lại form đăng ký
        }
    }

    // 2. Mở trang Form Đăng tin tuyển dụng
    // MỞ TRANG FORM ĐĂNG TIN TUYỂN DỤNG (CÓ TRUYỀN DỮ LIỆU ĐỂ PRE-FILL)
    @GetMapping("/recruiter/job/add")
    public String showAddJobForm(Model model, Principal principal) {
        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        User user = userRepository.findByEmail(email);
        if (user == null) {
            return "redirect:/login";
        }

        if (user.getCompanyProfile() != null) {
            model.addAttribute("company", user.getCompanyProfile());
        }

        // BỔ SUNG: Truyền toàn bộ danh sách Category sang View
        model.addAttribute("categories", categoryRepository.findAll());

        return "recruiter/add-job";
    }

    // XỬ LÝ LƯU HỒ SƠ VÀO DATABASE
    @PostMapping("/recruiter/job/save")
    public String saveJob(
            @ModelAttribute Job job,
            @RequestParam("categoryId") Long categoryId, // Lấy ID của Category từ thẻ <select>
            @RequestParam(value = "logoFile", required = false) MultipartFile file,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        User currentUser = userRepository.findByEmail(email);
        if (currentUser == null) {
            return "redirect:/login";
        }

        job.setUser(currentUser);

        // BỔ SUNG: Tìm Category trong DB dựa vào ID người dùng chọn và gán vào Job
        com.findjob_tt.findjob_tt.model.Category category = categoryRepository.findById(categoryId).orElse(null);
        if (category != null) {
            job.setCategory(category);
        }

        // Xử lý logo
        if (file != null && !file.isEmpty()) {
            String fileName = uploadFileService.handleSaveUploadFile(file, "job_logos");
            job.setLogo(fileName);
        } else {
            if (currentUser.getCompanyProfile() != null) {
                job.setLogo(currentUser.getCompanyProfile().getCompanyLogo());
            }
        }

        jobRepository.save(job);
        redirectAttributes.addFlashAttribute("successMsg", "Đăng tin thành công!");
        return "redirect:/recruiter/dashboard";
    }

    @GetMapping("/recruiter/application/{id}/status/{action}")
    public String updateApplicationStatus(@PathVariable Long id, @PathVariable String action, Principal principal) {
        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        Application app = applicationRepository.findById(id).orElse(null);

        if (app != null && app.getJob().getUser().getEmail().equals(email)) {
            Notification notification = new Notification();
            notification.setUser(app.getUser()); // Gửi cho người nộp đơn

            if ("approve".equals(action)) {
                app.setStatus("APPROVED");
                notification.setMessage(
                        "Chúc mừng! Hồ sơ của bạn cho vị trí '" + app.getJob().getTitle() + "' đã được chấp nhận.");
            } else {
                app.setStatus("REJECTED");
                notification.setMessage("Rất tiếc, hồ sơ của bạn cho vị trí '" + app.getJob().getTitle()
                        + "' không phù hợp ở thời điểm này.");
            }

            applicationRepository.save(app);
            notificationRepository.save(notification);

            // Trả về đúng trang danh sách ứng viên của công việc đó
            return "redirect:/recruiter/job/" + app.getJob().getId() + "/candidates";
        }

        // Nếu app bị null hoặc user không có quyền -> Đẩy về Dashboard cho an toàn
        return "redirect:/recruiter/dashboard";
    }

    // 1. Lấy thông tin công việc và hiển thị trang chỉnh sửa
    @GetMapping("/recruiter/edit-job/{id}")
    public String showEditJobForm(@PathVariable Long id, Principal principal, Model model,
            RedirectAttributes redirectAttributes) {
        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        Job job = jobRepository.findById(id).orElse(null);

        // Bảo mật: Kiểm tra xem công việc có tồn tại và có đúng là của user đang đăng
        // nhập không
        if (job == null || !job.getUser().getEmail().equals(email)) {
            redirectAttributes.addFlashAttribute("errorMsg",
                    "Công việc không tồn tại hoặc bạn không có quyền chỉnh sửa!");
            return "redirect:/recruiter/dashboard";
        }

        model.addAttribute("job", job);
        return "recruiter/edit-job"; // Trỏ đến file JSP giao diện sửa
    }

    // 2. Xử lý lưu thông tin cập nhật
    @PostMapping("/recruiter/edit-job")
    public String updateJob(@ModelAttribute Job formJob,
            @RequestParam("logoFile") MultipartFile logoFile,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        // Tìm lại công việc gốc trong Database
        Job existingJob = jobRepository.findById(formJob.getId()).orElse(null);

        // Bảo mật lớp thứ 2 khi Submit form
        if (existingJob != null && existingJob.getUser().getEmail().equals(email)) {

            // Cập nhật các trường văn bản (không đụng đến Ngày tạo, ID, hoặc danh sách ứng
            // viên)
            existingJob.setTitle(formJob.getTitle());
            existingJob.setCompanyName(formJob.getCompanyName());
            existingJob.setLocation(formJob.getLocation());
            existingJob.setSalary(formJob.getSalary());
            existingJob.setShortDescription(formJob.getShortDescription());
            existingJob.setDescription(formJob.getDescription());
            existingJob.setIsActive(formJob.getIsActive());

            // Xử lý nếu người dùng có tải lên Logo mới
            if (!logoFile.isEmpty()) {
                try {
                    // Loại bỏ khoảng trắng trong tên file để tránh lỗi URL %20
                    String originalFilename = logoFile.getOriginalFilename();
                    String cleanFileName = originalFilename.replaceAll("\\s+", "_");
                    String newFileName = System.currentTimeMillis() + "_" + cleanFileName;

                    // Thay đổi đường dẫn này nếu thư mục lưu của bạn khác
                    String uploadDir = Paths.get(System.getProperty("user.dir"), "src", "main", "resources", "static",
                            "uploads", "job_logos").toString();
                    File dir = new File(uploadDir);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    File serverFile = new File(dir.getAbsolutePath() + File.separator + newFileName);
                    logoFile.transferTo(serverFile);

                    // Cập nhật tên logo mới vào Database
                    existingJob.setLogo(newFileName);
                } catch (Exception e) {
                    e.printStackTrace();
                    redirectAttributes.addFlashAttribute("errorMsg", "Có lỗi xảy ra khi tải ảnh lên!");
                    return "redirect:/recruiter/edit-job/" + existingJob.getId();
                }
            }

            // Lưu lại thông tin đã cập nhật
            jobRepository.save(existingJob);
            redirectAttributes.addFlashAttribute("successMsg",
                    "Đã cập nhật công việc: " + existingJob.getTitle() + " thành công!");
        } else {
            redirectAttributes.addFlashAttribute("errorMsg", "Thao tác không hợp lệ!");
        }

        return "redirect:/recruiter/dashboard";
    }

    @GetMapping("/recruiter/toggle-job-status/{id}")
    public String toggleJobStatus(@PathVariable Long id, Principal principal, RedirectAttributes redirectAttributes) {
        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        Job job = jobRepository.findById(id).orElse(null);

        // Kiểm tra bảo mật
        if (job != null && job.getUser().getEmail().equals(email)) {

            boolean isCurrentlyActive = job.getIsActive();

            // Đảo ngược trạng thái
            job.setIsActive(!isCurrentlyActive);
            jobRepository.save(job);

            // NẾU HÀNH ĐỘNG LÀ ĐÓNG TIN TUYỂN DỤNG
            if (isCurrentlyActive == true) {
                List<Notification> autoNotifications = new ArrayList<>();

                for (Application app : job.getApplications()) {
                    // Chỉ gửi thông báo cho những người chưa được duyệt (PENDING)
                    if (app.getStatus() == null || "PENDING".equals(app.getStatus())) {
                        Notification notif = new Notification();
                        notif.setUser(app.getUser());
                        notif.setMessage("Tin tuyển dụng '" + job.getTitle()
                                + "' đã đóng nhận hồ sơ. Nhà tuyển dụng đang trong quá trình xét duyệt các ứng viên cuối cùng.");
                        autoNotifications.add(notif);
                    }
                }

                // Lưu một loạt thông báo vào Database
                if (!autoNotifications.isEmpty()) {
                    notificationRepository.saveAll(autoNotifications);
                }
            }

            String statusText = job.getIsActive() ? "MỞ" : "ĐÓNG";
            redirectAttributes.addFlashAttribute("successMsg", "Đã " + statusText + " công việc: " + job.getTitle());

        } else {
            redirectAttributes.addFlashAttribute("errorMsg",
                    "Lỗi: Không tìm thấy công việc hoặc không có quyền thao tác!");
        }

        return "redirect:/recruiter/jobs";
    }

    @GetMapping("/recruiter/jobs")
    public String manageJobs(Model model, Principal principal) {
        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        User user = userRepository.findByEmail(email);
        if (user == null) {
            return "redirect:/login";
        }

        // Lấy toàn bộ công việc và sắp xếp mới nhất lên đầu (Bạn có thể thêm phân trang
        // sau)
        List<Job> jobs = user.getJobs();
        // Giả sử có hàm sắp xếp ngược nếu bạn lấy list từ user
        Collections.reverse(jobs);

        model.addAttribute("jobs", jobs);
        return "recruiter/manage-jobs"; // Trỏ tới file JSP mới
    }

    @GetMapping("/recruiter/edit-company")
    public String showEditCompanyForm(Principal principal, Model model) {
        // 1. Lấy thông tin tài khoản đang đăng nhập
        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        User currentUser = userRepository.findByEmail(email);
        if (currentUser == null) {
            return "redirect:/login";
        }

        // 2. Sử dụng đúng phương thức getCompanyProfile() từ model User
        if (currentUser != null && currentUser.getCompanyProfile() != null) {

            // Truyền đối tượng ra view với tên "company" để khớp với biến
            // ${company.companyName} trên JSP
            model.addAttribute("company", currentUser.getCompanyProfile());
            return "recruiter/edit-company";
        }

        // 3. Nếu chưa có công ty -> Đẩy về trang đăng ký
        return "redirect:/switch-to-recruiter";
    }

    @PostMapping("/recruiter/update-company")
    public String updateCompanyProfile(
            @RequestParam("companyName") String companyName,
            @RequestParam("companyAddress") String companyAddress,
            @RequestParam("description") String description,
            @RequestParam(value = "logoFile", required = false) MultipartFile logoFile,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        // 1. Lấy user đang đăng nhập
        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        User currentUser = userRepository.findByEmail(email);
        if (currentUser == null) {
            return "redirect:/login";
        }

        // 2. Lấy hồ sơ công ty hiện tại (hoặc tạo mới nếu bị lỗi dữ liệu hụt)
        CompanyProfile company = currentUser.getCompanyProfile();
        if (company == null) {
            company = new CompanyProfile();
            company.setUser(currentUser);
            currentUser.setCompanyProfile(company);
        }

        // 3. Cập nhật các trường văn bản
        company.setCompanyName(companyName);
        company.setCompanyAddress(companyAddress);
        company.setDescription(description);

        // 4. Xử lý Upload Logo (Nếu người dùng có chọn tệp mới)
        if (logoFile != null && !logoFile.isEmpty()) {
            try {
                // Tạo tên file độc nhất để không bị trùng đè (Thêm timestamp vào trước tên gốc)
                String originalFilename = logoFile.getOriginalFilename();
                String cleanFileName = originalFilename.replaceAll("\\s+", "_"); // Xóa khoảng trắng
                String newFileName = System.currentTimeMillis() + "_" + cleanFileName;

                // Đường dẫn thư mục lưu ảnh (Sửa lại thư mục nếu dự án của bạn lưu chỗ khác)
                String uploadDir = Paths.get(System.getProperty("user.dir"),
                        "src", "main", "resources", "static", "uploads", "company_logos").toString();

                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs(); // Tạo thư mục nếu chưa tồn tại
                }

                // Chép file từ bộ nhớ tạm vào ổ cứng
                File serverFile = new File(dir.getAbsolutePath() + File.separator + newFileName);
                logoFile.transferTo(serverFile);

                // Lưu tên file mới vào đối tượng Company
                company.setCompanyLogo(newFileName);

            } catch (Exception e) {
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("errorMsg", "Có lỗi xảy ra khi tải ảnh lên: " + e.getMessage());
                return "redirect:/recruiter/edit-company";
            }
        }

        // 5. Lưu vào Database
        // Cực kỳ tiện lợi: Nhờ CascadeType.ALL trong User.java, ta chỉ cần lưu User là
        // CompanyProfile sẽ tự động được lưu theo!
        userRepository.save(currentUser);

        // 6. Gửi thông báo thành công và tải lại trang
        redirectAttributes.addFlashAttribute("successMsg", "Đã cập nhật thông tin Công ty thành công!");
        return "redirect:/recruiter/edit-company";
    }

    // Bắt cả 2 đường dẫn để chắc chắn không bị sót link nào trên Header
    @GetMapping({ "/switch-to-recruiter", "/recruiter/register-company" })
    public String showRegisterCompanyForm(Principal principal, Model model,
            @RequestParam(value = "retry", required = false) String retry) {

        if (principal == null)
            return "redirect:/login";

        String email = getEmailFromPrincipal(principal);
        if (email == null || email.isBlank()) {
            return "redirect:/login";
        }

        User user = userRepository.findByEmail(email);
        if (user == null) {
            return "redirect:/login";
        }

        CompanyProfile company = user.getCompanyProfile();

        if (company != null) {
            // 1. ĐÃ DUYỆT (Xử lý Cấp thẻ nóng & Hiện trang Chúc mừng)
            if ("APPROVED".equals(company.getStatus())) {

                // Lấy tấm thẻ (Session) hiện tại của người dùng
                Authentication auth = SecurityContextHolder.getContext().getAuthentication();
                boolean hasRecruiterRole = auth.getAuthorities().stream()
                        .anyMatch(a -> a.getAuthority().equals("ROLE_RECRUITER"));

                // Nếu trong thẻ CHƯA CÓ quyền Recruiter (Nghĩa là vừa được duyệt xong)
                if (!hasRecruiterRole) {
                    // Âm thầm cấp thêm quyền ROLE_RECRUITER vào Session ngay lập tức
                    List<GrantedAuthority> updatedAuthorities = new ArrayList<>(auth.getAuthorities());
                    updatedAuthorities.add(new SimpleGrantedAuthority("ROLE_RECRUITER"));
                    Authentication newAuth = new UsernamePasswordAuthenticationToken(auth.getPrincipal(),
                            auth.getCredentials(), updatedAuthorities);
                    SecurityContextHolder.getContext().setAuthentication(newAuth);

                    // Hiện trang CHÚC MỪNG
                    model.addAttribute("company", company);
                    return "recruiter/company-status";
                }

                // Nếu trong thẻ ĐÃ CÓ quyền rồi (Các lần truy cập sau đó) -> Vào thẳng
                // Dashboard luôn
                return "redirect:/recruiter/dashboard";
            }

            // 2. BỊ TỪ CHỐI & XIN LÀM LẠI
            if ("REJECTED".equals(company.getStatus()) && "true".equals(retry)) {
                model.addAttribute("company", company);
                return "recruiter/register-company";
            }

            // 3. ĐANG CHỜ hoặc BỊ TỪ CHỐI (Mặc định)
            if ("PENDING".equals(company.getStatus()) || "REJECTED".equals(company.getStatus())) {
                model.addAttribute("company", company);
                return "recruiter/company-status";
            }
        }

        // 4. CHƯA CÓ GÌ
        return "recruiter/register-company";
    }

}