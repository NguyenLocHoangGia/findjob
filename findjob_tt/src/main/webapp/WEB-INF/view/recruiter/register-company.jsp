<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Đăng ký thông tin Công ty - JobPortal</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <style>
                body {
                    background-color: #f4f7fa;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                .select2-results__options {
                    max-height: 210px !important;
                    overflow-y: auto !important;
                }

                .hero-bg {
                    background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
                    color: white;
                    padding: 60px 0;
                    border-radius: 0 0 30px 30px;
                    margin-bottom: -50px;
                }
            </style>
        </head>

        <body>

            <jsp:include page="../candidate/layout/header.jsp" />

            <div class="hero-bg text-center shadow-sm">
                <div class="container pt-5">
                    <h2 class="fw-bold"><i class="bi bi-building-add me-2"></i>Đăng ký Hồ sơ Doanh nghiệp</h2>
                    <p class="opacity-75">Cung cấp thông tin xác thực để bắt đầu hành trình tìm kiếm nhân tài</p>
                </div>
            </div>

            <div class="container pb-5" style="position: relative; z-index: 10;">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="card shadow border-0 rounded-4 p-4 p-md-5 bg-white">

                            <c:if test="${not empty errorMsg}">
                                <div class="alert alert-danger fw-bold"><i
                                        class="bi bi-exclamation-triangle-fill me-2"></i>${errorMsg}</div>
                            </c:if>

                            <form action="/recruiter/register-company" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <h5 class="fw-bold text-dark mb-4 border-bottom pb-2">Thông tin Doanh nghiệp</h5>

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Tên Công ty <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control form-control-lg bg-light" name="companyName"
                                        required placeholder="VD: Công ty Cổ phần Công nghệ TechAsia">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Địa chỉ Trụ sở <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control bg-light" name="companyAddress" required
                                        placeholder="Nhập địa chỉ cụ thể...">
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold">Giới thiệu về Công ty <span
                                            class="text-danger">*</span></label>
                                    <select class="form-select bg-light" name="location" id="locationSelect" required>
                                        <option value="" disabled ${empty company.companyAddress ? 'selected' : '' }>--
                                            Chọn tỉnh/thành phố --</option>

                                        <option value="An Giang" ${company.companyAddress.contains('An Giang') ||
                                            company.companyAddress.contains('Kiên Giang') ? 'selected' : '' }>An Giang
                                        </option>
                                        <option value="Bắc Ninh" ${company.companyAddress.contains('Bắc Ninh') ||
                                            company.companyAddress.contains('Bắc Giang') ? 'selected' : '' }>Bắc Ninh
                                        </option>
                                        <option value="Cà Mau" ${company.companyAddress.contains('Cà Mau') ||
                                            company.companyAddress.contains('Bạc Liêu') ? 'selected' : '' }>Cà Mau
                                        </option>
                                        <option value="Cao Bằng" ${company.companyAddress.contains('Cao Bằng')
                                            ? 'selected' : '' }>Cao Bằng</option>
                                        <option value="Đắk Lắk" ${company.companyAddress.contains('Đắk Lắk') ||
                                            company.companyAddress.contains('Phú Yên') ? 'selected' : '' }>Đắk Lắk
                                        </option>
                                        <option value="Điện Biên" ${company.companyAddress.contains('Điện Biên')
                                            ? 'selected' : '' }>Điện Biên</option>
                                        <option value="Đồng Nai" ${company.companyAddress.contains('Đồng Nai') ||
                                            company.companyAddress.contains('Bình Phước') ? 'selected' : '' }>Đồng Nai
                                        </option>
                                        <option value="Đồng Tháp" ${company.companyAddress.contains('Đồng Tháp') ||
                                            company.companyAddress.contains('Tiền Giang') ? 'selected' : '' }>Đồng Tháp
                                        </option>
                                        <option value="Gia Lai" ${company.companyAddress.contains('Gia Lai') ||
                                            company.companyAddress.contains('Bình Định') ? 'selected' : '' }>Gia Lai
                                        </option>
                                        <option value="Hà Tĩnh" ${company.companyAddress.contains('Hà Tĩnh')
                                            ? 'selected' : '' }>Hà Tĩnh</option>
                                        <option value="Hưng Yên" ${company.companyAddress.contains('Hưng Yên') ||
                                            company.companyAddress.contains('Thái Bình') ? 'selected' : '' }>Hưng Yên
                                        </option>
                                        <option value="Khánh Hòa" ${company.companyAddress.contains('Khánh Hòa') ||
                                            company.companyAddress.contains('Ninh Thuận') ? 'selected' : '' }>Khánh Hòa
                                        </option>
                                        <option value="Lai Châu" ${company.companyAddress.contains('Lai Châu')
                                            ? 'selected' : '' }>Lai Châu</option>
                                        <option value="Lâm Đồng" ${company.companyAddress.contains('Lâm Đồng') ||
                                            company.companyAddress.contains('Đắk Nông') ||
                                            company.companyAddress.contains('Bình Thuận') ? 'selected' : '' }>Lâm Đồng
                                        </option>
                                        <option value="Lạng Sơn" ${company.companyAddress.contains('Lạng Sơn')
                                            ? 'selected' : '' }>Lạng Sơn</option>
                                        <option value="Lào Cai" ${company.companyAddress.contains('Lào Cai') ||
                                            company.companyAddress.contains('Yên Bái') ? 'selected' : '' }>Lào Cai
                                        </option>
                                        <option value="Nghệ An" ${company.companyAddress.contains('Nghệ An')
                                            ? 'selected' : '' }>Nghệ An</option>
                                        <option value="Ninh Bình" ${company.companyAddress.contains('Ninh Bình') ||
                                            company.companyAddress.contains('Hà Nam') ||
                                            company.companyAddress.contains('Nam Định') ? 'selected' : '' }>Ninh Bình
                                        </option>
                                        <option value="Phú Thọ" ${company.companyAddress.contains('Phú Thọ') ||
                                            company.companyAddress.contains('Vĩnh Phúc') ||
                                            company.companyAddress.contains('Hòa Bình') ? 'selected' : '' }>Phú Thọ
                                        </option>
                                        <option value="Quảng Ngãi" ${company.companyAddress.contains('Quảng Ngãi') ||
                                            company.companyAddress.contains('Kon Tum') ? 'selected' : '' }>Quảng Ngãi
                                        </option>
                                        <option value="Quảng Ninh" ${company.companyAddress.contains('Quảng Ninh')
                                            ? 'selected' : '' }>Quảng Ninh</option>
                                        <option value="Quảng Trị" ${company.companyAddress.contains('Quảng Trị') ||
                                            company.companyAddress.contains('Quảng Bình') ? 'selected' : '' }>Quảng Trị
                                        </option>
                                        <option value="Sơn La" ${company.companyAddress.contains('Sơn La') ? 'selected'
                                            : '' }>Sơn La</option>
                                        <option value="Tây Ninh" ${company.companyAddress.contains('Tây Ninh') ||
                                            company.companyAddress.contains('Long An') ? 'selected' : '' }>Tây Ninh
                                        </option>
                                        <option value="Thái Nguyên" ${company.companyAddress.contains('Thái Nguyên') ||
                                            company.companyAddress.contains('Bắc Kạn') ? 'selected' : '' }>Thái Nguyên
                                        </option>
                                        <option value="Thanh Hóa" ${company.companyAddress.contains('Thanh Hóa')
                                            ? 'selected' : '' }>Thanh Hóa</option>
                                        <option value="TP Cần Thơ" ${company.companyAddress.contains('Cần Thơ') ||
                                            company.companyAddress.contains('Sóc Trăng') ||
                                            company.companyAddress.contains('Hậu Giang') ? 'selected' : '' }>TP Cần Thơ
                                        </option>
                                        <option value="TP Đà Nẵng" ${company.companyAddress.contains('Đà Nẵng') ||
                                            company.companyAddress.contains('Quảng Nam') ? 'selected' : '' }>TP Đà Nẵng
                                        </option>
                                        <option value="TP Hà Nội" ${company.companyAddress.contains('Hà Nội')
                                            ? 'selected' : '' }>TP Hà Nội</option>
                                        <option value="TP Hải Phòng" ${company.companyAddress.contains('Hải Phòng') ||
                                            company.companyAddress.contains('Hải Dương') ? 'selected' : '' }>TP Hải
                                            Phòng</option>
                                        <option value="TP.HCM" ${company.companyAddress.contains('TP.HCM') ||
                                            company.companyAddress.contains('Hồ Chí Minh') ||
                                            company.companyAddress.contains('Bình Dương') ||
                                            company.companyAddress.contains('Bà Rịa') ? 'selected' : '' }>TP.HCM
                                        </option>
                                        <option value="TP Huế" ${company.companyAddress.contains('Huế') ? 'selected'
                                            : '' }>TP Huế</option>
                                        <option value="Tuyên Quang" ${company.companyAddress.contains('Tuyên Quang') ||
                                            company.companyAddress.contains('Hà Giang') ? 'selected' : '' }>Tuyên Quang
                                        </option>
                                        <option value="Vĩnh Long" ${company.companyAddress.contains('Vĩnh Long') ||
                                            company.companyAddress.contains('Bến Tre') ||
                                            company.companyAddress.contains('Trà Vinh') ? 'selected' : '' }>Vĩnh Long
                                        </option>
                                    </select>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-md-6 mb-3 mb-md-0">
                                        <label class="form-label fw-bold">Logo Công ty <span
                                                class="text-danger">*</span></label>
                                        <div class="p-3 border rounded-3 bg-light text-center">
                                            <i class="bi bi-image text-muted fs-3 d-block mb-2"></i>
                                            <input type="file" class="form-control form-control-sm" name="logoFile"
                                                accept="image/png, image/jpeg" required>
                                            <small class="text-muted mt-2 d-block">Định dạng JPG, PNG (Tối đa
                                                2MB)</small>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-primary">Giấy phép kinh doanh <span
                                                class="text-danger">*</span></label>
                                        <div
                                            class="p-3 border border-primary border-opacity-25 rounded-3 bg-primary bg-opacity-10 text-center">
                                            <i class="bi bi-file-earmark-medical text-primary fs-3 d-block mb-2"></i>
                                            <input type="file" class="form-control form-control-sm border-primary"
                                                name="licenseFile" accept="image/png, image/jpeg, application/pdf"
                                                required>
                                            <small class="text-primary mt-2 d-block">Bản scan JPG, PNG hoặc PDF</small>
                                        </div>
                                    </div>
                                </div>

                                <div class="alert alert-warning small rounded-3 border-warning">
                                    <i class="bi bi-info-circle-fill me-1"></i> <strong>Lưu ý:</strong> Sau khi gửi yêu
                                    cầu, Ban quản trị sẽ tiến hành xác minh giấy phép kinh doanh của bạn. Quá trình này
                                    có thể mất từ 1-2 ngày làm việc.
                                </div>

                                <div class="d-grid mt-4">
                                    <button type="submit" class="btn btn-primary btn-lg fw-bold rounded-pill shadow-sm">
                                        <i class="bi bi-send-fill me-2"></i> Gửi yêu cầu xét duyệt
                                    </button>
                                </div>

                                <div class="text-center mt-3">
                                    <a href="/" class="text-muted text-decoration-none small">Hủy bỏ và quay lại trang
                                        chủ</a>
                                </div>
                            </form>

                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

            <script>
                $(document).ready(function () {
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