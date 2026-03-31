<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .hover-lift { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .hover-lift:hover { transform: translateY(-3px); box-shadow: 0 .5rem 1rem rgba(0,0,0,.15)!important; }
    </style>
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="min-height: 100vh;">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow-sm border-0 rounded-4 p-4 my-5">
                    <div class="text-center mb-4 mt-2">
                        <h2 class="fw-bold text-primary">Tạo tài khoản</h2>
                        <p class="text-muted">Tham gia mạng lưới việc làm IT lớn nhất</p>
                    </div>

                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger py-2 text-center">${errorMsg}</div>
                    </c:if>

                    <form id="registerForm" action="/register" method="POST">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="fullName" name="fullName" placeholder="Họ và tên" required>
                            <label for="fullName">Họ và tên của bạn</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="email" class="form-control rounded-3" id="email" name="email" placeholder="name@example.com" required>
                            <label for="email">Địa chỉ Email</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="password" class="form-control rounded-3" id="password" name="password" placeholder="Mật khẩu" required minlength="6">
                            <label for="password">Mật khẩu (Ít nhất 6 ký tự)</label>
                        </div>

                        <div class="form-floating mb-4">
                            <input type="password" class="form-control rounded-3" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu" required minlength="6">
                            <label for="confirmPassword">Xác nhận mật khẩu</label>
                        </div>
                        
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        
                        <input type="hidden" name="roleName" value="ROLE_CANDIDATE">

                        <button type="submit" class="btn btn-success w-100 py-2 fs-5 fw-bold rounded-3 mb-3">
                            Đăng ký
                        </button>
                    </form>

                    <div class="text-center">
                        <p class="mb-0 text-muted">Đã có tài khoản? <a href="/login" class="text-decoration-none fw-bold">Đăng nhập</a></p>
                        <a href="/" class="text-decoration-none text-secondary mt-2 d-block small"><i class="bi bi-arrow-left"></i> Quay lại trang chủ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="roleSelectionModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 p-2">
                <div class="modal-header border-0 pb-0 justify-content-center position-relative">
                    <h5 class="modal-title fw-bold fs-4 text-dark">Chọn vai trò của bạn</h5>
                    <button type="button" class="btn-close position-absolute end-0 me-3" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center pb-4 pt-3">
                    <p class="text-muted mb-4 small">Vui lòng cho chúng tôi biết mục đích bạn tham gia JobPortal để tối ưu trải nghiệm nhé!</p>
                    
                    <div class="d-grid gap-3 px-3">
                        <button type="button" class="btn btn-outline-primary btn-lg rounded-4 d-flex flex-column align-items-center justify-content-center p-3 hover-lift" onclick="submitFormWithRole('ROLE_CANDIDATE')">
                            <i class="bi bi-person-vcard fs-1 mb-2"></i>
                            <span class="fw-bold">Tôi là Ứng viên</span>
                            <small class="fw-normal opacity-75">Tìm kiếm việc làm, thực tập</small>
                        </button>
                        
                        <button type="button" class="btn btn-outline-success btn-lg rounded-4 d-flex flex-column align-items-center justify-content-center p-3 hover-lift" onclick="submitFormWithRole('ROLE_RECRUITER')">
                            <i class="bi bi-buildings fs-1 mb-2"></i>
                            <span class="fw-bold">Tôi là Nhà tuyển dụng</span>
                            <small class="fw-normal opacity-75">Đăng tin tuyển dụng, tìm nhân tài</small>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function triggerRoleModal() {
            const form = document.getElementById('registerForm');
            const pwd = document.getElementById('password').value;
            const confirmPwd = document.getElementById('confirmPassword').value;

            // Kiểm tra mật khẩu thủ công
            if (pwd !== confirmPwd) {
                alert("Mật khẩu xác nhận không khớp!");
                return;
            }

            // Kiểm tra các trường HTML5 (required, email...)
            if (form.checkValidity()) {
                // Form hợp lệ -> Hiện Popup chọn Role
                const roleModal = new bootstrap.Modal(document.getElementById('roleSelectionModal'));
                roleModal.show();
            } else {
                // Form thiếu thông tin -> Hiện cảnh báo mặc định của trình duyệt
                form.reportValidity();
            }
        }

        // Hàm được gọi khi bấm nút trong Popup
        function submitFormWithRole(role) {
            document.getElementById('hiddenRoleName').value = role;
            document.getElementById('registerForm').submit();
        }
    </script>
</body>
</html>