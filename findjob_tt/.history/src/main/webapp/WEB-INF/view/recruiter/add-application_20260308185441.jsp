<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm mới Hồ sơ - Nhà tuyển dụng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        /* Khung CSS chuẩn mực để ép Footer xuống đáy */
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
                    <h3 class="fw-bold mb-4">Thêm mới Hồ sơ ứng viên (Nhập tay)</h3>

                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger fw-bold">${errorMsg}</div>
                    </c:if>

                    <div class="card shadow-sm border-0" style="max-width: 800px;">
                        <div class="card-body p-4">
                            
                            <form action="/recruiter/application/save" method="POST" enctype="multipart/form-data">
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Họ và tên Ứng viên <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="candidateName" required placeholder="Ví dụ: Nguyễn Văn A">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Email liên hệ <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" name="candidateEmail" required placeholder="name@example.com">
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Ứng tuyển vào Vị trí (Công việc) <span class="text-danger">*</span></label>
                                    <select class="form-select" name="jobId" required>
                                        <option value="" disabled selected>-- Vui lòng chọn công việc --</option>
                                        <c:forEach var="job" items="${jobs}">
                                            <option value="${job.id}">${job.title} (${job.companyName})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold">Tải lên file CV (PDF) <span class="text-danger">*</span></label>
                                    <input class="form-control" type="file" name="cvFile" accept=".pdf" required>
                                    <small class="text-muted fst-italic">HR tự upload CV của ứng viên nhận được qua kênh ngoài (Zalo, Email...).</small>
                                </div>

                                <hr>
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary fw-bold px-4">
                                        <i class="bi bi-save me-2"></i> Lưu Hồ sơ
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>