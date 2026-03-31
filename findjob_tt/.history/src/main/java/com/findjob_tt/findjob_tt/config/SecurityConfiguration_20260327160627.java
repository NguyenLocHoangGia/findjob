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
                                                .requestMatchers("/", "/register", "/login", "/error", "/css/**",
                                                                "/js/**", "/images/**", "/uploads/**")
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
                                .rememberMe(remember -> remember
                                                .rememberMeServices(rememberMeServices()))
                                .logout(logout -> logout
                                                .logoutUrl("/logout")
                                                .logoutSuccessUrl("/login?logout")
                                                .permitAll())

                                // Báo cho Security biết dùng cuốn sổ SessionRegistry
                                .sessionManagement(session -> session
                                                .maximumSessions(1) // Mỗi user chỉ được đăng nhập 1 nơi (Tùy chọn)
                                                .sessionRegistry(sessionRegistry()))

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