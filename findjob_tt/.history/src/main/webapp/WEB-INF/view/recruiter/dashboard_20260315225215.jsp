<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng điều khiển - Nhà tuyển dụng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        .content-area { display: flex; flex-direction: column; flex: 1; }
        .main-content { flex: 1; padding: 30px; }
        .job-title-link { text-decoration: none; color: #0d6efd; transition: 0.2s; }
        .job-title-link:hover { text-decoration: underline; color: #0a58ca; }
        .table thead { background-color: #f8f9fa; }
        .card { border-radius: 12px; }
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
                        <div>
                            <h3 class="fw-bold mb-1">Công việc đã đăng tải</h3>
                            <p class="text-muted small mb-0">Quản lý các tin tuyển dụng và theo dõi ứng viên của bạn.</p>
                        </div>
                        <a href="/recruiter/post-job" class="btn btn-primary fw-bold shadow-sm">
                            <i class="bi bi-plus-lg me-2"></i> Đăng tin mới
                        </a>
                    </div>

                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success alert-dismissible fade show fw-bold border-0 shadow-sm" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${successMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="card shadow-sm border-0">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr class="text-secondary small text-uppercase">
                                            <th class="text-center py-3" width="5%">STT</th>
                                            <th class="py-3" width="40%">Chi tiết công việc</th>
                                            <th class="text-center py-3" width="15%">Ứng tuyển</th>
                                            <th class="py-3" width="15%">Ngày đăng</th>
                                            <th class="text-center py-3" width="25%">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="job" items="${jobs}" varStatus="status">
                                            <tr>
                                                <td class="text-center align-middle">${status.index + 1}</td>
                                                <td class="align-middle">
                                                    <a href="/job/${job.id}" target="_blank" class="job-title-link fw-bold">${job.title}</a>
                                                    <div class="small text-muted">${job.location}</div>
                                                </td>
                                                <td class="text-center align-middle">
                                                    <span class="badge bg-info text-dark rounded-pill">
                                                        ${not empty job.applications ? job.applications.size() : 0} ứng viên
                                                    </span>
                                                </td>
                                                <td class="align-middle text-muted small">
                                                    ${job.formattedCreatedAt} </td>
                                                <td class="text-center align-middle">
                                                    <div class="btn-group">
                                                        <a href="/recruiter/job/${job.id}/candidates" class="btn btn-sm btn-outline-primary">Ứng viên</a>
                                                        <button class="btn btn-sm btn-outline-danger" onclick="confirmDelete('${job.id}', '${job.title}')">Xóa</button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty currentUser.jobs}">
                                            <tr>
                                                <td colspan="5" class="text-center py-5">
                                                    <div class="py-4">
                                                        <i class="bi bi-clipboard-x fs-1 text-muted d-block mb-3"></i>
                                                        <h5 class="text-muted">Bạn chưa có bài đăng nào</h5>
                                                        <p class="small text-muted">Bắt đầu thu hút nhân tài bằng cách đăng tin tuyển dụng đầu tiên.</p>                                                    </div>
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

    <script>
        function confirmDelete(id, title) {
            if (confirm('XÁC NHẬN XÓA: "' + title + '"?\n\nHệ thống sẽ xóa vĩnh viễn công việc này cùng toàn bộ hồ sơ ứng viên đã nộp. Thao tác này không thể hoàn tác!')) {
                window.location.href = '/recruiter/delete-job/' + id;
            }
        }
    </script>
</body>
</html>