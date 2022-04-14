-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANCIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVBANCIEDIAPRO`;
DELIMITER $$


CREATE PROCEDURE `INVBANCIEDIAPRO`(


	Par_Fecha			date,
	Par_EmpresaID		int,
	Par_Salida			char(1),
	inout Par_NumErr	int(11),
	inout Par_ErrMen	varchar(400),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,

	Aud_NumTransaccion	bigint

)

TerminaStore: BEGIN

	DECLARE Var_FechaBatch	date;
	DECLARE Var_FecBitaco	datetime;
	DECLARE Var_MinutosBit	int;
	DECLARE	Sig_DiaHab			date;
	DECLARE Var_EsHabil			char(1);
	DECLARE	Fec_Calculo			date;


	DECLARE Cadena_Vacia	char(1);
	DECLARE Fecha_Vacia		date;
	DECLARE Entero_Cero		int;
	DECLARE Par_SalidaNO	char(1);

	DECLARE Pro_CiDiInvBan	int;
	DECLARE Pro_DevInvBan	int;
	DECLARE Pro_VenInvBan	int;


	Set Cadena_Vacia	:= '';
	Set Fecha_Vacia		:= '1900-01-01';
	Set Entero_Cero		:= 0;
	Set Par_SalidaNO	:= 'N';

	Set Pro_CiDiInvBan	:= 600;
	Set Pro_DevInvBan	:= 601;
	Set Pro_VenInvBan	:= 602;

	set Var_FecBitaco	:= now();
	Set Aud_FechaActual	:= now();

	select Fecha into Var_FechaBatch
		from BITACORABATCH
		where Fecha 			= Par_Fecha
			and ProcesoBatchID	= Pro_CiDiInvBan;

	set Var_FechaBatch := ifnull(Var_FechaBatch, Fecha_Vacia);

	if Var_FechaBatch != Fecha_Vacia then
		LEAVE TerminaStore;
	end if;


	set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());
	call BITACORABATCHALT(
		Pro_CiDiInvBan,		Par_Fecha,			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	set Var_FecBitaco = now();

	call DIASFESTIVOSCAL(
		Par_Fecha,				1,						Sig_DiaHab,				Var_EsHabil,			Par_EmpresaID,
		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion);

	set Fec_Calculo := Par_Fecha;

	WHILE (Fec_Calculo < Sig_DiaHab) DO
		set Var_FecBitaco = now();
		set Aud_FechaActual	:= now();
		call INVBANDEVINTPRO(
			Fec_Calculo,	Par_EmpresaID,		Par_SalidaNO,			Par_NumErr,		 Par_ErrMen,
			Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	 Aud_Sucursal,
			Aud_NumTransaccion	);
		set Var_MinutosBit	:= TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());
		set Aud_FechaActual	:= now();

		call BITACORABATCHALT(
			Pro_DevInvBan, 		Fec_Calculo,		Var_MinutosBit,	Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		SET	Fec_Calculo	= ADDDATE(Fec_Calculo, 1);
	END WHILE;



	set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());
	set Var_FecBitaco = now();

	call INVBANVENCIMPRO(
		Par_Fecha,		Par_EmpresaID,		Par_SalidaNO,			Par_NumErr,			 Par_ErrMen,
		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	 	Aud_Sucursal,
		Aud_NumTransaccion	);

	set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());

	call BITACORABATCHALT(
		Pro_VenInvBan,		Par_Fecha,			Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

END TerminaStore$$