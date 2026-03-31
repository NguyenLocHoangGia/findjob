package com.findjob_tt.findjob_tt.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.rememberme.TokenBasedRememberMeServices;

import jakarta.servlet.DispatcherType;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

        // 1. TIÊM (INJECT) UserDetailsService ĐỂ TÌM LẠI USER KHI RESTART SERVER
        @Autowired
        private UserDetailsService customUserDetailsService;

        // 2. TIÊM "CẢNH SÁT GIAO THÔNG" VÀO ĐỂ PHÂN LUỒNG
        @Autowired
        private CustomSuccessHandler customSuccessHandler;

        @Bean
        public TokenBasedRememberMeServices rememberMeServices() {
                // Khởi tạo dịch vụ nhớ mật khẩu với chìa khóa và customUserDetailsService
                TokenBasedRememberMeServices services = new TokenBasedRememberMeServices("jobportal_secret_key_123",
                                customUserDetailsService);

                // ĐÂY LÀ CHÌA KHÓA TỪ DỰ ÁN CŨ CỦA BẠN: Bắt buộc luôn nhớ mà không cần Checkbox
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

                                                // 1. Cấp quyền tự do cho các trang Public
                                                .requestMatchers("/", "/register", "/login", "/error", "/css/**",
                                                                "/js/**", "/images/**", "/uploads/**")
                                                .permitAll()

                                                // 2. KHÓA CỬA: Chỉ Admin mới vào được /admin/**
                                                .requestMatchers("/admin/**").hasAuthority("ROLE_ADMIN")

                                                // 3. KHÓA CỬA: Chỉ HR mới vào được /recruiter/**
                                                .requestMatchers("/recruiter/**").hasAuthority("ROLE_RECRUITER")

                                                // 4. KHÓA CỬA: Chỉ Ứng viên mới vào được /candidate/**
                                                .requestMatchers("/candidate/**").hasAuthority("ROLE_CANDIDATE")

                                                // Các trang còn lại bắt buộc phải đăng nhập
                                                .anyRequest().authenticated())

                                .formLogin(formLogin -> formLogin
                                                .loginPage("/login")
                                                .loginProcessingUrl("/login")
                                                .failureUrl("/login?error")
                                                // 3. KÍCH HOẠT CHUYỂN HƯỚNG THEO ROLE TẠI ĐÂY
                                                .successHandler(customSuccessHandler)
                                                .permitAll())

                                .rememberMe(remember -> remember
                                                .rememberMeServices(rememberMeServices()))

                                .logout(logout -> logout
                                                .logoutUrl("/logout")
                                                .logoutSuccessUrl("/login?logout")
                                                .permitAll());

                return http.build();
        }
}