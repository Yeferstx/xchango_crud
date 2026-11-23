-- Datos de ejemplo (salen de los JSON del cliente). Ejecutar despues de 01_esquema.sql
INSERT INTO municipios (nombre) VALUES
  ('Yopal'),
  ('Aguazul'),
  ('Chámeza'),
  ('Hato Corozal'),
  ('La Salina'),
  ('Maní'),
  ('Monterrey'),
  ('Nunchía'),
  ('Orocué'),
  ('Paz de Ariporo'),
  ('Pore'),
  ('Recetor'),
  ('Sabanalarga'),
  ('Sácama'),
  ('San Luis de Palenque'),
  ('Támara'),
  ('Tauramena'),
  ('Trinidad'),
  ('Villanueva');

INSERT INTO categorias (id,nombre,icono) VALUES
  ('cat1','Electrónicos','phone'),
  ('cat2','Vehículos','car'),
  ('cat3','Ropa y accesorios','shirt'),
  ('cat4','Hogar y muebles','home'),
  ('cat5','Deportes','bike'),
  ('cat6','Videojuegos','gamepad'),
  ('cat7','Servicios profesionales','tools'),
  ('cat8','Recursos digitales','book');

INSERT INTO avisos_ubicacion (id,municipio_id,titulo,mensaje,icono) VALUES
  ('av1',(SELECT id FROM municipios WHERE nombre='Yopal'),'7 trueques cerca de ti','Hay publicaciones nuevas en tu municipio esta semana.','location_on'),
  ('av2',(SELECT id FROM municipios WHERE nombre='Aguazul'),'3 trueques cerca de ti','Revisa lo que están ofreciendo en Aguazul.','location_on'),
  ('av3',(SELECT id FROM municipios WHERE nombre='Villanueva'),'2 trueques cerca de ti','Nuevas publicaciones en Villanueva.','location_on'),
  ('av4',(SELECT id FROM municipios WHERE nombre='Tauramena'),'1 trueque cerca de ti','Alguien publicó un servicio en Tauramena.','location_on'),
  ('av5',NULL,'Elige tu municipio','Así te mostramos primero los trueques que tienes cerca.','place');

INSERT INTO usuarios (id,nombre,apellido,fecha_nacimiento,email,telefono,municipio_id,direccion,barrio,avatar,descripcion,estado,verificacion,fecha_registro) VALUES
  ('u1','Carlos','Ospina','1994-03-12','carlos.ospina@mail.com','3143025871',(SELECT id FROM municipios WHERE nombre='Yopal'),'Calle 30 # 15-20','El Triunfo','https://i.pravatar.cc/80?img=12','Cambio tecnología y bicicletas. Respondo rápido por WhatsApp.','activo','verificado','2026-01-14'),
  ('u2','Daniela','Torres','1991-07-25','daniela.torres@mail.com','3125540912',(SELECT id FROM municipios WHERE nombre='Aguazul'),'Carrera 14 # 8-45','Centro','https://i.pravatar.cc/80?img=33','Profesora de inglés. Intercambio clases por diseño o servicios.','activo','verificado','2026-02-03'),
  ('u3','Andrés','Molina','1999-11-02','andres.molina@mail.com','3208814476',(SELECT id FROM municipios WHERE nombre='Yopal'),'Calle 12 # 22-10','La Campiña','https://i.pravatar.cc/80?img=15','Interesado en electrónica y accesorios.','suspendido','no_verificado','2026-02-21'),
  ('u4','Valentina','Ríos','1996-05-18','valentina.rios@mail.com','3116729305',(SELECT id FROM municipios WHERE nombre='Villanueva'),'Carrera 9 # 5-31','Villa Rosa','https://i.pravatar.cc/80?img=47','Diseñadora gráfica. Ofrezco identidad de marca por servicios o equipos.','activo','verificado','2026-03-08'),
  ('u5','Jhon','Barrera','1990-09-30','jhon.barrera@mail.com','3182203648',(SELECT id FROM municipios WHERE nombre='Tauramena'),'Calle 8 # 10-14','Centro','https://i.pravatar.cc/80?img=51','Técnico en sistemas. Hago mantenimiento a cambio de otros servicios.','advertido','verificado','2026-03-19'),
  ('u6','Camila','Sanabria','2001-01-21','camila.sanabria@mail.com','3007719284',(SELECT id FROM municipios WHERE nombre='Yopal'),'Carrera 20 # 33-07','El Remanso','https://i.pravatar.cc/80?img=22','Toco guitarra y doy clases. Busco ropa y accesorios.','activo','verificado','2026-04-02'),
  ('u7','Sebastián','Nieto','2003-04-09','sebastian.nieto@mail.com','3193348017',(SELECT id FROM municipios WHERE nombre='Monterrey'),'Calle 15 # 7-52','San Jorge','https://i.pravatar.cc/80?img=60','Nuevo en XchanGo, explorando la plataforma.','activo','no_verificado','2026-04-27'),
  ('u8','Paola','Guzmán','1998-12-14','paola.guzman@mail.com','3156604733',(SELECT id FROM municipios WHERE nombre='Yopal'),'Carrera 11 # 24-18','La Campiña','https://i.pravatar.cc/80?img=29','Intercambio ropa en buen estado y calzado deportivo.','activo','verificado','2026-05-11'),
  ('u9','Ricardo','Fonseca','1987-06-03','ricardo.fonseca@mail.com','3134417950',(SELECT id FROM municipios WHERE nombre='Aguazul'),'Calle 22 # 18-40','Brisas del Cravo','https://i.pravatar.cc/80?img=53','Perfil con reportes pendientes de revisión.','suspendido','no_verificado','2026-05-23'),
  ('u10','Luisa','Cárdenas','1989-08-27','luisa.cardenas@mail.com','3172286104',(SELECT id FROM municipios WHERE nombre='Maní'),'Carrera 5 # 12-09','Centro','https://i.pravatar.cc/80?img=44','Contadora. Ofrezco asesoría a cambio de clases o servicios.','activo','verificado','2026-06-05'),
  ('u11','Óscar','Peña','1993-02-16','oscar.pena@mail.com','3109935627',(SELECT id FROM municipios WHERE nombre='Paz de Ariporo'),'Calle 6 # 9-23','San Jorge','https://i.pravatar.cc/80?img=8','Trabajo en jardinería y mantenimiento de zonas verdes.','activo','verificado','2026-06-18'),
  ('u12','Natalia','Suárez','1995-10-05','natalia.suarez@mail.com','3145572380',(SELECT id FROM municipios WHERE nombre='Yopal'),'Carrera 16 # 29-35','El Triunfo','https://i.pravatar.cc/80?img=26','Comparto recursos digitales y muebles de hogar.','activo','verificado','2026-07-01'),
  ('u13','Julián','Ospina','1992-03-29','julian.ospina@mail.com','3163308291',(SELECT id FROM municipios WHERE nombre='Villanueva'),'Calle 18 # 14-60','Villa Rosa','https://i.pravatar.cc/80?img=9','Busco muebles para mi apartamento. Ofrezco comedor y electrodomésticos.','activo','verificado','2026-07-14'),
  ('u14','Marcela','Vega','2000-07-08','marcela.vega@mail.com','3021146758',(SELECT id FROM municipios WHERE nombre='Yopal'),'Carrera 8 # 20-12','Villa Rosa','https://i.pravatar.cc/80?img=41','Cuenta con advertencia activa.','advertido','no_verificado','2026-07-26'),
  ('u15','Diego','Salamanca','1997-11-19','diego.salamanca@mail.com','3187760413',(SELECT id FROM municipios WHERE nombre='Aguazul'),'Calle 25 # 11-05','El Remanso','https://i.pravatar.cc/80?img=4','Edito video. Intercambio ediciones por plantillas o cursos.','activo','verificado','2026-08-04');

CREATE EXTENSION IF NOT EXISTS pgcrypto;
INSERT INTO administradores (id,nombre,email,password_hash,rol,estado,avatar,ultimo_acceso) VALUES
  ('a1','Miguel Admin','admin@xchango.com',crypt('admin123',gen_salt('bf',10)),'admin','activo','https://i.pravatar.cc/80?img=68','2026-08-18T09:12:00'),
  ('a2','Ana Moderadora','moderador@xchango.com',crypt('mod123',gen_salt('bf',10)),'moderador','activo','https://i.pravatar.cc/80?img=45','2026-08-17T18:40:00');

INSERT INTO publicaciones (id,usuario_id,categoria_id,tipo,titulo,descripcion,ofreces,buscas,municipio_id,barrio,cantidad_disponible,disponibilidad,estado,vistas,fecha_creacion,fecha_modificacion) VALUES
  ('pub1','u1','cat1','bien_fisico','iPhone 13 de 128 GB','Celular en excelente estado, con caja y cargador original. Batería al 89 %.','iPhone 13 de 128 GB','Consola de videojuegos o portátil',(SELECT id FROM municipios WHERE nombre='Yopal'),'El Triunfo','1 unidad','Fines de semana','activa',214,'2026-08-12','2026-08-16'),
  ('pub2','u1','cat5','bien_fisico','Bicicleta todoterreno rin 29','Bicicleta de montaña con 21 cambios, frenos de disco y llantas nuevas.','Bicicleta todoterreno rin 29','PlayStation 5 o Nintendo Switch',(SELECT id FROM municipios WHERE nombre='Yopal'),'La Campiña','1 unidad','Lunes a viernes en la tarde','finalizada',341,'2026-07-28','2026-07-28'),
  ('pub3','u1','cat8','bien_digital','Plantillas premium para Canva','Paquete de 40 plantillas editables para redes sociales y presentaciones.','Paquete de plantillas premium para Canva','Diseño de logo o edición de video',NULL,NULL,NULL,NULL,'activa',128,'2026-08-15','2026-08-15'),
  ('pub4','u4','cat6','bien_fisico','PlayStation 5 con dos controles','Consola con dos controles inalámbricos y tres juegos físicos incluidos.','PlayStation 5 con dos controles','Portátil para diseño o cámara réflex',(SELECT id FROM municipios WHERE nombre='Villanueva'),'Centro','1 unidad','Disponible todos los días','activa',487,'2026-08-09','2026-08-13'),
  ('pub5','u4','cat7','servicio','Diseño de logo e identidad de marca','Diseño de logotipo, paleta de colores y manual básico de marca.','Diseño de logo e identidad de marca','Clases de inglés o asesoría contable',(SELECT id FROM municipios WHERE nombre='Villanueva'),NULL,'3 sesiones','Martes y jueves de 5:00 PM a 8:00 PM','activa',176,'2026-08-11','2026-08-11'),
  ('pub6','u12','cat4','bien_fisico','Juego de sala de 3 puestos','Sofá de tres puestos en tela, sin roturas ni manchas. Se entrega desarmado.','Juego de sala de 3 puestos','Comedor de 4 puestos o nevera pequeña',(SELECT id FROM municipios WHERE nombre='Yopal'),'Los Helechos','1 unidad','Fines de semana','pausada',95,'2026-08-02','2026-08-05'),
  ('pub7','u12','cat8','bien_digital','Curso digital de Excel básico','Curso en video de 12 lecciones con archivos de práctica y certificado.','Curso digital de Excel básico','Curso de inglés o plantillas de diseño',NULL,NULL,NULL,NULL,'activa',263,'2026-08-14','2026-08-14'),
  ('pub8','u8','cat3','bien_fisico','Chaqueta de cuero talla M','Chaqueta de cuero genuino, usada dos veces, sin desgaste.','Chaqueta de cuero talla M','Zapatillas deportivas talla 40 o audífonos',(SELECT id FROM municipios WHERE nombre='Yopal'),'El Centro','1 unidad','Fines de semana','finalizada',152,'2026-07-19','2026-07-19'),
  ('pub9','u2','cat7','servicio','Clases de inglés personalizadas','Clases uno a uno enfocadas en conversación, desde nivel básico hasta intermedio.','Clases de inglés personalizadas','Diseño de logo o reparación de computador',(SELECT id FROM municipios WHERE nombre='Aguazul'),NULL,'5 sesiones','Lunes y miércoles de 4:00 PM a 7:00 PM','activa',198,'2026-08-06','2026-08-10'),
  ('pub10','u5','cat7','servicio','Reparación de computadores','Mantenimiento preventivo, cambio de pasta térmica e instalación de sistema operativo.','Reparación y mantenimiento de computadores','Clases de guitarra o trabajos de jardinería',(SELECT id FROM municipios WHERE nombre='Tauramena'),NULL,'4 horas','Sábados de 8:00 AM a 12:00 M','activa',143,'2026-08-08','2026-08-08'),
  ('pub11','u9','cat4','bien_fisico','Licores artesanales hechos en casa','Publicación retirada por incumplir las normas de la comunidad.','Licores artesanales hechos en casa','Electrodomésticos pequeños',(SELECT id FROM municipios WHERE nombre='Aguazul'),'San Agustín','6 unidades','Fines de semana','eliminada',61,'2026-08-04','2026-08-04'),
  ('pub12','u3','cat8','bien_digital','Cuenta de streaming compartida','Publicación retirada por incumplir las normas de la comunidad.','Acceso a cuenta de streaming compartida','Licencia de software o curso digital',NULL,NULL,NULL,NULL,'eliminada',88,'2026-08-01','2026-08-01'),
  ('pub13','u14','cat1','bien_fisico','Documentos de trámite personal','Publicación retirada por incumplir las normas de la comunidad.','Gestión de documentos de trámite personal','Recargas o accesorios de celular',(SELECT id FROM municipios WHERE nombre='Yopal'),'Villa Rosa','2 unidades','Entre semana','eliminada',37,'2026-07-25','2026-07-25'),
  ('pub14','u10','cat2','bien_fisico','Moto Pulsar NS 200 modelo 2021','Moto en buen estado, papeles al día y mantenimiento reciente.','Moto Pulsar NS 200 modelo 2021','Carro pequeño o moto de mayor cilindraje',(SELECT id FROM municipios WHERE nombre='Maní'),'San Jorge','1 unidad','Fines de semana','activa',0,'2026-08-19','2026-08-19');

INSERT INTO publicacion_imagenes (publicacion_id,url,orden) VALUES
  ('pub1','https://images.unsplash.com/photo-1632661674596-df8be070a5c5?w=900&q=80',1),
  ('pub2','https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=900&q=80',1),
  ('pub3','https://images.unsplash.com/photo-1626785774573-4b799315345d?w=900&q=80',1),
  ('pub4','https://images.unsplash.com/photo-1587202372634-32705e3bf49c?w=900&q=80',1),
  ('pub5','https://images.unsplash.com/photo-1558877385-81a1c7e67d72?w=900&q=80',1),
  ('pub6','https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=900&q=80',1),
  ('pub7','https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=900&q=80',1),
  ('pub8','https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=900&q=80',1),
  ('pub9','https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=900&q=80',1),
  ('pub10','https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&q=80',1),
  ('pub11','https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=900&q=80',1),
  ('pub12','https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=900&q=80',1),
  ('pub13','https://images.unsplash.com/photo-1445205170230-053b83016050?w=900&q=80',1),
  ('pub14','https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=900&q=80',1);

INSERT INTO trueques (id,publicacion_id,solicitante_id,propietario_id,ofrece,busca,estado,fecha_solicitud,fecha_cierre,confirmado_solicitante,confirmado_propietario,calificacion_solicitante,calificacion_propietario) VALUES
  ('tr1','pub2','u4','u1','PlayStation 5 con dos controles','Bicicleta todoterreno rin 29','completado','2026-07-30','2026-08-03',TRUE,TRUE,5,5),
  ('tr2','pub2','u12','u1','Juego de sala de 3 puestos','Bicicleta todoterreno rin 29','rechazado','2026-07-31','2026-08-01',FALSE,FALSE,NULL,NULL),
  ('tr3','pub8','u6','u8','Clases de guitarra','Chaqueta de cuero talla M','completado','2026-07-22','2026-07-27',TRUE,TRUE,4,5),
  ('tr4','pub4','u1','u4','iPhone 13 de 128 GB','PlayStation 5 con dos controles','aceptado','2026-08-16',NULL,FALSE,FALSE,NULL,NULL),
  ('tr5','pub7','u1','u12','Paquete de plantillas premium para Canva','Curso digital de Excel básico','completado','2026-08-15','2026-08-16',TRUE,TRUE,5,4),
  ('tr6','pub5','u2','u4','Clases de inglés personalizadas','Diseño de logo e identidad de marca','aceptado','2026-08-13',NULL,FALSE,FALSE,NULL,NULL),
  ('tr7','pub6','u13','u12','Comedor de 4 puestos','Juego de sala de 3 puestos','pendiente','2026-08-18',NULL,FALSE,FALSE,NULL,NULL),
  ('tr8','pub9','u10','u2','Asesoría contable básica','Clases de inglés personalizadas','pendiente','2026-08-19',NULL,FALSE,FALSE,NULL,NULL),
  ('tr9','pub10','u11','u5','Trabajos de jardinería','Reparación y mantenimiento de computadores','pendiente','2026-08-19',NULL,FALSE,FALSE,NULL,NULL),
  ('tr10','pub3','u15','u1','Edición de video corto','Paquete de plantillas premium para Canva','completado','2026-08-17','2026-08-18',TRUE,TRUE,4,4),
  ('tr11','pub4','u7','u4','Balón de baloncesto oficial','PlayStation 5 con dos controles','rechazado','2026-08-12','2026-08-13',FALSE,FALSE,NULL,NULL),
  ('tr12','pub7','u8','u12','Zapatillas deportivas talla 40','Curso digital de Excel básico','completado','2026-08-10','2026-08-12',TRUE,TRUE,5,5);

INSERT INTO notificaciones (id,usuario_id,tipo,referencia_id,titulo,mensaje,leida,fecha) VALUES
  ('not1','u12','solicitud','tr7','Nueva solicitud de trueque','Julián Ospina quiere truequear por tu publicación "Juego de sala de 3 puestos".',FALSE,'2026-08-18T10:12:00'),
  ('not2','u2','solicitud','tr8','Nueva solicitud de trueque','Luisa Cárdenas quiere truequear por tu publicación "Clases de inglés personalizadas".',FALSE,'2026-08-19T09:05:00'),
  ('not3','u5','solicitud','tr9','Nueva solicitud de trueque','Óscar Peña quiere truequear por tu publicación "Reparación de computadores".',FALSE,'2026-08-19T14:40:00'),
  ('not4','u2','aceptada','tr6','Tu solicitud fue aceptada','Valentina Ríos aceptó tu propuesta. Continúa la negociación por WhatsApp.',TRUE,'2026-08-14T16:30:00'),
  ('not5','u12','rechazada','tr2','Tu solicitud fue rechazada','Carlos Ospina rechazó tu propuesta por "Bicicleta todoterreno rin 29".',TRUE,'2026-08-01T11:20:00');

INSERT INTO documentos (id,usuario_id,tipo_documento,numero,archivo,fecha_subida,estado,observacion,revisado_por) VALUES
  ('doc1','u3','Cédula de ciudadanía','1118543210','cedula-andres-molina.jpg','2026-08-14','pendiente','',NULL),
  ('doc2','u7','Cédula de ciudadanía','1006778941','cedula-sebastian-nieto.jpg','2026-08-16','pendiente','',NULL),
  ('doc3','u9','Cédula de ciudadanía','1120334455','cedula-ricardo-fonseca.jpg','2026-08-10','rechazado','La foto está borrosa y no se lee el número.','a1'),
  ('doc4','u14','Cédula de extranjería','E-448120','cedula-marcela-vega.jpg','2026-08-12','pendiente','',NULL),
  ('doc5','u1','Cédula de ciudadanía','1118220145','cedula-carlos-ospina.jpg','2026-08-05','aprobado','Documento legible y coincide con el perfil.','a1'),
  ('doc6','u2','Cédula de ciudadanía','1006554120','cedula-daniela-torres.jpg','2026-08-06','aprobado','Verificado sin novedad.','a2');

INSERT INTO reportes (id,publicacion_id,reportante_id,motivo,fecha,estado,gravedad) VALUES
  ('rep1','pub11','u7','Producto no permitido','2026-08-05','eliminada','alta'),
  ('rep2','pub11','u10','Posible estafa','2026-08-06','pendiente','alta'),
  ('rep3','pub11','u13','Información engañosa','2026-08-07','pendiente','alta'),
  ('rep4','pub12','u15','Servicio no permitido','2026-08-02','eliminada','alta'),
  ('rep5','pub12','u11','Contenido inapropiado','2026-08-03','pendiente','alta'),
  ('rep6','pub13','u2','Contenido inapropiado','2026-07-26','eliminada','media'),
  ('rep7','pub10','u4','Información engañosa','2026-08-16','aprobada','media'),
  ('rep8','pub6','u5','Categoría incorrecta','2026-08-12','aprobada','baja'),
  ('rep9','pub9','u14','Datos de contacto externos','2026-08-17','pendiente','media'),
  ('rep10','pub1','u3','Descripción no corresponde','2026-08-18','pendiente','baja');

INSERT INTO publicaciones_eliminadas (id,publicacion_id,usuario_id,admin_id,motivo,fecha) VALUES
  ('el1','pub11','u9','a1','Producto no permitido','2026-08-10'),
  ('el2','pub12','u3','a2','Servicio no permitido','2026-08-08'),
  ('el3','pub13','u14','a2','Contenido inapropiado','2026-08-02');

INSERT INTO historial_acciones (id,usuario_id,admin_id,accion,descripcion,fecha) VALUES
  ('ac1','u9','a1','Suspensión','Cuenta suspendida por reportes reiterados.','2026-08-17T16:20:00'),
  ('ac2','u5','a2','Advertencia','Advertencia enviada por información engañosa en una publicación.','2026-08-16T11:05:00'),
  ('ac3','u14','a2','Eliminación','Publicación eliminada por contenido inapropiado.','2026-08-02T09:40:00'),
  ('ac4','u12','a2','Aprobación','Reporte revisado y descartado.','2026-08-12T15:10:00'),
  ('ac5','u14','a1','Advertencia','Advertencia por publicar contenido no permitido.','2026-07-27T08:55:00'),
  ('ac6','u3','a1','Suspensión','Cuenta suspendida tras acumular reportes.','2026-08-09T17:30:00'),
  ('ac7','u9','a1','Eliminación','Publicación eliminada por producto no permitido.','2026-08-10T14:02:00'),
  ('ac8','u3','a2','Eliminación','Publicación eliminada por servicio no permitido.','2026-08-08T10:48:00');

INSERT INTO alertas (id,tipo,titulo,mensaje,fecha,leida,prioridad) VALUES
  ('al1','sospechosa','Actividad inusual detectada','El usuario Ricardo Fonseca creó 5 publicaciones en menos de 10 minutos.','2026-08-18T08:45:00',FALSE,'alta'),
  ('al2','moderacion','Publicaciones pendientes de revisión','Hay reportes de publicaciones esperando revisión.','2026-08-18T07:30:00',FALSE,'media'),
  ('al3','usuario','Usuario con múltiples reportes','Ricardo Fonseca acumula varios reportes en los últimos 30 días.','2026-08-17T20:15:00',FALSE,'alta'),
  ('al4','sistema','Respaldo completado','La copia de seguridad diaria finalizó correctamente.','2026-08-17T02:00:00',TRUE,'baja'),
  ('al5','sospechosa','Intentos de acceso fallidos','Se registraron 12 intentos fallidos de inicio de sesión desde la misma IP.','2026-08-16T23:18:00',FALSE,'media'),
  ('al6','moderacion','Categoría con aumento de reportes','La categoría Electrónicos duplicó sus reportes esta semana.','2026-08-16T10:05:00',TRUE,'baja');

-- las secuencias siguen despues del ultimo id de ejemplo
SELECT setval('seq_categorias', (SELECT COALESCE(MAX(SUBSTRING(id FROM 4)::int),0)+1 FROM categorias), false);
SELECT setval('seq_avisos', (SELECT COALESCE(MAX(SUBSTRING(id FROM 3)::int),0)+1 FROM avisos_ubicacion), false);
SELECT setval('seq_usuarios', (SELECT COALESCE(MAX(SUBSTRING(id FROM 2)::int),0)+1 FROM usuarios), false);
SELECT setval('seq_admins', (SELECT COALESCE(MAX(SUBSTRING(id FROM 2)::int),0)+1 FROM administradores), false);
SELECT setval('seq_publicaciones', (SELECT COALESCE(MAX(SUBSTRING(id FROM 4)::int),0)+1 FROM publicaciones), false);
SELECT setval('seq_trueques', (SELECT COALESCE(MAX(SUBSTRING(id FROM 3)::int),0)+1 FROM trueques), false);
SELECT setval('seq_notificaciones', (SELECT COALESCE(MAX(SUBSTRING(id FROM 4)::int),0)+1 FROM notificaciones), false);
SELECT setval('seq_documentos', (SELECT COALESCE(MAX(SUBSTRING(id FROM 4)::int),0)+1 FROM documentos), false);
SELECT setval('seq_reportes', (SELECT COALESCE(MAX(SUBSTRING(id FROM 4)::int),0)+1 FROM reportes), false);
SELECT setval('seq_eliminadas', (SELECT COALESCE(MAX(SUBSTRING(id FROM 3)::int),0)+1 FROM publicaciones_eliminadas), false);
SELECT setval('seq_historial', (SELECT COALESCE(MAX(SUBSTRING(id FROM 3)::int),0)+1 FROM historial_acciones), false);
SELECT setval('seq_alertas', (SELECT COALESCE(MAX(SUBSTRING(id FROM 3)::int),0)+1 FROM alertas), false);
