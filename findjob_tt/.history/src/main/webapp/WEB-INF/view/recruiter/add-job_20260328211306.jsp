<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Đăng Tin Tuyển Dụng Mới</title>
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

                .preview-img {
                    width: 100px;
                    height: 100px;
                    object-fit: cover;
                    border-radius: 12px;
                    border: 1px solid #dee2e6;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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
                            <h3 class="fw-bold mb-4">Đăng Tin Tuyển Dụng (Job)</h3>

                            <div class="card shadow-sm border-0" style="max-width: 900px;">
                                <div class="card-body p-4">

                                    <form action="/recruiter/job/save" method="POST" enctype="multipart/form-data">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                        <div class="row">
                                            <div class="col-md-8 mb-3">
                                                <label class="form-label fw-bold">Tiêu đề công việc <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" name="title" required
                                                    placeholder="VD: Thực tập sinh Java Spring Boot">
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label fw-bold">Tên công ty <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control bg-light" name="companyName"
                                                    value="${company.companyName}" required>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label fw-bold">Mức lương <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" name="salary" required
                                                    placeholder="VD: 5.000.000 VNĐ / Thỏa thuận">
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label fw-bold">Địa điểm làm việc <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control bg-light" name="location"
                                                    value="${company.companyAddress}" required>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Ngành nghề <span
                                                    class="text-danger">*</span></label>
                                            <select class="form-select" name="categoryId" required>
                                                <option value="">-- Chọn ngành nghề --</option>
                                                <c:forEach var="cat" items="${categories}">
                                                    <option value="${cat.id}">${cat.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label fw-bold text-primary">Mô tả ngắn gọn (Hiển thị
                                                ngoài Trang chủ) <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" name="shortDescription" required
                                                maxlength="150"
                                                placeholder="VD: Tìm kiếm 2 bạn Thực tập sinh Java đam mê lập trình web...">
                                            <small class="text-muted fst-italic">Nhập tóm tắt hấp dẫn để thu hút ứng
                                                viên.</small>
                                        </div>

                                        <div class="mb-4 mt-4">
                                            <label class="form-label fw-bold">Mô tả chi tiết và Yêu cầu <span
                                                    class="text-danger">*</span></label>
                                            <textarea class="form-control bg-light" name="description" rows="6" required
                                                placeholder="- Yêu cầu kỹ năng...">${company.description}</textarea>
                                        </div>

                                        <div class="mb-3 border rounded p-3 bg-light">
                                            <label for="logoFile" class="form-label fw-bold mb-1">Logo hiển thị cho tin
                                                này</label>
                                            <p class="text-muted small mb-2 text-info"><i class="bi bi-info-circle"></i>
                                                Hệ thống sẽ tự dùng Logo Công ty nếu bạn không chọn tệp mới.</p>
                                            <input class="form-control bg-white" type="file" id="logoFile"
                                                accept=".png, .jpg, .jpeg" name="logoFile"
                                                onchange="previewLogo(event)" />
                                        </div>

                                        <div id="previewContainer"
                                            class="mb-4 text-center <c:if test='${empty company.companyLogo}'>d-none</c:if>">
                                            <p class="text-muted small mb-2">Logo sẽ hiển thị cho tin này:</p>

                                            <img id="logoPreview"
                                                src="${not empty company.companyLogo ? '/uploads/company_logos/'.concat(company.companyLogo) : ''}"
                                                alt="Logo Preview" class="preview-img">
                                        </div>

                                        <hr>
                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary fw-bold px-4">
                                                <i class="bi bi-send-check me-2"></i> Đăng tin ngay
                                            </button>
                                            <a href="/recruiter/dashboard" class="btn btn-light border">Hủy bỏ</a>
                                        </div>
                                    </form>

                                </div>
                            </div>
                        </div>
                    </div>

                    <jsp:include page="layout/footer.jsp" />

                </div>
            </div>

            <script>
                function previewLogo(event) {
                    const input = event.target;
                    const previewImg = document.getElementById('logoPreview');
                    const previewContainer = document.getElementById('previewContainer');

                    if (input.files && input.files[0]) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            previewImg.src = e.target.result;
                            previewContainer.classList.remove('d-none');
                        }
                        reader.readAsDataURL(input.files[0]);
                    } else {
                        // Nếu người dùng nhấn hủy chọn tệp, phục hồi lại Logo mặc định của Công ty
                        const defaultLogo = '${company.companyLogo}';
                        if (defaultLogo) {
                            previewImg.src = '/uploads/company_logos/' + defaultLogo;
                            previewContainer.classList.remove('d-none');
                        } else {
                            previewContainer.classList.add('d-none');
                        }
                    }
                }
            </script>
        </body>

        </html>