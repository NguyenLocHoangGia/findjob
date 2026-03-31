package com.findjob_tt.findjob_tt.model;

import jakarta.persistence.*;

@Entity
@Table(name = "company_profiles")
public class CompanyProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Móc 1-1 về bảng User
    @OneToOne
    @JoinColumn(name = "user_id", unique = true)
    private User user;

    @Column(name = "company_name")
    private String companyName;

    @Column(name = "company_logo")
    private String companyLogo;

    @Column(name = "company_address")
    private String companyAddress;

    @Column(columnDefinition = "TEXT")
    private String description; // Giới thiệu về công ty

    @Column(name = "business_license")
    private String businessLicense;

    // Trạng thái chờ xét hồ sơ: PENDING (Đang chờ), APPROVED (Đã duyệt), REJECTED
    // (Bị từ chối)
    @Column(name = "status")
    private String status = "PENDING";

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

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyLogo() {
        return companyLogo;
    }

    public void setCompanyLogo(String companyLogo) {
        this.companyLogo = companyLogo;
    }

    public String getCompanyAddress() {
        return companyAddress;
    }

    public void setCompanyAddress(String companyAddress) {
        this.companyAddress = companyAddress;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBusinessLicense() {
        return businessLicense;
    }

    public void setBusinessLicense(String businessLicense) {
        this.businessLicense = businessLicense;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}