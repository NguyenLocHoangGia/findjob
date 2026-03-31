package com.findjob_tt.findjob_tt.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration // Đánh dấu đây là file cấu hình hệ thống
public class SecurityConfiguration {

    // Đây chính là cái Bean mà Spring Boot đang tìm kiếm nãy giờ!
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(); // Sử dụng thuật toán mã hóa BCrypt siêu bảo mật
    }

    // Tạm thời chúng ta chỉ cần Bean này để trang Đăng ký hoạt động và lưu được mật
    // khẩu mã hóa.
    // Các cấu hình chặn link, phân quyền (SecurityFilterChain) mình sẽ thêm vào sau
    // khi bạn đăng ký xong User đầu tiên nhé!
}