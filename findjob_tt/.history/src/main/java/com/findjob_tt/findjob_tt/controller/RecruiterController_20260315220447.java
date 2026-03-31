package com.findjob_tt.findjob_tt.controller;

import java.security.Principal; // THÊM IMPORT NÀY
import java.util.Collection;
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

import com.findjob_tt.findjob_tt.model.CompanyProfile;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.Role;
import com.findjob_tt.findjob_tt.model.User; // THÊM IMPORT NÀY
import com.findjob_tt.findjob_tt.repository.JobRepository;
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

    // 1. Trang Dashboard
    @GetMapping("/recruiter/dashboard")
    public String showRecruiterDashboard(Model model, Principal principal) {
        if (principal != null) {
            User user = userRepository.findByEmail(principal.getName());
            model.addAttribute("userFullName", user.getFullName());
            // Lấy danh sách từ quan hệ đã thiết lập trong model
            model.addAttribute("jobs", user.getJobs());
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

}