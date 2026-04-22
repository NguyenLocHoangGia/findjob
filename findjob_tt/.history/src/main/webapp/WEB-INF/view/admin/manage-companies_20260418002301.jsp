<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kiểm duyệt Doanh nghiệp - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .table thead { background-color: #f8f9fa; }
        .company-row { transition: all 0.2s; }
        .company-row:hover { background-color: #f8f9fa; }
        .logo-sm { width: 45px; height: 45px; object-fit: cover; border-radius: 8px; border: 1px solid #dee2e6; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container my-5" style="padding-top: 20px;">
        
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success fw-bold alert-dismissible fade show shadow-sm">
                <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger fw-bold alert-dismissible fade show shadow-sm">
                <i class="bi bi-x-circle-fill me-2"></i>${errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-4 mt-2">
            <div>
                <h2 class="fw-bold mb-1 text-dark">
                    <i class="bi bi-building-check text-primary me-2"></i>Kiểm duyệt Doanh nghiệp
                </h2>
                <p class="text-muted mb-0">Xác minh giấy phép kinh doanh và cấp quyền Nhà tuyển dụng.</p>
            </div>
        </div>

        <div class="card shadow-sm border-0 mb-4 p-3 rounded-4">
            <div class="row g-2">
                <div class="col-md-8">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0">
                            <i class="bi bi-search text-muted"></i>
                        </span>
                        <input type="text" id="searchInput" class="form-control border-start-0 ps-0 shadow-none" 
                               placeholder="Tìm theo tên công ty..." onkeyup="filterCompanies()">
                    </div>
                </div>
                <div class="col-md-4">
                    <select id="statusFilter" class="form-select text-muted shadow-none" onchange="filterCompanies()">
                        <option value="all">Tất cả Trạng thái</option>
                        <option value="PENDING" selected>Đang chờ duyệt</option>
                        <option value="APPROVED">Đã duyệt</option>
                        <option value="REJECTED">Bị từ chối</option>
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
                                <th class="text-center py-3" width="5%">STT</th>
                                <th class="ps-4 py-3" width="30%">Thông tin Công ty</th>
                                <th class="py-3" width="20%">Giấy phép (GPKD)</th>
                                <th class="text-center py-3" width="15%">Trạng thái</th>
                                <th class="text-center py-3" width="20%">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="company-tbody">
                            <c:forEach var="company" items="${companies}" varStatus="loop">
                                
                                <tr class="company-row" 
                                    data-name="${fn:toLowerCase(company.companyName)}"
                                    data-status="${company.status}">
                                    
                                    <td class="text-center align-middle stt-cell">
                                        ${(currentPage - 1) * 5 + loop.index + 1}
                                    </td>
                                    
                                    <td class="ps-4 align-middle">
                                        <div class="d-flex align-items-center">
                                            <img src="${not empty company.companyLogo ? '/uploads/company_logos/'.concat(company.companyLogo) : 'https://via.placeholder.com/45?text=Logo'}"
                                                 class="logo-sm me-3" alt="Logo">
                                            <div>
                                                <div class="fw-bold text-dark mb-1">${company.companyName}</div>
                                                <div class="small text-muted">
                                                    <i class="bi bi-person me-1"></i>${company.user.email}
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    
                                    <td class="align-middle">
                                        <c:choose>
                                            <c:when test="${not empty company.businessLicense}">
                                                <a href="/uploads/business_licenses/${company.businessLicense}" target="_blank"
                                                   class="btn btn-sm btn-outline-primary rounded-pill">
                                                    <i class="bi bi-file-earmark-text me-1"></i> Xem Giấy phép
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger small fst-italic">
                                                    <i class="bi bi-exclamation-circle me-1"></i>Thiếu GPKD
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td class="text-center align-middle">
                                        <c:choose>
                                            <c:when test="${company.status == 'APPROVED'}">
                                                <span class="badge bg-success-subtle text-success border border-success border-opacity-25 px-3 py-2 rounded-pill w-100">
                                                    Đã duyệt
                                                </span>
                                            </c:when>
                                            <c:when test="${company.status == 'REJECTED'}">
                                                <span class="badge bg-danger-subtle text-danger border border-danger border-opacity-25 px-3 py-2 rounded-pill w-100">
                                                    Từ chối
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning-subtle text-warning border border-warning border-opacity-25 px-3 py-2 rounded-pill w-100">
                                                    Đang chờ
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td class="text-center align-middle">
                                        <c:if test="${company.status == 'PENDING' || empty company.status}">
                                            <div class="d-flex justify-content-center gap-2">
                                                <form action="/admin/companies/${company.id}/approve" method="POST"
                                                      class="m-0 confirm-action"
                                                      data-confirm-message="Xác nhận CẤP QUYỀN Nhà tuyển dụng cho công ty này?">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit" class="btn btn-sm btn-success rounded-pill px-3 shadow-sm" title="Duyệt">
                                                        <i class="bi bi-check-lg"></i>
                                                    </button>
                                                </form>

                                                <form action="/admin/companies/${company.id}/reject" method="POST"
                                                      class="m-0 confirm-action"
                                                      data-confirm-message="Bạn từ chối hồ sơ này?">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit" class="btn btn-sm btn-danger rounded-pill px-3 shadow-sm" title="Từ chối">
                                                        <i class="bi bi-x-lg"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>

                                        <c:if test="${company.status != 'PENDING'}">
                                            <span class="text-muted small fst-italic">Đã xử lý</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty companies}">
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>
                                        Chưa có hồ sơ doanh nghiệp nào trong hệ thống.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>

                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation" class="mt-4 mb-2">
                            <ul class="pagination justify-content-center mb-0">

                                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                    <a class="page-link shadow-none" href="?page=${currentPage - 1}">
                                        <i class="bi bi-chevron-left"></i> Trước
                                    </a>
                                </li>

                                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link shadow-none" href="?page=${i}">${i + 1}</a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                    <a class="page-link shadow-none" href="?page=${currentPage + 1}">
                                        Sau <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>

                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="confirmActionModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-sm">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận thao tác</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="confirmActionMessage">Bạn có chắc chắn muốn tiếp tục?</div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" id="confirmActionBtn" class="btn btn-danger">Xác nhận</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let pendingForm = null;

        function openConfirmModal(message, form) {
            pendingForm = form;
            document.getElementById('confirmActionMessage').innerText = message;
            const modal = new bootstrap.Modal(document.getElementById('confirmActionModal'));
            modal.show();
        }

        document.getElementById('confirmActionBtn').addEventListener('click', function () {
            const modalEl = document.getElementById('confirmActionModal');
            const activeModal = bootstrap.Modal.getInstance(modalEl);
            if (activeModal) {
                activeModal.hide();
            }

            if (pendingForm) {
                const form = pendingForm;
                pendingForm = null;
                form.submit();
            }
        });

        document.querySelectorAll('.confirm-action').forEach(function (form) {
            form.addEventListener('submit', function (event) {
                event.preventDefault();
                const message = form.getAttribute('data-confirm-message') || 'Bạn có chắc chắn muốn tiếp tục?';
                openConfirmModal(message, form);
            });
        });

        document.addEventListener("DOMContentLoaded", filterCompanies);

        function updateVisibleRowNumbers() {
            const visibleRows = document.querySelectorAll(".company-row[style='display: table-row;'], .company-row:not([style])");
            let stt = 1;

            visibleRows.forEach(row => {
                if (row.style.display !== "none") {
                    const sttCell = row.querySelector(".stt-cell");
                    if (sttCell) {
                        sttCell.innerText = stt++;
                    }
                }
            });
        }

        function filterCompanies() {
            const keyword = document.getElementById("searchInput").value.toLowerCase().trim();
            const statusFilter = document.getElementById("statusFilter").value;
            const rows = document.querySelectorAll(".company-row");

            rows.forEach(row => {
                const rowName = (row.getAttribute("data-name") || "").toLowerCase();
                const rowStatus = row.getAttribute("data-status") || "PENDING";

                const matchesKeyword = rowName.includes(keyword);
                const matchesStatus = (statusFilter === "all") || (statusFilter === rowStatus);

                if (matchesKeyword && matchesStatus) {
                    row.style.display = "table-row";
                } else {
                    row.style.display = "none";
                }
            });

            updateVisibleRowNumbers();
        }
    </script>
</body>
</html>