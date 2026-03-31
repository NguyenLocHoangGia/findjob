package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import java.util.List;

@Controller
public class RecruiterController {

    @Autowired
    private ApplicationRepository applicationRepository;

    @GetMapping("/recruiter/dashboard")
    public String showDashboard(Model model) {
        // Lấy toàn bộ hồ sơ ứng viên (mới nhất xếp trên cùng)
        // Trong thực tế, bạn sẽ lọc theo ID của Nhà tuyển dụng đang đăng nhập
        List<Application> applications = applicationRepository.findAll();

        model.addAttribute("applications", applications);

        return "recruiter/dashboard";
    }
}