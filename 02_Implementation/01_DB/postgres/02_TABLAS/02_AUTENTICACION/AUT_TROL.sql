-- Table: ow_base_us.aut_trol

CREATE TABLE ow_base_us.aut_trol
(
    rol_rol character varying(20) COLLATE pg_catalog."default" NOT NULL,
    rol_descri character varying(100) COLLATE pg_catalog."default" NOT NULL,
    rol_is_sistema character varying(1) COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE ow_base_us.aut_trol
    OWNER to ow_base_us;
COMMENT ON TABLE ow_base_us.aut_trol
    IS 'TABLA QUE ALMACENA LOS ROLES QUE PUEDEN DESEMPEĂ‘AR LOS USUARIOS DENTRO DEL SISTEMA DE GESTIĂ“N DE PROYECTOS DE GRADO DE LA UNIVERSIDAD DISTRITAL (CN_SGR)';

COMMENT ON COLUMN ow_base_us.aut_trol.rol_rol
    IS 'IDENTIFICADOR DEL ROL';

COMMENT ON COLUMN ow_base_us.aut_trol.rol_descri
    IS 'DESCRIPCION DEL ROL';

COMMENT ON COLUMN ow_base_us.aut_trol.rol_is_sistema
    IS 'ES ROL DE SISTEMA, NO SE PUEDE BORRAR';
    
    --
-- Name: aut_trol pk_aut_trol; Type: CONSTRAINT; Schema: ow_base_us; Owner: ow_base_us
--

ALTER TABLE ONLY ow_base_us.aut_trol
    ADD CONSTRAINT pk_aut_trol PRIMARY KEY (rol_rol);