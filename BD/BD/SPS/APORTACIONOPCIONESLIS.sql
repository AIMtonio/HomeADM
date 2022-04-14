-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONOPCIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONOPCIONESLIS`;DELIMITER $$

CREATE PROCEDURE `APORTACIONOPCIONESLIS`(
# ========================================================
# ------ SP PARA LISTA DE OPCIONES DE APORTACION ---------
# ========================================================
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
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Lis_OpcionesAport	INT(11);


	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Constante cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Constante Fecha vacia
	SET	Entero_Cero			:= 0;				-- Constante Entero cero
	SET	Lis_OpcionesAport	:= 17;				-- Lista para obtener las opciones.

	IF(Par_NumLis = Lis_OpcionesAport) THEN
		SELECT OpcionID AS Opcion, UPPER(NombreCorto) AS Descripcion
		FROM APORTACIONOPCIONES
        ORDER BY FechaActual DESC;
	END IF;

END TerminaStore$$