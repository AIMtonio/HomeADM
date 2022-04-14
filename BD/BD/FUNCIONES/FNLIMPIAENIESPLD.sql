
-- FNLIMPIAENIESPLD --

DELIMITER ;
DROP FUNCTION IF EXISTS `FNLIMPIAENIESPLD`;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE FUNCTION `FNLIMPIAENIESPLD`(
/** FUNCION QUE LIMPIA CUALQUIER TEXTO QUE CONTENGA EÑES DEPENDIENDO
 ** SI EL PARÁMETRO SE ENCUENTRA ENCENDIDO.*/
	Par_Texto 			VARCHAR(3000)		-- Texto a limpiar
) RETURNS varchar(3000) CHARSET latin1
	DETERMINISTIC
BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Resultado 		VARCHAR(3000);	-- TEXTO RESULTADO FINAL
DECLARE Var_LimpiaEniesPLD	CHAR(1);		-- PARÁMETRO QUE INDICA SI LIMPIA DE EÑES O NO.

-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia 		CHAR(1);
DECLARE Entero_Cero			INT(11);
DECLARE Entero_Uno			INT(11);
DECLARE Str_SI		 		CHAR(1);
DECLARE Str_NO		 		CHAR(1);

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia		:= '';			-- CADENA VACIA.
SET Entero_Cero			:= 0;			-- ENTERO CERO.
SET Entero_Uno			:= 1;			-- ENTERO UNO.
SET Str_SI				:= 'S';			-- CONSTANTE SI.
SET Str_NO				:= 'N';			-- CONSTANTE NO.
SET Var_Resultado		:= IFNULL(Par_Texto,Cadena_Vacia);

# SE CONSULTA SI EL PARÁMETRO SE ENCUENTRA HABILITADO.
SET Var_LimpiaEniesPLD := LEFT(FNPARAMGENERALES('LimpiaEniesPLD'),1);
# SI NO EXISTE SE LE SETEA VALOR DEFAULT DE NO.
SET Var_LimpiaEniesPLD := IF(TRIM(Var_LimpiaEniesPLD) != Cadena_Vacia,Var_LimpiaEniesPLD,Str_NO);

# SI ESTA HABILITADO
IF(Var_LimpiaEniesPLD = Str_SI)THEN
	SET Var_Resultado := REPLACE(Var_Resultado,'Ñ','N');
	SET Var_Resultado := REPLACE(Var_Resultado,'ñ','n');
END IF;

RETURN Var_Resultado;

END$$


