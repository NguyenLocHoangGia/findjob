<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Tin Tuyển Dụng Mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        .content-area { display: flex; flex-direction: column; flex: 1; }
        .main-content { flex: 1; padding: 30px; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="main-wrapper">
        
        <jsp:include page="layout/sidebar.jsp" />

        <div class="content-area">
            <div class="main-content">
                <div class="container-fluid">
                    <h3 class="fw-bold mb-4">Đăng Tin Tuyển Dụng (Job)</h3>

                    <div class="card shadow-sm border-0" style="max-width: 900px;">
                        <div class="card-body p-4">
                            
                            <form action="/recruiter/job/save" method="POST" enctype="multipart/form-data">

                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                
                                <div class="row">
                                    <div class="col-md-8 mb-3">
                                        <label class="form-label fw-bold">Tiêu đề công việc <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="title" required placeholder="VD: Thực tập sinh Java Spring Boot">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label fw-bold">Tên công ty <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="companyName" required placeholder="VD: Tech Asia">
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Mức lương <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="salary" required placeholder="VD: 5.000.000 VNĐ / Thỏa thuận">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Địa điểm làm việc <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="location" required placeholder="VD: Hà Nội, Đà Nẵng, TP.HCM">
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold text-primary">Mô tả ngắn gọn (Hiển thị ngoài Trang chủ) <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="shortDescription" required maxlength="150" placeholder="VD: Tìm kiếm 2 bạn Thực tập sinh Java đam mê lập trình web, có hỗ trợ dấu mộc...">
                                    <small class="text-muted fst-italic">Nhập 1-2 câu tóm tắt cực kỳ hấp dẫn để thu hút ứng viên click vào.</small>
                                </div>

                                <div class="mb-4 mt-4">
                                    <label class="form-label fw-bold">Mô tả chi tiết và Yêu cầu (Hiển thị ở trang Chi tiết) <span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="description" rows="6" required placeholder="- Yêu cầu kỹ năng...&#10;- Quyền lợi được hưởng...&#10;- Thời gian làm việc..."></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="logoFile" class="form-label fw-bold">Tải lên Logo công ty (Khuyến nghị ảnh vuông 1:1)</label>
                                    
                                    <input class="form-control" type="file" id="logoFile" accept=".png, .jpg, .jpeg" name="logoFile" onchange="previewLogo(event)"/>
                                </div>

                                <div class="mb-4 text-center" id="previewContainer" style="display: none;">
                                    <p class="text-muted small mb-2">Bản xem trước Logo trên trang chủ:</p>
                                    
                                    <img id="logoPreview" src="" alt="Logo Preview" 
                                        style="width: 100px; height: 100px; object-fit: cover; border-radius: 12px; border: 1px solid #dee2e6; box-shadow: 0 4px 12px rgba(0,0,0,0.1); padding: 0;">
                                </div>
                                <hr>
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary fw-bold px-4">
                                        <i class="bi bi-send-check me-2"></i> Đăng tin ngay
                                    </button>
                                    <a href="/recruiter/dashboard" class="btn btn-light border">Hủy bỏ</a>
                                </div>
                            </form>

                        </div>
                    </div>

                </div>
            </div>
            
            <jsp:include page="layout/footer.jsp" />
            
        </div>
    </div>

    <script>
        // Hàm xử lý hiển thị ảnh xem trước
        function previewLogo(event) {
            const input = event.target;
            const previewImg = document.getElementById('logoPreview');
            const previewContainer = document.getElementById('previewContainer');

            // Kiểm tra xem người dùng có chọn file không
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                // Khi file được đọc xong
                reader.onload = function(e) {
                    previewImg.src = e.target.result; // Gán data ảnh vào thẻ img
                    previewContainer.style.display = 'block'; // Hiện khung xem trước lên
                }
                
                // Bắt đầu đọc file dưới dạng Data URL
                reader.readAsDataURL(input.files[0]);
            } else {
                // Nếu người dùng ấn "Cancel" không chọn ảnh nữa thì ẩn khung đi
                previewImg.src = "";
                previewContainer.style.display = 'none';
            }
        }
    </script>
</body>
</html>