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
                // 1. Phục vụ Avatar (Session)
                if (session.getAttribute("img") == null) {
                    session.setAttribute("img", user.getImg());
                    session.setAttribute("fullName", user.getFullName());
                }

                // 2. Phục vụ đếm số lượng & kiểm tra thả tim (Đẩy vào Model)
                // Đẩy con số ra cho Header
                model.addAttribute("savedItemsCount", user.getSavedItems().size());
                // Đẩy danh sách ID ra cho Trang chủ để biết việc nào đã thả tim rồi
                model.addAttribute("savedJobIds", user.getSavedItems());
            }
        }
    }
}