package com.findjob_tt.findjob_tt.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity // Bật tính năng cấu hình Web Security
public class SecurityConfiguration {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // Đây là nơi chúng ta "dặn dò" bác bảo vệ Spring Security
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(authorize -> authorize
                        // 1. MỞ CỬA TỰ DO: Cho phép mọi người vào trang chủ, trang đăng ký, đăng nhập
                        // và tải file tĩnh (css, ảnh)
                        .requestMatchers("/", "/register", "/login", "/css/**", "/js/**", "/images/**").permitAll()

                        // 2. CÁC TRANG CÒN LẠI: Bắt buộc phải đăng nhập mới được xem
                        .anyRequest().authenticated())
                .formLogin(formLogin -> formLogin
                        // 3. SỬ DỤNG GIAO DIỆN CỦA CHÚNG TA: Trỏ tới đường dẫn /login mà AuthController
                        // đã ánh xạ tới login.jsp
                        .loginPage("/login")
                        .loginProcessingUrl("/login") // Spring sẽ tự động bắt form có action="/login" method="POST"
                        .defaultSuccessUrl("/") // Đăng nhập thành công thì về thẳng trang chủ
                        .failureUrl("/login?error") // Đăng nhập sai thì báo lỗi
                        .permitAll())
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout") // Đăng xuất xong quay lại trang login kèm thông báo
                        .permitAll());

        return http.build();
    }
}