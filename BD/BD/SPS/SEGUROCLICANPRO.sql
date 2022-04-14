-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLICANPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROCLICANPRO`;DELIMITER $$

CREATE PROCEDURE `SEGUROCLICANPRO`(
	Par_Seguro			bigint,
	Par_Motivo			int(11),
	Par_Observacion		varchar(200),
	Par_Clave				varchar(45),
	Par_Contrasenia		varchar(45),

	Par_Salida				char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(100),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore:BEGIN


DECLARE Var_ClienteID			int(11);
DECLARE Var_MontoPolizaSegA		decimal(14,2);
DECLARE Var_MontoSeguroApoyo	decimal(14,2);
DECLARE Var_MontoSegPagado	decimal(14,2);

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
DECLARE Var_CajaID		int(11);
DECLARE Var_MonedaBase		int(11);
DECLARE Var_ClaveUsuario		varchar(45);


DECLARE SalidaNO				char(1);
DECLARE SalidaSI				char(1);
DECLARE descrpcionMov			varchar(100);
DECLARE ConContaVenSegVida		int;
DECLARE ConceptosCajaAbono			int;
DECLARE ConceptosCajaCargo			int;
DECLARE NatAbono				char(1);
DECLARE NatCargo				char(1);
DECLARE Entero_Cero				int;
DECLARE Act_Vigente				int;
DECLARE Act_Cancela				int;
DECLARE Cadena_Vacia			char;
DECLARE Decimal_Cero			decimal;
DECLARE Si						char(1);
DECLARE Contador				int;
DECLARE Est_Inactivo			char(1);
DECLARE Est_Vigente				char(1);
DECLARE Est_Cancelado				char(1);
DECLARE Vencido		char(1);
DECLARE AltaEncPol_Si		char(1);
DECLARE AltaDetPol_Si		char(1);
DECLARE AltaEncPol_No		char(1);
DECLARE Var_poliza				bigint;
DECLARE Var_Control				varchar(100);
DECLARE TipoInstrumentoID		int(11);


set SalidaNO				:='N';
set SalidaSI				:='S';
set descrpcionMov			:='CANCELACION DE SEGURO VIDA AYUDA';
Set ConContaVenSegVida		:=408;
set ConceptosCajaAbono			:=6;
set ConceptosCajaCargo			:=2;
set NatAbono				:='A';
set NatCargo				:='C';
set Entero_Cero				:=0;
set Act_Vigente				:=1;
set Act_Cancela				:=4;
set Cadena_Vacia			:='';
set Decimal_Cero			:=0.0;
set Vencido				:= 'B';
set Si						:='S';
set Contador				:=1;
set Est_Inactivo			:='I';
set Est_Vigente				:='V';
set Est_Cancelado				:='K';
set Act_Vigente				:=3;
set AltaEncPol_Si				:='S';
set AltaEncPol_No				:='N';
set AltaDetPol_Si				:='S';
Set TipoInstrumentoID			:= 4;

ManejoErrores:BEGIN


 DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
 				"esto le ocasiona. Ref: SP-SEGUROCLICANPRO");
    END;

set Par_NumErr  	:= Entero_Cero;
set Par_ErrMen  	:= Cadena_Vacia;
set Aud_FechaActual := now();


select Clave into Var_ClaveUsuario from USUARIOS where UsuarioID = Aud_Usuario;
set Var_ClaveUsuario := ifnull(Var_ClaveUsuario,Cadena_Vacia);

if not exists(select UsuarioID from USUARIOS where Clave = Par_Clave and  Contrasenia= Par_Contrasenia) then
	set Par_NumErr := 1;
	set Par_ErrMen := "La Clave de Usuario o Contraseña Son Incorrectos";
	set Var_Control := 'contrasenia';
	LEAVE ManejoErrores;
end if;

if (Var_ClaveUsuario = Par_Clave) then
	set Par_NumErr := 2;
	set Par_ErrMen := "El usuario que realiza la Transaccion no puede ser el mismo que  Autoriza.";
	set Var_Control := 'claveUsuarioAutoriza';
	LEAVE ManejoErrores;
end if;


select FechaSistema,MontoPolizaSegA,MontoSegAyuda, MonedaBaseID
		into Var_FechaOper, Var_MontoPolizaSegA,Var_MontoSeguroApoyo, Var_MonedaBase
		from PARAMETROSSIS;

set Var_MontoSeguroApoyo:=ifnull(Var_MontoSeguroApoyo,Decimal_Cero);

select ClienteID, MontoSegPagado into Var_ClienteID, Var_MontoSegPagado from SEGUROCLIENTE where SeguroClienteID = Par_Seguro;
set 	Var_MontoSegPagado := ifnull(Var_MontoSegPagado,Entero_Cero);
set	Var_ClienteID		:=ifnull(Var_ClienteID,Entero_Cero);

select  Cli.SucursalOrigen,Cli.EsMenorEdad  into Var_SucCliente, Var_EsMEnorEdad
	from  CLIENTES Cli
	where Cli.ClienteID   = Var_ClienteID;

select CajaID into Var_CajaID from CAJASVENTANILLA where UsuarioID = Aud_Usuario;


set Var_EsMEnorEdad		:=ifnull(Var_EsMEnorEdad,Cadena_Vacia);


call DIASFESTIVOSCAL(
		Var_FechaOper,		Entero_Cero,		Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

if(Var_EsMEnorEdad = Si)then
	set Par_NumErr := 3;
	set Par_ErrMen := "La persona es un Socio Menor. No se puede realizar esta Operacion";
	set Var_Control := 'seguroClienteID';
	LEAVE ManejoErrores;
end if;

set Var_SeguroClienteID := ifnull(Par_Seguro,Entero_Cero);

call SEGUROCLIMOVALT
			(Var_SeguroClienteID,	Var_ClienteID,		Var_MontoSegPagado,	Est_Cancelado,		Aud_Sucursal,
			Var_CajaID,			Var_FechaOper,	Aud_Usuario,			descrpcionMov,	Aud_NumTransaccion,
			Var_MonedaBase,		SalidaNO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);
	if (Par_NumErr <> Entero_Cero)then
		LEAVE ManejoErrores;
	end if;

	call SEGUROCLIENTEACT(
			Var_SeguroClienteID,	Var_ClienteID,	Var_MontoSegPagado,	Act_Cancela,		Par_Motivo,
			Par_Observacion,		Par_Clave,		SalidaNO,				Par_NumErr,		Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);
	if (Par_NumErr <> Entero_Cero)then
		LEAVE ManejoErrores;
	end if;


	set Var_ReferDetPol 	:= convert(Var_ClienteID, char);
	set Var_poliza			:=Entero_Cero;
CALL CONTACAJAPRO(
	Aud_NumTransaccion,	Var_FechaApl,		Var_MontoSegPagado,		descrpcionMov,		Var_MonedaBase,
	Var_SucCliente,		AltaEncPol_Si,		ConContaVenSegVida,		Var_poliza,			AltaDetPol_Si,
	ConceptosCajaAbono,	NatAbono,			Var_ReferDetPol,		Var_ReferDetPol,	Entero_Cero,
	TipoInstrumentoID,	SalidaNO,			Par_NumErr,		Par_ErrMen,			Par_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion);
CALL CONTACAJAPRO(
	Aud_NumTransaccion,	Var_FechaApl,		Var_MontoSegPagado,	descrpcionMov,		Var_MonedaBase,
	Var_SucCliente,		AltaEncPol_No,		ConContaVenSegVida,	Var_poliza,			AltaDetPol_Si,
	ConceptosCajaCargo,	NatCargo,			Var_ReferDetPol,	Var_ReferDetPol,	Entero_Cero,
	TipoInstrumentoID,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion);


set Par_NumErr := Entero_Cero;
set Par_ErrMen := convert(concat('Seguro de Vida Cancelado: ', Par_Seguro), char);
set Var_Control := 'seguroClienteID';
END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
	Par_ErrMen as ErrMen,
	Var_Control as control,
	Par_Seguro as consecutivo;
end if;

END TerminaStore$$