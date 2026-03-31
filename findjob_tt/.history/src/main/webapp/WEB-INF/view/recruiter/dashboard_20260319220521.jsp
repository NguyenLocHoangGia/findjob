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
        .hover-lift { transition: transform 0.3s ease; }
        .hover-lift:hover { transform: translateY(-5px); }
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
                            <h3 class="fw-bold mb-1">Bảng điều khiển</h3>
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

                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="card bg-primary text-white border-0 shadow-sm rounded-4 h-100 p-3 hover-lift">
                                <div class="card-body d-flex align-items-center">
                                    <div class="bg-white bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 65px; height: 65px;">
                                        <i class="bi bi-briefcase-fill fs-2"></i>
                                    </div>
                                    <div>
                                        <p class="mb-0 text-white-50 fw-semibold text-uppercase" style="font-size: 0.8rem; letter-spacing: 0.5px;">Tổng chiến dịch</p>
                                        <h2 class="mb-0 fw-bold display-6">${not empty totalJobs ? totalJobs : 0}</h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="card bg-success text-white border-0 shadow-sm rounded-4 h-100 p-3 hover-lift">
                                <div class="card-body d-flex align-items-center">
                                    <div class="bg-white bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 65px; height: 65px;">
                                        <i class="bi bi-people-fill fs-2"></i>
                                    </div>
                                    <div>
                                        <p class="mb-0 text-white-50 fw-semibold text-uppercase" style="font-size: 0.8rem; letter-spacing: 0.5px;">Tổng hồ sơ nhận</p>
                                        <h2 class="mb-0 fw-bold display-6">${not empty totalCandidates ? totalCandidates : 0}</h2>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card bg-warning text-dark border-0 shadow-sm rounded-4 h-100 p-3 hover-lift">
                                <div class="card-body d-flex align-items-center">
                                    <div class="bg-dark bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 65px; height: 65px;">
                                        <i class="bi bi-hourglass-split fs-2"></i>
                                    </div>
                                    <div>
                                        <p class="mb-0 text-dark opacity-75 fw-semibold text-uppercase" style="font-size: 0.8rem; letter-spacing: 0.5px;">Chờ xử lý</p>
                                        <div class="d-flex align-items-center">
                                            <h2 class="mb-0 fw-bold display-6">${not empty pendingCandidates ? pendingCandidates : 0}</h2>
                                            <c:if test="${pendingCandidates > 0}">
                                                <span class="spinner-grow spinner-grow-sm text-danger ms-2" role="status" aria-hidden="true"></span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-list-task me-2 text-primary"></i>Danh sách công việc</h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr class="text-secondary small text-uppercase">
                                            <th class="text-center py-3" width="5%">STT</th>
                                            <th class="py-3" width="35%">Chi tiết công việc</th>
                                            <th class="text-center py-3" width="15%">Ứng tuyển</th>
                                            <th class="py-3" width="15%">Ngày đăng</th>
                                            <th class="text-center py-3" width="30%">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="job" items="${jobs}" varStatus="status">
                                            <tr>
                                                <td class="text-center align-middle">${status.index + 1}</td>
                                                <td class="align-middle">
                                                    <a href="/job/${job.id}" target="_blank" class="job-title-link fw-bold">${job.title}</a>
                                                    <div class="small text-muted"><i class="bi bi-geo-alt me-1"></i>${job.location}</div>
                                                </td>
                                                <td class="text-center align-middle">
                                                    <span class="badge bg-info-subtle text-info-emphasis rounded-pill px-3 py-1">
                                                        ${not empty job.applications ? job.applications.size() : 0} hồ sơ
                                                    </span>
                                                </td>
                                                <td class="align-middle text-muted small">
                                                    <i class="bi bi-calendar3 me-1"></i> ${job.formattedCreatedAt} 
                                                </td>
                                                <td class="text-center align-middle">
                                                    <div class="btn-group shadow-sm">
                                                        <a href="/recruiter/job/${job.id}/candidates" class="btn btn-sm btn-outline-primary" title="Xem ứng viên">
                                                            <i class="bi bi-people-fill"></i> Ứng viên
                                                        </a>
                                                        <a href="/recruiter/edit-job/${job.id}" class="btn btn-sm btn-outline-warning" title="Sửa công việc">
                                                            <i class="bi bi-pencil-square"></i> Sửa
                                                        </a>
                                                        <button class="btn btn-sm btn-outline-danger" onclick="confirmDelete('${job.id}', '${job.title}')" title="Xóa">
                                                            <i class="bi bi-trash"></i> Xóa
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty jobs}">
                                            <tr>
                                                <td colspan="5" class="text-center py-5">
                                                    <div class="py-4">
                                                        <i class="bi bi-clipboard-x fs-1 text-muted d-block mb-3 opacity-50"></i>
                                                        <h5 class="text-muted fw-bold">Bạn chưa có bài đăng nào</h5>
                                                        <p class="small text-muted">Bắt đầu thu hút nhân tài bằng cách đăng tin tuyển dụng đầu tiên.</p>
                                                        <a href="/recruiter/post-job" class="btn btn-primary btn-sm mt-2 rounded-pill px-4">Đăng tin ngay</a>                                                    
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(id, title) {
            if (confirm('XÁC NHẬN XÓA: "' + title + '"?\n\nHệ thống sẽ xóa vĩnh viễn công việc này cùng toàn bộ hồ sơ ứng viên đã nộp. Thao tác này không thể hoàn tác!')) {
                window.location.href = '/recruiter/delete-job/' + id;
            }
        }
    </script>
</body>
</html>