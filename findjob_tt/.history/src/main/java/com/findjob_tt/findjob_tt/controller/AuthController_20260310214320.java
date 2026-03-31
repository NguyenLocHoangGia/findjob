package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.Role;
import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.model.dto.RegisterDTO;
import com.findjob_tt.findjob_tt.repository.RoleRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository;

@Controller
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    // 1. Hiển thị trang Đăng nhập
    @GetMapping("/login")
    public String showLoginForm() {
        // Trỏ tới file /WEB-INF/view/auth/login.jsp
        return "auth/login";
    }

    // 2. Hiển thị trang Đăng ký
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        // Trỏ tới file /WEB-INF/view/auth/register.jsp
        return "auth/register";
    }

    // 3. Xử lý lưu thông tin Đăng ký vào Database
    @PostMapping("/register")
    public String processRegister(@ModelAttribute("registerDTO") RegisterDTO registerDTO,
            RedirectAttributes redirectAttributes) {

        if (!registerDTO.getPassword().equals(registerDTO.getConfirmPassword())) {
            redirectAttributes.addFlashAttribute("errorMsg", "Mật khẩu xác nhận không khớp!");
            return "redirect:/register";
        }

        if (userRepository.findByEmail(registerDTO.getEmail()) != null) {
            redirectAttributes.addFlashAttribute("errorMsg", "Email này đã được sử dụng!");
            return "redirect:/register";
        }

        User user = new User();
        user.setFullName(registerDTO.getFullName());
        user.setEmail(registerDTO.getEmail());
        user.setPassword(passwordEncoder.encode(registerDTO.getPassword()));

        // --- ĐÂY LÀ ĐOẠN QUAN TRỌNG NHẤT: CẤP QUYỀN MẶC ĐỊNH ---
        // Tìm quyền Ứng viên trong DB
        Role userRole = roleRepository.findByName("ROLE_CANDIDATE");
        if (userRole != null) {
            user.setRole(userRole); // Gắn quyền cho User
        }

        userRepository.save(user);

        redirectAttributes.addFlashAttribute("successMsg", "Tạo tài khoản thành công! Vui lòng đăng nhập.");
        return "redirect:/login";
    }
}