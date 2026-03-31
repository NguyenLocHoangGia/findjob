package com.findjob_tt.findjob_tt.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;

@Service
public class UploadService {

    // Thư mục lưu CV sẽ nằm ngay trong thư mục gốc của dự án
    private final String UPLOAD_DIR = System.getProperty("user.dir") + "/uploads/cv/";

    public String saveCV(MultipartFile file) {
        if (file.isEmpty()) {
            return null;
        }
        try {
            // 1. Tạo thư mục nếu chưa tồn tại
            File directory = new File(UPLOAD_DIR);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            // 2. Tạo tên file mới để không bị trùng (Thêm thời gian vào trước tên file)
            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();

            // 3. Đường dẫn lưu file chuẩn xác trên máy tính
            String filePath = UPLOAD_DIR + fileName;

            // 4. Lưu file vào ổ cứng
            file.transferTo(new File(filePath));

            return fileName; // Trả về tên file để lưu vào Database

        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}