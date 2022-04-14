-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOINGRESOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOINGRESOSCON`;DELIMITER $$

CREATE PROCEDURE `CATTIPOINGRESOSCON`(
	/*SP para consultar los Ingresos*/
	Par_Numero				INT(11),		# Consecutivo de Ingresos
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
		SELECT	Numero,	Tipo,	Descripcion,	Estatus
			FROM CATTIPOINGRESOS
			WHERE Numero = Par_Numero;
	END IF;
END TerminaStore$$