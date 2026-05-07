package com.findjob_tt.findjob_tt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.findjob_tt.findjob_tt.repository.JobRepository;

public class AdminGlobalAdvice {
    @Autowired
    private JobRepository jobRepository;

    // Biến này sẽ luôn có mặt trong mọi file JSP của Admin
    @ModelAttribute("pendingJobsCount")
    public long getPendingJobsCount() {
        return jobRepository.countByStatus("PENDING");
    }
}
