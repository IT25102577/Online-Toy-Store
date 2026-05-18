<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ToyVerse</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root { 
            --sidebar-bg: rgba(255, 255, 255, 0.85); 
            --sidebar-hover: rgba(79, 70, 229, 0.1); 
            --content-bg: #F4F7F6; 
            --card-bg: rgba(255, 255, 255, 0.9); 
            --text-dark: #1E293B; 
            --gray: #64748B; 
            --border: rgba(0, 0, 0, 0.05); 
            --primary: #4F46E5; 
            --success: #10B981; 
            --warning: #F59E0B; 
            --danger: #EF4444; 
            --info: #3B82F6; 
        }
        body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; background: url('${pageContext.request.contextPath}/assets/images/hexagon-bg.png') no-repeat center center fixed; background-size: cover; background-color: var(--content-bg); margin: 0; display: flex; min-height: 100vh; overflow-x: hidden; }

        /* Animated Background Blobs for that Apple effect */
        .bg-shapes { position: fixed; inset: 0; z-index: -1; pointer-events: none; }
        .shape { position: absolute; filter: blur(80px); opacity: 0.5; border-radius: 50%; animation: float 20s infinite alternate; }
        .shape-1 { top: -10%; left: -10%; width: 50vw; height: 50vw; background: #E0E7FF; }
        .shape-2 { bottom: -20%; right: -10%; width: 60vw; height: 60vw; background: #DBEAFE; animation-delay: -5s; }
        @keyframes float { 0% { transform: translate(0, 0) rotate(0deg); } 100% { transform: translate(50px, 50px) rotate(10deg); } }

        /* Admin Sidebar */
        .sidebar {
            width: 260px; background: var(--sidebar-bg); color: var(--text-dark);
            position: fixed; top: 0; left: 0; height: 100vh;
            display: flex; flex-direction: column; z-index: 50;
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid var(--border); box-shadow: 4px 0 24px rgba(0,0,0,0.02);
        }
        .sidebar-header { padding: 32px 24px; border-bottom: 1px solid var(--border); }
        .sidebar-header .logo { font-size: 20px; font-weight: 800; color: var(--primary); letter-spacing: -0.5px; }
        .sidebar-header .role { font-size: 13px; color: var(--gray); margin-top: 4px; font-weight: 500; }

        .sidebar-nav { flex: 1; padding: 24px 16px; }
        .sidebar-nav a {
            display: flex; align-items: center; gap: 12px;
            color: var(--gray); text-decoration: none; padding: 14px 16px;
            border-radius: 14px; font-size: 14px; font-weight: 600;
            margin-bottom: 8px; transition: all 0.3s ease;
        }
        .sidebar-nav a:hover { color: var(--primary); background: var(--sidebar-hover); }
        .sidebar-nav a.active { color: var(--primary); background: rgba(79, 70, 229, 0.1); border-left: 4px solid var(--primary); padding-left: 12px; }
        .sidebar-nav a .icon { font-size: 18px; width: 24px; text-align: center; }

        .sidebar-footer { padding: 24px 16px; border-top: 1px solid var(--border); }
        .btn-logout {
            display: flex; align-items: center; gap: 10px; width: 100%;
            padding: 14px 16px; border-radius: 14px; border: none;
            background: #FEF2F2; color: var(--danger);
            font-size: 14px; font-weight: 700; cursor: pointer;
            transition: all 0.3s; text-decoration: none;
        }
        .btn-logout:hover { background: #FEE2E2; transform: translateY(-2px); }

        /* Main Content Base */
        .main-content { flex: 1; margin-left: 260px; padding: 40px 48px; }
        .page-title { font-size: 32px; font-weight: 800; color: var(--text-dark); margin-bottom: 8px; letter-spacing: -1px; }
        .page-subtitle { color: var(--gray); font-size: 15px; margin-bottom: 40px; font-weight: 500; }

        /* Shared Card Styles */
        .section-card { background: var(--card-bg); border-radius: 24px; padding: 32px; border: 1px solid var(--border); box-shadow: 0 8px 32px rgba(0,0,0,0.03); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); animation: fadeUp 0.6s ease both; margin-bottom: 24px; }
        .section-card h3 { font-size: 20px; font-weight: 700; margin-bottom: 24px; color: var(--text-dark); letter-spacing: -0.5px; }

        /* Shared Table Styles */
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; color: var(--gray); font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; padding: 16px; border-bottom: 2px solid var(--border); }
        td { padding: 16px; font-size: 14px; color: var(--text-dark); border-bottom: 1px solid var(--border); font-weight: 500; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: rgba(0,0,0,0.01); }

        .toolbar { display: flex; justify-content: flex-end; margin-bottom: 24px; }
        .btn-add { padding: 12px 24px; border: none; border-radius: 50px; background: var(--primary); color: white; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.3s; box-shadow: 0 8px 24px rgba(79, 70, 229, 0.25); }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 12px 32px rgba(79, 70, 229, 0.35); background: #4338CA; }
        .btn-delete { padding: 8px 16px; border: none; border-radius: 12px; background: #FEF2F2; color: var(--danger); font-size: 13px; font-weight: 700; cursor: pointer; transition: all 0.3s; }
        .btn-delete:hover { background: #FEE2E2; }

        .toast { position: fixed; top: 40px; right: 40px; padding: 16px 24px; border-radius: 16px; font-size: 14px; font-weight: 600; z-index: 1000; transform: translateX(150%); transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1); background: rgba(255,255,255,0.9); backdrop-filter: blur(12px); border: 1px solid rgba(0,0,0,0.05); box-shadow: 0 12px 32px rgba(0,0,0,0.1); color: var(--text-dark); }
        .toast.show { transform: translateX(0); }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 900px) {
            .sidebar { width: 80px; } .sidebar-header .logo, .sidebar-header .role, .sidebar-nav a span:not(.icon), .btn-logout span:last-child { display: none; }
            .sidebar-nav a { justify-content: center; padding: 14px 0; }
            .main-content { margin-left: 80px; padding: 32px 24px; }
        }
    </style>
</head>
<body>
    <div class="bg-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
    </div>
    
    <div id="toast" class="toast"></div>

    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">🛡️ ToyVerse Admin</div>
            <div class="role">Administrator Panel</div>
        </div>
        <nav class="sidebar-nav">
            <a href="/admin/dashboard" id="nav-dashboard"><span class="icon">📊</span><span>Dashboard</span></a>
            <a href="/admin/users" id="nav-users"><span class="icon">👥</span><span>Users</span></a>
            <a href="/admin/toys" id="nav-toys"><span class="icon">🧸</span><span>Toys</span></a>
            <a href="/admin/orders" id="nav-orders"><span class="icon">📦</span><span>Orders</span></a>
            <a href="/admin/reviews" id="nav-reviews"><span class="icon">⭐</span><span>Reviews</span></a>
            <a href="/toys"><span class="icon">🏪</span><span>View Store</span></a>
        </nav>
        <div class="sidebar-footer">
            <a href="/admin/logout" class="btn-logout"><span class="icon">🚪</span> <span>Logout</span></a>
        </div>
    </aside>

    <main class="main-content">
        <!-- Content will be injected here -->

    <script>
        async function adminLogout() {
            await fetch('/api/logout', { method: 'POST' });
            window.location.href = '/';
        }

        function showToast(message, isError = false) {
            const toast = document.getElementById('toast');
            if (!toast) return;
            toast.innerHTML = (isError ? '⚠️ ' : '✅ ') + message;
            toast.style.background = isError ? 'rgba(254,242,242,0.97)' : 'rgba(236,253,245,0.97)';
            toast.style.color = isError ? '#DC2626' : '#059669';
            toast.style.borderColor = isError ? '#FECACA' : '#A7F3D0';
            toast.classList.add('show');
            setTimeout(() => toast.classList.remove('show'), 3000);
        }
    </script>