-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONMESNOMBRE
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONMESNOMBRE`;DELIMITER $$

CREATE FUNCTION `FUNCIONMESNOMBRE`(
	Par_Fecha  DATE
) RETURNS char(100) CHARSET latin1
    DETERMINISTIC
BEGIN
	DECLARE	Mes				int (2);
	DECLARE MesNombre		char(20);

	SET Mes		=	MONTH(Par_Fecha);

	SET MesNombre	=
			CASE
				WHEN Mes = 1	THEN 'Enero'
				WHEN Mes = 2	THEN 'Febrero'
				WHEN Mes = 3	THEN 'Marzo'
				WHEN Mes = 4	THEN 'Abril'
				WHEN Mes = 5	THEN 'Mayo'
				WHEN Mes = 6	THEN 'Junio'
				WHEN Mes = 7	THEN 'Julio'
				WHEN Mes = 8	THEN 'Agosto'
				WHEN Mes = 9	THEN 'Septiembre'
				WHEN Mes = 10	THEN 'Octubre'
				WHEN Mes = 11	THEN 'Noviembre'
				WHEN Mes = 12	THEN'Diciembre'
			END;


RETURN MesNombre;
END$$