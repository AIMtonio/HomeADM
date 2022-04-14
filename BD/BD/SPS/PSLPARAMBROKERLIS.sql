-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLPARAMBROKERLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLPARAMBROKERLIS`;DELIMITER $$

CREATE PROCEDURE `PSLPARAMBROKERLIS`(
	-- Stored procedure para listar los parametros del broker de servicios en linea
	Par_LlaveParametro 				VARCHAR(50),			-- Llave del parametro
	Par_ValorParametro 				VARCHAR(200),			-- Valor del parametro

	Par_NumLis						TINYINT UNSIGNED,		-- Opcion de lista

	Aud_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(2, 1); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE Var_LisPrincipal		TINYINT;				-- Lista de todos los parametros

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_LisPrincipal 			:= 1;					-- Lista de todos los parametros

	-- Lista de productos con filtros
	IF(Par_NumLis = Var_LisPrincipal) THEN
		SELECT LlaveParametro, ValorParametro
			FROM PSLPARAMBROKER;
	END IF;

-- Fin del SP
END TerminaStore$$