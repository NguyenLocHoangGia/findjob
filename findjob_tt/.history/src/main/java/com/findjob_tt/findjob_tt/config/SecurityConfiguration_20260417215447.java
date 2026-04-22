package com.findjob_tt.findjob_tt.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.rememberme.TokenBasedRememberMeServices;
import org.springframework.security.web.session.HttpSessionEventPublisher;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletResponse;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

        // 1. TIÊM (INJECT) UserDetailsService ĐỂ TÌM LẠI USER KHI RESTART SERVER
        @Autowired
        private UserDetailsService customUserDetailsService;

        // 2. TIÊM "CẢNH SÁT GIAO THÔNG" VÀO ĐỂ PHÂN LUỒNG
        @Autowired
        private CustomSuccessHandler customSuccessHandler;

        @Autowired
        private OAuth2AuthenticationSuccessHandler oauth2AuthenticationSuccessHandler;

        @Bean
        public TokenBasedRememberMeServices rememberMeServices() {
                TokenBasedRememberMeServices services = new TokenBasedRememberMeServices("jobportal_secret_key_123",
                                customUserDetailsService) {
                        @Override
                        public void onLoginSuccess(jakarta.servlet.http.HttpServletRequest request,
                                        jakarta.servlet.http.HttpServletResponse response,
                                        org.springframework.security.core.Authentication successfulAuthentication) {

                                // [CHÌA KHÓA GIẢI QUYẾT BUG]
                                // Nếu phát hiện đăng nhập bằng Google (OAuth2), ép RememberMe phải "đứng im"
                                // Để nhường đường cho OAuth2AuthenticationSuccessHandler chạy lệnh lưu Database
                                if (successfulAuthentication instanceof org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken) {
                                        return;
                                }

                                // Nếu là đăng nhập bằng tài khoản nội bộ (Form Login), vẫn chạy RememberMe bình
                                // thường
                                super.onLoginSuccess(request, response, successfulAuthentication);
                        }
                };

                // Vẫn giữ nguyên cấu hình cũ của bạn
                services.setAlwaysRemember(true);
                services.setTokenValiditySeconds(7 * 24 * 60 * 60); // Sống trong 7 ngày

                return services;
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                http
                                .authorizeHttpRequests(authorize -> authorize
                                                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE)
                                                .permitAll()
                                                .requestMatchers("/", "/register", "/login", "/error", "/css/**",
                                                                "/js/**", "/images/**", "/uploads/**",
                                                                "/oauth2/**", "/login/oauth2/**")
                                                .permitAll()
                                                .requestMatchers("/recruiter/register-company")
                                                .hasAuthority("ROLE_CANDIDATE")
                                                .requestMatchers("/admin/**").hasAuthority("ROLE_ADMIN")
                                                .requestMatchers("/recruiter/**").hasAuthority("ROLE_RECRUITER")
                                                .requestMatchers("/candidate/**").hasAuthority("ROLE_CANDIDATE")
                                                .anyRequest().authenticated())
                                .formLogin(formLogin -> formLogin
                                                .loginPage("/login")
                                                .loginProcessingUrl("/login")
                                                .failureUrl("/login?error")
                                                .successHandler(customSuccessHandler)
                                                .permitAll())
                                .oauth2Login(oauth2 -> oauth2
                                                .loginPage("/login")
                                                .successHandler(oauth2AuthenticationSuccessHandler))
                                .rememberMe(remember -> remember
                                                .rememberMeServices(rememberMeServices()))
                                .logout(logout -> logout
                                                .logoutUrl("/logout")
                                                .logoutSuccessUrl("/login?logout")
                                                .permitAll())

                                // Báo cho Security biết dùng cuốn sổ SessionRegistry
                                .sessionManagement(session -> session
                                                .maximumSessions(1) // Mỗi user chỉ được đăng nhập 1 nơi (Tùy chọn)
                                                .sessionRegistry(sessionRegistry())
                                                .expiredUrl("/login?expired=true") // <--- THÊM DÒNG NÀY ĐỂ TRÁNH MÀN
                                                                                   // HÌNH ĐEN
                                )
                                .exceptionHandling(exception -> exception
                                                .accessDeniedHandler((request, response, accessDeniedException) -> {
                                                        request.setAttribute(
                                                                        jakarta.servlet.RequestDispatcher.ERROR_STATUS_CODE,
                                                                        HttpServletResponse.SC_FORBIDDEN);
                                                        request.getRequestDispatcher("/error").forward(request,
                                                                        response);
                                                }))

                                .headers(headers -> headers
                                                .frameOptions(options -> options.sameOrigin()));

                return http.build();
        }

        // 1. Tạo Bean SessionRegistry để theo dõi các Session đang active
        @Bean
        public SessionRegistry sessionRegistry() {
                return new SessionRegistryImpl();
        }

        // 2. Lắng nghe sự kiện đăng nhập/đăng xuất để báo cho SessionRegistry
        @Bean
        public HttpSessionEventPublisher httpSessionEventPublisher() {
                return new HttpSessionEventPublisher();
        }
}