package com.findjob_tt.findjob_tt.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.repository.UserRepository;

import java.util.Collections;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        // 1. Tìm User trong Database bằng email
        User user = userRepository.findByEmail(email);
        if (user == null) {
            throw new UsernameNotFoundException("Không tìm thấy tài khoản với email: " + email);
        }

        // 2. Lấy quyền (Role) của User
        // LƯU Ý: Giả sử bảng User của bạn có liên kết với bảng Role
        // (user.getRole().getName())
        // Các Role nên có tên chuẩn như: "ROLE_ADMIN", "ROLE_RECRUITER",
        // "ROLE_CANDIDATE"
        SimpleGrantedAuthority authority = new SimpleGrantedAuthority(user.getRole().getName());

        // 3. Trả về đối tượng User chuẩn của Spring Security
        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPassword(),
                Collections.singletonList(authority));
    }
}