-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROSARRENDALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROSARRENDALIS`;DELIMITER $$

CREATE PROCEDURE `SEGUROSARRENDALIS`(
-- Sp lista de seguros arrendamiento
	Par_Nombre			VARCHAR(50),		-- Nombre del cliente
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de consulta
	-- Parametros de Auditoria
	Aud_EmpresaID		INT(11),			-- Id de la empresa
	Aud_Usuario			INT(11),			-- Usuario
    Aud_FechaActual		DATETIME,	 		-- Fecha actual
	Aud_DireccionIP		VARCHAR(15), 		-- Direccion IP
	Aud_ProgramaID		VARCHAR(50), 		-- Id del programa
	Aud_Sucursal		INT(11),	 		-- Numero de sucursal
	Aud_NumTransaccion	BIGINT(20)   		-- Numero de transaccion
    )
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);		-- Entero cero
	DECLARE Lis_Principal	INT(11);		-- Lista principal
	DECLARE Decimal_Cero	DECIMAL(18,2);	-- Decimal cero
	DECLARE Cadena_Vacia	CHAR(1);		-- Cadena vacia

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;		-- Valor entero cero
	SET Lis_Principal		:= 1;		-- Consulta por llave primaria
	SET Decimal_Cero		:= 0.0;		-- Constante 0.0
	SET Cadena_Vacia		:= '';		-- Constante Vacia

	-- CONSULTA PRINCIPAL
	IF(Lis_Principal	= Par_NumLis)THEN
		SELECT	SeguroArrendaID,	Descripcion
			FROM	SEGUROSARRENDA
			WHERE	Descripcion	LIKE	CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 15;
	END IF;

END TerminaStore$$