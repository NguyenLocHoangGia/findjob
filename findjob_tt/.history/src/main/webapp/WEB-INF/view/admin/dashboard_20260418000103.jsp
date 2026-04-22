<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - JobPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>
    <style>
        body { background-color: #f4f7fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .stat-card { border: none; border-radius: 15px; transition: transform 0.3s; }
        .stat-card:hover { transform: translateY(-5px); }
        .icon-box { width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; }
        .chart-container { position: relative; height: 350px; width: 100%; }
        .filter-group { background: white; padding: 15px; border-radius: 12px; box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); }
    </style>
</head>
<body>

    <jsp:include page="layout/header.jsp" />

    <div class="container my-5" style="padding-top: 20px;">
        <h2 class="fw-bold mb-4 text-dark"><i class="bi bi-speedometer2 text-primary me-2"></i>Bảng điều khiển Tổng quan</h2>
        
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card stat-card shadow-sm bg-white p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted fw-bold mb-1 text-uppercase" style="font-size: 0.85rem;">Tổng người dùng</p>
                            <h2 class="fw-bold mb-0 text-dark">${totalUsers}</h2>
                        </div>
                        <div class="icon-box bg-primary bg-opacity-10 text-primary"><i class="bi bi-people-fill"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card shadow-sm bg-white p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted fw-bold mb-1 text-uppercase" style="font-size: 0.85rem;">Tin tuyển dụng</p>
                            <h2 class="fw-bold mb-0 text-dark">${totalJobs}</h2>
                        </div>
                        <div class="icon-box bg-success bg-opacity-10 text-success"><i class="bi bi-briefcase-fill"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card shadow-sm bg-white p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted fw-bold mb-1 text-uppercase" style="font-size: 0.85rem;">Lượt ứng tuyển (CV)</p>
                            <h2 class="fw-bold mb-0 text-dark">${totalApplications}</h2>
                        </div>
                        <div class="icon-box bg-warning bg-opacity-10 text-warning"><i class="bi bi-file-earmark-person-fill"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="filter-group d-flex align-items-center gap-3 mb-4">
            <span class="fw-bold text-muted"><i class="bi bi-funnel-fill me-1"></i> Lọc dữ liệu:</span>
            <select id="timeViewType" class="form-select w-auto fw-medium shadow-none" onchange="updateCharts()">
                <option value="day">Hiển thị theo Ngày (Trong tuần)</option>
                <option value="month" selected>Hiển thị theo Tháng (Trong năm)</option>
                <option value="quarter">Hiển thị theo Quý</option>
                <option value="year">Hiển thị theo Năm</option>
            </select>
            <input type="date" id="specificDate" class="form-control w-auto shadow-none d-none" onchange="fetchDataBySpecificDate()">
            <button class="btn btn-outline-primary ms-auto btn-sm" onclick="resetView()"><i class="bi bi-arrow-counterclockwise"></i> Đặt lại</button>
        </div>

        <div class="row g-4">
            <div class="col-md-8">
                <div class="card shadow-sm border-0 rounded-4 h-100">
                    <div class="card-body p-4">
                        <h5 class="fw-bold text-dark mb-4" id="mainChartTitle">Tăng trưởng Người dùng & Việc làm</h5>
                        <div class="chart-container">
                            <canvas id="growthChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm border-0 rounded-4 h-100">
                    <div class="card-body p-4">
                        <h5 class="fw-bold text-dark mb-4">Ngành nghề được quan tâm</h5>
                        <div class="chart-container" style="height: 300px;">
                            <canvas id="categoryChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let growthChartInstance = null;
        let categoryChartInstance = null;

        function showToast(message, type) {
            const toastType = type || 'danger';
            const containerId = 'dashboardToastContainer';
            let container = document.getElementById(containerId);

            if (!container) {
                container = document.createElement('div');
                container.id = containerId;
                container.className = 'toast-container position-fixed top-0 end-0 p-3';
                container.style.zIndex = '2000';
                document.body.appendChild(container);
            }

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
            const bsToast = new bootstrap.Toast(toastEl, { delay: 2500 });
            bsToast.show();
            toastEl.addEventListener('hidden.bs.toast', function () {
                toastEl.remove();
            });
        }

        // Khởi tạo biểu đồ khi trang vừa load
        document.addEventListener("DOMContentLoaded", function() {
            updateCharts();
            initCategoryChart();
        });

        // Hàm fetch dữ liệu từ API
        async function fetchGrowthData(viewType) {
            try {
                const response = await fetch('/api/admin/chart/growth?viewType=' + viewType);
                if (!response.ok) throw new Error('Network response was not ok');
                return await response.json();
            } catch (error) {
                console.error('Error fetching growth data:', error);
                return null;
            }
        }

        async function fetchCategoryData() {
            try {
                const response = await fetch('/api/admin/chart/categories');
                if (!response.ok) throw new Error('Network response was not ok');
                return await response.json();
            } catch (error) {
                console.error('Error fetching category data:', error);
                return null;
            }
        }

        // Hàm vẽ biểu đồ Tăng trưởng (Đường & Cột kết hợp)
        async function initGrowthChart(viewType) {
            const ctx = document.getElementById('growthChart').getContext('2d');
            const dataToUse = await fetchGrowthData(viewType);

            if (!dataToUse) {
                showToast('Không thể tải dữ liệu biểu đồ. Vui lòng thử lại.', 'danger');
                return;
            }

            if (growthChartInstance) {
                growthChartInstance.destroy(); // Hủy biểu đồ cũ trước khi vẽ mới
            }

            growthChartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: dataToUse.labels,
                    datasets: [
                        {
                            label: 'Lượt ứng tuyển (CV)',
                            data: dataToUse.cvs,
                            borderColor: '#ffc107',
                            backgroundColor: 'rgba(255, 193, 7, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            tension: 0.4 // Làm cong đường nối
                        },
                        {
                            label: 'Tin tuyển dụng',
                            type: 'bar',
                            data: dataToUse.jobs,
                            backgroundColor: '#198754',
                            borderRadius: 5
                        },
                        {
                            label: 'Người dùng mới',
                            type: 'bar',
                            data: dataToUse.users,
                            backgroundColor: '#0d6efd',
                            borderRadius: 5
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: { mode: 'index', intersect: false },
                    plugins: { tooltip: { padding: 10 } },
                    scales: {
                        y: { beginAtZero: true, grid: { borderDash: [5, 5] } },
                        x: { grid: { display: false } }
                    },
                    // SỰ KIỆN CLICK (DRILL-DOWN)
                    onClick: (e, activeEls) => {
                        if (activeEls.length > 0) {
                            const dataIndex = activeEls[0].index;
                            const clickedLabel = dataToUse.labels[dataIndex];
                            showToast('Bạn vừa bấm vào: ' + clickedLabel + '. Khu vực drill-down sẽ được mở rộng ở bước tiếp theo.', 'info');
                            
                            // Ví dụ logic: Nếu đang xem Tháng, bấm vào sẽ nhảy sang xem Ngày của tháng đó
                            if(viewType === 'month') {
                                document.getElementById('timeViewType').value = 'day';
                                updateCharts();
                                document.getElementById('mainChartTitle').innerText = 'Dữ liệu chi tiết của ' + clickedLabel;
                            }
                        }
                    }
                }
            });
        }

        // Hàm vẽ biểu đồ Tròn (Ngành nghề)
        async function initCategoryChart() {
            const ctx = document.getElementById('categoryChart').getContext('2d');
            const dataToUse = await fetchCategoryData();

            if (!dataToUse) {
                showToast('Không thể tải dữ liệu biểu đồ ngành nghề. Vui lòng thử lại.', 'danger');
                return;
            }

            categoryChartInstance = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: dataToUse.labels,
                    datasets: [{
                        data: dataToUse.values,
                        backgroundColor: ['#0d6efd', '#6610f2', '#198754', '#ffc107', '#dc3545'],
                        borderWidth: 0,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { position: 'bottom' } }
                }
            });
        }

        // Hàm cập nhật khi đổi bộ lọc
        async function updateCharts() {
            const viewType = document.getElementById('timeViewType').value;
            const specificDateInput = document.getElementById('specificDate');
            
            // Hiện ô chọn ngày cụ thể nếu muốn
            if(viewType === 'day') {
                specificDateInput.classList.remove('d-none');
            } else {
                specificDateInput.classList.add('d-none');
            }

            document.getElementById('mainChartTitle').innerText = 'Tăng trưởng Người dùng & Việc làm';
            await initGrowthChart(viewType);
        }

        function resetView() {
            document.getElementById('timeViewType').value = 'month';
            updateCharts();
        }
    </script>
</body>
</html>