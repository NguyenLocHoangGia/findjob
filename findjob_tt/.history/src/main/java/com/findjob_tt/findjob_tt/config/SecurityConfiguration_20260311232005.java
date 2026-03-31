package com.findjob_tt.findjob_tt.config;

import org.springframework.beans.factory.annotation.Autowired; // THÊM IMPORT NÀY
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService; // THÊM IMPORT NÀY
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.rememberme.TokenBasedRememberMeServices;

import jakarta.servlet.DispatcherType;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

    // 1. TIÊM (INJECT) UserDetailsService ĐỂ TÌM LẠI USER KHI RESTART SERVER
    @Autowired
    private UserDetailsService customUserDetailsService;

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

    // @Bean
    // public AuthenticationSuccessHandler customSuccessHandler() {
    // return new CustomSuccessHandler();
    // }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(authorize -> authorize
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE).permitAll()
                        .requestMatchers("/", "/register", "/login", "/error", "/css/**", "/js/**", "/images/**")
                        .permitAll()
                        .anyRequest().authenticated())
                .formLogin(formLogin -> formLogin
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .failureUrl("/login?error")
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