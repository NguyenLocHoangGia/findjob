<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ Công ty - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        .content-area { display: flex; flex-direction: column; flex: 1; }
        .main-content { flex: 1; padding: 30px; }
        .preview-img { width: 120px; height: 120px; object-fit: cover; border-radius: 12px; border: 2px solid #dee2e6; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="main-wrapper">
        <jsp:include page="layout/sidebar.jsp" />

        <div class="content-area">
            <div class="main-content">
                <div class="container-fluid">
                    
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h3 class="fw-bold mb-1">Hồ sơ Doanh nghiệp</h3>
                            <p class="text-muted small mb-0">Cập nhật thông tin nhận diện thương hiệu tuyển dụng của bạn.</p>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-xl-8 col-lg-10">
                            <div class="card shadow-sm border-0 rounded-4 p-4 bg-white">
                                
                                <c:if test="${not empty successMsg}">
                                    <div class="alert alert-success fw-bold alert-dismissible fade show" role="alert">
                                        <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty errorMsg}">
                                    <div class="alert alert-danger fw-bold"><i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMsg}</div>
                                </c:if>

                                <form action="/recruiter/update-company" method="POST" enctype="multipart/form-data">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Tên Công ty <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control form-control-lg bg-light" name="companyName" value="${company.companyName}" required>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Địa chỉ Trụ sở <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control bg-light" name="companyAddress" value="${company.companyAddress}" required>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Giới thiệu về Công ty <span class="text-danger">*</span></label>
                                        <textarea class="form-control bg-light" name="description" rows="6" required>${company.description}</textarea>
                                    </div>

                                    <div class="mb-4 border rounded-3 p-3 bg-light">
                                        <label class="form-label fw-bold">Logo Công ty hiện tại</label>
                                        <div class="d-flex align-items-center gap-4 mt-2">
                                            <div id="previewContainer">
                                                <img id="logoPreview" 
                                                     src="${not empty company.companyLogo ? '/uploads/company_logos/'.concat(company.companyLogo) : 'https://via.placeholder.com/120?text=Logo'}" 
                                                     alt="Logo" class="preview-img bg-white">
                                            </div>
                                            <div class="flex-grow-1">
                                                <label class="btn btn-outline-primary btn-sm mb-2" for="logoFile">
                                                    <i class="bi bi-upload me-1"></i> Tải logo mới lên
                                                </label>
                                                <input type="file" class="d-none" id="logoFile" name="logoFile" accept="image/png, image/jpeg" onchange="previewLogo(event)">
                                                <p class="text-muted small mb-0"><i class="bi bi-info-circle me-1"></i>Để trống nếu muốn giữ logo cũ. Định dạng JPG, PNG.</p>
                                            </div>
                                        </div>
                                    </div>

                                    <hr class="my-4 text-muted">

                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-dark fw-bold px-5 shadow-sm">
                                            <i class="bi bi-save-fill me-2"></i> Lưu thay đổi
                                        </button>
                                        <a href="/recruiter/dashboard" class="btn btn-light border px-4">Hủy</a>
                                    </div>
                                </form>

                            </div>
                        </div>
                    </div>

                </div>
            </div>
            
            <jsp:include page="layout/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hiển thị trước ảnh Logo khi tải lên
        function previewLogo(event) {
            const input = event.target;
            const previewImg = document.getElementById('logoPreview');

            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result; 
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>