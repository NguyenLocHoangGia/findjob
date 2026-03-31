package com.findjob_tt.findjob_tt.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.findjob_tt.findjob_tt.model.Job;

@Repository
public interface JobRepository extends JpaRepository<Job, Long> {
}