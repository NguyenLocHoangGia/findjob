package com.findjob_tt.findjob_tt.config;

import java.io.IOException;
import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.repository.UserRepository;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class CustomSuccessHandler implements AuthenticationSuccessHandler {

    @Autowired
    private UserRepository userRepository;

    private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        String targetUrl = "/";
        String email = authentication.getName();
        User user = userRepository.findByEmail(email);

        HttpSession session = request.getSession();
        session.setAttribute("userEmail", email);

        if (user != null) {
            // SỬA: getImg() đổi thành getAvatar()
            session.setAttribute("img", user.getAvatar());
            session.setAttribute("fullName", user.getFullName());
        }

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        for (GrantedAuthority grantedAuthority : authorities) {
            String role = grantedAuthority.getAuthority();

            if (role.equals("ROLE_ADMIN")) {
                targetUrl = "/admin/dashboard";
                break;
            } else if (role.equals("ROLE_RECRUITER")) {
                targetUrl = "/recruiter/dashboard";
                break;
            } else if (role.equals("ROLE_CANDIDATE")) {
                targetUrl = "/";
                break;
            }
        }

        redirectStrategy.sendRedirect(request, response, targetUrl);
    }
}