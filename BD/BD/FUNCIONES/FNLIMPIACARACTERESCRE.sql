-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNLIMPIACARACTERESCRE
DELIMITER ;
DROP FUNCTION IF EXISTS `FNLIMPIACARACTERESCRE`;
DELIMITER $$

CREATE FUNCTION `FNLIMPIACARACTERESCRE`(
	-- Funcion para limpiar los caracteres de Circulo o Buro de Credito
	Par_Texto 			VARCHAR(2000),				-- Texto
	Par_TipoResultado	CHAR(2)						-- Tipo de Resultado

) RETURNS varchar(2000) CHARSET latin1
DETERMINISTIC
BEGIN
	-- Declaracion de Variables
	DECLARE Var_Resultado 		VARCHAR(2000);		-- Cadena de Resultado

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);			-- Constante Cadena Vacia
	DECLARE Entero_Cero			INT(11);			-- Constante Entero Vacio
	DECLARE Entero_Uno			INT(11);			-- Constante Entero Uno
	DECLARE SaltoLinea			VARCHAR(2);			-- Constante Salto de linea
	DECLARE TextoOriginal		VARCHAR(2);			-- Texto Original
	DECLARE TextoMayusculas		VARCHAR(2);			-- Texto en Mayusculas
	DECLARE TextoMinusculas		VARCHAR(2);			-- Texto en Minusculas
	DECLARE UnEspacio			VARCHAR(1);			-- Espacio
	DECLARE DobleEspacio		VARCHAR(2);			-- Doble espacio

	DECLARE LetraSMayus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetrasMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraZMayus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetrazMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraAMayus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraCMayus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraEMayus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraIMayus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraOMayus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraUMayus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraYMayus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraBMayus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraaMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetracMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraeMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraiMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetraoMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetrauMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetrayMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetrabMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	DECLARE LetrafMinus				CHAR(1);		-- Constante de las Letras que se requiere para remplazar por caracteres especiales

	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET SaltoLinea			:= '\n';

	SET TextoOriginal		:= 'OR';
	SET TextoMayusculas		:= 'MA';
	SET TextoMinusculas		:= 'MI';
	SET UnEspacio			:= ' ';
	SET DobleEspacio		:= '  ';

	SET LetraSMayus			:= "S";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetrasMinus			:= "s";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraZMayus			:= "Z";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetrazMinus			:= "z";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraAMayus			:= "A";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraCMayus			:= "C";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraEMayus			:= "E";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraIMayus			:= "I";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraOMayus			:= "O";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraUMayus			:= "U";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraYMayus			:= "Y";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraBMayus			:= "B";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraaMinus			:= "a";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetracMinus			:= "c";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraeMinus			:= "e";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraiMinus			:= "i";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetraoMinus			:= "o";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetrauMinus			:= "u";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetrayMinus			:= "y";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetrabMinus			:= "b";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales
	SET LetrafMinus			:= "f";			-- Constante de las Letras que se requiere para remplazar por caracteres especiales


	SET Par_TipoResultado := UPPER(Par_TipoResultado);

	SET Par_Texto := REPLACE(Par_Texto, "??", LetraSMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetrasMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraZMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetrazMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraCMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraEMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraEMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraEMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraEMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraIMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraIMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraIMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraIMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraUMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraUMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraUMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraUMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraYMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraYMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraBMayus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetracMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraeMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraeMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraeMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraeMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraiMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraiMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraiMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraiMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetrauMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetrauMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetrauMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetrauMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetrayMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetrayMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetrabMinus );
	SET Par_Texto := REPLACE(Par_Texto, "??", LetrafMinus );

	-- Eliminar Caracteres Especiales
	SET Par_Texto := REPLACE(Par_Texto,"!", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"@", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"#", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"$", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"%", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"&", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"*", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"(", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,")", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"_", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"-", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"+", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"=", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,'"', Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"`", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"{", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"[", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"^", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"~", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"}", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"]", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"<", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,">", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,".", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,",", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,":", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,";", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"?", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"/", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"+", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"*", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"|", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"\\", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"'", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"'", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"??", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"???", Cadena_Vacia );

	SET Var_Resultado := REPLACE(Par_Texto,SaltoLinea,' ');

	IF(IFNULL(Par_TipoResultado,Cadena_Vacia)=TextoMayusculas)THEN
		SET Var_Resultado := TRIM(UPPER(Var_Resultado));
	END IF;

	IF(IFNULL(Par_TipoResultado,Cadena_Vacia)=TextoMinusculas)THEN
		SET Var_Resultado := TRIM(LOWER(Var_Resultado));
	END IF;

	SET Var_Resultado := REPLACE(Var_Resultado, DobleEspacio, UnEspacio);
	SET Var_Resultado := REPLACE(Var_Resultado, DobleEspacio, UnEspacio);

	RETURN Var_Resultado;

END$$