
-- FNFECHAOTORGACRERENOVA

DELIMITER ;

DROP FUNCTION IF EXISTS `FNFECHAOTORGACRERENOVA`;

DELIMITER $$

CREATE FUNCTION `FNFECHAOTORGACRERENOVA`(
	-- FUNCION QUE OBTIENE LA FECHA DE OTORGAMIENTO DE CREDITOS RENOVADOS
	Par_IdenCreditoCNBV 	VARCHAR(50) 		-- Identificador del Credito CNBV

) RETURNS varchar(20) CHARSET latin1
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaInicio 		VARCHAR(20);	-- Obtiene la Fecha de Inicio del Credito Renovado

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);		-- Cadena vacia
	DECLARE Entero_Cero			INT(11);		-- Entero cero

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;

	SELECT MIN(FechaInicio) INTO Var_FechaInicio
	FROM CREDITOS
	WHERE IdenCreditoCNBV = Par_IdenCreditoCNBV;

	RETURN Var_FechaInicio;

END$$