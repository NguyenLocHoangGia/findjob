<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark border-bottom shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold text-warning" href="/recruiter/dashboard">JobPortal Recruiter</a>
        <div class="d-flex align-items-center ms-auto">
            <span class="text-white me-3 mt-1">
                <i class="bi bi-person-circle me-1"></i>
                Xin chào, <strong>${currentUser.fullName}</strong>
            </span>
            <button class="btn btn-outline-light btn-sm">Đăng xuất</button>
        </div>
    </div>
</nav>