<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<jsp:include page="admin-header.jsp" />

<h1 class="page-title">👥 User Management</h1>
<p class="page-subtitle">Manage all registered users</p>

<div class="section-card">
    <table>
        <thead><tr><th>User</th><th>Email</th><th>Full Name</th><th>Role</th><th>Status</th><th>Action</th></tr></thead>
        <tbody>
            <c:forEach items="${users}" var="user">
                <tr>
                    <td>
                        <div class="user-info">
                            <div class="user-avatar">${fn:toUpperCase(fn:substring(user.username, 0, 1))}</div>
                            <span style="font-weight: 600;">${user.username}</span>
                        </div>
                    </td>
                    <td>${user.email}</td>
                    <td>${user.fullName}</td>
                    <td>
                        <c:choose>
                            <c:when test="${user.role == 'ADMIN'}"><span class="role-badge badge-admin">ADMIN</span></c:when>
                            <c:otherwise><span class="role-badge badge-customer">CUSTOMER</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${user.active}"><span class="status-active">● Active</span></c:when>
                            <c:otherwise><span class="status-inactive">● Inactive</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td><button class="btn-delete" onclick="showDeleteModal(${user.id})">Delete</button></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<div id="modal" class="modal-overlay">
    <div class="modal">
        <h3>⚠️ Delete User?</h3>
        <p>This action cannot be undone.</p>
        <div class="modal-btns">
            <button class="btn-cancel-modal" onclick="closeModal()">Cancel</button>
            <button class="btn-confirm-delete" onclick="confirmDelete()">Delete</button>
        </div>
    </div>
</div>

<style>
    .role-badge { padding: 6px 12px; border-radius: 8px; font-size: 11px; font-weight: 700; letter-spacing: 0.5px; }
    .badge-admin { background: #FEF2F2; color: #DC2626; border: 1px solid #FECACA; }
    .badge-customer { background: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; }

    .status-active { color: var(--success); font-weight: 700; font-size: 13px; }
    .status-inactive { color: var(--danger); font-weight: 700; font-size: 13px; }

    .user-info { display: flex; align-items: center; gap: 12px; }
    .user-avatar { width: 40px; height: 40px; border-radius: 50%; background: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 15px; font-weight: 700; color: white; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3); }

    .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(15, 23, 42, 0.4); z-index: 500; justify-content: center; align-items: center; backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); }
    .modal-overlay.show { display: flex; }
    .modal { background: rgba(255, 255, 255, 0.95); border-radius: 32px; padding: 40px; max-width: 400px; width: 90%; text-align: center; box-shadow: 0 24px 64px rgba(0,0,0,0.15); animation: fadeUp 0.3s ease; }
    .modal h3 { font-size: 24px; margin-bottom: 16px; color: var(--text-dark); font-weight: 800; letter-spacing: -0.5px; }
    .modal p { color: var(--gray); font-size: 15px; margin-bottom: 32px; }
    
    .modal-btns { display: flex; gap: 16px; justify-content: center; }
    .modal-btns button { flex: 1; padding: 14px 24px; border-radius: 16px; font-size: 15px; font-weight: 700; cursor: pointer; border: none; transition: all 0.3s; }
    .btn-confirm-delete { background: var(--danger); color: white; box-shadow: 0 8px 24px rgba(239, 68, 68, 0.25); }
    .btn-confirm-delete:hover { background: #DC2626; transform: translateY(-2px); box-shadow: 0 12px 32px rgba(239, 68, 68, 0.35); }
    .btn-cancel-modal { background: #F1F5F9; color: var(--gray); }
    .btn-cancel-modal:hover { background: #E2E8F0; color: var(--text-dark); }
</style>

<script>
    document.getElementById('nav-users').classList.add('active');

    let deleteUserId = null;
    function showDeleteModal(id) { deleteUserId = id; document.getElementById('modal').classList.add('show'); }
    function closeModal() { document.getElementById('modal').classList.remove('show'); }

    async function confirmDelete() {
        closeModal();
        if (!deleteUserId) return;
        const response = await fetch('/admin/api/users/' + deleteUserId, { method: 'DELETE' });
        const data = await response.json();
        if (data.success) { showToast('User deleted', 'success'); setTimeout(() => location.reload(), 1000); }
        else showToast(data.message, 'error');
    }
</script>

<jsp:include page="admin-footer.jsp" />