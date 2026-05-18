<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:include page="header.jsp" />
    <div class="promo-container">
        <div class="promo-bar">
            <span class="promo-message" id="promoMessage">Summer Sale — Up to 40% Off</span>
        </div>
    </div>

    <section class="hero professional-hero reveal">
        <div class="hero-content">
            <div class="trust-badge">Trusted by 10,000+ families worldwide</div>
            <div class="hero-badge">Curated Collection 2024</div>
            <h1>The ultimate destination for <span class="highlight">premium toys</span></h1>
            <p>Discover our meticulously curated collection of educational, stuffed, and electronic toys designed to spark joy and creativity in children of all ages.</p>
            <div class="btn-group">
                <a href="/toys" class="btn btn-primary">Shop Collection</a>
                <a href="/register" class="btn btn-glass">Create Account</a>
            </div>
        </div>
        <div class="hero-image-container">
            <img src="/assets/images/hero-banner.png" alt="Premium Toy Store" class="hero-main-image">
            <div class="hero-overlay"></div>
        </div>
    </section>

    <section class="features-section reveal">
        <div class="features">
            <div class="feature-card">
                <div class="feature-icon">🎯</div>
                <h3>Curated Collection</h3>
                <p>Hand-picked premium toys from top brands worldwide.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">⚡</div>
                <h3>Fast Delivery</h3>
                <p>Quick, reliable shipping right to your doorstep.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">⭐</div>
                <h3>Verified Reviews</h3>
                <p>Authentic reviews from our community of buyers.</p>
            </div>
        </div>
    </section>

    <section class="popular-section reveal">
        <div class="section-header">
            <h2>Trending Now</h2>
            <div style="display:flex; align-items:center; gap:24px;">
                <a href="/toys" class="view-all">View All Collection →</a>
                <div class="scroll-arrows">
                    <button class="arrow-btn" onclick="scrollToys(-350)">←</button>
                    <button class="arrow-btn" onclick="scrollToys(350)">→</button>
                </div>
            </div>
        </div>
        <div class="scroll-container" id="toysScroll">
            <p style="padding: 20px; color: var(--text-muted);">Discovering the best toys for you...</p>
        </div>
    </section>

    <section class="weekly-trending reveal">
        <div class="section-title">
            <h2>Weekly Favorites</h2>
        </div>
        <div class="trending-container" id="trendingContainer">
            <p style="padding: 20px; color: var(--text-muted);">Fetching this week's favorites...</p>
        </div>
    </section>

    <section class="flash-deals reveal">
        <div class="deals-header">
            <div class="title-group">
                <h2>Flash Deals</h2>
            </div>
            <div class="countdown-group">
                <span class="label">Ends in:</span>
                <div class="countdown" id="dealCountdown">00:00:00</div>
            </div>
        </div>
        <div class="deals-grid" id="dealsGrid"></div>
    </section>

    <section class="popular-section bestseller-row reveal">
        <div class="section-header">
            <h2>Best Sellers</h2>
            <div class="scroll-arrows">
                <button class="arrow-btn" onclick="scrollBestsellers(-350)">←</button>
                <button class="arrow-btn" onclick="scrollBestsellers(350)">→</button>
            </div>
        </div>
        <div class="scroll-container" id="bestsellersScroll">
            <p style="padding: 20px; color: var(--text-muted);">Loading our top picks...</p>
        </div>
    </section>

    <section class="category-showcase reveal">
        <div class="section-header">
            <h2>Shop by Category</h2>
            <p>Explore our diverse range of high-quality toys</p>
        </div>
        <div class="categories-grid" id="categoriesGrid"></div>
    </section>

    <section class="trust-stats reveal">
        <div class="stat-item">
            <div class="stat-value" id="statToys">0+</div>
            <div class="stat-label">Premium Toys</div>
        </div>
        <div class="stat-item">
            <div class="stat-value" id="statKids">0+</div>
            <div class="stat-label">Happy Kids</div>
        </div>
        <div class="stat-item">
            <div class="stat-value" id="statReviews">0%</div>
            <div class="stat-label">Positive Reviews</div>
        </div>
        <div class="stat-item">
            <div class="stat-value">Free</div>
            <div class="stat-label">Global Shipping</div>
        </div>
    </section>

    <section class="newsletter-cta reveal">
        <div class="newsletter-content">
            <h2>Stay in the Play Loop!</h2>
            <p>Subscribe to get 15% off your first order and exclusive access to new drops.</p>
            <form id="newsletterForm" class="newsletter-form" onsubmit="subscribeNewsletter(event)">
                <input type="email" placeholder="your@email.com" required />
                <button type="submit" class="btn btn-primary">Join the Club</button>
            </form>
        </div>
    </section>

    <script>
        const categoryImages = { 
            'Stuffed': '/assets/images/cat-stuffed.png', 
            'Electronic': '/assets/images/cat-electronic.png', 
            'Educational': '/assets/images/cat-educational.png', 
            'Dolls': '/assets/images/cat-dolls.png', 
            'Vehicles': '/assets/images/cat-vehicles.png', 
            'Puzzles': '/assets/images/cat-puzzles.png' 
        };
        
        // Promo messages
        const promoMessages = [
            "Summer Sale — Up to 40% Off",
            "New Arrivals Weekly — Check them out!",
            "Free Shipping on all orders over Rs150",
            "Join our reward program for 10% cash back"
        ];
        let promoIndex = 0;
        function rotatePromo(){
            const el = document.getElementById('promoMessage');
            if(el){ 
                el.style.opacity = 0;
                setTimeout(() => {
                    el.textContent = promoMessages[promoIndex]; 
                    el.style.opacity = 1;
                    promoIndex = (promoIndex + 1) % promoMessages.length; 
                }, 500);
            }
        }
        setInterval(rotatePromo, 5000);

        // Load Weekly Trending
        async function loadWeeklyTrending(){
            try {
                const res = await fetch('/api/toys');
                const toys = await res.json();
                const container = document.getElementById('trendingContainer');
                if (!toys || toys.length === 0) return;
                const top = toys.slice(0, 5);
                container.innerHTML = top.map((t, i) => 
                    '<div class="trending-card" onclick="window.location.href=\'/toys?id=' + t.id + '\'">' +
                        '<div class="rank">#' + (i + 1) + '</div>' +
                        '<div class="category-img"><img src="' + (t.imageUrl || categoryImages[t.category] || '/assets/images/hero-banner.png') + '"></div>' +
                        '<div class="name">' + t.name + '</div>' +
                        '<div class="category">' + t.category + '</div>' +
                    '</div>').join('');
            } catch (e) { console.error(e); }
        }

        // Flash Deals with countdown
        let dealEnd = Date.now() + 2 * 60 * 60 * 1000;
        function updateCountdown(){
            const now = Date.now();
            const diff = Math.max(0, dealEnd - now);
            const h = String(Math.floor(diff / 3600000)).padStart(2, '0');
            const m = String(Math.floor((diff % 3600000) / 60000)).padStart(2, '0');
            const s = String(Math.floor((diff % 60000) / 1000)).padStart(2, '0');
            const el = document.getElementById('dealCountdown');
            if(el) el.textContent = h + ":" + m + ":" + s;
        }
        setInterval(updateCountdown, 1000);

        async function loadFlashDeals(){
            try {
                const res = await fetch('/api/toys');
                const toys = await res.json();
                const container = document.getElementById('dealsGrid');
                if (!toys || toys.length === 0) return;
                const deals = toys.slice(2, 5).map(t => ({ ...t, discount: 20 }));
                container.innerHTML = deals.map(d => 
                    '<div class="deal-card" onclick="window.location.href=\'/toys?id=' + d.id + '\'">' +
                        '<div class="discount-badge">-' + d.discount + '%</div>' +
                        '<div class="deal-image-wrap"><img src="' + (d.imageUrl || categoryImages[d.category] || '/assets/images/hero-banner.png') + '"></div>' +
                        '<div class="name">' + d.name + '</div>' +
                        '<div class="price">' +
                            '<span class="original">Rs' + d.price.toFixed(2) + '</span> ' +
                            '<span class="current">Rs' + (d.price * 0.8).toFixed(2) + '</span>' +
                        '</div>' +
                    '</div>').join('');
            } catch (e) { console.error(e); }
        }

        // Best Sellers
        async function loadBestSellers(){
            try {
                const res = await fetch('/api/toys');
                const toys = await res.json();
                const container = document.getElementById('bestsellersScroll');
                if (!toys || toys.length === 0) return;
                const best = toys.slice(0, 8);
                container.innerHTML = best.map((t, i) => 
                    '<div class="toy-card bestseller-card" onclick="window.location.href=\'/toys?id=' + t.id + '\'">' +
                        '<div class="toy-image">' +
                            '<img src="' + (t.imageUrl || categoryImages[t.category] || '/assets/images/hero-banner.png') + '">' +
                            '<div class="rank-badge">Top ' + (i + 1) + '</div>' +
                        '</div>' +
                        '<div class="toy-info">' +
                            '<div class="toy-category">' + t.category + '</div>' +
                            '<h3>' + t.name + '</h3>' +
                            '<div class="rating">★★★★★</div>' +
                            '<div class="toy-meta">' +
                                '<div class="price"><span class="currency">Rs</span>' + t.price.toFixed(2) + '</div>' +
                                '<button class="btn-quick-add" onclick="event.stopPropagation(); addToCart(' + t.id + ', this)">+</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>').join('');
            } catch (e) { console.error(e); }
        }

        async function loadCategories(){
            const grid = document.getElementById('categoriesGrid');
            try {
                const res = await fetch('/api/categories?t=' + Date.now());
                const cats = await res.json();
                if (!cats || cats.length === 0) {
                    grid.innerHTML = '<p style="color:#64748B;padding:20px;">No categories yet.</p>';
                    return;
                }
                grid.innerHTML = cats.map(cat => {
                    const imgHtml = (cat.imageUrl && cat.imageUrl.trim() !== '')
                        ? '<img src="' + cat.imageUrl + '" alt="' + cat.name + '">'
                        : '<img src="' + (categoryImages[cat.name] || '/assets/images/hero-banner.png') + '" alt="' + cat.name + '">';
                    return '<div class="category-card" onclick="window.location.href=\'/toys?category=' + cat.name + '\'">' +
                        '<div class="category-image-wrapper">' + imgHtml + '</div>' +
                        '<div class="label">' + cat.name + '</div>' +
                    '</div>';
                }).join('');
            } catch (e) {
                // Fallback to hardcoded images if API fails
                grid.innerHTML = Object.keys(categoryImages).map(cat =>
                    '<div class="category-card" onclick="window.location.href=\'/toys?category=' + cat + '\'">' +
                        '<div class="category-image-wrapper"><img src="' + categoryImages[cat] + '" alt="' + cat + '"></div>' +
                        '<div class="label">' + cat + '</div>' +
                    '</div>').join('');
            }
        }

        function animateStat(id, target){
            let count = 0;
            const el = document.getElementById(id);
            if(!el) return;
            const step = Math.ceil(target / 50);
            const interval = setInterval(() => {
                count += step;
                if(count >= target){ count = target; clearInterval(interval); }
                el.textContent = (id === 'statReviews') ? count + '%' : count.toLocaleString() + '+';
            }, 40);
        }

        function subscribeNewsletter(e){
            e.preventDefault();
            if(typeof showToast === 'function') showToast('Success! You are subscribed.');
            e.target.reset();
        }

        // Scroll Reveal Animation
        function initReveal() {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('active');
                    }
                });
            }, { threshold: 0.1 });
            document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
        }

        document.addEventListener('DOMContentLoaded', () => {
            loadWeeklyTrending();
            loadFlashDeals();
            loadBestSellers();
            loadCategories();
            animateStat('statToys', 850);
            animateStat('statKids', 15400);
            animateStat('statReviews', 99);
            rotatePromo();
            loadPopularToys();
            initReveal();
        });

        async function loadPopularToys() {
            try {
                const res = await fetch('/api/toys');
                const toys = await res.json();
                const container = document.getElementById('toysScroll');
                if (!toys || toys.length === 0) return;
                container.innerHTML = toys.slice(0, 8).map(toy => 
                    '<div class="toy-card" onclick="window.location.href=\'/toys?id=' + toy.id + '\'">' +
                        '<div class="toy-image">' +
                            '<img src="' + (toy.imageUrl || categoryImages[toy.category] || '/assets/images/hero-banner.png') + '">' +
                        '</div>' +
                        '<div class="toy-info">' +
                            '<div class="toy-category">' + toy.category + '</div>' +
                            '<h3>' + toy.name + '</h3>' +
                            '<div class="toy-meta">' +
                                '<div class="price"><span class="currency">Rs</span>' + toy.price.toFixed(2) + '</div>' +
                                '<button class="btn-quick-add" onclick="event.stopPropagation(); addToCart(' + toy.id + ', this)">+</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>').join('');
            } catch (e) { }
        }

        function scrollToys(amount) { document.getElementById('toysScroll').scrollBy({ left: amount, behavior: 'smooth' }); }
        function scrollBestsellers(amount) { document.getElementById('bestsellersScroll').scrollBy({ left: amount, behavior: 'smooth' }); }

        async function addToCart(toyId, btn) {
            try {
                const params = new URLSearchParams({ toyId, quantity: 1 });
                const res = await fetch('/api/cart/add', { method: 'POST', body: params });
                const data = await res.json();
                if (data.success) {
                    btn.textContent = '✓';
                    if (typeof showToast === 'function') showToast('Added to cart!');
                    if (typeof updateCartCount === 'function') updateCartCount();
                    setTimeout(() => { btn.textContent = '+'; }, 2000);
                }
            } catch (e) { window.location.href='/login'; }
        }
    </script>

<style>
/* ============================================
   PREMIUM GLASSMORPHISM HOMEPAGE
   ============================================ */

.promo-bar { 
    background: rgba(255, 255, 255, 0.5); 
    backdrop-filter: blur(24px); 
    -webkit-backdrop-filter: blur(24px);
    border: 1px solid rgba(255, 255, 255, 0.8);
    color: var(--primary); 
    text-align: center; 
    padding: 12px 32px; 
    font-weight: 800; 
    font-size: 14px; 
    letter-spacing: 0.5px; 
    position: relative; 
    z-index: 90; 
    box-shadow: 0 8px 32px rgba(31, 38, 135, 0.08);
    margin: 0 auto 50px; 
    max-width: fit-content;
    border-radius: 50px;
    transition: all 0.3s ease;
    display: inline-block;
}
.promo-bar:hover {
    background: rgba(255, 255, 255, 0.85);
    transform: translateY(-2px);
    box-shadow: 0 12px 40px rgba(31, 38, 135, 0.12);
}

.promo-container {
    text-align: center;
    width: 100%;
}

/* Glass Hero Section */
.professional-hero { 
    position: relative; 
    display: flex; 
    align-items: center; 
    justify-content: space-between;
    padding: 40px 10% 80px; 
    gap: 60px;
}

.hero-content { 
    flex: 1;
    position: relative; 
    z-index: 1; 
    max-width: 650px; 
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.8);
    padding: 60px;
    border-radius: 40px;
    box-shadow: 0 20px 50px rgba(0,0,0,0.05);
}

.hero-image-container { 
    flex: 1;
    position: relative; 
    z-index: 1; 
    border-radius: 40px;
    overflow: hidden;
    box-shadow: 0 30px 60px rgba(0,0,0,0.15);
    background: white;
    height: 500px;
}

.hero-main-image { width: 100%; height: 100%; object-fit: cover; }
.hero-overlay { display: none; }

.trust-badge { display: inline-block; background: rgba(16, 185, 129, 0.1); color: #10B981; padding: 8px 16px; border-radius: 50px; font-size: 13px; font-weight: 800; margin-bottom: 24px; border: 1px solid rgba(16, 185, 129, 0.3); }
.hero-badge { display: inline-block; background: var(--primary); color: white; padding: 6px 14px; border-radius: 4px; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 24px; margin-left: 10px; }
.hero h1 { font-size: 72px; font-weight: 900; line-height: 1.1; margin-bottom: 24px; color: #1E293B; letter-spacing: -3px; }
    .hero h1 .highlight { color: var(--primary); background: linear-gradient(135deg, var(--primary), #8B5CF6); background-clip: text; -webkit-background-clip: text; -webkit-text-fill-color: transparent; }

.btn-group { display: flex; gap: 16px; }
.btn-primary { background: var(--primary); color: white; padding: 16px 32px; border-radius: 50px; font-weight: 700; text-decoration: none; box-shadow: 0 10px 25px rgba(79, 70, 229, 0.3); transition: all 0.3s; border: none; font-size: 16px; cursor: pointer; }
.btn-primary:hover { background: #4338CA; transform: translateY(-3px); box-shadow: 0 15px 35px rgba(79, 70, 229, 0.4); }
.btn-glass { background: rgba(255,255,255,0.7); color: #1E293B; padding: 16px 32px; border-radius: 50px; font-weight: 700; text-decoration: none; border: 1px solid rgba(255,255,255,0.9); box-shadow: 0 10px 25px rgba(0,0,0,0.05); transition: all 0.3s; backdrop-filter: blur(10px); }
.btn-glass:hover { background: white; transform: translateY(-3px); box-shadow: 0 15px 35px rgba(0,0,0,0.1); }

/* Scroll Reveal */
.reveal { opacity: 0; transform: translateY(40px); transition: all 1s cubic-bezier(0.16, 1, 0.3, 1); }
.reveal.active { opacity: 1; transform: translateY(0); }

/* Glass Sections */
.features-section { padding: 40px 10%; position: relative; z-index: 10; }
.features { display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; }
.feature-card { background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); padding: 40px; border-radius: 32px; box-shadow: 0 20px 50px rgba(0,0,0,0.05); text-align: center; border: 1px solid rgba(255, 255, 255, 0.9); transition: all 0.4s; }
.feature-card:hover { transform: translateY(-10px); background: rgba(255, 255, 255, 0.9); box-shadow: 0 30px 60px rgba(0,0,0,0.08); }
.feature-icon { font-size: 40px; margin-bottom: 20px; animation: float 6s ease-in-out infinite; display: inline-block; }
.feature-card h3 { font-size: 20px; font-weight: 800; margin-bottom: 12px; color: #1E293B; }
.feature-card p { font-size: 15px; color: #64748B; line-height: 1.6; font-weight: 500; }

.popular-section { padding: 80px 10%; max-width: 1800px; margin: 0 auto; }
.section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 50px; }
.section-header h2 { font-size: 48px; font-weight: 900; letter-spacing: -2px; color: #1E293B; }
.section-header p { color: #64748B; font-size: 18px; font-weight: 500; margin-top: 10px; }
.scroll-container { display: flex; gap: 30px; overflow-x: auto; padding: 20px 0 50px; scrollbar-width: none; }
.scroll-container::-webkit-scrollbar { display: none; }

.view-all { font-weight: 700; color: var(--primary); text-decoration: none; font-size: 16px; transition: 0.3s; }
.view-all:hover { color: #4338CA; text-decoration: underline; }
.arrow-btn { width: 44px; height: 44px; border-radius: 50%; border: 1px solid rgba(255,255,255,0.8); background: rgba(255,255,255,0.6); backdrop-filter: blur(10px); font-size: 20px; color: #1E293B; cursor: pointer; transition: 0.3s; margin-left: 10px; }
.arrow-btn:hover { background: white; transform: scale(1.1); box-shadow: 0 10px 20px rgba(0,0,0,0.05); }

/* Glass Toy Card */
.toy-card { min-width: 320px; background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border-radius: 32px; overflow: hidden; box-shadow: 0 15px 35px rgba(0,0,0,0.04); border: 1px solid rgba(255,255,255,0.8); transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1); cursor: pointer; }
.toy-card:hover { transform: translateY(-12px); background: rgba(255, 255, 255, 0.95); box-shadow: 0 30px 60px rgba(0,0,0,0.1); }
.toy-image { height: 300px; position: relative; overflow: hidden; background: rgba(255,255,255,0.5); display: flex; align-items: center; justify-content: center; }
.toy-image img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; mix-blend-mode: multiply; }
.toy-card:hover .toy-image img { transform: scale(1.08); }
.rank-badge { position: absolute; top: 20px; left: 20px; background: rgba(17, 17, 17, 0.8); backdrop-filter: blur(10px); color: white; padding: 8px 16px; border-radius: 50px; font-size: 12px; font-weight: 800; z-index: 1; }

.toy-info { padding: 32px; }
.toy-category { font-size: 12px; font-weight: 800; color: var(--primary); text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 12px; }
.toy-info h3 { font-size: 22px; font-weight: 800; margin-bottom: 12px; color: #1E293B; line-height: 1.3; }
.rating { color: #F59E0B; font-size: 14px; margin-bottom: 20px; letter-spacing: 2px; }
.toy-meta { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid rgba(0,0,0,0.05); padding-top: 24px; }
.price { font-size: 28px; font-weight: 900; color: #1E293B; }
.price .currency { font-size: 16px; margin-right: 2px; vertical-align: super; color: #64748B; }
.btn-quick-add { width: 50px; height: 50px; border-radius: 50%; border: none; background: rgba(255,255,255,0.8); cursor: pointer; font-size: 24px; transition: all 0.3s; color: #1E293B; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
.btn-quick-add:hover { background: var(--primary); color: white; transform: rotate(90deg); }

.weekly-trending, .flash-deals { padding: 80px 8%; margin: 40px 10%; border-radius: 40px; background: rgba(255, 255, 255, 0.6); backdrop-filter: blur(24px); border: 1px solid rgba(255,255,255,0.8); box-shadow: 0 20px 50px rgba(0,0,0,0.05); }
.section-title h2 { font-size: 40px; font-weight: 900; margin-bottom: 40px; color: #1E293B; letter-spacing: -1px; text-align: center; }
.trending-container { display: flex; gap: 30px; overflow-x: auto; scrollbar-width: none; padding-bottom: 20px; }
.trending-card { min-width: 240px; padding: 40px 30px; text-align: center; background: rgba(255,255,255,0.6); border: 1px solid rgba(255,255,255,0.8); border-radius: 32px; transition: 0.4s; cursor: pointer; box-shadow: 0 10px 30px rgba(0,0,0,0.02); }
.trending-card:hover { background: white; transform: translateY(-10px); box-shadow: 0 20px 50px rgba(0,0,0,0.08); }
.category-img img { width: 140px; height: 140px; border-radius: 50%; object-fit: cover; margin-bottom: 24px; background: white; padding: 10px; box-shadow: 0 10px 20px rgba(0,0,0,0.05); }
.trending-card .rank { font-size: 50px; font-weight: 900; color: rgba(30, 41, 59, 0.1); margin-bottom: 10px; line-height: 1; }
.trending-card .name { font-size: 18px; font-weight: 800; color: #1E293B; margin-bottom: 8px; }
.trending-card .category { font-size: 13px; font-weight: 600; color: var(--primary); text-transform: uppercase; }

.deals-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 40px; }
.deals-header h2 { font-size: 40px; font-weight: 900; color: #1E293B; letter-spacing: -1px; }
.countdown-group { display: flex; flex-direction: column; align-items: flex-end; }
.countdown-group .label { font-size: 14px; font-weight: 700; color: #EF4444; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
.countdown { font-size: 32px; font-weight: 900; color: #1E293B; font-variant-numeric: tabular-nums; background: rgba(255,255,255,0.8); padding: 10px 20px; border-radius: 16px; box-shadow: 0 8px 20px rgba(0,0,0,0.05); }

.deals-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; }
.deal-card { padding: 40px; text-align: center; position: relative; background: rgba(255,255,255,0.7); border: 1px solid rgba(255,255,255,0.9); border-radius: 32px; cursor: pointer; transition: 0.4s; box-shadow: 0 10px 30px rgba(0,0,0,0.03); }
.deal-card:hover { transform: translateY(-10px); background: rgba(255,255,255,0.95); box-shadow: 0 20px 50px rgba(0,0,0,0.1); }
.discount-badge { position: absolute; top: 24px; right: 24px; background: #EF4444; color: white; padding: 10px 16px; border-radius: 50px; font-size: 14px; font-weight: 800; box-shadow: 0 8px 20px rgba(239, 68, 68, 0.3); }
.deal-image-wrap img { width: 100%; height: 220px; object-fit: contain; margin-bottom: 30px; mix-blend-mode: multiply; transition: 0.4s; }
.deal-card:hover .deal-image-wrap img { transform: scale(1.1); }
.deal-card .name { font-size: 20px; font-weight: 800; color: #1E293B; margin-bottom: 16px; }
.deal-card .price { display: flex; justify-content: center; gap: 16px; align-items: baseline; }
.deal-card .original { font-size: 18px; color: #94A3B8; text-decoration: line-through; font-weight: 600; }
.deal-card .current { font-size: 32px; font-weight: 900; color: #EF4444; }

.category-showcase { padding: 80px 10%; text-align: center; }
.categories-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 24px; margin-top: 60px; }
.category-card { transition: 0.4s; cursor: pointer; background: rgba(255,255,255,0.6); backdrop-filter: blur(10px); padding: 20px; border-radius: 32px; border: 1px solid rgba(255,255,255,0.8); }
.category-image-wrapper { height: 160px; border-radius: 24px; overflow: hidden; margin-bottom: 20px; background: white; display: flex; align-items: center; justify-content: center; }
.category-image-wrapper img { width: 80%; height: 80%; object-fit: contain; transition: 0.5s; mix-blend-mode: multiply; }
.category-card:hover { transform: translateY(-10px); background: rgba(255,255,255,0.9); box-shadow: 0 20px 40px rgba(0,0,0,0.08); }
.category-card:hover img { transform: scale(1.15) rotate(5deg); }
.category-card .label { font-size: 18px; font-weight: 800; color: #1E293B; }

.trust-stats { display: flex; justify-content: space-around; background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(20px); padding: 80px; margin: 80px 10%; border-radius: 40px; border: 1px solid rgba(255, 255, 255, 0.9); box-shadow: 0 20px 50px rgba(0,0,0,0.05); }
.stat-value { font-size: 64px; font-weight: 900; color: var(--primary); letter-spacing: -2px; margin-bottom: 12px; }
.stat-label { font-size: 18px; font-weight: 700; color: #64748B; }

.newsletter-cta { padding: 100px 10%; text-align: center; background: rgba(30, 41, 59, 0.9); backdrop-filter: blur(20px); color: white; margin: 40px 10% 80px; border-radius: 40px; box-shadow: 0 30px 60px rgba(0,0,0,0.15); border: 1px solid rgba(255,255,255,0.1); }
.newsletter-cta h2 { font-size: 56px; font-weight: 900; margin-bottom: 20px; letter-spacing: -2px; }
.newsletter-cta p { font-size: 20px; opacity: 0.8; margin-bottom: 50px; font-weight: 500; max-width: 600px; margin-left: auto; margin-right: auto; }
.newsletter-form { max-width: 550px; margin: 0 auto; display: flex; gap: 16px; background: rgba(255,255,255,0.1); padding: 12px; border-radius: 60px; border: 1px solid rgba(255,255,255,0.2); }
.newsletter-form input { flex: 1; padding: 18px 24px; border-radius: 50px; border: none; background: transparent; color: white; outline: none; font-size: 16px; font-weight: 500; }
.newsletter-form input::placeholder { color: rgba(255,255,255,0.5); }
.newsletter-form .btn-primary { background: white; color: #1E293B; box-shadow: 0 8px 20px rgba(255,255,255,0.2); }
.newsletter-form .btn-primary:hover { background: #F8FAFC; transform: translateY(-2px); box-shadow: 0 12px 25px rgba(255,255,255,0.3); }

@media (max-width: 1400px) {
    .hero h1 { font-size: 56px; }
    .categories-grid { grid-template-columns: repeat(3, 1fr); }
    .professional-hero { flex-direction: column; text-align: center; padding-top: 20px; }
    .hero-image-container { width: 100%; height: 400px; }
    .btn-group { justify-content: center; }
    .hero-badge { margin-left: 0; }
}
@media (max-width: 1024px) {
    .features-section { padding: 40px; }
    .features { grid-template-columns: 1fr; }
    .deals-grid { grid-template-columns: 1fr; }
    .trust-stats { flex-direction: column; gap: 40px; text-align: center; }
}

@keyframes float { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-10px); } }
</style>
<jsp:include page="footer.jsp" />