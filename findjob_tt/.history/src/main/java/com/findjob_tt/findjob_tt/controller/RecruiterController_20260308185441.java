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

import java.time.LocalDateTime;
import java.util.List;

@Controller
public class RecruiterController {

    @Autowired
    private ApplicationRepository applicationRepository;

    // Khai báo thêm 2 công cụ này
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

    // 2. MỞ FORM THÊM MỚI HỒ SƠ
    @GetMapping("/recruiter/application/add")
    public String showAddApplicationForm(Model model) {
        // Lấy danh sách Công việc để HR chọn xem ứng viên nộp vào vị trí nào
        List<Job> jobs = jobRepository.findAll();
        model.addAttribute("jobs", jobs);

        return "recruiter/add-application"; // Gọi file JSP
    }

    // 3. XỬ LÝ LƯU HỒ SƠ VÀO DATABASE
    @PostMapping("/recruiter/application/save")
    public String saveApplication(
            @RequestParam("candidateName") String candidateName,
            @RequestParam("candidateEmail") String candidateEmail,
            @RequestParam("jobId") Long jobId,
            @RequestParam("cvFile") MultipartFile cvFile,
            RedirectAttributes redirectAttributes) {

        Job job = jobRepository.findById(jobId).orElse(null);
        if (job == null) {
            redirectAttributes.addFlashAttribute("errorMsg", "Công việc không tồn tại!");
            return "redirect:/recruiter/application/add";
        }

        // Tái sử dụng lại hàm lưu file tuyệt đỉnh của bạn
        String savedFileName = uploadFileService.handleSaveUploadFile(cvFile, "cv");

        if (!savedFileName.isEmpty()) {
            Application app = new Application();
            app.setCandidateName(candidateName);
            app.setCandidateEmail(candidateEmail);
            app.setCvFileName(savedFileName);
            app.setApplyDate(LocalDateTime.now());
            app.setJob(job);

            applicationRepository.save(app);

            // Báo thành công và đá về trang Dashboard
            redirectAttributes.addFlashAttribute("successMsg",
                    "Đã thêm hồ sơ ứng viên " + candidateName + " thành công!");
            return "redirect:/recruiter/dashboard";
        } else {
            redirectAttributes.addFlashAttribute("errorMsg", "Lỗi tải file CV. Vui lòng kiểm tra lại!");
            return "redirect:/recruiter/application/add";
        }
    }
}