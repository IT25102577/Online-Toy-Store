<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<div class="page-container">
    <div class="toy-header glass-panel">
        <div class="emoji">⭐</div>
        <h1>Reviews for ${toy.name}</h1>
    </div>

    <div class="rating-summary glass-panel">
        <div class="big-stars">
            <c:forEach begin="1" end="5" var="i">
                <c:choose>
                    <c:when test="${i <= averageRating}"><span class="star-gold">★</span></c:when>
                    <c:otherwise><span class="star-empty">★</span></c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
        <p class="rating-text">
            ${averageRating} out of 5 <span>• Based on ${reviewCount} review<c:if test="${reviewCount != 1}">s</c:if></span>
        </p>
        <a href="/toys/${toy.id}/write-review" class="btn-write">Write a Review</a>
    </div>

    <c:if test="${not empty reviews}">
        <div class="reviews-list">
            <c:forEach items="${reviews}" var="review" varStatus="status">
                <div class="review-card glass-panel" style="animation-delay: ${status.index * 0.1}s">
                    <div class="review-top">
                        <div class="reviewer">
                            <div class="reviewer-avatar">${review.userName.substring(0,1).toUpperCase()}</div>
                            <div>
                                <div class="reviewer-name">${review.userName}</div>
                                <c:if test="${review.isVerified}">
                                    <span class="verified-badge">✓ Verified Purchase</span>
                                </c:if>
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
                    <div class="review-comment">"${review.comment}"</div>
                    <div class="review-date">Placed on ${review.reviewDate}</div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${empty reviews}">
        <div class="no-reviews glass-panel">
            <div class="icon">💬</div>
            <h3>No reviews yet</h3>
            <p>Be the first to share your experience with this toy!</p>
        </div>
    </c:if>
</div>

<style>
    .page-container { max-width: 800px; margin: 40px auto; padding: 0 40px 60px; animation: fadeIn 0.6s ease; flex: 1; width: 100%; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

    .toy-header { text-align: center; padding: 40px; margin-bottom: 24px; border-radius: 24px; }
    .toy-header .emoji { font-size: 56px; margin-bottom: 16px; animation: bounce 2s ease-in-out infinite; display: inline-block; }
    @keyframes bounce { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-10px); } }
    .toy-header h1 { font-size: 32px; font-weight: 800; color: var(--text-main); letter-spacing: -1px; }

    .rating-summary { padding: 40px; text-align: center; margin-bottom: 32px; border-radius: 24px; }
    .big-stars { font-size: 40px; letter-spacing: 6px; margin-bottom: 12px; }
    .star-gold { color: #F59E0B; }
    .star-empty { color: #E2E8F0; }
    .rating-text { font-size: 18px; font-weight: 700; color: var(--text-main); }
    .rating-text span { color: var(--text-muted); font-weight: 500; font-size: 14px; display: block; margin-top: 4px; }

    .btn-write {
        display: inline-block; padding: 14px 32px; border-radius: 50px;
        background: var(--primary); color: white; text-decoration: none; font-weight: 700; font-size: 15px;
        transition: all 0.3s; margin-top: 24px; box-shadow: 0 8px 24px rgba(79, 70, 229, 0.25);
    }
    .btn-write:hover { transform: translateY(-3px); box-shadow: 0 12px 32px rgba(79, 70, 229, 0.35); background: var(--primary-hover); }

    .reviews-list { display: flex; flex-direction: column; gap: 24px; }

    .review-card { padding: 32px; border-radius: 24px; transition: all 0.3s; animation: fadeIn 0.5s ease both; }
    .review-card:hover { transform: translateY(-4px); box-shadow: 0 12px 40px rgba(0,0,0,0.06); background: white; }
    
    .review-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
    .reviewer { display: flex; align-items: center; gap: 16px; }
    .reviewer-avatar {
        width: 48px; height: 48px; border-radius: 50%;
        background: var(--primary);
        display: flex; align-items: center; justify-content: center;
        font-size: 16px; font-weight: 700; color: white; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
    }
    .reviewer-name { font-weight: 700; font-size: 16px; color: var(--text-main); margin-bottom: 4px; }
    .verified-badge { display: inline-flex; align-items: center; gap: 4px; font-size: 12px; color: var(--secondary); background: #ECFDF5; padding: 4px 10px; border-radius: 8px; font-weight: 600; }
    .review-stars { color: #F59E0B; font-size: 16px; letter-spacing: 2px; }
    
    .review-comment { font-size: 16px; line-height: 1.7; color: var(--text-muted); margin-bottom: 16px; font-style: italic; }
    .review-date { font-size: 13px; color: #94A3B8; font-weight: 500; }

    .no-reviews { text-align: center; padding: 80px 20px; border-radius: 24px; }
    .no-reviews .icon { font-size: 64px; margin-bottom: 20px; }
    .no-reviews h3 { font-size: 24px; font-weight: 800; color: var(--text-main); margin-bottom: 8px; }
    .no-reviews p { color: var(--text-muted); font-size: 16px; }
</style>

<jsp:include page="footer.jsp" />
