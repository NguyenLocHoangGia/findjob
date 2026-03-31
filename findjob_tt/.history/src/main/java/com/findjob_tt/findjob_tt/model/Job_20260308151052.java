package com.findjob_tt.findjob_tt.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "jobs")
@Data
public class Job {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title; // Tiêu đề (VD: Thực tập sinh Java)
    private String companyName;
    private String salary;
    private String location;

    @Column(columnDefinition = "TEXT") // Dùng TEXT để lưu được văn bản dài
    private String description; // Mô tả công việc

    // Tạm thời bỏ qua các trường phức tạp khác để làm cho nhanh
}