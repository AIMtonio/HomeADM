-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAMBIOTASAAPORTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAMBIOTASAAPORTLIS`;DELIMITER $$

CREATE PROCEDURE `CAMBIOTASAAPORTLIS`(
# ====================================================================================
# ------ SP PARA LISTAS DE COMENTARIOS DE APORTACIONES QUE CAMBIARON DE TASA ---------
# ====================================================================================
	Par_AportacionID		BIGINT(20),			-- ID de la aportacion
	Par_NumLis				TINYINT UNSIGNED,	-- NÚMERO DE LISTA.

	Par_Empresa				INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Lis_Comentarios	INT(11);


	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Constante cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Constante Fecha vacia
	SET	Entero_Cero			:= 0;				-- Constante Entero cero
	SET	Lis_Comentarios		:= 16;				-- Lista para obtener los comentarios.

	IF(Par_NumLis = Lis_Comentarios) THEN
		SELECT CONCAT( ClaveUsuario, ' ',FechaActual, ' ',Comentario)  AS DesComentarios
		FROM CAMBIOTASAAPORT
		WHERE AportacionID = Par_AportacionID
        ORDER BY FechaActual DESC;
	END IF;

END TerminaStore$$