package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;

import java.util.List;

@Controller
public class RecruiterController {

    @Autowired
    private ApplicationRepository applicationRepository;

    // Khai báo thêm 2 công cụ này
    @Autowired
    private JobRepository jobRepository;

    // 1. Trang Bảng điều khiển (Đã làm ở bước trước)
    @GetMapping("/recruiter/dashboard")
    public String showDashboard(Model model) {
        List<Application> applications = applicationRepository.findAll();
        model.addAttribute("applications", applications);
        return "recruiter/dashboard";
    }

    // 2. MỞ FORM THÊM MỚI HỒ SƠ
    @GetMapping("/recruiter/application/add")
    public String showAddApplicationForm(Model model) {
        // Lấy danh sách Công việc để HR chọn xem ứng viên nộp vào vị trí nào
        List<Job> jobs = jobRepository.findAll();
        model.addAttribute("jobs", jobs);

        return "recruiter/add-application"; // Gọi file JSP
    }

    // 3. XỬ LÝ LƯU HỒ SƠ VÀO DATABASE
    @PostMapping("/recruiter/job/save")
    public String saveJob(@ModelAttribute Job job, RedirectAttributes redirectAttributes) {
        // Tự động lưu toàn bộ thông tin (title, companyName, salary, location,
        // description) vào DB
        jobRepository.save(job);

        redirectAttributes.addFlashAttribute("successMsg", "Đăng tin tuyển dụng [" + job.getTitle() + "] thành công!");

        // Tạm thời lưu xong thì quay về Dashboard (sau này bạn có thể tạo trang Danh
        // sách Job riêng)
        return "redirect:/recruiter/dashboard";
    }
}