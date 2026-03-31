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
import com.findjob_tt.findjob_tt.service.UploadFileService; // Dùng Service mới

import java.security.Principal;
import java.time.LocalDateTime;

@Controller
public class ApplicationController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UploadFileService uploadFileService; // Inject Service mới

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
            // Logic: Nếu file trống -> lấy cvUrl từ profile
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

            // ... Code lưu Application vào Database ...

            ra.addFlashAttribute("successMsg", "Ứng tuyển thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Lỗi hệ thống, vui lòng thử lại!");
        }
        return "redirect:/job/" + jobId;
    }
}