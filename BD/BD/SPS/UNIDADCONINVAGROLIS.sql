-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- UNIDADCONINVAGROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `UNIDADCONINVAGROLIS`;DELIMITER $$

CREATE PROCEDURE `UNIDADCONINVAGROLIS`(
    /*SP para Listar el catalogo de Unidades de Inversion*/
	Par_Descripcion			VARCHAR(100),		# Descripcion de la lista
	Par_NumLis				TINYINT UNSIGNED,	# Numero de consulta
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
	DECLARE	Lista_Principal	CHAR(1);

	-- Asignacion de Constantes
	SET	Lista_Principal			:= 1;		-- Lista Principal

	IF(Par_NumLis = Lista_Principal) THEN
		SELECT UniConceptoInvID,Clave,Unidad FROM UNIDADCONINVAGRO
			WHERE UniConceptoInvID LIKE CONCAT('%',Par_Descripcion,'%') OR Unidad LIKE CONCAT('%',Par_Descripcion,'%')
			ORDER BY UniConceptoInvID LIMIT 15;
	END IF;

END TerminaStore$$