DELIMITER ;
DROP FUNCTION IF EXISTS FUNCIONDIAHABILINV;

DELIMITER $$
CREATE FUNCTION `FUNCIONDIAHABILINV`(
	Par_Fecha			DATE,
	Par_NumDias			INT,
	Par_EmpresaID			INT
) RETURNS DATE
    DETERMINISTIC
BEGIN

DECLARE	Dias_Habil		INT;
DECLARE	Dias_Contador	INT;
DECLARE	FechaOriginal	DATE;

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia	DATE;
DECLARE	Entero_Cero	INT;

SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia	:= '1900-01-01';
SET	Entero_Cero	:= 0;


SET FechaOriginal = Par_Fecha;

SET Dias_Habil = IFNULL(Par_NumDias, Entero_Cero);
SET Dias_Contador = Entero_Cero;


IF (SELECT IFNULL(COUNT(*),Entero_Cero)
					FROM DIASFESTIVOS
					WHERE Fecha = Par_Fecha) > 0 THEN
	SET Dias_Habil = 1;
END IF;

IF DAYOFWEEK(Par_Fecha) = 1 THEN
	SET Dias_Habil = 1;
END IF;

IF (Par_NumDias>=0) THEN

WHILE Dias_Habil > Dias_Contador DO

	SET	Par_Fecha	= ADDDATE(Par_Fecha, 1);


	IF (SELECT IFNULL(COUNT(*),Entero_Cero)
		FROM DIASFESTIVOS
		WHERE Fecha = Par_Fecha) = 0  AND
		DAYOFWEEK(Par_Fecha) <> 1  THEN

		SET Dias_Contador = Dias_Contador + 1;
	END IF;

END WHILE;

ELSE

WHILE Dias_Habil > Dias_Contador DO

	SET	Par_Fecha	= DATE_SUB(Par_Fecha, INTERVAL 1 DAY);


	IF (SELECT IFNULL(COUNT(*),Entero_Cero)
		FROM DIASFESTIVOS
		WHERE Fecha = Par_Fecha) = 0  AND
		DAYOFWEEK(Par_Fecha) <> 1    THEN

		SET Dias_Contador = Dias_Contador + 1;
	END IF;

END WHILE;
END IF;

RETURN Par_Fecha;

END$$