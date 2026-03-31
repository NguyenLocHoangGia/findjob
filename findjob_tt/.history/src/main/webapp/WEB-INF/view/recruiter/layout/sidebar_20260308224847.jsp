<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="bg-dark text-white p-3 shadow" style="width: 260px; min-height: calc(100vh - 56px);">
    <h6 class="text-uppercase text-muted fw-bold mb-3 mt-2 text-center">Menu Quản trị</h6>
    <hr class="border-secondary">
    
    <ul class="nav flex-column gap-2 mt-3">
        <li class="nav-item">
            <a href="/recruiter/dashboard" class="nav-link text-white rounded hover-bg ${pageContext.request.requestURI eq '/WEB-INF/view/recruiter/dashboard.jsp' ? 'bg-primary' : ''}">
                <i class="bi bi-speedometer2 me-2"></i> Bảng điều khiển
            </a>
        </li>
        <li class="nav-item">
            <a href="/recruiter/job/add" class="nav-link text-white rounded hover-bg ${pageContext.request.requestURI eq '/WEB-INF/view/recruiter/add-job.jsp' ? 'bg-primary' : ''}">
                <i class="bi bi-megaphone me-2"></i> Đăng tin tuyển dụng
            </a>
        </li>
        <li class="nav-item">
            <a href="#" class="nav-link text-white rounded hover-bg">
                <i class="bi bi-briefcase me-2"></i> Quản lý Công việc
            </a>
        </li>
        <li class="nav-item mt-4">
            <a href="#" class="nav-link text-danger rounded hover-bg">
                <i class="bi bi-gear me-2"></i> Cài đặt
            </a>
        </li>
    </ul>
</div>

<style>
    /* Hiệu ứng sáng lên khi đưa chuột vào menu */
    .hover-bg:hover { background-color: rgba(255, 255, 255, 0.1); }
</style>