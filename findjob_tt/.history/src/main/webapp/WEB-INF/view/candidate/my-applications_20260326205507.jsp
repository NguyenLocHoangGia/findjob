<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử Ứng tuyển | JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .application-card { border-radius: 12px; transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .application-card:hover { transform: translateY(-3px); box-shadow: 0 .5rem 1rem rgba(0,0,0,.1)!important; }
        .job-title { text-decoration: none; color: #212529; font-weight: 700; transition: color 0.2s; }
        .job-title:hover { color: #0d6efd; }
        .company-logo { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid #dee2e6; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container py-5 mt-4" style="min-height: 80vh;">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                
                <h3 class="fw-bold mb-1">Lịch sử Ứng tuyển</h3>
                <p class="text-muted mb-4">Theo dõi trạng thái các công việc bạn đã nộp hồ sơ.</p>

                <div class="card shadow-sm border-0" style="border-radius: 16px;">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light text-secondary text-uppercase small">
                                    <tr>
                                        <th class="ps-4 py-3" width="45%">Công việc / Công ty</th>
                                        <th class="py-3" width="20%">Ngày nộp</th>
                                        <th class="text-center py-3" width="20%">Trạng thái</th>
                                        <th class="text-center py-3" width="15%">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="app" items="${applications}">
                                        <tr>
                                            <td class="ps-4 py-3">
                                                <div class="d-flex align-items-center">
                                                    <img src="/uploads/company_logos/${app.job.logo}" 
                                                         onerror="this.onerror=null; this.src='https://via.placeholder.com/50?text=Logo';" 
                                                         alt="Logo" class="company-logo me-3">
                                                    <div>
                                                        <a href="/job/${app.job.id}" class="job-title fs-6 d-block mb-1">${app.job.title}</a>
                                                        <div class="text-muted small">
                                                            <i class="bi bi-building me-1"></i>${app.job.companyName}
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-muted small">
                                                <i class="bi bi-clock me-1"></i> ${app.createdAt}
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${app.status == 'APPROVED'}">
                                                        <span class="badge bg-success-subtle text-success border border-success border-opacity-25 px-3 py-2 rounded-pill">
                                                            <i class="bi bi-check-circle-fill me-1"></i> Đã chấp nhận
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${app.status == 'REJECTED'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger border-opacity-25 px-3 py-2 rounded-pill">
                                                            <i class="bi bi-x-circle-fill me-1"></i> Từ chối
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary bg-opacity-10 text-secondary border px-3 py-2 rounded-pill">
                                                            <i class="bi bi-hourglass-split me-1"></i> Đang chờ duyệt
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="/job/${app.job.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                                    Xem lại tin
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty applications}">
                                        <tr>
                                            <td colspan="4" class="text-center py-5">
                                                <i class="bi bi-file-earmark-x fs-1 text-muted opacity-50 d-block mb-3"></i>
                                                <h5 class="fw-bold text-dark">Bạn chưa ứng tuyển công việc nào</h5>
                                                <p class="text-muted small mb-3">Hãy tìm kiếm và nắm bắt cơ hội nghề nghiệp ngay hôm nay!</p>
                                                <a href="/" class="btn btn-primary px-4 rounded-pill fw-bold">Tìm việc ngay</a>
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
    </div>

    <jsp:include page="layout/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>