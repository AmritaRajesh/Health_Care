<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Analytics - Admin Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<style>
.section-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 24px; }
.section-title { font-weight: 700; color: #1e293b; font-size: 1rem; margin-bottom: 20px; }
.stat-pill { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 14px 18px; text-align: center; }
.stat-pill .val { font-size: 1.6rem; font-weight: 700; color: #1e293b; }
.stat-pill .lbl { font-size: 0.75rem; color: #94a3b8; font-weight: 600; text-transform: uppercase; }
.table th { color: #64748b; font-size: 0.78rem; font-weight: 700; text-transform: uppercase; padding: 12px 16px; border-top: none; border-bottom: 1px solid #f1f5f9; }
.table td { padding: 12px 16px; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
.progress { height: 8px; border-radius: 4px; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Reports & Analytics</h1>
    <p class="page-subtitle">Hospital performance metrics and trend analysis</p>

    <!-- Summary Pills -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-2"><div class="stat-pill"><div class="val">${stats.doctors != null ? stats.doctors : 0}</div><div class="lbl">Doctors</div></div></div>
        <div class="col-6 col-md-2"><div class="stat-pill"><div class="val">${stats.patients != null ? stats.patients : 0}</div><div class="lbl">Patients</div></div></div>
        <div class="col-6 col-md-2"><div class="stat-pill"><div class="val">${stats.appointments != null ? stats.appointments : 0}</div><div class="lbl">Appointments</div></div></div>
        <div class="col-6 col-md-2"><div class="stat-pill"><div class="val">${stats.departments != null ? stats.departments : 0}</div><div class="lbl">Departments</div></div></div>
        <div class="col-6 col-md-2"><div class="stat-pill"><div class="val">₹${stats.revenue != null ? stats.revenue : 0}</div><div class="lbl">Revenue</div></div></div>
        <div class="col-6 col-md-2"><div class="stat-pill"><div class="val text-danger">₹${stats.unpaid != null ? stats.unpaid : 0}</div><div class="lbl">Dues</div></div></div>
    </div>

    <div class="row g-4">
        <!-- Monthly Chart -->
        <div class="col-md-7">
            <div class="section-card">
                <div class="section-title"><i class="fa-solid fa-chart-bar text-primary me-2"></i>Monthly Appointments (Last 6 Months)</div>
                <canvas id="monthlyChart" height="120"></canvas>
            </div>
        </div>

        <!-- Monthly Table -->
        <div class="col-md-5">
            <div class="section-card">
                <div class="section-title"><i class="fa-solid fa-table text-secondary me-2"></i>Monthly Breakdown</div>
                <table class="table mb-0">
                    <thead><tr><th>Month</th><th>Total</th><th>Completed</th><th>Pending</th></tr></thead>
                    <tbody>
                        <c:forEach var="m" items="${monthlyData}">
                            <tr>
                                <td class="fw-bold">${m.month}</td>
                                <td>${m.total}</td>
                                <td class="text-success fw-bold">${m.completed}</td>
                                <td class="text-warning fw-bold">${m.pending}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty monthlyData}"><tr><td colspan="4" class="text-center text-muted">No data yet.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Doctor Performance -->
        <div class="col-12">
            <div class="section-card">
                <div class="section-title"><i class="fa-solid fa-ranking-star text-warning me-2"></i>Doctor Performance</div>
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead><tr><th>Doctor</th><th>Specialization</th><th>Total Appointments</th><th>Completed</th><th>Completion Rate</th></tr></thead>
                        <tbody>
                            <c:forEach var="p" items="${performanceData}">
                                <tr>
                                    <td class="fw-bold text-dark">Dr. ${p.name}</td>
                                    <td><span class="badge" style="background:#ede9fe;color:#6d28d9;">${p.spec}</span></td>
                                    <td>${p.total}</td>
                                    <td class="text-success fw-bold">${p.completed}</td>
                                    <td>
                                        <c:set var="rate" value="${p.total > 0 ? (p.completed * 100 / p.total) : 0}"/>
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="progress flex-grow-1"><div class="progress-bar bg-success" style="width:${rate}%"></div></div>
                                            <span class="text-muted small">${rate}%</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty performanceData}"><tr><td colspan="5" class="text-center text-muted">No data yet.</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</div></div>
<script>
var labels = [<c:forEach var="m" items="${monthlyData}" varStatus="s">'${m.month}'<c:if test="${!s.last}">,</c:if></c:forEach>];
var totals = [<c:forEach var="m" items="${monthlyData}" varStatus="s">${m.total}<c:if test="${!s.last}">,</c:if></c:forEach>];
var completed = [<c:forEach var="m" items="${monthlyData}" varStatus="s">${m.completed}<c:if test="${!s.last}">,</c:if></c:forEach>];
new Chart(document.getElementById('monthlyChart'), {
    type: 'bar',
    data: {
        labels: labels,
        datasets: [
            { label: 'Total', data: totals, backgroundColor: 'rgba(99,102,241,0.7)', borderRadius: 6 },
            { label: 'Completed', data: completed, backgroundColor: 'rgba(16,185,129,0.7)', borderRadius: 6 }
        ]
    },
    options: { responsive: true, plugins: { legend: { position: 'top' } }, scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } } }
});
</script>
</body>
</html>
