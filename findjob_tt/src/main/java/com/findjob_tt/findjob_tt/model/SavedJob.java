package com.findjob_tt.findjob_tt.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity // BẮT BUỘC PHẢI CÓ DÒNG NÀY ĐỂ HIBERNATE NHẬN DIỆN
@Table(name = "saved_jobs")
@Getter
@Setter
public class SavedJob {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Mối quan hệ: 1 Ứng viên (User) có thể lưu nhiều Job
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    // Mối quan hệ: 1 Công việc (Job) có thể được lưu bởi nhiều Ứng viên
    @ManyToOne
    @JoinColumn(name = "job_id")
    private Job job;

}