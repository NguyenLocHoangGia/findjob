<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Lịch sử Ứng tuyển | JobPortal</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        /* Đồng bộ tuyệt đối phong cách với file notifications.jsp */
        body {
            background-color: #f4f7fa;
            font-family: 'Segoe UI', Tahoma, sans-serif;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .application-item {
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .application-item:hover {
            background-color: #f8f9fa;
            border-left-color: #198754; /* Viền xanh lá cây báo hiệu công việc */
        }

        .company-logo {
            width: 55px;
            height: 55px;
            object-fit: cover;
            border-radius: 10px;
            border: 1px solid #dee2e6;
        }

        .job-title {
            color: #212529;
            text-decoration: none;
            transition: color 0.2s;
        }

        .job-title:hover {
            color: #0d6efd;
        }
    </style>
</head>

<body>
    <jsp:include page="../layout/header.jsp" />

    <div class="container my-5 flex-grow-1" style="padding-top: 80px;">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow-sm border-0 rounded-4 p-4">
                    
                    <div class="d-flex align-items-center border-bottom pb-3 mb-4">
                        <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-3 shadow"
                            style="width: 60px; height: 60px; font-size: 24px;">
                            <i class="bi bi-clock-history"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark">Lịch sử Ứng tuyển</h3>
                            <p class="text-muted mb-0">Theo dõi trạng thái các công việc bạn đã nộp hồ sơ</p>
                        </div>
                    </div>

                    <div class="list-group list-group-flush rounded-3 border">
                        <c:forEach var="app" items="${applications}">
                            <div class="list-group-item application-item p-4">
                                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                                    
                                    <div class="d-flex align-items-center" style="min-width: 280px; flex: 1;">
                                        <img src="/uploads/company_logos/${app.job.logo}" 
                                             onerror="this.onerror=null; this.src='https://via.placeholder.com/55?text=Logo';" 
                                             alt="Logo" class="company-logo me-3 shadow-sm">
                                        <div>
                                            <a href="/job/${app.job.id}" target="_blank" class="job-title fw-bold fs-5 mb-1 d-block">
                                                ${app.job.title}
                                            </a>
                                            <div class="text-muted small">
                                                <i class="bi bi-building me-1"></i>${app.job.companyName}
                                            </div>
                                        </div>
                                    </div>

                                    <div class="text-muted small" style="min-width: 140px;">
                                        <i class="bi bi-calendar3 me-1"></i> ${app.createdAt}
                                    </div>

                                    <div style="min-width: 140px;">
                                        <c:choose>
                                            <c:when test="${app.status == 'APPROVED'}">
                                                <span class="badge bg-success-subtle text-success border border-success border-opacity-25 px-3 py-2 rounded-pill w-100 text-start">
                                                    <i class="bi bi-check-circle-fill me-1"></i> Đã chấp nhận
                                                </span>
                                            </c:when>
                                            <c:when test="${app.status == 'REJECTED'}">
                                                <span class="badge bg-danger-subtle text-danger border border-danger border-opacity-25 px-3 py-2 rounded-pill w-100 text-start">
                                                    <i class="bi bi-x-circle-fill me-1"></i> Từ chối
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border px-3 py-2 rounded-pill w-100 text-start">
                                                    <i class="bi bi-hourglass-split me-1"></i> Đang chờ duyệt
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="text-end" style="min-width: 120px;">
                                        <a href="/job/${app.job.id}" target="_blank" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-medium">
                                            Xem lại tin
                                        </a>
                                    </div>
                                    
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty applications}">
                            <div class="text-center py-5">
                                <i class="bi bi-file-earmark-x text-muted opacity-25" style="font-size: 4rem;"></i>
                                <h5 class="text-muted mt-3">Bạn chưa ứng tuyển công việc nào</h5>
                                <p class="text-muted small">Hãy tìm kiếm và nắm bắt cơ hội nghề nghiệp ngay hôm nay!</p>
                                <a href="/" class="btn btn-primary px-4 rounded-pill fw-bold mt-2 shadow-sm">Tìm việc ngay</a>
                            </div>
                        </c:if>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>