-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FORMATEAFECHACONTRATO
DELIMITER ;
DROP FUNCTION IF EXISTS `FORMATEAFECHACONTRATO`;DELIMITER $$

CREATE FUNCTION `FORMATEAFECHACONTRATO`(
	Par_Fecha	DATE

) RETURNS varchar(100) CHARSET latin1
    DETERMINISTIC
BEGIN


DECLARE Num_Dia				INT;
DECLARE Num_Mes				INT;
DECLARE Num_anio			INT;
DECLARE Fecha_Completa		VARCHAR(100);
DECLARE Var_NombreMes		VARCHAR(20);


SET	Par_Fecha	:= IFNULL(Par_Fecha, '1900-01-01');
SET Num_Dia := DATE_FORMAT(Par_Fecha, '%d');
SET Num_Mes := DATE_FORMAT(Par_Fecha, '%m');
SET Num_anio := DATE_FORMAT(Par_Fecha, '%Y');

SELECT CASE WHEN Num_Mes = 1 THEN 'ENERO'
			WHEN Num_Mes = 2 THEN 'FEBRERO'
			WHEN Num_Mes = 3 THEN 'MARZO'
			WHEN Num_Mes = 4 THEN 'ABRIL'
			WHEN Num_Mes = 5 THEN 'MAYO'
			WHEN Num_Mes = 6 THEN 'JUNIO'
			WHEN Num_Mes = 7 THEN 'JULIO'
			WHEN Num_Mes = 8 THEN 'AGOSTO'
			WHEN Num_Mes = 9 THEN 'SEPTIEMBRE'
			WHEN Num_Mes = 10 THEN 'OCTUBRE'
			WHEN Num_Mes = 11 THEN 'NOVIEMBRE'
			WHEN Num_Mes = 12 THEN 'DICIEMBRE'
	 END INTO Var_NombreMes;


SET Fecha_Completa := CONCAT(Num_Dia, ' DE ', Var_NombreMes, ' DEL ', Num_anio);

RETURN Fecha_Completa;

END$$