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
        // --- DỮ LIỆU MẪU (CHỈ DÀNH CHO BIỂU ĐỒ ĐƯỜNG - TĂNG TRƯỞNG) ---
        // Sẽ được thay thế bằng API thực tế ở các bước tiếp theo
        const mockData = {
            month: {
                labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
                users: [12, 19, 30, 45, 60, 80],
                jobs: [5, 10, 15, 25, 30, 40],
                cvs: [10, 25, 40, 80, 120, 150]
            },
            day: {
                labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'],
                users: [2, 5, 3, 8, 4, 10, 12],
                jobs: [1, 2, 0, 4, 2, 5, 1],
                cvs: [5, 8, 12, 6, 9, 20, 15]
            }
        };

        let growthChartInstance = null;
        let categoryChartInstance = null;

        // Khởi tạo cả 2 biểu đồ khi trang vừa load xong
        document.addEventListener("DOMContentLoaded", function() {
            initGrowthChart('month');
            initCategoryChart(); // Gọi hàm vẽ biểu đồ ngành nghề (đã nối API)
        });

        // 1. BIỂU ĐỒ ĐƯỜNG (Vẫn dùng Mock Data tạm thời)
        function initGrowthChart(viewType) {
            const ctx = document.getElementById('growthChart').getContext('2d');
            const dataToUse = mockData[viewType];

            if (growthChartInstance) {
                growthChartInstance.destroy();
            }

            growthChartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: dataToUse.labels,
                    datasets: [
                        { label: 'Lượt ứng tuyển (CV)', data: dataToUse.cvs, borderColor: '#ffc107', backgroundColor: 'rgba(255, 193, 7, 0.1)', borderWidth: 2, fill: true, tension: 0.4 },
                        { label: 'Tin tuyển dụng', type: 'bar', data: dataToUse.jobs, backgroundColor: '#198754', borderRadius: 5 },
                        { label: 'Người dùng mới', type: 'bar', data: dataToUse.users, backgroundColor: '#0d6efd', borderRadius: 5 }
                    ]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    interaction: { mode: 'index', intersect: false },
                    plugins: { tooltip: { padding: 10 } },
                    scales: {
                        y: { beginAtZero: true, grid: { borderDash: [5, 5] } },
                        x: { grid: { display: false } }
                    },
                    onClick: (e, activeEls) => {
                        if (activeEls.length > 0) {
                            const dataIndex = activeEls[0].index;
                            const clickedLabel = dataToUse.labels[dataIndex];
                            
                            // Drill-down giả lập
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

       // 2. BIỂU ĐỒ TRÒN (ĐÃ KẾT NỐI API THẬT & CÓ PHẦN TRĂM)
        function initCategoryChart() {
            Chart.register(ChartDataLabels);

            fetch('/api/admin/chart/categories')
                .then(response => {
                    if (!response.ok) throw new Error("Lỗi mạng hoặc chưa đăng nhập Admin");
                    return response.json();
                })
                .then(data => {
                    const container = document.getElementById('categoryChart').parentElement;

                    // BỔ SUNG: KIỂM TRA NẾU DỮ LIỆU RỖNG (Do chưa có Job nào được gán Ngành)
                    if (!data.labels || data.labels.length === 0) {
                        container.innerHTML = '<div class="d-flex h-100 align-items-center justify-content-center text-muted fst-italic"><i class="bi bi-inbox me-2"></i> Chưa có dữ liệu ngành nghề</div>';
                        return; // Dừng việc vẽ biểu đồ
                    }

                    const ctx = document.getElementById('categoryChart').getContext('2d');
                    
                    if(categoryChartInstance) {
                        categoryChartInstance.destroy();
                    }

                    categoryChartInstance = new Chart(ctx, {
                        type: 'doughnut',
                        data: {
                            labels: data.labels, 
                            datasets: [{
                                data: data.values, 
                                backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#dc3545', '#6610f2', '#0dcaf0', '#adb5bd'],
                                borderWidth: 0,
                                hoverOffset: 4
                            }]
                        },
                        options: {
                            responsive: true, 
                            maintainAspectRatio: false,
                            layout: {
                                padding: 25 
                            },
                            plugins: { 
                                legend: { position: 'bottom' },
                                datalabels: {
                                    color: '#ffffff',
                                    font: { weight: 'bold', size: 12 },
                                    formatter: (value, ctx) => {
                                        let sum = 0;
                                        let dataArr = ctx.chart.data.datasets[0].data;
                                        dataArr.map(data => { sum += data; });
                                        
                                        if (sum === 0) return "0%";
                                        let percentage = (value * 100 / sum).toFixed(1) + "%";
                                        return percentage;
                                    }
                                }
                            }
                        }
                    });
                })
                .catch(error => {
                    console.error('Lỗi khi tải dữ liệu Ngành nghề:', error);
                    const container = document.getElementById('categoryChart').parentElement;
                    container.innerHTML = '<div class="d-flex h-100 align-items-center justify-content-center text-danger"><i class="bi bi-exclamation-triangle me-2"></i> Lỗi tải dữ liệu</div>';
                });
        }

        // Hàm hỗ trợ lọc
        function updateCharts() {
            const viewType = document.getElementById('timeViewType').value;
            const specificDateInput = document.getElementById('specificDate');
            
            if(viewType === 'day') specificDateInput.classList.remove('d-none');
            else specificDateInput.classList.add('d-none');

            document.getElementById('mainChartTitle').innerText = 'Tăng trưởng Người dùng & Việc làm';
            initGrowthChart(viewType === 'day' ? 'day' : 'month'); 
        }

        function resetView() {
            document.getElementById('timeViewType').value = 'month';
            updateCharts();
        }
    </script>
</body>
</html>