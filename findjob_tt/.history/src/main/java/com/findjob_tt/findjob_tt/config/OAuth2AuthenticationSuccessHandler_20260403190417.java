package com.findjob_tt.findjob_tt.config;

import java.io.IOException;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
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

        OAuth2User oauth2User = (OAuth2User) authentication.getPrincipal();

        String googleId = resolveGoogleId(oauth2User);
        String email = resolveEmail(oauth2User);

        logger.info("Google OAuth2 success callback received: email={}, googleId={}", email, googleId);

        if (googleId == null || googleId.isBlank() || email == null || email.isBlank()) {
            response.sendRedirect("/login?error");
            return;
        }

        User user = userRepository.findByGoogleId(googleId);

        if (user != null && !user.isActive()) {
            logger.warn("Blocked Google login for disabled account: email={}, googleId={}", email, googleId);
            request.getSession().invalidate();
            response.sendRedirect("/login?disabled");
            return;
        }

        if (user == null) {
            user = userRepository.findByEmail(email);
            if (user != null) {
                if (!user.isActive()) {
                    logger.warn("Blocked Google account linking for disabled local account: email={}, googleId={}", email, googleId);
                    request.getSession().invalidate();
                    response.sendRedirect("/login?disabled");
                    return;
                }

                logger.info("Linking Google account to existing user by email: email={}, googleId={}", email, googleId);
                user.setGoogleId(googleId);
                if (user.getAuthType() == null) {
                    user.setAuthType(User.AuthType.LOCAL);
                }
            } else {
                logger.info("Creating new Google user: email={}, googleId={}", email, googleId);
                user = new User();
                user.setEmail(email);
                user.setGoogleId(googleId);
                user.setAuthType(User.AuthType.GOOGLE);
                user.setPassword(null);
                user.setCreatedAt(LocalDateTime.now());

                Role candidateRole = roleRepository.findById(2L)
                        .orElseGet(() -> roleRepository.findByName("ROLE_CANDIDATE"));
                if (candidateRole == null) {
                    throw new ServletException("Thiếu role CANDIDATE để tạo tài khoản Google");
                }

                user.getRoles().add(candidateRole);

                CandidateProfile profile = new CandidateProfile();
                profile.setUser(user);
                user.setCandidateProfile(profile);
            }

            user = userRepository.save(user);
        }

        logger.info("Google login completed successfully: email={}, target={}", user.getEmail(), resolveTargetUrl(user));

        HttpSession session = request.getSession();
        session.setAttribute("userEmail", user.getEmail());
        session.setAttribute("img", user.getAvatar());
        session.setAttribute("fullName", user.getFullName());

        response.sendRedirect(resolveTargetUrl(user));
    }

    private String resolveGoogleId(OAuth2User oauth2User) {
        if (oauth2User instanceof OidcUser oidcUser) {
            return oidcUser.getSubject();
        }

        Object sub = oauth2User.getAttributes().get("sub");
        return sub != null ? sub.toString() : null;
    }

    private String resolveEmail(OAuth2User oauth2User) {
        if (oauth2User instanceof OidcUser oidcUser) {
            return oidcUser.getEmail();
        }

        Object email = oauth2User.getAttributes().get("email");
        return email != null ? email.toString() : null;
    }

    private String resolveTargetUrl(User user) {
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
