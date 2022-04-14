-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPOARRENDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPOARRENDACON`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPOARRENDACON`(
	-- SP PARA CONSULTA DE SUBCUENTA
	Par_ConceptoArrendaID	INT(5),				-- 'Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento',
	Par_TipoArrenda			CHAR(1),			-- "Indica el tipo de arrendamiento  "F = Financiero P = Puro"',
	Par_NumCon				TINYINT UNSIGNED,	-- numero de consulta

	Aud_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
  )
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE	Entero_Cero		INT(11);			-- Entero cero
	DECLARE	Con_Principal	INT(11);			-- Consulta Principal
	DECLARE	Decimal_Cero	DECIMAL(18,2);		-- Decimal cero
	DECLARE	Cadena_Vacia	CHAR(1);			-- Cadena vacia

	-- Asignacion de Constantes
	SET	Entero_Cero		:= 0;		-- Valor cero
	SET	Con_Principal	:= 1;		-- Consulta por llave primaria
	SET	Decimal_Cero	:= 0.0;		-- Constante 0.0
	SET	Cadena_Vacia	:= '';		-- Constante Vacia

	-- CONSULTA PRINCIPAL
	IF(Con_Principal	= Par_NumCon)THEN
	SELECT	ConceptoArrendaID,	TipoArrenda,	SubCuenta
		FROM	SUBCTATIPOARRENDA
		WHERE	ConceptoArrendaID	= Par_ConceptoArrendaID
		  AND	TipoArrenda			= Par_TipoArrenda;
	END IF;

END TerminaStore$$