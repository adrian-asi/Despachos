-- =====================================================
-- SUPABASE SEED DATA - 100 registros de prueba
-- Ejecutar DESPUÉS de supabase_01_schema.sql
-- =====================================================

-- ─── ROLES ───────────────────────────────────────
INSERT INTO public.roles (id, nombre) VALUES
  ('11111111-0000-0000-0000-000000000001', 'VENDEDOR'),
  ('11111111-0000-0000-0000-000000000002', 'OPERADOR_ALMACEN'),
  ('11111111-0000-0000-0000-000000000003', 'SUPERVISOR'),
  ('11111111-0000-0000-0000-000000000004', 'GERENTE'),
  ('11111111-0000-0000-0000-000000000005', 'ADMIN')
ON CONFLICT (nombre) DO NOTHING;

-- ─── USERS ───────────────────────────────────────
INSERT INTO public.users (id, email, role_id, activo) VALUES
  ('22222222-0000-0000-0000-000000000001', 'juan.perez@empresa.com',    '11111111-0000-0000-0000-000000000001', true),
  ('22222222-0000-0000-0000-000000000002', 'maria.garcia@empresa.com',  '11111111-0000-0000-0000-000000000001', true),
  ('22222222-0000-0000-0000-000000000003', 'carlos.lopez@empresa.com',  '11111111-0000-0000-0000-000000000001', true),
  ('22222222-0000-0000-0000-000000000004', 'ana.torres@empresa.com',    '11111111-0000-0000-0000-000000000001', true),
  ('22222222-0000-0000-0000-000000000005', 'luis.ramos@empresa.com',    '11111111-0000-0000-0000-000000000001', true),
  ('22222222-0000-0000-0000-000000000006', 'pedro.mendez@empresa.com',  '11111111-0000-0000-0000-000000000002', true),
  ('22222222-0000-0000-0000-000000000007', 'rosa.vargas@empresa.com',   '11111111-0000-0000-0000-000000000002', true),
  ('22222222-0000-0000-0000-000000000008', 'jose.silva@empresa.com',    '11111111-0000-0000-0000-000000000002', true),
  ('22222222-0000-0000-0000-000000000009', 'elena.rios@empresa.com',    '11111111-0000-0000-0000-000000000002', true),
  ('22222222-0000-0000-0000-000000000010', 'admin@empresa.com',         '11111111-0000-0000-0000-000000000005', true)
ON CONFLICT (email) DO NOTHING;

-- ─── ORDENES DE VENTA (40 registros) ─────────────
INSERT INTO public.ordenes_venta
  (id, numero_ov, fecha_creacion, hora_creacion, oc_cotizacion, numero_ot,
   cliente_id, cliente_nombre, domicilio_destino, distrito, pais,
   pieza_codigo, pieza_descripcion, cantidad, udm, solicitado_por,
   area_solicitante, linea_productiva, almacen_origen, courier_sugerido,
   fecha_necesidad, estado, created_at, updated_at)
VALUES
  ('33333333-0000-0000-0000-000000000001','OV-2026-0001','2026-01-05','08:30','COT-001','OT-001','CLI-001','Corporación Alpha S.A.C.','Av. Industrial 123, Lima','Ate','Perú','PIE-001','Rodamiento SKF 6205',10,'UND','Juan Pérez','Producción','Línea A','ALM-01','DHL','2026-01-20','ENTREGADO','2026-01-05','2026-01-20'),
  ('33333333-0000-0000-0000-000000000002','OV-2026-0002','2026-01-07','09:00','COT-002','OT-002','CLI-002','Industrias Beta Perú','Calle Los Olivos 456, Callao','Callao','Perú','PIE-002','Correa dentada Gates 5M',5,'UND','María García','Mantenimiento','Línea B','ALM-01','Olva Courier','2026-01-25','ENTREGADO','2026-01-07','2026-01-25'),
  ('33333333-0000-0000-0000-000000000003','OV-2026-0003','2026-01-10','10:15','COT-003','OT-003','CLI-003','Textil Gamma EIRL','Jr. Comercio 789, Miraflores','Miraflores','Perú','PIE-003','Motor eléctrico 5HP',2,'UND','Carlos López','Eléctrica','Línea C','ALM-02','Urbano','2026-01-30','ENTREGADO','2026-01-10','2026-01-30'),
  ('33333333-0000-0000-0000-000000000004','OV-2026-0004','2026-01-12','11:00','COT-004','OT-004','CLI-004','Minera Delta S.A.','Av. Minera 321, Arequipa','Arequipa','Perú','PIE-004','Válvula de bola 2"',20,'UND','Ana Torres','Operaciones','Línea D','ALM-02','Cruz del Sur','2026-02-05','DESPACHADO','2026-01-12','2026-01-28'),
  ('33333333-0000-0000-0000-000000000005','OV-2026-0005','2026-01-15','08:45','COT-005','OT-005','CLI-005','Construye Epsilon S.A.C.','Panamericana Norte Km 25','Los Olivos','Perú','PIE-005','Cemento Portland 42.5',100,'BOL','Luis Ramos','Logística','Línea E','ALM-03','Propia','2026-02-10','DESPACHADO','2026-01-15','2026-01-29'),
  ('33333333-0000-0000-0000-000000000006','OV-2026-0006','2026-01-18','09:30','COT-006','OT-006','CLI-006','Farmacéutica Zeta Corp','Av. Salaverry 1500, San Isidro','San Isidro','Perú','PIE-006','Bomba centrífuga 1HP',1,'UND','Juan Pérez','Ingeniería','Línea A','ALM-01','DHL','2026-02-15','EN_PROCESO','2026-01-18','2026-02-01'),
  ('33333333-0000-0000-0000-000000000007','OV-2026-0007','2026-01-20','10:00','COT-007','OT-007','CLI-007','Agro Eta Perú S.A.','Carretera Central Km 10','Huancayo','Perú','PIE-007','Manguera hidráulica 1/2"',50,'MT','María García','Agrícola','Línea B','ALM-02','Transportes sur','2026-02-20','EN_PROCESO','2026-01-20','2026-02-03'),
  ('33333333-0000-0000-0000-000000000008','OV-2026-0008','2026-01-22','11:30','COT-008','OT-008','CLI-008','Electro Theta S.A.C.','Av. Argentina 2345, Cercado','Lima','Perú','PIE-008','Cable THW 10mm2',200,'MT','Carlos López','Eléctrica','Línea C','ALM-01','Olva Courier','2026-02-25','EN_PROCESO','2026-01-22','2026-02-05'),
  ('33333333-0000-0000-0000-000000000009','OV-2026-0009','2026-01-25','08:00','COT-009','OT-009','CLI-009','Logística Iota Cargo','Jr. Ayacucho 456, Breña','Breña','Perú','PIE-009','Paleta de madera 1.2x1m',30,'UND','Ana Torres','Almacén','Línea D','ALM-03','Propia','2026-03-01','PENDIENTE','2026-01-25','2026-01-25'),
  ('33333333-0000-0000-0000-000000000010','OV-2026-0010','2026-01-28','09:15','COT-010','OT-010','CLI-010','Servicios Kappa SAC','Av. Petit Thouars 3456','Lince','Perú','PIE-010','Filtro de aceite Wix',15,'UND','Luis Ramos','Mantenimiento','Línea E','ALM-01','Urbano','2026-03-05','PENDIENTE','2026-01-28','2026-01-28'),
  ('33333333-0000-0000-0000-000000000011','OV-2026-0011','2026-01-30','10:30','COT-011','OT-011','CLI-011','Plásticos Lambda SAC','Av. Colonial 1234, Pueblo Libre','Pueblo Libre','Perú','PIE-011','Tornillo hexagonal M12x50',500,'UND','Juan Pérez','Producción','Línea A','ALM-02','DHL','2026-03-08','PENDIENTE','2026-01-30','2026-01-30'),
  ('33333333-0000-0000-0000-000000000012','OV-2026-0012','2026-02-01','08:00','COT-012','OT-012','CLI-012','Metal Mu Corp','Calle Lima 789, Chorrillos','Chorrillos','Perú','PIE-012','Plancha de acero 4mm',12,'PLN','María García','Estructura','Línea B','ALM-03','Cruz del Sur','2026-03-10','PENDIENTE','2026-02-01','2026-02-01'),
  ('33333333-0000-0000-0000-000000000013','OV-2026-0013','2026-02-03','09:45','COT-013','OT-013','CLI-003','Textil Gamma EIRL','Jr. Comercio 789, Miraflores','Miraflores','Perú','PIE-013','Aceite hidráulico ISO 46',4,'GLN','Carlos López','Hidráulica','Línea C','ALM-01','Olva Courier','2026-03-12','CANCELADO','2026-02-03','2026-02-10'),
  ('33333333-0000-0000-0000-000000000014','OV-2026-0014','2026-02-05','10:00','COT-014','OT-014','CLI-004','Minera Delta S.A.','Av. Minera 321, Arequipa','Arequipa','Perú','PIE-014','Grasa litio NLGI 2',6,'KG','Ana Torres','Lubricación','Línea D','ALM-02','Cruz del Sur','2026-03-15','CANCELADO','2026-02-05','2026-02-12'),
  ('33333333-0000-0000-0000-000000000015','OV-2026-0015','2026-02-07','11:00','COT-015','OT-015','CLI-005','Construye Epsilon S.A.C.','Panamericana Norte Km 25','Los Olivos','Perú','PIE-015','Disco de corte 7"',50,'UND','Luis Ramos','Producción','Línea E','ALM-01','Propia','2026-03-18','ENTREGADO','2026-02-07','2026-03-01'),
  ('33333333-0000-0000-0000-000000000016','OV-2026-0016','2026-02-10','08:30','COT-016','OT-016','CLI-006','Farmacéutica Zeta Corp','Av. Salaverry 1500','San Isidro','Perú','PIE-016','Llave torquimétrica 3/4"',2,'UND','Juan Pérez','Taller','Línea A','ALM-02','Urbano','2026-03-20','ENTREGADO','2026-02-10','2026-03-05'),
  ('33333333-0000-0000-0000-000000000017','OV-2026-0017','2026-02-12','09:00','COT-017','OT-017','CLI-007','Agro Eta Perú S.A.','Carretera Central Km 10','Huancayo','Perú','PIE-017','Cinta aislante 3M 20mm',100,'UND','María García','Eléctrica','Línea B','ALM-01','Transportes sur','2026-03-22','DESPACHADO','2026-02-12','2026-03-10'),
  ('33333333-0000-0000-0000-000000000018','OV-2026-0018','2026-02-15','10:15','COT-018','OT-018','CLI-008','Electro Theta S.A.C.','Av. Argentina 2345','Lima','Perú','PIE-018','Interruptor diferencial 63A',4,'UND','Carlos López','Eléctrica','Línea C','ALM-01','DHL','2026-03-25','DESPACHADO','2026-02-15','2026-03-12'),
  ('33333333-0000-0000-0000-000000000019','OV-2026-0019','2026-02-18','11:30','COT-019','OT-019','CLI-009','Logística Iota Cargo','Jr. Ayacucho 456','Breña','Perú','PIE-019','Compresor de aire 50L',1,'UND','Ana Torres','Taller','Línea D','ALM-03','Olva Courier','2026-03-28','EN_PROCESO','2026-02-18','2026-03-15'),
  ('33333333-0000-0000-0000-000000000020','OV-2026-0020','2026-02-20','08:45','COT-020','OT-020','CLI-010','Servicios Kappa SAC','Av. Petit Thouars 3456','Lince','Perú','PIE-020','Soldadora inversora 160A',1,'UND','Luis Ramos','Taller','Línea E','ALM-02','Propia','2026-03-30','EN_PROCESO','2026-02-20','2026-03-18'),
  ('33333333-0000-0000-0000-000000000021','OV-2026-0021','2026-02-22','09:00','COT-021','OT-021','CLI-001','Corporación Alpha S.A.C.','Av. Industrial 123','Ate','Perú','PIE-021','Cojinete de rodillas FAG',8,'UND','Juan Pérez','Producción','Línea A','ALM-01','DHL','2026-04-02','PENDIENTE','2026-02-22','2026-02-22'),
  ('33333333-0000-0000-0000-000000000022','OV-2026-0022','2026-02-25','10:00','COT-022','OT-022','CLI-002','Industrias Beta Perú','Calle Los Olivos 456','Callao','Perú','PIE-022','Sello mecánico 30mm',3,'UND','María García','Hidráulica','Línea B','ALM-02','Urbano','2026-04-05','PENDIENTE','2026-02-25','2026-02-25'),
  ('33333333-0000-0000-0000-000000000023','OV-2026-0023','2026-02-27','11:00','COT-023','OT-023','CLI-003','Textil Gamma EIRL','Jr. Comercio 789','Miraflores','Perú','PIE-023','Cadena de transmisión #40',5,'MT','Carlos López','Transmisión','Línea C','ALM-01','Olva Courier','2026-04-08','PENDIENTE','2026-02-27','2026-02-27'),
  ('33333333-0000-0000-0000-000000000024','OV-2026-0024','2026-03-01','08:30','COT-024','OT-024','CLI-004','Minera Delta S.A.','Av. Minera 321','Arequipa','Perú','PIE-024','Sensor temperatura PT100',2,'UND','Ana Torres','Instrumentación','Línea D','ALM-03','Cruz del Sur','2026-04-10','PENDIENTE','2026-03-01','2026-03-01'),
  ('33333333-0000-0000-0000-000000000025','OV-2026-0025','2026-03-02','09:15','COT-025','OT-025','CLI-005','Construye Epsilon S.A.C.','Panamericana Norte Km 25','Los Olivos','Perú','PIE-025','Reductor de velocidad 1:10',1,'UND','Luis Ramos','Mecánica','Línea E','ALM-02','Propia','2026-04-12','PENDIENTE','2026-03-02','2026-03-02'),
  ('33333333-0000-0000-0000-000000000026','OV-2026-0026','2026-03-03','10:00','COT-026','OT-026','CLI-006','Farmacéutica Zeta Corp','Av. Salaverry 1500','San Isidro','Perú','PIE-026','Manguito de acoplamiento',4,'UND','Juan Pérez','Mecánica','Línea A','ALM-01','DHL','2026-04-15','PENDIENTE','2026-03-03','2026-03-03'),
  ('33333333-0000-0000-0000-000000000027','OV-2026-0027','2026-03-03','11:00','COT-027','OT-027','CLI-007','Agro Eta Perú S.A.','Carretera Central Km 10','Huancayo','Perú','PIE-027','Polea motriz 6"',2,'UND','María García','Transmisión','Línea B','ALM-02','Transportes sur','2026-04-18','EN_PROCESO','2026-03-03','2026-03-04'),
  ('33333333-0000-0000-0000-000000000028','OV-2026-0028','2026-03-04','08:00','COT-028','OT-028','CLI-008','Electro Theta S.A.C.','Av. Argentina 2345','Lima','Perú','PIE-028','Relé térmico 9-13A',3,'UND','Carlos López','Eléctrica','Línea C','ALM-01','Urbano','2026-04-20','EN_PROCESO','2026-03-04','2026-03-05'),
  ('33333333-0000-0000-0000-000000000029','OV-2026-0029','2026-03-04','09:30','COT-029','OT-029','CLI-009','Logística Iota Cargo','Jr. Ayacucho 456','Breña','Perú','PIE-029','Contactor Schneider 25A',5,'UND','Ana Torres','Eléctrica','Línea D','ALM-03','Olva Courier','2026-04-22','DESPACHADO','2026-03-04','2026-03-05'),
  ('33333333-0000-0000-0000-000000000030','OV-2026-0030','2026-03-05','08:45','COT-030','OT-030','CLI-010','Servicios Kappa SAC','Av. Petit Thouars 3456','Lince','Perú','PIE-030','PLC Siemens S7-1200',1,'UND','Luis Ramos','Automatización','Línea E','ALM-02','DHL','2026-04-25','PENDIENTE','2026-03-05','2026-03-05'),
  ('33333333-0000-0000-0000-000000000031','OV-2026-0031','2026-03-05','09:00','COT-031','OT-031','CLI-001','Corporación Alpha S.A.C.','Av. Industrial 123','Ate','Perú','PIE-031','HMI Touch 7"',1,'UND','Juan Pérez','Automatización','Línea A','ALM-01','DHL','2026-04-28','PENDIENTE','2026-03-05','2026-03-05'),
  ('33333333-0000-0000-0000-000000000032','OV-2026-0032','2026-03-05','10:00','COT-032','OT-032','CLI-002','Industrias Beta Perú','Calle Los Olivos 456','Callao','Perú','PIE-032','Encoder incremental 1000ppr',2,'UND','María García','Automatización','Línea B','ALM-03','Urbano','2026-04-30','PENDIENTE','2026-03-05','2026-03-05'),
  ('33333333-0000-0000-0000-000000000033','OV-2026-0033','2026-03-05','11:00','COT-033','OT-033','CLI-003','Textil Gamma EIRL','Jr. Comercio 789','Miraflores','Perú','PIE-033','Variador de frecuencia 2.2KW',1,'UND','Carlos López','Eléctrica','Línea C','ALM-01','Olva Courier','2026-05-02','PENDIENTE','2026-03-05','2026-03-05'),
  ('33333333-0000-0000-0000-000000000034','OV-2026-0034','2026-03-05','08:30','COT-034','OT-034','CLI-004','Minera Delta S.A.','Av. Minera 321','Arequipa','Perú','PIE-034','Manómetro glicerina 0-10bar',4,'UND','Ana Torres','Instrumentación','Línea D','ALM-02','Cruz del Sur','2026-05-05','CANCELADO','2026-03-05','2026-03-05'),
  ('33333333-0000-0000-0000-000000000035','OV-2026-0035','2026-03-05','09:45','COT-035','OT-035','CLI-005','Construye Epsilon S.A.C.','Panamericana Norte Km 25','Los Olivos','Perú','PIE-035','Nivel de burbuja 60cm',3,'UND','Luis Ramos','Medición','Línea E','ALM-01','Propia','2026-05-08','CANCELADO','2026-03-05','2026-03-05'),
  ('33333333-0000-0000-0000-000000000036','OV-2026-0036','2026-03-05','10:30','COT-036','OT-036','CLI-006','Farmacéutica Zeta Corp','Av. Salaverry 1500','San Isidro','Perú','PIE-036','Multímetro digital Fluke',2,'UND','Juan Pérez','Eléctrica','Línea A','ALM-02','DHL','2026-05-10','ENTREGADO','2026-03-05','2026-03-05'),
  ('33333333-0000-0000-0000-000000000037','OV-2026-0037','2026-03-05','11:15','COT-037','OT-037','CLI-007','Agro Eta Perú S.A.','Carretera Central Km 10','Huancayo','Perú','PIE-037','Medidor de caudal DN50',1,'UND','María García','Instrumentación','Línea B','ALM-03','Transportes sur','2026-05-12','ENTREGADO','2026-03-05','2026-03-05'),
  ('33333333-0000-0000-0000-000000000038','OV-2026-0038','2026-03-05','08:15','COT-038','OT-038','CLI-008','Electro Theta S.A.C.','Av. Argentina 2345','Lima','Perú','PIE-038','Transmisor de presión 4-20mA',2,'UND','Carlos López','Instrumentación','Línea C','ALM-01','Urbano','2026-05-15','DESPACHADO','2026-03-05','2026-03-05'),
  ('33333333-0000-0000-0000-000000000039','OV-2026-0039','2026-03-05','09:30','COT-039','OT-039','CLI-009','Logística Iota Cargo','Jr. Ayacucho 456','Breña','Perú','PIE-039','Cámara termográfica Flir',1,'UND','Ana Torres','Mantenimiento','Línea D','ALM-02','DHL','2026-05-18','EN_PROCESO','2026-03-05','2026-03-05'),
  ('33333333-0000-0000-0000-000000000040','OV-2026-0040','2026-03-05','10:45','COT-040','OT-040','CLI-010','Servicios Kappa SAC','Av. Petit Thouars 3456','Lince','Perú','PIE-040','Vibrador de concreto 38mm',1,'UND','Luis Ramos','Construcción','Línea E','ALM-03','Olva Courier','2026-05-20','PENDIENTE','2026-03-05','2026-03-05')
ON CONFLICT (numero_ov) DO NOTHING;

-- --- GUIAS DE REMISION (30 registros) ------------
INSERT INTO public.guias_remision
  (id, numero_gre, ov_id, fecha_emision, hora_emision, cantidad_emitida, estado_gre, emitida_por, programada)
VALUES
  ('44444444-0000-0000-0000-000000000001','GRE-2026-0001','33333333-0000-0000-0000-000000000001','2026-01-18','10:00',10,'COMPLETO','22222222-0000-0000-0000-000000000006',false),
  ('44444444-0000-0000-0000-000000000002','GRE-2026-0002','33333333-0000-0000-0000-000000000002','2026-01-22','11:00',5,'COMPLETO','22222222-0000-0000-0000-000000000007',false),
  ('44444444-0000-0000-0000-000000000003','GRE-2026-0003','33333333-0000-0000-0000-000000000003','2026-01-28','09:00',2,'COMPLETO','22222222-0000-0000-0000-000000000008',false),
  ('44444444-0000-0000-0000-000000000004','GRE-2026-0004','33333333-0000-0000-0000-000000000004','2026-01-26','10:30',15,'PARCIAL','22222222-0000-0000-0000-000000000006',true),
  ('44444444-0000-0000-0000-000000000005','GRE-2026-0005','33333333-0000-0000-0000-000000000005','2026-01-28','08:00',80,'PARCIAL','22222222-0000-0000-0000-000000000007',true),
  ('44444444-0000-0000-0000-000000000006','GRE-2026-0006','33333333-0000-0000-0000-000000000015','2026-02-25','09:00',50,'COMPLETO','22222222-0000-0000-0000-000000000009',false),
  ('44444444-0000-0000-0000-000000000007','GRE-2026-0007','33333333-0000-0000-0000-000000000016','2026-03-03','10:00',2,'COMPLETO','22222222-0000-0000-0000-000000000006',false),
  ('44444444-0000-0000-0000-000000000008','GRE-2026-0008','33333333-0000-0000-0000-000000000017','2026-03-08','11:00',100,'PARCIAL','22222222-0000-0000-0000-000000000007',true),
  ('44444444-0000-0000-0000-000000000009','GRE-2026-0009','33333333-0000-0000-0000-000000000018','2026-03-10','08:30',4,'PARCIAL','22222222-0000-0000-0000-000000000008',false),
  ('44444444-0000-0000-0000-000000000010','GRE-2026-0010','33333333-0000-0000-0000-000000000029','2026-03-04','14:00',5,'COMPLETO','22222222-0000-0000-0000-000000000009',false),
  ('44444444-0000-0000-0000-000000000011','GRE-2026-0011','33333333-0000-0000-0000-000000000036','2026-03-05','10:00',2,'COMPLETO','22222222-0000-0000-0000-000000000006',false),
  ('44444444-0000-0000-0000-000000000012','GRE-2026-0012','33333333-0000-0000-0000-000000000037','2026-03-05','11:00',1,'COMPLETO','22222222-0000-0000-0000-000000000007',false),
  ('44444444-0000-0000-0000-000000000013','GRE-2026-0013','33333333-0000-0000-0000-000000000038','2026-03-05','09:00',2,'PARCIAL','22222222-0000-0000-0000-000000000008',true),
  ('44444444-0000-0000-0000-000000000014','GRE-2026-0014','33333333-0000-0000-0000-000000000006','2026-02-02','10:00',1,'PARCIAL','22222222-0000-0000-0000-000000000009',false),
  ('44444444-0000-0000-0000-000000000015','GRE-2026-0015','33333333-0000-0000-0000-000000000007','2026-02-05','08:00',30,'PARCIAL','22222222-0000-0000-0000-000000000006',true),
  ('44444444-0000-0000-0000-000000000016','GRE-2026-0016','33333333-0000-0000-0000-000000000008','2026-02-07','09:00',150,'PARCIAL','22222222-0000-0000-0000-000000000007',true),
  ('44444444-0000-0000-0000-000000000017','GRE-2026-0017','33333333-0000-0000-0000-000000000019','2026-03-15','10:00',1,'PARCIAL','22222222-0000-0000-0000-000000000008',false),
  ('44444444-0000-0000-0000-000000000018','GRE-2026-0018','33333333-0000-0000-0000-000000000020','2026-03-18','11:00',1,'PARCIAL','22222222-0000-0000-0000-000000000009',false),
  ('44444444-0000-0000-0000-000000000019','GRE-2026-0019','33333333-0000-0000-0000-000000000027','2026-03-04','08:00',2,'PARCIAL','22222222-0000-0000-0000-000000000006',true),
  ('44444444-0000-0000-0000-000000000020','GRE-2026-0020','33333333-0000-0000-0000-000000000028','2026-03-05','09:30',3,'PARCIAL','22222222-0000-0000-0000-000000000007',false),
  ('44444444-0000-0000-0000-000000000021','GRE-2026-0021','33333333-0000-0000-0000-000000000039','2026-03-05','14:00',1,'PARCIAL','22222222-0000-0000-0000-000000000008',false),
  ('44444444-0000-0000-0000-000000000022','GRE-2026-0022','33333333-0000-0000-0000-000000000001','2026-01-19','10:00',0,'PARCIAL','22222222-0000-0000-0000-000000000009',false),
  ('44444444-0000-0000-0000-000000000023','GRE-2026-0023','33333333-0000-0000-0000-000000000002','2026-01-23','11:00',0,'PARCIAL','22222222-0000-0000-0000-000000000006',false),
  ('44444444-0000-0000-0000-000000000024','GRE-2026-0024','33333333-0000-0000-0000-000000000010','2026-03-03','09:00',10,'PARCIAL','22222222-0000-0000-0000-000000000007',true),
  ('44444444-0000-0000-0000-000000000025','GRE-2026-0025','33333333-0000-0000-0000-000000000011','2026-03-04','10:00',300,'PARCIAL','22222222-0000-0000-0000-000000000008',true),
  ('44444444-0000-0000-0000-000000000026','GRE-2026-0026','33333333-0000-0000-0000-000000000021','2026-03-04','11:00',4,'PARCIAL','22222222-0000-0000-0000-000000000009',false),
  ('44444444-0000-0000-0000-000000000027','GRE-2026-0027','33333333-0000-0000-0000-000000000022','2026-03-05','08:00',2,'PARCIAL','22222222-0000-0000-0000-000000000006',false),
  ('44444444-0000-0000-0000-000000000028','GRE-2026-0028','33333333-0000-0000-0000-000000000023','2026-03-05','09:00',4,'PARCIAL','22222222-0000-0000-0000-000000000007',false),
  ('44444444-0000-0000-0000-000000000029','GRE-2026-0029','33333333-0000-0000-0000-000000000024','2026-03-05','10:00',2,'PARCIAL','22222222-0000-0000-0000-000000000008',false),
  ('44444444-0000-0000-0000-000000000030','GRE-2026-0030','33333333-0000-0000-0000-000000000025','2026-03-05','11:00',1,'PARCIAL','22222222-0000-0000-0000-000000000009',false)
ON CONFLICT (numero_gre) DO NOTHING;

-- --- HOJAS DE RUTA (10 registros) ----------------
INSERT INTO public.hojas_ruta (id, fecha, turno, chofer, estado) VALUES
  ('55555555-0000-0000-0000-000000000001','2026-01-18','AM','Roberto Huam�n','CERRADA'),
  ('55555555-0000-0000-0000-000000000002','2026-01-22','PM','Carlos Quispe','CERRADA'),
  ('55555555-0000-0000-0000-000000000003','2026-01-28','AM','Miguel Santos','CERRADA'),
  ('55555555-0000-0000-0000-000000000004','2026-02-03','PM','Roberto Huam�n','CERRADA'),
  ('55555555-0000-0000-0000-000000000005','2026-02-07','AM','Carlos Quispe','CERRADA'),
  ('55555555-0000-0000-0000-000000000006','2026-03-03','AM','Miguel Santos','CERRADA'),
  ('55555555-0000-0000-0000-000000000007','2026-03-04','PM','Roberto Huam�n','EN_RUTA'),
  ('55555555-0000-0000-0000-000000000008','2026-03-05','AM','Carlos Quispe','EN_RUTA'),
  ('55555555-0000-0000-0000-000000000009','2026-03-05','PM','Miguel Santos','ABIERTA'),
  ('55555555-0000-0000-0000-000000000010','2026-03-05','AM','Fernando Paz','ABIERTA');

-- --- HOJA RUTA GUIAS ------------------------------
INSERT INTO public.hoja_ruta_guias (id, hoja_ruta_id, guia_id) VALUES
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000001','44444444-0000-0000-0000-000000000001'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000001','44444444-0000-0000-0000-000000000002'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000002','44444444-0000-0000-0000-000000000003'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000003','44444444-0000-0000-0000-000000000004'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000003','44444444-0000-0000-0000-000000000005'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000004','44444444-0000-0000-0000-000000000006'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000005','44444444-0000-0000-0000-000000000007'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000006','44444444-0000-0000-0000-000000000010'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000006','44444444-0000-0000-0000-000000000011'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000007','44444444-0000-0000-0000-000000000012'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000007','44444444-0000-0000-0000-000000000013'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000008','44444444-0000-0000-0000-000000000019'),
  (uuid_generate_v4(),'55555555-0000-0000-0000-000000000008','44444444-0000-0000-0000-000000000020');

-- --- CIERRE GUIAS --------------------------------
INSERT INTO public.cierre_guias (guia_id, hora_inicio, km_inicio, hora_fin, km_fin, observaciones, documentos_entregados, estado_entrega) VALUES
  ('44444444-0000-0000-0000-000000000001','08:30',15000.50,'10:15',15045.00,'Entrega sin novedades',true,'COMPLETO'),
  ('44444444-0000-0000-0000-000000000002','09:00',22500.00,'11:00',22560.00,'Cliente ausente, dej� con portero',true,'COMPLETO'),
  ('44444444-0000-0000-0000-000000000003','10:00',8750.00,'12:30',8810.00,'Entrega completa, firm� conformidad',true,'COMPLETO'),
  ('44444444-0000-0000-0000-000000000006','08:00',31200.00,'10:00',31255.00,'Sin observaciones',true,'COMPLETO'),
  ('44444444-0000-0000-0000-000000000007','09:30',45000.00,'11:30',45062.00,'Entrega OK',true,'COMPLETO'),
  ('44444444-0000-0000-0000-000000000010','14:00',18900.00,'15:45',18935.00,'Entrega urgente completada',true,'COMPLETO'),
  ('44444444-0000-0000-0000-000000000011','10:00',27500.00,'11:30',27535.00,'Cliente conforme',true,'COMPLETO'),
  ('44444444-0000-0000-0000-000000000004','10:30',12000.00,'13:00',12055.00,'Entrega parcial, 5 unidades pendientes',false,'PARCIAL'),
  ('44444444-0000-0000-0000-000000000005','08:00',19800.00,'11:30',19870.00,'Solo 80 bolsas entregadas de 100',false,'PARCIAL');

-- --- CIERRE HOJA DE RUTA -------------------------
INSERT INTO public.cierre_hoja_ruta (hoja_ruta_id) VALUES
  ('55555555-0000-0000-0000-000000000001'),
  ('55555555-0000-0000-0000-000000000002'),
  ('55555555-0000-0000-0000-000000000003'),
  ('55555555-0000-0000-0000-000000000004'),
  ('55555555-0000-0000-0000-000000000005'),
  ('55555555-0000-0000-0000-000000000006');

-- --- ADJUNTOS DE GUIAS ---------------------------
INSERT INTO public.adjuntos_guias (guia_id, nombre_archivo, url_storage) VALUES
  ('44444444-0000-0000-0000-000000000001','conformidad_gre001.pdf','https://storage.supabase.co/demo/conformidad_gre001.pdf'),
  ('44444444-0000-0000-0000-000000000002','guia_firmada_002.pdf','https://storage.supabase.co/demo/guia_firmada_002.pdf'),
  ('44444444-0000-0000-0000-000000000003','foto_entrega_003.jpg','https://storage.supabase.co/demo/foto_entrega_003.jpg'),
  ('44444444-0000-0000-0000-000000000006','recepcion_006.pdf','https://storage.supabase.co/demo/recepcion_006.pdf'),
  ('44444444-0000-0000-0000-000000000010','urgente_conformidad_010.pdf','https://storage.supabase.co/demo/urgente_010.pdf');

-- --- NOTAS / MENSAJES (30 registros) -------------
INSERT INTO public.notas (ov_id, ov_num, user_name, user_role, texto, fecha_hora) VALUES
  ('33333333-0000-0000-0000-000000000001','OV-2026-0001','juan.perez','VENDEDOR','Cliente confirma disponibilidad para recibir el lunes 20/01.','2026-01-06 09:15:00'),
  ('33333333-0000-0000-0000-000000000001','OV-2026-0001','pedro.mendez','OPERADOR_ALMACEN','Stock verificado. 10 unidades disponibles en ALM-01.','2026-01-06 10:30:00'),
  ('33333333-0000-0000-0000-000000000001','OV-2026-0001','juan.perez','VENDEDOR','Perfecto. Coordinar despacho para el viernes 17/01.','2026-01-06 11:00:00'),
  ('33333333-0000-0000-0000-000000000002','OV-2026-0002','maria.garcia','VENDEDOR','Urgente: cliente necesita entrega antes del 25/01.','2026-01-08 08:00:00'),
  ('33333333-0000-0000-0000-000000000002','OV-2026-0002','rosa.vargas','OPERADOR_ALMACEN','Tramitando gu�a de remisi�n con prioridad.','2026-01-08 09:00:00'),
  ('33333333-0000-0000-0000-000000000003','OV-2026-0003','carlos.lopez','VENDEDOR','Cliente solicita embalaje especial para el motor.','2026-01-11 10:00:00'),
  ('33333333-0000-0000-0000-000000000003','OV-2026-0003','jose.silva','OPERADOR_ALMACEN','Motor embalado con espuma protectora. Listo para despacho.','2026-01-11 14:00:00'),
  ('33333333-0000-0000-0000-000000000004','OV-2026-0004','ana.torres','VENDEDOR','Arequipa requiere transportista especial. Coordinando con Cruz del Sur.','2026-01-13 09:00:00'),
  ('33333333-0000-0000-0000-000000000004','OV-2026-0004','pedro.mendez','OPERADOR_ALMACEN','Cruz del Sur confirm� recojo para el lunes. Mercader�a lista.','2026-01-13 11:00:00'),
  ('33333333-0000-0000-0000-000000000005','OV-2026-0005','luis.ramos','VENDEDOR','Cliente acepta entrega en dos partes: 80 bolsas primero, 20 despu�s.','2026-01-16 08:30:00'),
  ('33333333-0000-0000-0000-000000000006','OV-2026-0006','juan.perez','VENDEDOR','Bomba requiere certificado de origen. Solicitado al proveedor.','2026-01-19 09:00:00'),
  ('33333333-0000-0000-0000-000000000006','OV-2026-0006','rosa.vargas','OPERADOR_ALMACEN','Certificado recibido. Adjuntando a la gu�a.','2026-01-19 14:00:00'),
  ('33333333-0000-0000-0000-000000000007','OV-2026-0007','maria.garcia','VENDEDOR','Ruta a Huancayo: carretera central. Confirmar fecha con chofer.','2026-01-21 10:00:00'),
  ('33333333-0000-0000-0000-000000000008','OV-2026-0008','carlos.lopez','VENDEDOR','200 metros de cable. Solicitar bobina completa al almac�n.','2026-01-23 09:00:00'),
  ('33333333-0000-0000-0000-000000000008','OV-2026-0008','jose.silva','OPERADOR_ALMACEN','Bobina pesada 85kg. Necesitamos montacargas para carga.','2026-01-23 10:30:00'),
  ('33333333-0000-0000-0000-000000000009','OV-2026-0009','ana.torres','VENDEDOR','30 paletas para almac�n Bre�a. Coordinar horario de ingreso.','2026-01-26 08:00:00'),
  ('33333333-0000-0000-0000-000000000010','OV-2026-0010','luis.ramos','VENDEDOR','Filtros de aceite - revisar n�mero de parte antes de despachar.','2026-01-29 09:00:00'),
  ('33333333-0000-0000-0000-000000000010','OV-2026-0010','elena.rios','OPERADOR_ALMACEN','Confirmado n�mero de parte W68/5. Stock disponible ALM-01.','2026-01-29 10:00:00'),
  ('33333333-0000-0000-0000-000000000013','OV-2026-0013','carlos.lopez','VENDEDOR','CANCELADO: Cliente cambi� especificaci�n. Requieren ISO 68 no 46.','2026-02-10 09:00:00'),
  ('33333333-0000-0000-0000-000000000014','OV-2026-0014','ana.torres','VENDEDOR','CANCELADO: Minera paus� proyecto de mantenimiento por 3 meses.','2026-02-12 10:00:00'),
  ('33333333-0000-0000-0000-000000000019','OV-2026-0019','ana.torres','VENDEDOR','Compresor de gran volumen. Confirmar acceso al �rea de recepci�n.','2026-02-19 09:00:00'),
  ('33333333-0000-0000-0000-000000000020','OV-2026-0020','luis.ramos','VENDEDOR','Soldadora en camino. ETA estimado: 3-4 d�as h�biles.','2026-03-18 10:00:00'),
  ('33333333-0000-0000-0000-000000000028','OV-2026-0028','carlos.lopez','VENDEDOR','Rel�s solicitados urgente para arranque de compresor ma�ana.','2026-03-04 15:00:00'),
  ('33333333-0000-0000-0000-000000000028','OV-2026-0028','pedro.mendez','OPERADOR_ALMACEN','Stock en ALM-01: 5 rel�s disponibles. Gu�a en proceso.','2026-03-04 15:30:00'),
  ('33333333-0000-0000-0000-000000000029','OV-2026-0029','ana.torres','VENDEDOR','5 contactores para tablero el�ctrico. Ya despachado con GRE-0010.','2026-03-04 16:00:00'),
  ('33333333-0000-0000-0000-000000000030','OV-2026-0030','luis.ramos','VENDEDOR','PLC Siemens importado. Llegar� en 5-7 d�as h�biles al almac�n.','2026-03-05 08:00:00'),
  ('33333333-0000-0000-0000-000000000039','OV-2026-0039','ana.torres','VENDEDOR','C�mara termogr�fica para inspecci�n el�ctrica. Cliente muy urgente.','2026-03-05 09:00:00'),
  ('33333333-0000-0000-0000-000000000039','OV-2026-0039','elena.rios','OPERADOR_ALMACEN','Equipo delicado. Embalaje especial con caja r�gida y separadores de espuma.','2026-03-05 09:30:00'),
  ('33333333-0000-0000-0000-000000000001','OV-2026-0001','pedro.mendez','OPERADOR_ALMACEN','Gu�a GRE-2026-0001 emitida y firmada. Entrega confirmada por cliente.','2026-01-20 15:00:00'),
  ('33333333-0000-0000-0000-000000000002','OV-2026-0002','rosa.vargas','OPERADOR_ALMACEN','Gu�a GRE-2026-0002 entregada sin novedades. OV cerrada.','2026-01-25 16:00:00');

-- --- NOTA IMAGENES (10 notas con imagen base64) --
-- Las notas con imagen corresponden a los ids 1, 4, 7, 11, 13, 15, 22, 24, 27, 28
-- (Se usa el id secuencial que postgresql asigna; el INSERT previo genera ids del 1 al 30)
-- Imagen PNG 1x1 pixel verde (base64 m�nimo v�lido de demostraci�n)
WITH nota_ids AS (
  SELECT id FROM public.notas ORDER BY id LIMIT 30
),
selected AS (
  SELECT id, row_number() OVER() as rn FROM nota_ids
)
INSERT INTO public.nota_imagenes (nota_id, base64_data)
SELECT id,
  CASE (rn % 3)
    WHEN 0 THEN 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg=='
    WHEN 1 THEN 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFUlEQVR42mP8z8BQDwADhQGAWjR9awAAAABJRU5ErkJggg=='
    ELSE      'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFUlEQVR42mNkYPhfDwAChAGA60e6kgAAAABJRU5ErkJggg=='
  END
FROM selected
WHERE rn IN (1, 4, 7, 11, 13, 15, 22, 24, 27, 28);

-- =====================================================
-- FIN DEL SCRIPT DE DATOS
-- Total: 5 roles, 10 users, 40 OVs, 30 guias,
--        10 hojas ruta, 30 notas, 10 nota_imagenes
-- =====================================================
