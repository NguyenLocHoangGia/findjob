<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Trạng thái Hồ sơ - JobPortal</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <style>
                body {
                    background-color: #f4f7fa;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }
            </style>
        </head>

        <body class="d-flex flex-column min-vh-100">

            <jsp:include page="../candidate/layout/header.jsp" />

            <div class="container flex-grow-1 d-flex align-items-center justify-content-center py-5">
                <div class="card shadow-sm border-0 rounded-4 text-center p-5" style="max-width: 600px; width: 100%;">

                    <c:choose>
                        <%-- TRƯỜNG HỢP 1: ĐANG CHỜ DUYỆT --%>
                            <c:when test="${company.status == 'PENDING'}">
                                <div class="mb-4">
                                    <i class="bi bi-hourglass-split text-warning" style="font-size: 5rem;"></i>
                                </div>
                                <h2 class="fw-bold text-dark mb-3">Hồ sơ đang được xét duyệt</h2>
                                <p class="text-muted fs-5 mb-4">
                                    Ban quản trị đang tiến hành xác minh giấy phép kinh doanh của công ty <strong
                                        class="text-dark">${company.companyName}</strong>.
                                    Quá trình này có thể mất từ 1-2 ngày làm việc.
                                </p>
                                <div
                                    class="alert alert-warning border-warning bg-warning bg-opacity-10 d-inline-block text-start mb-4">
                                    <i class="bi bi-info-circle-fill me-2"></i> Hệ thống sẽ thông báo cho bạn ngay khi
                                    có kết quả. Vui lòng kiên nhẫn!
                                </div>
                                <div>
                                    <a href="/" class="btn btn-primary rounded-pill px-4 py-2 fw-bold shadow-sm">
                                        <i class="bi bi-house-door-fill me-2"></i>Quay lại Trang chủ
                                    </a>
                                </div>
                            </c:when>

                            <%-- TRƯỜNG HỢP 2: BỊ TỪ CHỐI --%>
                                <c:when test="${company.status == 'REJECTED'}">
                                    <div class="mb-4">
                                        <i class="bi bi-x-circle-fill text-danger" style="font-size: 5rem;"></i>
                                    </div>
                                    <h2 class="fw-bold text-danger mb-3">Hồ sơ bị từ chối</h2>
                                    <p class="text-muted fs-5 mb-4">
                                        Rất tiếc, thông tin hoặc giấy phép kinh doanh của công ty <strong
                                            class="text-dark">${company.companyName}</strong> không hợp lệ hoặc không rõ
                                        ràng nên không thể vượt qua vòng kiểm duyệt.
                                    </p>
                                    <div class="d-grid gap-3 d-sm-flex justify-content-sm-center mt-4">
                                        <a href="/recruiter/register-company?retry=true"
                                            class="btn btn-danger rounded-pill px-4 py-2 fw-bold shadow-sm">
                                            <i class="bi bi-arrow-repeat me-2"></i> Cập nhật lại Hồ sơ
                                        </a>
                                        <a href="/" class="btn btn-outline-secondary rounded-pill px-4 py-2 fw-bold">
                                            Về Trang chủ
                                        </a>
                                    </div>
                                </c:when>
                                <%-- TRƯỜNG HỢP 3: CHÚC MỪNG ĐƯỢC DUYỆT --%>
                                <c:when test="${company.status == 'APPROVED'}">
                                    <div class="mb-4">
                                        <i class="bi bi-check-circle-fill text-success" style="font-size: 5rem;"></i>
                                    </div>
                                    <h2 class="fw-bold text-success mb-3">Chúc mừng! Hồ sơ đã được duyệt</h2>
                                    <p class="text-muted fs-5 mb-4">
                                        Giấy phép kinh doanh của công ty <strong class="text-dark">${company.companyName}</strong> đã được Admin xác minh. 
                                        Tài khoản của bạn đã chính thức được nâng cấp lên <strong>Nhà tuyển dụng</strong>.
                                    </p>
                                    <div>
                                        <a href="/recruiter/dashboard" class="btn btn-success rounded-pill px-4 py-2 fw-bold shadow-sm">
                                            <i class="bi bi-speedometer2 me-2"></i> Vào Bảng điều khiển ngay
                                        </a>
                                    </div>
                                </c:when>
                    </c:choose>
                </div>
            </div>

        </body>

        </html>