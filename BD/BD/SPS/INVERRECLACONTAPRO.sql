-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERRECLACONTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERRECLACONTAPRO`;DELIMITER $$

CREATE PROCEDURE `INVERRECLACONTAPRO`(
	Par_InversionID		int,
	Par_Monto			decimal(14,2),
	Par_TipoRecla		char(1),		-- Tipo Reclasificacion: L: Liberar, A: Asignar
	Par_PolizaID		bigint(20),		/* numero de poliza contable */
	Par_Salida			char(1),

inout Par_NumErr		int,
inout Par_ErrMen		varchar(400),
	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,

	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint		)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	Var_CharNumErr		varchar(10);
DECLARE	Var_FechaSistema	date;
DECLARE	Var_InvStatus		char(1);
DECLARE	Var_Poliza			bigint;
DECLARE	Var_ClienteID		bigint;
DECLARE	Var_MonedaID		int;
DECLARE	Var_MontoInver		decimal(14,2);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(12, 2);
DECLARE Val_SalidaNO    char(1);
DECLARE Val_SalidaSI    char(1);
DECLARE Con_InvCapital	int;
DECLARE Con_InvCapGrava	int;
DECLARE Nat_Abono       char(1);
DECLARE Nat_Cargo       char(1);
DECLARE Rec_Asigna		char(1);
DECLARE Rec_Libera		char(1);
DECLARE Sta_Vigente		char(1);
DECLARE Con_ContaRecla	int;
DECLARE AltEncPoliza	char(1);
DECLARE AltPoliza_SI	char(1);
DECLARE AltPoliza_NO	char(1);
DECLARE Mov_AhorroSI	char(1);
DECLARE Mov_AhorroNO	char(1);


-- Asignacion de Constantes
Set Cadena_Vacia    := '';              -- String Vacio
Set Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
Set Entero_Cero     := 0;               -- Entero en Cero
Set Decimal_Cero    := 0.00;            -- Decimal Cero
Set Val_SalidaNO    := 'N';             -- Ejecutar Store sin Regreso o Mensaje de Salida
Set Val_SalidaSI    := 'S';	            -- Ejecutar Store Con Regreso o Mensaje de Salida
Set Con_InvCapital	:= 1;				-- Concepto Contable de Inversion: Capital
Set Con_InvCapGrava	:= 6;				-- Concepto Contable de Inversion: Capital Garantizando Creditos
Set Nat_Abono       := 'A';             -- Naturaleza de Abono
Set Nat_Cargo       := 'C';             -- Naturaleza de Cargo
Set Rec_Asigna		:= 'A';             -- Tipo de Reclasificacion: Aisgnacion
Set Rec_Libera		:= 'L';             -- Tipo de Reclasificacion: Liberacion
Set	Sta_Vigente		:= 'N';				-- Estatus de la Inversion: Vigente
Set	Con_ContaRecla	:= 17;				-- Concepto Contable de Reclasificacion de Inversion
Set AltPoliza_SI	:= 'S';				-- Alta de la Poliza SI
Set AltPoliza_NO	:= 'N';				-- Alta de la Poliza NO
Set Mov_AhorroSI	:= 'S';         	-- Movimiento de Ahorro: SI
Set Mov_AhorroNO	:= 'N';         	-- Movimiento de Ahorro: NO
set AltEncPoliza = AltPoliza_NO;
ManejoErrores: BEGIN

-- Inicializacion
Set Par_NumErr		:= Entero_Cero;
Set Var_Poliza		:= Entero_Cero;
Set Par_ErrMen		:= 'Reclasificacion Realizada Exitosamente';

select FechaSistema into Var_FechaSistema
	from PARAMETROSSIS;

select Estatus, ClienteID, MonedaID, Monto into Var_InvStatus, Var_ClienteID, Var_MonedaID, Var_MontoInver
	from INVERSIONES
	where InversionID = Par_InversionID;

set Var_InvStatus	:= ifnull(Var_InvStatus, Cadena_Vacia);
set	Var_ClienteID	:= ifnull(Var_ClienteID, Entero_Cero);
set	Var_MonedaID	:= ifnull(Var_MonedaID, Entero_Cero);
set	Var_MontoInver	:= ifnull(Var_MontoInver, Entero_Cero);


if(ifnull(Var_InvStatus, Cadena_Vacia)) = Cadena_Vacia then
	set Par_NumErr :=  1;
	set Par_ErrMen := 'La Inversion no Existe';
	LEAVE ManejoErrores;
end if;

if(Var_InvStatus != Sta_Vigente)then
	set Par_NumErr :=  2;
	set Par_ErrMen := 'La Inversion no puede ser Reclasificada (Revisar su Estatus)';
	LEAVE ManejoErrores;
end if;

if(Par_Monto > Var_MontoInver )then
	set Par_NumErr :=  3;
	set Par_ErrMen := 'Monto Incorrecto, es mayor al Saldo de la Inversion';
	LEAVE ManejoErrores;
end if;

-- Realizamos las Afectaciones Contables
if(Par_TipoRecla = Rec_Asigna) then			-- Asignacion de la Inversion como Garantia

	if(Par_PolizaID >	Entero_Cero )then
		set AltEncPoliza 	:= AltPoliza_NO;
		set Var_Poliza		:= Par_PolizaID;
	else
		set AltEncPoliza 	:= AltPoliza_SI;
	end if;

	-- Cargo al Capital de Inversion
	call CONTAINVERSIONPRO(
		Par_InversionID,	Par_EmpresaID,		Var_FechaSistema,	Par_Monto,		Cadena_Vacia,
		Con_ContaRecla,		Con_InvCapital,		Entero_Cero,		Nat_Cargo,		AltEncPoliza,
		Mov_AhorroNO,		Var_Poliza,			Entero_Cero,		Var_ClienteID,	Var_MonedaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion	);

	-- Abono a Capital de Inversiones que Garantizan Creditos
	call CONTAINVERSIONPRO(
		Par_InversionID,	Par_EmpresaID,		Var_FechaSistema,	Par_Monto,		Cadena_Vacia,
		Con_ContaRecla,		Con_InvCapGrava,	Entero_Cero,		Nat_Abono,		AltPoliza_NO,
		Mov_AhorroNO,		Var_Poliza,			Entero_Cero,		Var_ClienteID,	Var_MonedaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion	);

else

	if(Par_PolizaID >	Entero_Cero )then
		set AltEncPoliza 	:= AltPoliza_NO;
		set Var_Poliza		:= Par_PolizaID;
	else
		set AltEncPoliza 	:= AltPoliza_SI;
	end if;
	-- Abono al Capital de Inversion
	call CONTAINVERSIONPRO(
		Par_InversionID,	Par_EmpresaID,		Var_FechaSistema,	Par_Monto,		Cadena_Vacia,
		Con_ContaRecla,		Con_InvCapital,		Entero_Cero,		Nat_Abono,		AltEncPoliza,
		Mov_AhorroNO,		Var_Poliza,			Entero_Cero,		Var_ClienteID,	Var_MonedaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion	);

	-- Cargo a Capital de Inversiones que Garantizan Creditos
	call CONTAINVERSIONPRO(
		Par_InversionID,	Par_EmpresaID,		Var_FechaSistema,	Par_Monto,		Cadena_Vacia,
		Con_ContaRecla,		Con_InvCapGrava,	Entero_Cero,		Nat_Cargo,		AltPoliza_NO,
		Mov_AhorroNO,		Var_Poliza,			Entero_Cero,		Var_ClienteID,	Var_MonedaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion	);
end if;

Set Par_NumErr		:= Entero_Cero;
Set Par_ErrMen		:= 'Reclasificacion Realizada Exitosamente';

END ManejoErrores;  -- End del Handler de Errores

 if (Par_Salida = Val_SalidaSI) then
	select 	convert(Par_NumErr, char) as NumErr,
		Par_ErrMen as ErrMen,
		'creditoID' as control,
		Entero_Cero as consecutivo;
end if;

END TerminaStore$$