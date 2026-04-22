package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository;
import com.findjob_tt.findjob_tt.service.UploadFileService;

import java.security.Principal;

@Controller
public class ApplicationController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JobRepository jobRepository;

    @Autowired
    private ApplicationRepository applicationRepository; // Cần cái này để lưu vào DB

    @Autowired
    private UploadFileService uploadFileService;

    @PostMapping("/apply")
    public String handleApply(
            @RequestParam("jobId") Long jobId,
            @RequestParam("candidateName") String name,
            @RequestParam("candidateEmail") String email,
            @RequestParam("cvFile") MultipartFile file,
            Principal principal,
            RedirectAttributes ra) {

        try {
            User user = userRepository.findByEmail(principal.getName());

            // Tìm Job đang ứng tuyển
            Job job = jobRepository.findById(jobId).orElse(null);
            if (job == null) {
                ra.addFlashAttribute("errorMsg", "Công việc không tồn tại!");
                return "redirect:/";
            }

            // Logic lấy CV
            String finalCvName = "";
            if (file != null && !file.isEmpty()) {
                finalCvName = uploadFileService.handleSaveUploadFile(file, "cv_files");
            } else if (user.getCandidateProfile() != null) {
                finalCvName = user.getCandidateProfile().getCvUrl();
            }

            if (finalCvName == null || finalCvName.isEmpty()) {
                ra.addFlashAttribute("errorMsg", "Vui lòng tải lên CV để ứng tuyển!");
                return "redirect:/job/" + jobId;
            }

            // ==========================================
            // CODE LƯU DỮ LIỆU THỰC TẾ Ở ĐÂY
            // ==========================================
            Application application = new Application();
            application.setJob(job);
            application.setUser(user);
            application.setCvFileName(finalCvName);

            applicationRepository.save(application); // Lệnh chốt hạ để dữ liệu vào DB
            // ==========================================

            ra.addFlashAttribute("successMsg", "Ứng tuyển thành công!");
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra log để bạn dễ theo dõi
            ra.addFlashAttribute("errorMsg", "Lỗi hệ thống: " + e.getMessage());
        }
        return "redirect:/job/" + jobId;
    }
}