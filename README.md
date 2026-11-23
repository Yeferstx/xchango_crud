# xchango_crud

API CRUD de XchanGo (Go + Beego). Es la que se conecta a PostgreSQL.
El MID le pide los datos por HTTP y no tiene base de datos propia.

Cliente (4200) -> MID (8080) -> CRUD (3000) -> PostgreSQL db_xchango (5432)

## 1. Base de datos
En pgAdmin, crear la base `db_xchango` y ejecutar en este orden (carpeta `sql/`):
1. `01_esquema.sql`
2. `02_datos_ejemplo.sql`
3. `03_crud.sql`
4. `04_pruebas.sql` (opcional: las pruebas del CRUD, ver abajo)

## 2. Configurar
Copiar `conf/app.conf.ejemplo` como `conf/app.conf` y poner la clave de PostgreSQL en `bd_clave`
(y `bd_puerto` si no es 5432).

## 3. Correr
```
go mod tidy
go run main.go
```
Debe salir "Conectado a PostgreSQL" y quedar escuchando en el puerto 3000.
Prueba rapida en el navegador: http://localhost:3000/categorias

## 4. Correr el MID
En el MID, `conf/app.conf` ya apunta a `url_crud=http://localhost:3000`.
Orden para arrancar: PostgreSQL, CRUD, MID, cliente.

## Como funciona
Hay un solo controlador (`controllers/crud.go`) para todas las colecciones.
Rutas: GET /coleccion, GET /coleccion/id, POST /coleccion, PUT /coleccion/id, DELETE /coleccion/id.
Colecciones: usuarios, publicaciones, trueques, notificaciones, favoritos, categorias,
avisos-ubicacion, admins, alertas, documentos, historial-acciones, reportes,
publicaciones-eliminadas y municipios (solo lectura).
El controlador llama a la funcion `crud()` de PostgreSQL (archivo `sql/03_crud.sql`),
que hace el SELECT/INSERT/UPDATE/DELETE y devuelve el JSON.

Codigos: 200/201 bien, 204 borrado, 400 dato invalido (regla de la base), 404 no existe,
409 ya existe (por ejemplo correo repetido).
Eliminar un usuario no borra la fila: la marca como eliminada.

## Pruebas
- `sql/04_pruebas.sql`: se ejecuta en pgAdmin (Query Tool de `db_xchango`) y prueba las 14 colecciones con 68 casos
  (crear, leer, editar, borrar y los errores 400, 404, 405 y 409). Muestra una tabla con
  la columna `resultado` en OK o FALLA. Lo que crea se deshace al final, no deja datos.
- Pruebas en Postman: importar `XchanGo-CRUD-pruebas.postman_collection.json`, con el CRUD corriendo. Clic derecho en la coleccion, Run collection, Run. Son 68 peticiones con 105 verificaciones, cada una se ve en verde (paso) o rojo (fallo).
