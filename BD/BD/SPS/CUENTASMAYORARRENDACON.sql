-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORARRENDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORARRENDACON`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORARRENDACON`(
	-- SP PARA CONSULTA DE CUENTAS MAYOR
	Par_ConceptoArrendaID	INT(5),				-- Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);			-- Entero cero
	DECLARE Con_Principal	INT(11);			-- Consulta principal
	DECLARE Decimal_Cero	DECIMAL(14,2);		-- Decimal cero
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena vacia

	-- Asignacion de Constantes
	SET Entero_Cero		:= 0;					-- Entero cero
	SET Con_Principal	:= 1;					-- Consulta por llave primaria
	SET Decimal_Cero	:= 0.0;					-- Decimal cero
	SET Cadena_Vacia	:= '';					-- Cadena vacia

	-- CONSULTA PRINCIPAL
	IF (Con_Principal = Par_NumCon) THEN
		SELECT		ConceptoArrendaID,	Cuenta,	Nomenclatura,	NomenclaturaCR
			FROM 	CUENTASMAYORARRENDA
			WHERE	ConceptoArrendaID = Par_ConceptoArrendaID;
	END IF;

END TerminaStore$$