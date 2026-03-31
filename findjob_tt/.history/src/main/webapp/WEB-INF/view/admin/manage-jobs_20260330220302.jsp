<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Tin tuyển dụng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .table thead { background-color: #f8f9fa; }
        .job-row { transition: all 0.2s; }
        .job-row:hover { background-color: #f8f9fa; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container my-5" style="padding-top: 20px;">

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success fw-bold alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger fw-bold alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-4 mt-2">
            <div>
                <h2 class="fw-bold mb-1 text-dark"><i class="bi bi-briefcase-fill text-primary me-2"></i>Quản lý Tin tuyển dụng</h2>
                <p class="text-muted mb-0">Duyệt hoặc từ chối các tin tuyển dụng chờ phê duyệt.</p>
            </div>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light text-secondary small text-uppercase">
                            <tr>
                                <th class="text-center py-3" width="5%">STT</th>
                                <th class="ps-4 py-3" width="25%">Công việc</th>
                                <th class="py-3" width="20%">Công ty</th>
                                <th class="py-3" width="15%">Người đăng</th>
                                <th class="py-3" width="15%">Ngày tạo</th>
                                <th class="text-center py-3" width="20%">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="job" items="${pendingJobs}" varStatus="status">
                                <tr class="job-row">
                                    <td class="text-center align-middle stt-cell">${status.index + 1}</td>
                                    <td class="ps-4 align-middle">
                                        <div class="fw-bold text-primary">${job.title}</div>
                                        <small class="text-muted"><i class="bi bi-geo-alt me-1"></i>${job.location}</small>
                                    </td>
                                    <td class="align-middle">
                                        <div class="fw-semibold">${job.companyName}</div>
                                        <small class="text-muted">${job.category != null ? job.category.name : 'Chưa phân loại'}</small>
                                    </td>
                                    <td class="align-middle">
                                        <div>${job.user.fullName}</div>
                                        <small class="text-muted">${job.user.email}</small>
                                    </td>
                                    <td class="align-middle text-muted small">
                                        ${job.formattedCreatedAt}
                                    </td>
                                    <td class="text-center align-middle">
                                        <div class="btn-group" role="group">
                                            <form action="/admin/approve-job/${job.id}" method="post" class="d-inline">
                                                <button type="submit" class="btn btn-success btn-sm" title="Duyệt">
                                                    <i class="bi bi-check-lg"></i> Duyệt
                                                </button>
                                            </form>
                                            <form action="/admin/reject-job/${job.id}" method="post" class="d-inline ms-1">
                                                <button type="submit" class="btn btn-danger btn-sm" title="Từ chối"
                                                        onclick="return confirm('Bạn có chắc muốn từ chối tin tuyển dụng này?')">
                                                    <i class="bi bi-x-lg"></i> Từ chối
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <c:if test="${empty pendingJobs}">
                        <div class="text-center py-5">
                            <i class="bi bi-check-circle fs-1 text-success d-block mb-3 opacity-50"></i>
                            <h5 class="text-muted fw-bold">Không có tin tuyển dụng nào chờ duyệt</h5>
                            <p class="small text-muted">Tất cả tin tuyển dụng đã được xử lý.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>