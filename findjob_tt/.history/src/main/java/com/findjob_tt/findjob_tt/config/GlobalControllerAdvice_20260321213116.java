package com.findjob_tt.findjob_tt.config;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.NotificationRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository;
import jakarta.servlet.http.HttpSession;

@ControllerAdvice
public class GlobalControllerAdvice {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private JobRepository jobRepository;

    @ModelAttribute
    public void globalAttributes(Principal principal, HttpSession session, Model model) {
        if (principal != null) {
            User user = userRepository.findByEmail(principal.getName());
            if (user != null) {
                // 1. Lưu session
                if (session.getAttribute("img") == null) {
                    session.setAttribute("img", user.getAvatar());
                    session.setAttribute("fullName", user.getFullName());
                }

                // 2. Đưa đối tượng user vào Model
                model.addAttribute("currentUser", user);

                // 3. Logic đếm "Công việc đã lưu" CHUẨN XÁC:
                // Chỉ đếm những công việc không bị null và Đang mở (isActive = true)
                long activeSavedJobsCount = 0;
                if (user.getSavedItems() != null && !user.getSavedItems().isEmpty()) {
                    // 1. Dùng danh sách ID (kiểu Long) để lấy ra các đối tượng Job thực sự từ DB
                    List<Job> actualSavedJobs = jobRepository.findAllById(user.getSavedItems());

                    // 2. Bây giờ biến 'job' đã là đối tượng Job hoàn chỉnh, có thể gọi
                    // getIsActive()
                    activeSavedJobsCount = actualSavedJobs.stream()
                            .filter(job -> job != null && Boolean.TRUE.equals(job.getIsActive()))
                            .count();
                }

                model.addAttribute("savedItemsCount", activeSavedJobsCount);
                model.addAttribute("savedJobIds", user.getSavedItems());

                // 4. Đếm số thông báo chưa đọc
                long unreadCount = notificationRepository.countByUserAndIsReadFalse(user);
                model.addAttribute("unreadNotificationsCount", unreadCount);
            }
        }
    }
}