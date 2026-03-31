package com.findjob_tt.findjob_tt.model.dto;

import org.springframework.web.multipart.MultipartFile;

public class CandidateProfileDTO {
    private String fullName;
    private String phone;
    private String address;
    private String description;

    // Dùng để hứng file người dùng upload lên
    private MultipartFile avatarFile;
    private MultipartFile cvFile;

    // Dùng để hiển thị ảnh/cv đang có sẵn trong Database
    private String existingImg;
    private String existingCv;

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public MultipartFile getAvatarFile() {
        return avatarFile;
    }

    public void setAvatarFile(MultipartFile avatarFile) {
        this.avatarFile = avatarFile;
    }

    public MultipartFile getCvFile() {
        return cvFile;
    }

    public void setCvFile(MultipartFile cvFile) {
        this.cvFile = cvFile;
    }

    public String getExistingImg() {
        return existingImg;
    }

    public void setExistingImg(String existingImg) {
        this.existingImg = existingImg;
    }

    public String getExistingCv() {
        return existingCv;
    }

    public void setExistingCv(String existingCv) {
        this.existingCv = existingCv;
    }

}
