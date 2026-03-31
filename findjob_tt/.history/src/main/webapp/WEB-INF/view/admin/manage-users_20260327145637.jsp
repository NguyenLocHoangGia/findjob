<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Người dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .table thead { background-color: #f8f9fa; }
        .user-row { transition: all 0.2s; }
        .user-row:hover { background-color: #f8f9fa; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container my-5" style="padding-top: 20px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1 text-dark"><i class="bi bi-people-fill text-primary me-2"></i>Quản lý Người dùng</h2>
                <p class="text-muted mb-0">Theo dõi, phân quyền và khóa tài khoản vi phạm hệ thống.</p>
            </div>
        </div>

        <div class="card shadow-sm border-0 mb-4 p-3 rounded-4">
            <div class="row g-2">
                <div class="col-md-8">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" id="searchInput" class="form-control border-start-0 ps-0 shadow-none" 
                               placeholder="Tìm theo tên, email..." onkeyup="filterUsers()">
                    </div>
                </div>
                <div class="col-md-4">
                    <select id="roleFilter" class="form-select text-muted shadow-none" onchange="filterUsers()">
                        <option value="all">Tất cả Vai trò</option>
                        <option value="CANDIDATE">Ứng viên</option>
                        <option value="RECRUITER">Nhà tuyển dụng</option>
                        <option value="ADMIN">Quản trị viên</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead class="table-light text-secondary small text-uppercase">
                            <tr>
                                <th class="text-center py-3" width="5%">ID</th>
                                <th class="ps-4 py-3" width="30%">Thông tin Người dùng</th>
                                <th class="py-3" width="20%">Vai trò (Role)</th>
                                <th class="text-center py-3" width="15%">Trạng thái</th>
                                <th class="text-center py-3" width="20%">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="user-tbody">
                            <c:forEach var="user" items="${users}">
                                
                                <c:set var="userRole" value="CANDIDATE" />
                                <c:set var="roleBadge" value="bg-info text-dark" />
                                <c:set var="roleName" value="Ứng viên" />
                                
                                <c:forEach var="role" items="${user.roles}">
                                    <c:if test="${role.name == 'ROLE_RECRUITER'}">
                                        <c:set var="userRole" value="RECRUITER" />
                                        <c:set var="roleBadge" value="bg-success text-white" />
                                        <c:set var="roleName" value="Nhà tuyển dụng" />
                                    </c:if>
                                    <c:if test="${role.name == 'ROLE_ADMIN'}">
                                        <c:set var="userRole" value="ADMIN" />
                                        <c:set var="roleBadge" value="bg-danger text-white" />
                                        <c:set var="roleName" value="Quản trị viên" />
                                    </c:if>
                                </c:forEach>

                                <tr class="user-row" 
                                    data-name="${fn:toLowerCase(not empty user.fullName ? user.fullName : '')}"
                                    data-email="${fn:toLowerCase(user.email)}"
                                    data-role="${userRole}">
                                    
                                    <td class="text-center align-middle">${user.id}</td>
                                    
                                    <td class="ps-4 align-middle">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-secondary bg-opacity-10 text-secondary rounded-circle d-flex align-items-center justify-content-center me-3 fw-bold" style="width: 45px; height: 45px;">
                                                <i class="bi bi-person"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold text-dark">${not empty user.fullName ? user.fullName : 'Chưa cập nhật tên'}</div>
                                                <div class="small text-muted">${user.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    
                                    <td class="align-middle">
                                        <span class="badge ${roleBadge} px-3 py-2 rounded-pill">${roleName}</span>
                                    </td>
                                    
                                    <td class="text-center align-middle">
                                        <span class="badge bg-success-subtle text-success border border-success border-opacity-25 px-3 py-2 rounded-pill w-100">
                                            <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i> Hoạt động
                                        </span>
                                    </td>
                                    
                                    <td class="text-center align-middle">
                                        <c:if test="${userRole != 'ADMIN'}">
                                            <button class="btn btn-sm btn-outline-danger fw-medium rounded-pill px-3 shadow-sm">
                                                <i class="bi bi-lock-fill me-1"></i> Khóa tài khoản
                                            </button>
                                        </c:if>
                                        <c:if test="${userRole == 'ADMIN'}">
                                            <span class="text-muted small fst-italic">Không thể thao tác</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterUsers() {
            const keyword = document.getElementById("searchInput").value.toLowerCase();
            const roleFilter = document.getElementById("roleFilter").value;
            const rows = document.querySelectorAll(".user-row");

            rows.forEach(row => {
                const rowName = row.getAttribute("data-name");
                const rowEmail = row.getAttribute("data-email");
                const rowRole = row.getAttribute("data-role");

                const matchesKeyword = rowName.includes(keyword) || rowEmail.includes(keyword);
                const matchesRole = (roleFilter === "all") || (roleFilter === rowRole);

                if (matchesKeyword && matchesRole) {
                    row.style.display = "table-row";
                } else {
                    row.style.display = "none";
                }
            });
        }
    </script>
</body>
</html>