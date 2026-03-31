package com.findjob_tt.findjob_tt.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository;

@RestController // Quan trọng: Trả về JSON, không trả về View JSP
@RequestMapping("/api/admin")
public class AdminRestController {

    @Autowired
    private JobRepository jobRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ApplicationRepository applicationRepository;

    @GetMapping("/chart/categories")
    public ResponseEntity<Map<String, Object>> getCategoryChartData() {
        // Gọi hàm truy vấn bạn vừa tạo ở bước 2
        List<Object[]> results = jobRepository.countJobsByCategory();

        List<String> labels = new ArrayList<>();
        List<Long> values = new ArrayList<>();

        // Tách dữ liệu ra thành 2 mảng: 1 mảng tên ngành, 1 mảng con số
        for (Object[] row : results) {
            labels.add((String) row[0]); // Tên ngành (VD: IT - Phần mềm)
            values.add((Long) row[1]); // Số lượng tin tuyển dụng (VD: 5)
        }

        // Đóng gói thành dạng JSON (Map) để Javascript dễ đọc
        Map<String, Object> response = new HashMap<>();
        response.put("labels", labels);
        response.put("values", values);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/chart/growth")
    public ResponseEntity<Map<String, Object>> getGrowthChartData(
            @RequestParam(defaultValue = "month") String viewType) {
        Map<String, Object> response = new HashMap<>();

        List<String> labels = new ArrayList<>();
        List<Long> users = new ArrayList<>();
        List<Long> jobs = new ArrayList<>();
        List<Long> cvs = new ArrayList<>();

        if ("month".equals(viewType)) {
            // Labels cho tháng
            for (int i = 1; i <= 12; i++) {
                labels.add("Tháng " + i);
            }

            // Dữ liệu users
            List<Object[]> userResults = userRepository.countUsersByMonth();
            Map<Integer, Long> userMap = new HashMap<>();
            for (Object[] row : userResults) {
                userMap.put((Integer) row[0], (Long) row[1]);
            }
            for (int i = 1; i <= 12; i++) {
                users.add(userMap.getOrDefault(i, 0L));
            }

            // Dữ liệu jobs
            List<Object[]> jobResults = jobRepository.countJobsByMonth();
            Map<Integer, Long> jobMap = new HashMap<>();
            for (Object[] row : jobResults) {
                jobMap.put((Integer) row[0], (Long) row[1]);
            }
            for (int i = 1; i <= 12; i++) {
                jobs.add(jobMap.getOrDefault(i, 0L));
            }

            // Dữ liệu applications
            List<Object[]> appResults = applicationRepository.countApplicationsByMonth();
            Map<Integer, Long> appMap = new HashMap<>();
            for (Object[] row : appResults) {
                appMap.put((Integer) row[0], (Long) row[1]);
            }
            for (int i = 1; i <= 12; i++) {
                cvs.add(appMap.getOrDefault(i, 0L));
            }
        } else if ("day".equals(viewType)) {
            // Tương tự cho ngày trong tuần, nhưng đơn giản hóa, giả sử tuần hiện tại
            labels = List.of("Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "CN");
            // Để đơn giản, set 0 hoặc tính toán phức tạp hơn
            for (int i = 0; i < 7; i++) {
                users.add(0L);
                jobs.add(0L);
                cvs.add(0L);
            }
        }

        response.put("labels", labels);
        response.put("users", users);
        response.put("jobs", jobs);
        response.put("cvs", cvs);

        return ResponseEntity.ok(response);
    }
}