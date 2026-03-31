<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý Công việc - Nhà tuyển dụng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        .content-area { display: flex; flex-direction: column; flex: 1; }
        .main-content { flex: 1; padding: 30px; }
        .card { border-radius: 12px; }
        .table thead { background-color: #f8f9fa; }

        body.modal-open {
            padding-right: 0 !important;
            overflow-y: scroll !important;
        }

        /* Ép Modal luôn nằm chính giữa màn hình tuyệt đối */
        .modal-dialog-centered {
            display: flex;
            align-items: center;
            min-height: calc(100vh - 1rem);
            margin: auto;
        }

        /* Ép Bootstrap không được đẩy màn hình sang trái gây ra khoảng trắng */
        body { padding-right: 0 !important; overflow-y: scroll !important; }
        .modal { padding-right: 0 !important; }
    </style>
</head>

<body>
    <jsp:include page="layout/header.jsp" />

    <div class="main-wrapper">
        <jsp:include page="layout/sidebar.jsp" />

        <div class="content-area">
            <div class="main-content">
                <div class="container-fluid">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h3 class="fw-bold mb-1">Quản lý Công việc</h3>
                            <p class="text-muted small mb-0">Điều chỉnh trạng thái, sửa đổi hoặc xóa tin tuyển dụng.</p>
                        </div>
                        <a href="/recruiter/job/add" class="btn btn-primary fw-bold shadow-sm">
                            <i class="bi bi-plus-lg me-2"></i> Đăng tin mới
                        </a>
                    </div>

                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success alert-dismissible fade show fw-bold border-0 shadow-sm" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${successMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger alert-dismissible fade show fw-bold border-0 shadow-sm" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="card shadow-sm border-0 mb-4 p-3">
                        <div class="row g-2">
                            <div class="col-md-6">
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
                                    <input type="text" id="searchInput" class="form-control border-start-0 ps-0" 
                                           placeholder="Tìm kiếm theo tiêu đề công việc..." onkeyup="filterJobs()">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select id="statusFilter" class="form-select text-muted" onchange="filterJobs()">
                                    <option value="all">Tất cả trạng thái</option>
                                    <option value="active">Đang mở tuyển</option>
                                    <option value="closed">Đã đóng</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-dark w-100" onclick="filterJobs()">Lọc kết quả</button>
                            </div>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0">
                        <div class="card-body p-0">
                            <div class="table-responsive" style="min-height: 280px; overflow-x: visible;">
                                <table class="table table-hover align-middle mb-0" id="jobsTable">
                                    <thead class="table-light text-secondary small text-uppercase">
                                        <tr>
                                            <th class="text-center py-3" width="5%">STT</th>
                                            <th class="ps-4 py-3" width="30%">Công việc</th>
                                            <th class="text-center py-3" width="15%">Trạng thái</th>
                                            <th class="text-center py-3" width="15%">Ứng viên</th>
                                            <th class="py-3" width="15%">Ngày tạo</th>
                                            <th class="text-center py-3" width="20%">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody id="job-tbody">
                                        <c:forEach var="job" items="${jobs}" varStatus="status">
                                            <tr class="job-row" 
                                                data-title="${fn:toLowerCase(job.title)}" 
                                                data-status="${job.isActive ? 'active' : 'closed'}">
                                                
                                                <td class="text-center align-middle stt-cell">${status.index + 1}</td>
                                                <td class="ps-4 align-middle">
                                                    <a href="/job/${job.id}" target="_blank" class="text-decoration-none fw-bold text-primary d-block">${job.title}</a>
                                                    <span class="small text-muted"><i class="bi bi-geo-alt me-1"></i>${job.location}</span>
                                                </td>
                                                <td class="text-center align-middle">
                                                    <c:choose>
                                                        <c:when test="${job.isActive}">
                                                            <span class="badge bg-success-subtle text-success border border-success border-opacity-25 px-3 py-2 rounded-pill">
                                                                <i class="bi bi-check-circle me-1"></i> Đang mở
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger-subtle text-danger border border-danger border-opacity-25 px-3 py-2 rounded-pill">
                                                                <i class="bi bi-lock-fill me-1"></i> Đã đóng
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center align-middle">
                                                    <a href="/recruiter/job/${job.id}/candidates" class="text-decoration-none fw-bold fs-5 text-dark">
                                                        ${not empty job.applications ? job.applications.size() : 0}
                                                    </a>
                                                    <div class="small text-muted">Hồ sơ</div>
                                                </td>
                                                <td class="align-middle text-muted small">
                                                    ${job.formattedCreatedAt}
                                                </td>
                                                <td class="text-center align-middle">
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-light border" type="button" data-bs-toggle="dropdown">
                                                            Tùy chọn <i class="bi bi-chevron-down ms-1" style="font-size: 0.7rem;"></i>
                                                        </button>
                                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                                            <li>
                                                                <a class="dropdown-item text-primary" href="/recruiter/edit-job/${job.id}">
                                                                    <i class="bi bi-pencil-square me-2"></i>Chỉnh sửa
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a class="dropdown-item text-warning" href="/recruiter/toggle-job-status/${job.id}">
                                                                    <i class="bi bi-power me-2"></i>${job.isActive ? 'Tắt tin (Đóng)' : 'Bật tin (Mở)'}
                                                                </a>
                                                            </li>
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li>
                                                                <a class="dropdown-item text-danger" href="javascript:void(0)" onclick="confirmDelete('${job.id}', '${job.title}')">
                                                                    <i class="bi bi-trash me-2"></i>Xóa vĩnh viễn
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                
                                <c:if test="${empty jobs}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-clipboard-x fs-1 text-muted d-block mb-3 opacity-50"></i>
                                        <h5 class="text-muted fw-bold">Bạn chưa có bài đăng nào</h5>
                                        <p class="small text-muted">Bắt đầu thu hút nhân tài bằng cách đăng tin tuyển dụng đầu tiên.</p>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="card-footer bg-white border-top py-3 d-flex justify-content-between align-items-center" id="pagination-container" style="display: none !important;">
                                <span class="text-muted small" id="page-info">Hiển thị 0 - 0 trong 0 kết quả</span>
                                <ul class="pagination pagination-sm mb-0 shadow-sm" id="pagination-controls">
                                    </ul>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
            <jsp:include page="layout/footer.jsp" />

            </div> </div> <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 12px; overflow: hidden;">
                <div class="modal-header border-bottom-0 pb-0 pt-4 px-4">
                    <h5 class="modal-title fw-bold text-danger d-flex align-items-center" id="deleteModalLabel">
                        <i class="bi bi-exclamation-triangle-fill fs-3 me-2"></i> Cảnh báo xóa
                    </h5>
                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body px-4 py-4">
                    <p class="text-muted mb-1 fs-6">Bạn có chắc chắn muốn xóa công việc này?</p>
                    <p class="fw-bold text-dark fs-5 mb-4" id="deleteJobTitle"></p>
                    
                    <div class="alert alert-danger bg-danger-subtle border-0 mb-0">
                        <i class="bi bi-info-circle-fill me-2"></i>Toàn bộ dữ liệu và hồ sơ ứng viên của công việc này sẽ bị xóa và <b>không thể khôi phục</b>.
                    </div>
                </div>
                <div class="modal-footer border-top-0 pb-4 px-4">
                    <button type="button" class="btn btn-light fw-medium px-4 border" data-bs-dismiss="modal">Hủy bỏ</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger fw-bold px-4 shadow-sm">
                        Xóa vĩnh viễn
                    </a>
                </div>
            </div>
        </div>
    </div>
        </div>
    </div>
    
 

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const rowsPerPage = 5; // Số công việc hiển thị trên 1 trang
        let currentPage = 1;
        let allRows = [];
        let filteredRows = [];

        document.addEventListener("DOMContentLoaded", function() {
            const tbody = document.getElementById("job-tbody");
            if (!tbody) return;

            // 1. Thu thập toàn bộ các thẻ TR và xóa chúng khỏi HTML gốc
            const rows = tbody.querySelectorAll("tr.job-row");
            rows.forEach(row => {
                allRows.push(row);
                row.remove(); // JS sẽ tự thêm lại vào theo trang
            });
            
            filteredRows = [...allRows]; // Mặc định hiển thị tất cả

            if (allRows.length > 0) {
                renderTable();
            }
        });

        // Hàm 1: Lọc dữ liệu khi gõ hoặc chọn dropdown
        function filterJobs() {
            const keyword = document.getElementById("searchInput").value.toLowerCase();
            const statusFilter = document.getElementById("statusFilter").value;

            // Lọc ra danh sách thỏa mãn điều kiện
            filteredRows = allRows.filter(row => {
                const rowTitle = row.getAttribute("data-title");
                const rowStatus = row.getAttribute("data-status");

                const matchesKeyword = rowTitle.includes(keyword);
                const matchesStatus = (statusFilter === "all") || (statusFilter === rowStatus);

                return matchesKeyword && matchesStatus;
            });

            currentPage = 1; // Nhập tìm kiếm mới thì reset về trang 1
            renderTable();
        }

        // Hàm 2: Hiển thị bảng theo trang
        function renderTable() {
            const tbody = document.getElementById("job-tbody");
            tbody.innerHTML = ""; // Xóa dữ liệu cũ trên bảng

            // Nếu lọc không ra kết quả nào
            if (filteredRows.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-search d-block fs-2 opacity-50 mb-2"></i>Không tìm thấy công việc phù hợp với bộ lọc.</td></tr>';
                document.getElementById("pagination-container").style.setProperty('display', 'none', 'important');
                return;
            }

            // Tính toán đoạn cắt của mảng dữ liệu
            const start = (currentPage - 1) * rowsPerPage;
            const end = start + rowsPerPage;
            const paginatedRows = filteredRows.slice(start, end);

            // Nạp dữ liệu của trang hiện tại vào bảng
            paginatedRows.forEach((row, index) => {
                // Cập nhật lại số thứ tự (STT) cho đúng
                row.querySelector(".stt-cell").innerText = start + index + 1;
                tbody.appendChild(row);
            });

            document.getElementById("pagination-container").style.setProperty('display', 'flex', 'important');
            renderPaginationUI();
        }

        // Hàm 3: Vẽ các nút bấm 1, 2, 3...
        function renderPaginationUI() {
            const totalPages = Math.ceil(filteredRows.length / rowsPerPage);
            const paginationEl = document.getElementById("pagination-controls");
            const pageInfo = document.getElementById("page-info");
            
            paginationEl.innerHTML = "";
            
            // Cập nhật dòng chữ "Hiển thị x - y..."
            const currentStart = ((currentPage - 1) * rowsPerPage) + 1;
            const currentEnd = Math.min(currentPage * rowsPerPage, filteredRows.length);
            pageInfo.innerHTML = "Hiển thị <strong>" + currentStart + " - " + currentEnd + "</strong> trong tổng <strong>" + filteredRows.length + "</strong> kết quả";

            if (totalPages <= 1) return; // Nếu chỉ có 1 trang thì không cần hiện nút

            // Nút Trang trước
            let prevClass = currentPage === 1 ? "disabled" : "";
            paginationEl.innerHTML += `<li class="page-item \${prevClass}"><a class="page-link" href="javascript:void(0)" onclick="goToPage(\${currentPage - 1})">&laquo;</a></li>`;
            
            // Các nút số
            for (let i = 1; i <= totalPages; i++) {
                let activeClass = currentPage === i ? "active" : "";
                paginationEl.innerHTML += `<li class="page-item \${activeClass}"><a class="page-link" href="javascript:void(0)" onclick="goToPage(\${i})">\${i}</a></li>`;
            }
            
            // Nút Trang sau
            let nextClass = currentPage === totalPages ? "disabled" : "";
            paginationEl.innerHTML += `<li class="page-item \${nextClass}"><a class="page-link" href="javascript:void(0)" onclick="goToPage(\${currentPage + 1})">&raquo;</a></li>`;
        }

        // Chuyển trang
        function goToPage(page) {
            const totalPages = Math.ceil(filteredRows.length / rowsPerPage);
            if (page >= 1 && page <= totalPages) {
                currentPage = page;
                renderTable();
            }
        }

        function confirmDelete(id, title) {
            // 1. Chèn tên công việc vào trong Popup để người dùng nhìn rõ họ đang xóa cái gì
            document.getElementById('deleteJobTitle').innerText = title;
            
            // 2. Gắn link API xóa vào nút "Xóa vĩnh viễn" trong Popup
            document.getElementById('confirmDeleteBtn').href = '/recruiter/delete-job/' + id;
            
            // 3. Kích hoạt và hiển thị Popup lên màn hình
            const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>