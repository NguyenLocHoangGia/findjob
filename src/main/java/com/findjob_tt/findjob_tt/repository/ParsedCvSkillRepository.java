package com.findjob_tt.findjob_tt.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.findjob_tt.findjob_tt.model.ParsedCvSkill;

public interface ParsedCvSkillRepository extends JpaRepository<ParsedCvSkill, Long> {

    void deleteByParsedCv_Id(Long parsedCvId);

    List<ParsedCvSkill> findByParsedCv_Id(Long parsedCvId);
}
