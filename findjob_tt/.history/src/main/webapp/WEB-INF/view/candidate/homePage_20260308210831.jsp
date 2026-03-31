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

        .hero-section { background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%); padding: 60px 0; text-align: center; color: white; }
        
        /* --- CSS CHO THẺ MINI PROFILE CARD --- */
        .mini-card {
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
            height: 100%;
            display: flex;
            flex-direction: column;
            border: 1px solid transparent;
        }
        
        /* Hiệu ứng nổi lên và viền xanh khi hover vào thẻ */
        .mini-card:hover { 
            transform: translateY(-8px); 
            box-shadow: 0 15px 30px rgba(0,0,0,0.1); 
            border-color: #0d6efd;
        }

        /* Cover & Logo thu nhỏ */
        .mini-cover {
            width: 100%; height: 110px; object-fit: cover;
            /* Thay đổi màu gradient của bìa cho sang trọng hơn */
            background: linear-gradient(to right, #2b5876, #4e4376);
        }
        
        .mini-logo-wrapper { text-align: center; margin-top: -45px; position: relative; z-index: 10; }
        .mini-logo-img { 
            width: 85px; height: 85px; 
            border-radius: 50%; 
            border: 4px solid #ffffff; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.1); 
            background: #fff; 
        }

        /* Giới hạn số dòng chữ (Cắt phần chữ dư thừa thành dấu ...) */
        .text-clamp-2 {
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        
        /* Nút xem chi tiết ẩn, chỉ hiện ra khi hover vào card */
        .view-detail-btn {
            opacity: 0;
            transform: translateY(10px);
            transition: all 0.3s ease;
        }
        .mini-card:hover .view-detail-btn {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="hero-section shadow-sm">
        <div class="container">
            <h1 class="fw-bold mb-3">Mạng Lưới Việc Làm IT Hàng Đầu</h1>
            <p class="lead mb-4 opacity-75">Tìm kiếm hàng ngàn cơ hội thực tập và việc làm chất lượng.</p>
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="input-group input-group-lg shadow">
                        <input type="text" class="form-control border-0" placeholder="Nhập tên kỹ năng, chức danh...">
                        <button class="btn btn-dark fw-bold px-4" type="button">Tìm việc</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container my-5 flex-grow-1">
        <h3 class="fw-bold mb-4 text-dark"><i class="bi bi-fire text-danger"></i> Việc làm mới nhất</h3>
        
        <div class="row g-4">
            
            <c:forEach var="job" items="${jobs}">
                <div class="col-lg-4 col-md-6">
                    
                    <a href="/job/${job.id}" class="text-decoration-none text-dark d-block h-100">
                        <div class="mini-card pb-3">
                            
                            <div class="mini-cover"></div>
                            <div class="mini-logo-wrapper">
                                <img src="https://ui-avatars.com/api/?name=${job.companyName}&background=0D8ABC&color=fff&size=150&font-size=0.4" class="mini-logo-img" alt="Logo">
                            </div>
                            
                            <div class="text-center px-4 pt-2 d-flex flex-column flex-grow-1">
                                <h5 class="fw-bold text-primary mb-1 text-truncate" title="${job.title}">${job.title}</h5>
                                <p class="text-muted text-uppercase fw-bold mb-3" style="font-size: 0.8rem;"> Công ty: ${job.companyName}</p>

                                <div class="d-flex justify-content-center gap-2 mb-3" style="font-size: 1.2rem;">
                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">💰 ${job.salary}</span>
                                    <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1"><i class="bi bi-geo-alt"></i> ${job.location}</span>
                                </div>

                                <p class="text-muted text-clamp-2 text-start mb-4" style="font-size: 0.85rem;">${job.description}</p>

                                <div class="mt-auto view-detail-btn">
                                    <span class="text-primary fw-bold" style="font-size: 0.9rem;">Xem chi tiết <i class="bi bi-arrow-right"></i></span>
                                </div>
                            </div>

                        </div>
                    </a>

                </div>
            </c:forEach>

        </div>
    </div>

    <jsp:include page="layout/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>