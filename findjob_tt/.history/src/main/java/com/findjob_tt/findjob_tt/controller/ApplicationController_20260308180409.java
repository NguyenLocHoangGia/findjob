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
import com.findjob_tt.findjob_tt.service.UploadFileService; // Dùng Service mới

import java.time.LocalDateTime;

@Controller
public class ApplicationController {

    @Autowired
    private ApplicationRepository applicationRepository;
    @Autowired
    private JobRepository jobRepository;

    @Autowired
    private UploadFileService uploadFileService; // Inject Service mới

    @PostMapping("/apply")
    public String applyJob(@RequestParam("jobId") Long jobId,
            @RequestParam("candidateName") String candidateName,
            @RequestParam("candidateEmail") String candidateEmail,
            @RequestParam("cvFile") MultipartFile cvFile,
            RedirectAttributes redirectAttributes) {

        Job job = jobRepository.findById(jobId).orElse(null);
        if (job == null)
            return "redirect:/";

        // GỌI HÀM VỚI THAM SỐ "cv" ĐỂ NÓ LƯU VÀO THƯ MỤC uploads/cv
        String savedFileName = uploadFileService.handleSaveUploadFile(cvFile, "cv");

        // Kiểm tra xem chuỗi trả về có rỗng hay không
        if (!savedFileName.isEmpty()) {
            Application application = new Application();
            application.setCandidateName(candidateName);
            application.setCandidateEmail(candidateEmail);
            application.setCvFileName(savedFileName);
            application.setApplyDate(LocalDateTime.now());
            application.setJob(job);

            applicationRepository.save(application);

            redirectAttributes.addFlashAttribute("successMsg",
                    "Ứng tuyển thành công! Nhà tuyển dụng sẽ sớm liên hệ với bạn.");
        } else {
            redirectAttributes.addFlashAttribute("errorMsg", "Lỗi tải file CV. Vui lòng thử lại!");
        }

        return "redirect:/job/" + jobId;
    }
}