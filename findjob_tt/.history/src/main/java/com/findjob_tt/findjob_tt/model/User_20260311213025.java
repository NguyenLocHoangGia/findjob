package com.findjob_tt.findjob_tt.model;

import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    // --- THÔNG TIN CHUNG (Dùng cho cả Candidate và Recruiter) ---
    @Email(message = "Email không đúng định dạng", regexp = "^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$")
    @NotNull(message = "Email không được bỏ trống")
    private String email;

    @NotNull(message = "Password không được để trống")
    @Size(min = 6, message = "Password chứa ít nhất 6 ký tự")
    private String password;

    @NotNull(message = "Tên không được để trống")
    @Size(min = 3, message = "Tên chứa ít nhất 3 ký tự")
    private String fullName;

    private String address;
    private String phone;
    private String avatar;

    // --- CÁC TRƯỜNG DÀNH RIÊNG CHO ỨNG VIÊN (CANDIDATE) ---
    private String cvUrl;

    @OneToMany(mappedBy = "user")
    private List<SavedJob> savedJobs;

    @OneToMany(mappedBy = "user")
    private List<Application> applications;

    private String companyName;
    private String companyAddress;
    private String img;

    @Column(columnDefinition = "TEXT") // Cho phép nhập mô tả dài
    private String description;

    private String cv;

    // Danh sách các công việc mà Nhà tuyển dụng này đã đăng
    @OneToMany(mappedBy = "user")
    private List<Job> postedJobs;

    // --- PHÂN QUYỀN (ROLE_ADMIN, ROLE_USER) ---
    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    // --- GETTERS & SETTERS ---
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getCvUrl() {
        return cvUrl;
    }

    public void setCvUrl(String cvUrl) {
        this.cvUrl = cvUrl;
    }

    public List<SavedJob> getSavedJobs() {
        return savedJobs;
    }

    public void setSavedJobs(List<SavedJob> savedJobs) {
        this.savedJobs = savedJobs;
    }

    public List<Application> getApplications() {
        return applications;
    }

    public void setApplications(List<Application> applications) {
        this.applications = applications;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyAddress() {
        return companyAddress;
    }

    public void setCompanyAddress(String companyAddress) {
        this.companyAddress = companyAddress;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String companyLogo) {
        this.img = companyLogo;
    }

    public List<Job> getPostedJobs() {
        return postedJobs;
    }

    public void setPostedJobs(List<Job> postedJobs) {
        this.postedJobs = postedJobs;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCv() {
        return cv;
    }

    public void setCv(String cv) {
        this.cv = cv;
    }

}