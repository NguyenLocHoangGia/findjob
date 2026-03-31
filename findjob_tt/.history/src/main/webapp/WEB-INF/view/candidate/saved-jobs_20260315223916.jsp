<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Việc làm đã lưu - JobPortal</title>
    
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, sans-serif; }
        .mini-card { 
            background: #fff; 
            border-radius: 12px; 
            border: 1px solid #edf2f7; 
            transition: all 0.3s ease; 
            padding: 15px; 
            position: relative;
        }
        .hover-lift:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 10px 20px rgba(0,0,0,0.05); 
            border-color: #0d6efd; 
        }
        .mini-logo-img { 
            width: 65px; 
            height: 65px; 
            border-radius: 10px; 
            object-fit: cover; 
            border: 1px solid #f1f5f9; 
        }
        .wishlist-btn { 
            position: absolute; 
            top: 10px; 
            right: 10px; 
            border: none; 
            background: rgba(255, 71, 87, 0.1); 
            color: #ff4757; 
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer; 
            transition: all 0.2s ease; 
            z-index: 5; 
        }
        .wishlist-btn:hover { 
            background: #ff4757; 
            color: #fff;
            transform: scale(1.1); 
        }
        .text-truncate-2 {
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container my-5" style="padding-top: 80px;">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow-sm border-0 rounded-4 p-4">
                    
                    <div class="d-flex align-items-center border-bottom pb-3 mb-4">
                        <div class="bg-danger text-white rounded-circle d-flex align-items-center justify-content-center me-3 shadow" style="width: 60px; height: 60px; font-size: 24px;">
                            <i class="bi bi-heart-fill"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark">Việc làm đang quan tâm</h3>
                            <p class="text-muted mb-0">Danh sách các cơ hội nghề nghiệp bạn đã lưu lại</p>
                        </div>
                    </div>

                    <c:choose>
                        <%-- TRƯỜNG HỢP 1: TRỐNG --%>
                        <c:when test="${empty savedJobsList}">
                            <div class="text-center py-5">
                                <i class="bi bi-clipboard-x text-muted opacity-25" style="font-size: 4rem;"></i>
                                <h5 class="text-muted fw-bold mt-3">Bạn chưa lưu công việc nào</h5>
                                <p class="text-muted small mb-4">Các công việc bạn "thả tim" sẽ xuất hiện tại đây.</p>
                                <a href="/" class="btn btn-primary rounded-pill px-4 shadow-sm">
                                    <i class="bi bi-search me-1"></i> Khám phá ngay
                                </a>
                            </div>
                        </c:when>
                        
                        <%-- TRƯỜNG HỢP 2: CÓ DỮ LIỆU --%>
                        <c:otherwise>
                            <div class="row g-3">
                                <c:forEach var="job" items="${savedJobsList}">
                                    <div class="col-lg-6 col-xl-6" id="job-card-${job.id}">
                                        <div class="mini-card hover-lift"> 
                                            <button class="wishlist-btn" type="button" data-job-id="${job.id}" onclick="removeSavedJob(event)">
                                                <i class="bi bi-heart-fill"></i>
                                            </button>

                                            <a href="/job/${job.id}" class="text-decoration-none d-flex align-items-start">
                                                <div class="me-3">
                                                    <c:choose>
                                                        <c:when test="${not empty job.logo}">
                                                            <img src="/images/job_logos/${job.logo}" class="mini-logo-img" alt="Logo">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="https://ui-avatars.com/api/?name=${job.companyName}&background=random&color=fff" class="mini-logo-img" alt="Logo">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <div class="flex-grow-1 overflow-hidden pe-4">
                                                    <h6 class="fw-bold text-dark mb-1 text-truncate-2">${job.title}</h6>
                                                    <p class="text-primary fw-semibold mb-2" style="font-size: 0.75rem;">${job.companyName}</p>
                                                    
                                                    <div class="d-flex flex-wrap gap-2">
                                                        <span class="badge bg-light text-success border border-success border-opacity-10 py-1">
                                                            <i class="bi bi-cash me-1"></i> ${job.salary}
                                                        </span>
                                                        <span class="badge bg-light text-secondary border border-secondary border-opacity-10 py-1">
                                                            <i class="bi bi-geo-alt me-1"></i> ${job.location}
                                                        </span>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function removeSavedJob(event) {
            event.stopPropagation();
            event.preventDefault();

            const btn = event.currentTarget;
            const jobId = btn.getAttribute('data-job-id');
            const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
            const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

            const formData = new URLSearchParams();
            formData.append("jobId", jobId);

            fetch('/candidate/api/toggle-save-job', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded', 
                    [csrfHeader]: csrfToken 
                },
                body: formData.toString()
            }).then(response => {
                if(response.ok) {
                    const card = document.getElementById('job-card-' + jobId);
                    card.style.transition = "all 0.3s ease";
                    card.style.opacity = "0";
                    card.style.transform = "scale(0.95)";
                    setTimeout(() => {
                        card.remove();
                        if(document.querySelectorAll('[id^="job-card-"]').length === 0) {
                            window.location.reload();
                        }
                    }, 300);
                }
            }).catch(err => console.error("Lỗi:", err));
        }
    </script>
</body>
</html>