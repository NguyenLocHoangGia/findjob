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

        String targetUrl = "/"; // Mặc định về trang chủ nếu không có quyền gì đặc biệt

        // Lấy thông tin user từ DB
        String email = authentication.getName();
        User user = userRepository.findByEmail(email);

        // Lưu thông tin vào Session để dùng hiển thị ở Header
        HttpSession session = request.getSession();
        session.setAttribute("userEmail", email);

        if (user != null) {
            session.setAttribute("img", user.getImg());
            session.setAttribute("fullName", user.getFullName());
        }

        // Kiểm tra quyền của người vừa đăng nhập
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        for (GrantedAuthority grantedAuthority : authorities) {
            String role = grantedAuthority.getAuthority();

            // Điều hướng tương ứng
            if (role.equals("ROLE_ADMIN")) {
                targetUrl = "/admin/dashboard";
                break; // Tìm thấy quyền cao nhất thì ngắt vòng lặp
            } else if (role.equals("ROLE_RECRUITER")) {
                targetUrl = "/recruiter/dashboard";
                break;
            } else if (role.equals("ROLE_CANDIDATE")) {
                targetUrl = "/";
                break;
            }
        }

        // Thực hiện chuyển hướng người dùng
        redirectStrategy.sendRedirect(request, response, targetUrl);
    }
}