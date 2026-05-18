<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<div class="page-container">
    <div class="profile-header">
        <div class="avatar">${user.username.substring(0,1).toUpperCase()}</div>
        <h1>${user.fullName}</h1>
        <span class="role-badge role-${user.role}">${user.role}</span>
    </div>

    <div class="info-card">
        <h3>📋 Account Information</h3>
        <div class="info-row"><span class="label">Username</span><span class="value">${user.username}</span></div>
        <div class="info-row"><span class="label">Role</span><span class="value">${user.role}</span></div>
        <div class="info-row"><span class="label">Status</span><span class="value" style="color:var(--secondary)">Active</span></div>
    </div>

    <div class="info-card">
        <h3>✏️ Edit Profile</h3>
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" id="fullName" value="${user.fullName}">
        </div>
        <div class="form-group">
            <label>Email Address</label>
            <input type="email" id="email" value="${user.email}">
        </div>
        <div class="form-group">
            <label>New Password</label>
            <input type="password" id="password" placeholder="Leave blank to keep current">
        </div>
        <input type="hidden" id="userId" value="${user.id}">
        <button class="btn-update" onclick="updateProfile()">Save Changes</button>
    </div>
</div>

<style>
    .page-container { max-width: 600px; margin: 40px auto; padding: 0 40px 60px; animation: fadeIn 0.6s ease; flex: 1; width: 100%; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

    .profile-header { text-align: center; margin-bottom: 40px; }
    .avatar {
        width: 120px; height: 120px; border-radius: 50%;
        background: var(--primary);
        display: flex; align-items: center; justify-content: center;
        font-size: 48px; font-weight: 800; color: white;
        margin: 0 auto 20px; box-shadow: 0 12px 32px rgba(79, 70, 229, 0.3);
    }
    .profile-header h1 { font-size: 28px; font-weight: 800; color: var(--text-main); letter-spacing: -1px; }
    .role-badge {
        display: inline-block; padding: 6px 16px; border-radius: 50px;
        font-size: 12px; font-weight: 700; margin-top: 12px;
        text-transform: uppercase; letter-spacing: 0.5px; box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }
    .role-CUSTOMER { background: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; }
    .role-ADMIN { background: #FEF2F2; color: #DC2626; border: 1px solid #FECACA; }

    .info-card {
        background: rgba(255, 255, 255, 0.8); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 24px; box-shadow: 0 8px 32px rgba(0,0,0,0.03);
        padding: 32px; margin-bottom: 24px; transition: all 0.3s;
    }
    .info-card:hover { box-shadow: 0 12px 40px rgba(0,0,0,0.06); background: white; }
    .info-card h3 { font-size: 18px; font-weight: 700; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; color: var(--text-main); }
    
    .info-row { display: flex; justify-content: space-between; padding: 16px 0; border-bottom: 1px solid rgba(0,0,0,0.05); }
    .info-row:last-child { border: none; padding-bottom: 0; }
    .info-row .label { color: var(--text-muted); font-size: 15px; font-weight: 500; }
    .info-row .value { font-size: 15px; font-weight: 600; color: var(--text-main); }

    .form-group { margin-bottom: 24px; }
    .form-group label { display: block; font-size: 14px; font-weight: 600; color: var(--text-muted); margin-bottom: 8px; }
    .form-group input {
        width: 100%; padding: 16px 20px;
        background: #F8FAFC; border: 1px solid rgba(0,0,0,0.05);
        border-radius: 16px; font-size: 15px; color: var(--text-main);
        transition: all 0.3s ease; outline: none; font-weight: 500;
    }
    .form-group input:focus { border-color: var(--primary); background: white; box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1); }

    .btn-update {
        width: 100%; padding: 18px; border: none; border-radius: 50px;
        background: var(--primary); color: white; font-size: 16px; font-weight: 700; cursor: pointer;
        transition: all 0.3s ease; box-shadow: 0 8px 24px rgba(79, 70, 229, 0.25); margin-top: 10px;
    }
    .btn-update:hover { transform: translateY(-3px); box-shadow: 0 12px 32px rgba(79, 70, 229, 0.35); background: var(--primary-hover); }
</style>

<script>
    async function updateProfile() {
        const params = new URLSearchParams({
            fullName: document.getElementById('fullName').value,
            email: document.getElementById('email').value,
            password: document.getElementById('password').value
        });
        const userId = document.getElementById('userId').value;
        const response = await fetch('/api/users/' + userId, { method: 'PUT', body: params });
        const data = await response.json();
        if(typeof showToast === 'function') showToast(data.success ? 'Profile updated successfully!' : 'Update failed', !data.success);
    }
    document.getElementById('nav-profile').classList.add('active');
</script>

<jsp:include page="footer.jsp" />
