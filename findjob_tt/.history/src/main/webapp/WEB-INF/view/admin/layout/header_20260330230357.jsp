<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <nav class="navbar navbar-expand-lg navbar-dark border-bottom shadow-sm py-3"
            style="background-color: #1a1d20; position: sticky; top: 0; z-index: 1050;">
            <div class="container-fluid px-4">
                <a class="navbar-brand fw-bold text-danger d-flex align-items-center fs-4" href="/admin/dashboard">
                    <i class="bi bi-shield-lock-fill me-2"></i> Hệ thống Quản trị
                </a>

                <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse"
                    data-bs-target="#adminMenu">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="adminMenu">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-4 gap-2">
                        <li class="nav-item">
                            <a class="nav-link text-white fw-medium" href="/admin/dashboard"><i
                                    class="bi bi-speedometer2 me-1"></i> Tổng quan</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white fw-medium" href="/admin/users"><i
                                    class="bi bi-people me-1"></i> Quản lý Người dùng</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white fw-medium" href="/admin/companies"><i
                                    class="bi bi-building-check me-1"></i> Duyệt Công ty</a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link text-white fw-medium" href="/admin/categories"><i
                                    class="bi bi-tags me-1"></i> Ngành nghề</a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link text-white fw-medium d-flex align-items-center" href="/admin/manage-jobs">
                                <i class="bi bi-briefcase me-1"></i> Kiểm duyệt Tin
                                <c:if test="${pendingJobsCount > 0}">
                                    <span class="badge bg-danger ms-2 rounded-pill shadow-sm" style="font-size: 0.7rem; padding: 0.35em 0.6em;">
                                        ${pendingJobsCount}
                                    </span>
                                </c:if>
                            </a>
                        </li>
                    </ul>

                    <div class="d-flex align-items-center ms-auto">
                        <span class="text-white me-4 opacity-75">
                            <i class="bi bi-person-circle me-1"></i> Xin chào, <strong class="text-white">Admin</strong>
                        </span>
                        <form action="/logout" method="post" class="m-0">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" class="btn btn-outline-danger btn-sm fw-bold rounded-pill px-3">
                                <i class="bi bi-box-arrow-right me-1"></i> Đăng xuất
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </nav>

        <style>
            .nav-link:hover {
                color: #dc3545 !important;
                transition: 0.2s;
            }
            /* Thêm hiệu ứng nhịp tim nhẹ cho cái chuông báo đỏ để Admin dễ chú ý */
            .badge.bg-danger {
                animation: pulse 2s infinite;
            }
            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.1); }
                100% { transform: scale(1); }
            }
        </style>