-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMVENDIVISAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMVENDIVISAALT`;DELIMITER $$

CREATE PROCEDURE `COMVENDIVISAALT`(
	Par_MonedaID			int,
	Par_NumeroMovimiento	bigint,
	Par_Fecha			date,
	Par_Monto			float,
	Par_TipoCambio		double,
	Par_Origen			char(1),
	Par_TipoOperacion		char(1),
	Par_Instrumento		varchar(20),
	Par_Referencia		varchar(50),
	Par_Descripcion		varchar(100),
	Par_Poliza			bigint,
	Par_Empresa			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Var_MontoMN 		float;
DECLARE Var_MonedaBase	int;
DECLARE Var_CargosMN 		float;
DECLARE Var_AbonosMN 		float;
DECLARE Var_CargosME 		float;
DECLARE Var_AbonosME 		float;


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE 	Ope_Interna		char(1);
DECLARE 	Tip_Compra		char(1);
DECLARE 	Tip_Venta		char(1);
DECLARE	Con_ComVen		int;


Set Cadena_Vacia		:= '';
Set Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero		:= 0;
Set Ope_Interna		:= 'I';
Set Tip_Compra		:= 'C';
Set Tip_Venta			:= 'V';
Set Con_ComVen		:= 2;

set 	Var_MontoMN = format(Par_Monto * Par_TipoCambio, 2);

select MonedaBaseID into Var_MonedaBase
	from PARAMETROSSIS;


call OPERACIONDIVISAALT(
	Par_MonedaID,		Aud_NumTransaccion,	Par_Fecha,		Var_MontoMN,		Par_Monto,
	Par_TipoCambio,	Par_Origen,		Par_TipoOperacion,	Par_Referencia,	Par_Descripcion,
	Par_Empresa,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
	Aud_Sucursal,		Aud_NumTransaccion	);


if (Par_TipoOperacion = Tip_Compra) then
	set Var_CargosMN = Var_MontoMN;
	set Var_AbonosMN = Entero_Cero;

	set Var_CargosME = Entero_Cero;
	set Var_AbonosME = Par_Monto;
else
	set Var_CargosMN = Entero_Cero;
	set Var_AbonosMN = Var_MontoMN;

	set Var_CargosME = Par_Monto;
	set Var_AbonosME = Entero_Cero;
end if;


call POLIZADIVISAPRO(
    Par_Poliza,         Entero_Cero,        Entero_Cero,    Par_Empresa,		Par_Fecha,
    Cadena_Vacia,       Con_ComVen,         Par_MonedaID,   Var_CargosME,		Var_AbonosME,
    Par_Instrumento,    Par_Descripcion,    Par_Referencia, Entero_Cero,Aud_Usuario,		Aud_FechaActual,
    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion	);


call POLIZADIVISAPRO(
    Par_Poliza,         Entero_Cero,        Entero_Cero,    Par_Empresa,    Par_Fecha,
    Cadena_Vacia,       Con_ComVen,         Var_MonedaBase, Var_CargosMN,   Var_AbonosMN,
    Par_Instrumento,    Par_Descripcion,    Par_Referencia, Entero_Cero,Aud_Usuario,    Aud_FechaActual,
    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion	);

END TerminaStore$$