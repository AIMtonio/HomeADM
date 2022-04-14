-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNSUMADIASFECHA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNSUMADIASFECHA`;DELIMITER $$

CREATE FUNCTION `FNSUMADIASFECHA`(
/* FUNCION QUE SUMA EN DÍAS A UNA FECHA DETERMINADA */
	Par_Fecha			DATE,		# Fecha a la cual se le sumaran los días que le llegue por parametro
    Par_NumeroDias		int(11)		# Numero de días a sumar

) RETURNS date
    DETERMINISTIC
BEGIN
	DECLARE Var_Fecha		DATE;

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);			# Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);			# Cadena Vacia
	DECLARE Fecha_Vacia		DATE;				# Fecha Vacia

	-- Asignacion de constates
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';

	SET Var_Fecha := DATE_ADD(IFNULL(Par_Fecha,Fecha_Vacia), INTERVAL IFNULL(Par_NumeroDias, Entero_Cero) DAY);

RETURN Var_Fecha;
END$$