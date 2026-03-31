package com.findjob_tt.findjob_tt.controller;

import java.security.Principal; // THÊM IMPORT NÀY
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.User; // THÊM IMPORT NÀY
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
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

    // 1. Trang Bảng điều khiển
    @GetMapping("/recruiter/dashboard")
    public String showDashboard(Model model) {
        List<Application> applications = applicationRepository.findAll();
        model.addAttribute("applications", applications);
        return "recruiter/dashboard";
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