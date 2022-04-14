DELIMITER ;
DROP FUNCTION IF EXISTS `FNCUENTASEXTERNASACADENA`;
DELIMITER $$

CREATE FUNCTION `FNCUENTASEXTERNASACADENA`(
	-- Función para obtener las cuentas externas del cliente como cadena
	Par_ClienteID   BIGINT(20)		--	ID del cliente
) RETURNS varchar(8000) CHARSET latin1
DETERMINISTIC
BEGIN
	-- Variables

	DECLARE Var_Resultado VARCHAR(8000);	-- Variable donde se guardaran las cuentas

	-- Constantes

	DECLARE Var_TipCuentaExterna CHAR(1);	-- Variable de tipo cuenta externa 
	DECLARE Cadena_Vacia CHAR(1);			-- Cadena vacía

	-- Asignacion de constantes

	SET Cadena_Vacia := '';					-- Se establece la cadena vacía ('')
	SET Var_TipCuentaExterna := 'E';		-- Se establece la letra E que es cuenta de tipo externa

	-- Inicializacion

	SET Var_Resultado := Cadena_Vacia;

	SET Var_Resultado := (SELECT GROUP_CONCAT(CONCAT(' ', Clabe, ' - ', Beneficiario))
	FROM CUENTASTRANSFER
	WHERE TipoCuenta = Var_TipCuentaExterna AND ClienteID = Par_ClienteID);

	SET Var_Resultado := IFNULL(Var_Resultado, Cadena_Vacia);
	SET Var_Resultado := REPLACE(Var_Resultado, ',', '\r\n');

	RETURN Var_Resultado;
END$$