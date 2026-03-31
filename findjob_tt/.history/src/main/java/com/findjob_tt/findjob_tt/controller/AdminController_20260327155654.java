package com.findjob_tt.findjob_tt.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.session.SessionInformation;
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

    @Autowired
    private org.springframework.security.core.session.SessionRegistry sessionRegistry;

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

        User currentAdmin = userRepository.findByEmail(principal.getName());
        User targetUser = userRepository.findById(id).orElse(null);

        if (targetUser != null) {
            if (targetUser.getId().equals(currentAdmin.getId())) {
                redirectAttributes.addFlashAttribute("errorMsg", "Bạn không thể tự khóa tài khoản của chính mình!");
                return "redirect:/admin/users";
            }

            // Đảo trạng thái và lưu DB
            targetUser.setActive(!targetUser.isActive());
            userRepository.save(targetUser);

            // ĐOẠN CODE "ĐUỔI THẲNG CỔ" NẰM Ở ĐÂY
            if (!targetUser.isActive()) { // Nếu hành động vừa rồi là KHÓA

                // Quét toàn bộ những người đang online
                List<Object> loggedInUsers = sessionRegistry.getAllPrincipals();

                for (Object loggedUser : loggedInUsers) {
                    // Ép kiểu về User của Spring Security
                    if (loggedUser instanceof org.springframework.security.core.userdetails.User) {
                        org.springframework.security.core.userdetails.User springUser = (org.springframework.security.core.userdetails.User) loggedUser;

                        // Nếu email của người đang online khớp với email của kẻ bị khóa
                        if (springUser.getUsername().equals(targetUser.getEmail())) {

                            // Lấy tất cả các thẻ qua cửa (Session) của người này
                            List<SessionInformation> sessions = sessionRegistry.getAllSessions(loggedUser, false);
                            for (SessionInformation session : sessions) {
                                // HỦY DIỆT SESSION NGAY LẬP TỨC!
                                session.expireNow();
                            }
                        }
                    }
                }
            }
            // ====================================================

            String action = targetUser.isActive() ? "Mở khóa" : "Khóa";
            redirectAttributes.addFlashAttribute("successMsg", "Đã " + action + " tài khoản: " + targetUser.getEmail());
        }

        return "redirect:/admin/users";
    }
}