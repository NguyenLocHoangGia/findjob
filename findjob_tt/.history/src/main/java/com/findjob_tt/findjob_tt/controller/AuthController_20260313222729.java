package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
            @RequestParam(value = "roleName", defaultValue = "ROLE_CANDIDATE") String roleName, // Bắt giá trị từ Radio
                                                                                                // button
            RedirectAttributes redirectAttributes) {

        // 1. Kiểm tra mật khẩu
        if (!registerDTO.getPassword().equals(registerDTO.getConfirmPassword())) {
            redirectAttributes.addFlashAttribute("errorMsg", "Mật khẩu xác nhận không khớp!");
            return "redirect:/register";
        }

        // 2. Kiểm tra email trùng
        if (userRepository.findByEmail(registerDTO.getEmail()) != null) {
            redirectAttributes.addFlashAttribute("errorMsg", "Email này đã được sử dụng!");
            return "redirect:/register";
        }

        // 3. Tạo User mới
        User user = new User();
        user.setFullName(registerDTO.getFullName());
        user.setEmail(registerDTO.getEmail());
        user.setPassword(passwordEncoder.encode(registerDTO.getPassword()));

        // Tìm quyền trong DB dựa trên lựa chọn của người dùng (ROLE_CANDIDATE hoặc
        // ROLE_RECRUITER)
        Role userRole = roleRepository.findByName(roleName);

        if (userRole != null) {
            user.setRole(userRole); // Gắn đúng quyền họ chọn
        } else {
            // Backup an toàn: Nếu có lỗi không tìm thấy quyền, mặc định cho làm Ứng viên
            Role defaultRole = roleRepository.findByName("ROLE_CANDIDATE");
            user.setRole(defaultRole);
        }

        // 4. Lưu vào Database
        userRepository.save(user);

        redirectAttributes.addFlashAttribute("successMsg", "Tạo tài khoản thành công! Vui lòng đăng nhập.");
        return "redirect:/login";
    }
}