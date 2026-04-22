<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .password-wrapper {
            position: relative;
        }

        .password-toggle-btn {
            position: absolute;
            top: 50%;
            right: 12px;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: #6c757d;
            z-index: 10;
        }
    </style>
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="min-height: 100vh;">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow-sm border-0 rounded-4 p-4">
                    <div class="text-center mb-4 mt-2">
                        <h2 class="fw-bold text-primary">JobPortal</h2>
                        <p class="text-muted">Chào mừng bạn quay trở lại!</p>
                    </div>

                    <c:if test="${param.error != null}">
                        <c:set var="errorMsg" value="Email hoặc mật khẩu không chính xác!" />
                        
                        <c:set var="exString" value="${sessionScope['SPRING_SECURITY_LAST_EXCEPTION']}" />
                        <c:if test="${fn:contains(exString, 'DisabledException')}">
                            <c:set var="errorMsg" value="Tài khoản của bạn đã bị khóa do vi phạm quy định. Vui lòng liên hệ Admin!" />
                        </c:if>
                        
                        <div class="alert alert-danger py-3 text-center rounded-3">
                            <i class="bi bi-shield-lock-fill fs-4 d-block mb-1"></i>
                            <span class="fw-bold">${errorMsg}</span>
                        </div>
                    </c:if>

                    <c:if test="${param.disabled != null}">
                        <div class="alert alert-danger py-3 text-center rounded-3">
                            <i class="bi bi-shield-lock-fill fs-4 d-block mb-1"></i>
                            <span class="fw-bold">Tài khoản của bạn đã bị khóa. Vui lòng liên hệ Admin!</span>
                        </div>
                    </c:if>

                    <c:if test="${param.expired != null}">
                        <div class="alert alert-warning py-3 text-center rounded-3 border-warning">
                            <i class="bi bi-exclamation-triangle-fill fs-4 d-block mb-1 text-warning"></i>
                            <span class="fw-bold text-dark">Phiên đăng nhập đã hết hạn hoặc tài khoản vừa bị khóa! Vui lòng đăng nhập lại.</span>
                        </div>
                    </c:if>

                    <c:if test="${param.logout != null}">
                        <div class="alert alert-info py-2 text-center rounded-3"><i class="bi bi-info-circle-fill me-1"></i>Bạn đã đăng xuất thành công.</div>
                    </c:if>
                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success py-2 text-center rounded-3"><i class="bi bi-check-circle-fill me-1"></i>${successMsg}</div>
                    </c:if>

                    <form action="/login" method="POST">
                        <div class="form-floating mb-3">
                            <input type="email" class="form-control rounded-3" id="email" name="username" placeholder="name@example.com" required>
                            <label for="email">Địa chỉ Email</label>
                        </div>
                        <div class="form-floating mb-4 password-wrapper">
                            <input type="password" class="form-control rounded-3 pe-5" id="password" name="password" placeholder="Mật khẩu" required>
                            <label for="password">Mật khẩu</label>
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('password', 'passwordIcon')" aria-label="Hiện/ẩn mật khẩu">
                                <i id="passwordIcon" class="bi bi-eye"></i>
                            </button>
                        </div>
                        
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <button type="submit" class="btn btn-primary w-100 py-2 fs-5 fw-bold rounded-3 mb-3 shadow-sm">
                            Đăng nhập
                        </button>
                    </form>

                    <div class="text-center mb-3">
                        <a href="/oauth2/authorization/google" class="btn btn-outline-secondary w-100 py-2 fs-5 fw-bold rounded-3 shadow-sm">
                            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 48 48'%3E%3Cpath fill='%23FFC107' d='M43.611 20.083H42V20H24v8h11.303C33.655 32.657 29.243 36 24 36c-6.627 0-12-5.373-12-12s5.373-12 12-12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C34.046 6.053 29.268 4 24 4 12.955 4 4 12.955 4 24s8.955 20 20 20 20-8.955 20-20c0-1.341-.138-2.65-.389-3.917z'/%3E%3Cpath fill='%23FF3D00' d='M6.306 14.691l6.571 4.819C14.655 15.108 18.961 12 24 12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C34.046 6.053 29.268 4 24 4c-7.682 0-14.417 4.337-17.694 10.691z'/%3E%3Cpath fill='%234CAF50' d='M24 44c5.166 0 9.86-1.977 13.409-5.193l-6.19-5.238C29.143 35.091 26.715 36 24 36c-5.221 0-9.617-3.329-11.283-7.946l-6.521 5.025C9.438 39.556 16.227 44 24 44z'/%3E%3Cpath fill='%231976D2' d='M43.611 20.083H42V20H24v8h11.303a12.048 12.048 0 0 1-4.084 5.569l6.19 5.238C37.001 39.2 44 34 44 24c0-1.341-.138-2.65-.389-3.917z'/%3E%3C/svg%3E" alt="Google" width="20" height="20" class="me-2">
                            Đăng nhập với Google
                        </a>
                    </div>

                    <div class="text-center">
                        <p class="mb-0 text-muted">Chưa có tài khoản? <a href="/register" class="text-decoration-none fw-bold">Đăng ký ngay</a></p>
                        <a href="/" class="text-decoration-none text-secondary mt-3 d-block small"><i class="bi bi-arrow-left"></i> Quay lại trang chủ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);

            if (!input || !icon) {
                return;
            }

            const isPassword = input.type === 'password';
            input.type = isPassword ? 'text' : 'password';
            icon.classList.toggle('bi-eye', !isPassword);
            icon.classList.toggle('bi-eye-slash', isPassword);
        }
    </script>

</body>
</html>