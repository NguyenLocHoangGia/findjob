<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Tin tuyển dụng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container my-5">
        <h3 class="fw-bold mb-4 text-dark"><i class="bi bi-briefcase me-2"></i>Quản lý Tin Tuyển dụng</h3>

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

        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation" class="mt-4">
                <ul class="pagination justify-content-center mb-0">
                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                        <a class="page-link shadow-none" href="?page=${currentPage - 1}"><i class="bi bi-chevron-left"></i> Trước</a>
                    </li>
                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link shadow-none" href="?page=${i}">${i + 1}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                        <a class="page-link shadow-none" href="?page=${currentPage + 1}">Sau <i class="bi bi-chevron-right"></i></a>
                    </li>
                </ul>
            </nav>
        </c:if>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>