package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.repository.UserRepository;

@Controller
public class AuthController {

    @Autowired
    private UserRepository userRepository;

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
    public String processRegister(@ModelAttribute("user") User user, RedirectAttributes redirectAttributes) {

        // Kiểm tra xem Email đã có ai đăng ký chưa
        if (userRepository.findByEmail(user.getEmail()) != null) {
            redirectAttributes.addFlashAttribute("errorMsg", "Email này đã được sử dụng! Vui lòng chọn email khác.");
            return "redirect:/register";
        }

        // Mã hóa mật khẩu trước khi lưu xuống Database để bảo mật
        String encodedPassword = passwordEncoder.encode(user.getPassword());
        user.setPassword(encodedPassword);

        // LƯU Ý VỀ ROLE:
        // Hiện tại tạm thời lưu user. Việc set Role (ROLE_CANDIDATE hay ROLE_RECRUITER)
        // sẽ phụ thuộc vào việc bạn thiết kế bảng Role như thế nào. Mình sẽ hướng dẫn
        // bổ sung sau.

        userRepository.save(user);

        redirectAttributes.addFlashAttribute("successMsg", "Tạo tài khoản thành công! Vui lòng đăng nhập.");
        return "redirect:/login";
    }
}