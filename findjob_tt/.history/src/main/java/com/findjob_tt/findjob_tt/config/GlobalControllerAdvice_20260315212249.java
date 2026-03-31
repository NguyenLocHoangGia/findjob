package com.findjob_tt.findjob_tt.config;

import java.security.Principal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.repository.UserRepository;
import jakarta.servlet.http.HttpSession;

@ControllerAdvice
public class GlobalControllerAdvice {

    @Autowired
    private UserRepository userRepository;

    @ModelAttribute
    public void globalAttributes(Principal principal, HttpSession session, Model model) {
        if (principal != null) {
            User user = userRepository.findByEmail(principal.getName());
            if (user != null) {
                // 1. Lưu session (giữ nguyên logic cũ của bạn)
                if (session.getAttribute("img") == null) {
                    session.setAttribute("img", user.getAvatar());
                    session.setAttribute("fullName", user.getFullName());
                }

                // 2. Đưa đối tượng user vào Model để dùng ở mọi nơi
                // Key là "currentUser", bạn có thể gọi ${currentUser.fullName} ở JSP
                model.addAttribute("currentUser", user);

                // 3. Các thuộc tính khác (giữ nguyên logic cũ)
                model.addAttribute("savedItemsCount", user.getSavedItems().size());
                model.addAttribute("savedJobIds", user.getSavedItems());
            }
        }
    }
}