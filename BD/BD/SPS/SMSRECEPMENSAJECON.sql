-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSRECEPMENSAJECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSRECEPMENSAJECON`;DELIMITER $$

CREATE PROCEDURE `SMSRECEPMENSAJECON`(
# ========================================================
# ---- SP PARA CONSULTAR LA CANTIDAD DE SMS RECEPCIONES---
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
	DECLARE	Con_CantMenRec  INT(11);
	DECLARE Est_Procesado	CHAR(1);
    DECLARE Est_Recibidos	CHAR(1);
    DECLARE Est_Cancelado	CHAR(1);
    DECLARE	Entero_Cero		INT(11);


	-- Asignacion de constantes
	SET	Con_CantMenRec		:= 1;		-- Consulta cuantos mensajes ya se enviaron y falta de enviar.
	SET Est_Procesado		:= 'P';
    SET Est_Recibidos		:= 'R';
	SET Est_Cancelado		:= 'C';
    SET Entero_Cero			:= 0;


	IF(Par_NumCon = Con_CantMenRec) THEN
		SELECT	  	IFNULL(SUM(CASE WHEN Estatus	= Est_Procesado		THEN 1 ELSE 0 END),Entero_Cero) AS NumEnviados,
					IFNULL(SUM(CASE WHEN Estatus	= Est_Recibidos 	THEN 1 ELSE 0 END),Entero_Cero) AS NumPorEnviar,
                    IFNULL(SUM(CASE WHEN Estatus	= Est_Cancelado		THEN 1 ELSE 0 END),Entero_Cero) AS NumCancelados
			FROM	SMSRECEPMENSAJE;
	END IF;


END TerminaStore$$