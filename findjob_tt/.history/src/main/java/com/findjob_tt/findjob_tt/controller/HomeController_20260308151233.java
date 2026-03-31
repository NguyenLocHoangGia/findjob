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

    @GetMapping("/job/{id}")
    public String showJobDetail(@org.springframework.web.bind.annotation.PathVariable("id") Long id, Model model) {
        // Tìm công việc theo ID, nếu không thấy thì trả về null
        Job job = jobRepository.findById(id).orElse(null);

        // Truyền dữ liệu công việc tìm được sang trang chi tiết
        model.addAttribute("job", job);

        // Sẽ gọi file: /WEB-INF/view/candidate/job-detail.jsp
        return "candidate/job-detail";
    }
}