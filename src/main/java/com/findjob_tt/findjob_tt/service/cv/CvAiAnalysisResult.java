package com.findjob_tt.findjob_tt.service.cv;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class CvAiAnalysisResult {

    @JsonProperty("parsed_cv")
    private ParsedCvData parsedCv;

    @JsonProperty("parsed_cv_skills")
    private List<String> parsedCvSkills = new ArrayList<>();

    @JsonProperty("cv_score")
    private CvScoreData cvScore;

    public ParsedCvData getParsedCv() {
        return parsedCv;
    }

    public void setParsedCv(ParsedCvData parsedCv) {
        this.parsedCv = parsedCv;
    }

    public List<String> getParsedCvSkills() {
        return parsedCvSkills;
    }

    public void setParsedCvSkills(List<String> parsedCvSkills) {
        this.parsedCvSkills = parsedCvSkills;
    }

    public CvScoreData getCvScore() {
        return cvScore;
    }

    public void setCvScore(CvScoreData cvScore) {
        this.cvScore = cvScore;
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class ParsedCvData {
        @JsonProperty("full_name")
        private String fullName;
        private String email;
        private String phone;
        private String address;
        private String summary;
        private String education;
        private String experience;

        public String getFullName() {
            return fullName;
        }

        public void setFullName(String fullName) {
            this.fullName = fullName;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public String getAddress() {
            return address;
        }

        public void setAddress(String address) {
            this.address = address;
        }

        public String getSummary() {
            return summary;
        }

        public void setSummary(String summary) {
            this.summary = summary;
        }

        public String getEducation() {
            return education;
        }

        public void setEducation(String education) {
            this.education = education;
        }

        public String getExperience() {
            return experience;
        }

        public void setExperience(String experience) {
            this.experience = experience;
        }
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class CvScoreData {
        @JsonProperty("job_id")
        private Long jobId;

        @JsonProperty("application_id")
        private Long applicationId;

        @JsonProperty("skill_score")
        private BigDecimal skillScore;

        @JsonProperty("project_score")
        private BigDecimal projectScore;

        @JsonProperty("education_score")
        private BigDecimal educationScore;

        @JsonProperty("completeness_score")
        private BigDecimal completenessScore;

        @JsonProperty("bonus_score")
        private BigDecimal bonusScore;

        @JsonProperty("penalty_score")
        private BigDecimal penaltyScore;

        @JsonProperty("total_score")
        private BigDecimal totalScore;

        @JsonProperty("match_level")
        private String matchLevel;

        public Long getJobId() {
            return jobId;
        }

        public void setJobId(Long jobId) {
            this.jobId = jobId;
        }

        public Long getApplicationId() {
            return applicationId;
        }

        public void setApplicationId(Long applicationId) {
            this.applicationId = applicationId;
        }

        public BigDecimal getSkillScore() {
            return skillScore;
        }

        public void setSkillScore(BigDecimal skillScore) {
            this.skillScore = skillScore;
        }

        public BigDecimal getProjectScore() {
            return projectScore;
        }

        public void setProjectScore(BigDecimal projectScore) {
            this.projectScore = projectScore;
        }

        public BigDecimal getEducationScore() {
            return educationScore;
        }

        public void setEducationScore(BigDecimal educationScore) {
            this.educationScore = educationScore;
        }

        public BigDecimal getCompletenessScore() {
            return completenessScore;
        }

        public void setCompletenessScore(BigDecimal completenessScore) {
            this.completenessScore = completenessScore;
        }

        public BigDecimal getBonusScore() {
            return bonusScore;
        }

        public void setBonusScore(BigDecimal bonusScore) {
            this.bonusScore = bonusScore;
        }

        public BigDecimal getPenaltyScore() {
            return penaltyScore;
        }

        public void setPenaltyScore(BigDecimal penaltyScore) {
            this.penaltyScore = penaltyScore;
        }

        public BigDecimal getTotalScore() {
            return totalScore;
        }

        public void setTotalScore(BigDecimal totalScore) {
            this.totalScore = totalScore;
        }

        public String getMatchLevel() {
            return matchLevel;
        }

        public void setMatchLevel(String matchLevel) {
            this.matchLevel = matchLevel;
        }
    }
}
