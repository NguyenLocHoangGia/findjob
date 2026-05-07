package com.findjob_tt.findjob_tt.service.cv;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import tools.jackson.databind.ObjectMapper;

class CvAiResponseParserTest {

    private final CvAiResponseParser parser = new CvAiResponseParser(new ObjectMapper());

    @Test
    void parseOutputTextWithCodeFence() throws Exception {
        String response = """
                {
                  "output_text": "```json\\n{\\n  \\"parsed_cv\\": { \\"full_name\\": \\"Nguyen Van A\\" },\\n  \\"parsed_cv_skills\\": [\\"Java\\"],\\n  \\"cv_score\\": { \\"total_score\\": 88, \\"match_level\\": \\"VERY_FIT\\" }\\n}\\n```"
                }
                """;

        CvAiAnalysisResult result = parser.parseResponseBody(response);

        assertEquals("Nguyen Van A", result.getParsedCv().getFullName());
        assertEquals("Java", result.getParsedCvSkills().get(0));
        assertEquals("VERY_FIT", result.getCvScore().getMatchLevel());
    }

    @Test
    void parseOutputContentWithExtraText() throws Exception {
        String response = """
                {
                  "output": [
                    {
                      "content": [
                        {
                          "type": "output_text",
                          "text": "Đây là kết quả:\\n{\\n  \\"parsed_cv\\": { \\"email\\": \\"a@example.com\\" },\\n  \\"parsed_cv_skills\\": [],\\n  \\"cv_score\\": { \\"total_score\\": 51, \\"match_level\\": \\"PARTIAL\\" }\\n}\\nCảm ơn"
                        }
                      ]
                    }
                  ]
                }
                """;

        CvAiAnalysisResult result = parser.parseResponseBody(response);

        assertEquals("a@example.com", result.getParsedCv().getEmail());
        assertEquals("PARTIAL", result.getCvScore().getMatchLevel());
    }
}
