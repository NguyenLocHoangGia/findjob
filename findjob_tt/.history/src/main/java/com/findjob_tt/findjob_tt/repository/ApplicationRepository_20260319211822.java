package com.findjob_tt.findjob_tt.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.User;

public interface ApplicationRepository extends JpaRepository<Application, Long> {

    // Kiểm tra xem ứng viên đã ứng tuyển công việc này và chưa được xử lý hay chưa
    boolean existsByUserAndJobAndStatus(User user, Job job, String status);

    // Hoặc kiểm tra xem có đơn ứng tuyển nào "đang hoạt động" không (chưa bị xóa/từ
    // chối)
    @Query("SELECT COUNT(a) > 0 FROM Application a WHERE a.user = :user AND a.job = :job AND a.status = 'PENDING'")
    boolean isApplicationPending(@Param("user") User user, @Param("job") Job job);

}
