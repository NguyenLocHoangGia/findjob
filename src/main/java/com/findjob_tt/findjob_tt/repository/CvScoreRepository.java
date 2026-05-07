package com.findjob_tt.findjob_tt.repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.findjob_tt.findjob_tt.model.CvScore;

public interface CvScoreRepository extends JpaRepository<CvScore, Long> {

    Optional<CvScore> findByApplication_Id(Long applicationId);

    List<CvScore> findByApplication_IdIn(Collection<Long> applicationIds);
}
