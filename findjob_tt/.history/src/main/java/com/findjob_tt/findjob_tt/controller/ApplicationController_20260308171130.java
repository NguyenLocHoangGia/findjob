package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.service.UploadService;

import java.time.LocalDateTime;

@Controller
public class ApplicationController {

    @Autowired
    private ApplicationRepository applicationRepository;
    @Autowired
    private JobRepository jobRepository;
    @Autowired
    private UploadService uploadService;

    // Hứng request POST từ giao diện khi người dùng bấm "Nộp CV"
    @PostMapping("/apply")
    public String applyJob(@RequestParam("jobId") Long jobId,
            @RequestParam("candidateName") String candidateName,
            @RequestParam("candidateEmail") String candidateEmail,
            @RequestParam("cvFile") MultipartFile cvFile,
            RedirectAttributes redirectAttributes) { // Dùng để gửi thông báo về giao diện

        // 1. Tìm công việc đang ứng tuyển
        Job job = jobRepository.findById(jobId).orElse(null);
        if (job == null)
            return "redirect:/";

        // 2. Lưu file CV vào ổ cứng
        String savedFileName = uploadService.saveCV(cvFile);

        // 3. Tạo Đơn ứng tuyển và lưu vào Database
        if (savedFileName != null) {
            Application application = new Application();
            application.setCandidateName(candidateName);
            application.setCandidateEmail(candidateEmail);
            application.setCvFileName(savedFileName);
            application.setApplyDate(LocalDateTime.now());
            application.setJob(job);

            applicationRepository.save(application);

            // Báo thành công
            redirectAttributes.addFlashAttribute("successMsg",
                    "Ứng tuyển thành công! Nhà tuyển dụng sẽ sớm liên hệ với bạn.");
        } else {
            redirectAttributes.addFlashAttribute("errorMsg", "Lỗi tải file CV. Vui lòng thử lại!");
        }

        // 4. Load lại trang chi tiết công việc đó
        return "redirect:/job/" + jobId;
    }
}