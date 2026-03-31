package com.findjob_tt.findjob_tt.controller;

import java.security.Principal; // THÊM IMPORT NÀY
import java.util.Collection;
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
import com.findjob_tt.findjob_tt.model.Role;
import com.findjob_tt.findjob_tt.model.User; // THÊM IMPORT NÀY
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.RoleRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository; // THÊM IMPORT NÀY
import com.findjob_tt.findjob_tt.service.UploadFileService;

@Controller
public class RecruiterController {

    @Autowired
    private ApplicationRepository applicationRepository;

    @Autowired
    private JobRepository jobRepository;

    // 1. THÊM REPOSITORY CỦA USER ĐỂ TÌM KIẾM NGƯỜI ĐĂNG NHẬP
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UploadFileService uploadFileService;

    @Autowired
    private RoleRepository roleRepository;

    // 1. Trang Bảng điều khiển
    @GetMapping("/recruiter/dashboard")
    public String showDashboard(Model model) {
        List<Application> applications = applicationRepository.findAll();
        model.addAttribute("applications", applications);
        return "recruiter/dashboard";
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
    @GetMapping("/recruiter/job/add")
    public String showAddJobForm() {
        return "recruiter/add-job";
    }

    // 3. XỬ LÝ LƯU HỒ SƠ VÀO DATABASE
    @PostMapping("/recruiter/job/save")
    public String saveJob(
            @ModelAttribute Job job,
            @RequestParam("logoFile") MultipartFile file,
            Principal principal, // 2. THÊM PRINCIPAL VÀO ĐÂY ĐỂ BIẾT AI ĐANG ĐĂNG TIN
            RedirectAttributes redirectAttributes) {

        // Bước 1: Tìm xem ai đang đăng nhập dựa vào email
        String email = principal.getName();
        User currentUser = userRepository.findByEmail(email);

        // Bước 2: Gắn user này làm "chủ sở hữu" của tin tuyển dụng
        // (Lưu ý: Tùy vào việc trong class Job.java bạn đặt tên biến liên kết là gì.
        // Thường là setUser hoặc setRecruiter. Mình đang để mặc định là setUser nhé).
        job.setUser(currentUser);

        // Bước 3: Xử lý lưu file logo nếu có
        if (file != null && !file.isEmpty()) {
            String logoFileName = uploadFileService.handleSaveUploadFile(file, "job_logos");
            job.setLogo(logoFileName); // Gắn thẳng tên file vào Job
        }

        // Bước 4: Lưu Job vào Database (Lúc này Job đã mang theo user_id)
        jobRepository.save(job);

        redirectAttributes.addFlashAttribute("successMsg", "Đăng tin thành công!");
        return "redirect:/recruiter/dashboard";
    }

    // Trạm trung chuyển khi user bấm nút "Nhà tuyển dụng" trên Header
    @GetMapping("/switch-to-recruiter")
    public String switchToRecruiter(Principal principal) {
        if (principal == null) {
            return "redirect:/login"; // Chưa đăng nhập thì đuổi ra trang login
        }

        User user = userRepository.findByEmail(principal.getName());

        // Kiểm tra xem User này đã có cái mác "ROLE_RECRUITER" trong người chưa?
        boolean isRecruiter = user.getRoles().stream()
                .anyMatch(role -> role.getName().equals("ROLE_RECRUITER"));

        if (isRecruiter) {
            // Đã là HR rồi -> Cho thẳng vào Dashboard
            return "redirect:/recruiter/dashboard";
        } else {
            // Chưa là HR (Tức là Candidate muốn nâng cấp)
            // -> Dẫn sang trang yêu cầu khai báo thông tin Công ty
            return "redirect:/recruiter/register-company";
        }
    }
}