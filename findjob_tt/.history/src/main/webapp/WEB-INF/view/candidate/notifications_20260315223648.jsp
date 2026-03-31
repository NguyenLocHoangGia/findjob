<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông báo của bạn - Ứng viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, sans-serif; }
        .notification-item { transition: 0.2s; border-left: 4px solid transparent; }
        .notification-item.unread { border-left-color: #0d6efd; background-color: #f0f7ff; }
        .notification-item:hover { background-color: #f8f9fa; }
    </style>
</head>
<body>
    <jsp:include page="layout/header.jsp" />

    <div class="container my-5" style="padding-top: 80px;">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow-sm border-0 rounded-4 p-4">
                    <div class="d-flex align-items-center border-bottom pb-3 mb-4">
                        <div class="bg-warning text-white rounded-circle d-flex align-items-center justify-content-center me-3 shadow" style="width: 60px; height: 60px; font-size: 24px;">
                            <i class="bi bi-bell-fill"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark">Thông báo hệ thống</h3>
                            <p class="text-muted mb-0">Cập nhật trạng thái hồ sơ ứng tuyển của bạn</p>
                        </div>
                    </div>

                    <div class="list-group list-group-flush rounded-3 border">
                        <c:forEach var="n" items="${notifications}">
                            <div class="list-group-item notification-item p-4 ${n.read ? '' : 'unread'}">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <p class="mb-1 text-dark fw-medium">${n.message}</p>
                                        <small class="text-muted"><i class="bi bi-clock me-1"></i>${n.createdAt}</small>
                                    </div>
                                    <c:if test="${!n.read}">
                                        <span class="badge rounded-pill bg-primary px-2 py-1" style="font-size: 0.6rem;">Mới</span>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty notifications}">
                            <div class="text-center py-5">
                                <i class="bi bi-chat-dots-fill text-muted opacity-25" style="font-size: 4rem;"></i>
                                <h5 class="text-muted mt-3">Hộp thư trống</h5>
                                <p class="text-muted small">Mọi cập nhật về hồ sơ sẽ xuất hiện tại đây.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>