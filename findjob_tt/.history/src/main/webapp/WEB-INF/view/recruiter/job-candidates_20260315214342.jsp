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

    <div class="container py-5" style="margin-top: 80px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Danh sách ứng viên</h3>
                <p class="text-muted">Vị trí: <span class="text-primary fw-bold">${job.title}</span></p>
            </div>
            <a href="/recruiter/dashboard" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại Dashboard
            </a>
        </div>

        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-primary">
                        <tr>
                            <th class="ps-4 py-3">STT</th>
                            <th>Tên Ứng viên</th>
                            <th>Email liên hệ</th>
                            <th>Ngày ứng tuyển</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="app" items="${applications}" varStatus="status">
                            <tr>
                                <td class="ps-4 text-muted">${status.index + 1}</td>
                                <td class="fw-bold">${app.candidateName}</td>
                                <td>${app.candidateEmail}</td>
                                <td class="small text-muted">${app.formattedApplyDate}</td>
                                <td class="text-center">
                                    <a href="/uploads/cv_files/${app.cvFileName}" target="_blank" class="btn btn-sm btn-success px-3">
                                        <i class="bi bi-eye"></i> Xem CV
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty applications}">
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">
                                    <i class="bi bi-person-x fs-1 d-block mb-2"></i>
                                    Chưa có ứng viên nào ứng tuyển cho vị trí này.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
</body>
</html>