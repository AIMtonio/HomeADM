-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNDECRYPTSAFI
DELIMITER ;
DROP FUNCTION IF EXISTS `FNDECRYPTSAFI`;DELIMITER $$

CREATE FUNCTION `FNDECRYPTSAFI`(
	/* Desencripta un dato de tipo BLOB */
	Par_Dato		BLOB
) RETURNS varchar(250) CHARSET latin1
    DETERMINISTIC
BEGIN

	DECLARE Var_Resultado		VARCHAR(250);
	DECLARE Key_SAFI			VARCHAR(250);

	DECLARE Cadena_Vacia		VARCHAR(2);

	SET Cadena_Vacia := '';

	SELECT KeyPassword
	INTO Key_SAFI
	FROM PARAMETROSSPEI LIMIT 1;

	SET Var_Resultado := AES_DECRYPT(Par_Dato,Key_SAFI);

	SET Var_Resultado := IFNULL(Var_Resultado,Cadena_Vacia);


	RETURN Var_Resultado;

END$$