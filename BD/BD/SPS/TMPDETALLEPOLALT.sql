-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDETALLEPOLALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPDETALLEPOLALT`;DELIMITER $$

CREATE PROCEDURE `TMPDETALLEPOLALT`(
	Par_Empresa		int,
	Par_Poliza		bigint,
	Par_Fecha		date,
	Par_CenCosto	int,
	Par_Cuenta		varchar(50),
	Par_Instrumento	varchar(20),
	Par_Moneda		int (11),
	Par_Cargos		Decimal(14,2),
	Par_Abonos		Decimal(14,2),
	Par_Descripcion	varchar(100),
	Par_Referencia	varchar(50),
	Par_Procedimiento varchar(20),
	Par_Salida 		char(1),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Entero_Cero		int;
DECLARE		Decimal_Cero		Decimal;
DECLARE		Salida_SI		char(1);
DECLARE		NumError			int;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero		:= 0.0;
Set	Salida_SI		:= 'S';

Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(ifnull( Aud_Usuario, Entero_Cero)) = Entero_Cero then
	Set NumError :=1;


	LEAVE TerminaStore;
end if;

if exists(select CuentaCompleta from CUENTASCONTABLES where CuentaCompleta=Par_Cuenta)  then
insert DETALLEPOLIZA VALUES (
	Par_Empresa,		Par_Poliza,			Par_Fecha, 			Par_CenCosto,		Par_Cuenta,
	Par_Instrumento,		Par_Moneda,			Par_Cargos,			Par_Abonos,			Par_Descripcion,
	Par_Referencia,		Par_Procedimiento,	Aud_Usuario	,		Aud_FechaActual,		Aud_DireccionIP,
	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
else
	Set NumError :=1;



	LEAVE TerminaStore;
end if;


if (Par_Salida = Salida_SI) then
	Set NumError :=1;




end if;


END TerminaStore$$