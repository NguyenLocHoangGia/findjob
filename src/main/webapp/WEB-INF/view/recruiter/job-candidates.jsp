<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Ứng viên cho: ${job.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        .content-area { display: flex; flex-direction: column; flex: 1; }
        .main-content { flex: 1; padding: 30px; }
        .card { border-radius: 12px; }
        .table thead { background-color: #f8f9fa; }
        .candidate-row { transition: background-color 0.2s; }
        .candidate-row:hover { background-color: #f8f9fa; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="main-wrapper">
        <jsp:include page="layout/sidebar.jsp" />

        <div class="content-area">
            <div class="main-content">
                <div class="container-fluid">
                    
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="/recruiter/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Danh sách ứng viên</li>
                        </ol>
                    </nav>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h3 class="fw-bold mb-1 text-dark">Ứng viên ứng tuyển</h3>
                            <p class="text-muted mb-0">Công việc: <span class="text-primary fw-bold">${job.title}</span></p>
                        </div>
                        <a href="/recruiter/dashboard" class="btn btn-outline-secondary shadow-sm">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>
                    </div>

                    <div class="card shadow-sm border-0 mb-4 p-3 rounded-4">
                        <div class="row g-2">
                            <div class="col-md-6">
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
                                    <input type="text" id="searchInput" class="form-control border-start-0 ps-0 shadow-none" 
                                           placeholder="Tìm theo tên hoặc email ứng viên..." onkeyup="filterCandidates()">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <select id="statusFilter" class="form-select text-muted shadow-none" onchange="filterCandidates()">
                                    <option value="all">Tất cả trạng thái</option>
                                    <option value="PENDING">Đang chờ duyệt</option>
                                    <option value="APPROVED">Đã chấp nhận</option>
                                    <option value="REJECTED">Đã từ chối</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button class="btn btn-dark w-100 fw-medium" onclick="filterCandidates()">Lọc</button>
                            </div>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0 rounded-4">
                        <div class="card-body p-0">
                            <div class="table-responsive" style="min-height: 300px;">
                                <table class="table align-middle mb-0">
                                    <thead class="table-light text-secondary small text-uppercase">
                                        <tr>
                                            <th class="text-center py-3" width="5%">STT</th>
                                            <th class="ps-4 py-3" width="22%">Tên Ứng viên</th>
                                            <th class="py-3" width="22%">Email</th>
                                            <th class="py-3" width="12%">Ngày nộp</th>
                                            <th class="text-center py-3" width="12%">Điểm AI</th>
                                            <th class="text-center py-3" width="12%">Mức phù hợp</th>
                                            <th class="text-center py-3" width="10%">Trạng thái</th>
                                            <th class="text-center py-3" width="10%">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody id="candidate-tbody">
                                        <c:forEach var="app" items="${applications}" varStatus="status">
                                            <c:set var="score" value="${cvScoreMap[app.id]}" />
                                            
                                            <tr class="candidate-row"
                                                data-name="${fn:toLowerCase(not empty app.user.fullName ? app.user.fullName : '')}"
                                                data-email="${fn:toLowerCase(not empty app.user.email ? app.user.email : '')}"
                                                data-status="${empty app.status ? 'PENDING' : app.status}">
                                                
                                                <td class="text-center align-middle stt-cell">${status.index + 1}</td>
                                                
                                                <td class="ps-4 fw-bold text-dark align-middle">
                                                    <div class="d-flex align-items-center">
                                                        <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center me-3 fw-bold" style="width: 40px; height: 40px;">
                                                            ${fn:substring(not empty app.user.fullName ? app.user.fullName : 'U', 0, 1)}
                                                        </div>
                                                        ${not empty app.user.fullName ? app.user.fullName : 'Chưa cập nhật'}
                                                    </div>
                                                </td>
                                                
                                                <td class="align-middle">
                                                    <a href="mailto:${app.user.email}" class="text-decoration-none text-muted small">
                                                        <i class="bi bi-envelope me-1"></i> ${not empty app.user.email ? app.user.email : 'Chưa cập nhật'}
                                                    </a>
                                                </td>
                                                
                                                <td class="text-muted small align-middle">
                                                    <i class="bi bi-calendar-event me-1"></i> ${fn:substring(app.createdAt, 0, 10)}
                                                </td>

                                                <td class="text-center align-middle">
                                                    <c:choose>
                                                        <c:when test="${not empty score}">
                                                            <span class="fw-bold text-primary">
                                                                <fmt:formatNumber value="${score.totalScore}" minFractionDigits="0" maxFractionDigits="2"/>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning-subtle text-warning border border-warning border-opacity-25 px-3 py-2 rounded-pill">
                                                                Đang chấm
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td class="text-center align-middle">
                                                    <c:choose>
                                                        <c:when test="${not empty score and score.matchLevel == 'VERY_FIT'}">
                                                            <span class="badge bg-success-subtle text-success border border-success border-opacity-25 px-3 py-2 rounded-pill">Rất phù hợp</span>
                                                        </c:when>
                                                        <c:when test="${not empty score and score.matchLevel == 'FIT'}">
                                                            <span class="badge bg-primary-subtle text-primary border border-primary border-opacity-25 px-3 py-2 rounded-pill">Phù hợp</span>
                                                        </c:when>
                                                        <c:when test="${not empty score and score.matchLevel == 'PARTIAL'}">
                                                            <span class="badge bg-info-subtle text-info border border-info border-opacity-25 px-3 py-2 rounded-pill">Phù hợp một phần</span>
                                                        </c:when>
                                                        <c:when test="${not empty score and score.matchLevel == 'LOW'}">
                                                            <span class="badge bg-danger-subtle text-danger border border-danger border-opacity-25 px-3 py-2 rounded-pill">Ít phù hợp</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted small">Chưa có điểm</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <td class="text-center align-middle">
                                                    <c:choose>
                                                        <c:when test="${app.status == 'APPROVED'}">
                                                            <span class="badge bg-success-subtle text-success border border-success border-opacity-25 px-3 py-2 rounded-pill w-100">
                                                                <i class="bi bi-check-circle-fill me-1"></i> Chấp nhận
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${app.status == 'REJECTED'}">
                                                            <span class="badge bg-danger-subtle text-danger border border-danger border-opacity-25 px-3 py-2 rounded-pill w-100">
                                                                <i class="bi bi-x-circle-fill me-1"></i> Từ chối
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary bg-opacity-10 text-secondary border px-3 py-2 rounded-pill w-100">
                                                                <i class="bi bi-hourglass-split me-1"></i> Đang chờ
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <td class="text-center align-middle">
                                                    <div class="btn-group shadow-sm">
                                                        <c:if test="${empty app.status || app.status == 'PENDING'}">
                                                            <a href="/recruiter/application/${app.id}/status/approve" 
                                                               class="btn btn-sm btn-outline-success" title="Chấp nhận">
                                                                <i class="bi bi-check-lg"></i>
                                                            </a>
                                                            <a href="/recruiter/application/${app.id}/status/reject" 
                                                               class="btn btn-sm btn-outline-danger" title="Từ chối">
                                                                <i class="bi bi-x-lg"></i>
                                                            </a>
                                                        </c:if>
                                                        <c:choose>
                                                            <c:when test="${not empty app.cvFileName}">
                                                                <a href="/uploads/cv_files/${app.cvFileName}" target="_blank"
                                                                    class="btn btn-sm btn-outline-primary" title="Xem CV">
                                                                    <i class="bi bi-file-earmark-pdf"></i>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${not empty app.user.candidateProfile and not empty app.user.candidateProfile.cvUrl}">
                                                                <a href="/uploads/cv_files/${app.user.candidateProfile.cvUrl}" target="_blank"
                                                                    class="btn btn-sm btn-outline-primary" title="Xem CV">
                                                                    <i class="bi bi-file-earmark-pdf"></i>
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-sm btn-outline-secondary" title="Ứng viên chưa có CV" disabled>
                                                                    <i class="bi bi-file-earmark-x"></i>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <c:choose>
                                                            <c:when test="${not empty score}">
                                                                <a href="/recruiter/application/${app.id}/cv-score"
                                                                    class="btn btn-sm btn-outline-info" title="Chi tiết điểm AI">
                                                                    <i class="bi bi-clipboard2-data"></i>
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-sm btn-outline-secondary" title="Đang chấm điểm AI" disabled>
                                                                    <i class="bi bi-clipboard2-pulse"></i>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <c:if test="${empty applications}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-inbox fs-1 d-block mb-3 text-muted opacity-50"></i>
                                        <h5 class="text-muted fw-bold">Chưa có ứng viên nào</h5>
                                        <p class="small text-muted">Hồ sơ ứng tuyển sẽ xuất hiện tại đây.</p>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="card-footer bg-white border-top py-3 d-flex justify-content-between align-items-center" id="pagination-container" style="display: none !important;">
                                <span class="text-muted small" id="page-info">Hiển thị 0 - 0 trong 0 ứng viên</span>
                                <ul class="pagination pagination-sm mb-0 shadow-sm" id="pagination-controls"></ul>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
            
            <jsp:include page="layout/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const rowsPerPage = 5; 
        let currentPage = 1;
        let allRows = [];
        let filteredRows = [];

        document.addEventListener("DOMContentLoaded", function() {
            const tbody = document.getElementById("candidate-tbody");
            if (!tbody) return;

            const rows = tbody.querySelectorAll("tr.candidate-row");
            rows.forEach(row => {
                allRows.push(row);
                row.remove(); 
            });
            
            filteredRows = [...allRows]; 

            if (allRows.length > 0) {
                renderTable();
            }
        });

        // Hàm lọc real-time
        function filterCandidates() {
            const keyword = document.getElementById("searchInput").value.toLowerCase();
            const statusFilter = document.getElementById("statusFilter").value;

            filteredRows = allRows.filter(row => {
                const rowName = row.getAttribute("data-name");
                const rowEmail = row.getAttribute("data-email");
                const rowStatus = row.getAttribute("data-status");

                const matchesKeyword = rowName.includes(keyword) || rowEmail.includes(keyword);
                const matchesStatus = (statusFilter === "all") || (statusFilter === rowStatus);

                return matchesKeyword && matchesStatus;
            });

            currentPage = 1; 
            renderTable();
        }

        // Cập nhật bảng và phân trang
        function renderTable() {
            const tbody = document.getElementById("candidate-tbody");
            tbody.innerHTML = ""; 

            if (filteredRows.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-search d-block fs-2 opacity-50 mb-2"></i>Không tìm thấy ứng viên phù hợp.</td></tr>';
                document.getElementById("pagination-container").style.setProperty('display', 'none', 'important');
                return;
            }

            const start = (currentPage - 1) * rowsPerPage;
            const end = start + rowsPerPage;
            const paginatedRows = filteredRows.slice(start, end);

            paginatedRows.forEach((row, index) => {
                row.querySelector(".stt-cell").innerText = start + index + 1;
                tbody.appendChild(row);
            });

            document.getElementById("pagination-container").style.setProperty('display', 'flex', 'important');
            renderPaginationUI();
        }

        // Tạo nút bấm trang 1, 2, 3...
        function renderPaginationUI() {
            const totalPages = Math.ceil(filteredRows.length / rowsPerPage);
            const paginationEl = document.getElementById("pagination-controls");
            const pageInfo = document.getElementById("page-info");
            
            paginationEl.innerHTML = "";
            
            const currentStart = ((currentPage - 1) * rowsPerPage) + 1;
            const currentEnd = Math.min(currentPage * rowsPerPage, filteredRows.length);
            pageInfo.innerHTML = "Hiển thị <strong>" + currentStart + " - " + currentEnd + "</strong> trong tổng <strong>" + filteredRows.length + "</strong> ứng viên";

            if (totalPages <= 1) return; 

            let prevClass = currentPage === 1 ? "disabled" : "";
            paginationEl.innerHTML += `<li class="page-item \${prevClass}"><a class="page-link" href="javascript:void(0)" onclick="goToPage(\${currentPage - 1})">&laquo;</a></li>`;
            
            for (let i = 1; i <= totalPages; i++) {
                let activeClass = currentPage === i ? "active" : "";
                paginationEl.innerHTML += `<li class="page-item \${activeClass}"><a class="page-link" href="javascript:void(0)" onclick="goToPage(\${i})">\${i}</a></li>`;
            }
            
            let nextClass = currentPage === totalPages ? "disabled" : "";
            paginationEl.innerHTML += `<li class="page-item \${nextClass}"><a class="page-link" href="javascript:void(0)" onclick="goToPage(\${currentPage + 1})">&raquo;</a></li>`;
        }

        function goToPage(page) {
            const totalPages = Math.ceil(filteredRows.length / rowsPerPage);
            if (page >= 1 && page <= totalPages) {
                currentPage = page;
                renderTable();
            }
        }
    </script>
</body>
</html>
