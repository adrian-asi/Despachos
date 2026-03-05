// =====================================================
// supabase-client.js
// Cliente Supabase para modo DEMO
// Reemplaza SUPABASE_URL y SUPABASE_ANON_KEY con
// los valores de tu proyecto en supabase.com/dashboard
// =====================================================

// ► Configura estas dos variables con tu proyecto Supabase:
const SUPABASE_URL = 'https://TU_PROJECT_ID.supabase.co';
const SUPABASE_ANON_KEY = 'TU_ANON_KEY_AQUI';

// El SDK de Supabase se carga via CDN en cada HTML:
// <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/dist/umd/supabase.min.js"></script>
let _supabaseClient = null;

function getSupabaseClient() {
    if (!_supabaseClient) {
        if (typeof supabase === 'undefined') {
            console.error('Supabase SDK no cargado. Asegúrate de incluir el CDN antes de este script.');
            return null;
        }
        _supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    }
    return _supabaseClient;
}

// ── Verifica si estamos en modo DEMO (Supabase) ───────────────
function isSupabaseMode() {
    const env = sessionStorage.getItem('appEnv');
    return env === 'SUPABASE';
}
