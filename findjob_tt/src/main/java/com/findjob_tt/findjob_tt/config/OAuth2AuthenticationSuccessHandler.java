package com.findjob_tt.findjob_tt.config;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.findjob_tt.findjob_tt.model.CandidateProfile;
import com.findjob_tt.findjob_tt.model.Role;
import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.repository.RoleRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class OAuth2AuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private static final Logger logger = LoggerFactory.getLogger(OAuth2AuthenticationSuccessHandler.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        // ===== LẤY THÔNG TIN USER TỪ GOOGLE =====
        OAuth2User oauth2User = (OAuth2User) authentication.getPrincipal();

        String googleId = resolveGoogleId(oauth2User); // ID duy nhất của Google
        String email = resolveEmail(oauth2User); // Email từ Google

        // Lấy thêm thông tin hiển thị
        String name = oauth2User.getAttribute("name");
        String picture = oauth2User.getAttribute("picture");

        logger.info("Google OAuth2 success callback received: email={}, googleId={}", email, googleId);

        // ===== VALIDATE DỮ LIỆU GOOGLE =====
        // Nếu thiếu googleId hoặc email → không cho login
        if (googleId == null || googleId.isBlank() || email == null || email.isBlank()) {
            response.sendRedirect("/login?error");
            return;
        }

        // ===== TÌM USER THEO GOOGLE ID =====
        User user = userRepository.findByGoogleId(googleId);

        // ===== CHẶN LOGIN GOOGLE NẾU USER BỊ KHÓA =====
        if (user != null && !user.isActive()) {
            logger.warn("Blocked Google login for disabled account: email={}, googleId={}", email, googleId);
            request.getSession().invalidate(); // hủy session hiện tại
            response.sendRedirect("/login?disabled"); // redirect thông báo
            return;
        }

        // ===== NẾU CHƯA TÌM THẤY USER THEO GOOGLE ID =====
        if (user == null) {

            // Thử tìm theo email (account local cũ)
            user = userRepository.findByEmail(email);

            if (user != null) {

                // ===== CHẶN LINK GOOGLE NẾU ACCOUNT LOCAL BỊ KHÓA =====
                if (!user.isActive()) {
                    logger.warn("Blocked Google account linking for disabled local account: email={}, googleId={}",
                            email, googleId);
                    request.getSession().invalidate();
                    response.sendRedirect("/login?disabled");
                    return;
                }

                // ===== LIÊN KẾT GOOGLE VỚI ACCOUNT LOCAL =====
                logger.info("Linking Google account to existing user by email: email={}, googleId={}", email, googleId);
                user.setGoogleId(googleId);

                // Nếu chưa có authType thì set LOCAL
                if (user.getAuthType() == null) {
                    user.setAuthType(User.AuthType.LOCAL);
                }

            } else {

                // ===== TẠO USER MỚI TỪ GOOGLE =====
                logger.info("Creating new Google user: email={}, googleId={}", email, googleId);

                user = new User();
                user.setEmail(email);
                user.setGoogleId(googleId);
                user.setAuthType(User.AuthType.GOOGLE);
                user.setPassword(null); // Google login không cần password
                user.setCreatedAt(LocalDateTime.now());

                // FIX: mặc định cho hoạt động
                user.setActive(true);

                // FIX: tránh lỗi NOT NULL
                user.setFullName(name != null ? name : "Google User");
                if (picture != null) {
                    user.setAvatar(picture);
                }

                // ===== GÁN ROLE MẶC ĐỊNH =====
                Role candidateRole = roleRepository.findByName("ROLE_CANDIDATE");

                if (candidateRole == null) {
                    throw new ServletException("Không tìm thấy role ROLE_CANDIDATE trong Database");
                }

                // FIX: tránh NullPointerException
                if (user.getRoles() == null) {
                    user.setRoles(new HashSet<>());
                }
                user.getRoles().add(candidateRole);

                // ===== TẠO PROFILE CHO USER =====
                CandidateProfile profile = new CandidateProfile();
                profile.setUser(user);
                user.setCandidateProfile(profile);
            }

            // ===== LƯU USER XUỐNG DB =====
            user = userRepository.save(user);
        }

        logger.info("Google login completed successfully: email={}, target={}", user.getEmail(),
                resolveTargetUrl(user));

        // ===== NẠP ROLE TỪ DATABASE VÀO SPRING SECURITY =====
        List<GrantedAuthority> authorities = new ArrayList<>();

        if (user.getRoles() != null) {
            for (Role r : user.getRoles()) {
                authorities.add(new SimpleGrantedAuthority(r.getName()));
            }
        }

        // Giữ lại quyền gốc từ Google
        authorities.addAll(authentication.getAuthorities());

        // ===== UPDATE LẠI SECURITY CONTEXT =====
        OAuth2AuthenticationToken newAuth = new OAuth2AuthenticationToken(
                oauth2User,
                authorities,
                ((OAuth2AuthenticationToken) authentication).getAuthorizedClientRegistrationId());

        SecurityContextHolder.getContext().setAuthentication(newAuth);

        // ===== TẠO SESSION CHO JSP =====
        HttpSession session = request.getSession();
        session.setAttribute("userEmail", user.getEmail());
        session.setAttribute("img", user.getAvatar());
        session.setAttribute("fullName", user.getFullName());

        // ===== REDIRECT THEO ROLE =====
        response.sendRedirect(resolveTargetUrl(user));
    }

    // ===== LẤY GOOGLE ID =====
    private String resolveGoogleId(OAuth2User oauth2User) {
        if (oauth2User instanceof OidcUser oidcUser) {
            return oidcUser.getSubject();
        }
        Object sub = oauth2User.getAttributes().get("sub");
        return sub != null ? sub.toString() : null;
    }

    // ===== LẤY EMAIL =====
    private String resolveEmail(OAuth2User oauth2User) {
        if (oauth2User instanceof OidcUser oidcUser) {
            return oidcUser.getEmail();
        }
        Object email = oauth2User.getAttributes().get("email");
        return email != null ? email.toString() : null;
    }

    // ===== XÁC ĐỊNH TRANG SAU LOGIN =====
    private String resolveTargetUrl(User user) {
        if (user.getRoles() == null)
            return "/home";

        for (Role role : user.getRoles()) {
            String roleName = role.getName();
            if ("ROLE_ADMIN".equals(roleName)) {
                return "/admin/dashboard";
            }
            if ("ROLE_RECRUITER".equals(roleName)) {
                return "/recruiter/dashboard";
            }
            if ("ROLE_CANDIDATE".equals(roleName)) {
                return "/home";
            }
        }

        return "/home";
    }
}