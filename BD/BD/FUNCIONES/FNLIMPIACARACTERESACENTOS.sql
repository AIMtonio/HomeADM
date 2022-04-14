-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNLIMPIACARACTERESACENTOS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNLIMPIACARACTERESACENTOS`;DELIMITER $$

CREATE FUNCTION `FNLIMPIACARACTERESACENTOS`(
-- Funcion para la limpieza de acentos en el proceso de Cinta de Buro de Credito
    Par_Texto           VARCHAR(2000)

) RETURNS varchar(2000) CHARSET latin1
    DETERMINISTIC
BEGIN
-- Declaracion de Constantes
DECLARE ConAcentos          VARCHAR(200);
DECLARE SinAcentos          VARCHAR(200);
DECLARE Var_Longitud        INT(11);
DECLARE Entero_Cero         INT(11);
DECLARE Entero_Uno          INT(11);
DECLARE Var_Resultado       VARCHAR(2000);
DECLARE SaltoLinea          VARCHAR(2);
-- Asignacion de constantes
SET ConAcentos          := 'ŠšŽžÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÒÓÔÕÖØÙÚÛÜÝŸÞàáâãäåæçèéêëìíîïòóôõöøùúûüýÿþƒ';
SET SinAcentos          := 'SsZzAAAAAAACEEEEIIIIOOOOOOUUUUYYBaaaaaaaceeeeiiiioooooouuuuyybf';
SET Var_Longitud        := LENGTH(ConAcentos);
SET Entero_Cero         := 0;
SET Entero_Uno          := 1;
SET SaltoLinea          := '\n';

WHILE Var_Longitud > Entero_Cero DO
    SET Par_Texto := REPLACE(Par_Texto, SUBSTRING(ConAcentos, Var_Longitud, Entero_Uno), SUBSTRING(SinAcentos, Var_Longitud, Entero_Uno));
    SET Var_Longitud := Var_Longitud - Entero_Uno;
END WHILE;

SET Var_Resultado := REPLACE(Par_Texto,SaltoLinea,' ');

RETURN Var_Resultado;
END$$