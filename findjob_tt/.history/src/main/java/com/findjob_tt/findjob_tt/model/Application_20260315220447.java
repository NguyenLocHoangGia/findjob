package com.findjob_tt.findjob_tt.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "applications")
@Getter
@Setter
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

    // Mối quan hệ: Nhiều Đơn ứng tuyển (Application) thuộc về 1 Ứng viên (User)
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private LocalDateTime createdAt; // Ngày đăng tin

    private String status; // "PENDING" (Chờ), "APPROVED" (Đồng ý), "REJECTED" (Từ chối)

    // Hàm này sẽ tự động chuyển đổi thời gian nguyên thủy thành chuỗi dễ đọc
    public String getFormattedApplyDate() {
        if (this.applyDate == null)
            return "";
        // Cấu hình mẫu định dạng: HH (giờ 24h), mm (phút), dd (ngày), MM (tháng), yyyy
        // (năm)
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
        return this.applyDate.format(formatter);
    }
}