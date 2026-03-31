<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${job.title} - Chi tiết việc làm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-5">
        <div class="container">
            <a class="navbar-brand fw-bold" href="/">JobPortal Intern</a>
        </div>
    </nav>

    <div class="container">
        <a href="/" class="btn btn-secondary mb-3">&larr; Quay lại danh sách</a>

        <div class="row">
            <div class="col-md-8">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        <h2 class="fw-bold text-primary mb-3">${job.title}</h2>
                        <h5 class="text-muted mb-4"><i class="bi bi-building"></i> ${job.companyName}</h5>
                        
                        <div class="d-flex gap-3 mb-4">
                            <span class="badge bg-success fs-6">Lương: ${job.salary}</span>
                            <span class="badge bg-secondary fs-6">Địa điểm: ${job.location}</span>
                        </div>

                        <h4 class="fw-bold mt-4 mb-3">Mô tả công việc</h4>
                        <div class="text-dark lh-lg" style="white-space: pre-wrap;">${job.description}</div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm border-0 bg-white">
                    <div class="card-body p-4 text-center">
                        <img src="https://via.placeholder.com/150" class="rounded mb-3" alt="Logo">
                        <h5 class="fw-bold">${job.companyName}</h5>
                        <hr>
                        <button class="btn btn-warning btn-lg w-100 fw-bold mt-3">ỨNG TUYỂN NGAY</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>