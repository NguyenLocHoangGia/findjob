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
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-primary text-white">
                                        <tr>
                                            <th class="ps-4 py-3" width="8%">STT</th>
                                            <th width="25%">Tên Ứng viên</th>
                                            <th width="25%">Email liên hệ</th>
                                            <th width="22%">Ngày ứng tuyển</th>
                                            <th class="text-center" width="20%">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="app" items="${applications}" varStatus="status">
                                            <tr>
                                                <td class="ps-4 text-muted fw-bold">${status.index + 1}</td>
                                                <td>
                                                    <div class="fw-bold text-dark">${app.candidateName}</div>
                                                </td>
                                                <td>${app.candidateEmail}</td>
                                                <td class="small text-muted">
                                                    <i class="bi bi-clock me-1"></i> ${app.formattedApplyDate}
                                                </td>
                                                <td class="text-center">
                                                    <a href="/uploads/cv_files/${app.cvFileName}" target="_blank" class="btn btn-sm btn-success px-3 shadow-sm">
                                                        <i class="bi bi-file-earmark-pdf"></i> Xem CV
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <c:if test="${empty applications}">
                                            <tr>
                                                <td colspan="5" class="text-center py-5">
                                                    <div class="text-muted">
                                                        <i class="bi bi-person-x fs-1 d-block mb-3 opacity-50"></i>
                                                        <h5>Chưa có hồ sơ nào</h5>
                                                        <p class="small">Khi có ứng viên nộp đơn, danh sách sẽ hiển thị tại đây.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
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