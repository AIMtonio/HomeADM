-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASHABILANTERCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASHABILANTERCAL`;DELIMITER $$

CREATE PROCEDURE `DIASHABILANTERCAL`(
	Par_Fecha			date,
	Par_NumDias			int,
	out Par_SalidaFecha	date,
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
)
BEGIN





DECLARE	Dias_Habil		int;
DECLARE	Dias_Contador		int;
DECLARE	FechaOriginal		date;

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia	date;
DECLARE	Entero_Cero	int;
DECLARE	Si_DiaHabil	char(1);
DECLARE	No_DiaHabil	char(1);


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia	:= '1900-01-01';
Set	Entero_Cero	:= 0;
Set	Si_DiaHabil	:= 'S';
Set	No_DiaHabil	:= 'N';

SET FechaOriginal = Par_Fecha;
SET Dias_Habil = ifnull(Par_NumDias, Entero_Cero);
SET Dias_Contador = Entero_Cero;


if (select ifnull(count(*),Entero_Cero)
					from DIASFESTIVOS
					where Fecha = Par_Fecha) > 0 then
	SET Dias_Habil = 1;
end if;

if DAYOFWEEK(Par_Fecha) = 1 or DAYOFWEEK(Par_Fecha) = 7 then
	SET Dias_Habil = 1;
end if;


if (Par_NumDias>=0) then

WHILE Dias_Habil > Dias_Contador DO

	SET	Par_Fecha	= ADDDATE(Par_Fecha, -1);


	IF (SELECT ifnull(count(*),Entero_Cero)
		from DIASFESTIVOS
		where Fecha = Par_Fecha) = 0  AND
		DAYOFWEEK(Par_Fecha) <> 1  AND
		DAYOFWEEK(Par_Fecha) <> 7 THEN

		SET Dias_Contador = Dias_Contador + 1;
	END IF;

END WHILE;

else

WHILE Dias_Habil > Dias_Contador DO

	SET	Par_Fecha	= DATE_SUB(Par_Fecha, INTERVAL 1 DAY);


	IF (SELECT ifnull(count(*),Entero_Cero)
		from DIASFESTIVOS
		where Fecha = Par_Fecha) = 0  AND
		DAYOFWEEK(Par_Fecha) <> 1  AND
		DAYOFWEEK(Par_Fecha) <> 7  THEN

		SET Dias_Contador = Dias_Contador + 1;
	END IF;

END WHILE;
END IF;


set Par_SalidaFecha := Par_Fecha;
END$$