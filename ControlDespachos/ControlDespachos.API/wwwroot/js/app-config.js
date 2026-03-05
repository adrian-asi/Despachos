// =====================================================
// app-config.js
// Capa de abstracción: SQL (PRD) ↔ Supabase (DEMO)
// Incluir DESPUÉS de supabase-client.js en cada HTML
// =====================================================

const API_BASE = '/api'; // URL base del backend .NET

// ═══════════════════════════════════════════════════
// ORDENES DE VENTA
// ═══════════════════════════════════════════════════

async function getOrdenesVenta() {
    if (isSupabaseMode()) {
        const sb = getSupabaseClient();
        const { data, error } = await sb
            .from('ordenes_venta')
            .select('*')
            .order('created_at', { ascending: false });
        if (error) throw error;
        return data.map(mapOvFromSupabase);
    }
    const res = await fetch(`${API_BASE}/ordenesVenta`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

async function getOrdenVentaById(id) {
    if (isSupabaseMode()) {
        const sb = getSupabaseClient();
        const { data, error } = await sb
            .from('ordenes_venta')
            .select('*')
            .eq('id', id)
            .single();
        if (error) throw error;
        return mapOvFromSupabase(data);
    }
    const res = await fetch(`${API_BASE}/ordenesVenta/${id}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

async function updateEstadoOV(id, nuevoEstado) {
    if (isSupabaseMode()) {
        const sb = getSupabaseClient();
        const { error } = await sb
            .from('ordenes_venta')
            .update({ estado: nuevoEstado, updated_at: new Date().toISOString() })
            .eq('id', id);
        if (error) throw error;
        return;
    }
    const res = await fetch(`${API_BASE}/ordenesVenta/${id}/estado`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ estado: nuevoEstado })
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
}

// Normaliza nombres de campo Supabase → formato app
function mapOvFromSupabase(row) {
    return {
        id: row.id,
        numeroOv: row.numero_ov,
        fechaCreacion: row.fecha_creacion,
        horaCreacion: row.hora_creacion,
        ocCotizacion: row.oc_cotizacion,
        numeroOt: row.numero_ot,
        clienteId: row.cliente_id,
        clienteNombre: row.cliente_nombre,
        domicilioDestino: row.domicilio_destino,
        distrito: row.distrito,
        pais: row.pais,
        piezaCodigo: row.pieza_codigo,
        piezaDescripcion: row.pieza_descripcion,
        cantidad: row.cantidad,
        udm: row.udm,
        solicitadoPor: row.solicitado_por,
        areaSolicitante: row.area_solicitante,
        lineaProductiva: row.linea_productiva,
        almacenOrigen: row.almacen_origen,
        courierSugerido: row.courier_sugerido,
        fechaNecesidad: row.fecha_necesidad,
        estado: row.estado,
        createdAt: row.created_at,
        updatedAt: row.updated_at
    };
}

// ═══════════════════════════════════════════════════
// GUIAS DE REMISION
// ═══════════════════════════════════════════════════

async function getGuiasRemision(ovId = null) {
    if (isSupabaseMode()) {
        const sb = getSupabaseClient();
        let query = sb
            .from('guias_remision')
            .select('*, ordenes_venta(numero_ov, cliente_nombre), users(email)')
            .order('created_at', { ascending: false });
        if (ovId) query = query.eq('ov_id', ovId);
        const { data, error } = await query;
        if (error) throw error;
        return data.map(mapGuiaFromSupabase);
    }
    const url = ovId ? `${API_BASE}/guiasRemision?ovId=${ovId}` : `${API_BASE}/guiasRemision`;
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

function mapGuiaFromSupabase(row) {
    return {
        id: row.id,
        numeroGre: row.numero_gre,
        ovId: row.ov_id,
        numeroOv: row.ordenes_venta?.numero_ov,
        clienteNombre: row.ordenes_venta?.cliente_nombre,
        fechaEmision: row.fecha_emision,
        horaEmision: row.hora_emision,
        cantidadEmitida: row.cantidad_emitida,
        estadoGre: row.estado_gre,
        emitidaPor: row.emitida_por,
        emitidaPorEmail: row.users?.email,
        programada: row.programada,
        createdAt: row.created_at
    };
}

// ═══════════════════════════════════════════════════
// HOJAS DE RUTA
// ═══════════════════════════════════════════════════

async function getHojasRuta() {
    if (isSupabaseMode()) {
        const sb = getSupabaseClient();
        const { data, error } = await sb
            .from('hojas_ruta')
            .select('*, hoja_ruta_guias(guia_id, guias_remision(numero_gre, ordenes_venta(numero_ov, cliente_nombre)))')
            .order('fecha', { ascending: false });
        if (error) throw error;
        return data.map(mapHojaFromSupabase);
    }
    const res = await fetch(`${API_BASE}/hojaRuta`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

async function updateEstadoHojaRuta(id, nuevoEstado) {
    if (isSupabaseMode()) {
        const sb = getSupabaseClient();
        const { error } = await sb
            .from('hojas_ruta')
            .update({ estado: nuevoEstado })
            .eq('id', id);
        if (error) throw error;
        return;
    }
    const res = await fetch(`${API_BASE}/hojaRuta/${id}/estado`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ estado: nuevoEstado })
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
}

function mapHojaFromSupabase(row) {
    return {
        id: row.id,
        fecha: row.fecha,
        turno: row.turno,
        chofer: row.chofer,
        estado: row.estado,
        createdAt: row.created_at,
        guias: (row.hoja_ruta_guias || []).map(g => ({
            guiaId: g.guia_id,
            numeroGre: g.guias_remision?.numero_gre,
            numeroOv: g.guias_remision?.ordenes_venta?.numero_ov,
            clienteNombre: g.guias_remision?.ordenes_venta?.cliente_nombre
        }))
    };
}

// ═══════════════════════════════════════════════════
// NOTAS / MENSAJES
// ═══════════════════════════════════════════════════

async function getNotas(ovId) {
    if (isSupabaseMode()) {
        const sb = getSupabaseClient();
        const { data, error } = await sb
            .from('notas')
            .select('*, nota_imagenes(id, base64_data)')
            .eq('ov_id', ovId)
            .order('fecha_hora', { ascending: true });
        if (error) throw error;
        return data.map(mapNotaFromSupabase);
    }
    const res = await fetch(`${API_BASE}/notas?ovId=${ovId}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

async function crearNota(nota) {
    if (isSupabaseMode()) {
        const sb = getSupabaseClient();
        const { data: notaData, error: notaErr } = await sb
            .from('notas')
            .insert({ ov_id: nota.ovId, ov_num: nota.ovNum, user_name: nota.userName, user_role: nota.userRole, texto: nota.texto })
            .select()
            .single();
        if (notaErr) throw notaErr;

        if (nota.imagenes && nota.imagenes.length > 0) {
            const imgRows = nota.imagenes.map(b64 => ({ nota_id: notaData.id, base64_data: b64 }));
            const { error: imgErr } = await sb.from('nota_imagenes').insert(imgRows);
            if (imgErr) throw imgErr;
        }
        return mapNotaFromSupabase(notaData);
    }
    const res = await fetch(`${API_BASE}/notas`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(nota)
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
}

function mapNotaFromSupabase(row) {
    return {
        id: row.id,
        ovId: row.ov_id,
        ovNum: row.ov_num,
        userName: row.user_name,
        userRole: row.user_role,
        texto: row.texto,
        fechaHora: row.fecha_hora,
        imagenes: (row.nota_imagenes || []).map(img => ({ id: img.id, base64Data: img.base64_data }))
    };
}

// ═══════════════════════════════════════════════════
// BADGE DE ENTORNO (visible en todas las páginas)
// ═══════════════════════════════════════════════════

function renderEnvBadge() {
    const env = sessionStorage.getItem('appEnv') || 'SQL';
    const badge = document.createElement('div');
    badge.id = 'env-badge';
    badge.style.cssText = `
        position:fixed; bottom:16px; right:16px; z-index:9999;
        padding:6px 14px; border-radius:20px; font-size:0.75rem;
        font-weight:700; letter-spacing:.5px; cursor:default;
        box-shadow:0 4px 12px rgba(0,0,0,0.2);
        transition: all .2s;
    `;
    if (env === 'SUPABASE') {
        badge.style.background = '#3ECF8E';
        badge.style.color = '#fff';
        badge.textContent = '☁️ DEMO · Supabase';
    } else {
        badge.style.background = '#1754cf';
        badge.style.color = '#fff';
        badge.textContent = '🗄️ PRD · SQL Server';
    }
    document.body.appendChild(badge);
}

// Auto-render badge al cargar
document.addEventListener('DOMContentLoaded', renderEnvBadge);
