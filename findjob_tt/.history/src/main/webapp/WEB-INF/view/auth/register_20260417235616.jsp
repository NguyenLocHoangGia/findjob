<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Đăng ký - JobPortal</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <style>
                .hover-lift {
                    transition: transform 0.2s ease, box-shadow 0.2s ease;
                }

                .hover-lift:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 .5rem 1rem rgba(0, 0, 0, .15) !important;
                }

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
                                    <input type="text" class="form-control rounded-3" id="fullName" name="fullName"
                                        placeholder="Họ và tên" required minlength="3" maxlength="20">
                                    <label for="fullName">Họ và tên của bạn</label>
                                </div>
                                <div class="form-floating mb-3">
                                    <input type="email" class="form-control rounded-3" id="email" name="email"
                                        placeholder="name@example.com" required>
                                    <label for="email">Địa chỉ Email</label>
                                </div>
                                <div class="form-floating mb-3 password-wrapper">
                                    <input type="password" class="form-control rounded-3 pe-5" id="password" name="password"
                                        placeholder="Mật khẩu" required minlength="6" maxlength="20">
                                    <label for="password">Mật khẩu (6 - 20 ký tự)</label>
                                    <button type="button" class="password-toggle-btn" onclick="togglePassword('password', 'passwordIcon')"
                                        aria-label="Hiện/ẩn mật khẩu">
                                        <i id="passwordIcon" class="bi bi-eye"></i>
                                    </button>
                                </div>

                                <div class="form-floating mb-4 password-wrapper">
                                    <input type="password" class="form-control rounded-3 pe-5" id="confirmPassword"
                                        name="confirmPassword" placeholder="Xác nhận mật khẩu" required minlength="6" maxlength="20">
                                    <label for="confirmPassword">Xác nhận mật khẩu</label>
                                    <button type="button" class="password-toggle-btn" onclick="togglePassword('confirmPassword', 'confirmPasswordIcon')"
                                        aria-label="Hiện/ẩn mật khẩu xác nhận">
                                        <i id="confirmPasswordIcon" class="bi bi-eye"></i>
                                    </button>
                                </div>

                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <input type="hidden" name="roleName" value="ROLE_CANDIDATE">

                                <button type="submit" class="btn btn-success w-100 py-2 fs-5 fw-bold rounded-3 mb-3">
                                    Đăng ký
                                </button>
                            </form>

                            <div class="text-center">
                                <p class="mb-0 text-muted">Đã có tài khoản? <a href="/login"
                                        class="text-decoration-none fw-bold">Đăng nhập</a></p>
                                <a href="/" class="text-decoration-none text-secondary mt-2 d-block small"><i
                                        class="bi bi-arrow-left"></i> Quay lại trang chủ</a>
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