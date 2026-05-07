package com.findjob_tt.findjob_tt.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Mở cửa cho các file tĩnh mặc định (CSS, JS)
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");

        // BẮC CẦU CHO THƯ MỤC UPLOAD ẢNH
        // Giả sử UploadFileService của bạn lưu ảnh vào thư mục "uploads/job_logos" ở
        // thư mục gốc dự án
        registry.addResourceHandler("/images/job_logos/**")
                .addResourceLocations("file:uploads/job_logos/");

    }
}