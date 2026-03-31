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
        body { background: #f8fafc; padding-top: 100px; font-family: 'Segoe UI', Tahoma, sans-serif; min-height: 100vh; display: flex; flex-direction: column; }
        .mini-card { background: #fff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); border: 1px solid rgba(0,0,0,0.06); transition: all 0.3s ease; height: 100%; display: flex; padding: 15px; }
        .hover-lift:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(13, 110, 253, 0.1); border-color: #0d6efd; }
        .mini-logo-img { width: 70px; height: 70px; border-radius: 12px; object-fit: cover; border: 1px solid #f1f5f9; }
        .wishlist-btn { position: absolute; top: 0; right: 0; border: none; background: none; color: #ff4757; padding: 1.5px; cursor: pointer; transition: all 0.2s ease; font-size: 1.2rem; z-index: 5; }
        .wishlist-btn:hover { transform: scale(1.15); }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container my-5 flex-grow-1">
        
        <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
            <div class="bg-danger text-white rounded-circle d-flex align-items-center justify-content-center me-3 shadow-sm" style="width: 50px; height: 50px; font-size: 20px;">
                <i class="bi bi-heart-fill"></i>
            </div>
            <div>
                <h3 class="fw-bold mb-0 text-dark">Việc làm đang quan tâm</h3>
                <p class="text-muted mb-0 mt-1">Danh sách các cơ hội nghề nghiệp bạn đã lưu lại</p>
            </div>
        </div>

        <c:choose>
            <%-- TRƯỜNG HỢP 1: NẾU CHƯA LƯU VIỆC LÀM NÀO --%>
            <c:when test="${empty savedJobsList}">
                <div class="text-center py-5 mt-5 bg-white rounded-4 shadow-sm border border-light">
                    <i class="bi bi-clipboard-x text-muted opacity-25" style="font-size: 5rem;"></i>
                    <h5 class="text-muted fw-bold mt-3">Bạn chưa lưu công việc nào</h5>
                    <p class="text-muted mb-4">Hãy quay lại trang chủ và thả tim cho công việc bạn yêu thích nhé!</p>
                    <a href="/" class="btn btn-primary rounded-pill px-4 fw-medium shadow-sm">
                        <i class="bi bi-search me-1"></i> Khám phá việc làm ngay
                    </a>
                </div>
            </c:when>
            
            <%-- TRƯỜNG HỢP 2: HIỂN THỊ DANH SÁCH ĐÃ LƯU --%>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach var="job" items="${savedJobsList}">
                        
                        <div class="col-lg-4 col-md-6" id="job-card-${job.id}">
                            <a href="/candidate/job/${job.id}" class="text-decoration-none text-dark d-block h-100">
                                <div class="mini-card hover-lift position-relative"> 
                                    
                                    <div class="me-3 flex-shrink-0">
                                        <c:choose>
                                            <c:when test="${not empty job.logo}">
                                                <img src="/images/job_logos/${job.logo}" class="mini-logo-img" alt="Logo">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://ui-avatars.com/api/?name=${job.companyName}&background=random&color=fff&size=120" class="mini-logo-img" alt="Logo">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <div class="flex-grow-1 overflow-hidden h-100 position-relative pe-4">
                                        
                                        <button class="wishlist-btn" type="button" data-job-id="${job.id}" title="Bỏ quan tâm" onclick="removeSavedJob(event)">
                                            <i class="bi bi-heart-fill"></i>
                                        </button>

                                        <h6 class="fw-bold text-primary mb-1 text-truncate">${job.title}</h6>
                                        <p class="text-muted text-uppercase fw-bold mb-2" style="font-size: 0.75rem;">${job.companyName}</p>
                                        
                                        <div class="d-flex flex-wrap gap-2 mb-2" style="font-size: 0.85rem;">
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">
                                                <i class="bi bi-cash me-1"></i> ${job.salary}
                                            </span>
                                            <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1">
                                                <i class="bi bi-geo-alt me-1"></i> ${job.location}
                                            </span>
                                        </div>
                                    </div>

                                </div>
                            </a>
                        </div>

                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        // Bỏ bớt tham số jobId ở đây đi
        function removeSavedJob(event) {
            // 1. Chặn click lan ra ngoài
            event.stopPropagation();
            event.preventDefault();

            // 2. Lấy ID công việc từ chính cái nút vừa bấm
            const btn = event.currentTarget;
            const jobId = btn.getAttribute('data-job-id');

            // Lấy token bảo mật
            const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
            const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

            const formData = new URLSearchParams();
            formData.append("jobId", jobId);

            // Gửi API ngầm xuống Controller
            fetch('/candidate/api/toggle-save-job', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded', 
                    [csrfHeader]: csrfToken 
                },
                body: formData.toString()
            }).then(response => {
                if(response.ok) {
                    // Hiệu ứng làm mờ và xóa thẻ
                    const card = document.getElementById('job-card-' + jobId);
                    card.style.transition = "all 0.4s ease";
                    card.style.opacity = "0";
                    card.style.transform = "scale(0.9)";
                    setTimeout(() => {
                        card.remove();
                        // Nếu xóa hết thẻ thì tải lại trang để hiện thông báo "Chưa lưu việc nào"
                        if(document.querySelectorAll('[id^="job-card-"]').length === 0) {
                            window.location.reload();
                        }
                    }, 400);
                }
            }).catch(err => console.error("Lỗi xóa việc làm:", err));
        }
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>