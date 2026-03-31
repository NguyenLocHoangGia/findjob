package com.findjob_tt.findjob_tt.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.findjob_tt.findjob_tt.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByEmail(String email);

    @Query("SELECT MONTH(u.createdAt), COUNT(u) FROM User u WHERE YEAR(u.createdAt) = YEAR(CURRENT_DATE) GROUP BY MONTH(u.createdAt) ORDER BY MONTH(u.createdAt)")
    java.util.List<Object[]> countUsersByMonth();
}
