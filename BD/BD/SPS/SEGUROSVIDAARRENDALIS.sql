-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROSVIDAARRENDALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROSVIDAARRENDALIS`;DELIMITER $$

CREATE PROCEDURE `SEGUROSVIDAARRENDALIS`(
# =====================================================================================
# -- STORED PROCEDURE DE LISTA DE LOS SEGUROS DE VIDA
# =====================================================================================
	Par_Nombre				VARCHAR(50),			-- Nombre o descripcion del seguro de vida
	Par_NumLis				TINYINT UNSIGNED,		-- Numero de lista

	Aud_EmpresaID			INT(11),				-- Parametros de Auditoria
	Aud_Usuario				INT(11),				-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametros de Auditoria

	Aud_DireccionIP 		VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal			INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion 		BIGINT(20)				-- Parametros de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Entero cero
	DECLARE Lis_Principal		INT(11);			-- Lista principal
	DECLARE Decimal_Cero 		DECIMAL(18,2);		-- Decimal cero
	DECLARE Cadena_Vacia 		CHAR(1);			-- Cadena vacia

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0; 				-- Entero cero
	SET Lis_Principal			:= 1;				-- lista por llave primaria
	SET Decimal_Cero 			:= 0.0;				-- Decimal cero
	SET Cadena_Vacia 			:= ''; 				-- Cadena vacia

	-- CONSULTA PRINCIPAL
	IF(Lis_Principal = Par_NumLis)THEN
		SELECT	SeguroVidaArrendaID,	Descripcion
			FROM SEGUROSVIDAARRENDA
			WHERE	Descripcion  LIKE CONCAT("%", Par_Nombre, "%")
			LIMIT 0, 15;
	END IF;

END TerminaStore$$