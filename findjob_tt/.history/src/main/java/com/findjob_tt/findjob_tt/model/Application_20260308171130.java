package com.findjob_tt.findjob_tt.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "applications")
@Data
public class Application {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String candidateName; // Tên ứng viên
    private String candidateEmail; // Email liên hệ
    private String cvFileName; // Tên file CV lưu trên ổ cứng (VD: 12345_cv_gia.pdf)

    private LocalDateTime applyDate; // Ngày nộp đơn

    // Mối quan hệ: Nhiều Đơn ứng tuyển (Application) thuộc về 1 Công việc (Job)
    @ManyToOne
    @JoinColumn(name = "job_id")
    private Job job;
}