<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kiểm duyệt Tin tuyển dụng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container my-5">
        <h3 class="fw-bold mb-4 text-dark"><i class="bi bi-briefcase me-2"></i>Kiểm duyệt Tin Tuyển dụng</h3>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4 py-3">Công việc / Công ty</th>
                                <th class="py-3">Địa điểm</th>
                                <th class="text-center py-3">Trạng thái</th>
                                <th class="text-center py-3">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="job" items="${jobs}">
                                <tr>
                                    <td class="ps-4">
                                        <a href="/job/${job.id}" target="_blank" class="fw-bold text-decoration-none text-primary d-block">${job.title}</a>
                                        <small class="text-muted">${job.companyName}</small>
                                    </td>
                                    <td><span class="small text-muted"><i class="bi bi-geo-alt me-1"></i>${job.location}</span></td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${job.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split"></i> Chờ duyệt</span>
                                            </c:when>
                                            <c:when test="${job.status == 'APPROVED'}">
                                                <span class="badge bg-success"><i class="bi bi-check-circle"></i> Đang hiển thị</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary"><i class="bi bi-x-circle"></i> Đã đóng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            
                                            <a href="/job/${job.id}" class="btn btn-sm btn-outline-info" target="_blank" title="Xem trước"><i class="bi bi-eye"></i></a>
                                            
                                            <c:if test="${job.status == 'PENDING'}">
                                                <form action="/admin/jobs/approve" method="POST" class="m-0">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <input type="hidden" name="jobId" value="${job.id}">
                                                    <button type="submit" class="btn btn-sm btn-success" title="Phê duyệt tin"><i class="bi bi-check-lg"></i></button>
                                                </form>
                                            </c:if>

                                            <c:if test="${job.status != 'REJECTED'}">
                                                <form action="/admin/jobs/reject" method="POST" class="m-0">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <input type="hidden" name="jobId" value="${job.id}">
                                                    <button type="submit" class="btn btn-sm btn-danger" title="Từ chối/Đóng tin" onclick="return confirm('Bạn có chắc chắn muốn đóng/từ chối tin này không?');">
                                                        <i class="bi bi-slash-circle"></i>
                                                    </button>
                                                </form>
                                            </c:if>

                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${empty jobs}">
                        <div class="text-center py-5 text-muted">Chưa có tin tuyển dụng nào trên hệ thống.</div>
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