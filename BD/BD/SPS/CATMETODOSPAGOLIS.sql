-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMETODOSPAGOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATMETODOSPAGOLIS`;DELIMITER $$

CREATE PROCEDURE `CATMETODOSPAGOLIS`(
	/*SP para Listar el catalogo de Ingresos  */
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
    DECLARE Lista_Combo		INT(11);
    DECLARE Est_Activo		CHAR(1);

	-- Asignacion de Constantes
	SET	Lista_Principal			:= 1;			-- Lista Principal
    SET Lista_Combo				:= 2;			-- Lista Combo(Activos)
    SET Est_Activo				:= 'A';			-- Estatus Activo

	IF(Par_NumLis = Lista_Principal) THEN
		SELECT MetodoPagoID,Descripcion FROM CATMETODOSPAGO
			WHERE MetodoPagoID LIKE CONCAT('%',Par_Descripcion,'%') OR Descripcion LIKE CONCAT('%',Par_Descripcion,'%')
			ORDER BY MetodoPagoID LIMIT 15;
	END IF;

    IF(Par_NumLis = Lista_Combo) THEN
		SELECT	MetodoPagoID,	Descripcion FROM CATMETODOSPAGO
			WHERE (MetodoPagoID LIKE CONCAT('%',Par_Descripcion,'%') OR Descripcion LIKE CONCAT('%',Par_Descripcion,'%'))
            AND Estatus = Est_Activo
			ORDER BY MetodoPagoID;
	END IF;
END TerminaStore$$