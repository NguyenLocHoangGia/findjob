package com.findjob_tt.findjob_tt.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.findjob_tt.findjob_tt.model.Notification;

public interface NotificationRepository extends JpaRepository<Notification, Long> {

}
