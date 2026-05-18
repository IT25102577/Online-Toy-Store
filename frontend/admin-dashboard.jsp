<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:include page="admin-header.jsp" />

<h1 class="page-title">Dashboard</h1>
<p class="page-subtitle">Welcome back, Admin! Here's your store overview.</p>

<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon">👥</div>
        <div class="stat-number">${totalUsers}</div>
        <div class="stat-label">Total Users</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">🧸</div>
        <div class="stat-number">${totalToys}</div>
        <div class="stat-label">Total Toys</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">📦</div>
        <div class="stat-number">${totalOrders}</div>
        <div class="stat-label">Total Orders</div>
    </div>
</div>

<div class="section-card">
    <h3>📋 Recent Orders</h3>
    <table>
        <thead>
            <tr><th>Order ID</th><th>Customer</th><th>Date</th><th>Total</th><th>Status</th></tr>
        </thead>
        <tbody>
            <c:forEach items="${recentOrders}" var="order">
                <tr>
                    <td style="font-weight: 700;">#${order.orderId}</td>
                    <td>${order.userName}</td>
                    <td style="color: var(--gray);">${order.orderDate}</td>
                    <td style="font-weight: 700; color: var(--text-dark);">Rs${order.totalAmount}</td>
                    <td><span class="status-badge badge-${order.status}">${order.status}</span></td>
                </tr>
            </c:forEach>
            <c:if test="${empty recentOrders}">
                <tr class="empty-row"><td colspan="5" style="text-align: center; color: var(--gray); padding: 40px;">📭 No orders yet</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<style>
    .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; margin-bottom: 32px; }
    .stat-card {
        background: var(--card-bg); border-radius: 24px; padding: 32px;
        border: 1px solid var(--border); transition: all 0.3s;
        animation: fadeUp 0.6s ease both; box-shadow: 0 8px 32px rgba(0,0,0,0.03);
        backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
    }
    .stat-card:nth-child(2) { animation-delay: 0.1s; }
    .stat-card:nth-child(3) { animation-delay: 0.2s; }
    .stat-card:hover { transform: translateY(-4px); box-shadow: 0 16px 40px rgba(0,0,0,0.06); background: white; }

    .stat-icon { font-size: 40px; margin-bottom: 16px; }
    .stat-number { font-size: 40px; font-weight: 800; color: var(--text-dark); letter-spacing: -1px; }
    .stat-label { color: var(--gray); font-size: 15px; margin-top: 4px; font-weight: 600; }

    .status-badge { padding: 6px 14px; border-radius: 50px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
    .badge-PENDING { background: #FFFBEB; color: #D97706; border: 1px solid #FDE68A; }
    .badge-PROCESSING { background: #EFF6FF; color: #2563EB; border: 1px solid #BFDBFE; }
    .badge-SHIPPED { background: #EEF2FF; color: #4F46E5; border: 1px solid #C7D2FE; }
    .badge-DELIVERED { background: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; }
    .badge-CANCELLED { background: #FEF2F2; color: #DC2626; border: 1px solid #FECACA; }

    @media (max-width: 900px) {
        .stats-grid { grid-template-columns: 1fr; }
    }
</style>

<script>
    document.getElementById('nav-dashboard').classList.add('active');
</script>

<jsp:include page="admin-footer.jsp" />