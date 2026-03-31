<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng điều khiển - Nhà tuyển dụng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        .content-area { display: flex; flex-direction: column; flex: 1; }
        .main-content { flex: 1; padding: 30px; }
        .job-title-link { text-decoration: none; color: #0d6efd; transition: 0.2s; }
        .job-title-link:hover { text-decoration: underline; color: #0a58ca; }
        .table thead { background-color: #f8f9fa; }
        .card { border-radius: 12px; }
        .hover-lift { transition: transform 0.3s ease, box-shadow 0.3s ease; cursor: pointer; }
        .hover-lift:hover { transform: translateY(-5px); box-shadow: 0 .5rem 1rem rgba(0,0,0,.15)!important; }
        
        /* Hiệu ứng làm nổi bật thẻ đang được chọn để sắp xếp */
        .card-active-sort { outline: 3px solid #343a40; outline-offset: 2px; }

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
                            <h3 class="fw-bold mb-1">Bảng điều khiển</h3>
                            <p class="text-muted small mb-0">Quản lý các tin tuyển dụng và theo dõi ứng viên của bạn.</p>
                        </div>
                        <a href="/recruiter/post-job" class="btn btn-primary fw-bold shadow-sm">
                            <i class="bi bi-plus-lg me-2"></i> Đăng tin mới
                        </a>
                    </div>

                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success alert-dismissible fade show fw-bold border-0 shadow-sm" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${successMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <p class="text-muted small mb-2"><i class="bi bi-info-circle"></i> Nhấp vào các thẻ bên dưới để sắp xếp bảng công việc</p>

                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="card bg-primary text-white border-0 shadow-sm rounded-4 h-100 p-3 hover-lift" id="sort-title" onclick="sortJobs('title')">
                                <div class="card-body d-flex align-items-center">
                                    <div class="bg-white bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 65px; height: 65px;">
                                        <i class="bi bi-briefcase-fill fs-2"></i>
                                    </div>
                                    <div>
                                        <p class="mb-0 text-white-50 fw-semibold text-uppercase" style="font-size: 0.8rem; letter-spacing: 0.5px;">Tổng chiến dịch</p>
                                        <h2 class="mb-0 fw-bold display-6">${not empty totalJobs ? totalJobs : 0}</h2>
                                    </div>
                                    <i class="bi bi-sort-alpha-down fs-4 ms-auto opacity-50"></i>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="card bg-success text-white border-0 shadow-sm rounded-4 h-100 p-3 hover-lift" id="sort-total" onclick="sortJobs('total')">
                                <div class="card-body d-flex align-items-center">
                                    <div class="bg-white bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 65px; height: 65px;">
                                        <i class="bi bi-people-fill fs-2"></i>
                                    </div>
                                    <div>
                                        <p class="mb-0 text-white-50 fw-semibold text-uppercase" style="font-size: 0.8rem; letter-spacing: 0.5px;">Tổng hồ sơ nhận</p>
                                        <h2 class="mb-0 fw-bold display-6">${not empty totalCandidates ? totalCandidates : 0}</h2>
                                    </div>
                                    <i class="bi bi-sort-numeric-down-alt fs-4 ms-auto opacity-50"></i>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card bg-warning text-dark border-0 shadow-sm rounded-4 h-100 p-3 hover-lift" id="sort-pending" onclick="sortJobs('pending')">
                                <div class="card-body d-flex align-items-center">
                                    <div class="bg-dark bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 65px; height: 65px;">
                                        <i class="bi bi-hourglass-split fs-2"></i>
                                    </div>
                                    <div>
                                        <p class="mb-0 text-dark opacity-75 fw-semibold text-uppercase" style="font-size: 0.8rem; letter-spacing: 0.5px;">Chờ xử lý</p>
                                        <div class="d-flex align-items-center">
                                            <h2 class="mb-0 fw-bold display-6">${not empty pendingCandidates ? pendingCandidates : 0}</h2>
                                        </div>
                                    </div>
                                    <i class="bi bi-sort-numeric-down-alt fs-4 ms-auto opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white border-bottom py-3">
                            <h5 class="mb-0 fw-bold text-dark"><i class="bi bi-list-task me-2 text-primary"></i>Danh sách công việc</h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr class="text-secondary small text-uppercase">
                                            <th class="text-center py-3" width="5%">STT</th>
                                            <th class="py-3" width="35%">Chi tiết công việc</th>
                                            <th class="text-center py-3" width="15%">Ứng tuyển</th>
                                            <th class="py-3" width="15%">Ngày đăng</th>
                                            <th class="text-center py-3" width="30%">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody id="job-tbody">
                                        <c:forEach var="job" items="${jobs}" varStatus="status">
                                            <c:set var="pendingCount" value="0"/>
                                            <c:forEach var="app" items="${job.applications}">
                                                <c:if test="${app.status == 'PENDING' || empty app.status}">
                                                    <c:set var="pendingCount" value="${pendingCount + 1}"/>
                                                </c:if>
                                            </c:forEach>
                                            
                                            <tr class="job-row" 
                                                data-title="${job.title}" 
                                                data-total="${not empty job.applications ? job.applications.size() : 0}" 
                                                data-pending="${pendingCount}">
                                                
                                                <td class="text-center align-middle stt-cell">${status.index + 1}</td>
                                                <td class="align-middle">
                                                    <a href="/job/${job.id}" target="_blank" class="job-title-link fw-bold">${job.title}</a>
                                                    <div class="small text-muted"><i class="bi bi-geo-alt me-1"></i>${job.location}</div>
                                                </td>
                                                <td class="text-center align-middle">
                                                    <span class="badge bg-info-subtle text-info-emphasis rounded-pill px-3 py-1">
                                                        ${not empty job.applications ? job.applications.size() : 0} hồ sơ
                                                    </span>
                                                    <c:if test="${pendingCount > 0}">
                                                        <div class="small text-danger mt-1 fw-medium"><i class="bi bi-exclamation-circle"></i> ${pendingCount} chờ duyệt</div>
                                                    </c:if>
                                                </td>
                                                <td class="align-middle text-muted small">
                                                    <i class="bi bi-calendar3 me-1"></i> ${job.formattedCreatedAt} 
                                                </td>
                                                <td class="text-center align-middle">
                                                    <div class="btn-group shadow-sm">
                                                        <a href="/recruiter/job/${job.id}/candidates" class="btn btn-sm btn-outline-primary" title="Xem ứng viên">
                                                            <i class="bi bi-people-fill"></i> Ứng viên
                                                        </a>
                                                        <a href="/recruiter/edit-job/${job.id}" class="btn btn-sm btn-outline-warning" title="Sửa công việc">
                                                            <i class="bi bi-pencil-square"></i> Sửa
                                                        </a>
                                                        <button class="btn btn-sm btn-outline-danger" onclick="confirmDelete('${job.id}', '${job.title}')" title="Xóa">
                                                            <i class="bi bi-trash"></i> Xóa
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                
                                <c:if test="${empty jobs}">
                                    <div class="text-center py-5" id="empty-state">
                                        <i class="bi bi-clipboard-x fs-1 text-muted d-block mb-3 opacity-50"></i>
                                        <h5 class="text-muted fw-bold">Bạn chưa có bài đăng nào</h5>
                                        <p class="small text-muted">Bắt đầu thu hút nhân tài bằng cách đăng tin tuyển dụng đầu tiên.</p>
                                        <a href="/recruiter/post-job" class="btn btn-primary btn-sm mt-2 rounded-pill px-4">Đăng tin ngay</a>                                                    
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="card-footer bg-white border-top py-3 d-flex justify-content-between align-items-center" id="pagination-container" style="display: none !important;">
                                <span class="text-muted small" id="page-info">Hiển thị 0 - 0 trong 0 công việc</span>
                                <ul class="pagination pagination-sm mb-0 shadow-sm" id="pagination-controls">
                                    </ul>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
            
            <jsp:include page="layout/footer.jsp" />

            <!-- Popup xóa -->
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
        // Cấu hình phân trang
        const rowsPerPage = 5;
        let currentPage = 1;
        let allRows = [];
        let currentSort = '';
        let sortDesc = false;

        document.addEventListener("DOMContentLoaded", function() {
            const tbody = document.getElementById("job-tbody");
            if(!tbody) return;

            // Lấy tất cả các dòng TR lưu vào mảng JS
            const rows = tbody.querySelectorAll("tr.job-row");
            rows.forEach(row => allRows.push(row));
            
            if (allRows.length > 0) {
                document.getElementById("pagination-container").style.setProperty('display', 'flex', 'important');
                renderTable(); // Hiển thị trang 1 mặc định
            }
        });

        // Hàm sắp xếp khi click vào thẻ KPI
        function sortJobs(type) {
            if (allRows.length === 0) return;

            // Đổi màu thẻ đang được chọn
            document.querySelectorAll('.hover-lift').forEach(card => card.classList.remove('card-active-sort'));
            document.getElementById('sort-' + type).classList.add('card-active-sort');

            // Toggle thứ tự nếu click liên tiếp vào cùng 1 thẻ
            if (currentSort === type) {
                sortDesc = !sortDesc; 
            } else {
                currentSort = type;
                // Nếu là tiêu đề thì ưu tiên ABC (Tăng dần), nếu là số thì ưu tiên giảm dần (nhiều nhất lên đầu)
                sortDesc = (type !== 'title'); 
            }

            // Logic sắp xếp mảng
            allRows.sort((a, b) => {
                let valA = a.getAttribute("data-" + type);
                let valB = b.getAttribute("data-" + type);
                
                if (type === 'title') {
                    // Sắp xếp theo chữ cái
                    valA = valA.toLowerCase();
                    valB = valB.toLowerCase();
                    if (valA < valB) return sortDesc ? 1 : -1;
                    if (valA > valB) return sortDesc ? -1 : 1;
                    return 0;
                } else {
                    // Sắp xếp theo số lượng
                    valA = parseInt(valA) || 0;
                    valB = parseInt(valB) || 0;
                    if (valA !== valB) {
                        return sortDesc ? valB - valA : valA - valB;
                    } else {
                        // NẾU SỐ LƯỢNG BẰNG NHAU -> Lấy tên ra sắp xếp ABC
                        let titleA = a.getAttribute("data-title").toLowerCase();
                        let titleB = b.getAttribute("data-title").toLowerCase();
                        if (titleA < titleB) return -1;
                        if (titleA > titleB) return 1;
                        return 0;
                    }
                }
            });

            currentPage = 1; // Sau khi sắp xếp, quay về trang 1
            renderTable();
        }

        // Hàm hiển thị dữ liệu ra bảng theo trang
        function renderTable() {
            const tbody = document.getElementById("job-tbody");
            tbody.innerHTML = ""; // Xóa dữ liệu cũ
            
            const start = (currentPage - 1) * rowsPerPage;
            const end = start + rowsPerPage;
            const paginatedRows = allRows.slice(start, end);
            
            paginatedRows.forEach((row, index) => {
                // Cập nhật lại số thứ tự (STT) cho chuẩn
                row.querySelector(".stt-cell").innerText = start + index + 1;
                tbody.appendChild(row);
            });
            
            renderPaginationUI();
        }

        // Hàm tạo các nút phân trang
        function renderPaginationUI() {
            const totalPages = Math.ceil(allRows.length / rowsPerPage);
            const paginationEl = document.getElementById("pagination-controls");
            const pageInfo = document.getElementById("page-info");
            
            paginationEl.innerHTML = "";
            
            // Cập nhật dòng chữ "Hiển thị x - y trong tổng số z..."
            const currentStart = ((currentPage - 1) * rowsPerPage) + 1;
            const currentEnd = Math.min(currentPage * rowsPerPage, allRows.length);
            pageInfo.innerHTML = "Hiển thị <strong>" + currentStart + " - " + currentEnd + "</strong> trong tổng <strong>" + allRows.length + "</strong> công việc";

            if (totalPages <= 1) return; // Không cần hiện nút nếu chỉ có 1 trang

            // Nút "Trang trước"
            let prevClass = currentPage === 1 ? "disabled" : "";
            paginationEl.innerHTML += `<li class="page-item \${prevClass}"><a class="page-link" href="javascript:void(0)" onclick="goToPage(\${currentPage - 1})">&laquo;</a></li>`;
            
            // Các nút số trang
            for (let i = 1; i <= totalPages; i++) {
                let activeClass = currentPage === i ? "active" : "";
                paginationEl.innerHTML += `<li class="page-item \${activeClass}"><a class="page-link" href="javascript:void(0)" onclick="goToPage(\${i})">\${i}</a></li>`;
            }
            
            // Nút "Trang sau"
            let nextClass = currentPage === totalPages ? "disabled" : "";
            paginationEl.innerHTML += `<li class="page-item \${nextClass}"><a class="page-link" href="javascript:void(0)" onclick="goToPage(\${currentPage + 1})">&raquo;</a></li>`;
        }

        function goToPage(page) {
            const totalPages = Math.ceil(allRows.length / rowsPerPage);
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