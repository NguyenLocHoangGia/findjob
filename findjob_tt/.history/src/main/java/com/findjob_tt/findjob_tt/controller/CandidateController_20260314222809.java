package com.findjob_tt.findjob_tt.controller;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.CandidateProfile;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.model.dto.CandidateProfileDTO;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository;

@Controller
@RequestMapping("/candidate")
public class CandidateController {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private JobRepository jobRepository;

    @GetMapping("/profile")
    public String showProfileForm(Model model, Principal principal) {
        String email = principal.getName();
        User user = userRepository.findByEmail(email);

        CandidateProfileDTO dto = new CandidateProfileDTO();
        // Thông tin cơ bản từ User
        dto.setFullName(user.getFullName());
        dto.setPhone(user.getPhone());
        dto.setExistingImg(user.getAvatar());

        // Thông tin chuyên sâu từ CandidateProfile
        CandidateProfile profile = user.getCandidateProfile();
        if (profile != null) {
            dto.setAddress(profile.getAddress());
            dto.setDescription(profile.getDescription());
            dto.setExistingCv(profile.getCvUrl());
        }

        model.addAttribute("candidateProfileDTO", dto);
        model.addAttribute("userEmail", email);

        return "candidate/profile";
    }

    @PostMapping("/verify-password")
    @ResponseBody
    public ResponseEntity<String> verifyPassword(@RequestParam("password") String password, Principal principal) {
        User user = userRepository.findByEmail(principal.getName());
        if (passwordEncoder.matches(password, user.getPassword())) {
            return ResponseEntity.ok("OK");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Sai mật khẩu");
        }
    }

    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute("candidateProfileDTO") CandidateProfileDTO dto,
            Principal principal, RedirectAttributes redirectAttributes) {
        try {
            User user = userRepository.findByEmail(principal.getName());

            // 1. Cập nhật thông tin chung ở bảng User
            user.setFullName(dto.getFullName());
            user.setPhone(dto.getPhone());

            // Xử lý lưu Ảnh đại diện (Avatar dùng chung)
            MultipartFile avatarFile = dto.getAvatarFile();
            if (avatarFile != null && !avatarFile.isEmpty()) {
                String fileName = StringUtils.cleanPath(avatarFile.getOriginalFilename());
                fileName = System.currentTimeMillis() + "_" + fileName;
                saveFile("uploads/avatars", fileName, avatarFile);
                user.setAvatar(fileName);
            }

            // 2. Cập nhật thông tin chuyên sâu ở bảng CandidateProfile
            CandidateProfile profile = user.getCandidateProfile();
            if (profile == null) {
                profile = new CandidateProfile();
                profile.setUser(user); // Móc nối về User
            }
            profile.setAddress(dto.getAddress());
            profile.setDescription(dto.getDescription());

            // Xử lý lưu CV
            MultipartFile cvFile = dto.getCvFile();
            if (cvFile != null && !cvFile.isEmpty()) {
                String fileName = StringUtils.cleanPath(cvFile.getOriginalFilename());
                fileName = System.currentTimeMillis() + "_" + fileName;
                saveFile("uploads/cvs", fileName, cvFile);
                profile.setCvUrl(fileName);
            }

            // Gắn lại profile vào user và lưu User (vì CascadeType.ALL, nó sẽ lưu luôn
            // Profile)
            user.setCandidateProfile(profile);
            userRepository.save(user);

            redirectAttributes.addFlashAttribute("successMsg", "Cập nhật hồ sơ thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMsg", "Có lỗi xảy ra khi lưu file!");
        }

        return "redirect:/candidate/profile";
    }

    // --- HÀM HỖ TRỢ LƯU FILE XUỐNG Ổ CỨNG ---
    private void saveFile(String uploadDir, String fileName, MultipartFile multipartFile) throws Exception {
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        try (InputStream inputStream = multipartFile.getInputStream()) {
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
    }

    @PostMapping("/api/toggle-save-job")
    @ResponseBody
    public ResponseEntity<String> toggleSaveJob(@RequestParam("jobId") Long jobId, Principal principal) {
        if (principal == null)
            return ResponseEntity.status(401).body("Chưa đăng nhập");
        User user = userRepository.findByEmail(principal.getName());
        List<Long> items = user.getSavedItems();
        boolean isAlreadySaved = items.contains(jobId);
        if (isAlreadySaved) {
            items.remove(jobId);
        } else {
            items.add(jobId);
        }
        userRepository.save(user);
        return ResponseEntity.ok(isAlreadySaved ? "removed" : "added");
    }

    @GetMapping("/saved-jobs")
    public String showSavedJobs(Model model, Principal principal) {
        User user = userRepository.findByEmail(principal.getName());
        List<Job> jobs = jobRepository.findAllById(user.getSavedItems());
        model.addAttribute("savedJobsList", jobs);
        return "candidate/saved-jobs";
    }

    @GetMapping("/job/{id}")
    public String showJobDetail(@PathVariable("id") Long id, Model model, Principal principal) {
        // 1. Tìm công việc theo ID
        Job job = jobRepository.findById(id).orElse(null);
        model.addAttribute("job", job);

        // 2. Nếu đã đăng nhập, lấy thông tin Profile để Pre-fill
        if (principal != null) {
            String email = principal.getName();
            User currentUser = userRepository.findByEmail(email);

            if (currentUser != null) {
                // Truyền Email tài khoản
                model.addAttribute("userEmail", currentUser.getEmail());

                // Truyền thông tin Profile (Họ tên, CV cũ...)
                if (currentUser.getCandidateProfile() != null) {
                    model.addAttribute("candidate", currentUser.getCandidateProfile());
                }
            }
        }

        // Trỏ đúng về file JSP của bạn
        return "candidate/job-detail";
    }
}