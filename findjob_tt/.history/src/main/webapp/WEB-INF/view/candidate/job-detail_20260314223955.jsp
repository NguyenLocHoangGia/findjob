<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${job.title} - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        /* Ép Footer xuống đáy và tạo màu nền xám nhạt làm nổi bật các Card trắng */
        body { 
            background-color: #f4f7fa; 
            display: flex; 
            flex-direction: column; 
            min-height: 100vh; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }
        .main-content { flex: 1; padding-top: 2rem; padding: 120px 0 50px 0px; }
        
        /* Chỉnh sửa Thẻ (Card) bo góc mượt mà, đổ bóng nhẹ */
        .custom-card { 
            border: none; 
            border-radius: 12px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.03); 
            background: #fff; 
            margin-bottom: 1.5rem; 
        }
        
        /* Hiệu ứng dính (Sticky) cho cột bên phải: Form luôn chạy theo khi cuộn chuột */
        .sticky-form { position: sticky; top: 20px; }
        
        /* Logo công ty tự động sinh ra nếu không có */
        .company-logo { 
            width: 80px; height: 80px; 
            border-radius: 12px; 
            object-fit: cover; 
            border: 1px solid #eee; 
        }
        
        /* Badge thông tin Lương, Địa điểm đẹp mắt */
        .info-badge { 
            background: #f8f9fa; 
            border: 1px solid #e9ecef; 
            padding: 12px 18px; 
            border-radius: 10px; 
            display: flex; 
            align-items: center; 
            gap: 12px; 
        }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="main-content">
        <div class="container">
            
            <a href="/" class="btn btn-sm btn-outline-secondary rounded-pill mb-4 px-3 shadow-sm">
                <i class="bi bi-arrow-left me-1"></i> Quay lại trang chủ
            </a>

            <c:if test="${not empty successMsg}">
                <div class="alert alert-success fw-bold shadow-sm rounded-3">
                    <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
                </div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger fw-bold shadow-sm rounded-3">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMsg}
                </div>
            </c:if>

            <div class="row g-4">
                
                <div class="col-lg-8">
                    
                    <div class="custom-card p-4">
                        <div class="d-flex align-items-center gap-4 mb-4">
                            <c:choose>
                               
                                <c:when test="${not empty job.logo}">
                                    <img src="/uploads/company_logos/${job.logo}" 
                                    class="company-logo shadow-sm" 
                                    onerror="this.onerror=null;this.src='/uploads/job_logos/${job.logo}';" 
                                    alt="Logo">
                                </c:when>
                                
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${job.companyName}&background=0D8ABC&color=fff&size=120" class="company-logo shadow-sm" alt="Logo">
                                </c:otherwise>
                            </c:choose>
                            <div>
                                <h2 class="fw-bold text-dark mb-2">${job.title}</h2>
                                <h5 class="text-primary mb-0"><i class="bi bi-building me-2"></i>${job.companyName}</h5>
                            </div>
                        </div>
                        
                        <div class="d-flex flex-wrap gap-3">
                            <div class="info-badge">
                                <i class="bi bi-cash-stack text-success fs-4"></i>
                                <div>
                                    <small class="text-muted d-block">Mức lương</small>
                                    <strong class="text-dark">${job.salary}</strong>
                                </div>
                            </div>
                            <div class="info-badge">
                                <i class="bi bi-geo-alt text-danger fs-4"></i>
                                <div>
                                    <small class="text-muted d-block">Địa điểm</small>
                                    <strong class="text-dark">${job.location}</strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="custom-card p-4">
                        <h4 class="fw-bold mb-4 border-bottom pb-3 text-dark">Chi tiết công việc</h4>
                        <div class="text-dark" style="white-space: pre-wrap; line-height: 1.8; font-size: 1rem;">${job.description}</div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="custom-card p-4 sticky-form border-top border-bottom border-4 border-primary">
                        <h5 class="fw-bold text-center mb-4 text-dark">Ứng tuyển ngay</h5>
                        
                        <form action="/apply" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="jobId" value="${job.id}">
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-secondary small">Họ và tên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control bg-light" name="candidateName" 
                                    value="${not empty candidate.user.fullName ? candidate.user.fullName : ''}" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold text-secondary small">Email liên hệ <span class="text-danger">*</span></label>
                                <input type="email" class="form-control bg-light" name="candidateEmail" 
                                    value="${not empty userEmail ? userEmail : ''}" required>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold text-secondary small">Tải lên CV (PDF) <span class="text-danger">*</span></label>
                                <input class="form-control bg-light" type="file" name="cvFile" accept=".pdf" 
                                    <c:if test="${empty candidate.existingCv}">required</c:if> >
                                
                                <c:if test="${not empty candidate.existingCv}">
                                    <small class="text-success d-block mt-1" style="font-size: 0.75rem;">
                                        <i class="bi bi-file-earmark-check-fill"></i> Hệ thống sẽ dùng CV sẵn có. Tải tệp mới nếu muốn thay đổi.
                                    </small>
                                </c:if>
                            </div>
                            
                            <button type="submit" class="btn btn-primary btn-lg w-100 fw-bold shadow-sm">
                                <i class="bi bi-send me-2"></i> GỬI HỒ SƠ
                            </button>
                        </form>
                        
                        <div class="mt-4 text-center">
                            <small class="text-muted fst-italic">
                                <i class="bi bi-shield-check text-success me-1"></i> Thông tin của bạn được bảo mật an toàn.
                            </small>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    
    <jsp:include page="layout/footer.jsp" />

</body>
</html>