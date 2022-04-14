-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ATMRECEPTRANSFPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ATMRECEPTRANSFPRO`;DELIMITER $$

CREATE PROCEDURE `ATMRECEPTRANSFPRO`(
	Par_CajeroTransfID		int(11),


	Par_Salida				char(1),
	inout Par_NumErr    	int,
    inout Par_ErrMen    	varchar(400),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint


	)
TerminaStore:BEGIN


DECLARE Var_CajeroOrigenID		varchar(20);
DECLARE Var_CajeroDestinoID		varchar(20);
DECLARE Var_Cantidad			decimal(14,2);
DECLARE	Var_MonedaID 			int(11);
DECLARE Var_Poliza				bigint(11);
DECLARE Var_FechaSistema		date;
DECLARE Var_Estatus				char(1);


DECLARE AltaEncPolizaSI			CHAR(1);
DECLARE AltaDetPolizaSI			char(1);
DECLARE NatContaAbono			char(1);
DECLARE AfectacionEnFirme		char(1);
DECLARE AfectacionTransito		char(1);
DECLARE AfectaSaldoCajeroSI		char(1);
DECLARE EstatusRecibido			char(1);
DECLARE DescripcionMov			varchar(100);
DECLARE DescripcionMovCargo		varchar(100);
DECLARE ConceptoContable		int;
DECLARE SalidaNO				char(1);
DECLARE SalidaSI				char(1);
DECLARE NatAbono				char(1);
DECLARE Cadena_Vacia			char(1);
DECLARE Entero_Cero				int;
DECLARE Decimal_Cero			decimal;
DECLARE TipoInstrumentoID		int(11);
DECLARE Cadena_Cero				char(1);


set AltaEncPolizaSI		:='S';
set AltaDetPolizaSI		:='S';
set NatContaAbono		:='A' ;
set AfectacionEnFirme	:='F';
set AfectacionTransito	:='T';
set AfectaSaldoCajeroSI	:='S';
set DescripcionMov		:='RECEPCION EFECTIVO ATM';
set DescripcionMovCargo	:='TRANSFERENCIA ATM';
set EstatusRecibido		:='R';
set ConceptoContable	:=601;
set SalidaNO			:='N';
set SalidaSI			:='S';
set NatAbono			:='A';
set Cadena_Vacia		:='';
set Entero_Cero			:=0;
set Decimal_Cero		:=0.0;
set TipoInstrumentoID	:= 10;
set Cadena_Cero			:='0';

ManejoErrores:BEGIN

set Aud_FechaActual		:=now();

set Var_FechaSistema	:=(select FechaSistema
							from PARAMETROSSIS
							limit 1);


select CajeroOrigenID,CajeroDestinoID,Cantidad,MonedaID, Estatus
		into Var_CajeroOrigenID,Var_CajeroDestinoID,Var_Cantidad,Var_MonedaID,Var_Estatus
		from CAJEROATMTRANSF
		where CajeroTransfID	= Par_CajeroTransfID;

set Var_CajeroOrigenID	:=ifnull(Var_CajeroOrigenID,Cadena_Vacia);
set Var_CajeroDestinoID	:=ifnull(Var_CajeroDestinoID,Cadena_Vacia);
set Var_Cantidad		:=ifnull(Var_Cantidad,Decimal_Cero);
set Var_MonedaID		:=ifnull(Var_MonedaID,Entero_Cero);
set Var_Estatus			:=ifnull(Var_Estatus,Cadena_Vacia);


if(Var_CajeroDestinoID = Cadena_Vacia)then
		set Par_NumErr	:=1;
		set Par_ErrMen	:='El Cajero Destino esta vacio';
		LEAVE ManejoErrores;
end if;
if(Var_Cantidad = Decimal_Cero)then
		set Par_NumErr	:=2;
		set Par_ErrMen	:='La cantidad de la Transferencia se encuentra vacia';
		LEAVE ManejoErrores;
end if;

if (Var_Estatus =EstatusRecibido )then
		set Par_NumErr	:=3;
		set Par_ErrMen	:='La Transferencia ya fue realizada';
		LEAVE ManejoErrores;
end if;


call CONTAATMPRO (
		Var_CajeroDestinoID,Var_Cantidad,		DescripcionMov,	Var_MonedaID,		AltaEncPolizaSI,
		AltaDetPolizaSI,	ConceptoContable,	NatContaAbono,	Var_CajeroOrigenID,	Var_CajeroDestinoID,
		AfectacionTransito, AfectaSaldoCajeroSI,NatAbono,		Var_FechaSistema, 	TipoInstrumentoID,
		Cadena_Cero,		Var_Poliza,			SalidaNO,			Par_NumErr,		Par_ErrMen,
		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

if(Par_NumErr <>Entero_Cero )then
		LEAVE ManejoErrores;
end if;


call POLIZAATMPRO(
		Var_CajeroDestinoID,Var_Poliza,		Var_FechaSistema,	Var_CajeroDestinoID,Var_MonedaID,
		Var_Cantidad,		Entero_Cero,	DescripcionMovCargo,Par_CajeroTransfID,	AfectacionEnFirme,
		TipoInstrumentoID,  Cadena_Cero,		SalidaNO,		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

if(Par_NumErr <>Entero_Cero )then
		LEAVE ManejoErrores;
end if;


update CAJEROATMTRANSF set
		Estatus	= EstatusRecibido
	where CajeroTransfID =	Par_CajeroTransfID;

	set Par_NumErr	:= 0;
	set Par_ErrMen	:='Recepcion de Efectivo Realizado Correctamente';
END ManejoErrores;

if (Par_Salida = SalidaSI) then
		select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            'folioTransaccion' as control,
            Var_Poliza as consecutivo;
	end if;

END TerminaStore$$