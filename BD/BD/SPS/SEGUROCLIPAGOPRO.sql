-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIPAGOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROCLIPAGOPRO`;DELIMITER $$

CREATE PROCEDURE `SEGUROCLIPAGOPRO`(

	Par_ClienteID			bigint,
	Par_NumeroMov			bigint,
	Par_CantidadMov			decimal(12,2),
	Par_MonedaID			int,

	Par_AltaEncPoliza		char(1),
	Par_SucursalID			int(2),
	inout Par_Poliza		bigint(20),
	Par_AltaDetPol			char(1),
	Par_CajaID				int(11),
	Par_UsuarioID			int(11),
	Par_SeguroClienteID		int(11),

	Par_Salida				char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
)
TerminaStore:BEGIN


DECLARE Var_MontoPolizaSegA		decimal(14,2);
DECLARE Var_MontoSegPagado		decimal(14,2);
DECLARE Var_ReferDetPol			varchar(20);
DECLARE Var_FechaOper			date;
DECLARE Var_FechaApl			date;
DECLARE Var_EsHabil				char(1);
DECLARE Var_SucCliente			int(5);


DECLARE SalidaNO				char(1);
DECLARE Var_NO					char(1);
DECLARE SalidaSI				char(1);
DECLARE descrpcionMov			varchar(100);
DECLARE ConContaPagoSegVida		int;
DECLARE ConceptosCaja			int;
DECLARE ConceptosCajaCan		int;
DECLARE ConceptosCajaApli		int;
DECLARE Nat_Cargo				char(1);
DECLARE Nat_Abono				char(1);
DECLARE Entero_Cero				int;
DECLARE Act_Siniestro			int;
DECLARE Cadena_Vacia			char;
DECLARE Decimal_Cero			decimal;
DECLARE Pago					char(1);
DECLARE ConContaCanSegVida		int;
DECLARE ConContaAplSegVida		int;
DECLARE TipoInstrumentoID		int(11);



set Var_NO					:='N';
set SalidaNO				:='N';
set SalidaSI				:='S';
set descrpcionMov			:='PAGO SEGURO VIDA AYUDA';
Set ConContaPagoSegVida		:=403;
Set ConContaCanSegVida		:=408;
Set ConContaAplSegVida		:=409;
set ConceptosCaja			:=2;
set ConceptosCajaCan		:=6;
set ConceptosCajaApli		:=7;
set Nat_Cargo				:='C';
set Nat_Abono				:='A';
set Entero_Cero				:=0;
set Act_Siniestro			:=2;
set Cadena_Vacia			:='';
set Decimal_Cero			:=0.0;
set Pago					:='P';
set TipoInstrumentoID		:=4;

ManejoErrores:BEGIN


DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-SEGUROCLIENTEPRO");
    END;

set Par_NumErr  	:= Entero_Cero;
set Par_ErrMen  	:= Cadena_Vacia;
set Aud_FechaActual := now();

select FechaSistema	into Var_FechaOper
		from PARAMETROSSIS;

select  Cli.SucursalOrigen  into Var_SucCliente
	from  CLIENTES Cli
	where Cli.ClienteID   = Par_ClienteID;

select MontoSeguro, MontoSegPagado into Var_MontoPolizaSegA, Var_MontoSegPagado
	from SEGUROCLIENTE
	where ClienteID=Par_ClienteID
		and SeguroClienteID=Par_SeguroClienteID;

 set Var_MontoPolizaSegA := ifnull(Var_MontoPolizaSegA,Decimal_Cero);


call DIASFESTIVOSCAL(
		Var_FechaOper,		Entero_Cero,		Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);



if(Par_CantidadMov <> Var_MontoPolizaSegA)then
	set Par_NumErr := 1;
	set Par_ErrMen := "El Monto del pago excede el monto de la poliza del seguro de Ayuda.";
	LEAVE ManejoErrores;
end if;

if(Par_SeguroClienteID <= Entero_Cero)then
	set Par_NumErr := 2;
	set Par_ErrMen := "El Numero de poliza esta vacio";
	LEAVE ManejoErrores;
end if;

if(Par_ClienteID <= Entero_Cero)then
	set Par_NumErr := 3;
	set Par_ErrMen := "El Numero de socio esta vacio";
	LEAVE ManejoErrores;
end if;

if(Par_CantidadMov <= Decimal_Cero)then
	set Par_NumErr := 4;
	set Par_ErrMen := "La Cantidad del movimiento esta vacio";
	LEAVE ManejoErrores;
end if;



call SEGUROCLIMOVALT
			(Par_SeguroClienteID,Par_ClienteID,	Par_CantidadMov,Pago,			Par_SucursalID,
			Par_CajaID,			Var_FechaOper,	Par_UsuarioID,	descrpcionMov,	Par_NumeroMov,
			Par_MonedaID,		SalidaNO,		Par_NumErr,		Par_ErrMen,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

	if (Par_NumErr <> Entero_Cero)then
		LEAVE ManejoErrores;
	end if;


	call SEGUROCLIENTEACT(
			Par_SeguroClienteID,	Par_ClienteID,	Par_CantidadMov,	Act_Siniestro,	Entero_Cero,
			descrpcionMov,		Cadena_Vacia,	SalidaNO,			Par_NumErr,	Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);
	if (Par_NumErr <> Entero_Cero)then
		LEAVE ManejoErrores;
	end if;



	set Var_ReferDetPol 	:= convert(Par_ClienteID, char);



CALL CONTACAJAPRO(
	Par_NumeroMov,		Var_FechaApl,		Var_MontoSegPagado,	descrpcionMov,		Par_MonedaID,
	Var_SucCliente,		Par_AltaEncPoliza,	ConContaPagoSegVida,Par_Poliza,			Par_AltaDetPol,
	ConceptosCaja,		Nat_Cargo,			Var_ReferDetPol,	Var_ReferDetPol,	Entero_Cero,
	TipoInstrumentoID,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion);


CALL CONTACAJAPRO(
	Par_NumeroMov,		Var_FechaApl,		Var_MontoSegPagado,	descrpcionMov,		Par_MonedaID,
	Var_SucCliente,		Var_NO,				ConContaCanSegVida,	Par_Poliza,			Par_AltaDetPol,
	ConceptosCajaCan,	Nat_Abono,			Var_ReferDetPol,	Var_ReferDetPol,	Entero_Cero,
	TipoInstrumentoID,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion);


CALL CONTACAJAPRO(
	Par_NumeroMov,		Var_FechaApl,		Par_CantidadMov,	descrpcionMov,		Par_MonedaID,
	Var_SucCliente,		Var_NO,				ConContaAplSegVida,	Par_Poliza,			Par_AltaDetPol,
	ConceptosCajaApli,	Nat_Cargo,			Var_ReferDetPol,	Var_ReferDetPol,	Entero_Cero,
	TipoInstrumentoID,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion);


set Par_NumErr := Entero_Cero;
set Par_ErrMen := "Seguro de Vida Ayuda Pagado Exitosamente.";

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'operacionID' as control,
			Par_Poliza as consecutivo;
end if;

END TerminaStore$$