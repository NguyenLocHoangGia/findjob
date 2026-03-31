<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ Ứng viên - JobPortal</title>
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
            background: #ffffff; /* Chuyển mini-card sang màu trắng */
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.06);
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: row;
            align-items: flex-start;
            padding: 20px;
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
            object-fit: contain;
            border: 1px solid #f1f5f9;
            background: #fff;
            padding: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }

        /* Giới hạn chữ mô tả */
        .text-clamp-2 {
            display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;
        }

        /* --- ICON TRÁI TIM (Quan tâm) --- */
        .wishlist-btn {
            position: absolute;
            top: 0;
            right: 0;
            border: none;
            background: none;
            color: #ccc; /* Màu mặc định nhạt */
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

    <div class="hero-section shadow-sm">
        <div class="container">
            <h1 class="fw-bold mb-3 fs-2">Mạng Lưới Việc Làm IT Hàng Đầu</h1>
            <p class="mb-4 opacity-75">Tìm kiếm hàng ngàn cơ hội thực tập và việc làm chất lượng.</p>
            <div class="row justify-content-center">
                <div class="col-lg-5 col-md-7">
                    <div class="input-group shadow-sm" style="border-radius: 8px; overflow: hidden;">
                        <input type="text" class="form-control border-0 py-2 px-3" placeholder="Nhập tên kỹ năng, chức danh...">
                        <button class="btn btn-dark fw-bold px-4" type="button">Tìm việc</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

<div class="container my-5 flex-grow-1">
        <h4 class="fw-bold mb-4 text-dark"><i class="bi bi-fire text-danger"></i> Việc làm mới nhất</h4>
        
        <div class="row g-4">
            
            <c:forEach var="job" items="${jobs}">
                <div class="col-lg-4 col-md-6">
                    
                    <a href="/job/${job.id}" class="text-decoration-none text-dark d-block h-100">
                        <div class="mini-card hover-lift"> <div class="me-3 flex-shrink-0">
                                <img src="https://ui-avatars.com/api/?name=${job.companyName}&background=0D8ABC&color=fff&size=120&font-size=0.4" class="mini-logo-img" alt="Logo">
                            </div>

                            <div class="card-body-content flex-grow-1 overflow-hidden h-100 position-relative">

                                <button class="wishlist-btn" type="button" data-job-id="${job.id}" onclick="toggleWishlist(event)">
                                    <i class="bi bi-heart"></i>
                                </button>

                                <h6 class="fw-bold text-primary mb-1 text-truncate" title="${job.title}">${job.title}</h6>
                                <p class="text-muted text-uppercase fw-bold mb-2" style="font-size: 0.75rem;">${job.companyName}</p>

                                <div class="d-flex flex-wrap gap-2 mb-2" style="font-size: 0.75rem;">
                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">
                                        <i class="bi bi-cash me-1"></i>${job.salary}
                                    </span>
                                    <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1">
                                        <i class="bi bi-geo-alt me-1"></i>${job.location}
                                    </span>
                                </div>

                                <p class="text-muted text-clamp-2 mb-0 mt-1" style="font-size: 0.85rem; line-height: 1.5;">${job.shortDescription}</p>

                                <div class="mt-auto pt-3 detail-button-wrapper text-end">
                                    <span class="btn btn-sm btn-outline-primary rounded-pill fw-bold" style="font-size: 0.8rem;">
                                        Chi tiết <i class="bi bi-arrow-right"></i>
                                    </span>
                                </div>

                            </div>

                        </div>
                    </a>

                </div>
            </c:forEach>

        </div>
    </div>

    <jsp:include page="layout/footer.jsp" />

    <script>
        function toggleWishlist(event, jobId) {
            // Ngăn việc chuyển hướng trang do thẻ cha <a>
            event.stopPropagation();
            // Ngăn việc submit form (nếu có)
            event.preventDefault();

            const btn = event.currentTarget;
            const icon = btn.querySelector('i');

            // Toggle class 'active' trên nút
            btn.classList.toggle('active');

            // Toggle icon (heart -> heart-fill)
            if (icon.classList.contains('bi-heart')) {
                icon.classList.remove('bi-heart');
                icon.classList.add('bi-heart-fill');
                // Tại đây bạn có thể gửi một yêu cầu AJAX đến server để lưu trạng thái "Quan tâm" cho jobId
                console.log("Quan tâm công việc:", jobId);
            } else {
                icon.classList.remove('bi-heart-fill');
                icon.classList.add('bi-heart');
                // Tại đây bạn có thể gửi một yêu cầu AJAX đến server để xóa trạng thái "Quan tâm"
                console.log("Bỏ quan tâm công việc:", jobId);
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>