-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACONTAPLANALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACONTAPLANALT`;DELIMITER $$

CREATE PROCEDURE `POLIZACONTAPLANALT`(
	Par_Fecha			Date,
	Par_Tipo			char(1),
	Par_ConceptoID		int(11),
	Par_Concepto		varchar(150),
	Par_Descripcion	varchar(150),

	Par_Empresa			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Salida_SI		char(1);
DECLARE	Var_Poliza		bigint;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Salida_SI		:= 'S';



set Var_Poliza := (select ifnull(Max(PolizaID),Entero_Cero) + 1
				from POLIZACONTAPLAN);


insert POLIZACONTAPLAN VALUES (
	Var_Poliza,			Par_Descripcion,		Par_Empresa,
	Par_Fecha, 				Par_Tipo,			Par_ConceptoID,
	Par_Concepto,		Aud_Usuario	,		Aud_FechaActual,
	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion);

select '000' as NumErr,
	  concat("Poliza Contable Plan Agregado: ", convert(Var_Poliza, CHAR))  as ErrMen,
	  'polizaID' as control,
	  Var_Poliza as consecutivo;

END TerminaStore$$