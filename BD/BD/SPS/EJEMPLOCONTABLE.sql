-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EJEMPLOCONTABLE
DELIMITER ;
DROP PROCEDURE IF EXISTS `EJEMPLOCONTABLE`;DELIMITER $$

CREATE PROCEDURE `EJEMPLOCONTABLE`(
	Par_CuentaID		bigint,
	Par_Empresa			int,
	Par_Fecha			Date,
	Par_Moneda			int,
	Par_Monto			float,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(20),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Var_TipoPersona	char(1);
DECLARE	Var_Poliza		float;
DECLARE	Var_Inversion	int;
DECLARE	Var_Cliente		bigint;
DECLARE 	Var_CuentaStr	varchar(20);


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Pol_Automatica	char(1);
DECLARE	Pol_Concepto	varchar(100);
DECLARE	Salida_NO		char(1);
DECLARE	Nat_Cargo		char(1);
DECLARE	Mov_AltaInv		varchar(4);
DECLARE	Con_Capital		int;
DECLARE 	ctaAho		int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Pol_Automatica	:= 'A';
Set	Pol_Concepto	:= 'Apertura de Inversion';
Set	Salida_NO		:= 'N';
Set	Nat_Cargo		:= 'C';
Set	Mov_AltaInv		:= '60';
Set	Con_Capital 	:= 1;

set Var_Inversion := 34567654;

set ctaAho:=(select CuentaAhoID from INVERSIONES where InversionID=Par_CuentaID);
select	Cue.ClienteID into Var_Cliente
	from  CUENTASAHO Cue
	where Cue.CuentaAhoID 	= ctaAho;

Set	Var_CuentaStr 	:= convert(Par_CuentaID, char);


call CUENTASAHOMOVALT(
	ctaAho, 	Aud_NumTransaccion, 	Par_Fecha, 		Nat_Cargo, 		Par_Monto,
	Pol_Concepto,	Var_Inversion,		Mov_AltaInv,	Par_Empresa, 	Aud_Usuario,
	Aud_FechaActual,
	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion	);


CALL MAESTROPOLIZAALT(
	Var_Poliza,		Par_Empresa,	Par_Fecha, 			Pol_Automatica,	Pol_Concepto,
	Salida_NO, 		Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
	Aud_Sucursal,	Aud_NumTransaccion);


CALL POLIZAAHORROPRO(
	Var_Poliza,		Par_Empresa,	Par_Fecha, 			Var_Cliente,		Con_Capital,
	ctaAho,	Par_Moneda,		Par_Monto,			Entero_Cero,		Pol_Concepto,
	Var_CuentaStr,	Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
	Aud_Sucursal,	Aud_NumTransaccion);

CALL POLIZAINVERPRO(
	Var_Poliza,		Par_Empresa,	Par_Fecha, 			Var_Cliente,		Con_Capital,
	Par_CuentaID,	Par_Moneda,		Entero_Cero,			Par_Monto,		Pol_Concepto,
	Var_CuentaStr,	Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
	Aud_Sucursal,	Aud_NumTransaccion);




END TerminaStore$$