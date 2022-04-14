-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSENVIOMENSAJECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSENVIOMENSAJECON`;DELIMITER $$

CREATE PROCEDURE `SMSENVIOMENSAJECON`(
# ========================================================
# ------ SP PARA CONSULTAR LA CANTIDAD DE SMS ENVIOS------
# ========================================================
	Par_CampaniaID		INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(11)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Con_CantMen		INT(11);
	DECLARE Est_Enviado		CHAR(1);
    DECLARE Est_NoEnviado	CHAR(1);
    DECLARE Est_Cancelado	CHAR(1);
    DECLARE	Entero_Cero		INT(11);


	-- Asignacion de constantes
	SET	Con_CantMen			:= 1;		-- Consulta cuantos mensajes ya se enviaron y falta de enviar.
	SET Est_Enviado			:= 'E';
    SET Est_NoEnviado		:= 'N';
	SET Est_Cancelado		:= 'C';
	SET	Entero_Cero			:= 0;


	IF(Par_NumCon = Con_CantMen) THEN
		DROP TEMPORARY TABLE IF EXISTS TMPNUMENSAJES;
		CREATE TEMPORARY TABLE TMPNUMENSAJES(
			`NumMensajeID`		INT(11) NOT NULL AUTO_INCREMENT,
			`NumEnviados` 		INT(11),
			`NumPorEnviar`		INT(11),
			`NumCancelados`		INT(11),
			PRIMARY KEY(`NumMensajeID`)
			);

		INSERT INTO TMPNUMENSAJES(NumEnviados,NumPorEnviar,NumCancelados)
		SELECT	IFNULL(SUM(CASE WHEN sms.Estatus	= Est_Enviado		THEN 1 ELSE 0 END),Entero_Cero),
				IFNULL(SUM(CASE WHEN sms.Estatus	= Est_NoEnviado 	THEN 1 ELSE 0 END),Entero_Cero),
                IFNULL(SUM(CASE WHEN sms.Estatus	= Est_Cancelado		THEN 1 ELSE 0 END),Entero_Cero)
			FROM	SMSENVIOMENSAJE sms
		UNION
		SELECT	IFNULL(SUM(CASE WHEN his.Estatus	= Est_Enviado		THEN 1 ELSE 0 END),Entero_Cero),
				IFNULL(SUM(CASE WHEN his.Estatus	= Est_NoEnviado 	THEN 1 ELSE 0 END),Entero_Cero),
                IFNULL(SUM(CASE WHEN his.Estatus	= Est_Cancelado		THEN 1 ELSE 0 END),Entero_Cero)
			FROM	HISSMSENVIOMENSAJE his
		;

		SELECT SUM(NumEnviados) AS NumEnviados, SUM(NumPorEnviar) AS NumPorEnviar, SUM(NumCancelados) AS NumCancelados FROM TMPNUMENSAJES;

		DROP TEMPORARY TABLE IF EXISTS TMPNUMENSAJES;
	END IF;

END TerminaStore$$