package com.findjob_tt.findjob_tt.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.findjob_tt.findjob_tt.model.JobRequiredSkill;

public interface JobRequiredSkillRepository extends JpaRepository<JobRequiredSkill, Long> {
    List<JobRequiredSkill> findByJob_IdOrderByDisplayOrderAscIdAsc(Long jobId);

    void deleteByJob_Id(Long jobId);
}
