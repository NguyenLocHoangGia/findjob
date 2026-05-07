package com.findjob_tt.findjob_tt.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

@Entity
@Table(name = "cv_scores")
public class CvScore {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "parsed_cv_id", nullable = false)
    private ParsedCv parsedCv;

    @ManyToOne
    @JoinColumn(name = "job_id", nullable = false)
    private Job job;

    @OneToOne
    @JoinColumn(name = "application_id", nullable = false, unique = true)
    private Application application;

    @Column(name = "skill_score", precision = 5, scale = 2)
    private BigDecimal skillScore;

    @Column(name = "project_score", precision = 5, scale = 2)
    private BigDecimal projectScore;

    @Column(name = "education_score", precision = 5, scale = 2)
    private BigDecimal educationScore;

    @Column(name = "completeness_score", precision = 5, scale = 2)
    private BigDecimal completenessScore;

    @Column(name = "bonus_score", precision = 5, scale = 2)
    private BigDecimal bonusScore;

    @Column(name = "penalty_score", precision = 5, scale = 2)
    private BigDecimal penaltyScore;

    @Column(name = "total_score", precision = 5, scale = 2)
    private BigDecimal totalScore;

    @Column(name = "match_level", length = 20)
    private String matchLevel;

    @Column(name = "scored_at")
    private LocalDateTime scoredAt;

    @PrePersist
    protected void onCreate() {
        if (scoredAt == null) {
            scoredAt = LocalDateTime.now();
        }
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ParsedCv getParsedCv() {
        return parsedCv;
    }

    public void setParsedCv(ParsedCv parsedCv) {
        this.parsedCv = parsedCv;
    }

    public Job getJob() {
        return job;
    }

    public void setJob(Job job) {
        this.job = job;
    }

    public Application getApplication() {
        return application;
    }

    public void setApplication(Application application) {
        this.application = application;
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

    public LocalDateTime getScoredAt() {
        return scoredAt;
    }

    public void setScoredAt(LocalDateTime scoredAt) {
        this.scoredAt = scoredAt;
    }
}
