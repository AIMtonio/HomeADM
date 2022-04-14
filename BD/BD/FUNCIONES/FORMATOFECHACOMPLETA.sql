-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FORMATOFECHACOMPLETA
DELIMITER ;
DROP FUNCTION IF EXISTS `FORMATOFECHACOMPLETA`;DELIMITER $$

CREATE FUNCTION `FORMATOFECHACOMPLETA`(
 Par_Fecha DATE

) RETURNS varchar(20) CHARSET latin1
    DETERMINISTIC
BEGIN


DECLARE Str_FechaFormato VARCHAR(20);
DECLARE Num_Mes    INT;
DECLARE Var_NombreMes  VARCHAR(20);


SET Par_Fecha := IFNULL(Par_Fecha, '1900-01-01');
SET Str_FechaFormato := DATE_FORMAT(Par_Fecha, '%d');
SET Num_Mes := DATE_FORMAT(Par_Fecha, '%m');

SELECT CASE WHEN Num_Mes = 1 THEN 'Enero'
   WHEN Num_Mes = 2 THEN 'Febrero'
   WHEN Num_Mes = 3 THEN 'Marzo'
   WHEN Num_Mes = 4 THEN 'Abril'
   WHEN Num_Mes = 5 THEN 'Mayo'
   WHEN Num_Mes = 6 THEN 'Junio'
   WHEN Num_Mes = 7 THEN 'Julio'
   WHEN Num_Mes = 8 THEN 'Agosto'
   WHEN Num_Mes = 9 THEN 'Septiembre'
   WHEN Num_Mes = 10 THEN 'Octubre'
   WHEN Num_Mes = 11 THEN 'Noviembre'
   WHEN Num_Mes = 12 THEN 'Diciembre'
  END INTO Var_NombreMes;


SET Str_FechaFormato := CONCAT(Str_FechaFormato, '/', Var_NombreMes, '/', convert(YEAR(Par_Fecha),CHAR));

RETURN Str_FechaFormato;

END$$