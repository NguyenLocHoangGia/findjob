<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân - Ứng viên</title>
    
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        /* Style cho ô input bị khóa để trông tự nhiên hơn */
        .form-control[readonly], .form-control[disabled] { background-color: #e9ecef; opacity: 1; cursor: not-allowed; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container my-5" style="padding-top: 80px;">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow-sm border-0 rounded-4 p-4">
                    <div class="d-flex align-items-center border-bottom pb-3 mb-4">
                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3 shadow" style="width: 60px; height: 60px; font-size: 24px;">
                            <i class="bi bi-person-lines-fill"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark">Hồ sơ Ứng viên</h3>
                            <p class="text-muted mb-0">Quản lý thông tin liên hệ và CV của bạn</p>
                        </div>
                    </div>

                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success py-2"><i class="bi bi-check-circle-fill me-2"></i>${successMsg}</div>
                    </c:if>

                    <form id="profileForm" action="/candidate/profile" method="POST" enctype="multipart/form-data">
                        
                        <div class="row mb-4">
                            <div class="col-md-4 text-center border-end">
                                <c:choose>
                                    <c:when test="${not empty candidateProfileDTO.existingImg}">
                                        <div class="mb-3">
                                            <img src="/uploads/avatars/${candidateProfileDTO.existingImg}" alt="Avatar" class="rounded-circle shadow" style="width: 130px; height: 130px; object-fit: cover; border: 3px solid #0d6efd;">
                                            <p class="small text-muted mb-0 mt-2">Đã cập nhật ảnh đại diện</p>
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
                                    <input class="form-control form-control-sm editable-file" type="file" name="avatarFile" accept="image/png, image/jpeg" disabled>
                                </div>

                                <div class="mb-3 text-start">
                                    <label class="form-label fw-bold small">Tải lên file CV (PDF)</label>
                                    <input class="form-control form-control-sm editable-file" type="file" id="cvFileProfile" 
                                        name="cvFile" accept="application/pdf" disabled onchange="previewPDF(this, 'profileCvPreview')">
                                    
                                    <div id="profileCvPreviewContainer" class="mt-3 <c:if test='${empty candidateProfileDTO.existingCv}'>d-none</c:if>">
                                        <iframe id="profileCvPreview" 
                                                src="${not empty candidateProfileDTO.existingCv ? '/uploads/cv_files/'.concat(candidateProfileDTO.existingCv) : ''}" 
                                                style="width: 100%; height: 400px; border-radius: 8px; border: 1px solid #ddd;">
                                        </iframe>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-8 ps-md-4">
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Tài khoản đăng nhập</label>
                                    <input type="email" class="form-control bg-light text-muted" value="${userEmail}" readonly>
                                </div>

                                <div class="mb-3">
                                    <label for="fullName" class="form-label fw-bold">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control editable-text" id="fullName" name="fullName" value="${candidateProfileDTO.fullName}" required readonly>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="phone" class="form-label fw-bold">Số điện thoại</label>
                                        <input type="text" class="form-control editable-text" id="phone" name="phone" value="${candidateProfileDTO.phone}" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="address" class="form-label fw-bold">Địa chỉ sinh sống</label>
                                        <input type="text" class="form-control editable-text" id="address" name="address" value="${candidateProfileDTO.address}" readonly>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label fw-bold">Giới thiệu bản thân</label>
                                    <textarea class="form-control editable-text" id="description" name="description" rows="4" readonly>${candidateProfileDTO.description}</textarea>
                                </div>
                            </div>
                        </div>

                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <div class="d-flex justify-content-end border-top pt-4 mt-2">
                            <button type="button" id="btnUnlock" class="btn btn-warning px-4 fw-bold text-dark" data-bs-toggle="modal" data-bs-target="#passwordModal">
                                <i class="bi bi-unlock-fill me-2"></i>Cập nhật thông tin
                            </button>
                            <button type="submit" id="btnSave" class="btn btn-success px-5 fw-bold d-none">
                                <i class="bi bi-floppy-fill me-2"></i>Lưu hồ sơ
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="passwordModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold text-dark"><i class="bi bi-shield-lock-fill text-warning me-2"></i>Xác thực bảo mật</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted small">Vui lòng nhập mật khẩu của bạn để cấp quyền chỉnh sửa hồ sơ.</p>
                    <input type="password" id="verifyPasswordInput" class="form-control form-control-lg" placeholder="Nhập mật khẩu...">
                    <div id="passwordError" class="text-danger small mt-2 d-none">Mật khẩu không chính xác!</div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" id="btnConfirmPassword" class="btn btn-primary px-4">Xác nhận</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.getElementById('btnConfirmPassword').addEventListener('click', function() {
            const password = document.getElementById('verifyPasswordInput').value;
            const errorDiv = document.getElementById('passwordError');
            
            // Lấy CSRF token để gửi Ajax
            const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
            const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

            // Tạo dữ liệu gửi đi
            const formData = new URLSearchParams();
            formData.append("password", password);

            // Gửi Ajax lên Server kiểm tra
            fetch('/candidate/verify-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    [csrfHeader]: csrfToken
                },
                body: formData.toString()
            })
            .then(response => {
                if (response.ok) {
                    // 1. MẬT KHẨU ĐÚNG: Đóng Modal
                    const modal = bootstrap.Modal.getInstance(document.getElementById('passwordModal'));
                    modal.hide();

                    // 2. Mở khóa các trường Text
                    document.querySelectorAll('.editable-text').forEach(field => {
                        field.removeAttribute('readonly');
                        field.classList.remove('bg-light');
                    });

                    // 3. Mở khóa các trường File
                    document.querySelectorAll('.editable-file').forEach(field => {
                        field.removeAttribute('disabled');
                    });

                    // 4. Đổi nút Cập nhật thành nút Lưu
                    document.getElementById('btnUnlock').classList.add('d-none');
                    document.getElementById('btnSave').classList.remove('d-none');
                    
                    errorDiv.classList.add('d-none');
                    document.getElementById('verifyPasswordInput').value = ''; // Xóa trắng mật khẩu đã nhập
                } else {
                    // MẬT KHẨU SAI: Báo lỗi
                    errorDiv.classList.remove('d-none');
                }
            })
            .catch(error => console.error('Error:', error));
        });
    </script>
</body>
</html>