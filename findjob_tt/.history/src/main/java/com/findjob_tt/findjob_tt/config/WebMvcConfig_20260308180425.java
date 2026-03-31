package com.findjob_tt.findjob_tt.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Ánh xạ toàn bộ thư mục "uploads" vật lý ra đường link "/uploads/**"
        // Như vậy nó sẽ nhận diện được cả /uploads/cv/... và /uploads/logo/...
        String uploadPath = "file:" + System.getProperty("user.dir") + "/uploads/";

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadPath);
    }
}