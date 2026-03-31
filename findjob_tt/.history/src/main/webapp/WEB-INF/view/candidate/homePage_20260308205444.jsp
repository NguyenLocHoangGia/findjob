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
        
        /* --- CSS CHO THẺ MINI PROFILE CARD BÊN NGOÀI TRANG CHỦ --- */
        .mini-card {
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .mini-card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }

        /* Cover & Logo thu nhỏ */
        .mini-cover {
            width: 100%; height: 100px; object-fit: cover;
            background-image: url('https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=2000&auto=format&fit=crop');
            background-size: cover; background-position: center;
        }
        .mini-logo-wrapper { text-align: center; margin-top: -40px; position: relative; z-index: 10; }
        .mini-logo-img { width: 80px; height: 80px; border-radius: 50%; border: 4px solid #ffffff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); background: #fff; }

        /* Khu vực nội dung Tab thu nhỏ */
        .mini-content { padding: 10px 20px; flex-grow: 1; height: 130px; overflow: hidden; }
        
        /* Giới hạn số dòng chữ (Tránh thẻ bị phình to) */
        .text-clamp-3 {
            display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;
        }

        /* Thanh Tabs thu nhỏ */
        .mini-nav-tabs { border-top: 1px solid #f1f5f9; background-color: #f8fafc; display: flex; font-size: 0.8rem; border-bottom: none; }
        .mini-nav-tabs .nav-link { 
            flex: 1; text-align: center; color: #64748b; font-weight: 600; padding: 0.8rem 0; 
            border: none; border-bottom: 2px solid transparent; border-radius: 0; 
        }
        .mini-nav-tabs .nav-link.active { color: #0d6efd; border-bottom-color: #0d6efd; background: transparent; }
        .mini-nav-tabs .nav-link:hover { color: #0d6efd; }
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

    <div class="container my-5">
        <h3 class="fw-bold mb-4 text-dark"><i class="bi bi-fire text-danger"></i> Việc làm mới nhất</h3>
        
        <div class="row g-4">
            
            <c:forEach var="job" items="${jobs}">
                <div class="col-lg-4 col-md-6">
                    
                    <div class="mini-card">
                        
                        <a href="/job/${job.id}" class="text-decoration-none text-dark d-block">
                            <div class="mini-cover"></div>
                            <div class="mini-logo-wrapper">
                                <img src="https://ui-avatars.com/api/?name=${job.companyName}&background=0D8ABC&color=fff&size=150" class="mini-logo-img" alt="Logo">
                            </div>
                            <div class="text-center px-3 pt-2">
                                <h5 class="fw-bold text-primary mb-1 text-truncate" title="${job.title}">${job.title}</h5>
                                <p class="text-muted text-uppercase fw-bold mb-0" style="font-size: 0.75rem;">${job.companyName}</p>
                            </div>
                        </a>

                        <div class="tab-content mini-content" id="tabContent-${job.id}">
                            
                            <div class="tab-pane fade show active" id="req-${job.id}" role="tabpanel">
                                <div class="d-flex justify-content-center gap-2 mb-2 mt-1" style="font-size: 0.8rem;">
                                    <span class="badge bg-success">💰 ${job.salary}</span>
                                    <span class="badge bg-secondary"><i class="bi bi-geo-alt"></i> ${job.location}</span>
                                </div>
                                <p class="text-muted text-clamp-3" style="font-size: 0.85rem;">${job.description}</p>
                            </div>

                            <div class="tab-pane fade" id="comp-${job.id}" role="tabpanel">
                                <h6 class="fw-bold text-center mt-1" style="font-size: 0.9rem;">Thông tin công ty</h6>
                                <p class="text-muted text-clamp-3 text-center" style="font-size: 0.85rem;">
                                    Chào mừng đến với ${job.companyName}. Chúng tôi luôn tìm kiếm những tài năng trẻ nhiệt huyết đồng hành cùng phát triển các dự án thực tế.
                                </p>
                            </div>

                        </div>

                        <ul class="nav nav-tabs mini-nav-tabs mt-auto" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#req-${job.id}" type="button" role="tab">Tóm tắt</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#comp-${job.id}" type="button" role="tab">Công ty</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <a href="/job/${job.id}" class="nav-link text-success">Chi tiết &rarr;</a>
                            </li>
                        </ul>

                    </div>

                </div>
            </c:forEach>

        </div>
    </div>

    <jsp:include page="layout/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>