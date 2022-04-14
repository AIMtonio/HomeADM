-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNSAFILOCALECTE
DELIMITER ;
DROP FUNCTION IF EXISTS `FNSAFILOCALECTE`;DELIMITER $$

CREATE FUNCTION `FNSAFILOCALECTE`(




) RETURNS varchar(20) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion de Variables
	DECLARE Var_InstitucionID			INT(11);
	DECLARE Var_SafiLocale				VARCHAR(20);
	DECLARE Var_NombreCorto				VARCHAR(20);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Entero_Cero					INT(11);
	DECLARE SCAP_Cliente				VARCHAR(20);
	DECLARE SOFIPO_Cliente				VARCHAR(20);
	DECLARE SOFOM_Cliente				VARCHAR(20);
	DECLARE sofipo						VARCHAR(20);
	DECLARE sofom						VARCHAR(20);
	DECLARE scap						VARCHAR(20);

	SET Cadena_Vacia					:= '';
	SET Entero_Cero						:= 0;
	SET sofipo							:= 'sofipo';
	SET sofom							:= 'sofom';
	SET scap							:= 'scap';
	SET SCAP_Cliente					:= 'Socio';
	SET SOFIPO_Cliente					:= 'Cliente';
	SET SOFOM_Cliente					:= 'Cliente';


	SELECT
		InstitucionID
		INTO
		Var_InstitucionID
		FROM PARAMETROSSIS LIMIT 1;

		SET Var_NombreCorto := (SELECT TIP.NombreCorto FROM
								INSTITUCIONES AS INS INNER JOIN
								TIPOSINSTITUCION AS TIP ON INS.TipoInstitID = TIP.TipoInstitID
								WHERE INS.InstitucionID = Var_InstitucionID);

		IF(Var_NombreCorto = scap) THEN
			SET Var_SafiLocale := SCAP_Cliente;
		ELSE
			SET Var_SafiLocale := SOFIPO_Cliente;
		END IF;
	RETURN Var_SafiLocale;
END$$