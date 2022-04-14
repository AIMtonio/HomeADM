-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVKUBOCIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVKUBOCIEDIAPRO`;
DELIMITER $$


CREATE PROCEDURE `INVKUBOCIEDIAPRO`(
	Par_Fecha			date,
	Par_EmpresaID			int,

inout	Par_NumErr			int(11),
inout	Par_ErrMen			varchar(100),
inout	Par_Consecutivo		bigint,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)

TerminaStore: BEGIN


DECLARE	Var_FechaBatch	date;
DECLARE	Var_FecBitaco 	datetime;
DECLARE	Var_MinutosBit 	int;


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE	Pro_CieInvKubo	int;
DECLARE	Pro_GenIntere 	int;
DECLARE	Pro_VencimInv		int;
DECLARE	Pro_TraspaExi		int;
DECLARE	Pro_CalSaldos		int;
DECLARE	SalidaNo			char(1);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero		:= 0.00;

Set	Pro_CieInvKubo 	:= 300;
Set	Pro_GenIntere		:= 301;
Set	Pro_VencimInv 	:= 302;
Set	Pro_TraspaExi 	:= 303;
Set	Pro_CalSaldos 	:= 304;

Set	SalidaNo			:= 'N';
set	Aud_ProgramaID	:= 'INVKUBOCIEDIAPRO';

set	Var_FecBitaco	:= now();

select Fecha into Var_FechaBatch
	from BITACORABATCH
	where Fecha 			= Par_Fecha
	  and ProcesoBatchID	= Pro_CieInvKubo;

set Var_FechaBatch := ifnull(Var_FechaBatch, Fecha_Vacia);


if Var_FechaBatch != Fecha_Vacia then
	LEAVE TerminaStore;
end if;

set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());

call BITACORABATCHALT(
	Pro_CieInvKubo, 	Par_Fecha, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

set Var_FecBitaco = now();


call FONKUBOVENCIMPRO(
	Par_Fecha,		Par_EmpresaID,	Par_NumErr,		Par_ErrMen,		Par_Consecutivo,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
	Aud_NumTransaccion	);

set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());

call BITACORABATCHALT(
	Pro_VencimInv, 	Par_Fecha, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

set Var_FecBitaco = now();


call FONKUBOTRASEXIPRO(
	Par_Fecha,		Par_EmpresaID,	Par_NumErr,		Par_ErrMen,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
	Aud_NumTransaccion	);

set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());

call BITACORABATCHALT(
	Pro_TraspaExi, 	Par_Fecha, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

set Var_FecBitaco = now();


call GENERAINTEREINVPRO(
	Par_Fecha,		Par_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion	);

set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());

call BITACORABATCHALT(
	Pro_GenIntere, 	Par_Fecha, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);






call INVKUBOCALSALDPRO(
	SalidaNo,		Par_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion	);

set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());


call BITACORABATCHALT(
	Pro_CalSaldos, 	Par_Fecha, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);


END TerminaStore$$