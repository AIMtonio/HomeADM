-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMETODOSPAGOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATMETODOSPAGOCON`;DELIMITER $$

CREATE PROCEDURE `CATMETODOSPAGOCON`(
	/*SP para consultar los Ingresos*/
	Par_MetodoPagoID		INT(11),		# Consecutivo de los Metodos de Pago
	Par_NumCon				TINYINT UNSIGNED,	# Numero de consulta
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11) ,
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Con_Principal	CHAR(1);

	-- Asignacion de Constantes
	SET	Con_Principal			:= 1;			-- Consulta Principal

	IF(Par_NumCon = Con_Principal) THEN
		SELECT	MetodoPagoID,	Descripcion,Estatus FROM CATMETODOSPAGO
			WHERE MetodoPagoID = Par_MetodoPagoID;
	END IF;
END TerminaStore$$