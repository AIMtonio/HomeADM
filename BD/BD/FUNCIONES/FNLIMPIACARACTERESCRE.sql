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

	SET Par_Texto := REPLACE(Par_Texto, "Š", LetraSMayus );
	SET Par_Texto := REPLACE(Par_Texto, "š", LetrasMinus );
	SET Par_Texto := REPLACE(Par_Texto, "Ž", LetraZMayus );
	SET Par_Texto := REPLACE(Par_Texto, "ž", LetrazMinus );
	SET Par_Texto := REPLACE(Par_Texto, "À", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Á", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Â", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ã", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ä", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Å", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Æ", LetraAMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ç", LetraCMayus );
	SET Par_Texto := REPLACE(Par_Texto, "È", LetraEMayus );
	SET Par_Texto := REPLACE(Par_Texto, "É", LetraEMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ê", LetraEMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ë", LetraEMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ì", LetraIMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Í", LetraIMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Î", LetraIMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ï", LetraIMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ò", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ó", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ô", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Õ", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ö", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ø", LetraOMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ù", LetraUMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ú", LetraUMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Û", LetraUMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ü", LetraUMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ý", LetraYMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Ÿ", LetraYMayus );
	SET Par_Texto := REPLACE(Par_Texto, "Þ", LetraBMayus );
	SET Par_Texto := REPLACE(Par_Texto, "à", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "á", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "â", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ã", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ä", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "å", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "æ", LetraaMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ç", LetracMinus );
	SET Par_Texto := REPLACE(Par_Texto, "è", LetraeMinus );
	SET Par_Texto := REPLACE(Par_Texto, "é", LetraeMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ê", LetraeMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ë", LetraeMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ì", LetraiMinus );
	SET Par_Texto := REPLACE(Par_Texto, "í", LetraiMinus );
	SET Par_Texto := REPLACE(Par_Texto, "î", LetraiMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ï", LetraiMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ò", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ó", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ô", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "õ", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ö", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ø", LetraoMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ù", LetrauMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ú", LetrauMinus );
	SET Par_Texto := REPLACE(Par_Texto, "û", LetrauMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ü", LetrauMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ý", LetrayMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ÿ", LetrayMinus );
	SET Par_Texto := REPLACE(Par_Texto, "þ", LetrabMinus );
	SET Par_Texto := REPLACE(Par_Texto, "ƒ", LetrafMinus );

	-- Eliminar Caracteres Especiales
	SET Par_Texto := REPLACE(Par_Texto,"!", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¡", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"@", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"#", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"$", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"%", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¨", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"&", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"*", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"(", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,")", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"«", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"—", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"»", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"_", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"–", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"-", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"+", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"=", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"§", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¹", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"²", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"³", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"£", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¢", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¬", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,'"', Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"`", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"´", Cadena_Vacia );
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
	SET Par_Texto := REPLACE(Par_Texto,"‘", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"’", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"‚", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"“", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"”", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"„", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,":", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,";", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¿", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"?", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"/", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"°", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"º", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"ª", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"+", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"*", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"|", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"\\", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"'", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"'", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¤", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¥", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¦", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"©", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"®", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¯", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"±", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"µ", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¶", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"·", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¸", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¼", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"½", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"¾", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"†", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"‡", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"•", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"…", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"‰", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"€", Cadena_Vacia );
	SET Par_Texto := REPLACE(Par_Texto,"™", Cadena_Vacia );

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