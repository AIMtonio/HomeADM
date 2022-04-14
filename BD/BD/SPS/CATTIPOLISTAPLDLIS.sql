-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOLISTAPLDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOLISTAPLDLIS`;DELIMITER $$

CREATE PROCEDURE `CATTIPOLISTAPLDLIS`(
	/*SP para Listar el catalogo de listas de PLD*/
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
	SET	Lista_Principal			:= 1;			-- Lista Principal

	IF(Par_NumLis = Lista_Principal) THEN
		SELECT TipoListaID,Descripcion FROM CATTIPOLISTAPLD
			WHERE TipoListaID LIKE CONCAT('%',Par_Descripcion,'%') OR Descripcion LIKE CONCAT('%',Par_Descripcion,'%')
			ORDER BY TipoListaID LIMIT 15;
	END IF;
END TerminaStore$$