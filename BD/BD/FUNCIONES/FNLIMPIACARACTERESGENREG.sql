-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNLIMPIACARACTERESGENREG
DELIMITER ;
DROP FUNCTION IF EXISTS `FNLIMPIACARACTERESGENREG`;DELIMITER $$

CREATE FUNCTION `FNLIMPIACARACTERESGENREG`(
/* FUNCION GENERICA QUE LIMPIA CUALQUIER TEXTO QUE CONTENGA ACENTOS, CARACTERES ESPECIALES Y SIGNOS DE PUNTUACION
   PARA LOS REPORTES REGULATORIOS*/
    Par_Texto           VARCHAR(2000),      -- Texto a limpiar
    Par_TipoResultado   CHAR(2)             -- OR.- Mantiene texto original MA.- El resultado lo pasa en Mayusculas MI.- El resultado lo pasa en Minusculas

) RETURNS varchar(2000) CHARSET latin1
    DETERMINISTIC
BEGIN

-- Declaracion de Variables
DECLARE Var_Longitud        INT(11);        -- Longitud de cadenas
DECLARE Var_Resultado       VARCHAR(2000);  -- Texto resultado final

-- Declaracion de Constantes
DECLARE Cadena_Vacia        CHAR(1);        -- Cadena Vacia
DECLARE Entero_Cero         INT(11);        -- Valor cero para Enteros
DECLARE Entero_Uno          INT(11);
DECLARE ConAcentos          VARCHAR(200);   -- Cadena con Acentos
DECLARE SinAcentos          VARCHAR(200);   -- Cadena sin Acentos
DECLARE CaractEspeciales    VARCHAR(200);   -- Cadena caracteres Especiales
DECLARE SaltoLinea          VARCHAR(2);     -- Salto de Linea
DECLARE TextoOriginal       VARCHAR(2);     -- Texto original
DECLARE TextoMayusculas     VARCHAR(2);     -- Texto en Mayusculas
DECLARE TextoMinusculas     VARCHAR(2);     -- Texto en Minusculas
DECLARE UnEspacio           VARCHAR(1);     -- Espacio
DECLARE DobleEspacio        VARCHAR(2);     -- Espacio Doble

-- Asignacion de Constantes
SET Cadena_Vacia        := '';          -- Cadena Vacia
SET Entero_Cero         := 0;           -- Valor vacion para enteros
SET Entero_Uno          := 1;           -- valor uno
SET ConAcentos          := 'ŠšŽžÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÒÓÔÕÖØÙÚÛÜÝŸÞàáâãäåæçèéêëìíîïòóôõöøùúûüýÿþƒ';
SET SinAcentos          := 'SsZzAAAAAAACEEEEIIIIOOOOOOUUUUYYBaaaaaaaceeeeiiiioooooouuuuyybf';
SET CaractEspeciales    := '!¡@#$%¨*()«—»_––-+=§¹²³£¢¬""`´{[^~}]<>.,‘’‚“”„:;¿?/°ºª+*|\\''¤¥¦©®¯±µ¶·¸¼½¾†‡•…‰€™';
SET SaltoLinea          := '\n';
SET TextoOriginal       := 'OR';
SET TextoMayusculas     := 'MA';
SET TextoMinusculas     := 'MI';
SET UnEspacio           := ' ';
SET DobleEspacio        := '  ';

SET Par_TipoResultado := IFNULL(Par_TipoResultado,Cadena_Vacia);

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

-- Da formato al texto a Mayusculas
IF(Par_TipoResultado = TextoMayusculas)THEN
    SET Var_Resultado := TRIM(UPPER(Var_Resultado));
END IF;

-- Da formato al texto a Minusculas
IF(Par_TipoResultado = TextoMinusculas)THEN
    SET Var_Resultado := TRIM(LOWER(Var_Resultado));
END IF;

-- Da formato al texto Normal
IF(Par_TipoResultado = TextoOriginal)THEN
    SET Var_Resultado := TRIM(Var_Resultado);
END IF;

-- Se limpia de espacios dobles y triples por un solo espacio
SET Var_Resultado := REPLACE(Var_Resultado, DobleEspacio, UnEspacio);
SET Var_Resultado := REPLACE(Var_Resultado, DobleEspacio, UnEspacio);

RETURN Var_Resultado;

END$$