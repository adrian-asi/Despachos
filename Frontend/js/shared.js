// =============================================
// SHARED: Autenticación, Nav, Datos Demo
// =============================================

// --- AUTH GUARD ---
function requireAuth() {
    const user = getUser();
    if (!user) { window.location.href = 'index.html'; return null; }
    return user;
}

function getUser() {
    try { return JSON.parse(sessionStorage.getItem('user')); } catch { return null; }
}

function logout() {
    sessionStorage.removeItem('user');
    window.location.href = 'index.html';
}

// --- RENDER NAV ---
function renderNav(activePage) {
    const user = getUser();
    const pages = [
        { id: 'ov_generadas', href: 'ov_generadas.html', label: 'Órdenes de Venta', icon: 'assignment' },
        { id: 'ov_emitidas', href: 'ov_emitidas.html', label: 'Programación', icon: 'schedule_send' },
        { id: 'hojas_ruta', href: 'hojas_ruta.html', label: 'Hoja de Ruta', icon: 'route' },
        { id: 'seguimiento', href: 'seguimiento.html', label: 'Seguimiento', icon: 'track_changes' },
    ];
    const navLinks = pages.map(p => `
    <a href="${p.href}" class="nav-link ${activePage === p.id ? 'active' : ''}">
      <span class="material-icons" style="font-size:18px">${p.icon}</span>${p.label}
    </a>`).join('');

    return `
  <header class="topbar">
    <div class="brand-bar">
      <div class="brand-icon-sm"><span class="material-icons">local_shipping</span></div>
      <div>
        <div class="brand-title">Almacén</div>
        <div class="brand-sub">Control de Despachos</div>
      </div>
    </div>
    <nav class="main-nav">${navLinks}</nav>
    <div class="user-area">
      <div class="user-avatar">${user ? user.name.charAt(0).toUpperCase() : 'U'}</div>
      <div class="user-info">
        <div class="user-name">${user?.name || 'Usuario'}</div>
        <div class="user-role">${user?.role === 'VENDEDOR' ? 'Vendedor' : 'Operador de Almacén'}</div>
      </div>
      <button class="logout-btn" onclick="logout()" title="Cerrar sesión"><span class="material-icons">logout</span></button>
    </div>
  </header>`;
}

// --- DATOS DEMO ---
const ESTADOS_OV = ['PENDIENTE', 'AGENDADA', 'URGENTE', 'VENCIDA', 'EMITIDA', 'PROGRAMADA', 'DESPACHADA', 'CERRADA'];
const CLIENTES = ['Corporación Minera SAC', 'Servicios Logísticos SRL', 'Acrilicos Peru SAC', 'TechIndustrias Perú', 'Distribuidora Lima Norte', 'Ferreyros Equipos SA', 'Industrias Metalúrgicas del Sur', 'Comercial Andina EIRL'];
const DISTRITOS = ['Ate', 'Callao', 'Los Olivos', 'San Isidro', 'Lurín', 'Villa El Salvador', 'La Victoria', 'Miraflores', 'San Miguel', 'Comas'];
const AREAS = ['Producción', 'Mantenimiento', 'Logística', 'Ventas', 'Operaciones', 'Almacén'];
const CHOFERES = ['Juan Pérez Ríos', 'Carlos Arias Luna', 'Pedro Torres Vega', 'Miguel Flores Cruz', 'Luis Mamani Huanca'];
const VENDEDORES = ['Ana García Ruiz', 'Juan López Díaz', 'Carlos Torres Silva', 'María Vela Paredes', 'Luis Mamani Cruz', 'Sofía Ramos León'];
const OPERADORES = ['Pedro Soto Quispe', 'Rosa Campos Lima', 'Andrés Paz Ríos', 'Carla Núñez Vera'];

function seed(n, min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
function pick(arr) { return arr[Math.floor(Math.random() * arr.length)]; }
function fmtDate(d) { return d.toLocaleDateString('es-PE', { day: '2-digit', month: '2-digit', year: 'numeric' }); }

// ── Limpieza automática si los datos demo son de versión anterior ───────────
(function () {
    const DATA_VERSION = 'v2';
    if (localStorage.getItem('demo_data_version') !== DATA_VERSION) {
        ['ovs_data', 'gres_data', 'hojas_data'].forEach(k => localStorage.removeItem(k));
        localStorage.setItem('demo_data_version', DATA_VERSION);
    }
})();

// Generar 100 OVs de prueba
function genOVs() {
    const stored = localStorage.getItem('ovs_data');
    if (stored) return JSON.parse(stored);
    const ovs = [];
    const base = new Date('2026-01-01');
    for (let i = 1; i <= 100; i++) {
        const created = new Date(base); created.setDate(base.getDate() + seed(0, 0, 59));
        const need = new Date(created); need.setDate(created.getDate() + seed(1, 3, 15));
        const estado = i <= 30 ? pick(['PENDIENTE', 'URGENTE', 'VENCIDA', 'AGENDADA'])
            : i <= 60 ? 'EMITIDA'
                : i <= 80 ? 'PROGRAMADA'
                    : pick(['DESPACHADA', 'CERRADA']);
        const qty = seed(0, 10, 2000);
        ovs.push({
            id: `ov-${String(i).padStart(3, '0')}`,
            numero_ov: `OV-${250000 + i}`,
            fecha_creacion: fmtDate(created),
            hora_creacion: `${String(seed(0, 7, 18)).padStart(2, '0')}:${String(seed(0, 0, 59)).padStart(2, '0')}`,
            oc_cotizacion: `COT-${seed(0, 1000, 9999)}`,
            numero_ot: `OT-${seed(0, 100, 999)}`,
            cliente_nombre: pick(CLIENTES),
            domicilio_destino: `Av. ${pick(['Industrial', 'Los Álamos', 'Perú', 'Lima', 'Argentina', 'Brasil'])} ${seed(0, 10, 9999)}`,
            distrito: pick(DISTRITOS),
            pais: 'Perú',
            pieza_codigo: `P-${String(seed(0, 1, 9999)).padStart(4, '0')}`,
            pieza_descripcion: pick(['Válvula hidráulica', 'Freno neumático', 'Sensor de temperatura', 'Bomba centrífuga', 'Compresor industrial', 'Filtro de aceite', 'Rodamiento axial', 'Turbina de vapor']),
            cantidad: qty,
            udm: pick(['UND', 'KG', 'CJA', 'PAR', 'LT', 'MT']),
            vendedor: pick(VENDEDORES),
            solicitado_por: `${pick(['María', 'Juan', 'Carlos', 'Ana', 'Luis'])} ${pick(['García', 'López', 'Torres', 'Vela', 'Mamani'])}`,
            area_solicitante: pick(AREAS),
            linea_productiva: `LP-${seed(0, 1, 5)}`,
            almacen_origen: pick(['Almacén 01', 'Almacén 02', 'Almacén Principal', 'Almacén Externo']),
            courier_sugerido: pick(['Olva Courier', 'Serpost', 'DHL', 'MRW', 'Propio']),
            fecha_necesidad: fmtDate(need),
            estado,
            created_at: created.toISOString(),
        });
    }
    localStorage.setItem('ovs_data', JSON.stringify(ovs));
    return ovs;
}

// Generar 60 GREs
function genGREs(ovs) {
    const stored = localStorage.getItem('gres_data');
    if (stored) return JSON.parse(stored);
    const emitidas = ovs.filter(o => ['EMITIDA', 'PROGRAMADA', 'DESPACHADA', 'CERRADA'].includes(o.estado));
    const gres = emitidas.slice(0, 60).map((ov, i) => {
        const total = ov.cantidad;
        const emitida = seed(0, Math.ceil(total * 0.5), total);
        const emisHora = `${String(seed(0, 8, 17)).padStart(2, '0')}:${String(seed(0, 0, 59)).padStart(2, '0')}`;
        return {
            id: `gre-${String(i + 1).padStart(3, '0')}`,
            numero_gre: `GRE-001-${4560 + i}`,
            ov_id: ov.id,
            numero_ov: ov.numero_ov,
            cliente_nombre: ov.cliente_nombre,
            domicilio_destino: ov.domicilio_destino,
            distrito: ov.distrito,
            fecha_emision: ov.fecha_creacion,
            hora_emision: ov.hora_creacion,
            cantidad_ov: total,
            cantidad_emitida: emitida,
            estado_gre: emitida >= total ? 'COMPLETO' : 'PARCIAL',
            programada: ov.estado !== 'EMITIDA',
            hoja_ruta_id: ov.estado !== 'EMITIDA' ? `hr-${String(seed(0, 1, 10)).padStart(3, '0')}` : null,
            emitido_por: pick(OPERADORES),
            emitido_fecha: ov.fecha_creacion,
            emitido_hora: emisHora,
            vendedor_ov: ov.vendedor || pick(VENDEDORES),
        };
    });
    localStorage.setItem('gres_data', JSON.stringify(gres));
    return gres;
}

// Generar 10 Hojas de Ruta
function genHojas() {
    const stored = localStorage.getItem('hojas_data');
    if (stored) return JSON.parse(stored);
    const hojas = [];
    const base = new Date('2026-02-01');
    for (let i = 1; i <= 10; i++) {
        const d = new Date(base); d.setDate(base.getDate() + i);
        hojas.push({
            id: `hr-${String(i).padStart(3, '0')}`,
            numero: `HR-${45900 + i}`,
            fecha: fmtDate(d),
            turno: i % 2 === 0 ? 'PM' : 'AM',
            chofer: pick(CHOFERES),
            placa: `${pick(['ABC', 'XYZ', 'CAM', 'TRK'])}-${seed(0, 100, 999)}`,
            estado: i <= 2 ? 'CERRADA' : i <= 6 ? 'EN_RUTA' : 'ABIERTA',
            guias: [],
            km_inicio: seed(0, 10000, 90000),
            km_fin: null,
        });
    }
    localStorage.setItem('hojas_data', JSON.stringify(hojas));
    return hojas;
}

// BADGE COLOR helpers
function badgeEstado(estado) {
    const map = {
        PENDIENTE: 'badge-blue', AGENDADA: 'badge-blue', URGENTE: 'badge-orange', VENCIDA: 'badge-red',
        EMITIDA: 'badge-purple', PROGRAMADA: 'badge-yellow', DESPACHADA: 'badge-green', CERRADA: 'badge-gray',
        PARCIAL: 'badge-orange', COMPLETO: 'badge-green',
        ABIERTA: 'badge-blue', EN_RUTA: 'badge-yellow', CERRADA: 'badge-gray',
        NO_RECIBIDO: 'badge-red',
    };
    return map[estado] || 'badge-gray';
}

function badge(label, cls) {
    return `<span class="badge ${cls}">${label}</span>`;
}

function semaforo(estado) {
    if (['COMPLETO', 'DESPACHADA', 'CERRADA', 'ABIERTA'].includes(estado)) return '🟢';
    if (['PARCIAL', 'URGENTE', 'PROGRAMADA', 'EN_RUTA'].includes(estado)) return '🟡';
    return '🔴';
}
