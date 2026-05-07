package com.findjob_tt.findjob_tt.repository;

import com.findjob_tt.findjob_tt.model.Notification;
import com.findjob_tt.findjob_tt.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    // Tự động tìm thông báo theo User và sắp xếp theo thời gian tạo mới nhất lên
    // đầu
    List<Notification> findByUserOrderByCreatedAtDesc(User user);

    // Thêm hàm này nếu bạn muốn đếm số thông báo chưa đọc để hiện ở icon chuông
    long countByUserAndIsReadFalse(User user);

}