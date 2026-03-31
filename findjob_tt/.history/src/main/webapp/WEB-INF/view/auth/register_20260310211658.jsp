<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
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

                    <form action="/register" method="POST">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="fullName" name="fullName" placeholder="Họ và tên" required>
                            <label for="fullName">Họ và tên của bạn</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="email" class="form-control rounded-3" id="email" name="email" placeholder="name@example.com" required>
                            <label for="email">Địa chỉ Email</label>
                        </div>
                        <div class="form-floating mb-4">
                            <input type="password" class="form-control rounded-3" id="password" name="password" placeholder="Mật khẩu" required minlength="6">
                            <label for="password">Mật khẩu (Ít nhất 6 ký tự)</label>
                        </div>

                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

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

</body>
</html>