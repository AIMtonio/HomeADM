-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPASHISTORICOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPASHISTORICOPRO`;DELIMITER $$

CREATE PROCEDURE `CREPASHISTORICOPRO`(
	Par_Fecha			date,
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN


DECLARE	Var_FechaSig		date;
DECLARE	Es_DiaHabil		char(1);
DECLARE	Var_FecBitaco 	datetime;
DECLARE	Var_MinutosBit 	int;


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Un_DiaHabil		int;
DECLARE	Pro_PasHistorico	int;



Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Un_DiaHabil		:= 1;
Set	Pro_PasHistorico 	:= 205;



call DIASFESTIVOSCAL(
	Par_Fecha,		Un_DiaHabil,		Var_FechaSig,		Es_DiaHabil,		Par_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
	Aud_NumTransaccion);


if (MONTH(Var_FechaSig) != MONTH(Par_Fecha)) then

	set Var_FecBitaco = now();


	insert into `HIS-DEPPAGOCRE`(
			FechaRegistro,	Transaccion,		Consecutivo,		CreditoID,		ClienteID,
			MontoDeposito,	MontoAplicado,		FechaAplicacion,	NumTraAplica,	EmpresaID,
			Usuario,		FechaActual,		DireccionIP,		ProgramaID,		Sucursal,
			NumTransaccion)
	select	FechaRegistro,	Transaccion,		Consecutivo,		CreditoID,		ClienteID,
			MontoDeposito,	MontoAplicado,		FechaAplicacion,	NumTraAplica,	EmpresaID,
			Usuario,		FechaActual,		DireccionIP,		ProgramaID,		Sucursal,
			NumTransaccion
		from DEPOSITOPAGOCRE;

	truncate DEPOSITOPAGOCRE;

	set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());

	call BITACORABATCHALT(
		Pro_PasHistorico,	Par_Fecha, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

end if;


END TerminaStore$$