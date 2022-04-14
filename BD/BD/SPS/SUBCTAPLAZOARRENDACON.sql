-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOARRENDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPLAZOARRENDACON`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPLAZOARRENDACON`(
-- SP PARA CONSULTA DE CUENTAS MAYOR
	Par_ConceptoArrendaID	INT(5),				-- Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento',
	Par_Plazo				CHAR(1),			-- Indica el plazo  de arrendamiento
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),			-- Id de la empresa
	Aud_Usuario				INT(11),			-- Usuario
    Aud_FechaActual			DATETIME,	 		-- Fecha actual
	Aud_DireccionIP			VARCHAR(15), 		-- Direccion IP
	Aud_ProgramaID			VARCHAR(50), 		-- Id del programa
	Aud_Sucursal			INT(11),	 		-- Numero de sucursal
	Aud_NumTransaccion		BIGINT(20)   		-- Numero de transaccion
  )
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);		-- Entero cero
	DECLARE	Con_Principal	INT(11);		-- Consulta principal
	DECLARE	Decimal_Cero	DECIMAL(18,2);	-- Decimal cero
	DECLARE Cadena_Vacia	CHAR(1);		-- Cadena vacia

	-- Asignacion de Constantes
	SET	Entero_Cero		:= 0;		-- Valor cero
	SET	Con_Principal	:= 1;		-- Consulta por llave primaria
	SET	Decimal_Cero	:= 0.0;		-- Constante 0.0 --
	SET	Cadena_Vacia	:= '';		-- Constante Vacia --

	-- CONSULTA PRINCIPAL
	IF(Con_Principal	= Par_NumCon)THEN
	SELECT 	ConceptoArrendaID,	Plazo,	SubCuenta
		FROM	SUBCTAPLAZOARRENDA
		WHERE	ConceptoArrendaID	= Par_ConceptoArrendaID
		  AND	Plazo				= Par_Plazo;
	END IF;

END TerminaStore$$