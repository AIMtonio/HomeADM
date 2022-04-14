-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VENTANILLACIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `VENTANILLACIEDIAPRO`;
DELIMITER $$


CREATE PROCEDURE `VENTANILLACIEDIAPRO`(

	Par_Fecha			date,
	Par_Salida			char(1),
	inout	Par_NumErr	int,
	inout	Par_ErrMen	varchar(400),

	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

)

TerminaStore: BEGIN


DECLARE Var_FechaBatch		date;
DECLARE Var_FecBitaco		datetime;
DECLARE Var_MinutosBit		int;
DECLARE Var_FecActual		date;
DECLARE Var_IntNumErr		int;
DECLARE Var_Control			varchar(100);

DECLARE Cadena_Vacia		char(1);
DECLARE Fecha_Vacia			date;
DECLARE Entero_Cero			int;
DECLARE Pro_CieVentan		int;
DECLARE Pro_PasoHistor		int;
DECLARE Var_SI				char(1);
DECLARE Salida_SI			char(1);
DECLARE Salida_NO			char(1);
DECLARE Es_DiaHabil			char(1);
DECLARE Pro_VenSegVid		int;
DECLARE Un_DiaHabil			int;
DECLARE Var_VencimAutoSeg	char(1);


Set Cadena_Vacia    		:= '';
Set Fecha_Vacia     		:= '1900-01-01';
Set Entero_Cero     		:= 0;
Set Pro_CieVentan   		:= 700;
Set Pro_PasoHistor  		:= 701;
Set Salida_NO    			:= 'N';
Set Salida_SI    			:= 'S';
Set Var_SI					:= 'S';
set Aud_ProgramaID			:= 'VENTANILLACIEDIAPRO';
set Var_FecBitaco			:= now();
Set Pro_VenSegVid 			:= 1000;
Set Un_DiaHabil 			:= 1;

Select VencimAutoSeg
	into Var_VencimAutoSeg
	from PARAMETROSSIS;

Set Var_VencimAutoSeg := ifnull(Var_VencimAutoSeg,Salida_NO);

Select Fecha into Var_FechaBatch
	from BITACORABATCH
	where Fecha 		= Par_Fecha
	and ProcesoBatchID	= Pro_CieVentan;

Set Var_FechaBatch := ifnull(Var_FechaBatch, Fecha_Vacia);

if Var_FechaBatch != Fecha_Vacia then
	LEAVE TerminaStore;
end if;

Set Aud_FechaActual:=now();
Set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());

call BITACORABATCHALT(
	Pro_CieVentan,      Par_Fecha, 			Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion);

Set Var_FecBitaco = now();

INSERT INTO `HIS-DENOMMOVS`	(
			FechaCorte,				SucursalID,				CajaID,					Fecha,					Transaccion,
			Naturaleza,				DenominacionID,			Cantidad,				Monto,					MonedaID,
			EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion)
    Select  Par_Fecha,      SucursalID,     CajaID,         Fecha,          Transaccion,
            Naturaleza,     DenominacionID, Cantidad,       Monto,          MonedaID,
            EmpresaID,      Usuario,        FechaActual,    DireccionIP,    ProgramaID,
            Sucursal,       NumTransaccion
        from DENOMINACIONMOVS Den
        where Den.Fecha <= Par_Fecha;

delete from DENOMINACIONMOVS
    where Fecha <= Par_Fecha;


INSERT INTO `HIS-BALANZADENO`	(
			Fecha,					SucursalID,				CajaID,				DenominacionID,				MonedaID,
			Cantidad,				EmpresaID,				Usuario,			FechaActual,				DireccionIP,
			ProgramaID,				Sucursal,				NumTransaccion)
    select  Par_Fecha,  SucursalID, CajaID,     DenominacionID, MonedaID,
            Cantidad,   EmpresaID,  Usuario,    FechaActual,    DireccionIP,
            ProgramaID, Sucursal,   NumTransaccion
        from BALANZADENOM;


INSERT INTO `HIS-CAJASMOVS`	(
			FechaCorte,				SucursalID,				CajaID,					Fecha,					Transaccion,
			Consecutivo,			MonedaID,				MontoEnFirme,			MontoSBC,				TipoOperacion,
			Instrumento,			Referencia,				Comision,				IVAComision,			EmpresaID,
			Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
			NumTransaccion)
    select  Par_Fecha,      SucursalID,     CajaID,         Fecha,          Transaccion,
            Consecutivo,    MonedaID,       MontoEnFirme,   MontoSBC,       TipoOperacion,
            Instrumento,    Referencia,     Comision,       IVAComision,    EmpresaID,
            Usuario,        FechaActual,    DireccionIP,    ProgramaID,     Sucursal,
            NumTransaccion
        from CAJASMOVS
        where Fecha <= Par_Fecha;

delete from CAJASMOVS
    where Fecha <= Par_Fecha;


INSERT INTO `HIS-CAJASTRANSFER`	(
			FechaCorte,				CajasTransferID,			SucursalOrigen,			SucursalDestino,			Fecha,
			DenominacionID,			Cantidad,					CajaOrigen,				CajaDestino,				Estatus,
			MonedaID,				PolizaID,					EmpresaID,				Usuario,					FechaActual,
			DireccionIP,			ProgramaID,					Sucursal,				NumTransaccion)
    select  Par_Fecha,      CajasTransferID,    SucursalOrigen, SucursalDestino,    Fecha,
            DenominacionID, Cantidad,           CajaOrigen,     CajaDestino,        Estatus,
            MonedaID,       PolizaID,           EmpresaID,      Usuario,            FechaActual,
            DireccionIP,    ProgramaID,         Sucursal,       NumTransaccion
    from CAJASTRANSFER
    where Fecha <= Par_Fecha;

delete from CAJASTRANSFER
    where Fecha <= Par_Fecha;


INSERT INTO `HIS-TRANSFERBANCO`	(
			FechaCorte,			TransferBancoID,	InstitucionID,			NumCtaInstit,			SucursalID,
			CajaID,				MonedaID,			Cantidad,				PolizaID,				DenominacionID,
			Estatus,			Fecha,				Referencia,				EmpresaID,				Usuario,
			FechaActual,		DireccionIP,		ProgramaID,				Sucursal,				NumTransaccion)
    select  Par_Fecha,      TransferBancoID,    InstitucionID,  NumCtaInstit,   SucursalID,
            CajaID,         MonedaID,           Cantidad,       PolizaID,       DenominacionID,
            Estatus,        Fecha,              Referencia,     EmpresaID,      Usuario,
            FechaActual,    DireccionIP,        ProgramaID,     Sucursal,       NumTransaccion
        from TRANSFERBANCO
        where Fecha <= Par_Fecha;

delete from TRANSFERBANCO
    where Fecha <= Par_Fecha;


 truncate table REIMPRESIONTICKET;

set Aud_FechaActual:=now();
set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());

call BITACORABATCHALT(
	Pro_PasoHistor,     Par_Fecha, 			Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion);

set	Var_FecBitaco	:= now();

call DIASFESTIVOSCAL(
			Par_Fecha,			Un_DiaHabil,		Var_FecActual,		Es_DiaHabil,	Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

set	Var_FecActual	:= ifnull(Var_FecActual, Entero_Cero);
set Par_NumErr		:= ifnull(Par_NumErr, Entero_Cero);

if(Var_VencimAutoSeg = Var_SI) then

call `SEGCLIVENGENPRO`(
				Entero_Cero,	Aud_Usuario,	Var_FecActual,		Salida_NO,			Par_NumErr,
				Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
				);

	if( Par_NumErr != Entero_Cero)then
		if( Par_Salida = Salida_SI) then
			select 	Par_NumErr as NumErr,
					concat (convert(Par_ErrMen, char),' En el SP SEGCLIVENGENPRO') as ErrMen,
					'Fecha'	as control;
		end if;
		LEAVE TerminaStore;
	end if;
	set Aud_FechaActual:=now();
	set Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());
	call BITACORABATCHALT(
		Pro_VenSegVid, 		Par_Fecha, 			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
end if;
END TerminaStore$$
