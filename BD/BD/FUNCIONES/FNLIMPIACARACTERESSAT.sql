-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNLIMPIACARACTERESSAT
DELIMITER ;
DROP FUNCTION IF EXISTS `FNLIMPIACARACTERESSAT`;DELIMITER $$

CREATE FUNCTION `FNLIMPIACARACTERESSAT`(
/* FUNCION GENERICA QUE LIMPIA CUALQUIER LOS CARACTERES ESPECIALES PARA REPORTES ANTE EL SAT*/
	Par_Texto 			VARCHAR(2000) 		-- Texto a limpiar

) RETURNS varchar(2000) CHARSET latin1
    DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_Resultado 		VARCHAR(2000);	-- Texto resultado final

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);		-- Cadena Vacia

	DECLARE Con_Ampersa			CHAR(1);		-- Constante Ampersa
	DECLARE Con_SignoMenor		CHAR(1);		-- Constante Signo Menor
	DECLARE Con_SignoMayor		CHAR(1);		-- Constante Signo Mayor
	DECLARE Con_ComillaSimple	CHAR(1);		-- Constante Comilla Simple
	DECLARE Con_ComillaDoble	CHAR(1);		-- Constante Comilla Doble

	DECLARE Con_CadAmpersa			CHAR(6);	-- Constante a sustituir Ampersa
	DECLARE Con_CadSignoMenor		CHAR(6);	-- Constante a sustituir Signo Menor
	DECLARE Con_CadSignoMayor		CHAR(6);	-- Constante a sustituir Signo Mayor
	DECLARE Con_CadComillaSimple	CHAR(6);	-- Constante a sustituir Comilla Simple
	DECLARE Con_CadComillaDoble		CHAR(6);	-- Constante a sustituir Comilla Doble

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';			-- Cadena Vacia

	SET Con_Ampersa			:= '&';
	SET Con_SignoMenor		:= '<';
	SET Con_SignoMayor		:= '>';
	SET Con_ComillaSimple	:= "'";
	SET Con_ComillaDoble	:= '"';

	SET Con_CadAmpersa			:= '&amp;';
	SET Con_CadSignoMenor		:= '&lt;';
	SET Con_CadSignoMayor		:= '&gt;';
	SET Con_CadComillaSimple	:= '&apos;';
	SET Con_CadComillaDoble		:= '&quot;';

	SET Par_Texto 			:= IFNULL(Par_Texto,Cadena_Vacia);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_Ampersa,		Con_CadAmpersa);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_SignoMenor,	Con_CadSignoMenor);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_SignoMayor,	Con_CadSignoMayor);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_ComillaSimple,Con_CadComillaSimple);
	SET Par_Texto 			:= REPLACE(Par_Texto, Con_ComillaDoble,	Con_CadComillaDoble);

	SET Var_Resultado := Par_Texto;

	RETURN Var_Resultado;

END$$