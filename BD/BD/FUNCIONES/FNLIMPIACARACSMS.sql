-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNLIMPIACARACSMS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNLIMPIACARACSMS`;
DELIMITER $$

CREATE FUNCTION `FNLIMPIACARACSMS`(
	-- Funcion para limpiar los acentos y caracteres de n antes de darlos de alta en SMSENVIOMENSAJE
	Par_Texto 			VARCHAR(160), 	-- Texto del SMS a limpiar
	Par_TipoResultado	CHAR(2)			-- OR.- Mantiene texto original MA.- El resultado lo pasa en Mayusculas MI.- El resultado lo pasa en Minusculas
) RETURNS varchar(160) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion de Variables
	DECLARE Var_Longitud		INT(11);		-- Longitud de cadenas
	DECLARE Var_Resultado 		VARCHAR(160);	-- Texto resultado final

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);		-- Cadena vacia
	DECLARE Entero_Cero			INT(11);		-- Entero cero
	DECLARE Entero_Uno			INT(11);		-- Entero uno
	DECLARE ConAcentos 			VARCHAR(200); 	-- Caracteres con acentos
	DECLARE SinAcentos 			VARCHAR(200); 	-- Caracteres con acentos
	DECLARE CaractEspeciales	VARCHAR(200); 	-- Caracteres con acentos
	DECLARE SaltoLinea			VARCHAR(2); 	-- Salto de Linea
	DECLARE TextoOriginal		VARCHAR(2); 	-- Mantiene texto original
	DECLARE TextoMayusculas		VARCHAR(2); 	-- Convierte texto a mayusculas
	DECLARE TextoMinusculas		VARCHAR(2); 	-- Convierte texto a minusculas
	DECLARE UnEspacio			VARCHAR(1); 	-- Un espacio
	DECLARE DobleEspacio		VARCHAR(2); 	-- Doble espacio

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';																					-- Cadena vacia
	SET Entero_Cero			:= 0;																					-- Entero cero
	SET Entero_Uno			:= 1;																					-- Entero uno
	SET ConAcentos 			:= 'ŠšŽžÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÒÓÔÕÖØÙÚÛÜÝŸÞàáâãäåæçèéêëìíîïòóôõöøùúûüýÿþƒ';					-- Caracteres con acentos
	SET SinAcentos 			:= 'SsZzAAAAAAACEEEEIIIIOOOOOOUUUUYYBaaaaaaaceeeeiiiioooooouuuuyybf';					-- Caracteres sin acentos
	SET CaractEspeciales	:= '!¡@#%¨&*()«—»_––+=§¹²³£¢¬""`´{[^~}]<>‘’‚“”„;¿?°ºª+*|\\''¤¥¦©®¯±µ¶·¸¼½¾†‡•…‰€™';	-- Caracteres especiales
	SET SaltoLinea			:= '\n';																				-- Salto de Linea
	SET TextoOriginal		:= 'OR';																				-- Mantiene texto original
	SET TextoMayusculas		:= 'MA';																				-- Convierte texo a mayusculas
	SET TextoMinusculas		:= 'MI';																				-- Convierte texto a minusculas
	SET UnEspacio			:= ' ';																					-- Un espacio
	SET DobleEspacio		:= '  ';																				-- Doble espacio

	SET Par_TipoResultado := UPPER(Par_TipoResultado);

	-- Limpia el texto de acentos
	SET Var_Longitud := LENGTH(ConAcentos);
	WHILE Var_Longitud > Entero_Cero DO
		SET Par_Texto := REPLACE(Par_Texto, SUBSTRING(ConAcentos, Var_Longitud, Entero_Uno), SUBSTRING(SinAcentos, Var_Longitud, Entero_Uno));
		SET Var_Longitud := Var_Longitud - Entero_Uno;
	END WHILE;

	-- Limpia el texto de caracteres especiales
	SET Var_Longitud := LENGTH(CaractEspeciales);
	WHILE Var_Longitud > Entero_Cero DO
		SET Par_Texto := REPLACE(Par_Texto, SUBSTRING(CaractEspeciales, Var_Longitud, Entero_Uno), Cadena_Vacia);
		SET Var_Longitud := Var_Longitud - Entero_Uno;
	END WHILE;

	SET Var_Resultado := REPLACE(Par_Texto,SaltoLinea,' ');

	-- Da formato al texto limpio
	IF(IFNULL(Par_TipoResultado,Cadena_Vacia)=TextoMayusculas)THEN
		SET Var_Resultado := TRIM(UPPER(Var_Resultado));
	END IF;

	IF(IFNULL(Par_TipoResultado,Cadena_Vacia)=TextoMinusculas)THEN
		SET Var_Resultado := TRIM(LOWER(Var_Resultado));
	END IF;

	-- Se limpia de espacios dobles y triples por un solo espacio
	SET Var_Resultado := REPLACE(Var_Resultado, DobleEspacio, UnEspacio);
	SET Var_Resultado := REPLACE(Var_Resultado, DobleEspacio, UnEspacio);

	RETURN Var_Resultado;
END$$