DELIMITER ;
DROP FUNCTION IF EXISTS FNSUMDIASHABIL;

DELIMITER $$
CREATE FUNCTION `FNSUMDIASHABIL`(
Par_Fecha		DATE,		# Feecha a la que se le sumaran los días habiles.
Par_Dias		INT(11)		# Numero de días a sumar

) RETURNS date
    DETERMINISTIC
BEGIN
	DECLARE Dias_Habil      int;
	DECLARE Dias_Contador   int;
	DECLARE FechaOriginal   date;
	DECLARE Var_FecSal		DATE;
	DECLARE Var_EsHabil		CHAR(1);

	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Entero_Cero		INT;
	DECLARE Entero_Uno		INT(11);
	
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET FechaOriginal		:= Par_Fecha;
	SET Dias_Habil			:= IFNULL(Par_Dias, Entero_Cero);
	SET Dias_Contador 		:= Entero_Cero;

	# Se suman los dias a la fecha
	SET Par_Fecha := FNSUMADIASFECHA(Par_Fecha,Par_Dias);

	CALL DIASFESTIVOSCAL(
		Par_Fecha,			Entero_Cero,		 Var_FecSal, 		Var_EsHabil,		1,
		1,					NOW(),				'127.0.0.1',		'FNSUMDIASHABIL',	1,
		1);
	
	RETURN Var_FecSal;
END$$
