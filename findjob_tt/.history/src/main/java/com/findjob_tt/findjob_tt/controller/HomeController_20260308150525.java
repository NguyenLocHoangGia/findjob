package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.model.Job;
import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private JobRepository jobRepository;

    @GetMapping("/")
    public String showCandidateHomepage(Model model) {
        // Lấy danh sách việc làm từ Database
        List<Job> jobs = jobRepository.findAll();

        // Truyền danh sách này sang giao diện với tên là "jobs"
        model.addAttribute("jobs", jobs);

        return "candidate/homePage";
    }
}