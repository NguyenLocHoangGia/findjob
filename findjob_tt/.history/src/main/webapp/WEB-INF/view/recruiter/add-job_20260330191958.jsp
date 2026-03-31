<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Đăng Tin Tuyển Dụng Mới</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" />
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" />
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
                .select2-results__options {
                    max-height: 210px !important; 
                    overflow-y: auto !important;
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
                                                <label class="form-label fw-bold">Địa điểm làm việc <span class="text-danger">*</span></label>
                                                
                                                <select class="form-select bg-light" name="location" required id="locationSelect">
                                                    <option value="" disabled ${empty company.companyAddress ? 'selected' : ''}>-- Chọn tỉnh/thành phố --</option>
                                                    
                                                    <option value="An Giang" ${company.companyAddress.contains('An Giang') || company.companyAddress.contains('Kiên Giang') ? 'selected' : ''}>An Giang</option>
                                                    <option value="Bắc Ninh" ${company.companyAddress.contains('Bắc Ninh') || company.companyAddress.contains('Bắc Giang') ? 'selected' : ''}>Bắc Ninh</option>
                                                    <option value="Cà Mau" ${company.companyAddress.contains('Cà Mau') || company.companyAddress.contains('Bạc Liêu') ? 'selected' : ''}>Cà Mau</option>
                                                    <option value="Cao Bằng" ${company.companyAddress.contains('Cao Bằng') ? 'selected' : ''}>Cao Bằng</option>
                                                    <option value="Đắk Lắk" ${company.companyAddress.contains('Đắk Lắk') || company.companyAddress.contains('Phú Yên') ? 'selected' : ''}>Đắk Lắk</option>
                                                    <option value="Điện Biên" ${company.companyAddress.contains('Điện Biên') ? 'selected' : ''}>Điện Biên</option>
                                                    <option value="Đồng Nai" ${company.companyAddress.contains('Đồng Nai') || company.companyAddress.contains('Bình Phước') ? 'selected' : ''}>Đồng Nai</option>
                                                    <option value="Đồng Tháp" ${company.companyAddress.contains('Đồng Tháp') || company.companyAddress.contains('Tiền Giang') ? 'selected' : ''}>Đồng Tháp</option>
                                                    <option value="Gia Lai" ${company.companyAddress.contains('Gia Lai') || company.companyAddress.contains('Bình Định') ? 'selected' : ''}>Gia Lai</option>
                                                    <option value="Hà Tĩnh" ${company.companyAddress.contains('Hà Tĩnh') ? 'selected' : ''}>Hà Tĩnh</option>
                                                    <option value="Hưng Yên" ${company.companyAddress.contains('Hưng Yên') || company.companyAddress.contains('Thái Bình') ? 'selected' : ''}>Hưng Yên</option>
                                                    <option value="Khánh Hòa" ${company.companyAddress.contains('Khánh Hòa') || company.companyAddress.contains('Ninh Thuận') ? 'selected' : ''}>Khánh Hòa</option>
                                                    <option value="Lai Châu" ${company.companyAddress.contains('Lai Châu') ? 'selected' : ''}>Lai Châu</option>
                                                    <option value="Lâm Đồng" ${company.companyAddress.contains('Lâm Đồng') || company.companyAddress.contains('Đắk Nông') || company.companyAddress.contains('Bình Thuận') ? 'selected' : ''}>Lâm Đồng</option>
                                                    <option value="Lạng Sơn" ${company.companyAddress.contains('Lạng Sơn') ? 'selected' : ''}>Lạng Sơn</option>
                                                    <option value="Lào Cai" ${company.companyAddress.contains('Lào Cai') || company.companyAddress.contains('Yên Bái') ? 'selected' : ''}>Lào Cai</option>
                                                    <option value="Nghệ An" ${company.companyAddress.contains('Nghệ An') ? 'selected' : ''}>Nghệ An</option>
                                                    <option value="Ninh Bình" ${company.companyAddress.contains('Ninh Bình') || company.companyAddress.contains('Hà Nam') || company.companyAddress.contains('Nam Định') ? 'selected' : ''}>Ninh Bình</option>
                                                    <option value="Phú Thọ" ${company.companyAddress.contains('Phú Thọ') || company.companyAddress.contains('Vĩnh Phúc') || company.companyAddress.contains('Hòa Bình') ? 'selected' : ''}>Phú Thọ</option>
                                                    <option value="Quảng Ngãi" ${company.companyAddress.contains('Quảng Ngãi') || company.companyAddress.contains('Kon Tum') ? 'selected' : ''}>Quảng Ngãi</option>
                                                    <option value="Quảng Ninh" ${company.companyAddress.contains('Quảng Ninh') ? 'selected' : ''}>Quảng Ninh</option>
                                                    <option value="Quảng Trị" ${company.companyAddress.contains('Quảng Trị') || company.companyAddress.contains('Quảng Bình') ? 'selected' : ''}>Quảng Trị</option>
                                                    <option value="Sơn La" ${company.companyAddress.contains('Sơn La') ? 'selected' : ''}>Sơn La</option>
                                                    <option value="Tây Ninh" ${company.companyAddress.contains('Tây Ninh') || company.companyAddress.contains('Long An') ? 'selected' : ''}>Tây Ninh</option>
                                                    <option value="Thái Nguyên" ${company.companyAddress.contains('Thái Nguyên') || company.companyAddress.contains('Bắc Kạn') ? 'selected' : ''}>Thái Nguyên</option>
                                                    <option value="Thanh Hóa" ${company.companyAddress.contains('Thanh Hóa') ? 'selected' : ''}>Thanh Hóa</option>
                                                    <option value="TP Cần Thơ" ${company.companyAddress.contains('Cần Thơ') || company.companyAddress.contains('Sóc Trăng') || company.companyAddress.contains('Hậu Giang') ? 'selected' : ''}>TP Cần Thơ</option>
                                                    <option value="TP Đà Nẵng" ${company.companyAddress.contains('Đà Nẵng') || company.companyAddress.contains('Quảng Nam') ? 'selected' : ''}>TP Đà Nẵng</option>
                                                    <option value="TP Hà Nội" ${company.companyAddress.contains('Hà Nội') ? 'selected' : ''}>TP Hà Nội</option>
                                                    <option value="TP Hải Phòng" ${company.companyAddress.contains('Hải Phòng') || company.companyAddress.contains('Hải Dương') ? 'selected' : ''}>TP Hải Phòng</option>
                                                    <option value="TP.HCM" ${company.companyAddress.contains('TP.HCM') || company.companyAddress.contains('Hồ Chí Minh') || company.companyAddress.contains('Bình Dương') || company.companyAddress.contains('Bà Rịa') ? 'selected' : ''}>TP.HCM</option>
                                                    <option value="TP Huế" ${company.companyAddress.contains('Huế') ? 'selected' : ''}>TP Huế</option>
                                                    <option value="Tuyên Quang" ${company.companyAddress.contains('Tuyên Quang') || company.companyAddress.contains('Hà Giang') ? 'selected' : ''}>Tuyên Quang</option>
                                                    <option value="Vĩnh Long" ${company.companyAddress.contains('Vĩnh Long') || company.companyAddress.contains('Bến Tre') || company.companyAddress.contains('Trà Vinh') ? 'selected' : ''}>Vĩnh Long</option>
                                                </select>
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
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // "Hóa phép" ô select thường thành ô select thông minh
            $('#locationSelect').select2({
                theme: 'bootstrap-5', 
                width: '100%',
                placeholder: '-- Chọn tỉnh/thành phố --',
                minimumResultsForSearch: Infinity // <-- THÊM DÒNG NÀY ĐỂ ẨN Ô TÌM KIẾM
            });
        })
    </script>
        </body>

        </html>