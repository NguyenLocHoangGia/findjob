<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Quản lý Công việc - Nhà tuyển dụng</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <style>
                body {
                    display: flex;
                    flex-direction: column;
                    min-height: 100vh;
                    margin: 0;
                    background-color: #f4f6f9;
                }

                .main-wrapper {
                    display: flex;
                    flex: 1;
                }

                .content-area {
                    display: flex;
                    flex-direction: column;
                    flex: 1;
                }

                .main-content {
                    flex: 1;
                    padding: 30px;
                }

                .card {
                    border-radius: 12px;
                }
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
                                    <p class="text-muted small mb-0">Điều chỉnh trạng thái, sửa đổi hoặc xóa tin tuyển
                                        dụng.</p>
                                </div>
                                <a href="/recruiter/job/add" class="btn btn-primary fw-bold shadow-sm">
                                    <i class="bi bi-plus-lg me-2"></i> Đăng tin mới
                                </a>
                            </div>

                            <div class="card shadow-sm border-0 mb-4 p-3">
                                <div class="row g-2">
                                    <div class="col-md-6">
                                        <div class="input-group">
                                            <span class="input-group-text bg-white border-end-0"><i
                                                    class="bi bi-search text-muted"></i></span>
                                            <input type="text" class="form-control border-start-0 ps-0"
                                                placeholder="Tìm kiếm theo tiêu đề công việc...">
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select text-muted">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="active">Đang mở tuyển</option>
                                            <option value="closed">Đã đóng</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <button class="btn btn-dark w-100">Lọc kết quả</button>
                                    </div>
                                </div>
                            </div>

                            <div class="card shadow-sm border-0">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-light text-secondary small text-uppercase">
                                                <tr>
                                                    <th class="ps-4 py-3" width="35%">Công việc</th>
                                                    <th class="text-center py-3" width="15%">Trạng thái</th>
                                                    <th class="text-center py-3" width="15%">Ứng viên</th>
                                                    <th class="py-3" width="15%">Ngày tạo</th>
                                                    <th class="text-center py-3" width="20%">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="job" items="${jobs}">
                                                    <tr>
                                                        <td class="ps-4 align-middle">
                                                            <a href="/job/${job.id}" target="_blank"
                                                                class="text-decoration-none fw-bold text-primary d-block">${job.title}</a>
                                                            <span class="small text-muted"><i
                                                                    class="bi bi-geo-alt me-1"></i>${job.location}</span>
                                                        </td>
                                                        <td class="text-center align-middle">
                                                            <c:choose>
                                                                <c:when test="${job.isActive}">
                                                                    <span
                                                                        class="badge bg-success-subtle text-success border border-success border-opacity-25 px-3 py-2 rounded-pill"><i
                                                                            class="bi bi-check-circle me-1"></i> Đang
                                                                        mở</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="badge bg-danger-subtle text-danger border border-danger border-opacity-25 px-3 py-2 rounded-pill"><i
                                                                            class="bi bi-lock-fill me-1"></i> Đã
                                                                        đóng</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center align-middle">
                                                            <a href="/recruiter/job/${job.id}/candidates"
                                                                class="text-decoration-none fw-bold fs-5 text-dark">
                                                                ${not empty job.applications ? job.applications.size() :
                                                                0}
                                                            </a>
                                                            <div class="small text-muted">Hồ sơ</div>
                                                        </td>
                                                        <td class="align-middle text-muted small">
                                                            ${job.formattedCreatedAt}
                                                        </td>
                                                        <td class="text-center align-middle">
                                                            <div class="dropdown">
                                                                <button class="btn btn-sm btn-light border"
                                                                    type="button" data-bs-toggle="dropdown">
                                                                    Tùy chọn <i class="bi bi-chevron-down ms-1"
                                                                        style="font-size: 0.7rem;"></i>
                                                                </button>
                                                                <ul
                                                                    class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                                                    <li><a class="dropdown-item text-primary"
                                                                            href="/recruiter/edit-job/${job.id}"><i
                                                                                class="bi bi-pencil-square me-2"></i>Chỉnh
                                                                            sửa</a></li>
                                                                    <li><a class="dropdown-item text-warning"
                                                                            href="/recruiter/toggle-job-status/${job.id}"><i
                                                                                class="bi bi-power me-2"></i>Bật/Tắt
                                                                            trạng thái</a></li>
                                                                    <li>
                                                                        <hr class="dropdown-divider">
                                                                    </li>
                                                                    <li><a class="dropdown-item text-danger"
                                                                            href="javascript:void(0)"
                                                                            onclick="confirmDelete('${job.id}', '${job.title}')"><i
                                                                                class="bi bi-trash me-2"></i>Xóa vĩnh
                                                                            viễn</a></li>
                                                                </ul>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty jobs}">
                                                    <tr>
                                                        <td colspan="5" class="text-center py-5 text-muted">Bạn chưa tạo
                                                            công việc nào.</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
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
                function confirmDelete(id, title) {
                    if (confirm('Xóa công việc "' + title + '"? Hành động này không thể hoàn tác.')) {
                        window.location.href = '/recruiter/delete-job/' + id;
                    }
                }
            </script>
        </body>

        </html>