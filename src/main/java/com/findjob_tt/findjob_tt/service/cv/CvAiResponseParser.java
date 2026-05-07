package com.findjob_tt.findjob_tt.service.cv;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

@Component
public class CvAiResponseParser {

    private final ObjectMapper objectMapper;

    public CvAiResponseParser(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    public CvAiAnalysisResult parseResponseBody(String responseBody) throws Exception {
        JsonNode responseJson = objectMapper.readTree(responseBody);
        String rawText = extractJsonText(responseJson);
        String cleanedText = cleanJsonText(rawText);
        return objectMapper.readValue(cleanedText, CvAiAnalysisResult.class);
    }

    private String extractJsonText(JsonNode responseJson) {
        JsonNode outputText = responseJson.get("output_text");
        if (outputText != null && outputText.isTextual() && StringUtils.hasText(outputText.asText())) {
            return outputText.asText().trim();
        }

        List<String> textParts = new ArrayList<>();
        JsonNode output = responseJson.get("output");
        if (output != null && output.isArray()) {
            for (JsonNode item : output) {
                JsonNode contents = item.get("content");
                if (contents == null || !contents.isArray()) {
                    continue;
                }
                for (JsonNode content : contents) {
                    String type = content.path("type").asText("");
                    JsonNode text = content.get("text");
                    if (("output_text".equals(type) || "text".equals(type))
                            && text != null
                            && text.isTextual()
                            && StringUtils.hasText(text.asText())) {
                        textParts.add(text.asText());
                    }
                }
            }
        }

        String merged = String.join("\n", textParts).trim();
        if (StringUtils.hasText(merged)) {
            return merged;
        }

        throw new IllegalArgumentException("Không tìm thấy text output trong response AI");
    }

    private String cleanJsonText(String rawText) {
        String text = rawText == null ? "" : rawText.trim();
        text = text.replaceFirst("(?is)^```json\\s*", "");
        text = text.replaceFirst("(?is)^```\\s*", "");
        text = text.replaceFirst("(?is)\\s*```$", "");

        int start = text.indexOf('{');
        int end = text.lastIndexOf('}');
        if (start >= 0 && end > start) {
            text = text.substring(start, end + 1);
        }

        if (!StringUtils.hasText(text)) {
            throw new IllegalArgumentException("Response AI không chứa JSON hợp lệ");
        }

        return text.trim();
    }
}
