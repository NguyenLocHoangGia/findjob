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

    // THÊM TRƯỜNG MỚI: Mô tả ngắn (Dành cho trang chủ)
    @Column(length = 255) // Giới hạn 255 ký tự cho ngắn gọn
    private String shortDescription;

    // Giữ nguyên trường cũ: Mô tả chi tiết (Dành cho trang Detail)
    @Column(columnDefinition = "TEXT")
    private String description;
}