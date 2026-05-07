package com.findjob_tt.findjob_tt.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.findjob_tt.findjob_tt.model.ParsedCv;

public interface ParsedCvRepository extends JpaRepository<ParsedCv, Long> {
}
