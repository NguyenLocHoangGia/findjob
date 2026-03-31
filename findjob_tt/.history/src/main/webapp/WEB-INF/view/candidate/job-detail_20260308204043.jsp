<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${job.title} - ${job.companyName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        /* Nền trang web sử dụng dải màu gradient hiện đại giống ảnh của bạn */
        body { 
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); 
            min-height: 100vh; 
            display: flex; 
            flex-direction: column; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* KHUNG THẺ (CARD) CHÍNH */
        .profile-card {
            max-width: 750px; /* Độ rộng thẻ giống như ảnh mẫu */
            width: 90%;
            margin: auto; /* Căn giữa màn hình */
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.15); /* Đổ bóng sâu tạo cảm giác nổi 3D */
            overflow: hidden;
            position: relative;
        }

        /* ẢNH BÌA (COVER) */
        .cover-photo {
            width: 100%;
            height: 200px;
            object-fit: cover;
            /* Dùng một ảnh gradient ngẫu nhiên mờ ảo để làm ảnh bìa tĩnh */
            background-image: url('https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=2000&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
        }

        /* ẢNH LOGO CÔNG TY (AVATAR) */
        .logo-wrapper {
            text-align: center;
            margin-top: -65px; /* Kéo logo lên đè vào ảnh bìa giống hệt Facebook */
            position: relative;
            z-index: 10;
        }
        .logo-img {
            width: 130px;
            height: 130px;
            border-radius: 50%; /* Bo tròn 100% */
            border: 5px solid #ffffff; /* Viền trắng bao quanh logo */
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            object-fit: contain;
            background: #fff;
        }

        /* KHU VỰC NỘI DUNG CHÍNH (CÓ THANH CUỘN BÊN TRONG NẾU QUÁ DÀI) */
        .content-area {
            padding: 1.5rem 2.5rem;
            min-height: 320px; /* Giữ chiều cao cố định để thẻ không bị giật khi chuyển tab */
            max-height: 400px;
            overflow-y: auto; /* Hiển thị thanh cuộn nội bộ nếu chữ quá dài */
        }
        
        /* Tùy chỉnh làm đẹp thanh cuộn */
        .content-area::-webkit-scrollbar { width: 6px; }
        .content-area::-webkit-scrollbar-thumb { background-color: #cbd5e1; border-radius: 10px; }

        /* THANH ĐIỀU HƯỚNG TABS Ở DƯỚI ĐÁY CÙNG */
        .nav-tabs {
            border-bottom: none;
            border-top: 1px solid #f1f5f9;
            background-color: #f8fafc;
            display: flex;
            justify-content: space-around; /* Chia đều 3 khoảng cách */
        }
        .nav-tabs .nav-link {
            border: none;
            color: #64748b;
            font-weight: 700;
            font-size: 0.9rem;
            text-transform: uppercase;
            padding: 1.2rem 1rem;
            border-bottom: 3px solid transparent; /* Chuẩn bị viền dưới tàng hình */
            border-radius: 0;
            transition: all 0.3s;
        }
        /* Khi tab được chọn */
        .nav-tabs .nav-link.active {
            color: #3b82f6; /* Đổi màu chữ thành xanh dương */
            border-bottom-color: #3b82f6; /* Hiện viền dưới màu xanh */
            background: transparent;
        }
        .nav-tabs .nav-link:hover {
            color: #3b82f6;
        }
    </style>
</head>
<body>

    <div class="container mt-3">
        <a href="/" class="btn btn-dark btn-sm shadow"><i class="bi bi-arrow-left"></i> Quay lại trang chủ</a>
    </div>

    <div class="container d-flex flex-grow-1 justify-content-center align-items-center py-4">
        
        <div class="profile-card">
            
            <div class="cover-photo"></div>

            <div class="logo-wrapper">
                <img src="https://ui-avatars.com/api/?name=${job.companyName}&background=0D8ABC&color=fff&size=200" class="logo-img" alt="Logo">
            </div>

            <div class="text-center px-4 pt-2">
                <h4 class="fw-bold text-dark mb-1">${job.title}</h4>
                <p class="text-muted text-uppercase fw-bold" style="font-size: 0.85rem; letter-spacing: 1px;">${job.companyName}</p>
            </div>

            <c:if test="${not empty successMsg}">
                <div class="mx-4 mt-2 alert alert-success text-center py-2" style="font-size: 0.9rem;">${successMsg}</div>
            </c:if>

            <div class="tab-content content-area" id="profileTabsContent">
                
                <div class="tab-pane fade show active" id="about" role="tabpanel">
                    <h5 class="fw-bold mb-3 text-secondary">Về Công Ty</h5>
                    <p class="text-muted" style="line-height: 1.8;">
                        Chào mừng bạn đến với <strong>${job.companyName}</strong>. Chúng tôi tự hào là một trong những đơn vị phát triển và năng động. Tại đây, chúng tôi luôn tạo điều kiện tốt nhất để các thành viên phát triển bản thân, học hỏi kiến thức mới và xây dựng một lộ trình thăng tiến rõ ràng.
                    </p>
                    <div class="d-flex justify-content-center gap-3 mt-4">
                        <a href="#" class="text-primary fs-4"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="text-info fs-4"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="text-primary fs-4"><i class="bi bi-linkedin"></i></a>
                    </div>
                </div>

                <div class="tab-pane fade" id="experience" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="badge bg-success px-3 py-2 fs-6">💰 ${job.salary}</span>
                        <span class="badge bg-secondary px-3 py-2"><i class="bi bi-geo-alt"></i> ${job.location}</span>
                    </div>
                    <h5 class="fw-bold mb-2 text-secondary">Yêu cầu & Mô tả</h5>
                    <div class="text-muted" style="white-space: pre-wrap; line-height: 1.7;">${job.description}</div>
                </div>

                <div class="tab-pane fade" id="contact" role="tabpanel">
                    <h5 class="fw-bold mb-3 text-secondary text-center">Gửi Hồ Sơ Ứng Tuyển</h5>
                    
                    <form action="/apply" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="jobId" value="${job.id}">
                        
                        <div class="mb-3">
                            <input type="text" class="form-control bg-light border-0" name="candidateName" required placeholder="Họ và tên của bạn...">
                        </div>
                        <div class="mb-3">
                            <input type="email" class="form-control bg-light border-0" name="candidateEmail" required placeholder="Địa chỉ Email...">
                        </div>
                        <div class="mb-4">
                            <label class="form-label text-muted fw-bold" style="font-size: 0.85rem;">Tải lên CV (PDF) *</label>
                            <input class="form-control bg-light border-0" type="file" name="cvFile" accept=".pdf" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2" style="border-radius: 10px;">GỬI NGAY</button>
                    </form>
                </div>

            </div>

            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#about" type="button" role="tab">Về Chúng Tôi</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#experience" type="button" role="tab">Công Việc</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#contact" type="button" role="tab">Liên Lạc</button>
                </li>
            </ul>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>