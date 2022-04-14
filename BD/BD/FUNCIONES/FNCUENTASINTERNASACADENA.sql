DELIMITER ;
DROP FUNCTION IF EXISTS `FNCUENTASINTERNASACADENA`;
DELIMITER $$

CREATE FUNCTION `FNCUENTASINTERNASACADENA`(
	-- Función para obtener las cuentas internas del cliente como cadena
	Par_ClienteID   BIGINT(20)		--	ID del cliente
) RETURNS varchar(8000) CHARSET latin1
DETERMINISTIC
BEGIN
	-- Variables

	DECLARE Var_Resultado VARCHAR(8000);	-- Variable donde se guardan las cuentas

	-- Constantes

	DECLARE Var_TipCuentaInterna CHAR(1);	-- Variable de tipo cuenta interna
	DECLARE Cadena_Vacia CHAR(1);			-- Cadena vacía

	-- Asignacion de constantes

	SET Cadena_Vacia := '';					-- Se establece la cadena vacía ('')
	SET Var_TipCuentaInterna := 'I';		-- Se establece la letra I que es cuenta de tipo interna

	-- Inicializacion

	SET Var_Resultado := Cadena_Vacia;

	SET Var_Resultado := (SELECT GROUP_CONCAT(CONCAT(' ', CuentaDestino, ' - ', Beneficiario))
	FROM CUENTASTRANSFER
	WHERE TipoCuenta = Var_TipCuentaInterna AND ClienteID = Par_ClienteID);

	SET Var_Resultado := IFNULL(Var_Resultado, Cadena_Vacia);
	SET Var_Resultado := REPLACE(Var_Resultado, ',', '\r\n');

	RETURN Var_Resultado;
END$$