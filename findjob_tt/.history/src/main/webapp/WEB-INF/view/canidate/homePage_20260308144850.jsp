<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ Ứng viên - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .hero-section { background-color: #f8f9fa; padding: 50px 0; text-align: center; }
        .job-card { transition: transform 0.2s; cursor: pointer; }
        .job-card:hover { transform: translateY(-5px); box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
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
            <div class="col-md-6 mb-4">
                <div class="card job-card h-100">
                    <div class="card-body d-flex align-items-center">
                        <img src="https://via.placeholder.com/80" class="rounded me-3" alt="Logo">
                        <div>
                            <h5 class="card-title text-primary fw-bold mb-1">Thực tập sinh Java Spring Boot</h5>
                            <h6 class="card-subtitle mb-2 text-muted">Công ty TNHH Tech Asia</h6>
                            <span class="badge bg-success">Lương: Thỏa thuận</span>
                            <span class="badge bg-secondary">Hà Nội</span>
                        </div>
                        <div class="ms-auto">
                            <button class="btn btn-outline-primary btn-sm">Ứng tuyển</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6 mb-4">
                <div class="card job-card h-100">
                    <div class="card-body d-flex align-items-center">
                        <img src="https://via.placeholder.com/80" class="rounded me-3" alt="Logo">
                        <div>
                            <h5 class="card-title text-primary fw-bold mb-1">Fresher Frontend (ReactJS)</h5>
                            <h6 class="card-subtitle mb-2 text-muted">Tập đoàn VinaCorp</h6>
                            <span class="badge bg-success">Lương: 8.000.000 VNĐ</span>
                            <span class="badge bg-secondary">Đà Nẵng</span>
                        </div>
                        <div class="ms-auto">
                            <button class="btn btn-outline-primary btn-sm">Ứng tuyển</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>