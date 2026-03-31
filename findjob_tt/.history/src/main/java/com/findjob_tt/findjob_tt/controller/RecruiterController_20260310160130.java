package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.service.UploadFileService;

import java.util.List;

@Controller
public class RecruiterController {

    @Autowired
    private ApplicationRepository applicationRepository;

    @Autowired
    private JobRepository jobRepository;

    @Autowired
    private UploadFileService uploadFileService;

    // 1. Trang Bảng điều khiển (Đã làm ở bước trước)
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
            RedirectAttributes redirectAttributes) {

        // 1. Xử lý lưu file logo nếu có
        if (file != null && !file.isEmpty()) {
            String logoFileName = uploadFileService.handleSaveUploadFile(file, "job_logos");
            job.setLogo(logoFileName); // Gắn thẳng tên file vào Job
        }

        // 2. Lưu thẳng Job vào Database (Lúc này Job sẽ mang theo companyName và logo)
        jobRepository.save(job);

        redirectAttributes.addFlashAttribute("successMsg", "Đăng tin thành công!");
        return "redirect:/recruiter/dashboard";
    }
}