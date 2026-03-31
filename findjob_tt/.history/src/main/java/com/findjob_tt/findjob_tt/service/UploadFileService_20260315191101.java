package com.findjob_tt.findjob_tt.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;

@Service
public class UploadFileService {

    // Kế thừa tư duy truyền targetFolder từ code cũ của bạn
    public String handleSaveUploadFile(MultipartFile file, String targetFolder) {

        if (file.isEmpty()) {
            return "";
        }

        // Dữ liệu sẽ sống sót qua mọi lần Restart server
        String rootPath = System.getProperty("user.dir") + "/uploads";

        try {
            File dir = new File(rootPath + File.separator + targetFolder);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // Giữ nguyên logic nối thời gian vào tên file để chống trùng lặp
            String rawFileName = file.getOriginalFilename();
            // Loại bỏ dấu tiếng Việt, đổi khoảng trắng thành dấu gạch dưới
            String cleanFileName = rawFileName.replaceAll("[^a-zA-Z0-9.\\-]", "_");
            String finalName = System.currentTimeMillis() + "_" + cleanFileName;
            File serverFile = new File(dir.getAbsolutePath() + File.separator + finalName);

            // TỐI ƯU CODE: Thay 5 dòng code Stream cũ bằng đúng 1 dòng này của Spring Boot
            file.transferTo(serverFile);

            return finalName;

        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}