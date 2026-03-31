package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.model.Job;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private JobRepository jobRepository;

    @GetMapping("/")
    public String showCandidateHomepage(
            // Thêm @RequestParam để hứng từ khóa (required = false nghĩa là lúc mới vào
            // trang web sẽ không báo lỗi)
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model) {

        List<Job> jobs;

        // Nếu người dùng có nhập chữ vào ô tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Gọi hàm tìm kiếm đa năng
            jobs = jobRepository.searchJobsByKeyword(keyword.trim());
            model.addAttribute("keyword", keyword); // Giữ lại từ khóa để hiện lại trên ô input
        }
        // Nếu không tìm kiếm gì (mới load trang) -> Hiển thị tất cả
        else {
            jobs = jobRepository.findAll();
        }

        model.addAttribute("jobs", jobs);

        return "candidate/homePage";
    }

}