<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
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
                        <div class="alert alert-danger py-2 text-center">Email hoặc mật khẩu không chính xác!</div>
                    </c:if>
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-info py-2 text-center">Bạn đã đăng xuất thành công.</div>
                    </c:if>
                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success py-2 text-center">${successMsg}</div>
                    </c:if>

                    <form action="/login" method="POST">
                        <div class="form-floating mb-3">
                            <input type="email" class="form-control rounded-3" id="email" name="username" placeholder="name@example.com" required>
                            <label for="email">Địa chỉ Email</label>
                        </div>
                        <div class="form-floating mb-4">
                            <input type="password" class="form-control rounded-3" id="password" name="password" placeholder="Mật khẩu" required>
                            <label for="password">Mật khẩu</label>
                        </div>
                        
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <button type="submit" class="btn btn-primary w-100 py-2 fs-5 fw-bold rounded-3 mb-3">
                            Đăng nhập
                        </button>
                    </form>

                    <div class="text-center">
                        <p class="mb-0 text-muted">Chưa có tài khoản? <a href="/register" class="text-decoration-none fw-bold">Đăng ký ngay</a></p>
                        <a href="/" class="text-decoration-none text-secondary mt-2 d-block small"><i class="bi bi-arrow-left"></i> Quay lại trang chủ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>