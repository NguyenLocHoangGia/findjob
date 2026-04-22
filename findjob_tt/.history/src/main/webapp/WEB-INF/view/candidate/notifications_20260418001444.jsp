<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Thông báo của bạn - Ứng viên</title>

            <meta name="_csrf" content="${_csrf.token}" />
            <meta name="_csrf_header" content="${_csrf.headerName}" />

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <style>
                body {
                    background-color: #f4f7fa;
                    font-family: 'Segoe UI', Tahoma, sans-serif;
                }

                .notification-item {
                    transition: all 0.3s ease;
                    border-left: 4px solid transparent;
                }

                .notification-item.unread {
                    border-left-color: #0d6efd;
                    background-color: #f0f7ff;
                }

                .notification-item:hover {
                    background-color: #f8f9fa;
                }

                .btn-delete {
                    color: #adb5bd;
                    transition: 0.2s;
                }

                .btn-delete:hover {
                    color: #dc3545;
                    transform: scale(1.1);
                }
            </style>
        </head>

        <body>
            <jsp:include page="layout/header.jsp" />

            <div class="container my-5" style="padding-top: 80px;">
                <div class="row justify-content-center">
                    <div class="col-md-10">
                        <div class="card shadow-sm border-0 rounded-4 p-4">
                            <div class="d-flex align-items-center border-bottom pb-3 mb-4">
                                <div class="bg-warning text-white rounded-circle d-flex align-items-center justify-content-center me-3 shadow"
                                    style="width: 60px; height: 60px; font-size: 24px;">
                                    <i class="bi bi-bell-fill"></i>
                                </div>
                                <div>
                                    <h3 class="fw-bold mb-0 text-dark">Thông báo hệ thống</h3>
                                    <p class="text-muted mb-0">Cập nhật trạng thái hồ sơ ứng tuyển của bạn</p>
                                </div>
                            </div>

                            <div class="list-group list-group-flush rounded-3 border">
                                <c:forEach var="n" items="${notifications}">
                                    <div class="list-group-item notification-item p-4 ${n.read ? '' : 'unread'}"
                                        id="notif-${n.id}">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div class="pe-3">
                                                <p class="mb-1 text-dark fw-medium">${n.message}</p>
                                                <small class="text-muted"><i
                                                        class="bi bi-clock me-1"></i>${n.createdAt}</small>
                                            </div>
                                            <div class="d-flex align-items-center flex-shrink-0">
                                                <c:if test="${!n.read}">
                                                    <span class="badge rounded-pill bg-primary px-2 py-1 me-3"
                                                        style="font-size: 0.6rem;">Mới</span>
                                                </c:if>
                                                <button
                                                    class="btn btn-link btn-delete p-0 text-decoration-none border-0"
                                                    onclick="deleteNotification(event, '${n.id}')"
                                                    title="Xóa thông báo">
                                                    <i class="bi bi-trash fs-5"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty notifications}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-chat-dots-fill text-muted opacity-25"
                                            style="font-size: 4rem;"></i>
                                        <h5 class="text-muted mt-3">Hộp thư trống</h5>
                                        <p class="text-muted small">Mọi cập nhật về hồ sơ sẽ xuất hiện tại đây.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content border-0 shadow-sm">
                        <div class="modal-header">
                            <h5 class="modal-title">Xác nhận xóa</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            Bạn có chắc chắn muốn xóa thông báo này?
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                            <button type="button" id="confirmDeleteBtn" class="btn btn-danger">Xóa</button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="toastContainer" class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 2000;"></div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                let pendingNotificationId = null;

                function showToast(message, type) {
                    const toastType = type || 'danger';
                    const container = document.getElementById('toastContainer');
                    const toastEl = document.createElement('div');
                    toastEl.className = 'toast align-items-center text-bg-' + toastType + ' border-0';
                    toastEl.role = 'alert';
                    toastEl.ariaLive = 'assertive';
                    toastEl.ariaAtomic = 'true';
                    toastEl.innerHTML =
                        '<div class="d-flex">' +
                        '<div class="toast-body">' + message + '</div>' +
                        '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
                        '</div>';
                    container.appendChild(toastEl);
                    const bsToast = new bootstrap.Toast(toastEl, { delay: 2200 });
                    bsToast.show();
                    toastEl.addEventListener('hidden.bs.toast', function () {
                        toastEl.remove();
                    });
                }

                function deleteNotification(event, id) {
                    event.stopPropagation();
                    event.preventDefault();
                    pendingNotificationId = id;
                    const modal = new bootstrap.Modal(document.getElementById('confirmDeleteModal'));
                    modal.show();
                }

                document.getElementById('confirmDeleteBtn').addEventListener('click', function () {
                    if (!pendingNotificationId) {
                        return;
                    }

                    const modalEl = document.getElementById('confirmDeleteModal');
                    const activeModal = bootstrap.Modal.getInstance(modalEl);
                    if (activeModal) {
                        activeModal.hide();
                    }

                    const id = pendingNotificationId;
                    pendingNotificationId = null;

                    const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
                    const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

                    const formData = new URLSearchParams();
                    formData.append('id', id);

                    fetch('/candidate/api/delete-notification', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            [csrfHeader]: csrfToken
                        },
                        body: formData.toString()
                    }).then(function (response) {
                        if (!response.ok) {
                            showToast('Có lỗi xảy ra, không thể xóa thông báo lúc này.', 'danger');
                            return;
                        }

                        const item = document.getElementById('notif-' + id);
                        if (!item) {
                            return;
                        }

                        item.style.opacity = '0';
                        item.style.transform = 'scale(0.95)';

                        setTimeout(function () {
                            item.remove();
                            if (document.querySelectorAll('[id^="notif-"]').length === 0) {
                                window.location.reload();
                            }
                        }, 300);
                    }).catch(function (err) {
                        console.error('Lỗi xóa thông báo:', err);
                        showToast('Có lỗi xảy ra, không thể xóa thông báo lúc này.', 'danger');
                    });
                });
            </script>
        </body>

        </html>