-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONMASIVACAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONMASIVACAL`;DELIMITER $$

CREATE PROCEDURE `INVERSIONMASIVACAL`(
	Par_Fecha			date	,
	Par_Empresa			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
BEGIN


DECLARE Var_FechaPosible	date;
DECLARE Var_Fecha			date;
DECLARE Var_FechaRegreso	date;
DECLARE Es_DiaHabil		char(1);


DECLARE	Cero_DiaHabil		int;



DECLARE  Cur1  CURSOR FOR
 	SELECT FechaPosibleVencimiento
		FROM TEMINVERSIONES
		group by FechaPosibleVencimiento;


Set	Cero_DiaHabil		:= 0;

Open  Cur1;

BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	Loop
		Fetch Cur1 Into Var_FechaPosible;

		Set Var_Fecha := Var_FechaPosible;
		Set Var_FechaRegreso := '1900-01-01';

		call DIASFESTIVOSCAL(
			Var_FechaPosible,		Cero_DiaHabil,	Var_FechaRegreso,		Es_DiaHabil,		Par_Empresa,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

		update	TEMINVERSIONES set
			FechaVencimiento = Var_FechaRegreso
			where FechaPosibleVencimiento = Var_Fecha;

	End Loop;
END;

Close Cur1;

END$$