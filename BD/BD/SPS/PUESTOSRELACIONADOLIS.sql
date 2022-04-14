-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSRELACIONADOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUESTOSRELACIONADOLIS`;DELIMITER $$

CREATE PROCEDURE `PUESTOSRELACIONADOLIS`(
# =====================================================================================
# ----- SP PARA LISTAR EL CATALOGO DE CARGOS -----------------
# =====================================================================================
	Par_Descripcion				VARCHAR(100),		# Descripcion de la lista
	Par_NumLis					TINYINT UNSIGNED,	# Numero de consulta

	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11) ,
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Lista_Principal		CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET	Lista_Principal			:= 1;			-- Lista Principal

	# LISTA PRINCIPAL
	IF(Par_NumLis = Lista_Principal) THEN
		SELECT PuestoRelID,	Descripcion FROM PUESTOSRELACIONADO
			WHERE Descripcion LIKE CONCAT('%',Par_Descripcion,'%')
			ORDER BY PuestoRelID LIMIT 15;
	END IF;


END TerminaStore$$