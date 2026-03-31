package com.findjob_tt.findjob_tt.model;

import java.util.List;

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

    @Email(message = "Email không đúng định dạng", regexp = "^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$")
    @NotNull(message = "Email không được bỏ trống")
    private String email;

    @NotNull(message = "Password không được để trống")
    @Size(min = 6, message = "Password chứa ít nhất 6 ký tự") // Nên tăng lên 6 ký tự cho bảo mật
    private String password;

    @NotNull(message = "Tên không được để trống")
    @Size(min = 3, message = "Tên chứa ít nhất 3 ký tự")
    private String fullName;

    private String address;
    private String phone;
    private String avatar;

    // --- CÁC TRƯỜNG DÀNH RIÊNG CHO CHỨC NĂNG TÌM VIỆC (CANDIDATE) ---
    private String cvUrl; // Đường dẫn file CV mặc định của ứng viên

    @OneToMany(mappedBy = "user")
    private List<SavedJob> savedJobs; // Danh sách việc làm đã lưu (Quan tâm)

    @OneToMany(mappedBy = "user")
    private List<Application> applications; // Danh sách việc làm đã ứng tuyển

    // Khóa ngoại liên kết với công ty. Nếu User chỉ là Candidate, trường này sẽ là
    // null.
    @ManyToOne
    @JoinColumn(name = "company_id")
    private Company company;

    // --- PHÂN QUYỀN (ADMIN / USER) ---
    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    // --- GETTERS & SETTERS ---
    @Override
    public String toString() {
        return "User [id=" + id + ", email=" + email + ", fullName=" + fullName + "]";
    }

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

    public Company getCompany() {
        return company;
    }

    public void setCompany(Company company) {
        this.company = company;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}