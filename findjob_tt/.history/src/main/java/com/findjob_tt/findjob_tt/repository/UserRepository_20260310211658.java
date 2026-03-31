package com.findjob_tt.findjob_tt.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.findjob_tt.findjob_tt.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByEmail(String email);
}
