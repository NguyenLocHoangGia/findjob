package com.findjob_tt.findjob_tt.controller;

import java.io.File;
import java.nio.file.Paths;
import java.security.Principal; // THÊM IMPORT NÀY
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.model.CompanyProfile;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.Notification;
import com.findjob_tt.findjob_tt.model.Role;
import com.findjob_tt.findjob_tt.model.User; // THÊM IMPORT NÀY
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.NotificationRepository;
import com.findjob_tt.findjob_tt.repository.RoleRepository;
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
    private RoleRepository roleRepository;

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private ApplicationRepository applicationRepository;

    // 1. Trang Dashboard
    @GetMapping("/recruiter/dashboard")
    public String showRecruiterDashboard(Model model, Principal principal) {
        if (principal != null) {
            User user = userRepository.findByEmail(principal.getName());
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
        }
        return "recruiter/dashboard";
    }

    // 2. Logic Xóa công việc
    @GetMapping("/recruiter/delete-job/{id}")
    public String deleteJob(@PathVariable("id") Long id, Principal principal, RedirectAttributes ra) {
        Job job = jobRepository.findById(id).orElse(null);

        // Bảo mật: Kiểm tra quyền sở hữu
        if (job != null && job.getUser().getEmail().equals(principal.getName())) {
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
        Job job = jobRepository.findById(jobId).orElse(null);

        if (job == null || !job.getUser().getEmail().equals(principal.getName())) {
            return "redirect:/recruiter/dashboard?error=access_denied";
        }

        model.addAttribute("job", job);
        model.addAttribute("applications", job.getApplications());
        return "recruiter/job-candidates";
    }

    @GetMapping("/recruiter/register-company")
    public String showRegisterCompanyForm() {
        return "recruiter/register-company"; // Trỏ về file JSP vừa tạo
    }

    @PostMapping("/recruiter/register-company")
    public String processRegisterCompany(
            @RequestParam("companyName") String companyName,
            @RequestParam("companyAddress") String companyAddress,
            @RequestParam("description") String description,
            @RequestParam("logoFile") MultipartFile logoFile,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        try {
            // Bước 1: Lấy thông tin User hiện tại
            String email = principal.getName();
            User user = userRepository.findByEmail(email);

            // Bước 2: Xử lý file Logo
            String logoFileName = null;
            if (logoFile != null && !logoFile.isEmpty()) {
                // Tái sử dụng service lưu file của bạn
                logoFileName = uploadFileService.handleSaveUploadFile(logoFile, "company_logos");
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
            if (logoFileName != null) {
                companyProfile.setCompanyLogo(logoFileName); // Cập nhật logo nếu có
            }

            user.setCompanyProfile(companyProfile);

            // Bước 4: Cấp thêm quyền Nhà Tuyển Dụng (ROLE_RECRUITER)
            Role recruiterRole = roleRepository.findByName("ROLE_RECRUITER");
            if (recruiterRole != null && !user.getRoles().contains(recruiterRole)) {
                user.getRoles().add(recruiterRole);
            }

            // Lưu toàn bộ thông tin xuống Database
            userRepository.save(user);

            // ========================================================================
            // BƯỚC 5 (CỰC KỲ QUAN TRỌNG): LÀM MỚI PHIÊN ĐĂNG NHẬP CỦA SPRING SECURITY
            // ========================================================================
            // Lấy danh sách quyền MỚI NHẤT từ database
            Collection<GrantedAuthority> newAuthorities = user.getRoles().stream()
                    .map(role -> new SimpleGrantedAuthority(role.getName()))
                    .collect(Collectors.toList());

            // Lấy phiên đăng nhập cũ
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            // Tạo phiên đăng nhập mới với danh sách quyền đã được cộng thêm
            Authentication newAuth = new UsernamePasswordAuthenticationToken(
                    auth.getPrincipal(),
                    auth.getCredentials(),
                    newAuthorities);

            // Ép Spring Security nhận phiên đăng nhập mới
            SecurityContextHolder.getContext().setAuthentication(newAuth);
            // ========================================================================

            redirectAttributes.addFlashAttribute("successMsg",
                    "Chúc mừng! Tài khoản của bạn đã được nâng cấp thành Nhà Tuyển Dụng.");
            return "redirect:/recruiter/dashboard";

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMsg", "Có lỗi xảy ra khi lưu thông tin công ty!");
            return "redirect:/recruiter/register-company";
        }
    }

    // 2. Mở trang Form Đăng tin tuyển dụng
    // MỞ TRANG FORM ĐĂNG TIN TUYỂN DỤNG (CÓ TRUYỀN DỮ LIỆU ĐỂ PRE-FILL)
    @GetMapping("/recruiter/job/add")
    public String showAddJobForm(Model model, Principal principal) {
        // Lấy thông tin user hiện tại
        User user = userRepository.findByEmail(principal.getName());

        // Truyền hồ sơ công ty ra giao diện để tự động điền
        if (user.getCompanyProfile() != null) {
            model.addAttribute("company", user.getCompanyProfile());
        }

        return "recruiter/add-job";
    }

    // XỬ LÝ LƯU HỒ SƠ VÀO DATABASE
    @PostMapping("/recruiter/job/save")
    public String saveJob(
            @ModelAttribute Job job,
            @RequestParam(value = "logoFile", required = false) MultipartFile file, // Chuyển thành required = false
                                                                                    // (Không bắt buộc)
            Principal principal,
            RedirectAttributes redirectAttributes) {

        String email = principal.getName();
        User currentUser = userRepository.findByEmail(email);
        job.setUser(currentUser);

        // Xử lý logo
        if (file != null && !file.isEmpty()) {
            // Nếu người dùng CHỌN FILE MỚI -> Lưu file mới
            String fileName = uploadFileService.handleSaveUploadFile(file, "job_logos");
            job.setLogo(fileName);
        } else {
            // Nếu ô Input báo "Không có tệp nào được chọn" (file.isEmpty())
            // -> Lấy logo mặc định từ Profile đã điền sẵn trong DB
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
        Application app = applicationRepository.findById(id).orElse(null);

        if (app != null && app.getJob().getUser().getEmail().equals(principal.getName())) {
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
        Job job = jobRepository.findById(id).orElse(null);

        // Bảo mật: Kiểm tra xem công việc có tồn tại và có đúng là của user đang đăng
        // nhập không
        if (job == null || !job.getUser().getEmail().equals(principal.getName())) {
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

        // Tìm lại công việc gốc trong Database
        Job existingJob = jobRepository.findById(formJob.getId()).orElse(null);

        // Bảo mật lớp thứ 2 khi Submit form
        if (existingJob != null && existingJob.getUser().getEmail().equals(principal.getName())) {

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
        Job job = jobRepository.findById(id).orElse(null);

        // Kiểm tra bảo mật: Phải đúng là công việc của user đang đăng nhập
        if (job != null && job.getUser().getEmail().equals(principal.getName())) {

            // Đảo ngược trạng thái hiện tại (Đang mở -> Đóng, Đang đóng -> Mở)
            job.setIsActive(!job.getIsActive());
            jobRepository.save(job);

            String statusText = job.getIsActive() ? "MỞ" : "ĐÓNG";
            redirectAttributes.addFlashAttribute("successMsg", "Đã " + statusText + " công việc: " + job.getTitle());
        } else {
            redirectAttributes.addFlashAttribute("errorMsg",
                    "Lỗi: Không tìm thấy công việc hoặc không có quyền thao tác!");
        }

        // Chuyển hướng về lại trang Quản lý công việc
        return "redirect:/recruiter/jobs";
    }

    @GetMapping("/recruiter/jobs")
    public String manageJobs(Model model, Principal principal) {
        if (principal != null) {
            User user = userRepository.findByEmail(principal.getName());

            // Lấy toàn bộ công việc và sắp xếp mới nhất lên đầu (Bạn có thể thêm phân trang
            // sau)
            List<Job> jobs = user.getJobs();
            // Giả sử có hàm sắp xếp ngược nếu bạn lấy list từ user
            Collections.reverse(jobs);

            model.addAttribute("jobs", jobs);
        }
        return "recruiter/manage-jobs"; // Trỏ tới file JSP mới
    }

}