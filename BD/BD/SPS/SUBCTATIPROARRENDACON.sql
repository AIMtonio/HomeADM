-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROARRENDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPROARRENDACON`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPROARRENDACON`(
	-- SP PARA CONSULTA DE SUBCUENTA
	Par_ConceptoArrendaID	INT(5),				-- Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento',
	Par_ProductoArrendaID	INT(11),			-- Indica el producto de arrendamiento
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
	DECLARE	Entero_Cero   INT(11);			-- Entero cero
	DECLARE	Con_Principal INT(11);			-- Consulta principal
	DECLARE	Decimal_Cero  DECIMAL(18,2);	-- Decimal cero
	DECLARE	Cadena_Vacia  CHAR(1);			-- Cadena vacia

	-- Asignacion de Constantes
	SET	Entero_Cero		:= 0;		-- Valor cero
	SET	Con_Principal	:= 1;		-- Consulta por llave primaria
	SET	Decimal_Cero	:= 0.0;		-- Constante 0.0 --
	SET	Cadena_Vacia	:= '';		-- Constante Vacia --

	-- CONSULTA PRINCIPAL
	IF(Con_Principal	= Par_NumCon)THEN
	SELECT	ConceptoArrendaID,	ProductoArrendaID,	SubCuenta
		FROM	SUBCTATIPROARRENDA
		WHERE	ConceptoArrendaID	= Par_ConceptoArrendaID
		  AND	ProductoArrendaID	= Par_ProductoArrendaID;
	END IF;

END TerminaStore$$