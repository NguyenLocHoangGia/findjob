package com.findjob_tt.findjob_tt.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Biến thư mục vật lý "uploads/cv" thành một đường link web "/uploads/cv/**"
        String cvUploadPath = "file:" + System.getProperty("user.dir") + "/uploads/cv/";

        registry.addResourceHandler("/uploads/cv/**")
                .addResourceLocations(cvUploadPath);
    }
}