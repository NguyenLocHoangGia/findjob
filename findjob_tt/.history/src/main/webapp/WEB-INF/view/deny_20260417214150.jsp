<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${errorTitle} - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #f0f4ff 0%, #f8fafc 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }

        .deny-card {
            max-width: 680px;
            width: 100%;
            background: #ffffff;
            border-radius: 18px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 20px 45px rgba(15, 23, 42, 0.08);
            padding: 32px 28px;
            text-align: center;
        }

        .status-badge {
            display: inline-block;
            background: #eff6ff;
            color: #1d4ed8;
            font-weight: 700;
            letter-spacing: 0.5px;
            border-radius: 999px;
            padding: 8px 14px;
            margin-bottom: 16px;
        }

        .icon-wrap {
            width: 84px;
            height: 84px;
            border-radius: 999px;
            background: #fee2e2;
            color: #dc2626;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-bottom: 16px;
        }

        .deny-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 10px;
        }

        .deny-desc {
            color: #475569;
            margin-bottom: 24px;
            line-height: 1.6;
        }
    </style>
</head>

<body>
    <div class="deny-card">
        <div class="status-badge">Mã lỗi: ${statusCode}</div>
        <div class="icon-wrap">
            <i class="bi bi-exclamation-triangle-fill"></i>
        </div>
        <h1 class="deny-title">${errorTitle}</h1>
        <p class="deny-desc">${errorMessage}</p>

        <a href="/" class="btn btn-primary btn-lg px-4 fw-bold">
            <i class="bi bi-house-door-fill me-2"></i>Quay về trang chủ
        </a>
    </div>
</body>

</html>
