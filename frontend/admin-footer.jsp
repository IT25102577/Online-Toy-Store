    </main>

    <script>
        function showToast(msg, type) { 
            const t = document.getElementById('toast'); 
            t.innerHTML = (type === 'error' ? '⚠️ ' : '✅ ') + msg; 
            t.className = 'toast show'; 
            setTimeout(() => t.classList.remove('show'), 3000); 
        }
    </script>
</body>
</html>
