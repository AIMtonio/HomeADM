-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAINVERSIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAINVERSIONPRO`;DELIMITER $$

CREATE PROCEDURE `CONTAINVERSIONPRO`(
	Par_InversionID		bigint,
	Par_Empresa			int,
	Par_Fecha			Date,
	Par_Monto			decimal(12,2),
	Par_TipoMovAho		varchar(4),

	Par_ConceptoCon		int,
	Par_ConceptoInv		int,
	Par_ConceptoAho		int,
	Par_Naturaleza		char(1),
	Par_AltaEncPoliza	char(1),

	Par_AltaMovAho		char(1),
inout	Par_Poliza		bigint,
	Par_CuentaAhoID		bigint(12),
	Par_ClienteID		bigint,
	Par_MonedaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,

	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN


DECLARE	Var_TipoPersona		char(1);
DECLARE	Var_Poliza			bigint;
DECLARE Var_CuentaStr		varchar(20);
DECLARE Var_InversionStr	varchar(20);
DECLARE Mon_Cargo			decimal(12,2);
DECLARE Mon_Abono			decimal(12,2);


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Pol_Automatica		char(1);
DECLARE	Salida_NO			char(1);
DECLARE	AltaPoliza_SI		char(1);
DECLARE	AltaMovAho_SI		char(1);
DECLARE	Nat_Cargo			char(1);
DECLARE	Nat_Abono			char(1);
DECLARE	Tipo_Provision		char(4);
DECLARE	Con_IntGra			int;
DECLARE	Con_IntExe			int;
DECLARE	Con_Provision		int;
DECLARE	Pol_Concepto		varchar(100);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Pol_Automatica		:= 'A';
Set	Salida_NO			:= 'N';
Set	AltaPoliza_SI		:= 'S';
Set	AltaMovAho_SI		:= 'S';
Set	Nat_Cargo			:= 'C';
Set	Nat_Abono			:= 'A';
Set	Tipo_Provision		:= '100';
Set	Con_IntGra			:= 2;
Set	Con_IntExe			:= 3;
Set	Con_Provision		:= 5;

if (Par_TipoMovAho != Cadena_Vacia) then
	set Pol_Concepto:= (select Descripcion
						from TIPOSMOVSAHO
						where	TipoMovAhoID = Par_TipoMovAho);
else
	set Pol_Concepto:= (select Descripcion
						from CONCEPTOSINVER
						where	ConceptoInvID = Par_ConceptoInv);
end if;

Set Var_InversionStr:=  concat("Inv.",convert(Par_InversionID, char));
Set Var_CuentaStr 	:=  concat("Cta.",convert(Par_CuentaAhoID, char));


if (Par_AltaEncPoliza = AltaPoliza_SI) then
	set	Var_Poliza	:= Entero_Cero;
	CALL MAESTROPOLIZAALT(
		Var_Poliza,		Par_Empresa,	Par_Fecha,		Pol_Automatica,		Par_ConceptoCon,
		Pol_Concepto,	Salida_NO,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
	set	Par_Poliza	:= Var_Poliza;
else
	set Var_Poliza = Par_Poliza;
end if;


if(Par_Naturaleza = Nat_Abono)then
	if (Par_AltaMovAho = AltaMovAho_SI) then
		call CUENTASAHOMOVALT(
			Par_CuentaAhoID, 	Aud_NumTransaccion,	Par_Fecha, 			Nat_Abono,			Par_Monto,
			Pol_Concepto,		Par_InversionID,	Par_TipoMovAho,		Par_Empresa,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		CALL POLIZAAHORROPRO(
			Var_Poliza,			Par_Empresa,		Par_Fecha,			Par_ClienteID,		Par_ConceptoAho,
			Par_CuentaAhoID,	Par_MonedaID,		Entero_Cero,		Par_Monto,			Pol_Concepto,
			Var_CuentaStr,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		set Mon_Cargo	:= Par_Monto;
		set Mon_Abono	:= Entero_Cero;
	else
		set Mon_Cargo	:= Entero_Cero;
		set Mon_Abono	:= Par_Monto;
	end if;

	CALL POLIZAINVERPRO(
		Var_Poliza,			Par_Empresa,	Par_Fecha, 			Par_ClienteID,		Par_ConceptoInv,
		Par_InversionID,	Par_MonedaID,	Mon_Cargo,			Mon_Abono,			Pol_Concepto,
		Var_InversionStr,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);
end if;


if(Par_Naturaleza = Nat_Cargo)then
	if (Par_AltaMovAho = AltaMovAho_SI) then
		call CUENTASAHOMOVALT(
			Par_CuentaAhoID, 	Aud_NumTransaccion,	Par_Fecha, 			Nat_Cargo,			Par_Monto,
			Pol_Concepto,		Par_InversionID,	Par_TipoMovAho,		Par_Empresa, 		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		CALL POLIZAAHORROPRO(
			Var_Poliza,		    Par_Empresa,		Par_Fecha,			Par_ClienteID,		Par_ConceptoAho,
			Par_CuentaAhoID,	Par_MonedaID,		Par_Monto,			Entero_Cero,		Pol_Concepto,
			Var_CuentaStr,	    Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		set Mon_Cargo	:= Entero_Cero;
		set Mon_Abono	:= Par_Monto;
	else
		set Mon_Cargo	:= Par_Monto;
		set Mon_Abono	:= Entero_Cero;

	end if;

	CALL POLIZAINVERPRO(
		Var_Poliza,			Par_Empresa,		Par_Fecha, 			Par_ClienteID,		Par_ConceptoInv,
		Par_InversionID,	Par_MonedaID,		Mon_Cargo,			Mon_Abono,			Pol_Concepto,
		Var_InversionStr,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);
end if;

END TerminaStore$$