prompt
prompt PACKAGE: US_QUSER
prompt
CREATE OR REPLACE PACKAGE FS_AUWEB_US.US_QUSER IS
    --
    -- ===========================================================
    -- US_QUSER
    -- -----------------------------------------------------------
    -- Todas las funciones del usuario
    -- ===========================================================
    --
    -- #VERSION:0000001000
    --
    -- HISTORIAL DE CAMBIOS
    --
    -- Versi�n        GAP              Solicitud        Fecha         Realiz�          Descripci�n
    -- -----------    -------------    -------------    ----------    -------------    ------------------------------------------------------------------------------------------------------------------------------------------
    -- 
    -- -----------    -------------    -------------    ----------    -------------    ------------------------------------------------------------------------------------------------------------------------------------------

    -- ============================================================
    -- Constantes generales a nivel de PAQUETE
    -- ============================================================
  
    
    -- ============================================================
    -- Declaracion de PROCEDIMIENTOS y FUNCIONES
    -- ============================================================
    
  PROCEDURE loginUsuario
    (
        p_nombre_usuario               IN  US_TUSER.USER_ALAS%type,
        p_password_usuario             IN  US_TUSER.USER_PSWD%type,
        p_id_usuario                   OUT US_TUSER.USER_USER%type,
        p_cod_rta                      OUT NE_TCRTA.CRTA_CRTA%type
    );

  PROCEDURE crearUsuario
    (
        p_nombre_usuario               IN  US_TUSER.USER_ALAS%type,
        p_password_usuario             IN  US_TUSER.USER_PSWD%type,
        p_id_usuario                   OUT US_TUSER.USER_USER%type,
        p_cod_rta                      OUT NE_TCRTA.CRTA_CRTA%type
    );

  PROCEDURE buscarUsuarioPorNombre
    (
        p_nombre_usuario               IN  US_TUSER.USER_ALAS%type,
        p_id_usuario                   OUT US_TUSER.USER_USER%type,
        p_cod_rta                      OUT NE_TCRTA.CRTA_CRTA%type
    ); 

  PROCEDURE actualizarUsuario
    (
        p_nombre_usuario               IN  US_TUSER.USER_ALAS%type,
        p_nombre_usuario_act           IN  US_TUSER.USER_ALAS%type,
        p_password_usuario_act         IN  US_TUSER.USER_PSWD%type,
        p_cod_rta                      OUT NE_TCRTA.CRTA_CRTA%type
    ); 
    -- ------------------------------------------------------------
    
END US_QUSER;
/


prompt
prompt PACKAGE BODY:US_QUSER
prompt


CREATE OR REPLACE PACKAGE BODY FS_AUWEB_US.US_QUSER IS
    --
    -- #VERSION:0000001000
    --
    
    -- ===========================================================
    -- PROCEDURE loginUsuario
    -- -----------------------------------------------------------
    -- permite el logueo del usuario dado un nombre de usuario 
    -- y password
    -- ===========================================================
    PROCEDURE loginUsuario
    (
        p_nombre_usuario               IN  US_TUSER.USER_ALAS%type,
        p_password_usuario             IN  US_TUSER.USER_PSWD%type,
        p_id_usuario                   OUT US_TUSER.USER_USER%type,
        p_cod_rta                      OUT NE_TCRTA.CRTA_CRTA%type
    )IS

    CURSOR c_usuario
       (
            pc_password_md5          VARCHAR2
        ) IS
        SELECT 
            USER_USER
        FROM
            FS_AUWEB_US.US_TUSER
        WHERE
            USER_ALAS = p_nombre_usuario        AND
            USER_PSWD = pc_password_md5;

        r_usuario               c_usuario%rowtype;
        v_password_md5          VARCHAR2(30);

    BEGIN  

        v_password_md5 := DBMS_OBFUSCATION_TOOLKIT.MD5(INPUT_STRING => p_password_usuario); 

        OPEN  c_usuario(v_password_md5);
        FETCH c_usuario INTO r_usuario;
        CLOSE c_usuario;

        IF(r_usuario.USER_USER IS NOT NULL) THEN
          p_id_usuario := r_usuario.USER_USER;
          p_cod_rta     := 'OK';
        ELSE
          p_id_usuario := NULL;
          p_cod_rta     := 'ER_NULLL';
        END IF;
        EXCEPTION
            WHEN OTHERS THEN
                p_id_usuario := NULL;
                p_cod_rta  := 'ERROR_NC';

    END loginUsuario;

     --
    -- #VERSION:0000001000
    --

    -- ===========================================================
    -- PROCEDURE crearUsuario
    -- -----------------------------------------------------------
    -- creacion de usuaio dado atributos
    -- ===========================================================
    PROCEDURE crearUsuario
    (
        p_nombre_usuario               IN  US_TUSER.USER_ALAS%type,
        p_password_usuario             IN  US_TUSER.USER_PSWD%type,
        p_id_usuario                   OUT US_TUSER.USER_USER%type,
        p_cod_rta                      OUT NE_TCRTA.CRTA_CRTA%type
    )IS

        v_existencia_usuario    BOOLEAN;
        v_secuencia             NUMBER;
        v_cod_rta_tipo          NE_TCRTA.CRTA_CRTA%type;
        v_password_md5          VARCHAR2(30);

    BEGIN  
        v_secuencia := US_SETUSER.NextVal;
        v_password_md5 := DBMS_OBFUSCATION_TOOLKIT.MD5(INPUT_STRING => p_password_usuario);

        US_QVUSER.validarUsuarioPorNombre
        (
            p_nombre_usuario,
            v_existencia_usuario,
            v_cod_rta_tipo
        );

        IF(v_existencia_usuario) THEN
          INSERT INTO US_TUSER(
            USER_USER,
            USER_ALAS,
            USER_PSWD
          )
          VALUES(
            v_secuencia,
            p_nombre_usuario,
            v_password_md5
          );
           p_id_usuario  := v_secuencia;
           p_cod_rta     := 'OK';
        ELSE
           p_cod_rta     := 'ER_NULL';
        END IF;
        EXCEPTION
            WHEN OTHERS THEN
                p_cod_rta  := 'ERROR_NC';

    END crearUsuario;

    --
    -- #VERSION:0000001000
    --

    -- ===========================================================
    -- PROCEDURE homologarCoreWebModulo
    -- -----------------------------------------------------------
    -- insersion type table core en type table web de roles y 
    -- modulos
    -- ===========================================================
    PROCEDURE buscarUsuarioPorNombre
    (
        p_nombre_usuario               IN  US_TUSER.USER_ALAS%type,
        p_id_usuario                   OUT US_TUSER.USER_USER%type,
        p_cod_rta                      OUT NE_TCRTA.CRTA_CRTA%type
    )IS

    CURSOR c_usuario IS
        SELECT 
            USER_USER
        FROM
            FS_AUWEB_US.US_TUSER
        WHERE
            USER_ALAS = p_nombre_usuario;

        r_usuario c_usuario%rowtype;

    BEGIN  

        OPEN  c_usuario;
        FETCH c_usuario INTO r_usuario;
        CLOSE c_usuario;

        IF(r_usuario.USER_USER IS NOT NULL) THEN
          p_id_usuario  :=  r_usuario.USER_USER;
          p_cod_rta     := 'OK';
        ELSE
          p_id_usuario  := NULL;
          p_cod_rta     := 'ER_NULL';
        END IF;
        EXCEPTION
            WHEN OTHERS THEN
                p_id_usuario  := NULL;
                p_cod_rta  := 'ERROR_NC';

    END buscarUsuarioPorNombre;
    --
    -- #VERSION:0000001000
    --

    -- ===========================================================
    -- PROCEDURE homologarWebCoreModulo
    -- -----------------------------------------------------------
    -- insersion type table web en type table core de roles y
    -- modulos
    -- ===========================================================
    PROCEDURE actualizarUsuario
    (
        p_nombre_usuario               IN  US_TUSER.USER_ALAS%type,
        p_nombre_usuario_act           IN  US_TUSER.USER_ALAS%type,
        p_password_usuario_act         IN  US_TUSER.USER_PSWD%type,
        p_cod_rta                      OUT NE_TCRTA.CRTA_CRTA%type
    )IS

        v_id_usuario            US_TUSER.USER_USER%type;
        v_cod_rta_tipo          NE_TCRTA.CRTA_CRTA%type;

    BEGIN  

        US_QUSER.buscarUsuarioPorNombre
        (
            p_nombre_usuario,             
            v_id_usuario,
            v_cod_rta_tipo                      
        );

        IF(v_id_usuario IS NOT NULL) THEN

            UPDATE 
                FS_AUWEB_US.US_TUSER
            SET 
                USER_ALAS = p_nombre_usuario_act, 
                USER_PSWD = p_password_usuario_act
            WHERE 
                USER_USER = v_id_usuario;

              p_cod_rta     := 'OK';
        ELSE
              p_cod_rta     := v_cod_rta_tipo;
        END IF;
        EXCEPTION
            WHEN OTHERS THEN
                p_cod_rta  := 'ERROR_NC';

    END actualizarUsuario;
END US_QUSER;
/