package com.findjob_tt.findjob_tt.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository;

@Controller
@RequestMapping("/admin") // Đặt tiền tố /admin cho tất cả các đường dẫn trong file này
public class AdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JobRepository jobRepository;

    @Autowired
    private ApplicationRepository applicationRepository;

    @GetMapping("/dashboard")
    public String showAdminDashboard(Model model) {

        // Sử dụng hàm .count() có sẵn của JPA để đếm số lượng dữ liệu
        long totalUsers = userRepository.count();
        long totalJobs = jobRepository.count();
        long totalApplications = applicationRepository.count();

        // Đẩy các con số này sang giao diện JSP
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalJobs", totalJobs);
        model.addAttribute("totalApplications", totalApplications);

        return "admin/dashboard"; // Trỏ tới file JSP của Admin
    }

    // Thêm hàm lấy danh sách người dùng
    @GetMapping("/users")
    public String manageUsers(Model model) {
        List<User> allUsers = userRepository.findAll();
        model.addAttribute("users", allUsers);
        return "admin/manage-users";
    }

    @GetMapping("/users/toggle-status/{id}")
    public String toggleUserStatus(@PathVariable("id") Long id, Principal principal,
            RedirectAttributes redirectAttributes) {

        // Lấy Admin đang thao tác
        User currentAdmin = userRepository.findByEmail(principal.getName());

        // Tìm User cần khóa/mở khóa
        User targetUser = userRepository.findById(id).orElse(null);

        if (targetUser != null) {
            // Ngăn chặn Admin tự khóa tài khoản của chính mình
            if (targetUser.getId().equals(currentAdmin.getId())) {
                redirectAttributes.addFlashAttribute("errorMsg", "Bạn không thể tự khóa tài khoản của chính mình!");
                return "redirect:/admin/users";
            }

            // Đảo ngược trạng thái: Nếu đang true -> false (Khóa), Nếu đang false -> true
            // (Mở)
            targetUser.setActive(!targetUser.isActive());
            userRepository.save(targetUser);

            String action = targetUser.isActive() ? "Mở khóa" : "Khóa";
            redirectAttributes.addFlashAttribute("successMsg", "Đã " + action + " tài khoản: " + targetUser.getEmail());
        }

        return "redirect:/admin/users";
    }
}