<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:include page="header.jsp" />

    <div class="browse-header">
        <h1>Explore Our Collection</h1>
        <p>Find the perfect toy to spark creativity and joy</p>
    </div>

    <!-- SEARCH & FILTER -->
    <div class="search-section">
        <div class="search-container">
            <div class="search-bar glass-panel">
                <span class="search-icon">🔍</span>
                <input type="text" id="searchInput" placeholder="Search for amazing toys..." oninput="searchToys()">
            </div>
            <div class="filter-pills">
                <div class="pill active" onclick="filterCategory(this, '')">All Toys</div>
                <div class="pill" onclick="filterCategory(this, 'Stuffed')">🧸 Stuffed</div>
                <div class="pill" onclick="filterCategory(this, 'Electronic')">🔌 Electronic</div>
                <div class="pill" onclick="filterCategory(this, 'Educational')">📚 Educational</div>
                <div class="pill" onclick="filterCategory(this, 'Dolls')">👧 Dolls</div>
                <div class="pill" onclick="filterCategory(this, 'Vehicles')">🚗 Vehicles</div>
                <div class="pill" onclick="filterCategory(this, 'Puzzles')">🧩 Puzzles</div>
            </div>
        </div>
    </div>

    <!-- TOY GRID -->
    <div class="container">
        <div id="resultsInfo" class="results-info"></div>
        <div id="toysList" class="toys-grid"></div>
    </div>

    <!-- ============================================
         TOY DETAILS MODAL
         ============================================ -->
    <div id="toyModal" class="modal-overlay" onclick="closeModal(event)">
        <div class="modal-content">
            <button class="modal-close" onclick="closeModal(event, true)">✕</button>
            
            <div class="modal-grid">
                <!-- Left: Image -->
                <div class="modal-image-col">
                    <div id="modalImageContainer"></div>
                </div>
                
                <!-- Right: Info -->
                <div class="modal-info-col">
                    <div class="modal-breadcrumbs" id="modalBreadcrumbs">Category > Subcategory</div>
                    <h2 class="modal-title" id="modalTitle">Toy Name</h2>
                    
                    <div class="modal-price-row">
                        <div class="modal-price"><span class="currency">Rs</span><span id="modalPrice">0.00</span></div>
                        <div class="modal-stock" id="modalStock">IN STOCK</div>
                    </div>
                    
                    <p class="modal-desc" id="modalDesc">Toy description goes here...</p>
                    
                    <div class="modal-actions">
                        <button class="btn-block-primary" id="modalAddToCart" onclick="addModalToyToCart()">Add to Cart</button>
                    </div>
                    
                    <div class="shipping-info">
                        <div class="icon">🚚</div>
                        <div>
                            <p>Free Premium Shipping</p>
                            <span>On orders over Rs150</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom: Reviews -->
            <div class="modal-reviews">
                <div class="modal-reviews-header">
                    <h3>Customer Reviews</h3>
                    <div class="overall-rating" id="modalOverallRating"></div>
                </div>
                <div class="reviews-grid" id="modalReviewsGrid">
                    <!-- Reviews populated via JS -->
                </div>
            </div>
        </div>
    </div>

    <script>
        let allToys = [];
        let currentFilter = '';
        let currentModalToyId = null;

        const toyEmojis = {
            'Stuffed': '🧸', 'Electronic': '🎮', 'Educational': '📚',
            'Dolls': '👧', 'Vehicles': '🚗', 'Puzzles': '🧩', 'default': '🎁'
        };

        // Initialize
        async function loadToys() {
            try {
                const response = await fetch('/api/toys');
                allToys = await response.json();
                
                // Handle URL Parameters
                const urlParams = new URLSearchParams(window.location.search);
                const catParam = urlParams.get('category');
                const idParam = urlParams.get('id');

                if (catParam) {
                    currentFilter = catParam;
                    // Update UI pills
                    document.querySelectorAll('.pill').forEach(p => {
                        if (p.textContent.includes(catParam)) p.classList.add('active');
                        else p.classList.remove('active');
                    });
                }

                renderToys(allToys); // Initial render with possible filter

                if (idParam) {
                    const toyId = parseInt(idParam);
                    setTimeout(() => openModal(toyId), 500); // Small delay to ensure render
                }
            } catch(e) {
                document.getElementById('toysList').innerHTML = '<p>Failed to load toys. Please refresh.</p>';
            }
        }

        // Render Cards
        function renderToys(toys) {
            const container = document.getElementById('toysList');
            document.getElementById('resultsInfo').textContent = toys.length + ' products found';

            container.innerHTML = toys.map((toy, index) => {
                const emoji = toyEmojis[toy.category] || toyEmojis['default'];
                const imgHtml = (toy.imageUrl && toy.imageUrl.trim() !== '') ? 
                    '<img src="' + toy.imageUrl + '" alt="' + toy.name + '">' : '<div style="font-size:80px">' + emoji + '</div>';
                
                // Clicking the card opens the modal. We prevent event bubbling on the cart button.
                return '<div class="toy-card glass-panel" style="animation-delay:' + (index * 0.05) + 's" onclick="openModal(' + toy.id + ')">' +
                    '<div class="toy-image">' +
                        imgHtml +
                        '<div class="badge-new">' + toy.type + '</div>' +
                    '</div>' +
                    '<div class="toy-info">' +
                        '<div class="toy-category">' + toy.category + '</div>' +
                        '<h3>' + toy.name + '</h3>' +
                        '<div class="toy-meta">' +
                            '<div class="price"><span class="currency">Rs</span>' + toy.price.toFixed(2) + '</div>' +
                            '<button class="btn-quick-add" id="cartBtn' + toy.id + '" onclick="event.stopPropagation(); addToCart(' + toy.id + ')">+</button>' +
                        '</div>' +
                    '</div>' +
                '</div>';
            }).join('');
        }

        // Search & Filter
        function searchToys() {
            const keyword = document.getElementById('searchInput').value.toLowerCase();
            let filtered = allToys;
            if (keyword) filtered = filtered.filter(t => t.name.toLowerCase().includes(keyword) || t.description.toLowerCase().includes(keyword));
            if (currentFilter) filtered = filtered.filter(t => t.category === currentFilter);
            renderToys(filtered);
        }

        function filterCategory(el, category) {
            document.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
            el.classList.add('active');
            currentFilter = category;
            searchToys();
        }

        // ============================================
        // MODAL LOGIC
        // ============================================
        async function openModal(toyId) {
            const toy = allToys.find(t => t.id === toyId);
            if(!toy) return;
            currentModalToyId = toy.id;

            // Populate Modal Static Data
            const emoji = toyEmojis[toy.category] || toyEmojis['default'];
            const imgHtml = (toy.imageUrl && toy.imageUrl.trim() !== '') ? 
                '<img src="' + toy.imageUrl + '">' : '<div class="emoji-placeholder">' + emoji + '</div>';
            
            document.getElementById('modalImageContainer').innerHTML = imgHtml;
            document.getElementById('modalBreadcrumbs').textContent = 'TOYVERSE > ' + toy.category + ' > ' + toy.type;
            document.getElementById('modalTitle').textContent = toy.name;
            document.getElementById('modalPrice').textContent = toy.price.toFixed(2);
            document.getElementById('modalDesc').textContent = toy.description || 'Experience the magic of this premium toy. Crafted with care and designed to bring joy and wonder.';
            
            const stockEl = document.getElementById('modalStock');
            if(toy.stock > 10) { stockEl.textContent = '✓ IN STOCK'; stockEl.style.color = 'var(--secondary)'; stockEl.style.background = 'rgba(16, 185, 129, 0.1)';}
            else if(toy.stock > 0) { stockEl.textContent = '⚠️ LOW STOCK (' + toy.stock + ')'; stockEl.style.color = '#F59E0B'; stockEl.style.background = 'rgba(245, 158, 11, 0.1)';}
            else { stockEl.textContent = 'OUT OF STOCK'; stockEl.style.color = '#EF4444'; stockEl.style.background = 'rgba(239, 68, 68, 0.1)';}

            // Fetch Reviews
            document.getElementById('modalReviewsGrid').innerHTML = '<p style="padding:20px; color:#64748b;">Loading reviews...</p>';
            document.getElementById('modalOverallRating').innerHTML = '';
            
            try {
                const res = await fetch('/api/reviews/toy/' + toyId);
                const data = await res.json();
                
                if(data.totalReviews > 0) {
                    const starsHtml = '★'.repeat(Math.round(data.averageRating)) + '☆'.repeat(5 - Math.round(data.averageRating));
                    document.getElementById('modalOverallRating').innerHTML = '<span class="stars">' + starsHtml + '</span> (' + data.totalReviews + ' Reviews)';
                    
                    document.getElementById('modalReviewsGrid').innerHTML = data.reviews.map(r => {
                        const rStars = '★'.repeat(r.rating) + '☆'.repeat(5 - r.rating);
                        const initials = r.userName.split(' ').map(n=>n[0]).join('').substring(0,2).toUpperCase();
                        return '<div class="review-card">' +
                                '<div class="review-user">' +
                                    '<div class="avatar">' + initials + '</div>' +
                                    '<div class="user-meta">' +
                                        '<h4>' + r.userName + '</h4>' +
                                        '<span>✓ Verified Buyer</span>' +
                                    '</div>' +
                                '</div>' +
                                '<p class="review-text">"' + r.comment + '"</p>' +
                                '<div class="stars" style="font-size:12px">' + rStars + '</div>' +
                               '</div>';
                    }).join('');
                } else {
                    document.getElementById('modalReviewsGrid').innerHTML = '<p style="padding:20px; color:#64748b;">No reviews yet. Be the first to review this product!</p>';
                }
            } catch (e) {
                document.getElementById('modalReviewsGrid').innerHTML = '<p style="padding:20px; color:#ef4444;">Could not load reviews.</p>';
            }

            // Show Modal
            document.body.style.overflow = 'hidden';
            document.getElementById('toyModal').classList.add('show');
        }

        function closeModal(event, force=false) {
            if (force || event.target.id === 'toyModal') {
                document.getElementById('toyModal').classList.remove('show');
                document.body.style.overflow = '';
                currentModalToyId = null;
            }
        }

        async function addModalToyToCart() {
            if(currentModalToyId) {
                await addToCart(currentModalToyId);
                const btn = document.getElementById('modalAddToCart');
                const origText = btn.textContent;
                btn.textContent = '✓ Added to Cart';
                btn.style.background = 'var(--secondary)';
                setTimeout(() => { btn.textContent = origText; btn.style.background = ''; }, 2000);
            }
        }

        // ============================================
        // CART & UTILS
        // ============================================
        async function addToCart(toyId) {
            try {
                const params = new URLSearchParams({ toyId: toyId, quantity: 1 });
                const response = await fetch('/api/cart/add', { method: 'POST', body: params });
                const data = await response.json();

                if (data.success) {
                    if (typeof showToast === 'function') showToast('Added to cart successfully!');
                    if (typeof updateCartCount === 'function') updateCartCount();
                    const quickBtn = document.getElementById('cartBtn' + toyId);
                    if(quickBtn) {
                        quickBtn.classList.add('added'); quickBtn.textContent = '✓';
                        setTimeout(() => { quickBtn.classList.remove('added'); quickBtn.textContent = '+'; }, 2000);
                    }
                } else { if (typeof showToast === 'function') showToast(data.message, true); }
            } catch(e) {
                if (typeof showToast === 'function') showToast('Please login first!', true);
                setTimeout(() => window.location.href = '/login', 1500);
            }
        }

        document.getElementById('nav-discover').classList.add('active');
        loadToys();
    </script>

<style>
/* Page Specific CSS */
.browse-header { text-align: center; padding: 60px 24px 40px; }
.browse-header h1 { font-size: 48px; font-weight: 800; color: var(--text-main); margin-bottom: 12px; letter-spacing: -1px; }
.browse-header p { color: var(--text-muted); font-size: 18px; }

.search-section { max-width: 1300px; margin: 0 auto 40px; padding: 0 40px; }
.search-container { display: flex; flex-direction: column; gap: 24px; align-items: center; }
.search-bar { display: flex; align-items: center; gap: 12px; border-radius: 50px; padding: 12px 32px; transition: all 0.3s ease; width: 100%; max-width: 600px; }
.search-bar:focus-within { box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1); }
.search-bar input { flex: 1; background: none; border: none; outline: none; color: var(--text-main); font-size: 16px; padding: 12px 0; }
.search-icon { font-size: 20px; }

.filter-pills { display: flex; gap: 12px; flex-wrap: wrap; justify-content: center; }
.pill { padding: 10px 24px; border-radius: 50px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.3s; color: var(--text-muted); border: 1px solid rgba(0,0,0,0.05); background: rgba(255,255,255,0.5); backdrop-filter: blur(10px); }
.pill:hover { background: white; transform: translateY(-2px); }
.pill.active { background: var(--primary); color: white; border-color: var(--primary); box-shadow: 0 8px 20px rgba(79,70,229,0.2); }

.results-info { color: var(--text-muted); font-size: 14px; margin-bottom: 32px; font-weight: 600; text-align: center; }
.toys-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 32px; max-width: 1300px; margin: 0 auto; padding: 0 40px; }
.toy-card { border-radius: 24px; overflow: hidden; cursor: pointer; transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); display: flex; flex-direction: column; animation: fadeUp 0.6s ease-out both; }
.toy-card:hover { transform: translateY(-8px); box-shadow: 0 20px 40px rgba(0,0,0,0.08); background: white; }

@keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

.toy-image { height: 220px; display: flex; align-items: center; justify-content: center; font-size: 80px; position: relative; background: #F8FAFC; overflow: hidden; }
.toy-image img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; }
.toy-card:hover .toy-image img { transform: scale(1.05); }
.badge-new { position: absolute; top: 16px; right: 16px; background: rgba(255,255,255,0.9); backdrop-filter: blur(8px); color: var(--text-main); padding: 6px 12px; border-radius: 50px; font-size: 11px; font-weight: 700; }

.toy-info { padding: 24px; flex: 1; display: flex; flex-direction: column; }
.toy-category { font-size: 11px; font-weight: 700; color: var(--primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
.toy-info h3 { font-size: 18px; font-weight: 700; margin-bottom: 16px; color: var(--text-main); }
.toy-meta { display: flex; justify-content: space-between; align-items: flex-end; margin-top: auto; padding-top: 16px; border-top: 1px solid rgba(0,0,0,0.03); }
.price { font-size: 24px; font-weight: 800; color: var(--text-main); }
.price .currency { font-size: 14px; font-weight: 600; color: var(--text-muted); }

.btn-quick-add { width: 44px; height: 44px; border-radius: 50%; border: none; background: #F1F5F9; color: var(--text-main); cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.3s; font-size: 20px; }
.btn-quick-add:hover { background: var(--primary); color: white; transform: rotate(90deg); }
.btn-quick-add.added { background: var(--secondary); color: white; transform: none; }

/* MODAL */
.modal-overlay { position: fixed; inset: 0; z-index: 2000; background: rgba(15, 23, 42, 0.4); backdrop-filter: blur(12px); display: flex; align-items: center; justify-content: center; opacity: 0; pointer-events: none; transition: all 0.4s; padding: 20px; }
.modal-overlay.show { opacity: 1; pointer-events: auto; }
.modal-content { width: 100%; max-width: 1000px; max-height: 90vh; background: rgba(255, 255, 255, 0.9); border-radius: 32px; box-shadow: 0 40px 100px rgba(0,0,0,0.2); overflow: hidden; overflow-y: auto; transform: scale(0.9) translateY(40px); transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); position: relative; border: 1px solid rgba(255,255,255,0.5); }
.modal-overlay.show .modal-content { transform: scale(1) translateY(0); }

.modal-close { position: absolute; top: 20px; right: 20px; z-index: 10; width: 44px; height: 44px; border-radius: 50%; border: none; background: rgba(0,0,0,0.05); cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 18px; transition: all 0.3s; }
.modal-close:hover { background: #FF4757; color: white; transform: rotate(90deg); }

.modal-grid { display: grid; grid-template-columns: 1fr 1.2fr; }
.modal-image-col { background: #F1F5F9; display: flex; align-items: center; justify-content: center; padding: 60px; position: relative; }
.modal-image-col img { max-width: 100%; max-height: 400px; object-fit: contain; border-radius: 20px; filter: drop-shadow(0 20px 40px rgba(0,0,0,0.1)); }
.modal-image-col .emoji-placeholder { font-size: 160px; }

.modal-info-col { padding: 60px; display: flex; flex-direction: column; }
.modal-breadcrumbs { font-size: 12px; color: var(--text-muted); font-weight: 700; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 20px; }
.modal-title { font-size: 48px; font-weight: 900; line-height: 1; margin-bottom: 20px; color: var(--text-main); letter-spacing: -2px; }
.modal-price-row { display: flex; align-items: center; gap: 20px; margin-bottom: 32px; }
.modal-price { font-size: 36px; font-weight: 800; color: var(--primary); }
.modal-stock { padding: 6px 16px; border-radius: 50px; font-size: 12px; font-weight: 800; }

.modal-desc { font-size: 17px; color: var(--text-muted); line-height: 1.6; margin-bottom: 40px; }
.btn-block-primary { width: 100%; padding: 20px; border: none; border-radius: 20px; background: var(--primary); color: white; font-size: 18px; font-weight: 700; cursor: pointer; transition: all 0.3s; box-shadow: 0 10px 30px rgba(79,70,229,0.3); }
.btn-block-primary:hover { transform: translateY(-3px); box-shadow: 0 15px 40px rgba(79,70,229,0.4); }

.shipping-info { margin-top: 40px; padding: 24px; border-radius: 20px; background: white; border: 1px solid rgba(0,0,0,0.05); display: flex; align-items: center; gap: 16px; }
.shipping-info .icon { font-size: 28px; }
.shipping-info p { font-size: 15px; font-weight: 700; margin: 0; }
.shipping-info span { font-size: 13px; color: var(--text-muted); }

.modal-reviews { padding: 60px; border-top: 1px solid rgba(0,0,0,0.05); background: #F8FAFC; }
.modal-reviews-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
.modal-reviews-header h3 { font-size: 28px; font-weight: 800; }
.stars { color: #FFB800; font-size: 18px; }

.review-card { padding: 32px; border-radius: 24px; background: white; box-shadow: 0 4px 20px rgba(0,0,0,0.02); }
.review-user { display: flex; align-items: center; gap: 16px; margin-bottom: 20px; }
.avatar { width: 52px; height: 52px; border-radius: 50%; background: #EEF2FF; display: flex; align-items: center; justify-content: center; font-weight: 800; color: var(--primary); }
.user-meta h4 { font-size: 16px; font-weight: 700; margin: 0; }
.user-meta span { font-size: 12px; color: var(--secondary); font-weight: 700; }
.review-text { font-size: 15px; color: var(--text-muted); line-height: 1.7; font-style: italic; }

@media (max-width: 1000px) {
    .modal-grid { grid-template-columns: 1fr; }
    .modal-info-col { padding: 40px; }
}
@media (max-width: 768px) {
    .browse-header h1 { font-size: 36px; }
    .search-section { padding: 0 20px; }
    .toys-grid { padding: 0 20px; gap: 20px; }
}
</style>
<jsp:include page="footer.jsp" />
