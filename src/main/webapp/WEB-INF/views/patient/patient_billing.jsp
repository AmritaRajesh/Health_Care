<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Billing & Payments - Hospital Management</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
.summary-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; }
.due-amount { font-size: 2.2rem; font-weight: 700; color: #ef4444; }
.due-label { color: #64748b; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
.due-icon { width: 56px; height: 56px; background: #fee2e2; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 1.6rem; color: #ef4444; }
.content-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; }
.table th { color: #64748b; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; padding: 14px 18px; border-top: none; border-bottom: 1px solid #f1f5f9; }
.table td { padding: 14px 18px; vertical-align: middle; color: #334155; border-bottom: 1px solid #f1f5f9; }
.s-unpaid { background: #fef2f2; color: #dc2626; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
.s-paid { background: #ecfdf5; color: #059669; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
.btn-pay { background: #3b82f6; color: white; border: none; padding: 7px 16px; border-radius: 8px; font-size: 0.85rem; font-weight: 600; cursor: pointer; transition: 0.2s; }
.btn-pay:hover { background: #2563eb; }
.empty-state { text-align: center; padding: 50px; color: #94a3b8; }
/* Modal */
.modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center; }
.modal-overlay.show { display: flex; }
.modal-box { background: white; border-radius: 16px; padding: 32px; max-width: 420px; width: 90%; text-align: center; }
.modal-amount { font-size: 2rem; font-weight: 700; color: #1e293b; margin: 12px 0; }
.btn-confirm { background: #10b981; color: white; border: none; padding: 12px 28px; border-radius: 8px; font-weight: 700; font-size: 1rem; cursor: pointer; width: 100%; margin-top: 10px; }
.btn-cancel-modal { background: none; border: 1px solid #e2e8f0; color: #64748b; padding: 10px 28px; border-radius: 8px; font-weight: 600; cursor: pointer; width: 100%; margin-top: 8px; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp" />

    <h1 class="page-title">Billing & Payments</h1>
    <p class="page-subtitle">View your bills and make payments</p>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">${successMsg}</div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger">${errorMsg}</div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>

    <!-- Summary -->
    <div class="summary-card">
        <div>
            <div class="due-label">Total Amount Due</div>
            <div class="due-amount">₹<fmt:formatNumber value="${totalDue}" pattern="#,##0.00"/></div>
        </div>
        <div class="due-icon"><i class="fa-solid fa-file-invoice-dollar"></i></div>
    </div>

    <!-- Bills Table -->
    <div class="content-card">
        <h5 class="fw-bold text-dark mb-4"><i class="fa-solid fa-receipt text-primary me-2"></i>Payment History</h5>
        <c:if test="${empty billList}">
            <div class="empty-state">
                <i class="fa-solid fa-file-invoice fs-1 mb-3"></i>
                <h5 class="fw-bold">No Bills Found</h5>
                <p>Your billing history will appear here.</p>
            </div>
        </c:if>
        <c:if test="${not empty billList}">
        <div class="table-responsive">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Description</th>
                        <th>Doctor</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${billList}" varStatus="s">
                        <tr>
                            <td class="text-muted">${s.count}</td>
                            <td class="fw-bold">${b.description}</td>
                            <td>Dr. ${b.doctorName}</td>
                            <td class="fw-bold text-dark">₹<fmt:formatNumber value="${b.amount}" pattern="#,##0.00"/></td>
                            <td><span class="s-${b.status}">${b.status}</span></td>
                            <td class="text-muted small">${b.createdAt}</td>
                            <td>
                                <c:if test="${b.status eq 'unpaid'}">
                                    <button class="btn-pay" onclick="openPayModal(${b.id}, '${b.description}', ${b.amount})">
                                        <i class="fa-solid fa-credit-card me-1"></i>Pay Now
                                    </button>
                                </c:if>
                                <c:if test="${b.status eq 'paid'}">
                                    <span class="text-muted small"><i class="fa-solid fa-check-circle text-success me-1"></i>${b.paidAt}</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        </c:if>
    </div>

</div></div>

<!-- Payment Modal -->
<div class="modal-overlay" id="payModal">
    <div class="modal-box">
        <i class="fa-solid fa-credit-card fs-1 text-primary mb-2"></i>
        <h5 class="fw-bold text-dark" id="modalDesc">Confirm Payment</h5>
        <div class="modal-amount" id="modalAmt"></div>
        <p class="text-muted small">This is a simulated payment. Click confirm to mark as paid.</p>
        <form action="${pageContext.request.contextPath}/patient/billing" method="post">
            <input type="hidden" name="billId" id="modalBillId">
            <button type="submit" class="btn-confirm"><i class="fa-solid fa-check me-2"></i>Confirm Payment</button>
        </form>
        <button class="btn-cancel-modal" onclick="closePayModal()">Cancel</button>
    </div>
</div>

<script>
function openPayModal(id, desc, amt) {
    document.getElementById('modalBillId').value = id;
    document.getElementById('modalDesc').textContent = desc;
    document.getElementById('modalAmt').textContent = '₹' + parseFloat(amt).toFixed(2);
    document.getElementById('payModal').classList.add('show');
}
function closePayModal() {
    document.getElementById('payModal').classList.remove('show');
}
</script>
</body>
</html>
