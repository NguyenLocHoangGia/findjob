<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng điều khiển - Nhà tuyển dụng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        /* Đảm bảo toàn màn hình */
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        
        /* CẬP NHẬT MỚI: Biến khu vực bên phải thành cột dọc để ép Footer xuống đáy */
        .content-area { display: flex; flex-direction: column; flex: 1; }
        
        /* CẬP NHẬT MỚI: Tách padding ra một thẻ riêng để không dính vào Footer */
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
                <h3 class="fw-bold mb-4">Danh sách Ứng viên mới nhất</h3>

                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <table class="table table-hover table-bordered mb-0">
                            <thead class="table-primary">
                                <tr>
                                    <th class="text-center" width="5%">STT</th>
                                    <th>Tên Ứng viên</th>
                                    <th>Email</th>
                                    <th>Vị trí ứng tuyển</th>
                                    <th>Ngày nộp</th>
                                    <th class="text-center" width="20%">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="app" items="${applications}" varStatus="status">
                                    <tr>
                                        <td class="text-center align-middle">${status.index + 1}</td>
                                        <td class="align-middle fw-bold">${app.candidateName}</td>
                                        <td class="align-middle">${app.candidateEmail}</td>
                                        <td class="align-middle text-primary">${app.job.title}</td>
                                        <td class="align-middle">${app.formattedApplyDate}</td>
                                        <td class="text-center align-middle">
                                            <a href="/uploads/cv/${app.cvFileName}" target="_blank" class="btn btn-sm btn-success">
                                                <i class="bi bi-eye"></i> Xem CV
                                            </a>
                                            <button class="btn btn-sm btn-outline-danger ms-1">
                                                <i class="bi bi-trash"></i> Xóa
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            </div>
            
            <jsp:include page="layout/footer.jsp" />
        </div>
    </div>

</body>
</html>