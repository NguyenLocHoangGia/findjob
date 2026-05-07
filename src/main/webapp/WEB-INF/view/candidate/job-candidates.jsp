<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Ứng viên cho: ${job.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">
    <jsp:include page="layout/header.jsp" />

    <div class="container py-5" style="margin-top: 70px;">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/recruiter/dashboard">Dashboard</a></li>
                <li class="breadcrumb-item active">Danh sách ứng viên</li>
            </ol>
        </nav>

        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body bg-primary text-white rounded">
                <h4 class="fw-bold mb-1">Ứng viên ứng tuyển vị trí: ${job.title}</h4>
                <p class="mb-0 opacity-75"><i class="bi bi-geo-alt me-1"></i> ${job.location} | <i class="bi bi-people me-1"></i> ${job.applications.size()} ứng viên</p>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Tên Ứng viên</th>
                            <th>Email</th>
                            <th>Ngày nộp</th>
                            <th class="text-center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="app" items="${applications}">
                            <tr>
                                <td class="ps-4 align-middle">
                                    <div class="fw-bold">${app.candidateName}</div>
                                </td>
                                <td class="align-middle">${app.candidateEmail}</td>
                                <td class="align-middle text-muted small">${app.formattedApplyDate}</td>
                                <td class="text-center align-middle">
                                    <a href="/uploads/cv_files/${app.cvFileName}" target="_blank" class="btn btn-sm btn-success">
                                        <i class="bi bi-file-earmark-pdf me-1"></i> Xem CV
                                    </a>
                                    <a href="/recruiter/candidate-profile/${app.user.id}" class="btn btn-sm btn-outline-secondary ms-1">
                                        <i class="bi bi-person"></i> Hồ sơ
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty applications}">
                            <tr>
                                <td colspan="4" class="text-center py-5 text-muted">
                                    Chưa có ứng viên nào ứng tuyển cho vị trí này.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="mt-4">
            <a href="/recruiter/dashboard" class="btn btn-secondary">
                <i class="bi bi-arrow-left me-2"></i> Quay lại Dashboard
            </a>
        </div>
    </div>
</body>
</html>