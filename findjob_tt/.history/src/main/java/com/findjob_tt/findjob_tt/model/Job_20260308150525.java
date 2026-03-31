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
    private String companyName; // Tên công ty
    private String salary; // Mức lương (VD: 8.000.000 VNĐ)
    private String location; // Địa điểm (VD: Hà Nội)

    // Tạm thời bỏ qua các trường phức tạp khác để làm cho nhanh
}