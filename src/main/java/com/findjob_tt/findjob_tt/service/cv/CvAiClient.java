package com.findjob_tt.findjob_tt.service.cv;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.time.Duration;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.findjob_tt.findjob_tt.model.JobRequiredSkill;

import tools.jackson.databind.ObjectMapper;

@Component
public class CvAiClient {

    private final CvAiProperties properties;
    private final CvAiResponseParser responseParser;
    private final ObjectMapper objectMapper;

    public CvAiClient(CvAiProperties properties, CvAiResponseParser responseParser, ObjectMapper objectMapper) {
        this.properties = properties;
        this.responseParser = responseParser;
        this.objectMapper = objectMapper;
    }

    public CvAiAnalysisResult analyze(CvScoringContext context) throws Exception {
        byte[] pdfBytes = Files.readAllBytes(context.cvPath());
        String pdfBase64 = Base64.getEncoder().encodeToString(pdfBytes);
        String payload = objectMapper.writeValueAsString(buildPayload(context, pdfBase64));

        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(properties.getTimeoutSeconds()))
                .build();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(normalizedBaseUrl() + "/responses"))
                .timeout(Duration.ofSeconds(properties.getTimeoutSeconds()))
                .header("Authorization", "Bearer " + properties.getApiKey())
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(payload))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IllegalStateException("AI API trả lỗi HTTP " + response.statusCode() + ": " + response.body());
        }

        return responseParser.parseResponseBody(response.body());
    }

    private Map<String, Object> buildPayload(CvScoringContext context, String pdfBase64) {
        Map<String, Object> fileContent = new LinkedHashMap<>();
        fileContent.put("type", "input_file");
        fileContent.put("filename", context.cvFileName());
        fileContent.put("file_data", "data:application/pdf;base64," + pdfBase64);

        Map<String, Object> textContent = new LinkedHashMap<>();
        textContent.put("type", "input_text");
        textContent.put("text", buildPrompt(context));

        Map<String, Object> message = new LinkedHashMap<>();
        message.put("role", "user");
        message.put("content", List.of(fileContent, textContent));

        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("model", properties.getModel());
        payload.put("input", List.of(message));
        return payload;
    }

    private String buildPrompt(CvScoringContext context) {
        return """
                Hãy đọc file PDF CV này, trích xuất thông tin và chấm điểm CV theo công việc đang ứng tuyển.
                Bắt buộc chỉ trả về duy nhất một JSON hợp lệ, không dùng markdown, không bọc trong ```json, không giải thích, không ghi thêm bất kỳ chữ nào ngoài JSON.

                Thông tin job:
                - job_id: %s
                - application_id: %s
                - title: %s
                - company_name: %s
                - category: %s
                - location: %s
                - salary: %s
                - short_description: %s
                - description: %s
                - job_required_skills: %s

                Thông tin candidate hiện có trong hệ thống:
                - full_name: %s
                - email: %s
                - phone: %s
                - address: %s
                - profile_description: %s

                JSON phải đúng theo cấu trúc sau:
                {
                  "parsed_cv": {
                    "full_name": "string_or_null",
                    "email": "string_or_null",
                    "phone": "string_or_null",
                    "address": "string_or_null",
                    "summary": "string_or_null",
                    "education": "string_or_null",
                    "experience": "string_or_null"
                  },
                  "parsed_cv_skills": [
                    "skill_1",
                    "skill_2"
                  ],
                  "cv_score": {
                    "job_id": %s,
                    "application_id": %s,
                    "skill_score": 0,
                    "project_score": 0,
                    "education_score": 0,
                    "completeness_score": 0,
                    "bonus_score": 0,
                    "penalty_score": 0,
                    "total_score": 0,
                    "match_level": "VERY_FIT"
                  },
                  "score_details": {
                    "matched_required": 0,
                    "total_required": 0,
                    "matched_preferred": 0,
                    "total_preferred": 0,
                    "relevant_projects": 0,
                    "tech_match": 0,
                    "is_relevant_major": false,
                    "has_certificate_or_course": false,
                    "has_gpa_or_english": false,
                    "has_full_name": false,
                    "has_email": false,
                    "has_phone": false,
                    "has_address": false,
                    "has_summary": false,
                    "has_project_or_experience": false,
                    "has_git": false,
                    "has_scrum": false,
                    "has_english": false,
                    "has_strengths": false,
                    "missing_email_or_phone": false,
                    "no_project": false,
                    "few_skills": false
                  }
                }

                Công thức chấm điểm:
                SkillScore = (matchedRequired / totalRequired) * 30 + (matchedPreferred / totalPreferred) * 10.
                Khi có job_required_skills, hãy tính matchedRequired/matchedPreferred từ danh sách đó, ưu tiên REQUIRED hơn PREFERRED, xét weight 1-10 và min_years nếu CV có thông tin năm kinh nghiệm. must_have là kỹ năng bắt buộc; nếu thiếu must_have thì tăng PenaltyScore và không nên xếp VERY_FIT dù các phần khác tốt.
                Khi job_required_skills rỗng, fallback suy luận kỹ năng required/preferred từ description như cách chấm thông thường.
                ProjectScore = min(relevantProjects * 8 + techMatch * 3, 25)
                EducationScore = (đúng chuyên ngành ? 4 : 0) + (có khóa học/chứng chỉ ? 3 : 0) + (có GPA/English ? 3 : 0)
                CompletenessScore = (fullName ? 3 : 0) + (email ? 2 : 0) + (phone ? 2 : 0) + (address ? 2 : 0) + (summary ? 3 : 0) + (project/experience ? 3 : 0)
                BonusScore = (Git ? 3 : 0) + (Scrum ? 2 : 0) + (English ? 2 : 0) + (điểm mạnh ? 3 : 0)
                PenaltyScore = (thiếu email/phone ? 5 : 0) + (không có project ? 3 : 0) + (skill ít ? 2 : 0)
                TotalScore = clamp(SkillScore + ProjectScore + EducationScore + CompletenessScore + BonusScore - PenaltyScore, 0, 100)

                Phân loại:
                - >= 85 => VERY_FIT
                - >= 70 => FIT
                - >= 50 => PARTIAL
                - < 50 => LOW

                Yêu cầu:
                - Không trả về raw_text.
                - Nếu thiếu dữ liệu thì dùng null với field text, false với field boolean, 0 với field number.
                - parsed_cv_skills chỉ là mảng string tên kỹ năng.
                - Ưu tiên match kỹ năng theo job_required_skills đã chuẩn hóa lowercase; có thể coi biến thể tương đương như "springboot" và "spring boot" là cùng kỹ năng nếu ngữ cảnh rõ ràng.
                - REQUIRED thiếu nhiều hoặc thiếu must_have phải ảnh hưởng rõ vào penalty_score và match_level.
                - total_score phải nằm trong khoảng 0 đến 100.
                - match_level chỉ được là một trong 4 giá trị: VERY_FIT, FIT, PARTIAL, LOW.
                - Chỉ trả về JSON, không thêm bất cứ nội dung nào khác.
                """.formatted(
                safe(context.jobId()),
                safe(context.applicationId()),
                safe(context.jobTitle()),
                safe(context.companyName()),
                safe(context.categoryName()),
                safe(context.location()),
                safe(context.salary()),
                safe(context.shortDescription()),
                safe(context.jobDescription()),
                formatRequiredSkills(context.requiredSkills()),
                safe(context.candidateFullName()),
                safe(context.candidateEmail()),
                safe(context.candidatePhone()),
                safe(context.candidateAddress()),
                safe(context.candidateDescription()),
                safe(context.jobId()),
                safe(context.applicationId()));
    }

    private String formatRequiredSkills(List<JobRequiredSkill> skills) {
        if (skills == null || skills.isEmpty()) {
            return "[]";
        }

        List<Map<String, Object>> payload = skills.stream()
                .map(skill -> {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("skill_name", skill.getSkillName());
                    item.put("skill_type", skill.getSkillType());
                    item.put("min_years", skill.getMinYears());
                    item.put("weight", skill.getWeight());
                    item.put("must_have", skill.getMustHave());
                    item.put("display_order", skill.getDisplayOrder());
                    return item;
                })
                .toList();

        try {
            return objectMapper.writeValueAsString(payload);
        } catch (Exception ex) {
            return "[]";
        }
    }

    private String normalizedBaseUrl() {
        return properties.getBaseUrl().replaceAll("/+$", "");
    }

    private String safe(Object value) {
        return value == null ? "null" : value.toString();
    }
}
