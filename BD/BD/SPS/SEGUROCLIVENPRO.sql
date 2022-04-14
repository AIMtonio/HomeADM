-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIVENPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROCLIVENPRO`;DELIMITER $$

CREATE PROCEDURE `SEGUROCLIVENPRO`(

	Par_Seguro					bigint,
	Par_ClienteID				bigint,
	Par_NumeroMov				bigint,
	Par_CantidadMov				decimal(12,2),
	Par_MonedaID				int,
	Par_AltaEncPoliza			char(1),

	Par_SucursalID				int(2),
	inout Par_Poliza			bigint,
	Par_AltaDetPol				char(1),
	Par_CajaID					int(11),
	Par_UsuarioID				int(11),

	Par_Salida					char(1),
	inout Par_NumErr			int,
	inout Par_ErrMen			varchar(400),
	Par_EmpresaID				int,
	Aud_Usuario					int,

	Aud_FechaActual				DateTime,
	Aud_DireccionIP				varchar(15),
	Aud_ProgramaID				varchar(50),
	Aud_Sucursal				int,
	Aud_NumTransaccion			bigint
	)
TerminaStore:BEGIN


DECLARE Var_ClienteID			int(11);
DECLARE Var_MontoPolizaSegA		decimal(14,2);
DECLARE Var_MontoSeguroApoyo	decimal(14,2);
DECLARE Var_ReferDetPol			varchar(20);
DECLARE Var_FechaOper			date;
DECLARE Var_FechaApl			date;
DECLARE Var_EsHabil				char(1);
DECLARE Var_SucCliente			int(5);
DECLARE Var_EsMEnorEdad			char(1);
DECLARE Var_SegClienteID		int(11);
DECLARE Var_MontoSegPagadosuma	decimal(14,2);
DECLARE Var_SegClienteIDCiclo	int(11);
DECLARE Var_SeguroClienteID		int(11);
DECLARE Var_MontoSegPagado		decimal(14,2);


DECLARE SalidaNO				char(1);
DECLARE SalidaSI				char(1);
DECLARE descrpcionMov			varchar(100);
DECLARE ConContaVenSegVida		int;
DECLARE ConceptosCajaAbono		int;
DECLARE ConceptosCajaCargo		int;
DECLARE NatAbono				char(1);
DECLARE NatCargo				char(1);
DECLARE Entero_Cero				int;
DECLARE Act_Vigente				int;
DECLARE Act_Vencido				int;
DECLARE Cadena_Vacia			char;
DECLARE Decimal_Cero			decimal;
DECLARE Si						char(1);
DECLARE Contador				int;
DECLARE Est_Inactivo			char(1);
DECLARE Est_Vigente				char(1);
DECLARE Est_Vencido				char(1);
DECLARE Con_AltaEncPol_No		char(1);
DECLARE TipoInstrumentoID		int(11);
DECLARE MotivoCanAut			int(11);


set SalidaNO					:='N';
set SalidaSI					:='S';
set descrpcionMov				:='VENCIMIENTO SEGURO VIDA AYUDA';
Set ConContaVenSegVida			:=407;
set ConceptosCajaAbono			:=5;
set ConceptosCajaCargo			:=2;
set NatAbono					:='A';
set NatCargo					:='C';
set Entero_Cero					:=0;
set Act_Vigente					:=1;
set Cadena_Vacia				:='';
set Decimal_Cero				:=0.0;
set Est_Vencido					:= 'B';
set Si							:='S';
set Contador					:=1;
set Est_Inactivo				:='I';
set Est_Vigente					:='V';
set Act_Vencido					:=3;
set Con_AltaEncPol_No			:='N';
set TipoInstrumentoID			:=4;
set MotivoCanAut				:=88;
ManejoErrores:BEGIN

 DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-SEGUROCLIVENPRO");
    END;

set Par_NumErr  	:= Entero_Cero;
set Par_ErrMen  	:= Cadena_Vacia;
set Aud_FechaActual := now();

select   FechaSistema, MontoPolizaSegA,    MontoSegAyuda
	into Var_FechaOper,Var_MontoPolizaSegA,Var_MontoSeguroApoyo
	from PARAMETROSSIS;


set Var_MontoSeguroApoyo:=ifnull(Var_MontoSeguroApoyo,Decimal_Cero);

select  Cli.SucursalOrigen,Cli.EsMenorEdad
	into Var_SucCliente,Var_EsMEnorEdad
	from  CLIENTES Cli
	where Cli.ClienteID = Par_ClienteID;

set Var_ClienteID		:=ifnull(Var_ClienteID,Entero_Cero);
set Var_EsMEnorEdad		:=ifnull(Var_EsMEnorEdad,Cadena_Vacia);





set Var_FechaApl := Var_FechaOper;

if(Var_EsMEnorEdad = Si)then
	set Par_NumErr := 1;
	set Par_ErrMen := "La persona es un Socio Menor. No se puede realizar esta Operacion";
	LEAVE ManejoErrores;
end if;

set Var_SeguroClienteID := ifnull(Par_Seguro,Entero_Cero);
set Var_MontoSegPagado 	:= (select MontoSegPagado from SEGUROCLIENTE where SeguroClienteID = Par_Seguro);
set Var_MontoSegPagado := ifnull(Var_MontoSegPagado, Decimal_Cero);

call SEGUROCLIMOVALT
			(Var_SeguroClienteID,	Par_ClienteID,	Var_MontoSegPagado,	Est_Vencido,	Par_SucursalID,
			Par_CajaID,				Var_FechaOper,	Par_UsuarioID,		descrpcionMov,	Par_NumeroMov,
			Par_MonedaID,			SalidaNO,		Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);
	if (Par_NumErr <> Entero_Cero)then
		LEAVE ManejoErrores;
	end if;


	call SEGUROCLIENTEACT(
			Var_SeguroClienteID,	Par_ClienteID,		Par_CantidadMov,	Act_Vencido,		MotivoCanAut,
			Entero_Cero,			descrpcionMov,		SalidaNO,			Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);
	if (Par_NumErr <> Entero_Cero)then
		LEAVE ManejoErrores;
	end if;


	set Var_ReferDetPol 	:= convert(Par_ClienteID, char);
	set Par_Poliza			:=Entero_Cero;

	if ( Var_EsHabil = Si) then
		CALL CONTACAJAPRO(
			Par_NumeroMov,			Var_FechaOper,		Var_MontoSegPagado,	descrpcionMov,		Par_MonedaID,
			Var_SucCliente,			Par_AltaEncPoliza,	ConContaVenSegVida,	Par_Poliza,			Par_AltaDetPol,
			ConceptosCajaCargo,		NatCargo,			Var_ReferDetPol,	Var_ReferDetPol,	Entero_Cero,
			TipoInstrumentoID,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		CALL CONTACAJAPRO(
			Par_NumeroMov,			Var_FechaOper,		Var_MontoSegPagado,		descrpcionMov,		Par_MonedaID,
			Var_SucCliente,			Con_AltaEncPol_No,	ConContaVenSegVida,		Par_Poliza,			Par_AltaDetPol,
			ConceptosCajaAbono,		NatAbono,			Var_ReferDetPol,		Var_ReferDetPol,	Entero_Cero,
			TipoInstrumentoID,		SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);
	else
		CALL CONTACAJAPRO(
			Par_NumeroMov,			Var_FechaApl,		Var_MontoSegPagado,	descrpcionMov,		Par_MonedaID,
			Var_SucCliente,			Par_AltaEncPoliza,	ConContaVenSegVida,	Par_Poliza,			Par_AltaDetPol,
			ConceptosCajaCargo,		NatCargo,			Var_ReferDetPol,	Var_ReferDetPol,	Entero_Cero,
			TipoInstrumentoID,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);
		CALL CONTACAJAPRO(
			Par_NumeroMov,		Var_FechaApl,		Var_MontoSegPagado,	descrpcionMov,		Par_MonedaID,
			Var_SucCliente,		Con_AltaEncPol_No,	ConContaVenSegVida,	Par_Poliza,			Par_AltaDetPol,
			ConceptosCajaAbono,	NatAbono,			Var_ReferDetPol,	Var_ReferDetPol,	Entero_Cero,
			TipoInstrumentoID,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

	end if;



set Par_NumErr := Entero_Cero;
set Par_ErrMen := "Seguro de Vida Ayuda Cambio a Vencido.";

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'operacionID' as control,
			Par_Poliza as consecutivo;
end if;

END TerminaStore$$