package com.findjob_tt.findjob_tt.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.text.Normalizer;
import java.util.regex.Pattern;

@Service
public class UploadFileService {

    public String handleSaveUploadFile(MultipartFile file, String targetFolder) {
        if (file == null || file.isEmpty()) {
            return "";
        }

        String rootPath = System.getProperty("user.dir") + File.separator + "uploads";

        try {
            File dir = new File(rootPath + File.separator + targetFolder);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String rawFileName = file.getOriginalFilename();

            // BƯỚC NÂNG CẤP: Khử dấu tiếng Việt trước khi dùng Regex
            String noAccent = removeAccents(rawFileName);

            // Loại bỏ tất cả ký tự lạ, chỉ giữ lại chữ, số, dấu chấm và dấu gạch ngang
            String cleanFileName = noAccent.replaceAll("[^a-zA-Z0-9.\\-]", "_");
            String finalName = System.currentTimeMillis() + "_" + cleanFileName;

            File serverFile = new File(dir.getAbsolutePath() + File.separator + finalName);
            file.transferTo(serverFile);

            return finalName;

        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    // Hàm phụ trợ để biến "Tiếng Việt" thành "Tieng Viet"
    private String removeAccents(String s) {
        String temp = Normalizer.normalize(s, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp).replaceAll("").replace('đ', 'd').replace('Đ', 'D');
    }
}