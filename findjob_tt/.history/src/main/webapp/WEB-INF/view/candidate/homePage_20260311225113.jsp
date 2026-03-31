<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container fixed-top mt-3 z-3">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark rounded-pill shadow-lg px-4 py-2" style="background-color: rgba(33, 37, 41, 0.9) !important; backdrop-filter: blur(10px);">
        
        <a class="navbar-brand fw-bold d-flex align-items-center" href="/">
            <span class="bg-info rounded-circle me-2 d-inline-block" style="width: 16px; height: 16px;"></span>
            JobPortal
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#headerMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="headerMenu">
            
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0 fw-medium">
                <li class="nav-item">
                    <a class="nav-link active text-white" href="/">
                        <i class="bi bi-house-door-fill me-1"></i> Trang chủ
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-4">
                
                <a href="javascript:history.back()" class="text-white text-decoration-none small fw-bold d-flex align-items-center hover-opacity" title="Quay lại">
                    <i class="bi bi-arrow-left-circle fs-5 me-1"></i> Quay lại
                </a>

                <a href="/candidate/saved-jobs" class="position-relative text-white hover-scale" title="Việc làm đã lưu">
                    <i class="bi bi-heart-fill fs-5 text-danger"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-dark" style="font-size: 0.65rem; padding: 0.3em 0.5em;">
                        3
                        <span class="visually-hidden">việc làm quan tâm</span>
                    </span>
                </a>

                <a href="/candidate/profile" class="text-white hover-scale" title="Hồ sơ cá nhân">
                    <i class="bi bi-person-circle fs-4 text-info"></i>
                </a>

                <form action="/logout" method="post" class="m-0 ms-2">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-danger btn-sm rounded-pill px-3 fw-bold shadow-sm">
                        <i class="bi bi-box-arrow-right me-1"></i> Thoát
                    </button>
                </form>

            </div>
        </div>
    </nav>
</div>

<style>
    .hover-scale { transition: transform 0.2s ease-in-out; }
    .hover-scale:hover { transform: scale(1.15); }
    .hover-opacity { transition: opacity 0.2s; }
    .hover-opacity:hover { opacity: 0.7; }
</style>