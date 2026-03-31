package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
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

    @GetMapping("/")
    public String showCandidateHomepage(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "location", required = false) String location,
            Model model) {

        List<Job> jobs;

        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
        boolean hasLocation = (location != null && !location.trim().isEmpty());

        // Nếu người dùng có nhập từ khóa HOẶC chọn địa điểm
        if (hasKeyword || hasLocation) {
            // Xử lý chuỗi rỗng để truyền vào Query
            String searchKeyword = hasKeyword ? keyword.trim() : "";
            String searchLocation = hasLocation ? location.trim() : "";

            // Gọi hàm tìm kiếm đa năng (Chỉ tìm job đang Active)
            jobs = jobRepository.searchActiveJobs(searchKeyword, searchLocation);

            // Giữ lại giá trị để hiển thị trên thanh tìm kiếm
            model.addAttribute("keyword", keyword);
            model.addAttribute("location", location);
        }
        // Nếu không tìm kiếm gì (mới load trang)
        else {
            // KHÔNG DÙNG findAll() nữa để tránh hiện các job đã đóng
            // Lấy các job đang mở (isActive = true) và xếp mới nhất lên đầu
            jobs = jobRepository.findByIsActiveTrueOrderByCreatedAtDesc();
        }

        model.addAttribute("jobs", jobs);

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

    @GetMapping("/switch-to-recruiter")
    public String switchToRecruiter(Principal principal) {
        if (principal == null) {
            return "redirect:/login"; // Chưa đăng nhập thì yêu cầu login
        }

        User user = userRepository.findByEmail(principal.getName());

        // Kiểm tra xem User này đã có mác "ROLE_RECRUITER" chưa?
        boolean isRecruiter = user.getRoles().stream()
                .anyMatch(role -> role.getName().equals("ROLE_RECRUITER"));

        if (isRecruiter) {
            // Đã là HR -> Cho vào Dashboard quản lý tin tuyển dụng
            return "redirect:/recruiter/dashboard";
        } else {
            // Đang là Candidate muốn nâng cấp -> Dẫn sang trang khai báo Công ty
            return "redirect:/recruiter/register-company";
        }
    }
}