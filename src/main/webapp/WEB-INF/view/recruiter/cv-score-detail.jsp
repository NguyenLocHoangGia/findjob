<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết điểm AI - ${not empty application.user.fullName ? application.user.fullName : application.user.email}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; margin: 0; background-color: #f4f6f9; }
        .main-wrapper { display: flex; flex: 1; }
        .content-area { display: flex; flex-direction: column; flex: 1; }
        .main-content { flex: 1; padding: 30px; }
        .card { border-radius: 12px; }
        .score-number { font-size: 3.5rem; line-height: 1; }
        .score-chip { border-radius: 999px; }
        .score-progress { height: 8px; }
        .info-label { font-size: .78rem; text-transform: uppercase; color: #6c757d; font-weight: 700; }
        .pre-line { white-space: pre-line; }
        .skill-badge { font-size: .86rem; }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="main-wrapper">
        <jsp:include page="layout/sidebar.jsp" />

        <div class="content-area">
            <div class="main-content">
                <div class="container-fluid">

                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="/recruiter/dashboard" class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item">
                                <a href="/recruiter/job/${job.id}/candidates" class="text-decoration-none">Danh sách ứng viên</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Chi tiết điểm AI</li>
                        </ol>
                    </nav>

                    <div class="d-flex justify-content-between align-items-start mb-4">
                        <div>
                            <h3 class="fw-bold mb-1 text-dark">Chi tiết điểm AI</h3>
                            <p class="text-muted mb-0">
                                Ứng viên:
                                <span class="text-primary fw-bold">${not empty application.user.fullName ? application.user.fullName : application.user.email}</span>
                                <span class="mx-2">•</span>
                                Công việc: <span class="fw-bold">${job.title}</span>
                            </p>
                        </div>
                        <a href="/recruiter/job/${job.id}/candidates" class="btn btn-outline-secondary shadow-sm">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>
                    </div>

                    <c:if test="${empty score}">
                        <div class="card shadow-sm border-0 rounded-4">
                            <div class="card-body text-center py-5">
                                <i class="bi bi-hourglass-split fs-1 text-warning d-block mb-3"></i>
                                <h5 class="fw-bold text-dark">Chưa có điểm AI</h5>
                                <p class="text-muted mb-4">CV này đang chấm hoặc lần chấm trước chưa tạo được kết quả.</p>
                                <a href="/recruiter/job/${job.id}/candidates" class="btn btn-dark">
                                    <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
                                </a>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty score}">
                        <div class="row g-4 mb-4">
                            <div class="col-lg-4">
                                <div class="card shadow-sm border-0 rounded-4 h-100">
                                    <div class="card-body p-4">
                                        <div class="d-flex justify-content-between align-items-start mb-4">
                                            <div>
                                                <div class="info-label mb-1">Tổng điểm</div>
                                                <div class="score-number fw-bold text-primary">
                                                    <fmt:formatNumber value="${score.totalScore}" minFractionDigits="0" maxFractionDigits="2"/>
                                                </div>
                                            </div>
                                            <c:choose>
                                                <c:when test="${score.matchLevel == 'VERY_FIT'}">
                                                    <span class="badge bg-success-subtle text-success border border-success border-opacity-25 px-3 py-2 score-chip">Rất phù hợp</span>
                                                </c:when>
                                                <c:when test="${score.matchLevel == 'FIT'}">
                                                    <span class="badge bg-primary-subtle text-primary border border-primary border-opacity-25 px-3 py-2 score-chip">Phù hợp</span>
                                                </c:when>
                                                <c:when test="${score.matchLevel == 'PARTIAL'}">
                                                    <span class="badge bg-info-subtle text-info border border-info border-opacity-25 px-3 py-2 score-chip">Phù hợp một phần</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger border-opacity-25 px-3 py-2 score-chip">Ít phù hợp</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="text-muted small mb-3">
                                            <i class="bi bi-clock me-1"></i>
                                            Chấm lúc: ${fn:replace(fn:substring(score.scoredAt, 0, 19), 'T', ' ')}
                                        </div>
                                        <div class="text-muted small">
                                            <i class="bi bi-file-earmark-text me-1"></i>
                                            Application #${application.id}
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-8">
                                <div class="card shadow-sm border-0 rounded-4 h-100">
                                    <div class="card-header bg-white border-0 pt-4 px-4">
                                        <h5 class="fw-bold mb-0"><i class="bi bi-bar-chart-fill text-primary me-2"></i>Điểm thành phần</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <c:set var="skillScore" value="${empty score.skillScore ? 0 : score.skillScore}" />
                                        <c:set var="projectScore" value="${empty score.projectScore ? 0 : score.projectScore}" />
                                        <c:set var="educationScore" value="${empty score.educationScore ? 0 : score.educationScore}" />
                                        <c:set var="completenessScore" value="${empty score.completenessScore ? 0 : score.completenessScore}" />
                                        <c:set var="bonusScore" value="${empty score.bonusScore ? 0 : score.bonusScore}" />
                                        <c:set var="penaltyScore" value="${empty score.penaltyScore ? 0 : score.penaltyScore}" />

                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <div class="d-flex justify-content-between small fw-bold mb-1"><span>Kỹ năng</span><span>${skillScore}</span></div>
                                                <div class="progress score-progress"><div class="progress-bar bg-primary" style="width: ${skillScore}%"></div></div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="d-flex justify-content-between small fw-bold mb-1"><span>Dự án/Kinh nghiệm</span><span>${projectScore}</span></div>
                                                <div class="progress score-progress"><div class="progress-bar bg-success" style="width: ${projectScore}%"></div></div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="d-flex justify-content-between small fw-bold mb-1"><span>Học vấn</span><span>${educationScore}</span></div>
                                                <div class="progress score-progress"><div class="progress-bar bg-info" style="width: ${educationScore}%"></div></div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="d-flex justify-content-between small fw-bold mb-1"><span>Độ đầy đủ CV</span><span>${completenessScore}</span></div>
                                                <div class="progress score-progress"><div class="progress-bar bg-warning" style="width: ${completenessScore}%"></div></div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="d-flex justify-content-between small fw-bold mb-1"><span>Điểm cộng</span><span>${bonusScore}</span></div>
                                                <div class="progress score-progress"><div class="progress-bar bg-secondary" style="width: ${bonusScore}%"></div></div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="d-flex justify-content-between small fw-bold mb-1"><span>Điểm trừ</span><span>${penaltyScore}</span></div>
                                                <div class="progress score-progress"><div class="progress-bar bg-danger" style="width: ${penaltyScore}%"></div></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row g-4">
                            <div class="col-lg-5">
                                <div class="card shadow-sm border-0 rounded-4 h-100">
                                    <div class="card-header bg-white border-0 pt-4 px-4">
                                        <h5 class="fw-bold mb-0"><i class="bi bi-person-vcard text-primary me-2"></i>Thông tin CV đã parse</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div class="mb-3">
                                            <div class="info-label">Họ tên</div>
                                            <div class="fw-bold">${not empty parsedCv.fullName ? parsedCv.fullName : 'Chưa có'}</div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="info-label">Email</div>
                                            <div>${not empty parsedCv.email ? parsedCv.email : 'Chưa có'}</div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="info-label">Số điện thoại</div>
                                            <div>${not empty parsedCv.phone ? parsedCv.phone : 'Chưa có'}</div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="info-label">Địa chỉ</div>
                                            <div>${not empty parsedCv.address ? parsedCv.address : 'Chưa có'}</div>
                                        </div>
                                        <div class="mb-4">
                                            <div class="info-label">File nguồn</div>
                                            <div class="text-muted small">${not empty parsedCv.sourceCvFile ? parsedCv.sourceCvFile : 'Chưa có'}</div>
                                        </div>

                                        <c:set var="cvLink" value="${not empty application.cvFileName ? application.cvFileName : application.user.candidateProfile.cvUrl}" />
                                        <c:if test="${not empty cvLink}">
                                            <a href="/uploads/cv_files/${cvLink}" target="_blank" class="btn btn-outline-primary w-100">
                                                <i class="bi bi-file-earmark-pdf me-1"></i> Mở CV gốc
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-7">
                                <div class="card shadow-sm border-0 rounded-4 mb-4">
                                    <div class="card-header bg-white border-0 pt-4 px-4">
                                        <h5 class="fw-bold mb-0"><i class="bi bi-tools text-primary me-2"></i>Kỹ năng nhận diện</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <c:choose>
                                            <c:when test="${not empty skills}">
                                                <div class="d-flex flex-wrap gap-2">
                                                    <c:forEach var="skill" items="${skills}">
                                                        <span class="badge bg-primary-subtle text-primary border border-primary border-opacity-25 px-3 py-2 rounded-pill skill-badge">
                                                            ${skill.skillName}
                                                        </span>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">AI chưa trả về danh sách kỹ năng.</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="card shadow-sm border-0 rounded-4">
                                    <div class="card-header bg-white border-0 pt-4 px-4">
                                        <h5 class="fw-bold mb-0"><i class="bi bi-file-text text-primary me-2"></i>Nội dung tóm tắt</h5>
                                    </div>
                                    <div class="card-body p-4">
                                        <div class="mb-4">
                                            <div class="info-label mb-2">Tóm tắt</div>
                                            <div class="pre-line">${not empty parsedCv.summary ? parsedCv.summary : 'Chưa có thông tin tóm tắt.'}</div>
                                        </div>
                                        <div class="mb-4">
                                            <div class="info-label mb-2">Học vấn</div>
                                            <div class="pre-line">${not empty parsedCv.education ? parsedCv.education : 'Chưa có thông tin học vấn.'}</div>
                                        </div>
                                        <div>
                                            <div class="info-label mb-2">Kinh nghiệm / Dự án</div>
                                            <div class="pre-line">${not empty parsedCv.experience ? parsedCv.experience : 'Chưa có thông tin kinh nghiệm.'}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <jsp:include page="layout/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
