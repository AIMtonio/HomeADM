-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJEROATMTRANSFPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJEROATMTRANSFPRO`;DELIMITER $$

CREATE PROCEDURE `CAJEROATMTRANSFPRO`(
	Par_CajeroOrigenID		varchar(20),
	Par_CajeroDestinoID		varchar(20),
	Par_Cantidad			decimal(14,2),
	Par_MonedaID			int(11),
	Par_SucursalID			int(11),

	inout Par_Poliza          bigint(11),
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

DECLARE Var_Poliza				int;
DECLARE Var_Fecha				date;


DECLARE DescripcionMov			varchar(100);
DECLARE AltaEncPolizaNO			char(1);
DECLARE AltaDetPolizaSI			char(1);
DECLARE ConceptoContable		int;
DECLARE NatContaCargo			char(1);
DECLARE AfectacionTransito		char(1);
DECLARE AfectaSaldoCajeroNO		char(1);
DECLARE SalidaNO				char(1);
DECLARE EstatusEnviado			char(1);
DECLARE Entero_Cero				int;
DECLARE SalidaSI				char(1);
DECLARE NatAbono				char(1);
DECLARE TipoInstrumentoID		int(11);
DECLARE Cadena_Cero				char(1);


set DescripcionMov		:='TRANSFERENCIA A CAJERO ATM';
set AltaEncPolizaNO		:='N';
set AltaDetPolizaSI		:='S';
set ConceptoContable	:=600;
set NatContaCargo		:='C' ;
set AfectacionTransito	:='T';
set AfectaSaldoCajeroNO	:='N';
set SalidaNO			:='N';
set EstatusEnviado		:='E';
set Entero_Cero			:=0;
set SalidaSI			:='S';
set NatAbono			:='A';
set TipoInstrumentoID	:= 10;
set Cadena_Cero			:='0';
ManejoErrores:BEGIN

set Var_Fecha	:=(select FechaSistema
					from PARAMETROSSIS
						limit 1);

set Aud_FechaActual		:=now();

call CAJEROATMTRANSFALT(
		Par_CajeroOrigenID,	Par_CajeroDestinoID,Var_Fecha,		Par_Cantidad,	EstatusEnviado,
		Par_MonedaID, 		Par_SucursalID,		SalidaNO,		Par_NumErr,		Par_ErrMen,
		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

if(Par_NumErr <>Entero_Cero )then
		LEAVE ManejoErrores;
end if;



call CONTAATMPRO (
		Par_CajeroDestinoID,Par_Cantidad,		DescripcionMov,	Par_MonedaID,		AltaEncPolizaNO,
		AltaDetPolizaSI,	ConceptoContable,	NatContaCargo,	Par_CajeroOrigenID,	Par_CajeroDestinoID,
		AfectacionTransito, AfectaSaldoCajeroNO,NatAbono,		Var_Fecha, 			TipoInstrumentoID,
		Cadena_Cero,		Par_Poliza,			SalidaNO,			Par_NumErr,		Par_ErrMen,			Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

if(Par_NumErr <>Entero_Cero )then
		LEAVE ManejoErrores;
end if;

	set Par_NumErr	:= 0;
	set Par_ErrMen	:='Envio de Efectivo Realizado Correctamente';

END ManejoErrores;

if (Par_Salida = SalidaSI) then
		select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            'folioTransaccion' as control,
            Par_Poliza as consecutivo;
	end if;

END TerminaStore$$