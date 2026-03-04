// ═══════════════════════════════════════════════════════════════
// NOTAS / MENSAJERÍA POR OV — Módulo compartido
// Persistencia: localStorage  clave  notas_data (array global)
// ═══════════════════════════════════════════════════════════════

(function () {
    let _currentOvId = null;
    let _currentOvNum = '';
    let _pendingImages = []; // base64 strings
    let _contadores = {}; // { ovId: count }

    const API_BASE = '/api/notas';

    // ─── INIT: inyecta modal al DOM ──────────────────────────────
    async function initNotas() {
        if (document.getElementById('modalNotas')) return;

        const overlay = document.createElement('div');
        overlay.className = 'modal-overlay';
        overlay.id = 'modalNotas';
        overlay.innerHTML = `
        <div class="modal modal-lg">
            <div class="modal-header">
                <h3><span class="material-icons" style="color:var(--primary)">chat</span> Notas – <span id="notasOvNum"></span></h3>
                <button class="close-modal" onclick="cerrarNotas()"><span class="material-icons">close</span></button>
            </div>
            <div class="modal-body" style="padding:16px 20px">
                <div class="notas-container">
                    <div class="notas-header-info">
                        <span class="material-icons">info</span>
                        <span>Las notas grabadas son persistentes en la Base de Datos y visibles para todo el equipo.</span>
                    </div>
                    <div class="notas-mensajes" id="notasMensajes"></div>
                    <div class="notas-input-area">
                        <div class="notas-input-row">
                            <textarea class="notas-textarea" id="notasTexto" rows="2"
                                placeholder="Escribe una nota o indicación..." 
                                onkeydown="if(event.ctrlKey&&event.key==='Enter'){event.preventDefault();grabarNota();}"></textarea>
                            <button class="notas-btn-grabar" id="btnGrabarNota" onclick="grabarNota()">
                                <span class="material-icons">save</span> Grabar
                            </button>
                        </div>
                        <div class="notas-preview-imgs" id="notasPreviewImgs"></div>
                        <div class="notas-paste-hint">
                            <span class="material-icons">content_paste</span>
                            Ctrl+V para pegar imágenes · Ctrl+Enter para grabar
                        </div>
                    </div>
                </div>
            </div>
        </div>`;
        document.body.appendChild(overlay);
        overlay.addEventListener('click', e => { if (e.target === overlay) cerrarNotas(); });
        document.getElementById('notasTexto').addEventListener('paste', handlePaste);

        // Carga inicial de contadores para los badges
        await _loadContadores();
    }

    // ─── ABRIR MODAL ─────────────────────────────────────────────
    window.abrirNotas = async function (ovId, ovNum) {
        await initNotas();
        _currentOvId = ovId;
        _currentOvNum = ovNum;
        _pendingImages = [];
        document.getElementById('notasOvNum').textContent = ovNum;
        document.getElementById('notasTexto').value = '';
        document.getElementById('notasPreviewImgs').innerHTML = '';

        document.getElementById('modalNotas').classList.add('open');
        _renderLoading();

        await renderNotas();
        _markAsRead(ovId);

        setTimeout(() => document.getElementById('notasTexto').focus(), 200);
    };

    window.cerrarNotas = function () {
        _markAsRead(_currentOvId);
        document.getElementById('modalNotas').classList.remove('open');
        _pendingImages = [];
        if (typeof window._onNotasClose === 'function') window._onNotasClose();
    };

    // ─── GRABAR NOTA ─────────────────────────────────────────────
    window.grabarNota = async function () {
        const texto = (document.getElementById('notasTexto').value || '').trim();
        if (!texto && _pendingImages.length === 0) {
            _showNotaToast('Escribe un mensaje o pega una imagen', 'error');
            return;
        }

        const user = _getUser();
        const btn = document.getElementById('btnGrabarNota');
        btn.disabled = true;
        btn.innerHTML = '<span class="material-icons rotating">sync</span> Grabando...';

        const payload = {
            ovId: _currentOvId,
            ovNum: _currentOvNum,
            userName: user?.name || 'Usuario',
            userRole: user?.role || 'OPERADOR',
            texto: texto,
            imagenes: _pendingImages.map(img => ({ base64Data: img }))
        };

        try {
            const resp = await fetch(API_BASE, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            if (!resp.ok) throw new Error('Error al guardar en servidor');

            document.getElementById('notasTexto').value = '';
            document.getElementById('notasPreviewImgs').innerHTML = '';
            _pendingImages = [];

            await renderNotas();
            await _loadContadores();
            _showNotaToast('✅ Nota guardada en SQL Server', 'success');
        } catch (err) {
            _showNotaToast('❌ Error: ' + err.message, 'error');
        } finally {
            btn.disabled = false;
            btn.innerHTML = '<span class="material-icons">save</span> Grabar';
        }
    };

    // ─── RENDERIZAR NOTAS ────────────────────────────────────────
    async function renderNotas() {
        const container = document.getElementById('notasMensajes');
        try {
            const resp = await fetch(`${API_BASE}/${_currentOvId}`);
            const notas = await resp.json();

            if (!notas.length) {
                container.innerHTML = `
                    <div class="notas-empty">
                        <span class="material-icons">speaker_notes_off</span>
                        <p>Sin historial aún para esta OV</p>
                    </div>`;
                return;
            }

            container.innerHTML = notas.map(n => {
                const initials = (n.userName || 'U').split(' ').map(w => w[0]).join('').substring(0, 2).toUpperCase();
                const roleLabel = n.userRole === 'VENDEDOR' ? 'Vendedor' : 'Operador';
                const avatarColor = n.userRole === 'VENDEDOR' ? 'background:#8b5cf6' : 'background:var(--primary)';
                const f = new Date(n.fechaHora);
                const fechaStr = f.toLocaleDateString() + ' ' + f.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

                return `<div class="nota-burbuja">
                    <div class="nota-meta">
                        <div class="nota-avatar" style="${avatarColor}">${initials}</div>
                        <div>
                            <div class="nota-user">${n.userName}</div>
                            <div style="font-size:.7rem;color:var(--text-muted)">${roleLabel}</div>
                        </div>
                        <div class="nota-time">${fechaStr}</div>
                    </div>
                    ${n.texto ? `<div class="nota-texto">${_escapeHtml(n.texto)}</div>` : ''}
                    ${n.imagenes && n.imagenes.length ? `
                        <div class="nota-imagenes">
                            ${n.imagenes.map(img => `<img class="nota-img-thumb" src="${img.base64Data}" onclick="verImagenNota(this.src)">`).join('')}
                        </div>
                    ` : ''}
                </div>`;
            }).join('');
            container.scrollTop = 0;
        } catch (err) {
            container.innerHTML = `<div class="notas-empty"><p style="color:var(--red)">Error al cargar historial</p></div>`;
        }
    }

    function _renderLoading() {
        document.getElementById('notasMensajes').innerHTML = '<div class="notas-empty"><span class="material-icons rotating">sync</span><p>Cargando notas...</p></div>';
    }

    // ─── API CONTADORES ──────────────────────────────────────────
    async function _loadContadores() {
        try {
            const resp = await fetch(`${API_BASE}/contadores`);
            _contadores = await resp.json();
            // Si hay elementos que necesitan refrescar el badge en la página actual...
            // pero esto se maneja mejor en el render de cada página.
        } catch (e) { console.error("Error al cargar contadores", e); }
    }

    window.contarNotas = function (ovId) {
        return _contadores[ovId] || 0;
    };

    window.notasBtn = function (ovId, ovNum) {
        const count = window.contarNotas(ovId);
        let btnStyle, iconColor, badgeHtml = '';

        if (count === 0) {
            btnStyle = 'background:#f1f5f9;border:1px solid #cbd5e1;color:#334155';
            iconColor = '#334155';
        } else if (_hasUnread(ovId)) { // _hasUnread sigue usando localStorage para el timestamp de lectura local
            btnStyle = 'background:#fef2f2;border:1px solid #fca5a5;color:#dc2626';
            iconColor = '#dc2626';
            badgeHtml = `<span class="notas-badge">${count}</span>`;
        } else {
            btnStyle = 'background:#eff6ff;border:1px solid #93c5fd;color:#2563eb';
            iconColor = '#2563eb';
            badgeHtml = `<span class="notas-badge" style="background:#2563eb">${count}</span>`;
        }

        return `<button class="btn btn-sm" onclick="abrirNotas('${ovId}','${ovNum}')" title="Notas SQL" style="position:relative;${btnStyle}">
            <span class="material-icons" style="font-size:14px;color:${iconColor}">chat</span>${badgeHtml}
        </button>`;
    };

    // Auto-init contadores
    initNotas();

    // ─── RESTO DE HELPERS (Pase, Lightbox, Auth, etc) ───────────────
    // (iguales o adaptados)
    function handlePaste(e) {
        const items = e.clipboardData?.items;
        if (!items) return;
        for (const item of items) {
            if (item.type.startsWith('image/')) {
                e.preventDefault();
                const file = item.getAsFile();
                const reader = new FileReader();
                reader.onload = function (ev) {
                    _pendingImages.push(ev.target.result);
                    _renderPreviewImgs();
                };
                reader.readAsDataURL(file);
                break;
            }
        }
    }

    function _renderPreviewImgs() {
        const container = document.getElementById('notasPreviewImgs');
        container.innerHTML = _pendingImages.map((img, i) =>
            `<div class="notas-preview-item">
                <img src="${img}" alt="Preview">
                <button class="notas-preview-remove" onclick="quitarImgPreview(${i})">✕</button>
            </div>`
        ).join('');
    }

    window.quitarImgPreview = function (idx) {
        _pendingImages.splice(idx, 1);
        _renderPreviewImgs();
    };

    window.verImagenNota = function (src) {
        const lb = document.createElement('div');
        lb.className = 'notas-lightbox';
        lb.innerHTML = `<img src="${src}">`;
        lb.onclick = () => lb.remove();
        document.body.appendChild(lb);
    };

    function _getUser() { try { return JSON.parse(sessionStorage.getItem('user')); } catch { return null; } }
    function _escapeHtml(str) { const d = document.createElement('div'); d.textContent = str; return d.innerHTML; }

    function _showNotaToast(msg, type) {
        if (typeof showToast === 'function') { showToast(msg, type); return; }
        const t = document.createElement('div');
        t.style.cssText = `position:fixed;bottom:24px;right:24px;z-index:20000;background:${type === 'success' ? '#10b981' : '#ef4444'};color:white;padding:12px 20px;border-radius:10px;font-size:.875rem;font-weight:600;box-shadow:0 8px 24px rgba(0,0,0,.2);transition:opacity .4s`;
        t.textContent = msg;
        document.body.appendChild(t);
        setTimeout(() => { t.style.opacity = '0'; setTimeout(() => t.remove(), 400); }, 3000);
    }

    // El sistema de UNREAD sigue siendo local (para no sobrecargar SQL con marcas de lectura por ahora)
    function _markAsRead(ovId) {
        if (!ovId) return;
        const user = _getUser();
        const userId = user?.name || 'anonymous';
        const data = JSON.parse(localStorage.getItem('notas_read_' + userId) || '{}');
        data[ovId] = Date.now();
        localStorage.setItem('notas_read_' + userId, JSON.stringify(data));
    }

    function _hasUnread(ovId) {
        const count = _contadores[ovId] || 0;
        if (count === 0) return false;
        const user = _getUser();
        const userId = user?.name || 'anonymous';
        const readData = JSON.parse(localStorage.getItem('notas_read_' + userId) || '{}');
        const lastRead = readData[ovId] || 0;
        // Si nunca lo leyó o hubo cambios, asumimos unread (simplificado)
        // En una app real, SQL traería si hay mensajes nuevos desde lastRead.
        return lastRead === 0;
    }

})();
