<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân - Ứng viên</title>
    
    <meta name="_csrf" content="${_csrf.token}"/>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        /* Style cho ô input bị khóa để trông tự nhiên hơn */
        .form-control[readonly], .form-control[disabled] { background-color: #e9ecef; opacity: 1; cursor: not-allowed; }
        .text-truncate {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            display: block;
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
                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3 shadow" style="width: 60px; height: 60px; font-size: 24px;">
                            <i class="bi bi-person-lines-fill"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark">Hồ sơ Ứng viên</h3>
                            <p class="text-muted mb-0">Quản lý thông tin liên hệ và CV của bạn</p>
                        </div>
                    </div>

                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success py-2"><i class="bi bi-check-circle-fill me-2"></i>${successMsg}</div>
                    </c:if>

                    <form id="profileForm" action="/candidate/profile" method="POST" enctype="multipart/form-data">
                        
                        <div class="row mb-4">
                            <div class="col-md-4 text-center border-end">
                                <c:choose>
    <c:when test="${not empty candidateProfileDTO.existingImg}">
        <div class="mb-3">
            <%-- Kiểm tra xem ảnh là link Google (http) hay ảnh tự upload --%>
            <c:choose>
                <c:when test="${fn:startsWith(candidateProfileDTO.existingImg, 'http')}">
                    <img src="${candidateProfileDTO.existingImg}" alt="Avatar" class="rounded-circle shadow" style="width: 130px; height: 130px; object-fit: cover; border: 3px solid #0d6efd;">
                </c:when>
                <c:otherwise>
                    <img src="/uploads/avatars/${candidateProfileDTO.existingImg}" alt="Avatar" class="rounded-circle shadow" style="width: 130px; height: 130px; object-fit: cover; border: 3px solid #0d6efd;">
                </c:otherwise>
            </c:choose>
            
            <p class="small text-muted mb-0 mt-2">Đã cập nhật ảnh đại diện</p>
        </div>
    </c:when>
    <c:otherwise>
        <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 100px; height: 100px;">
            <i class="bi bi-camera text-secondary fs-1"></i>
        </div>
    </c:otherwise>
</c:choose>

                                <div class="mb-4 text-start">
                                    <label class="form-label fw-bold small">Tải lên Ảnh đại diện</label>
                                    <input class="form-control form-control-sm editable-file" type="file" name="avatarFile" accept="image/png, image/jpeg" disabled>
                                </div>

                                <div class="mb-3 text-start">
                                    <label class="form-label fw-bold small">Tải lên file CV (PDF)</label>
                                    <input class="form-control form-control-sm editable-file" type="file" name="cvFile" accept="application/pdf" disabled>
                                    
                                    <c:if test="${not empty candidateProfileDTO.existingCv}">
                                        <div id="oldCvContainer" class="mt-3 p-3 border rounded bg-white shadow-sm d-flex align-items-center justify-content-between">
                                            <div class="d-flex align-items-center overflow-hidden"> <i class="bi bi-file-pdf-fill text-danger fs-2 me-3"></i>
                                                <div class="overflow-hidden">
                                                    <div class="fw-bold small text-dark">Hồ sơ năng lực (CV)</div>
                                                    <div class="text-muted text-truncate" style="font-size: 0.75rem; max-width: 250px;" title="${candidateProfileDTO.existingCv}">
                                                        <i class="bi bi-check2-circle text-success"></i> ${candidateProfileDTO.existingCv}
                                                    </div>
                                                </div>
                                            </div>
                                            <a href="/uploads/cv_files/${candidateProfileDTO.existingCv}" target="_blank" class="btn btn-sm btn-success px-3 flex-shrink-0">
                                                <i class="bi bi-box-arrow-up-right me-1"></i> Xem chi tiết
                                            </a>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="col-md-8 ps-md-4">
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Tài khoản đăng nhập</label>
                                    <input type="email" class="form-control bg-light text-muted" value="${userEmail}" readonly>
                                </div>

                                <div class="mb-3">
                                    <label for="fullName" class="form-label fw-bold">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control editable-text" id="fullName" name="fullName" value="${candidateProfileDTO.fullName}" required readonly>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="phone" class="form-label fw-bold">Số điện thoại</label>
                                        <input type="text" class="form-control editable-text" id="phone" name="phone" value="${candidateProfileDTO.phone}" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="address" class="form-label fw-bold">Địa chỉ sinh sống</label>
                                        <input type="text" class="form-control editable-text" id="address" name="address" value="${candidateProfileDTO.address}" readonly>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label fw-bold">Giới thiệu bản thân</label>
                                    <textarea class="form-control editable-text" id="description" name="description" rows="4" readonly>${candidateProfileDTO.description}</textarea>
                                </div>
                            </div>
                        </div>

                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <div class="d-flex justify-content-end border-top pt-4 mt-2">
                            <button type="button" id="btnToggleEdit" class="btn btn-warning px-4 fw-bold text-dark">
                                <i class="bi bi-unlock-fill me-2"></i>Mở chỉnh sửa
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>

    <div id="toastContainer" class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 2000;"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function showToast(message, type) {
            const toastType = type || 'warning';
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

        function previewPDF(input, iframeId) {
            const containerId = iframeId + 'Container';
            const previewContainer = document.getElementById(containerId);
            const previewIframe = document.getElementById(iframeId);

            if (input.files && input.files[0]) {
                const file = input.files[0];
                if (file.type === "application/pdf") {
                    const fileURL = URL.createObjectURL(file);
                    previewIframe.src = fileURL;
                    previewContainer.classList.remove('d-none');
                } else {
                    showToast('Vui lòng chọn file định dạng PDF', 'warning');
                    input.value = "";
                }
            }
        }
        const profileForm = document.getElementById('profileForm');
        const btnToggleEdit = document.getElementById('btnToggleEdit');
        let isEditMode = false;

        function setEditMode(enabled) {
            isEditMode = enabled;

            document.querySelectorAll('.editable-text').forEach(field => {
                if (enabled) {
                    field.removeAttribute('readonly');
                    field.classList.remove('bg-light');
                } else {
                    field.setAttribute('readonly', true);
                    field.classList.add('bg-light');
                }
            });

            document.querySelectorAll('.editable-file').forEach(field => {
                if (enabled) {
                    field.removeAttribute('disabled');
                } else {
                    field.setAttribute('disabled', true);
                }
            });

            if (enabled) {
                const oldCvContainer = document.getElementById('oldCvContainer');
                if (oldCvContainer) {
                    oldCvContainer.classList.add('d-none');
                }

                if (!document.getElementById('tempUpdateNote')) {
                    const cvInput = document.querySelector('input[name="cvFile"]');
                    if (cvInput) {
                        const note = document.createElement('div');
                        note.id = 'tempUpdateNote';
                        note.className = 'small text-warning mt-2 fw-semibold';
                        note.innerHTML = '<i class="bi bi-info-circle-fill me-1"></i> Hệ thống đã sẵn có CV của bạn. Chọn file mới nếu bạn muốn thay thế.';
                        cvInput.parentNode.appendChild(note);
                    }
                }

                btnToggleEdit.classList.remove('btn-warning', 'text-dark');
                btnToggleEdit.classList.add('btn-success', 'text-white');
                btnToggleEdit.innerHTML = '<i class="bi bi-floppy-fill me-2"></i>Lưu cập nhật';
            } else {
                btnToggleEdit.classList.remove('btn-success', 'text-white');
                btnToggleEdit.classList.add('btn-warning', 'text-dark');
                btnToggleEdit.innerHTML = '<i class="bi bi-unlock-fill me-2"></i>Mở chỉnh sửa';
            }
        }

        btnToggleEdit.addEventListener('click', function() {
            if (!isEditMode) {
                setEditMode(true);
                return;
            }

            btnToggleEdit.disabled = true;
            btnToggleEdit.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Đang lưu...';
            profileForm.requestSubmit();
        });

        setEditMode(false);
    </script>
</body>
</html>