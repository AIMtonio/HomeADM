-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRODUCTOARRENDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRODUCTOARRENDACON`;DELIMITER $$

CREATE PROCEDURE `PRODUCTOARRENDACON`(
# =====================================================================================
# -- STORED PROCEDURE DE CONSULTA DE PRODUCTOS DE ARRENDAMIENTO
# =====================================================================================
	Par_ProductoArrendaID	INT(11),			-- Id del producto de arrendamiento */
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	Aud_EmpresaID			INT,				-- Parametros de Auditoria
	Aud_Usuario         	INT,				-- Parametros de Auditoria
	Aud_FechaActual     	DATETIME,			-- Parametros de Auditoria

	Aud_DireccionIP     	VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID      	VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal        	INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion  	bigINT(20)			-- Parametros de Auditoria
	)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);			-- Entero Cero
	DECLARE Con_Principal	INT(11);			-- Consulta principal
	DECLARE Decimal_Cero	DECIMAL(18,2);		-- Decimal cero
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena Vacia

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero cero
	SET Con_Principal		:= 1; 				-- Consulta por llave primaria
	SET Decimal_Cero		:= 0.0;				-- Decimal cero 0.0
	SET Cadena_Vacia		:= ''; 				-- Cadena Vacia

	-- CONSULTA PRINCIPAL
	IF(Con_Principal = Par_NumCon)THEN
		SELECT	ProductoArrendaID,	NombreCorto,	Descripcion
			FROM PRODUCTOARRENDA
			WHERE	ProductoArrendaID = Par_ProductoArrendaID;
	END IF;

END TerminaStore$$