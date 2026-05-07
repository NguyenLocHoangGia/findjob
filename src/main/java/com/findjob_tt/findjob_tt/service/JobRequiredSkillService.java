package com.findjob_tt.findjob_tt.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.JobRequiredSkill;
import com.findjob_tt.findjob_tt.repository.JobRequiredSkillRepository;

@Service
public class JobRequiredSkillService {

    private final JobRequiredSkillRepository jobRequiredSkillRepository;

    public JobRequiredSkillService(JobRequiredSkillRepository jobRequiredSkillRepository) {
        this.jobRequiredSkillRepository = jobRequiredSkillRepository;
    }

    @Transactional(readOnly = true)
    public List<JobRequiredSkill> findByJobId(Long jobId) {
        if (jobId == null) {
            return List.of();
        }
        return jobRequiredSkillRepository.findByJob_IdOrderByDisplayOrderAscIdAsc(jobId);
    }

    @Transactional
    public void replaceSkills(
            Job job,
            List<String> skillNames,
            List<String> skillTypes,
            List<String> minYears,
            List<String> weights,
            List<String> mustHaves) {

        if (job == null || job.getId() == null) {
            return;
        }

        jobRequiredSkillRepository.deleteByJob_Id(job.getId());

        List<JobRequiredSkill> normalizedSkills = buildSkills(job, skillNames, skillTypes, minYears, weights,
                mustHaves);
        if (!normalizedSkills.isEmpty()) {
            jobRequiredSkillRepository.saveAll(normalizedSkills);
        }
    }

    private List<JobRequiredSkill> buildSkills(
            Job job,
            List<String> skillNames,
            List<String> skillTypes,
            List<String> minYears,
            List<String> weights,
            List<String> mustHaves) {

        if (skillNames == null || skillNames.isEmpty()) {
            return List.of();
        }

        Set<String> seen = new LinkedHashSet<>();
        List<JobRequiredSkill> result = new ArrayList<>();

        for (int i = 0; i < skillNames.size(); i++) {
            String skillName = normalizeSkillName(getAt(skillNames, i));
            if (skillName == null || !seen.add(skillName)) {
                continue;
            }

            JobRequiredSkill skill = new JobRequiredSkill();
            skill.setJob(job);
            skill.setSkillName(skillName);
            String skillType = normalizeSkillType(getAt(skillTypes, i));
            skill.setSkillType(skillType);
            skill.setMinYears(parseMinYears(getAt(minYears, i)));
            skill.setWeight(parseWeight(getAt(weights, i)));
            skill.setMustHave(resolveMustHave(getAt(mustHaves, i), skillType));
            skill.setDisplayOrder(result.size());
            result.add(skill);
        }

        return result;
    }

    private String normalizeSkillName(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }
        String normalized = value.trim().replaceAll("\\s+", " ").toLowerCase(Locale.ROOT);
        if (normalized.length() > 150) {
            return normalized.substring(0, 150);
        }
        return normalized;
    }

    private String normalizeSkillType(String value) {
        if (JobRequiredSkill.TYPE_PREFERRED.equalsIgnoreCase(value)) {
            return JobRequiredSkill.TYPE_PREFERRED;
        }
        return JobRequiredSkill.TYPE_REQUIRED;
    }

    private BigDecimal parseMinYears(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }
        try {
            BigDecimal minYears = new BigDecimal(value.trim()).setScale(1, RoundingMode.HALF_UP);
            return minYears.compareTo(BigDecimal.ZERO) < 0 ? null : minYears;
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private Integer parseWeight(String value) {
        if (!StringUtils.hasText(value)) {
            return 5;
        }
        try {
            int weight = Integer.parseInt(value.trim());
            return Math.max(1, Math.min(10, weight));
        } catch (NumberFormatException ex) {
            return 5;
        }
    }

    private boolean resolveMustHave(String value, String skillType) {
        if (!StringUtils.hasText(value)) {
            return JobRequiredSkill.TYPE_REQUIRED.equalsIgnoreCase(skillType);
        }

        String normalized = value.trim().toLowerCase(Locale.ROOT);
        if (!"true".equals(normalized) && !"false".equals(normalized)) {
            return JobRequiredSkill.TYPE_REQUIRED.equalsIgnoreCase(skillType);
        }

        return Boolean.parseBoolean(normalized);
    }

    private String getAt(List<String> values, int index) {
        if (values == null || index < 0 || index >= values.size()) {
            return null;
        }
        return values.get(index);
    }
}
