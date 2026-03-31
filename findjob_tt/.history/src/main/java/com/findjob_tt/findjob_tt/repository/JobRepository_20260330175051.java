package com.findjob_tt.findjob_tt.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.findjob_tt.findjob_tt.model.Job;

@Repository
public interface JobRepository extends JpaRepository<Job, Long> {
        @Query("SELECT j FROM Job j WHERE " +
                        "LOWER(j.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "LOWER(j.companyName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "LOWER(j.location) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "LOWER(j.salary) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "LOWER(j.shortDescription) LIKE LOWER(CONCAT('%', :keyword, '%'))")
        List<Job> searchJobsByKeyword(@Param("keyword") String keyword);

        @Query("SELECT j FROM Job j WHERE j.isActive = true " +
                        "AND (:keyword IS NULL OR LOWER(j.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(j.companyName) LIKE LOWER(CONCAT('%', :keyword, '%'))) "
                        +
                        "AND (:location IS NULL OR :location = '' OR j.location LIKE CONCAT('%', :location, '%')) " +
                        "AND (:categoryId IS NULL OR j.category.id = :categoryId) " +
                        "ORDER BY j.createdAt DESC")
        List<Job> searchActiveJobs(@Param("keyword") String keyword, @Param("location") String location,
                        @Param("categoryId") Long categoryId);

        // Cập nhật luôn hàm lấy toàn bộ công việc mặc định (chỉ lấy job đang mở)
        List<Job> findByIsActiveTrueOrderByCreatedAtDesc();

        @Query("SELECT j.category.name, COUNT(j) FROM Job j WHERE j.category IS NOT NULL GROUP BY j.category.name")
        List<Object[]> countJobsByCategory();

        @Query("SELECT MONTH(j.createdAt), COUNT(j) FROM Job j WHERE YEAR(j.createdAt) = YEAR(CURRENT_DATE) GROUP BY MONTH(j.createdAt) ORDER BY MONTH(j.createdAt)")
        List<Object[]> countJobsByMonth();
}