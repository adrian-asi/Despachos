-- =====================================================
-- SUPABASE SCHEMA MIRROR - Control de Despachos
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- =====================================================

-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ─────────────────────────────────────────
-- 1. ROLES
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.roles (
    id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre     VARCHAR(50) NOT NULL UNIQUE
);

COMMENT ON TABLE public.roles IS 'Roles de usuario del sistema';

-- ─────────────────────────────────────────
-- 2. USERS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.users (
    id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email      VARCHAR(255) NOT NULL UNIQUE,
    role_id    UUID REFERENCES public.roles(id),
    activo     BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.users IS 'Usuarios del sistema';

-- ─────────────────────────────────────────
-- 3. ORDENES DE VENTA
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.ordenes_venta (
    id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_ov           VARCHAR(50) NOT NULL UNIQUE,
    fecha_creacion      DATE NOT NULL,
    hora_creacion       TIME,
    oc_cotizacion       VARCHAR(100),
    numero_ot           VARCHAR(100),
    cliente_id          VARCHAR(100),
    cliente_nombre      VARCHAR(255),
    domicilio_destino   TEXT,
    distrito            VARCHAR(100),
    pais                VARCHAR(100),
    pieza_codigo        VARCHAR(100),
    pieza_descripcion   TEXT,
    cantidad            INTEGER,
    udm                 VARCHAR(20),
    solicitado_por      VARCHAR(150),
    area_solicitante    VARCHAR(100),
    linea_productiva    VARCHAR(100),
    almacen_origen      VARCHAR(100),
    courier_sugerido    VARCHAR(100),
    fecha_necesidad     DATE,
    estado              VARCHAR(30) NOT NULL DEFAULT 'PENDIENTE',
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.ordenes_venta IS 'Órdenes de venta (estados: PENDIENTE, EN_PROCESO, DESPACHADO, ENTREGADO, CANCELADO)';

-- ─────────────────────────────────────────
-- 4. GUIAS DE REMISION
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.guias_remision (
    id                 UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_gre         VARCHAR(50) NOT NULL UNIQUE,
    ov_id              UUID REFERENCES public.ordenes_venta(id),
    fecha_emision      DATE NOT NULL DEFAULT CURRENT_DATE,
    hora_emision       TIME,
    cantidad_emitida   INTEGER,
    estado_gre         VARCHAR(20) NOT NULL DEFAULT 'PARCIAL', -- PARCIAL, COMPLETO
    emitida_por        UUID REFERENCES public.users(id),
    programada         BOOLEAN NOT NULL DEFAULT FALSE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.guias_remision IS 'Guías de remisión vinculadas a OVs';

-- ─────────────────────────────────────────
-- 5. HOJAS DE RUTA
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.hojas_ruta (
    id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fecha      DATE NOT NULL DEFAULT CURRENT_DATE,
    turno      VARCHAR(5) NOT NULL DEFAULT 'AM', -- AM, PM
    chofer     VARCHAR(150),
    estado     VARCHAR(20) NOT NULL DEFAULT 'ABIERTA', -- ABIERTA, EN_RUTA, CERRADA
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.hojas_ruta IS 'Hojas de ruta de los despachos';

-- ─────────────────────────────────────────
-- 6. HOJA RUTA ↔ GUIAS (tabla pivote)
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.hoja_ruta_guias (
    id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    hoja_ruta_id  UUID NOT NULL REFERENCES public.hojas_ruta(id) ON DELETE CASCADE,
    guia_id       UUID NOT NULL REFERENCES public.guias_remision(id),
    UNIQUE(hoja_ruta_id, guia_id)
);

COMMENT ON TABLE public.hoja_ruta_guias IS 'Relación muchos-a-muchos entre hojas de ruta y guías';

-- ─────────────────────────────────────────
-- 7. CIERRE DE GUIAS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cierre_guias (
    id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guia_id               UUID REFERENCES public.guias_remision(id),
    hora_inicio           TIME,
    km_inicio             NUMERIC(10,2),
    hora_fin              TIME,
    km_fin                NUMERIC(10,2),
    observaciones         TEXT,
    documentos_entregados BOOLEAN NOT NULL DEFAULT FALSE,
    estado_entrega        VARCHAR(20) NOT NULL DEFAULT 'COMPLETO', -- COMPLETO, PARCIAL, NO_RECIBIDO
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.cierre_guias IS 'Cierre administrativo de guías entregadas';

-- ─────────────────────────────────────────
-- 8. CIERRE DE HOJA DE RUTA
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cierre_hoja_ruta (
    id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    hoja_ruta_id  UUID REFERENCES public.hojas_ruta(id),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.cierre_hoja_ruta IS 'Registro de cierre de hojas de ruta completas';

-- ─────────────────────────────────────────
-- 9. ADJUNTOS DE GUIAS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.adjuntos_guias (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guia_id         UUID REFERENCES public.guias_remision(id),
    nombre_archivo  VARCHAR(255),
    url_storage     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.adjuntos_guias IS 'Archivos adjuntos vinculados a guías de remisión';

-- ─────────────────────────────────────────
-- 10. NOTAS / MENSAJES
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.notas (
    id          SERIAL PRIMARY KEY,
    ov_id       VARCHAR(150) NOT NULL,
    ov_num      VARCHAR(50),
    user_name   VARCHAR(150),
    user_role   VARCHAR(50),
    texto       TEXT NOT NULL,
    fecha_hora  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.notas IS 'Mensajes y notas vinculados a órdenes de venta';

-- ─────────────────────────────────────────
-- 11. IMAGENES DE NOTAS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.nota_imagenes (
    id          SERIAL PRIMARY KEY,
    nota_id     INTEGER NOT NULL REFERENCES public.notas(id) ON DELETE CASCADE,
    base64_data TEXT NOT NULL -- Formato "data:image/png;base64,..."
);

COMMENT ON TABLE public.nota_imagenes IS 'Imágenes adjuntas a notas (base64)';

-- ─────────────────────────────────────────
-- ROW LEVEL SECURITY (RLS) - Para acceso público en DEMO
-- ─────────────────────────────────────────
ALTER TABLE public.roles             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ordenes_venta     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guias_remision    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hojas_ruta        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hoja_ruta_guias   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cierre_guias      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cierre_hoja_ruta  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.adjuntos_guias    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notas             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nota_imagenes     ENABLE ROW LEVEL SECURITY;

-- Políticas: acceso anónimo de solo lectura + escritura para demo
CREATE POLICY "Acceso publico lectura roles"           ON public.roles             FOR SELECT USING (true);
CREATE POLICY "Acceso publico lectura users"           ON public.users             FOR SELECT USING (true);
CREATE POLICY "Acceso publico lectura ov"              ON public.ordenes_venta     FOR SELECT USING (true);
CREATE POLICY "Acceso publico escritura ov"            ON public.ordenes_venta     FOR INSERT WITH CHECK (true);
CREATE POLICY "Acceso publico update ov"               ON public.ordenes_venta     FOR UPDATE USING (true);
CREATE POLICY "Acceso publico lectura guias"           ON public.guias_remision    FOR SELECT USING (true);
CREATE POLICY "Acceso publico escritura guias"         ON public.guias_remision    FOR INSERT WITH CHECK (true);
CREATE POLICY "Acceso publico update guias"            ON public.guias_remision    FOR UPDATE USING (true);
CREATE POLICY "Acceso publico lectura hr"              ON public.hojas_ruta        FOR SELECT USING (true);
CREATE POLICY "Acceso publico escritura hr"            ON public.hojas_ruta        FOR INSERT WITH CHECK (true);
CREATE POLICY "Acceso publico update hr"               ON public.hojas_ruta        FOR UPDATE USING (true);
CREATE POLICY "Acceso publico lectura hrg"             ON public.hoja_ruta_guias   FOR SELECT USING (true);
CREATE POLICY "Acceso publico escritura hrg"           ON public.hoja_ruta_guias   FOR INSERT WITH CHECK (true);
CREATE POLICY "Acceso publico lectura cg"              ON public.cierre_guias      FOR SELECT USING (true);
CREATE POLICY "Acceso publico escritura cg"            ON public.cierre_guias      FOR INSERT WITH CHECK (true);
CREATE POLICY "Acceso publico lectura chr"             ON public.cierre_hoja_ruta  FOR SELECT USING (true);
CREATE POLICY "Acceso publico escritura chr"           ON public.cierre_hoja_ruta  FOR INSERT WITH CHECK (true);
CREATE POLICY "Acceso publico lectura adj"             ON public.adjuntos_guias    FOR SELECT USING (true);
CREATE POLICY "Acceso publico escritura adj"           ON public.adjuntos_guias    FOR INSERT WITH CHECK (true);
CREATE POLICY "Acceso publico lectura notas"           ON public.notas             FOR SELECT USING (true);
CREATE POLICY "Acceso publico escritura notas"         ON public.notas             FOR INSERT WITH CHECK (true);
CREATE POLICY "Acceso publico lectura nota_imagenes"   ON public.nota_imagenes     FOR SELECT USING (true);
CREATE POLICY "Acceso publico escritura nota_imagenes" ON public.nota_imagenes     FOR INSERT WITH CHECK (true);

-- ─────────────────────────────────────────
-- INDICES para rendimiento
-- ─────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_ov_estado           ON public.ordenes_venta(estado);
CREATE INDEX IF NOT EXISTS idx_ov_fecha            ON public.ordenes_venta(fecha_creacion);
CREATE INDEX IF NOT EXISTS idx_guias_ov_id         ON public.guias_remision(ov_id);
CREATE INDEX IF NOT EXISTS idx_guias_estado        ON public.guias_remision(estado_gre);
CREATE INDEX IF NOT EXISTS idx_hr_estado           ON public.hojas_ruta(estado);
CREATE INDEX IF NOT EXISTS idx_notas_ov_id         ON public.notas(ov_id);
CREATE INDEX IF NOT EXISTS idx_nota_imagenes_nota  ON public.nota_imagenes(nota_id);

-- =====================================================
-- FIN DEL SCRIPT DE SCHEMA
-- Ejecutar a continuación: supabase_02_seed_data.sql
-- =====================================================
