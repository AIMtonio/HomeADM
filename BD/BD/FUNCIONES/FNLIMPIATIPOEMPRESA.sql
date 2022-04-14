
-- FNLIMPIATIPOEMPRESA

DELIMITER ;

DROP FUNCTION IF EXISTS `FNLIMPIATIPOEMPRESA`;

DELIMITER $$

CREATE FUNCTION `FNLIMPIATIPOEMPRESA`(
	-- FUNCION QUE LIMPIA EL TIPO DE EMPRESA
	Par_Texto 			VARCHAR(3000) 		-- Texto a limpiar
) RETURNS VARCHAR(3000) CHARSET latin1
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_Resultado 		VARCHAR(3000);	-- Texto resultado final

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);		-- Cadena vacia
	DECLARE Entero_Cero			INT(11);		-- Entero cero

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;

	SET Par_Texto := UPPER(Par_Texto);
	SET Par_Texto := REPLACE(Par_Texto, ' S.C. DE A.P. DE R.L. DE C.V. S. C.', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ' SA DE CV S.A. DE C.V.', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ' SRL DE CV SRL DE CV', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ' S. DE R.L. DE CV', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ' S DE RL DE CV', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ' SPR DE RL DE CV', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ' SPR DE RL', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ' S.C.', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ' SPR', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ' A. C.', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ', S.A.', Cadena_Vacia);
    SET Par_Texto := REPLACE(Par_Texto, ' S.A.', Cadena_Vacia);
    SET Par_Texto := REPLACE(Par_Texto, ' S C', Cadena_Vacia);
	SET Par_Texto := REPLACE(Par_Texto, ' A C', Cadena_Vacia);

	SET Var_Resultado := Par_Texto;

	RETURN Var_Resultado;

END$$