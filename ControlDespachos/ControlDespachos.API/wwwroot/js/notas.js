// ═══════════════════════════════════════════════════════════════
// NOTAS / MENSAJERÍA POR OV — Módulo compartido
// Persistencia: localStorage  clave  notas_data (array global)
// ═══════════════════════════════════════════════════════════════

(function () {
    let _currentOvId = null;
    let _currentOvNum = '';
    let _pendingImages = []; // base64 strings

    // ─── INIT: inyecta modal al DOM ──────────────────────────────
    function initNotas() {
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
                        <span>Las notas grabadas quedan como historial permanente y son visibles en todos los formularios.</span>
                    </div>
                    <div class="notas-mensajes" id="notasMensajes"></div>
                    <div class="notas-input-area">
                        <div class="notas-input-row">
                            <textarea class="notas-textarea" id="notasTexto" rows="2"
                                placeholder="Escribe una nota o indicación..." 
                                onkeydown="if(event.ctrlKey&&event.key==='Enter'){event.preventDefault();grabarNota();}"></textarea>
                            <button class="notas-btn-grabar" onclick="grabarNota()">
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

        // Cerrar al clic fuera
        overlay.addEventListener('click', e => { if (e.target === overlay) cerrarNotas(); });

        // Paste listener en el textarea
        document.getElementById('notasTexto').addEventListener('paste', handlePaste);
    }

    // ─── ABRIR MODAL ─────────────────────────────────────────────
    window.abrirNotas = function (ovId, ovNum) {
        initNotas();
        _currentOvId = ovId;
        _currentOvNum = ovNum;
        _pendingImages = [];
        document.getElementById('notasOvNum').textContent = ovNum;
        document.getElementById('notasTexto').value = '';
        document.getElementById('notasPreviewImgs').innerHTML = '';
        renderNotas();
        _markAsRead(ovId); // marcar como leído al abrir
        document.getElementById('modalNotas').classList.add('open');
        // Focus textarea
        setTimeout(() => document.getElementById('notasTexto').focus(), 200);
    };

    window.cerrarNotas = function () {
        _markAsRead(_currentOvId); // marcar al cerrar también
        document.getElementById('modalNotas').classList.remove('open');
        _pendingImages = [];
        // Callback para refrescar botones en la página actual
        if (typeof window._onNotasClose === 'function') window._onNotasClose();
    };

    // ─── GRABAR NOTA ─────────────────────────────────────────────
    window.grabarNota = function () {
        const texto = (document.getElementById('notasTexto').value || '').trim();
        if (!texto && _pendingImages.length === 0) {
            _showNotaToast('Escribe un mensaje o pega una imagen', 'error');
            return;
        }

        const user = _getUser();
        const now = new Date();
        const nota = {
            id: 'nota-' + Date.now() + '-' + Math.random().toString(36).substr(2, 5),
            ov_id: _currentOvId,
            ov_num: _currentOvNum,
            user_name: user?.name || 'Usuario',
            user_role: user?.role || 'OPERADOR',
            texto: texto,
            imagenes: [..._pendingImages],
            fecha: now.toLocaleDateString('es-PE', { day: '2-digit', month: '2-digit', year: 'numeric' }),
            hora: now.toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit', second: '2-digit' }),
            timestamp: now.getTime(),
        };

        const notas = _getAllNotas();
        notas.push(nota);
        localStorage.setItem('notas_data', JSON.stringify(notas));

        // Limpiar
        document.getElementById('notasTexto').value = '';
        document.getElementById('notasPreviewImgs').innerHTML = '';
        _pendingImages = [];

        renderNotas();
        _showNotaToast('✅ Nota grabada exitosamente', 'success');
    };

    // ─── RENDERIZAR NOTAS ────────────────────────────────────────
    function renderNotas() {
        const container = document.getElementById('notasMensajes');
        const notas = _getAllNotas().filter(n => n.ov_id === _currentOvId);
        // Ordenar por más reciente primero
        notas.sort((a, b) => b.timestamp - a.timestamp);

        if (!notas.length) {
            container.innerHTML = `
                <div class="notas-empty">
                    <span class="material-icons">speaker_notes_off</span>
                    <p>Sin notas aún para esta OV</p>
                    <p style="font-size:.76rem">Escribe la primera nota o indicación</p>
                </div>`;
            return;
        }

        container.innerHTML = notas.map(n => {
            const initials = (n.user_name || 'U').split(' ').map(w => w[0]).join('').substring(0, 2).toUpperCase();
            const roleLabel = n.user_role === 'VENDEDOR' ? 'Vendedor' : 'Operador';
            const avatarColor = n.user_role === 'VENDEDOR' ? 'background:#8b5cf6' : 'background:var(--primary)';

            return `<div class="nota-burbuja">
                <div class="nota-meta">
                    <div class="nota-avatar" style="${avatarColor}">${initials}</div>
                    <div>
                        <div class="nota-user">${n.user_name}</div>
                        <div style="font-size:.7rem;color:var(--text-muted)">${roleLabel}</div>
                    </div>
                    <div class="nota-time">
                        <span class="material-icons" style="font-size:12px;vertical-align:middle">schedule</span>
                        ${n.fecha} ${n.hora}
                    </div>
                </div>
                ${n.texto ? `<div class="nota-texto">${_escapeHtml(n.texto)}</div>` : ''}
                ${n.imagenes && n.imagenes.length ? `
                    <div class="nota-imagenes">
                        ${n.imagenes.map(img => `<img class="nota-img-thumb" src="${img}" onclick="verImagenNota(this.src)" alt="Imagen adjunta">`).join('')}
                    </div>
                ` : ''}
            </div>`;
        }).join('');

        // Scroll al tope (más reciente)
        container.scrollTop = 0;
    }

    // ─── PASTE HANDLER (Ctrl+V imágenes) ─────────────────────────
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

    // ─── LIGHTBOX ────────────────────────────────────────────────
    window.verImagenNota = function (src) {
        const lb = document.createElement('div');
        lb.className = 'notas-lightbox';
        lb.innerHTML = `<img src="${src}">`;
        lb.onclick = () => lb.remove();
        document.body.appendChild(lb);
    };

    // ─── READ/UNREAD TRACKING ────────────────────────────────────
    function _getReadData() {
        const userId = _getUser()?.name || 'anonymous';
        try { return JSON.parse(localStorage.getItem('notas_read_' + userId) || '{}'); }
        catch { return {}; }
    }

    function _markAsRead(ovId) {
        if (!ovId) return;
        const data = _getReadData();
        data[ovId] = Date.now();
        const userId = _getUser()?.name || 'anonymous';
        localStorage.setItem('notas_read_' + userId, JSON.stringify(data));
    }

    function _hasUnread(ovId) {
        const notas = _getAllNotas().filter(n => n.ov_id === ovId);
        if (!notas.length) return false;

        const currentUser = _getUser()?.name || '';
        const readData = _getReadData();
        const lastRead = readData[ovId] || 0;

        // Find the latest message that was NOT written by the current user
        const otherNotas = notas.filter(n => n.user_name !== currentUser);

        // If there are no messages from other users, and I've read/closed my own notes, it's not unread.
        // Actually, let's just use the max timestamp of ANY note.
        // Because if I wrote it, my lastRead was updated.
        // But to be completely safe and avoid brief flashes of red:
        const lastMsg = Math.max(...notas.map(n => n.timestamp));

        // If the only notes are mine and lastRead is somewhat delayed, we still don't want it to show as unread for the creator.
        if (lastMsg > lastRead) {
            // Is the latest message mine?
            const latestNote = notas.find(n => n.timestamp === lastMsg);
            if (latestNote && latestNote.user_name === currentUser) {
                return false; // I wrote the latest message, so count it as read for me
            }
            return true;
        }
        return false;
    }

    // ─── CONTADOR DE NOTAS POR OV ────────────────────────────────
    window.contarNotas = function (ovId) {
        return _getAllNotas().filter(n => n.ov_id === ovId).length;
    };

    // Genera HTML para el botón de notas con colores según estado
    // 🔴 Rojo = mensajes sin leer | 🔵 Azul = mensajes leídos | ⚫ Negro = sin datos
    window.notasBtn = function (ovId, ovNum) {
        const count = window.contarNotas(ovId);
        let btnStyle, iconColor, badgeHtml = '';

        if (count === 0) {
            // Negro — sin datos
            btnStyle = 'background:#f1f5f9;border:1px solid #cbd5e1;color:#334155';
            iconColor = '#334155';
        } else if (_hasUnread(ovId)) {
            // Rojo — mensajes sin leer
            btnStyle = 'background:#fef2f2;border:1px solid #fca5a5;color:#dc2626';
            iconColor = '#dc2626';
            badgeHtml = `<span class="notas-badge">${count}</span>`;
        } else {
            // Azul — todos leídos
            btnStyle = 'background:#eff6ff;border:1px solid #93c5fd;color:#2563eb';
            iconColor = '#2563eb';
            badgeHtml = `<span class="notas-badge" style="background:#2563eb">${count}</span>`;
        }

        return `<button class="btn btn-sm" onclick="abrirNotas('${ovId}','${ovNum}')" title="Notas / Indicaciones" style="position:relative;${btnStyle}">
            <span class="material-icons" style="font-size:14px;color:${iconColor}">chat</span>${badgeHtml}
        </button>`;
    };

    // ─── HELPERS ─────────────────────────────────────────────────
    function _getAllNotas() {
        try { return JSON.parse(localStorage.getItem('notas_data') || '[]'); }
        catch { return []; }
    }

    function _getUser() {
        try { return JSON.parse(sessionStorage.getItem('user')); }
        catch { return null; }
    }

    function _escapeHtml(str) {
        const div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    }

    function _showNotaToast(msg, type) {
        if (typeof showToast === 'function') { showToast(msg, type); return; }
        const t = document.createElement('div');
        t.style.cssText = `position:fixed;bottom:24px;right:24px;z-index:10002;background:${type === 'success' ? '#10b981' : '#ef4444'};color:white;padding:12px 20px;border-radius:10px;font-size:.875rem;font-weight:600;box-shadow:0 8px 24px rgba(0,0,0,.2);transition:opacity .4s;z-index:10002`;
        t.textContent = msg;
        document.body.appendChild(t);
        setTimeout(() => { t.style.opacity = '0'; setTimeout(() => t.remove(), 400); }, 3000);
    }
})();
