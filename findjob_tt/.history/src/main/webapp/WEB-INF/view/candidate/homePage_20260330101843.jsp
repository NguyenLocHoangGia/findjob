<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ Ứng viên - JobPortal</title>
    
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">    
<style>
        body { 
            background: #f8fafc; 
            min-height: 100vh; 
            display: flex; 
            flex-direction: column; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .hero-section { background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%); padding: 130px 0 60px 0px; text-align: center; color: white; }
        
        /* --- CSS CHO THẺ NGANG MỚI --- */
        .mini-card {
            background: #ffffff; /* Đổi thành trắng tinh */
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.06);
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: row;
            align-items: flex-start;
            padding: 15px;
        }

        /* Hiệu ứng nổi lên khi hover cho toàn bộ Card */
        .hover-lift:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(13, 110, 253, 0.1);
            border-color: #0d6efd;
        }

        /* Phần nội dung bên phải (cần position relative cho trái tim) */
        .card-body-content {
            display: flex;
            flex-direction: column;
            padding-right: 30px; /* Chừa chỗ cho trái tim */
        }

        /* Logo nằm bên trái */
        .mini-logo-img {
            width: 70px;
            height: 70px;
            border-radius: 12px;
            
            /* 1. SỬA DÒNG NÀY: Đổi 'contain' thành 'cover' để ảnh lấp đầy khung */
            object-fit: cover; 
            
            border: 1px solid #f1f5f9;
            background: #fff;
            
            /* 2. SỬA DÒNG NÀY (Tùy chọn): Đổi từ 4px về 0 nếu bạn muốn ảnh tràn ra sát tận viền */
            padding: 0; 
            
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }

        /* Giới hạn chữ mô tả */
        .text-clamp-2 {
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }

        /* --- ICON TRÁI TIM (Quan tâm) --- */
        .wishlist-btn {
            position: absolute;
            top: 0;
            right: 0;
            border: none;
            background: none;
            color:#ff4757; /* Màu mặc định nhạt */
            padding: 1.5px;
            cursor: pointer;
            transition: color 0.2s ease, transform 0.2s ease;
            font-size: 1.1rem;
            line-height: 1;
            z-index: 5; /* Đặt trên các phần tử khác */
        }

        .wishlist-btn:hover {
            color: #ff4757; /* Màu đỏ khi hover */
            transform: scale(1.1);
        }

        /* Trạng thái đã quan tâm (đỏ và fill) */
        .wishlist-btn.active {
            color: #ff4757;
        }

        /* --- NÚT XEM CHI TIẾT GỌN GÀNG HƠN --- */
        .detail-button-wrapper {
            opacity: 0; /* Mặc định ẩn */
            transform: translateY(10px); /* Đẩy xuống */
            transition: all 0.3s ease;
        }

        /* Khi hover vào Mini Card, hiện nút Xem Chi Tiết */
        .hover-lift:hover .detail-button-wrapper {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />


<div class="hero-section shadow-sm" style="background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%); padding: 0;">
    <div class="container py-4">
        <div class="row align-items-center">
            <div class="col-lg-7 col-md-12 text-white text-center text-lg-start mb-4 mb-lg-0">
                <h1 class="fw-bold mb-3 fs-2">CareerLink.vn nay đã có mặt trên Zalo OA</h1>
                <p class="mb-4 opacity-75">Tìm kiếm hàng ngàn cơ hội thực tập và việc làm chất lượng.</p>
                <form action="/" method="GET" class="input-group shadow-lg mx-auto" style="max-width: 600px; border-radius: 8px; overflow: hidden; background: #fff;">
                    <input type="text" name="keyword" value="${keyword}" 
                        class="form-control border-0 py-3 px-3 shadow-none" 
                        style="flex: 2;" 
                        placeholder="Nhập kỹ năng, chức danh, công ty...">
                    <select name="location" class="form-select border-0 border-start py-3 shadow-none text-muted" style="flex: 1; cursor: pointer;">
                        <option value="">Tất cả địa điểm</option>
                        <option value="Hà Nội" ${location == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                        <option value="Tp. HCM" ${location == 'Tp. HCM' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
                        <option value="Đà Nẵng" ${location == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                        <option value="Cần Thơ" ${location == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                    </select>
                    <button class="btn btn-dark fw-bold px-4 py-3" type="submit">
                        <i class="bi bi-search me-1"></i> Tìm việc
                    </button>
                </form>
            </div>
            <div class="col-lg-5 col-md-12 text-center">
                <img src="https://careerlink.vn/images/zalo-careerlink.png" alt="CareerLink Zalo OA" class="img-fluid mb-3" style="max-width: 350px; border-radius: 20px; box-shadow: 0 8px 32px rgba(13,110,253,0.12);">
                <div class="d-flex justify-content-center align-items-center gap-3">
                    <img src="https://careerlink.vn/images/zalo-qr.png" alt="Zalo QR" style="width: 90px; height: 90px; border-radius: 12px; background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.04);">
                    <a href="#" class="btn btn-primary btn-lg fw-bold px-4 py-2" style="font-size: 1.1rem;">Tìm Hiểu Thêm</a>
                </div>
            </div>
        </div>
    </div>
</div>

    <div class="container my-5 flex-grow-1">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold text-dark mb-0"><i class="bi bi-fire text-danger"></i> Việc làm hấp dẫn</h4>
            <a href="/jobs" class="text-primary fw-bold">Xem tất cả <i class="bi bi-chevron-right"></i></a>
        </div>
        <div class="row g-3">
            <c:forEach var="job" items="${jobs}">
                <div class="col-xl-6 col-lg-6 col-md-12">
                    <div class="mini-card hover-lift position-relative mb-2">
                        <div class="me-3 flex-shrink-0">
                            <c:choose>
                                <c:when test="${not empty job.logo}">
                                    <img src="/uploads/company_logos/${job.logo}" class="mini-logo-img" alt="Logo" onerror="this.onerror=null;this.src='/uploads/job_logos/${job.logo}';">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${job.companyName}&background=0D8ABC&color=fff&size=120&font-size=0.4" class="mini-logo-img" alt="Logo">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-body-content flex-grow-1 overflow-hidden h-100 position-relative">
                            <button class="wishlist-btn" type="button" data-job-id="${job.id}" title="${savedJobIds.contains(job.id) ? 'Bỏ quan tâm' : 'Quan tâm'}" onclick="toggleWishlist(event)">
                                <i class="bi ${savedJobIds.contains(job.id) ? 'bi-heart-fill' : 'bi-heart'}"></i>
                            </button>
                            <div class="d-flex align-items-center mb-1">
                                <h6 class="fw-bold text-primary mb-0 text-truncate" title="${job.title}" style="font-size: 1.1rem;">${job.title}</h6>
                                <c:if test="${job.isHot}">
                                    <span class="badge bg-danger ms-2" style="font-size: 0.7rem;">HOT JOB</span>
                                </c:if>
                            </div>
                            <p class="text-muted text-uppercase fw-bold mb-1" style="font-size: 0.8rem;">${job.companyName}</p>
                            <div class="d-flex flex-wrap gap-2 mb-2" style="font-size: 0.9rem;">
                                <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">
                                    <i class="bi bi-cash me-1"></i>${job.salary}
                                </span>
                                <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1">
                                    <i class="bi bi-geo-alt me-1"></i>${job.location}
                                </span>
                            </div>
                            <p class="text-muted text-clamp-2 mb-0 mt-1" style="font-size: 0.95rem; line-height: 1.5;">${job.shortDescription}</p>
                            <div class="mt-auto pt-1 detail-button-wrapper text-end">
                                <a href="/job/${job.id}" class="text-primary fw-bold" style="font-size: 0.95rem; text-decoration: none;">Xem chi tiết <i class="bi bi-arrow-right"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <jsp:include page="layout/footer.jsp" />

    <script>
function toggleWishlist(event) {
    event.stopPropagation();
    event.preventDefault();

    const btn = event.currentTarget;
    const jobId = btn.getAttribute('data-job-id');
    const icon = btn.querySelector('i');
    
    // Tìm thẻ hiển thị số lượng trên Header
    const headerCountEl = document.getElementById('header-saved-count');
    let currentCount = parseInt(headerCountEl.innerText) || 0;

    const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
    const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

    const formData = new URLSearchParams();
    formData.append("jobId", jobId);

    fetch('/candidate/api/toggle-save-job', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded', [csrfHeader]: csrfToken },
        body: formData.toString()
    }).then(response => {
        if(response.status === 401) {
            alert("Vui lòng đăng nhập để lưu việc làm!");
            window.location.href = '/login';
            return;
        }
        return response.text();
    }).then(data => {
        // Cập nhật giao diện Trái tim & Con số ngay lập tức không cần tải lại trang
        if(data === 'added') {
            icon.classList.remove('bi-heart');
            icon.classList.add('bi-heart-fill');
            btn.setAttribute('title', 'Bỏ quan tâm');
            headerCountEl.innerText = currentCount + 1; // Tăng 1
        } else if(data === 'removed') {
            icon.classList.remove('bi-heart-fill');
            icon.classList.add('bi-heart');
            btn.setAttribute('title', 'Quan tâm');
            headerCountEl.innerText = currentCount > 0 ? currentCount - 1 : 0; // Trừ 1
        }
    }).catch(err => console.error("Lỗi:", err));
}
</script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>