package com.findjob_tt.findjob_tt.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "companies")
public class Company {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    private String logo;

    @Column(columnDefinition = "TEXT")
    private String description;

    private String address;
    private String website;

    // Một công ty có thể có nhiều tài khoản nhân viên nhân sự
    @OneToMany(mappedBy = "company")
    private List<User> recruiters;

    // Một công ty có thể đăng nhiều việc làm
    @OneToMany(mappedBy = "company", cascade = CascadeType.ALL)
    private List<Job> jobs;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
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

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public List<User> getRecruiters() {
        return recruiters;
    }

    public void setRecruiters(List<User> recruiters) {
        this.recruiters = recruiters;
    }

    public List<Job> getJobs() {
        return jobs;
    }

    public void setJobs(List<Job> jobs) {
        this.jobs = jobs;
    }

    @Override
    public String toString() {
        return "Company [id=" + id + ", name=" + name + ", logo=" + logo + ", description=" + description + ", address="
                + address + ", website=" + website + ", recruiters=" + recruiters + ", jobs=" + jobs + "]";
    }

}