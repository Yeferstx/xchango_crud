-- XchanGo - Pruebas del CRUD (ejecutar despues de 01, 02 y 03)
-- Llama a la funcion crud() igual que lo hace la API en Go y compara el
-- codigo que responde con el que debe responder.
-- Todo lo que crea se deshace al final: no deja datos de prueba.
-- Al terminar muestra la tabla de resultados (columna "resultado": OK o FALLA).

-- anota una prueba: nombre, lo esperado y lo obtenido
CREATE OR REPLACE FUNCTION pg_temp.anotar(lista JSONB, nombre TEXT, esperado TEXT, obtenido TEXT)
RETURNS JSONB AS $$
    SELECT lista || jsonb_build_object('prueba', nombre, 'esperado', esperado, 'obtenido', obtenido);
$$ LANGUAGE sql;

DO $$
DECLARE
    lista    JSONB := '[]'::jsonb;
    r        JSONB;
    id_user  TEXT;
    id_pub   TEXT;
    id_trueq TEXT;
    id_notif TEXT;
    id_fav   TEXT;
BEGIN
    -- todo va dentro de un bloque que al final se deshace
    BEGIN

        -- ---------- 1. LEER ----------
        lista := pg_temp.anotar(lista, 'listar usuarios (minimo 15)', 'true', (jsonb_array_length(crud('GET','usuarios')->'datos') >= 15)::text);
        lista := pg_temp.anotar(lista, 'listar categorias (minimo 8)', 'true', (jsonb_array_length(crud('GET','categorias')->'datos') >= 8)::text);
        lista := pg_temp.anotar(lista, 'listar municipios (19)', 'true', (jsonb_array_length(crud('GET','municipios')->'datos') = 19)::text);
        lista := pg_temp.anotar(lista, 'listar publicaciones (minimo 14)', 'true', (jsonb_array_length(crud('GET','publicaciones')->'datos') >= 14)::text);
        lista := pg_temp.anotar(lista, 'listar trueques (minimo 12)', 'true', (jsonb_array_length(crud('GET','trueques')->'datos') >= 12)::text);
        lista := pg_temp.anotar(lista, 'listar notificaciones (minimo 5)', 'true', (jsonb_array_length(crud('GET','notificaciones')->'datos') >= 5)::text);
        lista := pg_temp.anotar(lista, 'listar reportes (minimo 10)', 'true', (jsonb_array_length(crud('GET','reportes')->'datos') >= 10)::text);
        lista := pg_temp.anotar(lista, 'listar publicaciones-eliminadas (minimo 3)', 'true', (jsonb_array_length(crud('GET','publicaciones-eliminadas')->'datos') >= 3)::text);
        lista := pg_temp.anotar(lista, 'listar historial-acciones (minimo 8)', 'true', (jsonb_array_length(crud('GET','historial-acciones')->'datos') >= 8)::text);
        lista := pg_temp.anotar(lista, 'listar alertas (minimo 6)', 'true', (jsonb_array_length(crud('GET','alertas')->'datos') >= 6)::text);
        lista := pg_temp.anotar(lista, 'listar documentos (minimo 6)', 'true', (jsonb_array_length(crud('GET','documentos')->'datos') >= 6)::text);
        lista := pg_temp.anotar(lista, 'listar avisos-ubicacion (minimo 5)', 'true', (jsonb_array_length(crud('GET','avisos-ubicacion')->'datos') >= 5)::text);
        lista := pg_temp.anotar(lista, 'listar admins (minimo 2)', 'true', (jsonb_array_length(crud('GET','admins')->'datos') >= 2)::text);

        r := crud('GET','usuarios','u1');
        lista := pg_temp.anotar(lista, 'leer usuario u1', '200', r->>'codigo');
        lista := pg_temp.anotar(lista, 'u1 viene con nombre y municipio', 'Carlos Ospina Yopal', (r->'datos'->>'nombre') || ' ' || (r->'datos'->>'apellido') || ' ' || (r->'datos'->>'ubicacion'));
        lista := pg_temp.anotar(lista, 'leer un id que no existe', '404', crud('GET','usuarios','zzz')->>'codigo');
        lista := pg_temp.anotar(lista, 'coleccion que no existe', '404', crud('GET','cosas')->>'codigo');
        lista := pg_temp.anotar(lista, 'la contrasena del admin esta cifrada', 'true', (crud('GET','admins','a1')->'datos'->>'password' LIKE '$2%')::text);

        -- ---------- 2. USUARIOS ----------
        r := crud('POST','usuarios',NULL,'{"nombre":"Prueba","apellido":"CRUD","fechaNacimiento":"2000-05-20","direccion":"Calle 1 # 2-3","barrio":"Centro","email":"prueba.crud@mail.com","telefono":"3001234567","ubicacion":"Yopal"}');
        lista := pg_temp.anotar(lista, 'crear usuario', '201', r->>'codigo');
        lista := pg_temp.anotar(lista, 'el apellido se guarda al crear', 'CRUD', r->'datos'->>'apellido');
        lista := pg_temp.anotar(lista, 'la fecha de nacimiento se guarda', '2000-05-20', r->'datos'->>'fechaNacimiento');
        lista := pg_temp.anotar(lista, 'la direccion y el barrio se guardan', 'Calle 1 # 2-3 Centro', (r->'datos'->>'direccion') || ' ' || (r->'datos'->>'barrio'));
        id_user := r->'datos'->>'id';
        lista := pg_temp.anotar(lista, 'el usuario nuevo recibe un id', 'true', (id_user IS NOT NULL)::text);
        lista := pg_temp.anotar(lista, 'crear usuario con correo repetido', '409', crud('POST','usuarios',NULL,'{"nombre":"Otro","email":"PRUEBA.CRUD@mail.com"}')->>'codigo');
        lista := pg_temp.anotar(lista, 'crear usuario con municipio que no existe', '400', crud('POST','usuarios',NULL,'{"nombre":"Otro","email":"otro@mail.com","ubicacion":"Marte"}')->>'codigo');
        lista := pg_temp.anotar(lista, 'crear usuario con estado invalido', '400', crud('POST','usuarios',NULL,'{"nombre":"Otro","email":"otro2@mail.com","estado":"inventado"}')->>'codigo');
        r := crud('PUT','usuarios',id_user,'{"nombre":"Prueba editada","apellido":"Apellido editado","ubicacion":"Aguazul"}');
        lista := pg_temp.anotar(lista, 'editar usuario', '200', r->>'codigo');
        lista := pg_temp.anotar(lista, 'el apellido se puede editar', 'Apellido editado', r->'datos'->>'apellido');
        lista := pg_temp.anotar(lista, 'el cambio de municipio se guarda', 'Aguazul', r->'datos'->>'ubicacion');
        lista := pg_temp.anotar(lista, 'editar usuario que no existe', '404', crud('PUT','usuarios','zzz','{"nombre":"x"}')->>'codigo');

        -- ---------- 3. PUBLICACIONES ----------
        r := crud('POST','publicaciones',NULL, format('{"usuarioId":"%s","categoriaId":"cat1","tipo":"servicio","titulo":"Clases de prueba","descripcion":"d","ofreces":"o","buscas":"b","municipio":"Yopal","cantidadDisponible":"3 sesiones","disponibilidad":"tardes","imagenes":["a.jpg","b.jpg"]}', id_user)::jsonb);
        lista := pg_temp.anotar(lista, 'crear publicacion (servicio)', '201', r->>'codigo');
        id_pub := r->'datos'->>'id';
        lista := pg_temp.anotar(lista, 'se guardan las 2 imagenes', '2', jsonb_array_length(r->'datos'->'imagenes')::text);
        lista := pg_temp.anotar(lista, 'bien fisico sin barrio', '400', crud('POST','publicaciones',NULL, format('{"usuarioId":"%s","categoriaId":"cat1","tipo":"bien_fisico","titulo":"x","descripcion":"d","ofreces":"o","buscas":"b","municipio":"Yopal"}', id_user)::jsonb)->>'codigo');
        lista := pg_temp.anotar(lista, 'bien digital con municipio', '400', crud('POST','publicaciones',NULL, format('{"usuarioId":"%s","categoriaId":"cat1","tipo":"bien_digital","titulo":"x","descripcion":"d","ofreces":"o","buscas":"b","municipio":"Yopal"}', id_user)::jsonb)->>'codigo');
        lista := pg_temp.anotar(lista, 'publicacion con categoria que no existe', '400', crud('POST','publicaciones',NULL, format('{"usuarioId":"%s","categoriaId":"cat99","tipo":"bien_digital","titulo":"x","descripcion":"d","ofreces":"o","buscas":"b"}', id_user)::jsonb)->>'codigo');
        r := crud('PUT','publicaciones',id_pub,'{"tipo":"bien_digital","titulo":"Clases online","imagenes":["c.jpg"]}');
        lista := pg_temp.anotar(lista, 'cambiar la publicacion a bien digital', '200', r->>'codigo');
        lista := pg_temp.anotar(lista, 'al ser digital pierde el municipio', 'true', (r->'datos'->'municipio' = 'null'::jsonb)::text);

        -- ---------- 4. TRUEQUES ----------
        r := crud('POST','trueques',NULL, format('{"publicacionId":"%s","solicitanteId":"u2","propietarioId":"%s","ofrece":"Bicicleta","busca":"Clases"}', id_pub, id_user)::jsonb);
        lista := pg_temp.anotar(lista, 'crear trueque', '201', r->>'codigo');
        id_trueq := r->'datos'->>'id';
        lista := pg_temp.anotar(lista, 'el trueque nace pendiente', 'pendiente', r->'datos'->>'estado');
        lista := pg_temp.anotar(lista, 'trueque con uno mismo', '400', crud('POST','trueques',NULL, format('{"publicacionId":"%s","solicitanteId":"u2","propietarioId":"u2","ofrece":"a","busca":"b"}', id_pub)::jsonb)->>'codigo');
        lista := pg_temp.anotar(lista, 'segunda solicitud abierta a la misma publicacion', '409', crud('POST','trueques',NULL, format('{"publicacionId":"%s","solicitanteId":"u2","propietarioId":"%s","ofrece":"a","busca":"b"}', id_pub, id_user)::jsonb)->>'codigo');
        lista := pg_temp.anotar(lista, 'calificar un trueque que no esta completado', '400', crud('PUT','trueques',id_trueq,'{"calificacionSolicitante":5}')->>'codigo');
        lista := pg_temp.anotar(lista, 'nota fuera de 1 a 5', '400', crud('PUT','trueques',id_trueq,'{"estado":"completado","calificacionSolicitante":7}')->>'codigo');
        r := crud('PUT','trueques',id_trueq,'{"estado":"completado","fechaCierre":"2026-10-08","confirmadoSolicitante":true,"confirmadoPropietario":true,"calificacionSolicitante":5}');
        lista := pg_temp.anotar(lista, 'completar y calificar el trueque', '200', r->>'codigo');
        lista := pg_temp.anotar(lista, 'queda completado', 'completado', r->'datos'->>'estado');

        -- ---------- 5. NOTIFICACIONES ----------
        r := crud('POST','notificaciones',NULL, format('{"usuarioId":"%s","tipo":"solicitud","titulo":"Nueva solicitud","mensaje":"Prueba","referenciaId":"%s","leida":false}', id_user, id_trueq)::jsonb);
        lista := pg_temp.anotar(lista, 'crear notificacion', '201', r->>'codigo');
        id_notif := r->'datos'->>'id';
        lista := pg_temp.anotar(lista, 'notificacion de documento (sin trueque)', '201', crud('POST','notificaciones',NULL, format('{"usuarioId":"%s","tipo":"documento","titulo":"Tu documento fue aprobado","mensaje":"Tu cuenta ya esta verificada.","referenciaId":null,"leida":false}', id_user)::jsonb)->>'codigo');
        lista := pg_temp.anotar(lista, 'notificacion con tipo invalido', '400', crud('POST','notificaciones',NULL, format('{"usuarioId":"%s","tipo":"otra","titulo":"t","mensaje":"m"}', id_user)::jsonb)->>'codigo');
        lista := pg_temp.anotar(lista, 'marcar notificacion como leida', 'true', (crud('PUT','notificaciones',id_notif,'{"leida":true}')->'datos'->>'leida')::text);
        lista := pg_temp.anotar(lista, 'borrar notificacion', '204', crud('DELETE','notificaciones',id_notif)->>'codigo');
        lista := pg_temp.anotar(lista, 'borrarla otra vez', '404', crud('DELETE','notificaciones',id_notif)->>'codigo');

        -- ---------- 6. FAVORITOS ----------
        r := crud('POST','favoritos',NULL,'{"usuarioId":"u2","publicacionId":"pub3"}');
        lista := pg_temp.anotar(lista, 'crear favorito', '201', r->>'codigo');
        id_fav := r->'datos'->>'id';
        lista := pg_temp.anotar(lista, 'favorito repetido', '409', crud('POST','favoritos',NULL,'{"usuarioId":"u2","publicacionId":"pub3"}')->>'codigo');
        lista := pg_temp.anotar(lista, 'borrar favorito', '204', crud('DELETE','favoritos',id_fav)->>'codigo');

        -- ---------- 7. MODERACION Y PANEL ----------
        lista := pg_temp.anotar(lista, 'reporte repetido del mismo usuario', '409', crud('POST','reportes',NULL,'{"publicacionId":"pub11","reportanteId":"u7","motivo":"otra vez"}')->>'codigo');
        lista := pg_temp.anotar(lista, 'reporte con gravedad invalida', '400', crud('POST','reportes',NULL,'{"publicacionId":"pub1","reportanteId":"u5","motivo":"x","gravedad":"enorme"}')->>'codigo');
        lista := pg_temp.anotar(lista, 'aprobar un documento', 'aprobado', crud('PUT','documentos','doc1','{"estado":"aprobado","observacion":"","revisadoPor":"a1"}')->'datos'->>'estado');
        lista := pg_temp.anotar(lista, 'documento con estado invalido', '400', crud('PUT','documentos','doc1','{"estado":"quizas"}')->>'codigo');
        lista := pg_temp.anotar(lista, 'marcar alerta como leida', 'true', (crud('PUT','alertas','al1','{"leida":true}')->'datos'->>'leida')::text);
        lista := pg_temp.anotar(lista, 'registrar accion en el historial', '201', crud('POST','historial-acciones',NULL,'{"usuarioId":"u3","adminId":"a1","accion":"Advertencia","descripcion":"Prueba"}')->>'codigo');
        lista := pg_temp.anotar(lista, 'crear administrador', '201', crud('POST','admins',NULL,'{"nombre":"Mod Prueba","email":"modprueba@xchango.com","password":"hash","rol":"moderador","estado":"activo"}')->>'codigo');
        lista := pg_temp.anotar(lista, 'administrador con rol invalido', '400', crud('POST','admins',NULL,'{"nombre":"X","email":"x@xchango.com","password":"hash","rol":"jefe"}')->>'codigo');
        lista := pg_temp.anotar(lista, 'borrar un administrador', '204', crud('DELETE','admins','a2')->>'codigo');
        lista := pg_temp.anotar(lista, 'el historial se conserva al borrar un admin', 'true', (jsonb_array_length(crud('GET','historial-acciones')->'datos') >= 9)::text);

        -- ---------- 8. BORRAR ----------
        lista := pg_temp.anotar(lista, 'eliminar usuario (queda marcado)', '204', crud('DELETE','usuarios',id_user)->>'codigo');
        lista := pg_temp.anotar(lista, 'el usuario eliminado ya no se lee', '404', crud('GET','usuarios',id_user)->>'codigo');
        lista := pg_temp.anotar(lista, 'el correo se puede volver a registrar', '201', crud('POST','usuarios',NULL,'{"nombre":"Prueba CRUD 2","email":"prueba.crud@mail.com"}')->>'codigo');
        lista := pg_temp.anotar(lista, 'municipios es solo lectura', '405', crud('POST','municipios',NULL,'{"nombre":"Nuevo"}')->>'codigo');

        -- deshace todo lo que se creo arriba
        RAISE EXCEPTION 'deshacer_pruebas';
    EXCEPTION
        WHEN raise_exception THEN
            NULL;
    END;

    DROP TABLE IF EXISTS pg_temp.resultados_crud;
    CREATE TEMP TABLE resultados_crud AS
        SELECT n AS numero,
               e->>'prueba'   AS prueba,
               e->>'esperado' AS esperado,
               e->>'obtenido' AS obtenido,
               CASE WHEN e->>'esperado' = e->>'obtenido' THEN 'OK' ELSE 'FALLA' END AS resultado
          FROM jsonb_array_elements(lista) WITH ORDINALITY AS t(e, n);
END $$;

-- resultado: una fila por prueba
SELECT * FROM pg_temp.resultados_crud ORDER BY numero;
