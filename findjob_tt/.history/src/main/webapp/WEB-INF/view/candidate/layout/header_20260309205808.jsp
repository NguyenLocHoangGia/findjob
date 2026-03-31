<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* Khung bọc Nav để giữ cố định trên màn hình mà không chặn click ở ngoài */
    .floating-header-wrapper {
        position: fixed;
        top: 20px; /* Chừa khoảng cách với lề trên màn hình */
        left: 0;
        width: 100%;
        z-index: 1050;
        pointer-events: none; 
    }

    /* Thẻ Nav phong cách NeoNav (Kính mờ bóng tối) */
    .glass-pill-nav {
        pointer-events: auto; /* Nhận click bình thường bên trong thanh */
        background: rgba(22, 28, 45, 0.75); /* Màu xanh đen trong suốt */
        backdrop-filter: blur(16px); /* Làm mờ cảnh nền đằng sau */
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.08); /* Viền sáng siêu mỏng */
        
        border-radius: 50px; /* Bo tròn 2 đầu dạng viên thuốc */
        margin: 0 auto;
        max-width: 1100px;
        width: 92%; /* Cách lề 2 bên trang web */
        padding: 10px 25px;
        box-shadow: 0 15px 35px rgba(0,0,0,0.2); /* Đổ bóng sâu */
        transition: all 0.3s ease;
    }

    /* Tùy chỉnh Các liên kết menu (Có cả icon) */
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
    
    /* Hiệu ứng thẻ nổi khi hover menu */
    .glass-pill-nav .nav-link:hover,
    .glass-pill-nav .nav-link.active {
        color: #ffffff !important;
        background: rgba(255, 255, 255, 0.1); /* Nền xám mờ hiện ra */
    }

    /* Dấu chấm tròn ở menu đang active (Giống ảnh mẫu của bạn) */
    .glass-pill-nav .nav-link.active::before {
        content: "";
        display: block;
        width: 6px;
        height: 6px;
        background-color: #fff;
        border-radius: 50%;
    }

    /* Nút Call-to-action màu đỏ/cam nổi bật */
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
    .btn-neo-start:hover { transform: scale(1.05); }
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
                    <a href="/recruiter/dashboard" class="btn btn-neo-start">
                        Nhà tuyển dụng
                        <h6 style="color: grey;"> Đăng, tuyển, tìm ứng viên</h6>
                    </a>
                </div>
            </div>
            
        </div>
    </nav>
</div>