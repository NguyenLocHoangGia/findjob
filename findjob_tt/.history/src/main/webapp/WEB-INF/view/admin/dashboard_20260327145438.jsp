<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        /* Style cho các tấm thẻ thống kê */
        .stat-card {
            border: none;
            border-radius: 15px;
            transition: transform 0.3s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .icon-box {
            width: 60px; height: 60px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem;
        }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container my-5" style="padding-top: 80px;">
        <h2 class="fw-bold mb-4 text-dark"><i class="bi bi-speedometer2 text-primary me-2"></i>Bảng điều khiển Tổng quan</h2>
        
        <div class="row g-4 mb-5">
            
            <div class="col-md-4">
                <div class="card stat-card shadow-sm bg-white p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted fw-bold mb-1 text-uppercase" style="font-size: 0.85rem;">Tổng người dùng</p>
                            <h2 class="fw-bold mb-0 text-dark">${totalUsers}</h2>
                        </div>
                        <div class="icon-box bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-people-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card stat-card shadow-sm bg-white p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted fw-bold mb-1 text-uppercase" style="font-size: 0.85rem;">Tin tuyển dụng</p>
                            <h2 class="fw-bold mb-0 text-dark">${totalJobs}</h2>
                        </div>
                        <div class="icon-box bg-success bg-opacity-10 text-success">
                            <i class="bi bi-briefcase-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card stat-card shadow-sm bg-white p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted fw-bold mb-1 text-uppercase" style="font-size: 0.85rem;">Lượt ứng tuyển (CV)</p>
                            <h2 class="fw-bold mb-0 text-dark">${totalApplications}</h2>
                        </div>
                        <div class="icon-box bg-warning bg-opacity-10 text-warning">
                            <i class="bi bi-file-earmark-person-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>