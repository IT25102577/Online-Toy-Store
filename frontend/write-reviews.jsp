<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<div class="page-container">
    <div class="review-form glass-panel">
        <h1>Write a Review</h1>
        <p class="toy-name">for ${toy.name}</p>

        <div class="form-group">
            <label>Your Rating</label>
            <div class="star-rating" id="starContainer">
                <span class="star" data-value="1">★</span>
                <span class="star" data-value="2">★</span>
                <span class="star" data-value="3">★</span>
                <span class="star" data-value="4">★</span>
                <span class="star" data-value="5">★</span>
            </div>
            <input type="hidden" id="ratingValue">
        </div>

        <div class="form-group">
            <label>Your Review</label>
            <textarea id="commentText" placeholder="Share your experience with this toy... What did you like? Would you recommend it?" maxlength="500" oninput="updateCharCount()"></textarea>
            <div class="char-counter"><span id="charCount">0</span>/500</div>
        </div>

        <button class="btn-submit" id="submitBtn" onclick="submitReview()">Submit Review</button>
    </div>
</div>

<style>
    .page-container { max-width: 600px; margin: 40px auto; padding: 0 40px 60px; animation: fadeIn 0.6s ease; flex: 1; width: 100%; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

    .review-form { padding: 40px; border-radius: 24px; }
    .review-form h1 { font-size: 28px; font-weight: 800; color: var(--text-main); margin-bottom: 4px; letter-spacing: -1px; }
    .toy-name { color: var(--primary); font-size: 16px; font-weight: 600; margin-bottom: 32px; }

    .form-group { margin-bottom: 32px; }
    .form-group label { display: block; font-size: 15px; font-weight: 600; margin-bottom: 12px; color: var(--text-main); }

    .star-rating { display: flex; gap: 8px; }
    .star-rating .star {
        font-size: 48px; cursor: pointer; color: rgba(0,0,0,0.1);
        transition: all 0.2s ease; user-select: none; text-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .star-rating .star:hover, .star-rating .star.active { color: #F59E0B; transform: scale(1.1); text-shadow: 0 4px 12px rgba(245, 158, 11, 0.3); }
    .star-rating .star.hover-preview { color: #FCD34D; opacity: 0.8; }

    .form-group textarea {
        width: 100%; padding: 20px; min-height: 160px; resize: vertical;
        background: white; border: 1px solid rgba(0,0,0,0.05);
        border-radius: 16px; font-size: 15px; color: var(--text-main);
        outline: none; transition: all 0.3s; line-height: 1.6; font-weight: 500;
        box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);
    }
    .form-group textarea:focus { border-color: var(--primary); box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1); }
    .char-counter { text-align: right; font-size: 13px; color: var(--text-muted); margin-top: 8px; font-weight: 500; }

    .btn-submit {
        width: 100%; padding: 18px; border: none; border-radius: 50px;
        background: var(--primary); color: white; font-size: 16px; font-weight: 700; cursor: pointer;
        transition: all 0.3s; box-shadow: 0 8px 24px rgba(79, 70, 229, 0.25);
    }
    .btn-submit:hover { transform: translateY(-3px); box-shadow: 0 12px 32px rgba(79, 70, 229, 0.35); background: var(--primary-hover); }
    .btn-submit.loading { pointer-events: none; opacity: 0.7; transform: none; box-shadow: none; }
</style>

<script>
    const stars = document.querySelectorAll('.star');
    const ratingInput = document.getElementById('ratingValue');
    let selectedRating = 0;

    stars.forEach(star => {
        star.addEventListener('mouseenter', function() {
            const val = parseInt(this.dataset.value);
            stars.forEach(s => {
                s.classList.toggle('hover-preview', parseInt(s.dataset.value) <= val && parseInt(s.dataset.value) > selectedRating);
            });
        });

        star.addEventListener('click', function() {
            selectedRating = parseInt(this.dataset.value);
            ratingInput.value = selectedRating;
            stars.forEach(s => {
                s.classList.toggle('active', parseInt(s.dataset.value) <= selectedRating);
                s.classList.remove('hover-preview');
            });
        });
    });

    document.getElementById('starContainer').addEventListener('mouseleave', () => {
        stars.forEach(s => s.classList.remove('hover-preview'));
    });

    function updateCharCount() {
        document.getElementById('charCount').textContent = document.getElementById('commentText').value.length;
    }

    async function submitReview() {
        const rating = ratingInput.value;
        const comment = document.getElementById('commentText').value.trim();
        const btn = document.getElementById('submitBtn');
        const toyId = ${toy.id};

        if (!rating) { if(typeof showToast === 'function') showToast('Please select a star rating', true); return; }
        if (!comment) { if(typeof showToast === 'function') showToast('Please write your review', true); return; }

        btn.classList.add('loading'); btn.textContent = 'Submitting...';

        try {
            const params = new URLSearchParams();
            params.append('toyId', toyId);
            params.append('rating', rating);
            params.append('comment', comment);

            const response = await fetch('/api/reviews', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            });
            const data = await response.json();

            if (data.success) {
                if(typeof showToast === 'function') showToast('Review submitted! Awaiting approval.');
                setTimeout(() => window.location.href = '/toys/' + toyId + '/reviews', 2000);
            } else {
                if(typeof showToast === 'function') showToast(data.message, true);
                btn.classList.remove('loading'); btn.textContent = 'Submit Review';
            }
        } catch(e) {
            if(typeof showToast === 'function') showToast('Error submitting review', true);
            btn.classList.remove('loading'); btn.textContent = 'Submit Review';
        }
    }
</script>

<jsp:include page="footer.jsp" />
