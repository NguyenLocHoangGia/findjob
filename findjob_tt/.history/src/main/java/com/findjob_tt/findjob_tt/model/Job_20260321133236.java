package com.findjob_tt.findjob_tt.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "jobs")
@Getter
@Setter
public class Job {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String salary;
    private String companyName;
    private String logo;
    private String location;

    @Column(length = 255)
    private String shortDescription;

    @Column(columnDefinition = "TEXT")
    private String description;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    // Quan trọng: cascade = CascadeType.ALL giúp xóa Job là xóa sạch Application
    // của Job đó
    @OneToMany(mappedBy = "job", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Application> applications;

    private LocalDateTime createdAt;

    @Column(name = "is_active")
    private Boolean isActive = true;

    // Thêm hàm Getter tùy chỉnh này để đảm bảo các record cũ bị null sẽ mặc định
    // hiểu là đang mở (true)
    public Boolean getIsActive() {
        if (this.isActive == null) {
            return true;
        }
        return this.isActive;
    }

    // Tự động gán ngày giờ khi tạo mới công việc
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    // Fix lỗi 500: JSP sẽ gọi được thuộc tính này
    public String getFormattedCreatedAt() {
        if (this.createdAt == null)
            return "Vừa xong";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
        return this.createdAt.format(formatter);
    }
}