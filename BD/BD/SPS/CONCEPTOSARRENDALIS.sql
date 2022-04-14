-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSARRENDALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSARRENDALIS`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSARRENDALIS`(
  -- STORED PROCEDURE DE LISTA DE CONCEPTOS ARRENDAMIENTO
	Par_NumLis			TINYINT UNSIGNED,		-- Numero de lista

	Aud_EmpresaID		INT(11),				-- Parametros de Auditoria
	Aud_Usuario			INT(11),				-- Parametros de Auditoria

	Aud_FechaActual		DATETIME,				-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID 		VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal		INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion 	BIGINT(20)				-- Parametros de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT;			-- Entero cero
	DECLARE Con_Principal		INT;			-- Lista principal
	DECLARE Decimal_Cero		DECIMAL(18,2);	-- Decimal cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0; 			-- Entero cero
	SET Con_Principal			:= 1; 			-- Lista principal
	SET Decimal_Cero			:= 0.0;			-- Decimal 0.0
	SET Cadena_Vacia			:= '';			-- Cadena Vacia

	-- CONSULTA PRINCIPAL
	IF(Con_Principal = Par_NumLis)THEN
		SELECT	ConceptoArrendaID,	Descripcion
			FROM CONCEPTOSARRENDA;
	END IF;

END TerminaStore$$