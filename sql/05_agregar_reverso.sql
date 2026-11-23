-- solo para bases que ya estaban creadas antes de agregar la foto de atras
-- del documento (si la base es nueva, 01_esquema.sql ya trae la columna)
ALTER TABLE documentos ADD COLUMN IF NOT EXISTS archivo_reverso TEXT NOT NULL DEFAULT '';

-- la vista se vuelve a crear para que tome la columna nueva
CREATE OR REPLACE VIEW crud_documentos AS SELECT * FROM documentos;
