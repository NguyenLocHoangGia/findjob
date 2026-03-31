<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý công việc - Nhà tuyển dụng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        .content-area { display: flex; flex-direction: column; flex: 1; }
        .main-content { flex: 1; padding: 30px; }
        .job-title-link { text-decoration: none; color: #0d6efd; transition: 0.2s; }
        .job-title-link:hover { text-decoration: underline; color: #0a58ca; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="main-wrapper">
        <jsp:include page="layout/sidebar.jsp" />

        <div class="content-area">
            <div class="main-content">
                <div class="container-fluid">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold mb-0">Công việc đã đăng tải</h3>
                        <a href="/recruiter/post-job" class="btn btn-primary fw-bold">
                            <i class="bi bi-plus-lg me-2"></i> Đăng tin mới
                        </a>
                    </div>

                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success alert-dismissible fade show fw-bold" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${successMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="card shadow-sm border-0">
                        <div class="card-body p-0">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-center" width="5%">STT</th>
                                        <th width="35%">Tiêu đề công việc</th>
                                        <th width="15%">Số lượng ứng tuyển</th>
                                        <th width="15%">Ngày đăng</th>
                                        <th class="text-center" width="30%">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="job" items="${jobs}" varStatus="status">
                                        <tr>
                                            <td class="text-center align-middle">${status.index + 1}</td>
                                            <td class="align-middle">
                                                <a href="/job/${job.id}" target="_blank" class="job-title-link fw-bold">
                                                    ${job.title}
                                                </a>
                                                <div class="small text-muted"><i class="bi bi-geo-alt me-1"></i>${job.location}</div>
                                            </td>
                                            <td class="align-middle text-center">
                                                <span class="badge bg-info text-dark rounded-pill px-3">
                                                    ${job.applications.size()} ứng viên
                                                </span>
                                            </td>
                                            <td class="align-middle text-muted small">${job.formattedCreatedAt}</td>
                                            <td class="text-center align-middle">
                                                <a href="/recruiter/job/${job.id}/candidates" class="btn btn-sm btn-outline-primary shadow-sm">
                                                    <i class="bi bi-people"></i> Ứng viên
                                                </a>
                                                
                                                <a href="/recruiter/edit-job/${job.id}" class="btn btn-sm btn-outline-warning ms-1 shadow-sm">
                                                    <i class="bi bi-pencil"></i> Sửa
                                                </a>

                                                <button class="btn btn-sm btn-outline-danger ms-1 shadow-sm" 
                                                        onclick="confirmDelete('${job.id}', '${job.title}')">
                                                    <i class="bi bi-trash"></i> Xóa
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty jobs}">
                                        <tr>
                                            <td colspan="5" class="text-center p-5 text-muted">
                                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                                Bạn chưa đăng tải công việc nào.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <jsp:include page="layout/footer.jsp" />
        </div>
    </div>

    <script>
        function confirmDelete(id, title) {
            if (confirm('Bạn có chắc chắn muốn xóa công việc "' + title + '"? \nLưu ý: Toàn bộ hồ sơ ứng tuyển liên quan cũng sẽ bị xóa!')) {
                window.location.href = '/recruiter/delete-job/' + id;
            }
        }
    </script>
</body>
</html>