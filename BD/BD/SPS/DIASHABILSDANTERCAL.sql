-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASHABILSDANTERCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASHABILSDANTERCAL`;DELIMITER $$

CREATE PROCEDURE `DIASHABILSDANTERCAL`(
# ========================================================
# ------ SP PARA CONSIDERAR DIAS INHABILES: SABADO -------
# ========================================================
	Par_Fecha			DATE,
	Par_NumDias			INT(11),
	OUT Par_SalidaFecha	DATE,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
BEGIN
	-- 	Declaracion de constantes
	DECLARE	Dias_Habil		INT(11);
	DECLARE	Dias_Contador	INT(11);
	DECLARE	FechaOriginal	DATE;
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Si_DiaHabil		CHAR(1);
	DECLARE	No_DiaHabil		CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Si_DiaHabil			:= 'S';
	SET	No_DiaHabil			:= 'N';

	SET FechaOriginal 	:= Par_Fecha;
	SET Dias_Habil		:= IFNULL(Par_NumDias, Entero_Cero);
	SET Dias_Contador 	:= Entero_Cero;


	IF (SELECT IFNULL(COUNT(*),Entero_Cero)
						FROM 	DIASFESTIVOS
						WHERE 	Fecha = Par_Fecha) > 0 THEN
		SET Dias_Habil = 1;
	END IF;

	IF (DAYOFWEEK(Par_Fecha) = 1 OR DAYOFWEEK(Par_Fecha) = 7) THEN
		SET Dias_Habil = 1;
	END IF;


	IF (Par_NumDias>=0) THEN

		WHILE Dias_Habil > Dias_Contador DO

			SET	Par_Fecha	= ADDDATE(Par_Fecha, -1);

			IF (SELECT IFNULL(COUNT(*),Entero_Cero)
					FROM 	DIASFESTIVOS
					WHERE 	Fecha 	= Par_Fecha) = 0  AND
				DAYOFWEEK(Par_Fecha) <> 1  AND
				DAYOFWEEK(Par_Fecha) <> 7 THEN

				SET Dias_Contador = Dias_Contador + 1;
			END IF;
		END WHILE;

	ELSE

		WHILE Dias_Habil > Dias_Contador DO

			SET	Par_Fecha	= DATE_SUB(Par_Fecha, INTERVAL 1 DAY);


			IF (SELECT IFNULL(COUNT(*),Entero_Cero)
					FROM DIASFESTIVOS
					WHERE Fecha = Par_Fecha) = 0  AND
				DAYOFWEEK(Par_Fecha) <> 1  AND
				DAYOFWEEK(Par_Fecha) <> 7  THEN

				SET Dias_Contador = Dias_Contador + 1;
			END IF;
		END WHILE;
	END IF;


	SET Par_SalidaFecha := Par_Fecha;
END$$