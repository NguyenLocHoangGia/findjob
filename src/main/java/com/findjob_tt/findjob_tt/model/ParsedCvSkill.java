package com.findjob_tt.findjob_tt.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "parsed_cv_skills")
public class ParsedCvSkill {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "parsed_cv_id", nullable = false)
    private ParsedCv parsedCv;

    @Column(name = "skill_name", length = 150)
    private String skillName;

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

    public String getSkillName() {
        return skillName;
    }

    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }
}
