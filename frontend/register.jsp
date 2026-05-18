<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<div class="auth-page-wrapper">
    <div class="auth-wrapper glass-panel">
        <div class="auth-image-side">
            <div class="image-overlay">
                <h2>Join ToyVerse Today</h2>
                <p>Unlock exclusive offers, track your orders, and build the ultimate wishlist.</p>
            </div>
        </div>
        <div class="auth-form-side">
            <div class="auth-header">
                <span class="emoji-icon">🎁</span>
                <h1>Create Account</h1>
                <p>Join us to track orders and shop faster.</p>
            </div>

            <div class="form-group">
                <label>Username</label>
                <input type="text" id="username" placeholder="Choose a username" autofocus>
                <div class="hint">At least 3 characters</div>
            </div>
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" id="fullName" placeholder="Enter your full name">
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" id="email" placeholder="your@email.com">
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" id="password" placeholder="Create a strong password">
                <div class="hint">Minimum 4 characters</div>
            </div>

            <button class="btn-auth" id="registerBtn" onclick="register()">Create Account</button>

            <div class="auth-links">
                <a href="/login">Already have an account? Sign In</a>
            </div>
        </div>
    </div>
</div>

<style>
    .auth-page-wrapper { flex: 1; display: flex; align-items: center; justify-content: center; padding: 60px 20px; animation: fadeUp 0.8s cubic-bezier(0.16, 1, 0.3, 1); }
    @keyframes fadeUp { from { opacity: 0; transform: translateY(40px); } to { opacity: 1; transform: translateY(0); } }

    .auth-wrapper {
        display: flex;
        width: 100%;
        max-width: 1000px;
        min-height: 600px;
        background: rgba(255, 255, 255, 0.65);
        backdrop-filter: blur(30px);
        -webkit-backdrop-filter: blur(30px);
        border: 1px solid rgba(255, 255, 255, 0.8);
        border-radius: 40px;
        box-shadow: 0 30px 60px rgba(0,0,0,0.1);
        overflow: hidden;
    }

    .auth-image-side {
        flex: 1;
        background: url('/assets/images/hero-banner.png') center/cover no-repeat;
        position: relative;
        display: flex;
        align-items: flex-end;
        padding: 60px;
        overflow: hidden;
    }
    .auth-image-side::before {
        content: '';
        position: absolute;
        inset: 0;
        background: linear-gradient(to top, rgba(79, 70, 229, 0.8) 0%, rgba(16, 185, 129, 0.4) 100%);
        mix-blend-mode: multiply;
    }
    
    .image-overlay {
        position: relative;
        z-index: 2;
        color: white;
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(12px);
        padding: 30px;
        border-radius: 24px;
        border: 1px solid rgba(255, 255, 255, 0.3);
        box-shadow: 0 20px 40px rgba(0,0,0,0.2);
    }
    .image-overlay h2 { font-size: 32px; font-weight: 800; margin-bottom: 12px; letter-spacing: -1px; text-shadow: 0 2px 4px rgba(0,0,0,0.2); }
    .image-overlay p { font-size: 16px; font-weight: 500; opacity: 0.9; line-height: 1.5; }

    .auth-form-side {
        flex: 1;
        padding: 60px 80px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        background: rgba(255, 255, 255, 0.9);
    }

    .auth-header { margin-bottom: 30px; text-align: center; }
    .emoji-icon { font-size: 64px; display: inline-block; margin-bottom: 16px; animation: float 3s ease-in-out infinite; }
    @keyframes float { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-10px); } }
    .auth-header h1 { font-size: 32px; font-weight: 900; color: #1E293B; letter-spacing: -1px; margin-bottom: 8px; }
    .auth-header p { color: #64748B; font-size: 15px; font-weight: 500; }

    .form-group { margin-bottom: 20px; text-align: left; }
    .form-group label { display: block; font-size: 14px; font-weight: 700; color: #475569; margin-bottom: 8px; }
    .form-group input { width: 100%; padding: 16px 20px; background: #F8FAFC; border: 2px solid transparent; border-radius: 16px; font-size: 15px; color: #1E293B; outline: none; transition: all 0.3s ease; font-weight: 500; }
    .form-group input:focus { border-color: var(--primary); background: white; box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1); }
    .form-group .hint { font-size: 12px; color: #94A3B8; margin-top: 6px; margin-left: 4px; font-weight: 600; }

    .btn-auth { width: 100%; padding: 18px; border: none; border-radius: 50px; background: var(--primary); color: white; font-size: 16px; font-weight: 800; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 10px 25px rgba(79, 70, 229, 0.3); margin-top: 12px; }
    .btn-auth:hover { transform: translateY(-3px); box-shadow: 0 15px 35px rgba(79, 70, 229, 0.4); background: #4338CA; }
    .btn-auth.loading { pointer-events: none; opacity: 0.7; transform: none; box-shadow: none; }

    .auth-links { margin-top: 30px; text-align: center; padding-top: 24px; border-top: 1px solid rgba(0,0,0,0.05); }
    .auth-links a { color: var(--primary); text-decoration: none; font-size: 15px; font-weight: 700; transition: all 0.3s; }
    .auth-links a:hover { color: #4338CA; text-decoration: underline; }

    @media (max-width: 900px) {
        .auth-wrapper { flex-direction: column; }
        .auth-image-side { display: none; }
        .auth-form-side { padding: 40px; }
    }
</style>

<script>
    document.querySelectorAll('input').forEach(input => { input.addEventListener('keypress', e => { if (e.key === 'Enter') register(); }); });

    async function register() {
        const btn = document.getElementById('registerBtn');
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;
        const email = document.getElementById('email').value.trim();
        const fullName = document.getElementById('fullName').value.trim();

        if (!username || !password || !email || !fullName) { if(typeof showToast === 'function') showToast('Please fill in all fields', true); return; }
        if (username.length < 3) { if(typeof showToast === 'function') showToast('Username must be at least 3 characters', true); return; }
        if (password.length < 4) { if(typeof showToast === 'function') showToast('Password must be at least 4 characters', true); return; }
        if (!email.toLowerCase().endsWith('@gmail.com')) { if(typeof showToast === 'function') showToast('Email must be a valid @gmail.com address', true); return; }

        btn.classList.add('loading'); btn.textContent = 'Creating account...';

        try {
            const params = new URLSearchParams({ username, password, email, fullName });
            const response = await fetch('/api/register', { method: 'POST', body: params });
            const data = await response.json();

            if (data.success) {
                if(typeof showToast === 'function') showToast('Account created! Redirecting...', false);
                setTimeout(() => window.location.href = '/login', 1500);
            } else {
                if(typeof showToast === 'function') showToast(data.message, true);
                btn.classList.remove('loading'); btn.textContent = 'Create Account';
            }
        } catch (error) {
            if(typeof showToast === 'function') showToast('Connection error. Please try again.', true);
            btn.classList.remove('loading'); btn.textContent = 'Create Account';
        }
    }
</script>

<jsp:include page="footer.jsp" />
