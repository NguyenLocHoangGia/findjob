package com.findjob_tt.findjob_tt.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "jobs")
@Getter // Tự động sinh toàn bộ Getter
@Setter // Tự động sinh toàn bộ Setter
public class Job {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String salary;

    // Vẫn nên giữ location ở đây vì một công ty có thể tuyển ở nhiều chi nhánh khác
    // nhau (Hà Nội, HCM...)
    private String location;

    @Column(length = 255)
    private String shortDescription;

    @Column(columnDefinition = "TEXT")
    private String description;

    @ManyToOne
    @JoinColumn(name = "user_id") // ID của nhà tuyển dụng
    private User user;

}