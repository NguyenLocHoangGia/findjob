<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông báo của bạn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .notification-card { transition: 0.3s; border-left: 4px solid transparent; }
        .notification-card.unread { border-left-color: #0d6efd; background-color: #f0f7ff; }
        .notification-card:hover { transform: translateX(5px); }
    </style>
</head>
<body>
    <jsp:include page="layout/header.jsp" />

    <div class="container my-5" style="padding-top: 60px;">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold mb-0 text-dark">
                        <i class="bi bi-bell-fill text-warning me-2"></i>Thông báo
                    </h3>
                </div>

                <div class="card shadow-sm border-0 rounded-4">
                    <div class="list-group list-group-flush rounded-4">
                        <c:forEach var="n" items="${notifications}">
                            <div class="list-group-item notification-card p-4 ${n.read ? '' : 'unread'}">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="me-3">
                                        <p class="mb-1 text-dark">${n.message}</p>
                                        <small class="text-muted">
                                            <i class="bi bi-clock me-1"></i>
                                            ${n.createdAt}
                                        </small>
                                    </div>
                                    <c:if test="${!n.read}">
                                        <span class="badge rounded-pill bg-primary" style="font-size: 0.6rem;">Mới</span>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty notifications}">
                            <div class="text-center py-5">
                                <i class="bi bi-chat-dots fs-1 text-muted"></i>
                                <p class="text-muted mt-3">Bạn chưa nhận được thông báo nào.</p>
                                <a href="/" class="btn btn-sm btn-primary">Tìm việc ngay</a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>


</body>
</html>