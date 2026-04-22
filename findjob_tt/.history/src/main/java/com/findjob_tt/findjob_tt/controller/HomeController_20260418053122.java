package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
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
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

    private String getEmailFromPrincipal(Principal principal) {
        if (principal instanceof OAuth2AuthenticationToken oauthToken) {
            OAuth2User oauth2User = oauthToken.getPrincipal();
            return oauth2User.getAttribute("email");
        }
        return principal.getName();
    }

    private boolean isProfileCompleted(User user) {
        if (user == null) {
            return false;
        }
        if (user.getCandidateProfile() == null) {
            return false;
        }

        return user.getFullName() != null && !user.getFullName().isBlank()
                && user.getPhone() != null && !user.getPhone().isBlank()
                && user.getCandidateProfile().getAddress() != null && !user.getCandidateProfile().getAddress().isBlank()
                && user.getCandidateProfile().getDescription() != null
                && !user.getCandidateProfile().getDescription().isBlank()
                && user.getCandidateProfile().getCvUrl() != null && !user.getCandidateProfile().getCvUrl().isBlank();
    }

    @GetMapping({ "/", "/home" })
    public String showCandidateHomepage(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "location", required = false) String location,
            @RequestParam(value = "salaryRange", required = false) String salaryRange,
            @RequestParam(value = "category", required = false) Long categoryId,
            Model model) {

        populateHomeData(keyword, location, salaryRange, categoryId, model, false);
        return "candidate/homePage";
    }

    @GetMapping("/jobs")
    public String showAllJobsPage(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "location", required = false) String location,
            @RequestParam(value = "salaryRange", required = false) String salaryRange,
            @RequestParam(value = "category", required = false) Long categoryId,
            Model model) {

        populateHomeData(keyword, location, salaryRange, categoryId, model, true);
        return "candidate/homePage";
    }

    private void populateHomeData(
            String keyword,
            String location,
            String salaryRange,
            Long categoryId,
            Model model,
            boolean isAllJobsPage) {

        List<Job> jobs;

        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
        boolean hasLocation = (location != null && !location.trim().isEmpty());
        boolean hasSalaryRange = (salaryRange != null && !salaryRange.trim().isEmpty());
        boolean hasCategory = (categoryId != null);

        // =========================================================
        // 1. LẤY DANH SÁCH CÔNG VIỆC (Theo tìm kiếm hoặc Mặc định)
        // =========================================================
        if (hasKeyword || hasLocation || hasCategory) {
            String searchKeyword = hasKeyword ? keyword.trim() : "";
            String searchLocation = hasLocation ? location.trim() : "";

            jobs = jobRepository.searchActiveJobs(searchKeyword, searchLocation, categoryId);
        } else {
            jobs = jobRepository.findByIsActiveTrueAndStatusOrderByCreatedAtDesc("APPROVED");
        }

        if (hasSalaryRange) {
            String normalizedSalaryRange = salaryRange.trim();
            jobs = jobs.stream()
                    .filter(job -> matchesSalaryRange(job.getSalary(), normalizedSalaryRange))
                    .toList();
        }

        model.addAttribute("keyword", keyword);
        model.addAttribute("location", location);
        model.addAttribute("salaryRange", salaryRange);
        model.addAttribute("categoryId", categoryId);

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
        List<Job> hotJobs = jobs.stream()
                .filter(Job::getIsHot)
                .toList();

        List<Job> displayedHotJobs = hotJobs.stream().limit(3).toList();
        List<Job> displayedRecentJobs = jobs.stream().limit(6).toList();

        // Truyền dữ liệu ra file JSP
        model.addAttribute("hotJobs", displayedHotJobs); // Dành cho mục "Việc làm hấp dẫn"
        model.addAttribute("recentJobs", displayedRecentJobs); // Dành cho danh sách dưới cùng / Kết quả tìm kiếm
        model.addAttribute("allJobs", jobs); // Dành cho trang tổng hợp
        model.addAttribute("isAllJobsPage", isAllJobsPage);
        model.addAttribute("hasMoreHotJobs", hotJobs.size() > 3 && !isAllJobsPage);
        model.addAttribute("hasMoreRecentJobs", jobs.size() > 6 && !isAllJobsPage);
        model.addAttribute("categories", categoryRepository.findAll()); // Dành cho ô Select tìm theo ngành
    }

    private boolean matchesSalaryRange(String salaryText, String salaryRange) {
        if (salaryRange == null || salaryRange.isBlank()) {
            return true;
        }

        String normalizedSalary = salaryText == null ? "" : salaryText.trim().toLowerCase(Locale.ROOT);
        String normalizedRange = salaryRange.trim().toUpperCase(Locale.ROOT);

        if ("NEGOTIABLE".equals(normalizedRange)) {
            return normalizedSalary.contains("thoa thuan") || normalizedSalary.contains("thỏa thuận");
        }

        Long salaryNumber = extractSalaryNumber(salaryText);
        if (salaryNumber == null) {
            return false;
        }

        return switch (normalizedRange) {
            case "LT5" -> salaryNumber < 5_000_000L;
            case "FROM5TO15" -> salaryNumber >= 5_000_000L && salaryNumber <= 15_000_000L;
            case "GT15" -> salaryNumber > 15_000_000L;
            default -> true;
        };
    }

    private Long extractSalaryNumber(String salaryText) {
        if (salaryText == null || salaryText.isBlank()) {
            return null;
        }

        String normalized = salaryText.toLowerCase(Locale.ROOT).trim();
        if (normalized.contains("thoa thuan") || normalized.contains("thỏa thuận")) {
            return null;
        }

        Pattern pattern = Pattern.compile("(\\d[\\d\\s\\.,]*)");
        Matcher matcher = pattern.matcher(salaryText);
        if (!matcher.find()) {
            return null;
        }

        String digitsOnly = matcher.group(1).replaceAll("[^0-9]", "");
        if (digitsOnly.isBlank()) {
            return null;
        }

        try {
            return Long.parseLong(digitsOnly);
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    @GetMapping("/job/{id}")
    public String showJobDetail(@PathVariable("id") Long id, Model model, Principal principal) {
        // 1. Tìm công việc theo ID
        Job job = jobRepository.findById(id).orElse(null);
        model.addAttribute("job", job);

        // 2. Logic kiểm tra và Pre-fill thông tin
        boolean isPending = false; // Mặc định là chưa ứng tuyển
        boolean profileCompleted = true;

        if (principal != null) {
            String email = getEmailFromPrincipal(principal);
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

                boolean isCandidate = currentUser.getRoles().stream()
                        .anyMatch(role -> "ROLE_CANDIDATE".equals(role.getName()));
                if (isCandidate) {
                    profileCompleted = isProfileCompleted(currentUser);
                }
            }
        }

        // Gửi trạng thái isPending ra JSP
        model.addAttribute("isPending", isPending);
        model.addAttribute("profileCompleted", profileCompleted);

        return "candidate/job-detail";
    }

}