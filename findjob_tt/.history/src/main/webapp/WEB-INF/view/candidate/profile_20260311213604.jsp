<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<body>
    <jsp:include page="layout/header.jsp" />

    <div class="container my-5" style="padding-top: 80px;">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow-sm border-0 rounded-4 p-4">
                    <form action="/candidate/profile" method="POST" enctype="multipart/form-data">
                        
                        <div class="row mb-4">
                            <div class="col-md-4 text-center border-end">
                                <c:choose>
                                    <c:when test="${not empty candidateProfileDTO.existingImg}">
                                        <div class="mb-3">
                                            <i class="bi bi-person-check-fill text-success" style="font-size: 4rem;"></i>
                                            <p class="small text-muted mb-0">Đã cập nhật ảnh</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 100px; height: 100px;">
                                            <i class="bi bi-camera text-secondary fs-1"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="mb-4 text-start">
                                    <label class="form-label fw-bold small">Tải lên Ảnh đại diện</label>
                                    <input class="form-control form-control-sm" type="file" name="avatarFile" accept="image/png, image/jpeg">
                                </div>

                                <div class="mb-3 text-start">
                                    <label class="form-label fw-bold small">Tải lên file CV (PDF)</label>
                                    <input class="form-control form-control-sm" type="file" name="cvFile" accept=".pdf,.doc,.docx">
                                    <c:if test="${not empty candidateProfileDTO.existingCv}">
                                        <div class="mt-2 small text-success">
                                            <i class="bi bi-file-earmark-check-fill"></i> Đã có CV trong hệ thống
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="col-md-8 ps-md-4">
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Tài khoản đăng nhập</label>
                                    <input type="email" class="form-control bg-light text-muted" value="${userEmail}" readonly>
                                </div>

                                <div class="mb-3">
                                    <label for="fullName" class="form-label fw-bold">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" value="${candidateProfileDTO.fullName}" required>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="phone" class="form-label fw-bold">Số điện thoại</label>
                                        <input type="text" class="form-control" id="phone" name="phone" value="${candidateProfileDTO.phone}">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="address" class="form-label fw-bold">Địa chỉ</label>
                                        <input type="text" class="form-control" id="address" name="address" value="${candidateProfileDTO.address}">
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label fw-bold">Giới thiệu bản thân</label>
                                    <textarea class="form-control" id="description" name="description" rows="4" placeholder="Viết vài dòng giới thiệu về kinh nghiệm và mục tiêu nghề nghiệp của bạn...">${candidateProfileDTO.description}</textarea>
                                </div>
                            </div>
                        </div>

                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <div class="d-flex justify-content-end border-top pt-4 mt-2">
                            <button type="submit" class="btn btn-primary px-5 fw-bold">
                                <i class="bi bi-floppy-fill me-2"></i>Lưu hồ sơ
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>

    </body>
</html>