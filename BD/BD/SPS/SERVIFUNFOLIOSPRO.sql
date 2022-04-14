-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SERVIFUNFOLIOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVIFUNFOLIOSPRO`;
DELIMITER $$

CREATE PROCEDURE `SERVIFUNFOLIOSPRO`(

	Par_ServiFunFolioID			int(11),
	Par_Proceso					char(1),
	Par_UsuarioAutoriza			int(11),
	Par_UsuarioRechaza			int(11),
	Par_MotivoRechazo			varchar(400),

	Par_Salida					char(1),
	inout Par_NumErr			int,
	inout Par_ErrMen			varchar(500),

	Par_EmpresaID				int(11),
	Aud_Usuario					int,
	Aud_FechaActual				DateTime,
	Aud_DireccionIP				varchar(15),
	Aud_ProgramaID				varchar(50),
	Aud_Sucursal				int(11),
	Aud_NumTransaccion			bigint

)
TerminaStore:BEGIN

DECLARE Var_Control				varchar(100);
DECLARE Var_ClienteNombreComple varchar(200);

DECLARE Var_PolizaID			bigint(20);
DECLARE Var_CentroCostosID		int(11);
DECLARE Var_FechaSistema		date;
DECLARE	Var_MonedaBaseID 		int(11);
DECLARE Var_CtaContaSRVFUN		varchar(25);
DECLARE Var_HaberExSocios		varchar(25);
DECLARE Var_MontoApoyo			decimal(14,2);
DECLARE Var_ClienteID			int(11);
DECLARE Var_TipoServicio		char(1);
DECLARE Var_CCServifun			varchar(30);
DECLARE Var_SucCliente			int(11);

DECLARE Var_PerNombreComp		varchar(200);
DECLARE Var_PerPorcentaje		decimal(12,2);
DECLARE	Var_TipoRelacionID		int(11)	;
DECLARE	Var_PerClienteID		int(11);
DECLARE	Var_PersonaID			int(11);

DECLARE Entero_Cero				int;
DECLARE Autorizacion			char(1);
DECLARE Rechazo					char(1);
DECLARE SalidaSI				char(1);
DECLARE SalidaNO				char(1);
DECLARE Var_Si					char(1);

DECLARE Cadena_Vacia			char;
DECLARE PolAutomatica			char(1);
DECLARE ConceptoCon				int;
DECLARE DescripcionMovi			varchar(100);
DECLARE Fecha_Vacia				date;
DECLARE Decimal_Cero			decimal;
DECLARE DescMoviCargoAuto		varchar(100);
DECLARE Programa				varchar(100);
DECLARE DescMoviAbonoAuto		varchar(100);
DECLARE ServicioCliente			char(1);
DECLARE ServicioFamiliar		char(1);
DECLARE EstatusActiva			char(1);
DECLARE SIEsBeneficiario		char(1);
DECLARE TipoInstrumentoID		int(11);
DECLARE	For_SucOrigen			char(3);
DECLARE	For_SucCliente			char(3);
DECLARE Var_RolID			int(11);
DECLARE VarPerfilAutoriSRVFUN		int(11);
DECLARE Var_UsuarioAuto		int(11);
DECLARE Var_Contrasenia     varchar(500);


set Entero_Cero				:=0;
set Autorizacion			:='A';
set Rechazo					:='R';
set SalidaSI				:='S';
set SalidaNO				:='N';
set Var_Si					:='S';
set Cadena_Vacia			:='';
set PolAutomatica			:='A';
set ConceptoCon				:=801;
set DescripcionMovi			:='PAGO SERVIFUN';
set Fecha_Vacia				:='1900-01-01';
set Decimal_Cero			:=0.0;
set DescMoviCargoAuto		:='AUTORIZACION SERVIFUN';
set Programa				:='SERVIFUNFOLIOSPRO';
set DescMoviAbonoAuto		:='AUTORIZACION SERVIFUN';
set ServicioCliente			:='C';
set ServicioFamiliar		:='F';
set EstatusActiva			:='A';
set SIEsBeneficiario		:='S';
Set TipoInstrumentoID		:= 4;
set	For_SucOrigen			:= '&SO';
set	For_SucCliente			:= '&SC';

ManejoErrores:BEGIN


set Par_UsuarioAutoriza 	:= ifnull(Par_UsuarioAutoriza,Entero_Cero);
set Par_UsuarioRechaza		:= ifnull(Par_UsuarioRechaza,Entero_Cero);
set Par_MotivoRechazo		:=ifnull(Par_MotivoRechazo,Cadena_Vacia);
set Aud_FechaActual 		:= now();

if(ifnull(Par_ServiFunFolioID,Entero_Cero) = Entero_Cero)then
	set Par_NumErr  := 01;
	set Par_ErrMen  := concat('El Folio ', convert(Par_ServiFunFolioID,char),' no existe');
	set Var_Control := 'serviFunFolioID ';
	LEAVE ManejoErrores;
end if;
set Par_Proceso :=ifnull(Par_Proceso ,Cadena_Vacia);
select FechaSistema, MonedaBaseID into Var_FechaSistema, Var_MonedaBaseID
			from PARAMETROSSIS Limit 1;
	set Var_FechaSistema	:= ifnull(Var_FechaSistema, Fecha_Vacia);
	set Var_MonedaBaseID	:=ifnull(Var_MonedaBaseID,Entero_Cero);


if(Par_Proceso = Autorizacion)then
	if (ifnull(Par_UsuarioAutoriza ,Entero_Cero) = Entero_Cero)then
		set Par_NumErr  := 02;
		set Par_ErrMen  := concat('El usuario que Autoriza se encuentra vacio');
		set Var_Control := 'autorizar ';
		LEAVE ManejoErrores;
	end if;
	if not exists(select UsuarioID
						from USUARIOS
						where UsuarioID = Par_UsuarioAutoriza)then
		set Par_NumErr  := 03;
		set Par_ErrMen  := concat('El usuario ',convert(Par_UsuarioAutoriza,char),' no Existe');
		set Var_Control := 'autorizar ';
		LEAVE ManejoErrores;
	end if;

	select  	UsuarioID , 		Contrasenia,		RolID
		into	Var_UsuarioAuto,	Var_Contrasenia,	Var_RolID
		from USUARIOS
		where UsuarioID = Par_UsuarioAutoriza;


	set Var_CentroCostosID	:= FNCENTROCOSTOS(Aud_Sucursal);
	select CtaContaSRVFUN,		HaberExSocios,		CCServifun,		PerfilAutoriSRVFUN
		into Var_CtaContaSRVFUN, Var_HaberExSocios, Var_CCServifun,	VarPerfilAutoriSRVFUN
			from PARAMETROSCAJA
			limit 1;

	set Var_CtaContaSRVFUN	:=ifnull(Var_CtaContaSRVFUN,Cadena_Vacia);
	set Var_HaberExSocios 	:=ifnull(Var_HaberExSocios,Cadena_Vacia);
	set Var_CCServifun		:=ifnull(Var_CCServifun,Cadena_Vacia);

	select ClienteID, MontoApoyo,TipoServicio
				into Var_ClienteID, Var_MontoApoyo, Var_TipoServicio
			from SERVIFUNFOLIOS
				where ServiFunFolioID =Par_ServiFunFolioID;


	set Var_ClienteID	:= ifnull(Var_ClienteID,Entero_Cero);
	set Var_MontoApoyo	:=ifnull(Var_MontoApoyo,Decimal_Cero);
	set Var_TipoServicio:=ifnull(Var_TipoServicio,Cadena_Vacia);
	set Var_SucCliente	:=ifnull(Var_SucCliente, Entero_Cero);


	select Cli.NombreCompleto, SucursalOrigen
		into Var_ClienteNombreComple, Var_SucCliente
			FROM CLIENTES Cli
			where Cli.ClienteID	= Var_ClienteID
			limit 1;


	set Var_ClienteNombreComple :=ifnull(Var_ClienteNombreComple, Cadena_Vacia);

	call SERVIFUNENTREGADOALT(
		Par_ServiFunFolioID,	Var_ClienteID,		Var_ClienteNombreComple,	Var_MontoApoyo,		SalidaNO,
		Par_NumErr, 			Par_ErrMen,			Par_EmpresaID,				Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,				Aud_NumTransaccion
	);

	if (Par_NumErr <> Entero_Cero)then
		LEAVE ManejoErrores;
	end if;



	if LOCATE(For_SucOrigen, Var_CCServifun) > 0 then
		set Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
	else
		if LOCATE(For_SucCliente, Var_CCServifun) > 0 then
				if (Var_SucCliente > 0) then
					set Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
				else
					set Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
				end if;
		else
			set Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
		end if;
	end if;


	if(Var_TipoServicio = ServicioCliente)then

		if(Var_RolID != VarPerfilAutoriSRVFUN)then
			set Par_NumErr	:= '009';
			set Par_ErrMen	:= 'El Usuario no tiene El Perfil para Autorizar .';
			set Var_Control := 'usuarioAuto' ;
			LEAVE ManejoErrores;
		end if;

		CALL MAESTROPOLIZAALT(
			Var_PolizaID,		Par_EmpresaID,	Var_FechaSistema, 	PolAutomatica,		ConceptoCon,
			DescripcionMovi,	SalidaNO, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		CALL DETALLEPOLIZAALT(
			Par_EmpresaID,			Var_PolizaID,		Var_FechaSistema,	Var_CentroCostosID,	Var_CtaContaSRVFUN,
			Var_ClienteID,			Var_MonedaBaseID,	Var_MontoApoyo ,	Entero_Cero,		DescMoviCargoAuto,
			Par_ServiFunFolioID,	Programa,			TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia,			SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		CALL DETALLEPOLIZAALT(
			Par_EmpresaID,			Var_PolizaID,		Var_FechaSistema,	Var_CentroCostosID,	Var_HaberExSocios,
			Var_ClienteID,			Var_MonedaBaseID,	Entero_Cero,		Var_MontoApoyo,		DescMoviAbonoAuto,
			Par_ServiFunFolioID,	Programa,			TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia,			SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);



		update PROTECCIONES set
			AplicaSERVIFUN		= Var_Si,
			MontoSERVIFUN		= Var_MontoApoyo,
			SaldoFavorCliente	= ifnull(SaldoFavorCliente,0) + Var_MontoApoyo,
			TotalBeneAplicado	= ifnull(TotalBeneAplicado,0) + Var_MontoApoyo
		where ClienteID 		= Var_ClienteID;

	end if;

	update SERVIFUNFOLIOS set
		UsuarioAutoriza 	=Par_UsuarioAutoriza,
		FechaAutoriza		=Var_FechaSistema,
		UsuarioRechaza		=Par_UsuarioRechaza,
		FechaRechazo		=Fecha_Vacia,
		MotivoRechazo		=Par_MotivoRechazo,
		Estatus				=Autorizacion,

		EmpresaID			=Par_EmpresaID,
		Usuario				=Aud_Usuario,
		FechaActual			=Aud_FechaActual,
		DireccionIP			=Aud_DireccionIP,
		ProgramaID			=Aud_ProgramaID,
		Sucursal			=Aud_Sucursal,
		NumTransaccion		=Aud_NumTransaccion
	where ServiFunFolioID	=Par_ServiFunFolioID;


	set Par_NumErr  := 0;
	set Par_ErrMen  := concat('Folio ',Par_ServiFunFolioID,' Autorizado Exitosamente');
	set Var_Control := 'serviFunFolioID';

end if;

if(Par_Proceso = Rechazo)then

	if (ifnull(Par_UsuarioRechaza ,Entero_Cero) = Entero_Cero)then
		set Par_NumErr  := 4;
		set Par_ErrMen  := concat('El usuario que Rechaza se encuentra vacio');
		set Var_Control := 'autorizar ';
		LEAVE ManejoErrores;
	end if;
	if not exists(select UsuarioID
						from USUARIOS
						where UsuarioID = Par_UsuarioRechaza)then
		set Par_NumErr  := 5;
		set Par_ErrMen  := concat('El usuario ',convert(Par_UsuarioRechaza, char),' no Existe');
		set Var_Control := 'autorizar ';
		LEAVE ManejoErrores;
	end if;
	if(Par_MotivoRechazo = Cadena_Vacia)then
		set Par_NumErr  := 6;
		set Par_ErrMen  := concat('El Motivo del Rechazo se Encuentra Vacio');
		set Var_Control := 'autorizar ';
		LEAVE ManejoErrores;
	end if;

	update SERVIFUNFOLIOS set
		UsuarioAutoriza 	=Par_UsuarioAutoriza,
		FechaAutoriza		=Fecha_Vacia,
		UsuarioRechaza		=Par_UsuarioRechaza,
		FechaRechazo		=Var_FechaSistema,
		MotivoRechazo		=Par_MotivoRechazo,
		Estatus				=Rechazo,

		EmpresaID			=Par_EmpresaID,
		Usuario				=Aud_Usuario,
		FechaActual			=Aud_FechaActual,
		DireccionIP			=Aud_DireccionIP,
		ProgramaID			=Aud_ProgramaID,
		Sucursal			=Aud_Sucursal,
		NumTransaccion		=Aud_NumTransaccion

	where ServiFunFolioID	=Par_ServiFunFolioID;
		set Par_NumErr  := 0;
		set Par_ErrMen  := concat('Folio ',Par_ServiFunFolioID,' Rechazado Exitosamente');
		set Var_Control := 'serviFunFolioID';

end if;


END ManejoErrores;
	if (Par_Salida = SalidaSI) then
		select  Par_NumErr as NumErr,
        Par_ErrMen as ErrMen,
        Var_Control as control,
        Par_ServiFunFolioID as consecutivo;
	end if;

END TerminaStore$$