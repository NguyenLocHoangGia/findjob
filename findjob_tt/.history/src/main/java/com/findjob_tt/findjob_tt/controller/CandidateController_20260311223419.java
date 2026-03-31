package com.findjob_tt.findjob_tt.controller;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.model.dto.CandidateProfileDTO;
import com.findjob_tt.findjob_tt.repository.UserRepository;

@Controller
@RequestMapping("/candidate")
public class CandidateController {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/profile")
    public String showProfileForm(Model model, Principal principal) {
        String email = principal.getName();
        User user = userRepository.findByEmail(email);

        System.out.println("=== TÊN FILE ẢNH TRONG DB LÀ: " + user.getImg() + " ===");

        CandidateProfileDTO dto = new CandidateProfileDTO();
        dto.setFullName(user.getFullName());
        dto.setPhone(user.getPhone());
        dto.setAddress(user.getAddress());
        dto.setDescription(user.getDescription());
        dto.setExistingImg(user.getImg()); // Lấy file cũ hiển thị
        dto.setExistingCv(user.getCv()); // Lấy file cũ hiển thị

        model.addAttribute("candidateProfileDTO", dto);
        model.addAttribute("userEmail", email);

        return "candidate/profile";
    }

    @PostMapping("/verify-password")
    @ResponseBody // Hàm này trả về dữ liệu chữ thay vì trả về giao diện JSP
    public ResponseEntity<String> verifyPassword(@RequestParam("password") String password, Principal principal) {
        User user = userRepository.findByEmail(principal.getName());

        // So sánh mật khẩu nhập vào (chưa mã hóa) với mật khẩu trong DB (đã mã hóa)
        if (passwordEncoder.matches(password, user.getPassword())) {
            return ResponseEntity.ok("OK"); // Đúng mật khẩu
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Sai mật khẩu"); // Sai mật khẩu
        }
    }

    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute("candidateProfileDTO") CandidateProfileDTO dto,
            Principal principal, RedirectAttributes redirectAttributes) {
        try {
            User user = userRepository.findByEmail(principal.getName());

            // 1. Cập nhật thông tin chữ
            user.setFullName(dto.getFullName());
            user.setPhone(dto.getPhone());
            user.setAddress(dto.getAddress());
            user.setDescription(dto.getDescription());

            // 2. Xử lý lưu Ảnh đại diện (Avatar)
            MultipartFile avatarFile = dto.getAvatarFile();
            if (avatarFile != null && !avatarFile.isEmpty()) {
                String fileName = StringUtils.cleanPath(avatarFile.getOriginalFilename());
                // Thêm thời gian vào tên file để tránh trùng lặp
                fileName = System.currentTimeMillis() + "_" + fileName;
                saveFile("uploads/avatars", fileName, avatarFile);
                user.setImg(fileName); // Lưu tên file vào DB
            }

            // 3. Xử lý lưu CV
            MultipartFile cvFile = dto.getCvFile();
            if (cvFile != null && !cvFile.isEmpty()) {
                String fileName = StringUtils.cleanPath(cvFile.getOriginalFilename());
                fileName = System.currentTimeMillis() + "_" + fileName;
                saveFile("uploads/cvs", fileName, cvFile);
                user.setCv(fileName); // Lưu tên file vào DB
            }

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
        // Nếu thư mục chưa có thì tự động tạo
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        try (InputStream inputStream = multipartFile.getInputStream()) {
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
    }
}