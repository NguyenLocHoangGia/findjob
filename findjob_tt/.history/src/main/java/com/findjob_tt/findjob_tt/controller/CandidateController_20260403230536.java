package com.findjob_tt.findjob_tt.controller;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.model.CandidateProfile;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.Notification;
import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.model.dto.CandidateProfileDTO;
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.NotificationRepository;
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
    @Autowired
    private NotificationRepository notificationRepository;
    @Autowired
    private ApplicationRepository applicationRepository;

    // ==========================================
    // [HÀM BẢO BỐI]: Tự động lấy đúng Email cho cả Google Login và Form Login
    // ==========================================
    private String getEmailFromPrincipal(Principal principal) {
        if (principal instanceof OAuth2AuthenticationToken) {
            OAuth2AuthenticationToken oauthToken = (OAuth2AuthenticationToken) principal;
            OAuth2User oauth2User = oauthToken.getPrincipal();
            return oauth2User.getAttribute("email");
        }
        return principal.getName();
    }

    // Hồ sơ hoàn chỉnh để được ứng tuyển: họ tên, số điện thoại, địa chỉ, mô tả và CV
    private boolean isProfileCompleted(User user) {
        if (user == null) {
            return false;
        }

        CandidateProfile profile = user.getCandidateProfile();
        return StringUtils.hasText(user.getFullName())
                && StringUtils.hasText(user.getPhone())
                && profile != null
                && StringUtils.hasText(profile.getAddress())
                && StringUtils.hasText(profile.getDescription())
                && StringUtils.hasText(profile.getCvUrl());
    }

    @GetMapping("/profile")
    public String showProfileForm(Model model, Principal principal) {
        // Dùng hàm bảo bối thay vì principal.getName()
        String email = getEmailFromPrincipal(principal);
        User user = userRepository.findByEmail(email);

        // Check an toàn để không bao giờ bị lỗi 500 nữa
        if (user == null) {
            return "redirect:/login";
        }

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
        String email = getEmailFromPrincipal(principal);
        User user = userRepository.findByEmail(email);

        if (user.getPassword() == null || user.getPassword().isBlank()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Tài khoản này không có mật khẩu local");
        }
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
            String email = getEmailFromPrincipal(principal);
            User user = userRepository.findByEmail(email);

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
                saveFile("uploads/cv_files", fileName, cvFile);
                profile.setCvUrl(fileName);
            }

            // Gắn lại profile vào user và lưu User
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

        String email = getEmailFromPrincipal(principal);
        User user = userRepository.findByEmail(email);
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
        String email = getEmailFromPrincipal(principal);
        User user = userRepository.findByEmail(email);
        List<Job> jobs = jobRepository.findAllById(user.getSavedItems());
        model.addAttribute("savedJobsList", jobs);
        return "candidate/saved-jobs";
    }

    @GetMapping("/notifications")
    public String showNotifications(Model model, Principal principal) {
        String email = getEmailFromPrincipal(principal);
        User user = userRepository.findByEmail(email);
        // Lấy thông báo mới nhất xếp trên đầu
        List<Notification> notes = notificationRepository.findByUserOrderByCreatedAtDesc(user);
        // Đánh dấu tất cả là đã đọc khi người dùng truy cập vào trang này
        notes.forEach(n -> {
            if (!n.isRead()) {
                n.setRead(true);
            }
        });
        notificationRepository.saveAll(notes); // Lưu lại trạng thái đã đọc
        model.addAttribute("notifications", notes);
        return "candidate/notifications";
    }

    @PostMapping("/api/delete-notification")
    @ResponseBody
    public ResponseEntity<String> deleteNotification(@RequestParam("id") Long id, Principal principal) {
        try {
            Notification notification = notificationRepository.findById(id).orElse(null);
            String currentEmail = getEmailFromPrincipal(principal);

            // Bảo mật: Kiểm tra xem thông báo có tồn tại và đúng là của user đang đăng nhập
            if (notification != null && notification.getUser().getEmail().equals(currentEmail)) {
                notificationRepository.delete(notification);
                return ResponseEntity.ok("Đã xóa thông báo thành công");
            }

            return ResponseEntity.badRequest().body("Thông báo không tồn tại hoặc bạn không có quyền xóa");

        } catch (Exception e) {
            System.out.println("LỖI KHI XÓA THÔNG BÁO: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Lỗi máy chủ cục bộ");
        }
    }

    @PostMapping("/apply")
    public String applyJob(@RequestParam Long jobId, Principal principal, RedirectAttributes ra) {
        String email = getEmailFromPrincipal(principal);
        User user = userRepository.findByEmail(email);
        Job job = jobRepository.findById(jobId).orElse(null);

        if (job == null) {
            ra.addFlashAttribute("errorMsg", "Công việc không tồn tại hoặc đã bị gỡ.");
            return "redirect:/home";
        }

        if (!isProfileCompleted(user)) {
            ra.addFlashAttribute("errorMsg",
                    "Vui lòng cập nhật đầy đủ hồ sơ cá nhân (Họ tên, SĐT, Địa chỉ, Giới thiệu, CV) tại trang Hồ sơ trước khi ứng tuyển.");
            return "redirect:/job/" + jobId;
        }

        // LOGIC CHẶN SPAM:
        boolean alreadyApplied = applicationRepository.existsByUserAndJobAndStatus(user, job, "PENDING");

        if (alreadyApplied) {
            ra.addFlashAttribute("errorMsg",
                    "Bạn đã ứng tuyển công việc này rồi. Vui lòng đợi phản hồi từ nhà tuyển dụng!");
            return "redirect:/job/" + jobId;
        }

        Application newApp = new Application();
        newApp.setUser(user);
        newApp.setJob(job);
        newApp.setStatus("PENDING");
        newApp.setCreatedAt(LocalDateTime.now());
        applicationRepository.save(newApp);

        ra.addFlashAttribute("successMsg", "Ứng tuyển thành công!");
        return "redirect:/job/" + jobId;
    }

    @GetMapping("/my-applications")
    public String viewMyApplications(Principal principal, Model model) {
        if (principal == null) {
            return "redirect:/login";
        }

        String email = getEmailFromPrincipal(principal);
        User currentUser = userRepository.findByEmail(email);

        if (currentUser != null) {
            // Lấy danh sách lịch sử ứng tuyển
            List<Application> applications = applicationRepository.findByUserOrderByCreatedAtDesc(currentUser);
            model.addAttribute("applications", applications);
        }

        return "candidate/my-applications";
    }
}