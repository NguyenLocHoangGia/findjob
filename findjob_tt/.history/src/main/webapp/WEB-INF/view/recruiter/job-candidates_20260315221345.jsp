<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Ứng viên cho: ${job.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        /* Cấu trúc Layout giống Dashboard để đồng bộ Sidebar */
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        .content-area { display: flex; flex-direction: column; flex: 1; }
        .main-content { flex: 1; padding: 30px; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="main-wrapper">
        <jsp:include page="layout/sidebar.jsp" />

        <div class="content-area">
            <div class="main-content">
                <div class="container-fluid">
                    
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="/recruiter/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Danh sách ứng viên</li>
                        </ol>
                    </nav>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h3 class="fw-bold mb-1 text-dark">Ứng viên ứng tuyển</h3>
                            <p class="text-muted mb-0">Công việc: <span class="text-primary fw-bold">${job.title}</span></p>
                        </div>
                        <a href="/recruiter/dashboard" class="btn btn-outline-secondary shadow-sm">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>
                    </div>

                    <div class="card shadow-sm border-0 rounded-3">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
    <thead class="table-light">
        <tr>
            <th class="ps-4">Tên Ứng viên</th>
            <th>Email</th>
            <th>Ngày nộp</th>
            <th class="text-center">Trạng thái</th> <th class="text-center">Thao tác</th>
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
                
                <td class="align-middle text-center">
                    <c:choose>
                        <c:when test="${app.status == 'APPROVED'}">
                            <span class="badge bg-success"><i class="bi bi-heart-fill me-1"></i> Đã chấp nhận</span>
                        </c:when>
                        <c:when test="${app.status == 'REJECTED'}">
                            <span class="badge bg-danger"><i class="bi bi-x-lg me-1"></i> Đã từ chối</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary">Đang chờ</span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <td class="text-center align-middle">
                    <div class="btn-group">
                        <a href="/recruiter/application/${app.id}/status/approve" 
                           class="btn btn-sm btn-outline-success ${app.status == 'APPROVED' ? 'active' : ''}" 
                           title="Đồng ý tuyển dụng">
                            <i class="bi bi-heart"></i>
                        </a>
                        
                        <a href="/recruiter/application/${app.id}/status/reject" 
                           class="btn btn-sm btn-outline-danger ms-1 ${app.status == 'REJECTED' ? 'active' : ''}" 
                           title="Không phù hợp">
                            <i class="bi bi-x-lg"></i>
                        </a>

                        <a href="/uploads/cv_files/${app.cvFileName}" target="_blank" class="btn btn-sm btn-outline-primary ms-1">
                            <i class="bi bi-file-earmark-pdf"></i> CV
                        </a>
                        
                        <a href="/recruiter/candidate-profile/${app.user.id}" class="btn btn-sm btn-outline-secondary ms-1">
                            <i class="bi bi-person"></i> Profile
                        </a>
                    </div>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <jsp:include page="layout/footer.jsp" />
        </div>
    </div>

</body>
</html>