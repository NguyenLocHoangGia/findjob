package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

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
}