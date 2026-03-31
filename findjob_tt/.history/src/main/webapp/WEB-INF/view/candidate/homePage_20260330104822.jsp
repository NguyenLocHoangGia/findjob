<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>CareerLink Clone - Tìm kiếm việc làm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0, 56, 145, 0.8), rgba(0, 56, 145, 0.8)), 
                        url('https://images.unsplash.com/photo-1521737711867-e3b97375f902?q=80&w=1974') center/cover;
            padding: 100px 0;
            color: white;
        }
        .search-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .job-card {
            border: 1px solid #eee;
            border-radius: 8px;
            transition: all 0.3s;
            height: 100%;
        }
        .job-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-color: #003891;
        }
        .badge-hot {
            background-color: #ff4d4d;
            color: white;
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 4px;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        .company-logo {
            width: 50px; height: 50px; object-fit: contain; border: 1px solid #f0f0f0; padding: 5px;
        }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <section class="hero-section">
        <div class="container text-center">
            <h1 class="fw-bold mb-4">Tìm công việc mơ ước của bạn</h1>
            <div class="search-box mx-auto" style="max-width: 900px;">
                <form action="/search" method="GET" class="row g-2">
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
                            <input type="text" class="form-control border-start-0" name="keyword" placeholder="Tên công việc, kỹ năng...">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <select class="form-select" name="categoryId">
                            <option value="">Tất cả ngành nghề</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}">${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100 fw-bold">TÌM KIẾM</button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <div class="container my-5">
        
        <div class="d-flex justify-content-between align-items-end mb-4">
            <h3 class="fw-bold mb-0 text-primary"><i class="bi bi-fire me-2"></i>Việc làm hấp dẫn nhất</h3>
            <a href="/jobs" class="text-decoration-none">Xem tất cả <i class="bi bi-arrow-right"></i></a>
        </div>

        <div class="row g-3">
            <c:forEach var="job" items="${hotJobs}">
                <div class="col-md-6 col-lg-3">
                    <div class="card job-card p-3">
                        <div class="d-flex justify-content-between mb-2">
                            <img src="/uploads/job_logos/${job.logo}" class="company-logo rounded">
                            <span class="badge-hot"><i class="bi bi-graph-up-arrow me-1"></i>HOT</span>
                        </div>
                        <h6 class="fw-bold mb-1 text-truncate" title="${job.title}">
                            <a href="/job/${job.id}" class="text-decoration-none text-dark">${job.title}</a>
                        </h6>
                        <p class="text-muted small mb-2 text-truncate">${job.companyName}</p>
                        <div class="mt-auto">
                            <div class="text-danger fw-bold small"><i class="bi bi-cash-stack me-1"></i>${job.salary}</div>
                            <div class="text-muted small"><i class="bi bi-geo-alt me-1"></i>${job.location}</div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <h3 class="fw-bold mt-5 mb-4">Việc làm mới nhất</h3>
        <div class="list-group shadow-sm border-0">
            <c:forEach var="job" items="${recentJobs}">
                <a href="/job/${job.id}" class="list-group-item list-group-item-action border-start-0 border-end-0 border-top-0 py-3">
                    <div class="row align-items-center">
                        <div class="col-auto">
                            <img src="/uploads/job_logos/${job.logo}" class="rounded" style="width: 45px;">
                        </div>
                        <div class="col">
                            <h6 class="mb-0 fw-bold">${job.title} 
                                <c:if test="${job.isHot}"><span class="badge-hot ms-1">HOT</span></c:if>
                            </h6>
                            <small class="text-muted">${job.companyName}</small>
                        </div>
                        <div class="col-md-2 text-end">
                            <span class="text-danger small fw-bold">${job.salary}</span><br>
                            <small class="text-muted">${job.location}</small>
                        </div>
                        <div class="col-md-2 text-end small text-muted">
                            ${job.formattedCreatedAt}
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>

    </div>

    <jsp:include page="layout/footer.jsp" />

</body>
</html>