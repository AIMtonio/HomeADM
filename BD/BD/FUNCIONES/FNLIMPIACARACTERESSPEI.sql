-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNLIMPIACARACTERESSPEI
DELIMITER ;
DROP FUNCTION IF EXISTS `FNLIMPIACARACTERESSPEI`;DELIMITER $$

CREATE FUNCTION `FNLIMPIACARACTERESSPEI`(
  -- Funcion para limpiar caracteres con acentos o especiales en las operaciones SPEI
  Par_Texto       VARCHAR(250)	-- Texto a Limpiar

) RETURNS varchar(250) CHARSET latin1
    DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_Longitud    	INT(11);    			-- Longitud de la cadena
	DECLARE Var_Resultado     	VARCHAR(2000); 			-- Variable de Salida

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT(11);
	DECLARE Entero_Uno      	INT(11);
	DECLARE ConAcentos      	VARCHAR(200);
	DECLARE SinAcentos      	VARCHAR(200);
	DECLARE CaractEspeciales  	VARCHAR(200);
	DECLARE SaltoLinea      	VARCHAR(2);
	DECLARE DobleEspacio    	VARCHAR(2);

	-- Asignacion de Constantes
	SET Cadena_Vacia    	:= '';						-- Cosntante Vacia
	SET Entero_Cero     	:= 0;						-- Constante cero
	SET Entero_Uno      	:= 1;						-- Constante uno
	SET ConAcentos      	:= 'ŠšŽžÀAÂÃÄÅÆÇÈEÊËÌIÎÏÒOÔÕÖØÙUÛÜÝŸÞàaâãäåæçèeêëìiîïòoôõöøùuûüýÿþƒnN';	-- Caracteres con acentos
	SET SinAcentos      	:= 'SsZzAAAAAAACEEEEIIIIOOOOOOUUUUYYBaaaaaaaceeeeiiiioooooouuuuyybfnN';	-- Caracteres a sustituir
	SET CaractEspeciales	:= '.';																	-- Caracter especial
	SET SaltoLinea      	:= '\n';					-- Salto de Linea
	SET DobleEspacio    	:= '  ';					-- Doble espacio

	-- Seccion para remplazar los caracteres con acentos
	SET Var_Longitud := LENGTH(ConAcentos);
	WHILE Var_Longitud > Entero_Cero DO
		SET Par_Texto := REPLACE(Par_Texto, SUBSTRING(ConAcentos, Var_Longitud, Entero_Uno), SUBSTRING(SinAcentos, Var_Longitud, Entero_Uno));
		SET Var_Longitud := Var_Longitud - Entero_Uno;
	END WHILE;

	-- Seccion para remplazar los caracteres especiales
	SET Var_Longitud := LENGTH(CaractEspeciales);
	WHILE Var_Longitud > Entero_Cero DO
		SET Par_Texto := REPLACE(Par_Texto, SUBSTRING(CaractEspeciales, Var_Longitud, Entero_Uno), Cadena_Vacia);
		SET Var_Longitud := Var_Longitud - Entero_Uno;
	END WHILE;

	-- Asignacion a la variable de salida
	SET Var_Resultado := REPLACE(Par_Texto,SaltoLinea,' ');

	SET Var_Resultado := REPLACE(Var_Resultado, DobleEspacio, Cadena_Vacia);

	RETURN Var_Resultado;

END$$