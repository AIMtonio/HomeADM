-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASHABILFESTIVOSCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASHABILFESTIVOSCAL`;
DELIMITER $$


CREATE PROCEDURE `DIASHABILFESTIVOSCAL`(
-- SP PARA CONSIDERAR LOS DIAS FESTIVOS Y HABILES O SOLO LOS DIAS HABILES
	Par_Fecha			DATE,		-- FECHA
	Par_NumDias			INT(11),	-- DIAS
	Par_TipoCalculo		VARCHAR(2),	-- TIPO CALCULO DH.-SOLO DIAS HABILES, DF.-DIAS FESTIVOS Y HABILES
    OUT Par_SalidaFecha	DATE,		-- FECHA
	OUT Es_DiaHabil		CHAR(1),	-- DIA HABIL
    
    Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
)

BEGIN


-- DECLARACION DE VARIABLES
DECLARE	Dias_Habil		INT(11);
DECLARE	Dias_Contador	INT(11);
DECLARE	FechaOriginal	DATE;

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Si_DiaHabil		CHAR(1);
	DECLARE	No_DiaHabil		CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Si_DiaHabil			:= 'S';
	SET	No_DiaHabil			:= 'N';


	SET FechaOriginal = Par_Fecha;
	SET Dias_Habil = IFNULL(Par_NumDias, Entero_Cero);
	SET Dias_Contador = Entero_Cero;
    
    IF(Par_TipoCalculo = "DH" AND Par_NumDias>=0)THEN
		-- VALIDAMOS SI ES SABADO SUMAMOS DOS DIAS
        IF(DAYOFWEEK(Par_Fecha) = 7)THEN
			SET	Par_Fecha	= ADDDATE(Par_Fecha, 2);
        END IF;
        -- VALIDAMOS SI ES DOMINGO SUMAMOS 1 DIA
        IF(DAYOFWEEK(Par_Fecha) = 1)THEN
			SET	Par_Fecha	= ADDDATE(Par_Fecha, 1);
        END IF;
	ELSE
		-- VALIDAMOS SI ES SABADO RESTAMOS UN DIAS
		 IF(DAYOFWEEK(Par_Fecha) = 7)THEN
			SET	Par_Fecha	= DATE_SUB(Par_Fecha, INTERVAL 1 DAY);
        END IF;
        -- VALIDAMOS SI ES DOMINGO RESTAMOS DOS DIAS
        IF(DAYOFWEEK(Par_Fecha) = 1)THEN
			SET	Par_Fecha	= DATE_SUB(Par_Fecha, INTERVAL 2 DAY);
        END IF;
    END IF;
    
	IF(Par_TipoCalculo = "DF") THEN
		IF(SELECT IFNULL(COUNT(*),Entero_Cero)
							FROM DIASFESTIVOS
							WHERE Fecha = Par_Fecha) > 0 THEN
			SET Dias_Habil = 1;
		END IF;

		IF DAYOFWEEK(Par_Fecha) = 1  OR DAYOFWEEK(Par_Fecha) = 7  THEN
			SET Dias_Habil = 1;
		END IF;

		IF (Par_NumDias>=0) then
			WHILE Dias_Habil > Dias_Contador DO
				SET	Par_Fecha	= ADDDATE(Par_Fecha, 1);
				IF (SELECT ifnull(count(*),Entero_Cero)
					FROM DIASFESTIVOS
					WHERE Fecha = Par_Fecha) = 0  AND
					DAYOFWEEK(Par_Fecha) <> 1  AND
					DAYOFWEEK(Par_Fecha) <> 7  THEN

					SET Dias_Contador = Dias_Contador + 1;
				END IF;
			END WHILE;
		ELSE
			WHILE Dias_Habil > Dias_Contador DO

				SET	Par_Fecha	= DATE_SUB(Par_Fecha, INTERVAL 1 DAY);

				IF (SELECT ifnull(count(*),Entero_Cero)
					FROM DIASFESTIVOS
					WHERE Fecha = Par_Fecha) = 0  AND
					DAYOFWEEK(Par_Fecha) <> 1  AND
					DAYOFWEEK(Par_Fecha) <> 7  THEN

					SET Dias_Contador = Dias_Contador + 1;
				END IF;
			END WHILE;
		END IF;

	END IF;   
    
    -- VALIDACIONES DE PARAMETROS DE SALIDA
    
    IF DATEDIFF(Par_Fecha, FechaOriginal)  = Par_NumDias THEN
		SET Es_DiaHabil := Si_DiaHabil;
	ELSE
		SET Es_DiaHabil := No_DiaHabil;
	END IF;
	
	SET Par_SalidaFecha := Par_Fecha;
    
		
END$$