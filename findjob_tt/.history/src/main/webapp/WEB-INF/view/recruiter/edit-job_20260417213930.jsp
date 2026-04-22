<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa công việc: ${job.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        .content-area { display: flex; flex-direction: column; flex: 1; }
        .main-content { flex: 1; padding: 30px; }
        .preview-img { width: 100px; height: 100px; object-fit: cover; border-radius: 12px; border: 1px solid #dee2e6; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        
        /* CSS cho công tắc Bật/Tắt */
        .form-switch .form-check-input { width: 3em; height: 1.5em; cursor: pointer; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="main-wrapper">
        <jsp:include page="layout/sidebar.jsp" />

        <div class="content-area">
            <div class="main-content">
                <div class="container-fluid">
                    <h3 class="fw-bold mb-4">Chỉnh sửa tin tuyển dụng</h3>

                    <div class="card shadow-sm border-0" style="max-width: 900px;">
                        <div class="card-body p-4">
                            
                            <form action="/recruiter/edit-job" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                
                                <input type="hidden" name="id" value="${job.id}">
                                
                                <div class="mb-4 d-flex align-items-center bg-light p-3 rounded border">
                                    <div class="me-3">
                                        <i class="bi bi-broadcast fs-3 text-primary"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <h6 class="mb-0 fw-bold">Trạng thái tin đăng</h6>
                                        <small class="text-muted">Bật để ứng viên có thể thấy và ứng tuyển vào công việc này.</small>
                                    </div>
                                    <div class="form-check form-switch fs-5 mb-0">
                                        <input class="form-check-input" type="checkbox" role="switch" name="isActive" id="statusSwitch" value="true" ${job.isActive ? 'checked' : ''}>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-8 mb-3">
                                        <label class="form-label fw-bold">Tiêu đề công việc <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control fw-medium text-dark" name="title" value="${job.title}" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label fw-bold">Tên công ty <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="companyName" value="${job.companyName}" required>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Mức lương <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <select class="form-select" id="salaryType" style="max-width: 170px;">
                                                <option value="NUMBER">Theo số</option>
                                                <option value="NEGOTIABLE">Thỏa thuận</option>
                                            </select>
                                            <input type="number" class="form-control" id="salaryAmount" min="0" step="1"
                                                placeholder="VD: 5000000">
                                        </div>
                                        <input type="hidden" name="salary" id="salaryValue" required>
                                        <small class="text-muted">Chỉ nhập số không âm hoặc chọn Thỏa thuận.</small>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Địa điểm làm việc <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="location" value="${job.location}" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold text-primary">Mô tả ngắn gọn (Hiển thị ngoài Trang chủ) <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="shortDescription" value="${job.shortDescription}" required maxlength="150">
                                </div>

                                <div class="mb-4 mt-4">
                                    <label class="form-label fw-bold">Mô tả chi tiết và Yêu cầu <span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="description" rows="8" required>${job.description}</textarea>
                                </div>

                                <div class="mb-3 border rounded p-3 bg-light">
                                    <label for="logoFile" class="form-label fw-bold mb-1">Cập nhật Logo hiển thị</label>
                                    <p class="text-muted small mb-2 text-info"><i class="bi bi-info-circle"></i> Bỏ trống nếu bạn muốn giữ nguyên Logo hiện tại.</p>
                                    <input class="form-control bg-white" type="file" id="logoFile" accept=".png, .jpg, .jpeg" name="logoFile" onchange="previewLogo(event)"/>
                                </div>

                                <div id="previewContainer" class="mb-4 text-center">
                                    <p class="text-muted small mb-2">Logo hiện tại:</p>
                                    <img id="logoPreview" 
                                         src="/uploads/job_logos/${job.logo}" 
                                         onerror="this.onerror=null; this.src='/uploads/company_logos/${job.logo}';" 
                                         alt="Logo Preview" 
                                         class="preview-img">
                                </div>

                                <hr>
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-warning fw-bold px-4 text-dark shadow-sm">
                                        <i class="bi bi-save me-2"></i> Lưu cập nhật
                                    </button>
                                    <a href="/recruiter/dashboard" class="btn btn-light border">Hủy bỏ</a>
                                </div>
                            </form>

                        </div>
                    </div>
                </div>
            </div>
            
            <jsp:include page="layout/footer.jsp" />
            
        </div>
    </div>

    <script>
        // Xử lý xem trước ảnh
        function previewLogo(event) {
            const input = event.target;
            const previewImg = document.getElementById('logoPreview');

            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result; 
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                // Nếu Hủy chọn tệp -> Trả lại ảnh gốc (trick tải lại trang nhanh)
                window.location.reload(); 
            }
        }

        function syncSalaryEditForm() {
            const salaryTypeEl = document.getElementById('salaryType');
            const salaryAmountEl = document.getElementById('salaryAmount');
            const salaryValueEl = document.getElementById('salaryValue');

            if (!salaryTypeEl || !salaryAmountEl || !salaryValueEl) {
                return true;
            }

            if (salaryTypeEl.value === 'NEGOTIABLE') {
                salaryAmountEl.value = '';
                salaryAmountEl.disabled = true;
                salaryValueEl.value = 'Thỏa thuận';
                return true;
            }

            salaryAmountEl.disabled = false;
            const raw = salaryAmountEl.value.trim();
            if (raw === '') {
                alert('Vui lòng nhập mức lương dạng số hoặc chọn Thỏa thuận.');
                salaryAmountEl.focus();
                return false;
            }

            const value = Number(raw);
            if (!Number.isFinite(value) || value < 0 || !Number.isInteger(value)) {
                alert('Mức lương chỉ chấp nhận số nguyên không âm.');
                salaryAmountEl.focus();
                return false;
            }

            salaryValueEl.value = String(value);
            return true;
        }

        document.addEventListener('DOMContentLoaded', function () {
            const salaryTypeEl = document.getElementById('salaryType');
            const salaryAmountEl = document.getElementById('salaryAmount');
            const salaryValueEl = document.getElementById('salaryValue');
            const formEl = document.querySelector('form[action="/recruiter/edit-job"]');
            const currentSalary = '${job.salary}';

            if (salaryTypeEl && salaryAmountEl && salaryValueEl) {
                const digits = (currentSalary || '').replace(/[^0-9]/g, '');
                const normalized = (currentSalary || '').toLowerCase();

                if (normalized.includes('thỏa thuận') || normalized.includes('thoa thuan')) {
                    salaryTypeEl.value = 'NEGOTIABLE';
                    salaryAmountEl.value = '';
                    salaryAmountEl.disabled = true;
                    salaryValueEl.value = 'Thỏa thuận';
                } else {
                    salaryTypeEl.value = 'NUMBER';
                    salaryAmountEl.disabled = false;
                    salaryAmountEl.value = digits;
                    salaryValueEl.value = digits;
                }

                salaryTypeEl.addEventListener('change', function () {
                    if (salaryTypeEl.value === 'NEGOTIABLE') {
                        salaryAmountEl.value = '';
                        salaryAmountEl.disabled = true;
                        salaryValueEl.value = 'Thỏa thuận';
                    } else {
                        salaryAmountEl.disabled = false;
                        salaryValueEl.value = salaryAmountEl.value;
                    }
                });
            }

            if (formEl) {
                formEl.addEventListener('submit', function (event) {
                    if (!syncSalaryEditForm()) {
                        event.preventDefault();
                    }
                });
            }
        });
    </script>
</body>
</html>