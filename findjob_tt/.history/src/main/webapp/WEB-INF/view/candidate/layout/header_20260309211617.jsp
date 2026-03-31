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


    /* ========================================================
       CHÍNH LÀ ĐOẠN NÀY: CLASS BẮT BUỘC PHẢI CÓ ĐỂ LÀM MỎ NEO
       ======================================================== */
    .dropdown-container {
        position: relative; 
    }


    /* CSS làm đẹp cho Menu xổ xuống (Dropdown) */
    .neo-dropdown-menu {
        position: absolute;
        top: 100%;
        left: 50%; /* Bắt đầu từ giữa nút */
        transform: translateX(-50%) translateY(20px); /* Kéo ngược lại 50% để căn giữa nút, đẩy xuống dưới 20px */
        
        background: #fff;
        border-radius: 12px;
        border: none;
        box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        padding: 10px;
        min-width: 240px;
        
        /* Chế độ ẩn ban đầu */
        display: block;
        visibility: hidden;
        opacity: 0;
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
        pointer-events: none; 
    }
    
    /* Mở menu khi Hover vào cụm dropdown */
    .dropdown-container:hover .neo-dropdown-menu {
        visibility: visible;
        opacity: 1;
        transform: translateX(-50%) translateY(10px); /* Trượt lên sát nút */
        pointer-events: auto;
    }
    
    /* Vùng đệm tàng hình (Bridge): Giúp chuột không bị rớt khi di chuyển từ nút xuống menu */
    .dropdown-container::after {
        content: '';
        position: absolute;
        top: 100%;
        left: 0;
        width: 100%;
        height: 15px;
        background: transparent;
    }
    
    /* Trang trí thẻ bên trong menu */
    .neo-dropdown-menu .dropdown-item {
        border-radius: 8px;
        padding: 10px 15px;
        font-weight: 500;
        font-size: 0.95rem;
        color: #495057;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
    }
    .neo-dropdown-menu .dropdown-item:hover {
        background-color: #f8f9fa;
        color: #ff4757; 
        transform: translateX(5px); 
    }
</style>

<div class="floating-header-wrapper">
    <nav class="navbar navbar-expand-lg glass-pill-nav">
        <div class="container-fluid px-0">
            
            <a class="navbar-brand fw-bold fs-5 text-white d-flex align-items-center gap-2 ps-2" href="/">
                <div style="width: 22px; height: 22px; border-radius: 50%; background: #74ebd5;"></div>
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
                
                <div class="d-flex align-items-center gap-4 pe-2 mt-3 mt-lg-0">
                    <a href="#" class="text-white text-decoration-none fw-semibold d-flex align-items-center gap-2" style="font-size: 0.9rem; opacity: 0.8; transition: 0.3s;">
                        <i class="bi bi-envelope-fill"></i> Liên hệ
                    </a>
                    
                    <div class="dropdown-container">
                        
                        <a class="btn btn-neo-start" href="/recruiter/dashboard">
                            Nhà tuyển dụng 
                        </a>
                        
                        <ul class="neo-dropdown-menu">
                            <li>
                                <a class="dropdown-item" href="#">
                                    <i class="bi bi-person-circle fs-5 me-3 text-primary"></i> Đăng nhập
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="/recruiter/job/add">
                                    <i class="bi bi-file-earmark-plus fs-5 me-3 text-success"></i> Đăng tin tuyển dụng
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="/recruiter/dashboard">
                                    <i class="bi bi-search fs-5 me-3 text-warning"></i> Tìm ứng viên
                                </a>
                            </li>
                        </ul>

                    </div>
                    
                </div>
            </div>
            
        </div>
    </nav>
</div>