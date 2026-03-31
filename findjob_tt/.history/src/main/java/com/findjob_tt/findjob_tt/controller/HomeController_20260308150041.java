package com.findjob_tt.findjob_tt.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String showCandidateHomepage(Model model) {
        // Tạm thời truyền một thông điệp ảo ra giao diện để test
        model.addAttribute("welcomeMessage", "Chào mừng bạn đến với Mạng lưới việc làm IT hàng đầu!");

        // Spring Boot sẽ tự tìm file: /WEB-INF/view/candidate/homepage.jsp
        return "candidate/homePage";
    }
}