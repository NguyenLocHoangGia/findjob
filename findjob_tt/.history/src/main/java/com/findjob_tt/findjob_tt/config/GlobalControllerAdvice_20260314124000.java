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
                // SỬA: getImg() đổi thành getAvatar()
                if (session.getAttribute("img") == null) {
                    session.setAttribute("img", user.getAvatar());
                    session.setAttribute("fullName", user.getFullName());
                }

                model.addAttribute("savedItemsCount", user.getSavedItems().size());
                model.addAttribute("savedJobIds", user.getSavedItems());
            }
        }
    }
}