package com.findjob_tt.findjob_tt.service.cv;

import java.nio.file.Path;
import java.util.List;

import com.findjob_tt.findjob_tt.model.JobRequiredSkill;

public record CvScoringContext(
        Long applicationId,
        Long jobId,
        String cvFileName,
        Path cvPath,
        String jobTitle,
        String companyName,
        String categoryName,
        String location,
        String salary,
        String shortDescription,
        String jobDescription,
        List<JobRequiredSkill> requiredSkills,
        String candidateFullName,
        String candidateEmail,
        String candidatePhone,
        String candidateAddress,
        String candidateDescription) {
}
