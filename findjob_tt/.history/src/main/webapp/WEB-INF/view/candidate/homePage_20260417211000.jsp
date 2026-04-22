<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Trang chủ Ứng viên - JobPortal</title>

            <meta name="_csrf" content="${_csrf.token}" />
            <meta name="_csrf_header" content="${_csrf.headerName}" />

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
            <style>
                body {
                    background: #f8fafc;
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                /* --- MỞ RỘNG GIAO DIỆN --- */
                /* Class này giúp ghi đè giới hạn 1320px mặc định của Bootstrap, đẩy chiều rộng ra mép màn hình hơn */
                .container-custom {
                    max-width: 1450px !important;
                }

                /* --- HERO SECTION VỚI HÌNH NỀN --- */
                .hero-section {
                    background-image: linear-gradient(135deg, rgba(13, 110, 253, 0.85) 0%, rgba(13, 202, 240, 0.9) 100%),
                        url('https://images.unsplash.com/photo-1521737711867-e3b97375f902?q=80&w=1974');
                    background-size: cover;
                    background-position: center;
                    background-repeat: no-repeat;
                    padding: 130px 0 60px 0px;
                    text-align: center;
                    color: white;
                }

                .mini-card {
                    background: #ffffff;
                    border-radius: 12px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
                    border: 1px solid rgba(0, 0, 0, 0.06);
                    transition: all 0.3s ease;
                    height: 100%;
                    display: flex;
                    flex-direction: row;
                    align-items: flex-start;
                    padding: 15px;
                }

                .hover-lift:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 10px 25px rgba(13, 110, 253, 0.1);
                    border-color: #0d6efd;
                }

                .card-body-content {
                    display: flex;
                    flex-direction: column;
                    padding-right: 15px;
                }

                .mini-logo-img {
                    width: 70px;
                    height: 70px;
                    border-radius: 12px;
                    object-fit: cover;
                    border: 1px solid #f1f5f9;
                    background: #fff;
                    padding: 0;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
                }

                .text-clamp-2 {
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }

                .wishlist-btn {
                    position: absolute;
                    top: 0;
                    right: 0;
                    border: none;
                    background: none;
                    color: #ff4757;
                    padding: 1.5px;
                    cursor: pointer;
                    transition: color 0.2s ease, transform 0.2s ease;
                    font-size: 1.1rem;
                    line-height: 1;
                    z-index: 5;
                }

                .wishlist-btn:hover {
                    color: #ff4757;
                    transform: scale(1.1);
                }

                .wishlist-btn.active {
                    color: #ff4757;
                }

                .detail-button-wrapper {
                    opacity: 0;
                    transform: translateY(10px);
                    transition: all 0.3s ease;
                }

                .hover-lift:hover .detail-button-wrapper {
                    opacity: 1;
                    transform: translateY(0);
                }

                /* Huy hiệu HOT */
                .badge-hot {
                    background-color: #ff4d4d;
                    color: white;
                    font-size: 0.65rem;
                    padding: 3px 6px;
                    border-radius: 4px;
                    animation: pulse 1.5s infinite;
                    white-space: nowrap;
                    display: inline-block;
                }

                @keyframes pulse {
                    0% {
                        transform: scale(1);
                    }

                    50% {
                        transform: scale(1.1);
                    }

                    100% {
                        transform: scale(1);
                    }
                }
            </style>
        </head>

        <body>

            <jsp:include page="layout/header.jsp" />

            <div class="hero-section shadow-sm">
                <div class="container container-custom">
                    <h1 class="fw-bold mb-3 fs-2" style="text-shadow: 0 2px 4px rgba(0,0,0,0.3);">Mạng Lưới Việc Làm IT
                        Hàng Đầu</h1>
                    <p class="mb-4 opacity-75" style="text-shadow: 0 1px 2px rgba(0,0,0,0.2);">Tìm kiếm hàng ngàn cơ hội
                        thực tập và việc làm chất lượng.</p>
                    <div class="row justify-content-center">
                        <div class="col-lg-7 col-md-10">

                            <form action="/" method="GET" class="input-group shadow-lg"
                                style="border-radius: 8px; overflow: hidden; background: #fff;">
                                <input type="text" name="keyword" value="${keyword}"
                                    class="form-control border-0 py-3 px-3 shadow-none" style="flex: 2;"
                                    placeholder="Nhập kỹ năng, chức danh, công ty...">

                                <select name="location"
                                    class="form-select border-0 border-start py-3 shadow-none text-muted"
                                    style="flex: 1; cursor: pointer;">
                                    <option value="">Tất cả địa điểm</option>
                                    <option value="An Giang" ${location=='An Giang' ? 'selected' : '' }>An Giang</option>
                                    <option value="Bắc Ninh" ${location=='Bắc Ninh' ? 'selected' : '' }>Bắc Ninh</option>
                                    <option value="Cà Mau" ${location=='Cà Mau' ? 'selected' : '' }>Cà Mau</option>
                                    <option value="Cao Bằng" ${location=='Cao Bằng' ? 'selected' : '' }>Cao Bằng</option>
                                    <option value="Đắk Lắk" ${location=='Đắk Lắk' ? 'selected' : '' }>Đắk Lắk</option>
                                    <option value="Điện Biên" ${location=='Điện Biên' ? 'selected' : '' }>Điện Biên</option>
                                    <option value="Đồng Nai" ${location=='Đồng Nai' ? 'selected' : '' }>Đồng Nai</option>
                                    <option value="Đồng Tháp" ${location=='Đồng Tháp' ? 'selected' : '' }>Đồng Tháp</option>
                                    <option value="Gia Lai" ${location=='Gia Lai' ? 'selected' : '' }>Gia Lai</option>
                                    <option value="Hà Tĩnh" ${location=='Hà Tĩnh' ? 'selected' : '' }>Hà Tĩnh</option>
                                    <option value="Hưng Yên" ${location=='Hưng Yên' ? 'selected' : '' }>Hưng Yên</option>
                                    <option value="Khánh Hòa" ${location=='Khánh Hòa' ? 'selected' : '' }>Khánh Hòa</option>
                                    <option value="Lai Châu" ${location=='Lai Châu' ? 'selected' : '' }>Lai Châu</option>
                                    <option value="Lâm Đồng" ${location=='Lâm Đồng' ? 'selected' : '' }>Lâm Đồng</option>
                                    <option value="Lạng Sơn" ${location=='Lạng Sơn' ? 'selected' : '' }>Lạng Sơn</option>
                                    <option value="Lào Cai" ${location=='Lào Cai' ? 'selected' : '' }>Lào Cai</option>
                                    <option value="Nghệ An" ${location=='Nghệ An' ? 'selected' : '' }>Nghệ An</option>
                                    <option value="Ninh Bình" ${location=='Ninh Bình' ? 'selected' : '' }>Ninh Bình</option>
                                    <option value="Phú Thọ" ${location=='Phú Thọ' ? 'selected' : '' }>Phú Thọ</option>
                                    <option value="Quảng Ngãi" ${location=='Quảng Ngãi' ? 'selected' : '' }>Quảng Ngãi</option>
                                    <option value="Quảng Ninh" ${location=='Quảng Ninh' ? 'selected' : '' }>Quảng Ninh</option>
                                    <option value="Quảng Trị" ${location=='Quảng Trị' ? 'selected' : '' }>Quảng Trị</option>
                                    <option value="Sơn La" ${location=='Sơn La' ? 'selected' : '' }>Sơn La</option>
                                    <option value="Tây Ninh" ${location=='Tây Ninh' ? 'selected' : '' }>Tây Ninh</option>
                                    <option value="Thái Nguyên" ${location=='Thái Nguyên' ? 'selected' : '' }>Thái Nguyên</option>
                                    <option value="Thanh Hóa" ${location=='Thanh Hóa' ? 'selected' : '' }>Thanh Hóa</option>
                                    <option value="TP Cần Thơ" ${location=='TP Cần Thơ' ? 'selected' : '' }>TP Cần Thơ</option>
                                    <option value="TP Đà Nẵng" ${location=='TP Đà Nẵng' ? 'selected' : '' }>TP Đà Nẵng</option>
                                    <option value="TP Hà Nội" ${location=='TP Hà Nội' ? 'selected' : '' }>TP Hà Nội</option>
                                    <option value="TP Hải Phòng" ${location=='TP Hải Phòng' ? 'selected' : '' }>TP Hải Phòng</option>
                                    <option value="TP.HCM" ${location=='TP.HCM' ? 'selected' : '' }>TP.HCM</option>
                                    <option value="TP Huế" ${location=='TP Huế' ? 'selected' : '' }>TP Huế</option>
                                    <option value="Tuyên Quang" ${location=='Tuyên Quang' ? 'selected' : '' }>Tuyên Quang</option>
                                    <option value="Vĩnh Long" ${location=='Vĩnh Long' ? 'selected' : '' }>Vĩnh Long</option>
                                </select>

                                <select name="category"
                                    class="form-select border-0 border-start py-3 shadow-none text-muted"
                                    style="flex: 1; cursor: pointer;">
                                    <option value="">Tất cả ngành nghề</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.id}" ${categoryId==category.id ? 'selected' : '' }>
                                            ${category.name}</option>
                                    </c:forEach>
                                </select>

                                <button class="btn btn-dark fw-bold px-4 py-3" type="submit">
                                    <i class="bi bi-search me-1"></i> Tìm việc
                                </button>
                            </form>

                        </div>
                    </div>
                </div>
            </div>

            <div class="container container-custom my-5 flex-grow-1">

                <c:if test="${not empty hotJobs}">
                    <h4 class="fw-bold mb-4 text-dark"><i class="bi bi-fire text-danger"></i> Việc làm hấp dẫn nhất</h4>
                    <div class="row g-4 mb-5">
                        <c:forEach var="job" items="${hotJobs}">
                            <div class="col-lg-4 col-md-6">
                                <a href="/job/${job.id}" class="text-decoration-none text-dark d-block h-100">
                                    <div class="mini-card hover-lift">
                                        <div class="me-3 flex-shrink-0">
                                            <c:choose>
                                                <c:when test="${not empty job.logo}">
                                                    <img src="/uploads/company_logos/${job.logo}" class="mini-logo-img"
                                                        alt="Logo"
                                                        onerror="this.onerror=null;this.src='/uploads/job_logos/${job.logo}';">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://ui-avatars.com/api/?name=${job.companyName}&background=0D8ABC&color=fff&size=120&font-size=0.4"
                                                        class="mini-logo-img" alt="Logo">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div
                                            class="card-body-content flex-grow-1 overflow-hidden h-100 position-relative">
                                            <button class="wishlist-btn" type="button" data-job-id="${job.id}"
                                                title="${savedJobIds.contains(job.id) ? 'Bỏ quan tâm' : 'Quan tâm'}"
                                                onclick="toggleWishlist(event)">
                                                <i
                                                    class="bi ${savedJobIds.contains(job.id) ? 'bi-heart-fill' : 'bi-heart'}"></i>
                                            </button>

                                            <div class="d-flex align-items-center mb-1 pe-4">
                                                <h6 class="fw-bold text-primary mb-0 text-truncate"
                                                    title="${job.title}">${job.title}</h6>
                                                <span class="badge-hot ms-2 flex-shrink-0">HOT</span>
                                            </div>

                                            <p class="text-muted text-uppercase fw-bold mb-2"
                                                style="font-size: 0.75rem;">${job.companyName}</p>

                                            <div class="d-flex flex-wrap gap-2 mb-2" style="font-size: 0.85rem;">
                                                <span
                                                    class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">
                                                    <i class="bi bi-cash me-1"></i>${job.salary}
                                                </span>
                                                <span
                                                    class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1">
                                                    <i class="bi bi-geo-alt me-1"></i>${job.location}
                                                </span>

                                            </div>
                                            <span class="text-muted ms-2" style="font-size:0.85rem"><i
                                                    class="bi bi-clock me-1"></i><span class="job-timeago"
                                                    data-created="${job.createdAt}"></span></span>
                                            <p class="text-muted text-clamp-2 mb-0 mt-1"
                                                style="font-size: 0.85rem; line-height: 1.5;">${job.shortDescription}
                                            </p>

                                            <div class="mt-auto pt-1 detail-button-wrapper text-end">
                                                <span class="text-primary fw-bold" style="font-size: 0.85rem;">
                                                    Xem chi tiết <i class="bi bi-arrow-right"></i>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <h4 class="fw-bold mb-4 text-dark"><i class="bi bi-briefcase-fill text-primary"></i> Việc làm mới nhất
                </h4>
                <div class="row g-4">
                    <c:forEach var="job" items="${recentJobs}">
                        <div class="col-lg-4 col-md-6">
                            <a href="/job/${job.id}" class="text-decoration-none text-dark d-block h-100">
                                <div class="mini-card hover-lift">
                                    <div class="me-3 flex-shrink-0">
                                        <c:choose>
                                            <c:when test="${not empty job.logo}">
                                                <img src="/uploads/company_logos/${job.logo}" class="mini-logo-img"
                                                    alt="Logo"
                                                    onerror="this.onerror=null;this.src='/uploads/job_logos/${job.logo}';">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://ui-avatars.com/api/?name=${job.companyName}&background=0D8ABC&color=fff&size=120&font-size=0.4"
                                                    class="mini-logo-img" alt="Logo">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="card-body-content flex-grow-1 overflow-hidden h-100 position-relative">
                                        <button class="wishlist-btn" type="button" data-job-id="${job.id}"
                                            title="${savedJobIds.contains(job.id) ? 'Bỏ quan tâm' : 'Quan tâm'}"
                                            onclick="toggleWishlist(event)">
                                            <i
                                                class="bi ${savedJobIds.contains(job.id) ? 'bi-heart-fill' : 'bi-heart'}"></i>
                                        </button>

                                        <div class="d-flex align-items-center mb-1 pe-4">
                                            <h6 class="fw-bold text-primary mb-0 text-truncate" title="${job.title}">
                                                ${job.title}</h6>
                                            <c:if test="${job.isHot}">
                                                <span class="badge-hot ms-2 flex-shrink-0">HOT</span>
                                            </c:if>
                                        </div>

                                        <p class="text-muted text-uppercase fw-bold mb-2" style="font-size: 0.75rem;">
                                            ${job.companyName}</p>

                                        <div class="d-flex flex-wrap gap-2 mb-2" style="font-size: 0.85rem;">
                                            <span
                                                class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">
                                                <i class="bi bi-cash me-1"></i>${job.salary}
                                            </span>
                                            <span
                                                class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1">
                                                <i class="bi bi-geo-alt me-1"></i>${job.location}
                                            </span>

                                        </div>
                                        <span class="text-muted ms-2" style="font-size:0.85rem"><i
                                                class="bi bi-clock me-1"></i><span class="job-timeago"
                                                data-created="${job.createdAt}"></span></span>
                                        <p class="text-muted text-clamp-2 mb-0 mt-1"
                                            style="font-size: 0.85rem; line-height: 1.5;">${job.shortDescription}</p>

                                        <div class="mt-auto pt-1 detail-button-wrapper text-end">
                                            <span class="text-primary fw-bold" style="font-size: 0.85rem;">
                                                Xem chi tiết <i class="bi bi-arrow-right"></i>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>

            </div>

            <jsp:include page="layout/footer.jsp" />

            <script>
                function toggleWishlist(event) {
                    event.stopPropagation();
                    event.preventDefault();

                    const btn = event.currentTarget;
                    const jobId = btn.getAttribute('data-job-id');
                    const icon = btn.querySelector('i');

                    const headerCountEl = document.getElementById('header-saved-count');
                    let currentCount = parseInt(headerCountEl.innerText) || 0;

                    const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
                    const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

                    const formData = new URLSearchParams();
                    formData.append("jobId", jobId);

                    fetch('/candidate/api/toggle-save-job', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded', [csrfHeader]: csrfToken },
                        body: formData.toString()
                    }).then(response => {
                        if (response.status === 401) {
                            alert("Vui lòng đăng nhập để lưu việc làm!");
                            window.location.href = '/login';
                            return;
                        }
                        return response.text();
                    }).then(data => {
                        if (data === 'added') {
                            icon.classList.remove('bi-heart');
                            icon.classList.add('bi-heart-fill');
                            btn.setAttribute('title', 'Bỏ quan tâm');
                            headerCountEl.innerText = currentCount + 1;
                        } else if (data === 'removed') {
                            icon.classList.remove('bi-heart-fill');
                            icon.classList.add('bi-heart');
                            btn.setAttribute('title', 'Quan tâm');
                            headerCountEl.innerText = currentCount > 0 ? currentCount - 1 : 0;
                        }
                    }).catch(err => console.error("Lỗi:", err));
                }

                // Hiển thị thời gian đăng tin dạng "x ngày trước"
                document.addEventListener('DOMContentLoaded', function () {
                    function timeAgo(dateStr) {
                        const now = new Date();
                        const posted = new Date(dateStr);
                        const diff = Math.floor((now - posted) / 1000);
                        if (isNaN(diff)) return '';
                        if (diff < 60) return 'Vừa xong';
                        if (diff < 3600) return Math.floor(diff / 60) + ' phút trước';
                        if (diff < 86400) return Math.floor(diff / 3600) + ' giờ trước';
                        if (diff < 2592000) return Math.floor(diff / 86400) + ' ngày trước';
                        if (diff < 31536000) return Math.floor(diff / 2592000) + ' tháng trước';
                        return Math.floor(diff / 31536000) + ' năm trước';
                    }
                    document.querySelectorAll('.job-timeago').forEach(function (el) {
                        const created = el.getAttribute('data-created');
                        if (created) {
                            el.textContent = timeAgo(created);
                        }
                    });
                });
            </script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>