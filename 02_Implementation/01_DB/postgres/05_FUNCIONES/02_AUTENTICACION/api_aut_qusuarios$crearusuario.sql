-- FUNCTION: ow_base_us."api_aut_qusuarios$crearusuario"(ow_base_us.type_tt_ge_lgtr, ow_base_us.type_tt_au_tpersn, ow_base_us.type_tt_au_rol, ow_base_us.type_tt_au_usuario)

CREATE OR REPLACE FUNCTION ow_base_us."api_aut_qusuarios$crearusuario"(
	p_ctrl_operacion ow_base_us.type_tt_ge_lgtr,
	p_tpersona ow_base_us.type_tt_au_tpersn,
	p_troles ow_base_us.type_tt_au_rol,
	p_tusuario ow_base_us.type_tt_au_usuario,
	OUT p_cod_rta text,
	OUT p_errores ow_base_us.type_tt_ge_erro,
	OUT p_mensajes ow_base_us.type_tt_ge_mnsje)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

/* */

DECLARE

    v_crta_crta_gral OW_BASE_US.GE_TCRTA.crta_crta%TYPE

    /* Codigo interno de respuesta */;

    v_crta_prcs_gral OW_BASE_US.GE_TCRTA.crta_prcs%TYPE

    /* Proceso al cual pertenece el codigo de respuesta */;

    v_crta_http_gral OW_BASE_US.GE_TCRTA.crta_http_code%TYPE

    /* Codigo Http para el cogido interno de respuesta */;

    v_crta_descri_gral OW_BASE_US.GE_TCRTA.crta_descri%TYPE

    /* Descripcion general del codigo de respuesta */;

    v_lgtr_id_entidad OW_BASE_US.GE_TLGTR.lgtr_id_entidad%TYPE

    /* Id Entidad para el log de transacciones */;

    v_lgtr OW_BASE_US.GE_TLGTR.lgtr_lgtr%TYPE

    /* Log de trasnsacciones */;

    v_cod_pern OW_BASE_US.AUT_TPERSN.persn_persn%TYPE;

    v_mensajes ow_base_us.type_tt_ge_mnsje;

    F$RESULT_REC RECORD;

    F$RESULT_REC_2 RECORD;

    F$RESULT_REC_3 RECORD;

    F$RESULT_REC_4 RECORD;

/* */

/* */

BEGIN

    v_crta_prcs_gral := 'API_AUT_QUSUARIOS.crearUsuario'

    /* */;

    DECLARE

        v_cod_rspta_lgtr_v OW_BASE_US.GE_TCRTA.crta_crta%TYPE;

        v_cod_rpta_descri_lgtr_v OW_BASE_US.GE_TCRTA.crta_descri%TYPE;

    BEGIN

        SELECT

            *

            FROM ow_base_us.ge_qlgtr$validar_ctrl_operacion(p_ctrl_operacion, v_crta_prcs_gral)

            INTO F$RESULT_REC;

        v_cod_rspta_lgtr_v := F$RESULT_REC.P_COD_RPTA;

        v_cod_rpta_descri_lgtr_v := F$RESULT_REC.P_COD_RPTA_DESCRI;

        p_errores := F$RESULT_REC.P_ERRORES

        /* */;

        IF (v_cod_rspta_lgtr_v <> 'OK') THEN

            v_crta_crta_gral := 'ERROR_LGTR';

            

        END IF;

    END

    /* */

    /* ============================================= */

    /* Se inicializa el log general para toda */

    /* la transaccion. A traves del log se puende */

    /* consultar el estado final y los errores */

    /* ============================================= */;

    DECLARE

        v_cod_rspta_lgtr OW_BASE_US.GE_TCDER.cder_cder%TYPE;

        v_cod_rpta_descri_lgtr OW_BASE_US.GE_TCDER.cder_descri%TYPE;

    /* */

    BEGIN

        SELECT

            *

            FROM ow_base_us.ge_qlgtr$iniciar_log(p_ctrl_operacion := p_ctrl_operacion, p_prcs := v_crta_prcs_gral)

            INTO v_cod_rspta_lgtr, v_cod_rpta_descri_lgtr, v_lgtr;

        /* */

    END

    /* */;

    SELECT

        *

        FROM ow_base_us.aut_qusuarios$crearpersona(v_crta_prcs_gral, p_tpersona)

        INTO F$RESULT_REC_2;

    p_cod_rta := F$RESULT_REC_2.P_COD_RPTA;

    v_cod_pern := F$RESULT_REC_2.P_COD_PERSONA;

    p_errores := F$RESULT_REC_2.P_ERRORES;

    v_mensajes := F$RESULT_REC_2.P_MENSAJES

    /* */;

    IF (p_cod_rta = 'OK')

    /* */

    THEN

        SELECT

            *

            FROM ow_base_us.aut_qusuarios$crearusuario(v_crta_prcs_gral, p_tusuario, v_cod_pern)

            INTO F$RESULT_REC_3;

        p_cod_rta := F$RESULT_REC_3.P_COD_RPTA;

        p_errores := F$RESULT_REC_3.P_ERRORES;

        v_mensajes := F$RESULT_REC_3.P_MENSAJES

        /* */;

        IF (p_cod_rta = 'OK')

        /* */

        THEN

            SELECT

                *

                FROM ow_base_us.aut_qusuarios$asignarroles(v_crta_prcs_gral, p_tusuario, p_troles)

                INTO F$RESULT_REC_4;

            p_cod_rta := F$RESULT_REC_4.P_COD_RPTA;

            p_errores := F$RESULT_REC_4.P_ERRORES;

            v_mensajes := F$RESULT_REC_4.P_MENSAJES;

        /* */

        /* */

        ELSE

            RETURN;

        /* */

        END IF;

    /* */

    /* */

    ELSE

        RETURN;

    /* */

    END IF

    /* */;

    IF (p_cod_rta = 'OK')

    /* */

    THEN

        /*

        [5350 - Severity CRITICAL - Unable automatically convert statements that explicitly apply or cancel a transaction. Revise your code to try move transaction control on side of application.]

        COMMIT

        */

        BEGIN

        END;

    /* */

    /* */

    ELSE

        /*

        [5350 - Severity CRITICAL - Unable automatically convert statements that explicitly apply or cancel a transaction. Revise your code to try move transaction control on side of application.]

        ROLLBACK

        */

        BEGIN

        END;

    /* */

    END IF

    /* */;

    p_mensajes := v_mensajes

    /* */;

    DECLARE

        v_cod_rspta_lgtr OW_BASE_US.GE_TCDER.cder_cder%TYPE;

        v_cod_rpta_descri_lgtr OW_BASE_US.GE_TCDER.cder_descri%TYPE;

    BEGIN

        IF (p_cod_rta = 'OK') THEN

            v_crta_descri_gral := NULL;

        END IF;

        SELECT

            *

            FROM ow_base_us.ge_qlgtr$finalizar_log(p_lgtr := v_lgtr, p_crta := p_cod_rta, p_id_entidad := COALESCE(v_lgtr_id_entidad, '-'), p_error := v_crta_descri_gral)

            INTO v_cod_rspta_lgtr, v_cod_rpta_descri_lgtr;

    END;

    /* */

END;

$BODY$;

ALTER FUNCTION ow_base_us."api_aut_qusuarios$crearusuario"(ow_base_us.type_tt_ge_lgtr, ow_base_us.type_tt_au_tpersn, ow_base_us.type_tt_au_rol, ow_base_us.type_tt_au_usuario)
    OWNER TO ow_base_us;
