<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* Khung bọc Nav */
    .floating-header-wrapper {
        position: fixed;
        top: 20px; 
        left: 0;
        width: 100%;
        z-index: 1050;
        pointer-events: none; 
    }

    /* Thẻ Nav phong cách NeoNav */
    .glass-pill-nav {
        pointer-events: auto; 
        background: rgba(22, 28, 45, 0.75); 
        backdrop-filter: blur(16px); 
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.08); 
        
        border-radius: 50px; 
        margin: 0 auto;
        
        /* CẬP NHẬT MỚI: Tăng nhẹ chiều rộng để dài ra 2 bên */
        max-width: 1300px; 
        width: 94%; 
        
        padding: 10px 25px;
        box-shadow: 0 15px 35px rgba(0,0,0,0.2); 
        transition: all 0.3s ease;
    }

    /* Các liên kết menu */
    .glass-pill-nav .nav-link {
        color: rgba(255, 255, 255, 0.7) !important;
        font-weight: 500;
        font-size: 0.95rem;
        padding: 8px 18px !important;
        border-radius: 30px;
        margin: 0 5px;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    
    .glass-pill-nav .nav-link:hover,
    .glass-pill-nav .nav-link.active {
        color: #ffffff !important;
        background: rgba(255, 255, 255, 0.1); 
    }

    .glass-pill-nav .nav-link.active::before {
        content: "";
        display: block;
        width: 6px;
        height: 6px;
        background-color: #fff;
        border-radius: 50%;
    }

    /* Nút Call-to-action Dropdown */
    .btn-neo-start {
        background: linear-gradient(135deg, #ff6b6b, #ff4757);
        color: white !important;
        font-weight: 700;
        border: none;
        padding: 10px 25px;
        border-radius: 30px;
        box-shadow: 0 4px 15px rgba(255, 107, 107, 0.4);
        transition: transform 0.2s;
    }
    .btn-neo-start:hover { transform: scale(1.03); }

    /* CẬP NHẬT MỚI: CSS làm đẹp cho Menu xổ xuống (Dropdown) */
    .neo-dropdown-menu {
        border-radius: 16px;
        border: none;
        box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        padding: 10px;
        min-width: 240px;
        margin-top: 15px !important; /* Tạo khoảng cách với nút bấm */
    }
    .neo-dropdown-menu .dropdown-item {
        border-radius: 10px;
        padding: 10px 15px;
        font-weight: 600;
        color: #495057;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
    }
    .neo-dropdown-menu .dropdown-item:hover {
        background-color: #f1f3f5;
        color: #ff4757; /* Đổi màu chữ khi đưa chuột vào */
        transform: translateX(5px); /* Hiệu ứng trượt nhẹ chữ sang phải */
    }
</style>

<div class="floating-header-wrapper">
    <nav class="navbar navbar-expand-lg glass-pill-nav">
        <div class="container-fluid px-0">
            
            <a class="navbar-brand fw-bold fs-5 text-white d-flex align-items-center gap-2" href="/">
                <div style="width: 24px; height: 24px; border-radius: 50%; background: linear-gradient(135deg, #74ebd5 0%, #ACB6E5 100%);"></div>
                JobPortal
            </a>
            
            <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <i class="bi bi-list text-white fs-2"></i>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="/"><i class="bi bi-house-door-fill"></i> Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="bi bi-info-circle-fill"></i> Về chúng tôi</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="bi bi-briefcase-fill"></i> Việc làm IT</a>
                    </li>
                </ul>
                
                <div class="d-flex align-items-center mt-3 mt-lg-0 gap-3">
                    <a href="#" class="text-white text-decoration-none fw-semibold" style="opacity: 0.8; transition: 0.3s;"><i class="bi bi-envelope-fill me-1"></i> Liên hệ</a>
                    
                    <div class="dropdown">
                        <button class="btn btn-neo-start dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Nhà tuyển dụng
                        </button>
                        
                        <ul class="dropdown-menu dropdown-menu-end neo-dropdown-menu">
                            <li>
                                <a class="dropdown-item" href="#">
                                    <i class="bi bi-person-circle fs-5 me-2 text-primary"></i> Đăng nhập
                                </a>
                            </li>
                            <li><hr class="dropdown-divider my-2"></li>
                            <li>
                                <a class="dropdown-item" href="/recruiter/job/add">
                                    <i class="bi bi-file-earmark-plus fs-5 me-2 text-success"></i> Đăng tin tuyển dụng
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="/recruiter/dashboard">
                                    <i class="bi bi-search fs-5 me-2 text-warning"></i> Tìm ứng viên
                                </a>
                            </li>
                        </ul>
                    </div>
                    </div>
            </div>
            
        </div>
    </nav>
</div>