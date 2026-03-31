<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký thông tin Công ty - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .hero-bg { background: linear-gradient(135deg, #198754 0%, #20c997 100%); color: white; padding: 60px 0; border-radius: 0 0 30px 30px; margin-bottom: -50px; }
    </style>
</head>
<body>

    <jsp:include page="../candidate/layout/header.jsp" />

    <div class="hero-bg text-center shadow-sm">
        <div class="container pt-5">
            <h2 class="fw-bold"><i class="bi bi-rocket-takeoff-fill me-2"></i>Nâng cấp tài khoản Nhà Tuyển Dụng</h2>
            <p class="opacity-75">Chỉ một bước duy nhất để bắt đầu đăng tin và tìm kiếm nhân tài</p>
        </div>
    </div>

    <div class="container pb-5" style="position: relative; z-index: 10;">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow border-0 rounded-4 p-4 p-md-5 bg-white">
                    
                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger fw-bold"><i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMsg}</div>
                    </c:if>

                    <form action="/recruiter/register-company" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        
                        <h5 class="fw-bold text-dark mb-4 border-bottom pb-2">Thông tin Doanh nghiệp</h5>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên Công ty <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-lg bg-light" name="companyName" required placeholder="VD: Công ty Cổ phần Công nghệ TechAsia">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Địa chỉ Trụ sở <span class="text-danger">*</span></label>
                            <input type="text" class="form-control bg-light" name="companyAddress" required placeholder="Nhập địa chỉ cụ thể...">
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Giới thiệu về Công ty <span class="text-danger">*</span></label>
                            <textarea class="form-control bg-light" name="description" rows="5" required placeholder="Mô tả lĩnh vực hoạt động, văn hóa công ty, quy mô..."></textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Logo Công ty (Hình vuông) <span class="text-danger">*</span></label>
                            <input type="file" class="form-control" name="logoFile" accept="image/png, image/jpeg" required>
                            <small class="text-muted mt-1 d-block"><i class="bi bi-info-circle me-1"></i>Định dạng JPG, PNG. Dung lượng tối đa 2MB.</small>
                        </div>

                        <div class="d-grid mt-5">
                            <button type="submit" class="btn btn-success btn-lg fw-bold rounded-pill shadow-sm">
                                <i class="bi bi-check-circle-fill me-2"></i> Hoàn tất & Đi tới Bảng điều khiển
                            </button>
                        </div>
                        
                        <div class="text-center mt-3">
                            <a href="/" class="text-muted text-decoration-none small">Hủy bỏ và quay lại trang chủ</a>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>