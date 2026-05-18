<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - ToyVerse</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh; display: flex; justify-content: center; align-items: center;
            background: url('${pageContext.request.contextPath}/assets/images/hexagon-bg.png') no-repeat center center fixed; background-size: cover; background-color: #F4F7F6; color: #1E293B; overflow: hidden; position: relative;
        }

        /* Animated Background Blobs */
        .bg-shapes { position: fixed; inset: 0; z-index: -1; pointer-events: none; }
        .shape { position: absolute; filter: blur(80px); opacity: 0.5; border-radius: 50%; animation: float 20s infinite alternate; }
        .shape-1 { top: -10%; left: -10%; width: 50vw; height: 50vw; background: #E0E7FF; }
        .shape-2 { bottom: -20%; right: -10%; width: 60vw; height: 60vw; background: #DBEAFE; animation-delay: -5s; }
        .shape-3 { top: 40%; left: 60%; width: 40vw; height: 40vw; background: #FEE2E2; animation-delay: -10s; }
        @keyframes float { 0% { transform: translate(0, 0) rotate(0deg); } 100% { transform: translate(50px, 50px) rotate(10deg); } }

        .login-box { width: 100%; max-width: 440px; text-align: center; animation: fadeUp 0.8s ease; z-index: 10; padding: 20px; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

        .shield { font-size: 64px; margin-bottom: 20px; display: inline-block; animation: pulse 2s ease-in-out infinite; }
        @keyframes pulse { 0%,100% { transform: scale(1); } 50% { transform: scale(1.1); } }

        h1 { color: #1E293B; font-size: 32px; font-weight: 800; margin-bottom: 8px; letter-spacing: -1px; }
        .subtitle { color: #64748B; font-size: 15px; margin-bottom: 32px; font-weight: 500; }

        .card {
            background: rgba(255, 255, 255, 0.85); border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 24px; padding: 40px; backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.06); text-align: left;
        }

        .form-group { margin-bottom: 24px; }
        .form-group label { display: block; font-size: 14px; color: #64748B; margin-bottom: 8px; font-weight: 600; }
        .form-group input {
            width: 100%; padding: 16px 20px;
            background: #F8FAFC; border: 1px solid rgba(0,0,0,0.05);
            border-radius: 16px; font-size: 15px; color: #1E293B;
            font-family: inherit; outline: none; transition: all 0.3s; font-weight: 500;
        }
        .form-group input:focus { border-color: #EF4444; background: white; box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.1); }
        
        .btn-admin {
            width: 100%; padding: 18px; border: none; border-radius: 50px;
            background: #EF4444; color: white; font-size: 16px; font-weight: 700; cursor: pointer;
            transition: all 0.3s; margin-top: 10px; box-shadow: 0 8px 24px rgba(239, 68, 68, 0.25);
        }
        .btn-admin:hover { transform: translateY(-3px); box-shadow: 0 12px 32px rgba(239, 68, 68, 0.35); background: #DC2626; }
        .btn-admin.loading { pointer-events: none; opacity: 0.7; transform: none; box-shadow: none; }

        .back { display: block; margin-top: 24px; color: #64748B; text-decoration: none; font-size: 14px; font-weight: 600; transition: color 0.3s; }
        .back:hover { color: #1E293B; }

        .toast { position: fixed; top: 40px; right: 40px; padding: 16px 24px; border-radius: 16px; font-size: 14px; font-weight: 600; z-index: 1000; transform: translateX(150%); transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1); background: rgba(255,255,255,0.9); backdrop-filter: blur(12px); border: 1px solid rgba(0,0,0,0.05); box-shadow: 0 12px 32px rgba(0,0,0,0.1); color: #1E293B; }
        .toast.show { transform: translateX(0); }
    </style>
</head>
<body>
    <div class="bg-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
        <div class="shape shape-3"></div>
    </div>

    <div id="toast" class="toast"></div>
    
    <div class="login-box">
        <span class="shield">🛡️</span>
        <h1>Admin Portal</h1>
        <p class="subtitle">Authorized personnel only</p>
        
        <div class="card">
            <div class="form-group"><label>Admin Username</label><input type="text" id="username" placeholder="Enter admin username" autofocus></div>
            <div class="form-group"><label>Password</label><input type="password" id="password" placeholder="Enter password"></div>
            <button class="btn-admin" id="loginBtn" onclick="login()">Login to Dashboard</button>
        </div>
        
        <a href="/" class="back">← Back to Store</a>
    </div>

    <script>
        document.getElementById('password').addEventListener('keypress', e => { if (e.key === 'Enter') login(); });

        async function login() {
            const btn = document.getElementById('loginBtn');
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            if (!username || !password) { showToast('Please fill in all fields', 'error'); return; }

            btn.classList.add('loading'); btn.textContent = 'Authenticating...';
            try {
                const params = new URLSearchParams({ username, password });
                const response = await fetch('/admin/api/login', { method: 'POST', body: params });
                const data = await response.json();
                if (data.success) {
                    showToast('Welcome, Admin!', 'success');
                    setTimeout(() => window.location.href = '/admin/dashboard', 1000);
                } else {
                    showToast(data.message, 'error');
                    btn.classList.remove('loading'); btn.textContent = 'Login to Dashboard';
                }
            } catch(e) {
                showToast('Connection error', 'error');
                btn.classList.remove('loading'); btn.textContent = 'Login to Dashboard';
            }
        }
        function showToast(msg, type) { const t = document.getElementById('toast'); t.innerHTML = (type==='error'?'⚠️ ':'✅ ') + msg; t.className = 'toast show'; setTimeout(()=>t.classList.remove('show'), 3000); }
    </script>
</body>
</html>