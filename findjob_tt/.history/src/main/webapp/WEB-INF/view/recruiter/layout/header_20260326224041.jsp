<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark border-bottom shadow-sm py-3" style="position: sticky; top: 0; z-index: 1050;">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold text-warning d-flex align-items-center fs-4" href="/recruiter/dashboard">
            <i class="bi bi-briefcase-fill me-2"></i> JobPortal Recruiter
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#recruiterMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="recruiterMenu">
            <div class="d-flex align-items-center ms-auto gap-4 mt-3 mt-lg-0">
                
                <a href="/" class="text-light fw-medium text-decoration-none hover-scale d-flex align-items-center" title="Trở về trang tìm việc">
                    <i class="bi bi-person-badge fs-5 me-2 text-info"></i> Góc Ứng viên
                </a>

                <div class="nav-item dropdown position-relative ms-2">
                    <a class="nav-link text-white d-flex align-items-center p-0" href="#" role="button" data-bs-toggle="dropdown" data-bs-display="static" aria-expanded="false">
                        
                        <span class="me-3 d-none d-md-inline opacity-75">
                            Xin chào, <strong class="text-white">${not empty currentUser.fullName ? currentUser.fullName : 'Nhà tuyển dụng'}</strong>
                        </span>

                        <%-- Avatar --%>
                        <c:choose>
                            <c:when test="${not empty sessionScope.img}">
                                <img src="/uploads/avatars/${sessionScope.img}" alt="Avatar" class="rounded-circle object-fit-cover border border-2 border-warning hover-scale bg-white" style="width: 42px; height: 42px;">
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-person-circle fs-2 text-warning hover-scale"></i>
                            </c:otherwise>
                        </c:choose>
                        
                    </a>
                    
                    <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 mt-3 rounded-4 p-2" style="min-width: 230px;">
                        <li>
                            <a class="dropdown-item py-2 rounded-3 fw-medium mb-1" href="/recruiter/edit-company">
                                <i class="bi bi-building-gear text-primary me-2"></i> Hồ sơ Công ty
                            </a>
                        </li>
                        <li><hr class="dropdown-divider opacity-25 my-2"></li>
                        <li>
                            <form action="/logout" method="post" class="m-0">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button type="submit" class="dropdown-item py-2 rounded-3 fw-bold text-danger">
                                    <i class="bi bi-box-arrow-right me-2"></i> Đăng xuất
                                </button>
                            </form>
                        </li>
                    </ul>
                </div>

            </div>
        </div>
    </div>
</nav>

<style>
    .hover-scale { transition: transform 0.2s ease-in-out; }
    .hover-scale:hover { transform: scale(1.15); }
    .dropdown-item:hover { background-color: #f8f9fa; transform: translateX(3px); transition: all 0.2s ease; }
</style>