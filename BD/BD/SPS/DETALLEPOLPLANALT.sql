-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPOLPLANALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPOLPLANALT`;DELIMITER $$

CREATE PROCEDURE `DETALLEPOLPLANALT`(
	Par_Empresa		int,
	Par_Poliza		bigint,
	Par_Fecha		date,
	Par_CenCosto	int,
	Par_Cuenta		varchar(50),
	Par_Instrumento	varchar(20),
	Par_Moneda		int (11),
	Par_Cargos		float,
	Par_Abonos		float,
	Par_Descripcion	varchar(100),
	Par_Referencia	varchar(50),
	Par_Procedimiento varchar(20),

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
DECLARE		Float_Cero		float;
DECLARE		Salida_SI		char(1);

Set	Cadena_Vacia		:= '';
Set	Entero_Cero		:= 0;
Set	Float_Cero		:= 0.0;
Set	Salida_SI		:= 'S';

Set Aud_FechaActual := CURRENT_TIMESTAMP();



insert DETALLEPOLPLAN VALUES (
	Par_Empresa,		Par_Poliza,			Par_Fecha, 			Par_CenCosto,		Par_Cuenta,
	Par_Instrumento,		Par_Moneda,			Par_Cargos,			Par_Abonos,			Par_Descripcion,
	Par_Referencia,		Par_Procedimiento,	Aud_Usuario	,		Aud_FechaActual,		Aud_DireccionIP,
	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


select '000' as NumErr,
  concat("Detalle Poliza Plan Agregada: ", convert(Par_Poliza, CHAR))  as ErrMen,
  'polizaID' as control,
  Par_Poliza as consecutivo;


END TerminaStore$$