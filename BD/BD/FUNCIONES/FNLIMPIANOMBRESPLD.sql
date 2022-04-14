

DELIMITER ;
DROP FUNCTION IF EXISTS FNLIMPIANOMBRESPLD;

DELIMITER $$
CREATE FUNCTION `FNLIMPIANOMBRESPLD`(
/** FUNCION QUE LIMPIA TEXTO QUE CONTENGA EÑES Y SIMBOLOS ESPECIALES DEPENDIENDO
 ** SI LOS PARÁMETROS SE ENCUENTRAN ENCENDIDOS.*/
	Par_Texto 			VARCHAR(3000)		-- Texto a limpiar
) RETURNS varchar(3000) CHARSET latin1
    DETERMINISTIC
BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Resultado 		VARCHAR(3000);	-- TEXTO RESULTADO FINAL
DECLARE Var_LimpiaNombPLD	CHAR(1);		-- PARÁMETRO QUE INDICA SI LIMPIA DE EÑES O NO.

-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia 		CHAR(1);
DECLARE Entero_Cero			INT(11);
DECLARE Entero_Uno			INT(11);
DECLARE Str_SI		 		CHAR(1);
DECLARE Str_NO		 		CHAR(1);
DECLARE Tipo_LimpiaNO		INT(11);
DECLARE Tipo_LimpiaCE		INT(11);
DECLARE Tipo_LimpiaECE		INT(11);
DECLARE Tipo_LimpiaE		INT(11);

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia		:= '';			-- CADENA VACIA.
SET Entero_Cero			:= 0;			-- ENTERO CERO.
SET Entero_Uno			:= 1;			-- ENTERO UNO.
SET Str_SI				:= 'S';			-- CONSTANTE SI.
SET Str_NO				:= 'N';			-- CONSTANTE NO.
SET Tipo_LimpiaNO		:= 0;			-- NO SE LIMPIA.
SET Tipo_LimpiaCE		:= 1;			-- LIMPIA SOLO CARACTERES ESPECIALES.
SET Tipo_LimpiaECE		:= 2;			-- LIMPIA EÑES Y CARACTERES ESPECIALES.
SET Tipo_LimpiaE		:= 3;			-- LIMPIA SOLO EÑES.
SET Var_Resultado		:= IFNULL(Par_Texto,Cadena_Vacia);

# SE CONSULTA SI EL PARÁMETRO SE ENCUENTRA HABILITADO.
SET Var_LimpiaNombPLD := LEFT(FNPARAMGENERALES('LimpiaNombresPLD'),1);
# SI NO EXISTE SE LE SETEA VALOR DEFAULT DE LIMPIA SOLO CARACTERES ESPECIALES.
SET Var_LimpiaNombPLD := IF(TRIM(Var_LimpiaNombPLD) != Cadena_Vacia,Var_LimpiaNombPLD,Tipo_LimpiaCE);

CASE Var_LimpiaNombPLD
	WHEN Tipo_LimpiaCE THEN
	# LIMPIA SOLO CARACTERES ESPECIALES.
		SET Var_Resultado := FNLIMPIACARACTERESGEN(Var_Resultado,'MA');
	WHEN Tipo_LimpiaECE THEN
	# LIMPIA CARACTERES ESPECIALES Y EÑES SOLO SÍ EL PARÁMETRO ESTA HABILITADO.
		SET Var_Resultado := FNLIMPIACARACTERESGEN(FNLIMPIAENIESPLD(Var_Resultado),'MA');
	WHEN Tipo_LimpiaE THEN
	# LIMPIA SOLO EÑES SOLO SÍ EL PARÁMETRO ESTA HABILITADO.
		SET Var_Resultado := FNLIMPIAENIESPLD(Var_Resultado);
	ELSE
	# SINO, NO SE LIMPIA.
		SET Var_Resultado := Var_Resultado;
END CASE;

RETURN Var_Resultado;

END$$

