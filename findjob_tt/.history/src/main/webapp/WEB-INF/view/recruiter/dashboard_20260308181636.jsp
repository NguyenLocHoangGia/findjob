<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Hồ sơ - Nhà tuyển dụng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-5">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold text-warning" href="#">JobPortal Recruiter</a>
            <div class="d-flex">
                <span class="text-white me-3 mt-2">Xin chào, HR Tech Asia</span>
                <button class="btn btn-outline-light btn-sm">Đăng xuất</button>
            </div>
        </div>
    </nav>

    <div class="container-fluid px-5">
        <h2 class="fw-bold mb-4">Danh sách Ứng viên mới nhất</h2>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <table class="table table-hover table-bordered mb-0">
                    <thead class="table-primary">
                        <tr>
                            <th scope="col" class="text-center" width="5%">STT</th>
                            <th scope="col" width="15%">Tên Ứng viên</th>
                            <th scope="col" width="20%">Email</th>
                            <th scope="col" width="25%">Vị trí ứng tuyển</th>
                            <th scope="col" width="15%">Ngày nộp</th>
                            <th scope="col" class="text-center" width="20%">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="app" items="${applications}" varStatus="status">
                            <tr>
                                <td class="text-center align-middle">${status.index + 1}</td>
                                <td class="align-middle fw-bold">${app.candidateName}</td>
                                <td class="align-middle">${app.candidateEmail}</td>
                                <td class="align-middle text-primary">${app.job.title}</td>
                                <td class="align-middle">${app.formattedApplyDate}</td>
                                <td class="text-center align-middle">
                                    
                                    <a href="/uploads/cv/${app.cvFileName}" target="_blank" class="btn btn-sm btn-success">
                                        <i class="bi bi-eye"></i> Xem CV
                                    </a>
                                    
                                    <button class="btn btn-sm btn-outline-danger ms-1">
                                        <i class="bi bi-trash"></i> Từ chối
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty applications}">
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">Chưa có ứng viên nào nộp hồ sơ.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>