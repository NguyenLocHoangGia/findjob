package com.findjob_tt.findjob_tt.repository;

import com.findjob_tt.findjob_tt.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
}