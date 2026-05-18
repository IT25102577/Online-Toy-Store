<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:include page="admin-header.jsp" />

<h1 class="page-title">⭐ Review Moderation</h1>
<p class="page-subtitle">Approve or reject pending customer reviews</p>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty pendingReviews}">
    <div class="empty-state section-card">
        <div class="icon">✅</div>
        <h3>All caught up!</h3>
        <p>No pending reviews to moderate</p>
    </div>
</c:if>

<c:forEach items="${pendingReviews}" var="review" varStatus="status">
    <div class="review-card section-card" style="animation-delay: ${status.index * 0.1}s">
        <div class="review-header">
            <div class="review-info">
                <h4>Review #${review.id}</h4>
                <div class="review-meta">
                    <span class="meta-item">🧸 Toy ID: ${review.toyId}</span>
                    <span class="meta-item">👤 ${review.userName}</span>
                    <c:choose>
                        <c:when test="${review.isVerified}">
                            <span class="verified-tag verified-yes">✓ Verified Purchase</span>
                        </c:when>
                        <c:otherwise>
                            <span class="verified-tag verified-no">Unverified</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="review-stars">
                <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                        <c:when test="${i <= review.rating}">★</c:when>
                        <c:otherwise>☆</c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </div>

        <div class="review-body">"${review.comment}"</div>

        <div class="review-actions">
            <button class="btn-approve" onclick="moderateReview(${review.id}, 'approve')">✓ Approve</button>
            <button class="btn-reject" onclick="moderateReview(${review.id}, 'reject')">✗ Reject</button>
        </div>
    </div>
</c:forEach>

<style>
    .review-card { padding: 32px; border-left: 6px solid var(--warning); transition: all 0.3s; margin-bottom: 24px; animation: slideIn 0.5s ease both; }
    .review-card:hover { transform: translateX(4px); box-shadow: 0 12px 40px rgba(0,0,0,0.06); background: white; }
    @keyframes slideIn { from { opacity: 0; transform: translateX(-20px); } to { opacity: 1; transform: translateX(0); } }

    .review-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px; }
    .review-info h4 { font-size: 18px; font-weight: 700; color: var(--text-dark); margin-bottom: 8px; letter-spacing: -0.5px; }
    .review-meta { display: flex; gap: 16px; flex-wrap: wrap; }
    .meta-item { font-size: 13px; color: var(--gray); display: flex; align-items: center; font-weight: 600; }

    .review-stars { color: #F59E0B; font-size: 20px; letter-spacing: 2px; }

    .review-body { font-size: 15px; color: var(--text-dark); line-height: 1.7; padding: 20px; background: #F8FAFC; border-radius: 16px; margin-bottom: 24px; font-style: italic; font-weight: 500; border: 1px solid rgba(0,0,0,0.03); }

    .verified-tag { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 8px; font-size: 11px; font-weight: 700; }
    .verified-yes { background: #ECFDF5; color: #059669; }
    .verified-no { background: #FFFBEB; color: #D97706; }

    .review-actions { display: flex; gap: 12px; }
    .btn-approve {
        padding: 12px 24px; border: none; border-radius: 12px;
        background: var(--success); color: white; font-size: 14px; font-weight: 700; cursor: pointer;
        transition: all 0.3s; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
    }
    .btn-approve:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(16, 185, 129, 0.3); background: #059669; }

    .btn-reject {
        padding: 12px 24px; border: none; border-radius: 12px;
        background: #FEF2F2; color: var(--danger); font-size: 14px; font-weight: 700; cursor: pointer;
        transition: all 0.3s;
    }
    .btn-reject:hover { background: #FEE2E2; transform: translateY(-2px); }

    .empty-state { text-align: center; padding: 80px 20px; }
    .empty-state .icon { font-size: 64px; margin-bottom: 20px; }
    .empty-state h3 { font-size: 24px; font-weight: 800; color: var(--text-dark); margin-bottom: 8px; letter-spacing: -0.5px; }
    .empty-state p { color: var(--gray); font-size: 15px; font-weight: 500; }
</style>

<script>
    document.getElementById('nav-reviews').classList.add('active');

    async function moderateReview(reviewId, action) {
        try {
            const response = await fetch('/api/admin/reviews/' + reviewId + '/' + action, { method: 'POST' });
            const data = await response.json();
            if (data.success) {
                showToast('Review ' + action + 'd successfully!', 'success');
                setTimeout(() => location.reload(), 1000);
            } else {
                showToast('Error: ' + data.message, 'error');
            }
        } catch(e) {
            showToast('Failed to ' + action + ' review', 'error');
        }
    }
</script>

<jsp:include page="admin-footer.jsp" />
