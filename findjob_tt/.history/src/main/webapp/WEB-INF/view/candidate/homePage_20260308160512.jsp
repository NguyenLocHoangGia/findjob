<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ Ứng viên - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
        .hero-section { background-color: #f8f9fa; padding: 50px 0; text-align: center; }
        
        /* Hiệu ứng tổng thể cho Card */
        .job-card { 
            transition: all 0.3s ease; 
            cursor: pointer; 
            border: 3px solid #eee;
        }
        
        /* Khi đưa chuột vào Card: Nổi lên, đổ bóng và viền sáng màu xanh */
        .job-card:hover { 
            transform: translateY(-5px); 
            box-shadow: 0 10px 20px rgba(0,0,0,0.1); 
            border-color: #0d6efd; 
        }
        
        /* CHỈNH SỬA MỚI: Trạng thái ẩn của chữ "Xem chi tiết" */
        .view-detail-hint {
            opacity: 0;
            transform: translateX(20px); /* Bị đẩy sang phải 20px */
            transition: all 0.3s ease;
            white-space: nowrap;
        }
        
        /* Khi đưa chuột vào Card -> Chữ hiện ra và trượt về vị trí cũ */
        .job-card:hover .view-detail-hint {
            opacity: 1;
            transform: translateX(0); 
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand fw-bold" href="/">JobPortal Intern</a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link text-white" href="/">Việc làm IT</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="#">Đăng nhập</a></li>
                    <li class="nav-item"><a class="btn btn-warning ms-2 fw-bold" href="#">Nhà tuyển dụng</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="hero-section">
        <div class="container">
            <h1 class="fw-bold text-primary">${welcomeMessage}</h1>
            <p class="lead text-muted">Tìm kiếm hàng ngàn cơ hội thực tập và việc làm chất lượng.</p>
            <div class="row justify-content-center mt-4">
                <div class="col-md-6">
                    <div class="input-group input-group-lg">
                        <input type="text" class="form-control" placeholder="Nhập tên kỹ năng, chức danh...">
                        <button class="btn btn-success" type="button">Tìm việc ngay</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-5">
        <h3 class="fw-bold mb-4">🔥 Việc làm mới nhất</h3>
        <div class="row">       
            <c:forEach var="job" items="${jobs}">
                <div class="col-md-6 mb-4">
                    
                    <a href="/job/${job.id}" class="text-decoration-none text-dark">
                        <div class="card job-card h-100">
                            <div class="card-body d-flex align-items-center">
                                <img src="https://via.placeholder.com/80" class="rounded me-3" alt="Logo">
                                <div>
                                    <h5 class="card-title text-primary fw-bold mb-1">${job.title}</h5>
                                    <h6 class="card-subtitle mb-2 text-muted">${job.companyName}</h6>
                                    <span class="badge bg-success">Lương: ${job.salary}</span>
                                    <span class="badge bg-secondary">${job.location}</span>
                                </div>
                                
                                <div class="ms-auto view-detail-hint text-primary fw-bold">
                                    Xem chi tiết &rarr;
                                </div>
                                
                            </div>
                        </div>
                    </a>
                    
                </div>
            </c:forEach>

        </div>
    </div>

</body>
</html>