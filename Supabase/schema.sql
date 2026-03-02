-- =====================================
-- 1. EXTENSIONS
-- =====================================
create extension if not exists "uuid-ossp";

-- =====================================
-- 2. TABLAS (Esquema Público)
-- =====================================

-- Tabla Roles
create table public.roles (
  id uuid primary key default uuid_generate_v4(),
  nombre varchar(50) not null unique -- VENDEDOR, OPERADOR_ALMACEN
);

-- Tabla Custom Users (asociada a Supabase Auth)
create table public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email varchar(255) not null unique,
  role_id uuid references public.roles(id),
  activo boolean default true,
  created_at timestamptz default now()
);

-- Tabla OVs (Órdenes de Venta)
create table public.ordenes_venta (
  id uuid primary key default uuid_generate_v4(),
  numero_ov varchar(50) not null unique,
  fecha_creacion date not null default current_date,
  hora_creacion time not null default current_time,
  oc_cotizacion varchar(50),
  numero_ot varchar(50),
  cliente_id varchar(50),
  cliente_nombre text not null,
  domicilio_destino text not null,
  distrito varchar(100) not null,
  pais varchar(50) not null,
  pieza_codigo varchar(50),
  pieza_descripcion text,
  cantidad integer not null check (cantidad > 0),
  udm varchar(20),
  solicitado_por varchar(100),
  area_solicitante varchar(100),
  linea_productiva varchar(100),
  almacen_origen varchar(100),
  courier_sugerido varchar(100),
  fecha_necesidad date not null,
  estado varchar(50) not null check (estado in ('PENDIENTE', 'AGENDADA', 'URGENTE', 'VENCIDA', 'EMITIDA', 'PROGRAMADA', 'DESPACHADA', 'CERRADA')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Tabla GREs (Guías de Remisión Electrónica)
create table public.guias_remision (
  id uuid primary key default uuid_generate_v4(),
  numero_gre varchar(50) not null unique,
  ov_id uuid references public.ordenes_venta(id),
  fecha_emision date not null default current_date,
  hora_emision time not null default current_time,
  cantidad_emitida integer not null check (cantidad_emitida > 0),
  estado_gre varchar(20) not null check (estado_gre in ('PARCIAL', 'COMPLETO')),
  emitida_por uuid references public.users(id),
  programada boolean default false,
  hoja_ruta_id uuid, -- Referencia opcional inicial, manejada mayormente por N:M si corresponde, pero se pide nullable
  created_at timestamptz default now()
);

-- Tabla Hojas de Ruta
create table public.hojas_ruta (
  id uuid primary key default uuid_generate_v4(),
  fecha date not null default current_date,
  turno varchar(10) not null check (turno in ('AM', 'PM')),
  chofer varchar(100) not null,
  estado varchar(20) not null check (estado in ('ABIERTA', 'EN_RUTA', 'CERRADA')),
  created_at timestamptz default now()
);

-- Tabla NM: Hoja Ruta - Guías
create table public.hoja_ruta_guias (
  id uuid primary key default uuid_generate_v4(),
  hoja_ruta_id uuid references public.hojas_ruta(id) on delete cascade,
  guia_id uuid references public.guias_remision(id) on delete cascade,
  unique (hoja_ruta_id, guia_id)
);

-- Tabla Cierre Guías
create table public.cierre_guias (
  id uuid primary key default uuid_generate_v4(),
  guia_id uuid references public.guias_remision(id) on delete cascade,
  hora_inicio time not null,
  km_inicio numeric,
  hora_fin time not null,
  km_fin numeric,
  observaciones text,
  documentos_entregados boolean default false,
  estado_entrega varchar(20) not null check (estado_entrega in ('COMPLETO', 'PARCIAL', 'NO_RECIBIDO')),
  created_at timestamptz default now()
);

-- Tabla Cierre Hoja de Ruta
create table public.cierre_hoja_ruta (
  id uuid primary key default uuid_generate_v4(),
  hoja_ruta_id uuid references public.hojas_ruta(id) on delete cascade,
  km_total numeric,
  hora_cierre time not null,
  observaciones_finales text,
  created_at timestamptz default now()
);

-- Tabla Adjuntos Guías
create table public.adjuntos_guias (
  id uuid primary key default uuid_generate_v4(),
  guia_id uuid references public.guias_remision(id) on delete cascade,
  nombre_archivo varchar(255) not null,
  url_storage text not null,
  created_at timestamptz default now()
);

-- =====================================
-- 3. TRIGGERS & FUNCTIONS
-- =====================================

-- Función: Límite de 10 guías por hoja de ruta
create or replace function trg_check_guias_limit()
returns trigger language plpgsql as $$
declare
    v_count int;
begin
    select count(*) into v_count from public.hoja_ruta_guias where hoja_ruta_id = NEW.hoja_ruta_id;
    if v_count >= 10 then
        raise exception 'No se permiten más de 10 guías por hoja de ruta.';
    end if;
    return NEW;
end;
$$;

create trigger trg_check_guias_limit_before_insert
before insert on public.hoja_ruta_guias
for each row execute function trg_check_guias_limit();

-- =====================================
-- 4. RLS (ROW LEVEL SECURITY)
-- =====================================

alter table public.ordenes_venta enable row level security;
alter table public.guias_remision enable row level security;
alter table public.hojas_ruta enable row level security;
alter table public.users enable row level security;

-- Política Vendedores: Solo ven las filas si "solicitado_por" coincide o algo similar (se ajusta la lógica a auth.uid)
-- Dado que "solicitado_por" es varchar y la autenticación la hace Supabase usando auth.uid() y auth.jwt()->>'email'.
create policy "Los vendedores solo ven sus OVs" 
on public.ordenes_venta for select 
using (
    (select r.nombre from public.users u join public.roles r on u.role_id = r.id where u.id = auth.uid()) = 'OPERADOR_ALMACEN'
    or solicitado_por = (select email from auth.users where id = auth.uid())
);

-- Operadores ven todo
create policy "Operadores insert / update todas OVs" 
on public.ordenes_venta for all 
using (
    (select r.nombre from public.users u join public.roles r on u.role_id = r.id where u.id = auth.uid()) = 'OPERADOR_ALMACEN'
);

-- =====================================
-- 5. SEED (DATOS DE PRUEBA)
-- =====================================

-- Roles
insert into public.roles (id, nombre) values 
('2a1e9447-fd46-4cb8-bad1-20ff6bf4ccf1', 'VENDEDOR'),
('f8810c97-6a15-4ba8-9b87-1db5e3bbdcfa', 'OPERADOR_ALMACEN')
on conflict do nothing;

-- El resto del seed requerirá la creación de los usuarios en auth.users, que convencionalmente se hace vía API o un script de seed más dinámico.
