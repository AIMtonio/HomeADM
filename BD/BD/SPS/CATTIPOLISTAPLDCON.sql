-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOLISTAPLDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOLISTAPLDCON`;DELIMITER $$

CREATE PROCEDURE `CATTIPOLISTAPLDCON`(
	/*SP para consultar el catalogo de listas de PLD*/
	Par_TipoListaID			VARCHAR(45),		# Descripcion de la lista
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
		SELECT TipoListaID,Descripcion,Estatus FROM CATTIPOLISTAPLD
			WHERE TipoListaID = Par_TipoListaID;
	END IF;
END TerminaStore$$