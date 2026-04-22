package com.findjob_tt.findjob_tt.controller;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.CandidateProfile;
import com.findjob_tt.findjob_tt.model.CompanyProfile;
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

    @GetMapping("/login")
    public String showLoginForm() {
        return "auth/login";
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        return "auth/register";
    }

    @PostMapping("/register")
    public String processRegister(@ModelAttribute("registerDTO") RegisterDTO registerDTO,
            @RequestParam(value = "roleName", defaultValue = "ROLE_CANDIDATE") String roleName,
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
        user.setAuthType(User.AuthType.LOCAL);
        user.setCreatedAt(LocalDateTime.now());

        // Tìm quyền
        Role userRole = roleRepository.findByName(roleName);
        if (userRole == null) {
            userRole = roleRepository.findByName("ROLE_CANDIDATE"); // Backup
        }

        // Gắn quyền (Sử dụng Set vì là ManyToMany)
        user.getRoles().add(userRole);

        // Khởi tạo Profile tương ứng dựa vào Role
        if (userRole.getName().equals("ROLE_CANDIDATE")) {
            CandidateProfile candidateProfile = new CandidateProfile();
            candidateProfile.setUser(user);
            user.setCandidateProfile(candidateProfile);
        } else if (userRole.getName().equals("ROLE_RECRUITER")) {
            CompanyProfile companyProfile = new CompanyProfile();
            companyProfile.setUser(user);
            user.setCompanyProfile(companyProfile);
        }

        userRepository.save(user);

        redirectAttributes.addFlashAttribute("successMsg", "Tạo tài khoản thành công! Vui lòng đăng nhập.");
        return "redirect:/login";
    }
}