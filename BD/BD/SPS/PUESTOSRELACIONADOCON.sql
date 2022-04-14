-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSRELACIONADOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUESTOSRELACIONADOCON`;DELIMITER $$

CREATE PROCEDURE `PUESTOSRELACIONADOCON`(
# =====================================================================================
# ----- SP PARA CONSULTAR EL CATALOGO DE CARGOS  -----------------
# =====================================================================================
	Par_PuestoRelID			INT(11),			# Consecutivo de los cargos
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

	-- DECLARACION DE CONSTANTES
	DECLARE	Con_Principal		CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET	Con_Principal			:= 1;			-- Consulta Principal


	# CONSULTA PRINCIPAL
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	PuestoRelID,	Descripcion
		FROM PUESTOSRELACIONADO
		WHERE PuestoRelID = Par_PuestoRelID;
	END IF;


END TerminaStore$$