-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITODOCENTVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITODOCENTVAL`;DELIMITER $$

CREATE PROCEDURE `CREDITODOCENTVAL`(
    Par_Credito         BIGINT(12),
    Par_Grupo           INT(11),
    Par_TipVal          INT(11),
    INOUT Par_CheckComple    CHAR(1),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

/*  Declaracion de   Variables   */
DECLARE     Var_Credito             BIGINT(12);
DECLARE     Var_CreditoCheckIncomp  VARCHAR(150);
DECLARE	Var_Producto			INT(11);
DECLARE Var_RequiereCheckList	CHAR(1);



/*  Declaracion de   Constantes   */
DECLARE     Con_Cadena_Vacia        CHAR(1);
DECLARE     Con_Fecha_Vacia         DATETIME;
DECLARE     Con_Entero_Cero         INT(11);
DECLARE     Con_Str_SI              CHAR(1);
DECLARE     Con_Str_NO              CHAR(1);
DECLARE     Con_SolStaInactiva      CHAR(1);
DECLARE     Con_SolStaAutorizada    CHAR(1);
DECLARE     Con_TipoSolicitud       CHAR(1);
DECLARE     Con_TipValCreInd        INT(11);
DECLARE     Con_TipValCreGrup       INT(11);


DECLARE Cur_Grupos CURSOR FOR
 SELECT Cre.CreditoID
    FROM INTEGRAGRUPOSCRE SolGrp
    INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID =  SolGrp.SolicitudCreditoID  -- and Sol.Estatus = Con_SolStaInactiva
    INNER JOIN CREDITOS Cre         ON Cre.SolicitudCreditoID =  Sol.SolicitudCreditoID
    WHERE SolGrp.GrupoID = Par_Grupo
    ORDER BY Cre.CreditoID;


/*  asignacion de Constantes   */
SET     Con_Cadena_Vacia        := '';              -- Cadena Vacia
SET     Con_Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
SET     Con_Entero_Cero         := 0;               -- Entero Cero
SET     Con_Str_SI              := 'S';             -- String de Si
SET     Con_Str_NO              := 'N';             -- String de No
SET     Con_SolStaInactiva      := 'I';             -- Estatus de Solicitud Inactiva
SET     Con_SolStaAutorizada    := 'A';             -- Estatus de Solicitud Autorizada
SET     Con_TipoSolicitud       := 'S';             -- Tipo de Clasificacion para Solicitud


SET     Con_TipValCreInd        := 1;               -- Tipo de Validacion  Checklist completo de un Credito Individual
SET     Con_TipValCreGrup       := 2;               -- Tipo de Validacion  Checklist completo de Grupo de Creditos

/* Inicializar parametros de salida */
SET     Par_NumErr              := 1;
SET     Par_ErrMen              := Con_Cadena_Vacia;
SET     Var_CreditoCheckIncomp   := Con_Cadena_Vacia;


SET     Par_CheckComple := Con_Str_NO;



/*   Validacion de Checklist completo de un Credito (Individual)   */
IF Par_TipVal = Con_TipValCreInd THEN
    IF(IFNULL(Par_Credito, Con_Entero_Cero))= Con_Entero_Cero THEN
        SET Par_ErrMen  := 'El numero de credito no es valido.';
        IF Par_Salida = Con_Str_SI THEN
            SELECT  '001' AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'creditoID' AS control,
                    Con_Entero_Cero AS consecutivo;
        END IF;
        LEAVE TerminaStore;
    END IF;

	SET Var_Producto := (   SELECT ProductoCreditoID
	                        FROM CREDITOS
	                        WHERE CreditoID = Par_Credito
	                          AND Estatus   = Con_SolStaInactiva);
	SET Var_RequiereCheckList := (SELECT RequiereCheckList FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_Producto LIMIT 1);
	SET Var_RequiereCheckList := IFNULL(Var_RequiereCheckList, Con_Cadena_Vacia);

	IF(Var_RequiereCheckList = Con_Str_SI)THEN
	    IF NOT EXISTS(SELECT CreditoID FROM CREDITODOCENT WHERE CreditoID = Par_Credito) THEN
	        SET Par_ErrMen  := CONCAT("El Credito ",CONVERT(Par_Credito, CHAR)," no existe en el checklist.");
	        IF Par_Salida = Con_Str_SI THEN
	            SELECT  '002' AS NumErr,
	                    Par_ErrMen AS ErrMen,
	                    'creditoID' AS control,
	                    Con_Entero_Cero AS consecutivo;
	        END IF;
	        LEAVE TerminaStore;
	    END IF;
    END IF;

    IF EXISTS(  SELECT CreditoID
                FROM CREDITODOCENT
                WHERE CreditoID = Par_Credito
                  AND DocAceptado = Con_Str_NO) THEN

        SET     Par_CheckComple := Con_Str_NO;
        SET     Par_NumErr  := 0;
        SET     Par_ErrMen  := CONCAT("El Credito ",CONVERT(Par_Credito, CHAR)," no tiene su checklist Completo.");

        IF Par_Salida = Con_Str_SI THEN
            SELECT  '000' AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'creditoID' AS control,
                    Con_Entero_Cero AS consecutivo;
        END IF;
        LEAVE TerminaStore;

    ELSE
        SET     Par_CheckComple := Con_Str_SI;
        SET     Par_NumErr  := 0;
        SET     Par_ErrMen  := CONCAT("Credito ",CONVERT(Par_Credito, CHAR),"  tiene su checklist Completo.");

        IF Par_Salida = Con_Str_SI THEN
            SELECT  '000' AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'creditoID' AS control,
                    Par_Credito AS consecutivo;
        END IF;
        LEAVE TerminaStore;

    END IF;
END IF;



/*   Validacion de Checklist completo de un Grupo de Creditos (varios)   */
IF Par_TipVal = Con_TipValCreGrup THEN
    IF(IFNULL(Par_Grupo, Con_Entero_Cero))= Con_Entero_Cero THEN
        SET     Par_ErrMen  := 'El numero de Grupo no es valido.' ;
        IF Par_Salida = Con_Str_SI THEN
            SELECT  '003' AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'GrupoID' AS control,
                    Con_Entero_Cero AS consecutivo;
        END IF;
        LEAVE TerminaStore;
    END IF;

    IF NOT EXISTS(SELECT GrupoID FROM GRUPOSCREDITO WHERE GrupoID = Par_Grupo) THEN
        SET     Par_ErrMen  := CONCAT("El Grupo ",CONVERT(Par_Grupo, CHAR)," no existe.") ;
        IF Par_Salida = Con_Str_SI THEN
            SELECT  '004' AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'GrupoID' AS control,
                    Con_Entero_Cero AS consecutivo;
        END IF;
        LEAVE TerminaStore;
    END IF;

    IF( SELECT COUNT(SolGrp.SolicitudCreditoID)
        FROM INTEGRAGRUPOSCRE SolGrp
        WHERE GrupoID = Par_Grupo) <= Con_Entero_Cero THEN
        SET     Par_ErrMen  := CONCAT("El Grupo ",CONVERT(Par_Grupo, CHAR)," No tiene Solicitudes Asignadas.") ;
        IF Par_Salida = Con_Str_SI THEN
            SELECT  '005' AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'GrupoID' AS control,
                    Con_Entero_Cero AS consecutivo;
        END IF;
        LEAVE TerminaStore;
    END IF;

    SET Par_ErrMen  := Con_Cadena_Vacia;

    OPEN Cur_Grupos;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        CICLOCUR_GRUPOS: LOOP
            FETCH Cur_Grupos INTO Var_Credito;

			SET Var_Producto := (   SELECT ProductoCreditoID
			                        FROM CREDITOS
			                        WHERE CreditoID = Var_Credito
			                          AND Estatus   = Con_SolStaInactiva);
			SET Var_RequiereCheckList := (SELECT RequiereCheckList FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_Producto LIMIT 1);
			SET Var_RequiereCheckList := IFNULL(Var_RequiereCheckList, Con_Cadena_Vacia);

			IF(Var_RequiereCheckList = Con_Str_SI)THEN
	            IF NOT EXISTS(SELECT CreditoID FROM CREDITODOCENT WHERE CreditoID = Var_Credito) THEN
	                SET     Par_ErrMen  := CONCAT("El Credito ", CONVERT(Var_Credito, CHAR), " NO existe en el checklist.");
	                IF Par_Salida = Con_Str_SI THEN
	                    SELECT  '006' AS NumErr,
	                             Par_ErrMen AS ErrMen,
	                            'creditoID' AS control,
	                            Var_Credito AS consecutivo;
	                END IF;
	                LEAVE CICLOCUR_GRUPOS;
	            END IF;

            	IF EXISTS(  SELECT CreditoID
                        FROM CREDITODOCENT
                        WHERE CreditoID = Var_Credito
                          AND DocAceptado = Con_Str_NO) THEN

	                IF Var_CreditoCheckIncomp = Con_Cadena_Vacia THEN
	                    SET     Var_CreditoCheckIncomp := CONVERT(Var_Credito, CHAR);
	                ELSE
	                    SET     Var_CreditoCheckIncomp := CONCAT(Var_CreditoCheckIncomp, ",", CONVERT(Var_Credito, CHAR));
	                END IF;
	            END IF;
			END IF;

        END LOOP CICLOCUR_GRUPOS;
    END;
    CLOSE Cur_Grupos;

    IF Par_ErrMen <> Con_Cadena_Vacia THEN
         LEAVE TerminaStore;
    END IF;
    SET Var_CreditoCheckIncomp := IFNULL(Var_CreditoCheckIncomp,Con_Cadena_Vacia);
    IF Var_CreditoCheckIncomp = Con_Cadena_Vacia THEN
        SET     Par_CheckComple := Con_Str_SI;
        SET     Par_ErrMen      := CONCAT("El Grupo ",CONVERT(Par_Grupo, CHAR)," tiene Todos los creditos con checklist Completo");
    ELSE
        SET     Par_CheckComple := Con_Str_NO;
        SET     Par_ErrMen      := CONCAT("El Grupo ",CONVERT(Par_Grupo, CHAR)," tiene CheckList Incompleto, para los Creditos: ", Var_CreditoCheckIncomp);


    END IF;

    SET     Par_NumErr      := 0;
    IF Par_Salida = Con_Str_SI THEN
        SELECT  '000' AS NumErr,
                Par_ErrMen AS ErrMen,
                'grupoID' AS control,
                Par_Grupo AS consecutivo;
    END IF;
    LEAVE TerminaStore;
END IF;


END TerminaStore$$