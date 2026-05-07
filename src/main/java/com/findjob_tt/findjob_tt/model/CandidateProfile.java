package com.findjob_tt.findjob_tt.model;

import jakarta.persistence.*;

@Entity
@Table(name = "candidate_profiles")
public class CandidateProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Móc 1-1 về bảng User
    @OneToOne
    @JoinColumn(name = "user_id", unique = true)
    private User user;

    @Column(name = "cv_url")
    private String cvUrl;

    @Column(columnDefinition = "TEXT")
    private String description; // Giới thiệu bản thân

    private String address; // Địa chỉ thường trú

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getCvUrl() {
        return cvUrl;
    }

    public void setCvUrl(String cvUrl) {
        this.cvUrl = cvUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    // Tương lai bạn có thể thêm: skills, education, experience... vào đây

}