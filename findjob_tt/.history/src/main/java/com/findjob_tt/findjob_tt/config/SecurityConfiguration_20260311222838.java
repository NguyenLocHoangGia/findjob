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

import jakarta.servlet.DispatcherType;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

    // 1. TIÊM (INJECT) UserDetailsService ĐỂ TÌM LẠI USER KHI RESTART SERVER
    @Autowired
    private UserDetailsService customUserDetailsService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationSuccessHandler customSuccessHandler() {
        return new CustomSuccessHandler();
    }

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
                        .successHandler(customSuccessHandler())
                        .failureUrl("/login?error")
                        .permitAll())

                .rememberMe(remember -> remember
                        .key("jobportal_secret_key_123")
                        .tokenValiditySeconds(7 * 24 * 60 * 60)
                        // 2. KHAI BÁO CHO SPRING BIẾT CHỖ LẤY LẠI THÔNG TIN USER
                        .userDetailsService(customUserDetailsService))

                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")
                        .permitAll());

        return http.build();
    }
}