<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Quản lý Danh mục - Admin</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <style>
                body {
                    background-color: #f4f7fa;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }
            </style>
        </head>

        <body>

            <jsp:include page="layout/header.jsp" />

            <div class="container my-5" style="padding-top: 20px;">

                <c:if test="${not empty successMsg}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm fw-bold"><i
                            class="bi bi-check-circle-fill me-2"></i>${successMsg}<button type="button"
                            class="btn-close" data-bs-dismiss="alert"></button></div>
                </c:if>
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm fw-bold"><i
                            class="bi bi-exclamation-triangle-fill me-2"></i>${errorMsg}<button type="button"
                            class="btn-close" data-bs-dismiss="alert"></button></div>
                </c:if>

                <h2 class="fw-bold mb-4 text-dark"><i class="bi bi-tags-fill text-primary me-2"></i>Quản lý Ngành nghề
                </h2>

                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="card shadow-sm border-0 rounded-4">
                            <div class="card-header bg-white border-bottom py-3">
                                <h5 class="fw-bold mb-0 text-dark">Thêm Danh mục mới</h5>
                            </div>
                            <div class="card-body p-4">
                                <form action="/admin/categories/add" method="POST">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">Tên ngành nghề <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="name" required
                                            placeholder="VD: IT - Phần mềm">
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100 fw-bold rounded-pill"><i
                                            class="bi bi-plus-circle me-2"></i> Thêm mới</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-8">
                        <div class="card shadow-sm border-0 rounded-4">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table align-middle mb-0">
                                        <thead class="table-light text-secondary small text-uppercase">
                                            <tr>
                                                <th class="text-center py-3" width="10%">ID</th>
                                                <th class="py-3" width="70%">Tên Ngành nghề</th>
                                                <th class="text-center py-3" width="20%">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="cat" items="${categories}">
                                                <tr>
                                                    <td class="text-center fw-bold text-muted">${cat.id}</td>
                                                    <td class="fw-bold text-dark"><i
                                                            class="bi bi-tag text-primary me-2"></i>${cat.name}</td>
                                                    <td class="text-center">
                                                        <form action="/admin/categories/delete/${cat.id}" method="POST"
                                                            class="confirm-action" data-confirm-message="Bạn có chắc muốn xóa danh mục này?">
                                                            <input type="hidden" name="${_csrf.parameterName}"
                                                                value="${_csrf.token}" />
                                                            <button type="submit"
                                                                class="btn btn-sm btn-outline-danger rounded-pill px-3 shadow-sm"><i
                                                                    class="bi bi-trash-fill me-1"></i> Xóa</button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty categories}">
                                                <tr>
                                                    <td colspan="3" class="text-center py-4 text-muted">Chưa có danh mục
                                                        nào.</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                    
                                </div>
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
            </script>
        </body>

        </html>