package com.findjob_tt.findjob_tt.service.cv;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
@ConfigurationProperties(prefix = "cv.ai")
public class CvAiProperties {

    private String baseUrl = "https://openai.phongdaynai.id.vn/v1";
    private String apiKey = "";
    private String model = "gpt-5.2";
    private int timeoutSeconds = 300;

    public boolean hasApiKey() {
        return StringUtils.hasText(apiKey);
    }

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public String getApiKey() {
        return apiKey;
    }

    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public int getTimeoutSeconds() {
        return timeoutSeconds;
    }

    public void setTimeoutSeconds(int timeoutSeconds) {
        this.timeoutSeconds = timeoutSeconds;
    }
}
