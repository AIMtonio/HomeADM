-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROSARRENDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROSARRENDACON`;DELIMITER $$

CREATE PROCEDURE `SEGUROSARRENDACON`(
# =====================================================================================
# -- STORED PROCEDURE DE CONSULTA PARA LOS SEGUROS DE ARRENDAMIENTO
# =====================================================================================
	Par_SeguroArrendaID		INT(11),			-- ID del seguro
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	Aud_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario         	INT(11),			-- Parametros de Auditoria
	Aud_FechaActual     	DATETIME,			-- Parametros de Auditoria

	Aud_DireccionIP     	VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID      	VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal        	INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion  	BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT;				-- Entero cero
	DECLARE Con_Principal	INT;				-- Consulta principal
	DECLARE Decimal_Cero	DECIMAL(18,2);		-- Decimal cero
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena vacia

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;				-- Entero cero
	SET Con_Principal		:= 1; 				-- Consulta por llave primaria
	SET Decimal_Cero		:= 0.0;				-- Decimal 0.0
	SET Cadena_Vacia		:= ''; 				-- Cadena Vacia

	-- CONSULTA PRINCIPAL
	IF(Con_Principal = Par_NumCon)THEN
		SELECT	SeguroArrendaID,	Descripcion
			FROM SEGUROSARRENDA
			WHERE	SeguroArrendaID =  Par_SeguroArrendaID;
	END IF;

END TerminaStore$$