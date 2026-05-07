package com.findjob_tt.findjob_tt.service.cv;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.findjob_tt.findjob_tt.model.Application;
import com.findjob_tt.findjob_tt.model.CandidateProfile;
import com.findjob_tt.findjob_tt.model.CvScore;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.JobRequiredSkill;
import com.findjob_tt.findjob_tt.model.ParsedCv;
import com.findjob_tt.findjob_tt.model.ParsedCvSkill;
import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.CvScoreRepository;
import com.findjob_tt.findjob_tt.repository.JobRequiredSkillRepository;
import com.findjob_tt.findjob_tt.repository.ParsedCvRepository;
import com.findjob_tt.findjob_tt.repository.ParsedCvSkillRepository;

@Service
public class CvScoringPersistenceService {

    private static final BigDecimal ZERO = BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
    private static final BigDecimal HUNDRED = BigDecimal.valueOf(100).setScale(2, RoundingMode.HALF_UP);

    private final ApplicationRepository applicationRepository;
    private final CvScoreRepository cvScoreRepository;
    private final ParsedCvRepository parsedCvRepository;
    private final ParsedCvSkillRepository parsedCvSkillRepository;
    private final JobRequiredSkillRepository jobRequiredSkillRepository;

    public CvScoringPersistenceService(
            ApplicationRepository applicationRepository,
            CvScoreRepository cvScoreRepository,
            ParsedCvRepository parsedCvRepository,
            ParsedCvSkillRepository parsedCvSkillRepository,
            JobRequiredSkillRepository jobRequiredSkillRepository) {
        this.applicationRepository = applicationRepository;
        this.cvScoreRepository = cvScoreRepository;
        this.parsedCvRepository = parsedCvRepository;
        this.parsedCvSkillRepository = parsedCvSkillRepository;
        this.jobRequiredSkillRepository = jobRequiredSkillRepository;
    }

    @Transactional(readOnly = true)
    public CvScoringContext buildContext(Long applicationId) {
        Application application = applicationRepository.findById(applicationId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy application id=" + applicationId));

        Job job = application.getJob();
        User user = application.getUser();
        CandidateProfile profile = user != null ? user.getCandidateProfile() : null;

        String cvFileName = application.getCvFileName();
        if (!StringUtils.hasText(cvFileName) && profile != null) {
            cvFileName = profile.getCvUrl();
        }
        if (!StringUtils.hasText(cvFileName)) {
            throw new IllegalStateException("Application không có file CV để chấm điểm");
        }

        Path cvPath = Path.of(System.getProperty("user.dir"), "uploads", "cv_files", cvFileName);
        if (!Files.isRegularFile(cvPath)) {
            throw new IllegalStateException("Không tìm thấy file CV: " + cvPath);
        }

        List<JobRequiredSkill> requiredSkills = job != null
                ? jobRequiredSkillRepository.findByJob_IdOrderByDisplayOrderAscIdAsc(job.getId())
                : List.of();

        return new CvScoringContext(
                application.getId(),
                job != null ? job.getId() : null,
                cvFileName,
                cvPath,
                job != null ? job.getTitle() : null,
                job != null ? job.getCompanyName() : null,
                job != null && job.getCategory() != null ? job.getCategory().getName() : null,
                job != null ? job.getLocation() : null,
                job != null ? job.getSalary() : null,
                job != null ? job.getShortDescription() : null,
                job != null ? job.getDescription() : null,
                requiredSkills,
                user != null ? user.getFullName() : null,
                user != null ? user.getEmail() : null,
                user != null ? user.getPhone() : null,
                profile != null ? profile.getAddress() : null,
                profile != null ? profile.getDescription() : null);
    }

    @Transactional
    public void saveResult(Long applicationId, CvAiAnalysisResult result) {
        if (result == null || result.getCvScore() == null) {
            throw new IllegalArgumentException("AI response thiếu cv_score");
        }

        Application application = applicationRepository.findById(applicationId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy application id=" + applicationId));

        CvScore score = cvScoreRepository.findByApplication_Id(applicationId).orElseGet(CvScore::new);
        ParsedCv parsedCv = score.getParsedCv() != null ? score.getParsedCv() : new ParsedCv();
        CvAiAnalysisResult.ParsedCvData parsedData = result.getParsedCv();

        parsedCv.setUser(application.getUser());
        parsedCv.setSourceCvFile(application.getCvFileName());
        if (parsedData != null) {
            parsedCv.setFullName(trimToNull(parsedData.getFullName()));
            parsedCv.setEmail(trimToNull(parsedData.getEmail()));
            parsedCv.setPhone(trimToNull(parsedData.getPhone()));
            parsedCv.setAddress(trimToNull(parsedData.getAddress()));
            parsedCv.setSummary(trimToNull(parsedData.getSummary()));
            parsedCv.setEducation(trimToNull(parsedData.getEducation()));
            parsedCv.setExperience(trimToNull(parsedData.getExperience()));
        }
        parsedCv = parsedCvRepository.save(parsedCv);

        if (parsedCv.getId() != null) {
            parsedCvSkillRepository.deleteByParsedCv_Id(parsedCv.getId());
        }
        saveSkills(parsedCv, result);

        CvAiAnalysisResult.CvScoreData scoreData = result.getCvScore();
        BigDecimal totalScore = normalizeScore(scoreData.getTotalScore(), true);

        score.setParsedCv(parsedCv);
        score.setApplication(application);
        score.setJob(application.getJob());
        score.setSkillScore(normalizeScore(scoreData.getSkillScore(), false));
        score.setProjectScore(normalizeScore(scoreData.getProjectScore(), false));
        score.setEducationScore(normalizeScore(scoreData.getEducationScore(), false));
        score.setCompletenessScore(normalizeScore(scoreData.getCompletenessScore(), false));
        score.setBonusScore(normalizeScore(scoreData.getBonusScore(), false));
        score.setPenaltyScore(normalizeScore(scoreData.getPenaltyScore(), false));
        score.setTotalScore(totalScore);
        score.setMatchLevel(normalizeMatchLevel(scoreData.getMatchLevel(), totalScore));
        score.setScoredAt(LocalDateTime.now());
        cvScoreRepository.save(score);
    }

    private void saveSkills(ParsedCv parsedCv, CvAiAnalysisResult result) {
        if (result.getParsedCvSkills() == null || result.getParsedCvSkills().isEmpty()) {
            return;
        }

        Set<String> seen = new HashSet<>();
        for (String rawSkill : result.getParsedCvSkills()) {
            String skill = trimToNull(rawSkill);
            if (skill == null) {
                continue;
            }
            if (skill.length() > 150) {
                skill = skill.substring(0, 150);
            }
            String normalized = skill.toLowerCase(Locale.ROOT);
            if (!seen.add(normalized)) {
                continue;
            }

            ParsedCvSkill parsedCvSkill = new ParsedCvSkill();
            parsedCvSkill.setParsedCv(parsedCv);
            parsedCvSkill.setSkillName(skill);
            parsedCvSkillRepository.save(parsedCvSkill);
        }
    }

    private BigDecimal normalizeScore(BigDecimal value, boolean clampToHundred) {
        if (value == null) {
            return ZERO;
        }
        BigDecimal score = value.setScale(2, RoundingMode.HALF_UP);
        if (score.compareTo(ZERO) < 0) {
            return ZERO;
        }
        if (clampToHundred && score.compareTo(HUNDRED) > 0) {
            return HUNDRED;
        }
        return score;
    }

    private String normalizeMatchLevel(String rawLevel, BigDecimal totalScore) {
        String level = trimToNull(rawLevel);
        if (level != null) {
            String normalized = level.toUpperCase(Locale.ROOT);
            if (normalized.equals("VERY_FIT")
                    || normalized.equals("FIT")
                    || normalized.equals("PARTIAL")
                    || normalized.equals("LOW")) {
                return normalized;
            }
        }

        if (totalScore.compareTo(BigDecimal.valueOf(85)) >= 0) {
            return "VERY_FIT";
        }
        if (totalScore.compareTo(BigDecimal.valueOf(70)) >= 0) {
            return "FIT";
        }
        if (totalScore.compareTo(BigDecimal.valueOf(50)) >= 0) {
            return "PARTIAL";
        }
        return "LOW";
    }

    private String trimToNull(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }
        return value.trim();
    }
}
