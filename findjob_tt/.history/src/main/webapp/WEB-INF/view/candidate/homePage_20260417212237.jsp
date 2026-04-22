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

                .location-suggestions {
                    position: absolute;
                    top: calc(100% + 4px);
                    left: 0;
                    right: 0;
                    background: #fff;
                    border: 1px solid #dee2e6;
                    border-radius: 8px;
                    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
                    z-index: 1100;
                    max-height: 210px;
                    overflow-y: auto;
                }

                .location-suggestion-item {
                    padding: 10px 12px;
                    cursor: pointer;
                    border-bottom: 1px solid #f1f3f5;
                    font-size: 0.95rem;
                }

                .location-suggestion-item:last-child {
                    border-bottom: none;
                }

                .location-suggestion-item:hover,
                .location-suggestion-item.active {
                    background: #f1f7ff;
                    color: #0d6efd;
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

                                <div class="position-relative border-start" style="flex: 1; min-width: 220px;">
                                    <input type="text" id="locationInput" name="location" value="${location}"
                                        class="form-control border-0 py-3 px-3 shadow-none text-muted"
                                        placeholder="Tất cả địa điểm" autocomplete="off">
                                    <div id="locationSuggestions" class="location-suggestions d-none"></div>
                                </div>

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
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold mb-0 text-dark"><i class="bi bi-fire text-danger"></i> Việc làm hấp dẫn nhất</h4>
                        <c:if test="${hasMoreHotJobs}">
                            <a href="/jobs?keyword=${keyword}&location=${location}&category=${categoryId}"
                                class="btn btn-outline-primary btn-sm fw-bold">
                                Xem thêm <i class="bi bi-arrow-right"></i>
                            </a>
                        </c:if>
                    </div>
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

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold mb-0 text-dark"><i class="bi bi-briefcase-fill text-primary"></i> Việc làm mới nhất</h4>
                    <c:if test="${hasMoreRecentJobs}">
                        <a href="/jobs?keyword=${keyword}&location=${location}&category=${categoryId}"
                            class="btn btn-outline-primary btn-sm fw-bold">
                            Xem thêm <i class="bi bi-arrow-right"></i>
                        </a>
                    </c:if>
                </div>
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

                <c:if test="${isAllJobsPage}">
                    <h4 class="fw-bold mt-5 mb-4 text-dark"><i class="bi bi-list-task text-success"></i> Danh sách tất cả công việc
                    </h4>
                    <div class="row g-4">
                        <c:forEach var="job" items="${allJobs}">
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
                </c:if>

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
                    const vietnamLocations = [
                        'An Giang', 'Bắc Ninh', 'Cà Mau', 'Cao Bằng', 'Đắk Lắk', 'Điện Biên', 'Đồng Nai', 'Đồng Tháp',
                        'Gia Lai', 'Hà Tĩnh', 'Hưng Yên', 'Khánh Hòa', 'Lai Châu', 'Lâm Đồng', 'Lạng Sơn', 'Lào Cai',
                        'Nghệ An', 'Ninh Bình', 'Phú Thọ', 'Quảng Ngãi', 'Quảng Ninh', 'Quảng Trị', 'Sơn La', 'Tây Ninh',
                        'Thái Nguyên', 'Thanh Hóa', 'TP Cần Thơ', 'TP Đà Nẵng', 'TP Hà Nội', 'TP Hải Phòng', 'TP.HCM',
                        'TP Huế', 'Tuyên Quang', 'Vĩnh Long'
                    ];

                    const locationInput = document.getElementById('locationInput');
                    const locationSuggestions = document.getElementById('locationSuggestions');

                    function normalizeText(text) {
                        return (text || '')
                            .toLowerCase()
                            .normalize('NFD')
                            .replace(/[\u0300-\u036f]/g, '')
                            .replace(/\b(tp|thanh pho|t\.?p\.?)\b/g, '')
                            .replace(/[^a-z0-9\s]/g, ' ')
                            .replace(/\s+/g, ' ')
                            .trim();
                    }

                    function getMatchedLocations(keyword) {
                        const normalizedKeyword = normalizeText(keyword);
                        if (!normalizedKeyword) {
                            return vietnamLocations;
                        }

                        return vietnamLocations.filter(function (location) {
                            const normalizedLocation = normalizeText(location);
                            return normalizedLocation.includes(normalizedKeyword)
                                || normalizedKeyword.includes(normalizedLocation);
                        });
                    }

                    function renderLocationSuggestions(keyword) {
                        if (!locationSuggestions) {
                            return;
                        }

                        const matches = getMatchedLocations(keyword);
                        locationSuggestions.innerHTML = '';

                        if (matches.length === 0) {
                            locationSuggestions.classList.add('d-none');
                            return;
                        }

                        matches.forEach(function (item) {
                            const option = document.createElement('div');
                            option.className = 'location-suggestion-item';
                            option.textContent = item;
                            option.addEventListener('mousedown', function (event) {
                                event.preventDefault();
                                locationInput.value = item;
                                locationSuggestions.classList.add('d-none');
                            });
                            locationSuggestions.appendChild(option);
                        });

                        locationSuggestions.classList.remove('d-none');
                    }

                    if (locationInput && locationSuggestions) {
                        locationInput.addEventListener('focus', function () {
                            renderLocationSuggestions(locationInput.value);
                        });

                        locationInput.addEventListener('input', function () {
                            renderLocationSuggestions(locationInput.value);
                        });

                        document.addEventListener('click', function (event) {
                            if (!locationInput.contains(event.target) && !locationSuggestions.contains(event.target)) {
                                locationSuggestions.classList.add('d-none');
                            }
                        });
                    }

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