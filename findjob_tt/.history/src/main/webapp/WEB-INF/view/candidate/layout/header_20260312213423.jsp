<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container fixed-top mt-3 z-3">
    <nav class="navbar navbar-expand-lg navbar-dark rounded-pill shadow-lg px-4 py-3" style="background-color: rgba(33, 37, 41, 0.65) !important; backdrop-filter: blur(15px);">
        
        <a class="navbar-brand fw-bold d-flex align-items-center fs-4" href="/">
            <span class="bg-info rounded-circle me-2 d-inline-block" style="width: 20px; height: 20px;"></span>
            JobPortal
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#headerMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="headerMenu">
            <div class="ms-auto d-flex align-items-center gap-4">
                
                <a href="/upgrade-recruiter" class="text-white fw-medium text-decoration-none hover-scale d-flex align-items-center">
                    <i class="bi bi-buildings fs-5 me-2 text-success"></i> Nhà tuyển dụng
                </a>

                <c:choose>
                    
                    <%-- NẾU ĐÃ ĐĂNG NHẬP --%>
                    <c:when test="${not empty pageContext.request.userPrincipal}">
                        
                        <a href="/candidate/saved-jobs" class="position-relative text-white hover-scale mt-1" title="Việc làm đã lưu">
                            <i class="bi bi-heart-fill fs-4 text-danger"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-dark" style="font-size: 0.7rem; padding: 0.35em 0.55em;">3</span>
                        </a>

                        <a href="/candidate/notifications" class="position-relative text-white hover-scale mt-1" title="Thông báo ứng tuyển">
                            <i class="bi bi-bell-fill fs-4 text-warning"></i>
                            <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle" style="margin-top: 5px; margin-left: -5px;">
                                <span class="visually-hidden">New alerts</span>
                            </span>
                        </a>

                        <div class="nav-item dropdown position-relative ms-2">
                            <a class="nav-link text-white d-flex align-items-center p-0" href="#" role="button" data-bs-toggle="dropdown" data-bs-display="static" aria-expanded="false">
                                
                                <%-- Nếu có ảnh thì hiện ảnh, không thì hiện icon mặc định --%>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.img}">
                                        <img src="/uploads/avatars/${candidateProfileDTO.existingImg}" alt="Avatar" class="rounded-circle object-fit-cover border border-2 border-info hover-scale" style="width: 40px; height: 40px;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-person-circle fs-2 text-info hover-scale"></i>
                                    </c:otherwise>
                                </c:choose>
                                
                                <i class="bi bi-caret-down-fill ms-1 mt-1 hover-scale" style="font-size: 0.75rem;"></i>
                            </a>
                            
                            <ul class="dropdown-menu dropdown-menu-center shadow-lg border-0 mt-3 rounded-4 p-2" style="min-width: 220px; background-color: rgba(255, 255, 255, 0.95);">
                                <li>
                                    <a class="dropdown-item py-2 rounded-3 fw-medium mb-1" href="/candidate/profile">
                                        <i class="bi bi-person-vcard text-primary me-2"></i> Xem hồ sơ cá nhân
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
                    </c:when>

                    <%-- NẾU CHƯA ĐĂNG NHẬP --%>
                    <c:otherwise>
                        <div class="d-flex align-items-center gap-3 ms-3">
                            <a href="/login" class="btn btn-outline-light rounded-pill px-4 fw-bold">Đăng nhập</a>
                            <a href="/register" class="btn btn-info text-dark rounded-pill px-4 fw-bold shadow-sm">Đăng ký</a>
                        </div>
                    </c:otherwise>

                </c:choose>

            </div>
        </div>
    </nav>
</div>

<style>
    .hover-scale { transition: transform 0.2s ease-in-out; }
    .hover-scale:hover { transform: scale(1.15); }
    .dropdown-item:hover { background-color: #f8f9fa; transform: translateX(3px); transition: all 0.2s ease; }
    .dropdown-menu-center { left: 50% !important; right: auto !important; transform: translateX(-50%) !important; }
</style>