-- XchanGo - Base de datos (PostgreSQL)
-- Plataforma de trueques de Casanare
-- Ejecutar:  psql -U postgres -d xchango -f 01_esquema.sql
-- Notas rapidas:
-- Los id son texto con prefijo (u1, pub1, tr1...) porque el cliente
--    Angular ya los usa asi. Se generan solos con una secuencia.
-- Los contadores (publicaciones, intercambios, reportes, calificacion)
--    NO se guardan: se calculan en las vistas del final.
-- Los usuarios no tienen contrasena (entran con correo + PIN).
--    Solo los administradores tienen password_hash.

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

-- catalogos (el cliente los puede leer directo, sin pasar por el MID)
CREATE TABLE municipios (
    id      SERIAL PRIMARY KEY,
    nombre  VARCHAR(60) NOT NULL UNIQUE
);

CREATE SEQUENCE seq_categorias;
CREATE TABLE categorias (
    id      TEXT PRIMARY KEY DEFAULT 'cat' || nextval('seq_categorias'),
    nombre  VARCHAR(60) NOT NULL UNIQUE,
    icono   VARCHAR(40) NOT NULL DEFAULT 'category'
);

-- Aviso que se muestra segun el municipio. municipio NULL = aviso por defecto
CREATE SEQUENCE seq_avisos;
CREATE TABLE avisos_ubicacion (
    id            TEXT PRIMARY KEY DEFAULT 'av' || nextval('seq_avisos'),
    municipio_id  INT UNIQUE REFERENCES municipios(id) ON DELETE CASCADE,
    titulo        VARCHAR(100) NOT NULL,
    mensaje       VARCHAR(255) NOT NULL,
    icono         VARCHAR(40)  NOT NULL DEFAULT 'location_on'
);

-- usuarios y administradores
CREATE SEQUENCE seq_usuarios;
CREATE TABLE usuarios (
    id              TEXT PRIMARY KEY DEFAULT 'u' || nextval('seq_usuarios'),
    nombre          VARCHAR(100) NOT NULL,
    apellido        VARCHAR(100) NOT NULL DEFAULT '',
    fecha_nacimiento DATE,
    email           VARCHAR(120) NOT NULL,
    telefono        VARCHAR(15),
    municipio_id    INT REFERENCES municipios(id),
    direccion       VARCHAR(150) NOT NULL DEFAULT '',
    barrio          VARCHAR(80) NOT NULL DEFAULT '',
    avatar          TEXT,
    descripcion     TEXT NOT NULL DEFAULT '',
    estado          VARCHAR(12) NOT NULL DEFAULT 'activo'
                    CHECK (estado IN ('activo','advertido','suspendido')),
    verificacion    VARCHAR(15) NOT NULL DEFAULT 'no_verificado'
                    CHECK (verificacion IN ('no_verificado','verificado')),
    fecha_registro  DATE NOT NULL DEFAULT CURRENT_DATE,
    eliminado       BOOLEAN NOT NULL DEFAULT FALSE   -- "Eliminar cuenta" (borrado logico)
);

-- el correo se puede volver a usar si la cuenta anterior fue eliminada
CREATE UNIQUE INDEX ux_usuarios_email ON usuarios (LOWER(email)) WHERE eliminado = FALSE;

CREATE SEQUENCE seq_admins;
CREATE TABLE administradores (
    id             TEXT PRIMARY KEY DEFAULT 'a' || nextval('seq_admins'),
    nombre         VARCHAR(100) NOT NULL,
    email          VARCHAR(120) NOT NULL UNIQUE,
    password_hash  VARCHAR(100) NOT NULL,
    rol            VARCHAR(12) NOT NULL DEFAULT 'moderador'
                   CHECK (rol IN ('admin','moderador')),
    estado         VARCHAR(10) NOT NULL DEFAULT 'activo'
                   CHECK (estado IN ('activo','inactivo')),
    avatar         TEXT,
    ultimo_acceso  TIMESTAMP
);

-- publicaciones
CREATE SEQUENCE seq_publicaciones;
CREATE TABLE publicaciones (
    id                  TEXT PRIMARY KEY DEFAULT 'pub' || nextval('seq_publicaciones'),
    usuario_id          TEXT NOT NULL REFERENCES usuarios(id),
    categoria_id        TEXT NOT NULL REFERENCES categorias(id),
    tipo                VARCHAR(12) NOT NULL
                        CHECK (tipo IN ('bien_fisico','servicio','bien_digital')),
    titulo              VARCHAR(120) NOT NULL,
    descripcion         TEXT NOT NULL,
    ofreces             VARCHAR(200) NOT NULL,
    buscas              VARCHAR(200) NOT NULL,
    municipio_id        INT REFERENCES municipios(id),
    barrio              VARCHAR(80),
    cantidad_disponible VARCHAR(40),
    disponibilidad      VARCHAR(120),
    estado              VARCHAR(10) NOT NULL DEFAULT 'activa'
                        CHECK (estado IN ('activa','pausada','finalizada','eliminada')),
    vistas              INT NOT NULL DEFAULT 0 CHECK (vistas >= 0),
    fecha_creacion      DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_modificacion  DATE NOT NULL DEFAULT CURRENT_DATE,

    -- Reglas segun el tipo:
    --  bien_fisico : municipio, barrio, cantidad y disponibilidad
    --  servicio    : municipio, cantidad y disponibilidad (sin barrio)
    --  bien_digital: sin ubicacion ni cantidad
    CONSTRAINT ck_pub_tipo CHECK (
        (tipo = 'bien_fisico' AND municipio_id IS NOT NULL AND barrio IS NOT NULL
             AND cantidad_disponible IS NOT NULL AND disponibilidad IS NOT NULL)
     OR (tipo = 'servicio' AND municipio_id IS NOT NULL AND barrio IS NULL
             AND cantidad_disponible IS NOT NULL AND disponibilidad IS NOT NULL)
     OR (tipo = 'bien_digital' AND municipio_id IS NULL AND barrio IS NULL
             AND cantidad_disponible IS NULL AND disponibilidad IS NULL)
    )
);

CREATE TABLE publicacion_imagenes (
    id              SERIAL PRIMARY KEY,
    publicacion_id  TEXT NOT NULL REFERENCES publicaciones(id) ON DELETE CASCADE,
    url             TEXT NOT NULL,
    orden           INT NOT NULL DEFAULT 1
);

-- Favoritos: un usuario no puede marcar dos veces la misma publicacion
CREATE SEQUENCE seq_favoritos;
CREATE TABLE favoritos (
    id              TEXT PRIMARY KEY DEFAULT 'fav' || nextval('seq_favoritos'),
    usuario_id      TEXT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    publicacion_id  TEXT NOT NULL REFERENCES publicaciones(id) ON DELETE CASCADE,
    fecha           TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (usuario_id, publicacion_id)
);

-- trueques
CREATE SEQUENCE seq_trueques;
CREATE TABLE trueques (
    id                       TEXT PRIMARY KEY DEFAULT 'tr' || nextval('seq_trueques'),
    publicacion_id           TEXT NOT NULL REFERENCES publicaciones(id),
    solicitante_id           TEXT NOT NULL REFERENCES usuarios(id),
    propietario_id           TEXT NOT NULL REFERENCES usuarios(id),
    ofrece                   VARCHAR(200) NOT NULL,
    busca                    VARCHAR(200) NOT NULL,
    estado                   VARCHAR(12) NOT NULL DEFAULT 'pendiente'
                             CHECK (estado IN ('pendiente','aceptado','rechazado','completado','cancelado')),
    fecha_solicitud          DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_cierre             DATE,
    confirmado_solicitante   BOOLEAN NOT NULL DEFAULT FALSE,
    confirmado_propietario   BOOLEAN NOT NULL DEFAULT FALSE,
    calificacion_solicitante SMALLINT CHECK (calificacion_solicitante BETWEEN 1 AND 5),
    calificacion_propietario SMALLINT CHECK (calificacion_propietario BETWEEN 1 AND 5),

    CONSTRAINT ck_no_autotrueque CHECK (solicitante_id <> propietario_id),
    -- solo se califica un trueque completado
    CONSTRAINT ck_calificar_completado CHECK (
        estado = 'completado'
        OR (calificacion_solicitante IS NULL AND calificacion_propietario IS NULL))
);

-- Un usuario no puede tener dos solicitudes abiertas sobre la misma publicacion
CREATE UNIQUE INDEX ux_trueque_abierto
    ON trueques (solicitante_id, publicacion_id)
    WHERE estado IN ('pendiente','aceptado');

-- notificaciones
CREATE SEQUENCE seq_notificaciones;
CREATE TABLE notificaciones (
    id             TEXT PRIMARY KEY DEFAULT 'not' || nextval('seq_notificaciones'),
    usuario_id     TEXT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    tipo           VARCHAR(12) NOT NULL CHECK (tipo IN ('solicitud','aceptada','rechazada','documento')),
    referencia_id  TEXT REFERENCES trueques(id) ON DELETE CASCADE,
    titulo         VARCHAR(100) NOT NULL,
    mensaje        VARCHAR(255) NOT NULL,
    leida          BOOLEAN NOT NULL DEFAULT FALSE,
    fecha          TIMESTAMP NOT NULL DEFAULT NOW()
);

-- documentos de verificacion
CREATE SEQUENCE seq_documentos;
CREATE TABLE documentos (
    id              TEXT PRIMARY KEY DEFAULT 'doc' || nextval('seq_documentos'),
    usuario_id      TEXT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    tipo_documento  VARCHAR(50) NOT NULL,
    numero          VARCHAR(30) NOT NULL,
    archivo         TEXT NOT NULL,
    archivo_reverso TEXT NOT NULL DEFAULT '',
    fecha_subida    DATE NOT NULL DEFAULT CURRENT_DATE,
    estado          VARCHAR(10) NOT NULL DEFAULT 'pendiente'
                    CHECK (estado IN ('pendiente','aprobado','rechazado')),
    observacion     VARCHAR(255) NOT NULL DEFAULT '',
    revisado_por    TEXT REFERENCES administradores(id) ON DELETE SET NULL
);

-- moderacion (reportes, eliminadas, historial, alertas)
CREATE SEQUENCE seq_reportes;
CREATE TABLE reportes (
    id              TEXT PRIMARY KEY DEFAULT 'rep' || nextval('seq_reportes'),
    publicacion_id  TEXT NOT NULL REFERENCES publicaciones(id),
    reportante_id   TEXT NOT NULL REFERENCES usuarios(id),
    motivo          VARCHAR(120) NOT NULL,
    fecha           DATE NOT NULL DEFAULT CURRENT_DATE,
    estado          VARCHAR(10) NOT NULL DEFAULT 'pendiente'
                    CHECK (estado IN ('pendiente','aprobada','eliminada')),
    gravedad        VARCHAR(6) NOT NULL DEFAULT 'media'
                    CHECK (gravedad IN ('baja','media','alta')),
    -- un usuario no reporta dos veces lo mismo
    UNIQUE (publicacion_id, reportante_id)
);

CREATE SEQUENCE seq_eliminadas;
CREATE TABLE publicaciones_eliminadas (
    id              TEXT PRIMARY KEY DEFAULT 'el' || nextval('seq_eliminadas'),
    publicacion_id  TEXT NOT NULL REFERENCES publicaciones(id),
    usuario_id      TEXT NOT NULL REFERENCES usuarios(id),   -- dueno de la publicacion
    admin_id        TEXT REFERENCES administradores(id) ON DELETE SET NULL,
    motivo          VARCHAR(255) NOT NULL,
    fecha           DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE SEQUENCE seq_historial;
CREATE TABLE historial_acciones (
    id           TEXT PRIMARY KEY DEFAULT 'ac' || nextval('seq_historial'),
    usuario_id   TEXT NOT NULL REFERENCES usuarios(id),
    admin_id     TEXT REFERENCES administradores(id) ON DELETE SET NULL,
    accion       VARCHAR(40) NOT NULL,
    descripcion  VARCHAR(255) NOT NULL,
    fecha        TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE SEQUENCE seq_alertas;
CREATE TABLE alertas (
    id         TEXT PRIMARY KEY DEFAULT 'al' || nextval('seq_alertas'),
    tipo       VARCHAR(12) NOT NULL CHECK (tipo IN ('sospechosa','moderacion','sistema','usuario')),
    titulo     VARCHAR(120) NOT NULL,
    mensaje    VARCHAR(255) NOT NULL,
    fecha      TIMESTAMP NOT NULL DEFAULT NOW(),
    leida      BOOLEAN NOT NULL DEFAULT FALSE,
    prioridad  VARCHAR(6) NOT NULL DEFAULT 'media' CHECK (prioridad IN ('baja','media','alta'))
);

-- indices (para las consultas mas usadas)
CREATE INDEX ix_pub_usuario    ON publicaciones (usuario_id);
CREATE INDEX ix_pub_categoria  ON publicaciones (categoria_id);
CREATE INDEX ix_pub_estado     ON publicaciones (estado);
CREATE INDEX ix_pub_municipio  ON publicaciones (municipio_id);
CREATE INDEX ix_img_pub        ON publicacion_imagenes (publicacion_id);
CREATE INDEX ix_tr_solic       ON trueques (solicitante_id);
CREATE INDEX ix_tr_prop        ON trueques (propietario_id);
CREATE INDEX ix_tr_pub         ON trueques (publicacion_id);
CREATE INDEX ix_not_usuario    ON notificaciones (usuario_id, leida);
CREATE INDEX ix_rep_estado     ON reportes (estado);
CREATE INDEX ix_doc_usuario    ON documentos (usuario_id);
CREATE INDEX ix_hist_usuario   ON historial_acciones (usuario_id);

-- vistas (reemplazan los contadores que antes venian guardados)

-- Calificaciones recibidas por cada usuario (como solicitante o propietario)
CREATE VIEW v_calificaciones AS
    SELECT solicitante_id AS usuario_id, calificacion_propietario AS puntos
      FROM trueques WHERE calificacion_propietario IS NOT NULL
    UNION ALL
    SELECT propietario_id, calificacion_solicitante
      FROM trueques WHERE calificacion_solicitante IS NOT NULL;
-- OJO: cada parte califica a la otra, por eso se cruzan los campos arriba:
-- la calificacion_propietario la pone el propietario y la RECIBE el solicitante.

-- Datos del usuario con sus contadores (lo mismo que tenia el JSON)
CREATE VIEW v_usuarios AS
SELECT u.id, u.nombre, u.apellido, u.fecha_nacimiento, u.email, u.telefono,
       m.nombre AS ubicacion, u.direccion, u.barrio,
       u.avatar, u.descripcion, u.estado, u.verificacion, u.fecha_registro,
       (SELECT COUNT(*) FROM publicaciones p
         WHERE p.usuario_id = u.id AND p.estado <> 'eliminada')          AS publicaciones,
       (SELECT COUNT(*) FROM trueques t
         WHERE t.estado = 'completado'
           AND u.id IN (t.solicitante_id, t.propietario_id))             AS intercambios,
       (SELECT COUNT(*) FROM reportes r
          JOIN publicaciones p ON p.id = r.publicacion_id
         WHERE p.usuario_id = u.id)                                      AS reportes,
       COALESCE((SELECT ROUND(AVG(c.puntos), 1) FROM v_calificaciones c
                  WHERE c.usuario_id = u.id), 0)                         AS calificacion,
       (SELECT COUNT(*) FROM v_calificaciones c WHERE c.usuario_id = u.id) AS total_calificaciones
  FROM usuarios u
  LEFT JOIN municipios m ON m.id = u.municipio_id
 WHERE u.eliminado = FALSE;

-- Nivel de actividad (igual que el MID): 8 o mas alto, 3 o mas medio, el resto bajo (publicaciones + intercambios)
CREATE VIEW v_nivel_actividad AS
SELECT id,
       CASE WHEN publicaciones + intercambios >= 8 THEN 'alto'
            WHEN publicaciones + intercambios >= 3 THEN 'medio'
            ELSE 'bajo' END AS nivel_actividad
  FROM v_usuarios;

-- Publicaciones listas para mostrar (con nombre de municipio, categoria, dueno)
CREATE VIEW v_publicaciones AS
SELECT p.id, p.usuario_id, p.categoria_id, c.nombre AS categoria,
       p.tipo, p.titulo, p.descripcion, p.ofreces, p.buscas,
       m.nombre AS municipio, p.barrio, p.cantidad_disponible, p.disponibilidad,
       p.estado, p.vistas, p.fecha_creacion, p.fecha_modificacion,
       COALESCE((SELECT ARRAY_AGG(i.url ORDER BY i.orden)
                   FROM publicacion_imagenes i WHERE i.publicacion_id = p.id), '{}') AS imagenes
  FROM publicaciones p
  JOIN categorias c ON c.id = p.categoria_id
  LEFT JOIN municipios m ON m.id = p.municipio_id;

-- Ranking de usuarios (panel de administracion)
CREATE VIEW v_ranking_usuarios AS
SELECT RANK() OVER (ORDER BY intercambios DESC, calificacion DESC) AS puesto,
       id, nombre, intercambios, calificacion, total_calificaciones
  FROM v_usuarios
 WHERE estado <> 'suspendido';

-- Publicaciones por categoria (grafica del panel)
CREATE VIEW v_publicaciones_por_categoria AS
SELECT c.nombre AS categoria, COUNT(p.id) AS total
  FROM categorias c
  LEFT JOIN publicaciones p ON p.categoria_id = c.id AND p.estado <> 'eliminada'
 GROUP BY c.nombre;

-- Actividad por municipio (grafica del panel)
CREATE VIEW v_actividad_por_municipio AS
SELECT m.nombre AS municipio, COUNT(p.id) AS publicaciones
  FROM municipios m
  LEFT JOIN publicaciones p ON p.municipio_id = m.id AND p.estado <> 'eliminada'
 GROUP BY m.nombre;

-- Intercambios completados por mes (grafica del panel)
CREATE VIEW v_intercambios_por_mes AS
SELECT TO_CHAR(fecha_cierre, 'YYYY-MM') AS mes, COUNT(*) AS total
  FROM trueques WHERE estado = 'completado'
 GROUP BY 1 ORDER BY 1;

-- Resumen de tarjetas del panel
CREATE VIEW v_resumen_panel AS
SELECT (SELECT COUNT(*) FROM usuarios WHERE eliminado = FALSE)                AS usuarios,
       (SELECT COUNT(*) FROM publicaciones WHERE estado = 'activa')           AS publicaciones_activas,
       (SELECT COUNT(*) FROM trueques WHERE estado = 'completado')            AS intercambios_completados,
       (SELECT COUNT(*) FROM reportes WHERE estado = 'pendiente')             AS reportes_pendientes,
       (SELECT COUNT(*) FROM documentos WHERE estado = 'pendiente')           AS documentos_pendientes,
       (SELECT COUNT(*) FROM alertas WHERE leida = FALSE)                     AS alertas_sin_leer;
