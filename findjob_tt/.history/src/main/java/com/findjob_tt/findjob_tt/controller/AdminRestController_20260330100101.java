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
}