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
        .hero-bg { background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%); color: white; padding: 60px 0; border-radius: 0 0 30px 30px; margin-bottom: -50px; }
    </style>
</head>
<body>

    <jsp:include page="../candidate/layout/header.jsp" />

    <div class="hero-bg text-center shadow-sm">
        <div class="container pt-5">
            <h2 class="fw-bold"><i class="bi bi-building-add me-2"></i>Đăng ký Hồ sơ Doanh nghiệp</h2>
            <p class="opacity-75">Cung cấp thông tin xác thực để bắt đầu hành trình tìm kiếm nhân tài</p>
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

                        <div class="row mb-4">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <label class="form-label fw-bold">Logo Công ty <span class="text-danger">*</span></label>
                                <div class="p-3 border rounded-3 bg-light text-center">
                                    <i class="bi bi-image text-muted fs-3 d-block mb-2"></i>
                                    <input type="file" class="form-control form-control-sm" name="logoFile" accept="image/png, image/jpeg" required>
                                    <small class="text-muted mt-2 d-block">Định dạng JPG, PNG (Tối đa 2MB)</small>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold text-primary">Giấy phép kinh doanh <span class="text-danger">*</span></label>
                                <div class="p-3 border border-primary border-opacity-25 rounded-3 bg-primary bg-opacity-10 text-center">
                                    <i class="bi bi-file-earmark-medical text-primary fs-3 d-block mb-2"></i>
                                    <input type="file" class="form-control form-control-sm border-primary" name="licenseFile" accept="image/png, image/jpeg, application/pdf" required>
                                    <small class="text-primary mt-2 d-block">Bản scan JPG, PNG hoặc PDF</small>
                                </div>
                            </div>
                        </div>

                        <div class="alert alert-warning small rounded-3 border-warning">
                            <i class="bi bi-info-circle-fill me-1"></i> <strong>Lưu ý:</strong> Sau khi gửi yêu cầu, Ban quản trị sẽ tiến hành xác minh giấy phép kinh doanh của bạn. Quá trình này có thể mất từ 1-2 ngày làm việc.
                        </div>

                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-primary btn-lg fw-bold rounded-pill shadow-sm">
                                <i class="bi bi-send-fill me-2"></i> Gửi yêu cầu xét duyệt
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