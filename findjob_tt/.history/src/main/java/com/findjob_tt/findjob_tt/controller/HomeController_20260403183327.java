package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.CategoryRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.User;

import java.security.Principal;
import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private JobRepository jobRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private ApplicationRepository applicationRepository;
    @Autowired
    private CategoryRepository categoryRepository;

    @GetMapping({ "/", "/home" })
    public String showCandidateHomepage(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "location", required = false) String location,
            @RequestParam(value = "category", required = false) Long categoryId,
            Model model) {

        List<Job> jobs;

        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
        boolean hasLocation = (location != null && !location.trim().isEmpty());
        boolean hasCategory = (categoryId != null);

        // =========================================================
        // 1. LẤY DANH SÁCH CÔNG VIỆC (Theo tìm kiếm hoặc Mặc định)
        // =========================================================
        if (hasKeyword || hasLocation || hasCategory) {
            String searchKeyword = hasKeyword ? keyword.trim() : "";
            String searchLocation = hasLocation ? location.trim() : "";

            jobs = jobRepository.searchActiveJobs(searchKeyword, searchLocation, categoryId);

            model.addAttribute("keyword", keyword);
            model.addAttribute("location", location);
            model.addAttribute("categoryId", categoryId);
        } else {
            jobs = jobRepository.findByIsActiveTrueAndStatusOrderByCreatedAtDesc("APPROVED");
        }

        // =========================================================
        // 2. LOGIC TÍNH TOÁN "CÔNG VIỆC HOT" (DYNAMIC BADGE)
        // =========================================================
        long totalApplications = applicationRepository.count(); // Tổng số đơn toàn hệ thống

        if (totalApplications > 0) {
            for (Job job : jobs) {
                // Đếm số lượng ứng viên đã nộp vào công việc này
                double applyCount = job.getApplications() != null ? job.getApplications().size() : 0;

                // Tính tỉ trọng phần trăm (%)
                double ratio = (applyCount / totalApplications) * 100;

                // Quy tắc: Chiếm >= 10% tổng số đơn toàn hệ thống thì được lên top HOT
                job.setIsHot(ratio >= 10.0);
            }
        }

        // =========================================================
        // 3. CHIA DỮ LIỆU ĐỂ HIỂN THỊ CHO GIAO DIỆN
        // =========================================================
        // Lọc ra danh sách tối đa 8 việc làm Hot để nhét vào khung Grid
        List<Job> hotJobs = jobs.stream()
                .filter(Job::getIsHot)
                .limit(8)
                .toList();

        // Truyền dữ liệu ra file JSP
        model.addAttribute("hotJobs", hotJobs); // Dành cho mục "Việc làm hấp dẫn"
        model.addAttribute("recentJobs", jobs); // Dành cho danh sách dưới cùng / Kết quả tìm kiếm
        model.addAttribute("categories", categoryRepository.findAll()); // Dành cho ô Select tìm theo ngành

        return "candidate/homePage";
    }

    @GetMapping("/job/{id}")
    public String showJobDetail(@PathVariable("id") Long id, Model model, Principal principal) {
        // 1. Tìm công việc theo ID
        Job job = jobRepository.findById(id).orElse(null);
        model.addAttribute("job", job);

        // 2. Logic kiểm tra và Pre-fill thông tin
        boolean isPending = false; // Mặc định là chưa ứng tuyển

        if (principal != null) {
            String email = principal.getName();
            User currentUser = userRepository.findByEmail(email);

            if (currentUser != null) {
                // --- DÒNG LOGIC MỚI THÊM VÀO ĐÂY ---
                // Kiểm tra xem user này đã nộp đơn cho job này và đang đợi duyệt (PENDING) hay
                // chưa
                isPending = applicationRepository.existsByUserAndJobAndStatus(currentUser, job, "PENDING");
                // ------------------------------------

                model.addAttribute("userEmail", currentUser.getEmail());

                if (currentUser.getCandidateProfile() != null) {
                    model.addAttribute("candidate", currentUser.getCandidateProfile());
                }
            }
        }

        // Gửi trạng thái isPending ra JSP
        model.addAttribute("isPending", isPending);

        return "candidate/job-detail";
    }

}