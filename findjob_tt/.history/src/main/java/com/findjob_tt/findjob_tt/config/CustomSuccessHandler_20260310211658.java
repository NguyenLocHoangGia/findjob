package com.findjob_tt.findjob_tt.config;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import java.io.IOException;
import java.util.Collection;

public class CustomSuccessHandler implements AuthenticationSuccessHandler {

    private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        String targetUrl = "/"; // Mặc định cho về trang chủ

        // 1. Kiểm tra quyền của người vừa đăng nhập
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        for (GrantedAuthority grantedAuthority : authorities) {
            String role = grantedAuthority.getAuthority();

            // 2. Điều hướng tương ứng
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

        // 3. Lưu thông tin cơ bản vào Session để dùng hiển thị ở Header (như Tên,
        // Avatar)
        HttpSession session = request.getSession();
        session.setAttribute("userEmail", authentication.getName());

        // 4. Chuyển hướng
        redirectStrategy.sendRedirect(request, response, targetUrl);
    }
}