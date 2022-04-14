-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNENCRYPTSAFI
DELIMITER ;
DROP FUNCTION IF EXISTS `FNENCRYPTSAFI`;DELIMITER $$

CREATE FUNCTION `FNENCRYPTSAFI`(
	/* Encripta un dato de tipo Texto */
	Par_Dato		VARCHAR(250)
) RETURNS blob
    DETERMINISTIC
BEGIN


	DECLARE Var_Resultado		BLOB;
	DECLARE Key_SAFI			VARCHAR(250);

	DECLARE Cadena_Vacia		VARCHAR(2);

	SET Cadena_Vacia := '';
	SET Par_Dato 	 := IFNULL(Par_Dato,Cadena_Vacia);

	SELECT KeyPassword
	INTO Key_SAFI
	FROM PARAMETROSSPEI LIMIT 1;

	SET Var_Resultado := AES_ENCRYPT(Par_Dato,Key_SAFI);

	RETURN Var_Resultado;

END$$