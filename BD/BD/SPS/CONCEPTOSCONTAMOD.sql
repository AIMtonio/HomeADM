-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCONTAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSCONTAMOD`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSCONTAMOD`(
	Par_ConceptoID		int,
	Par_EmpresaID		int,
	Par_Descripcion		varchar(150),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;

Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '001' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;

update CONCEPTOSCONTA set
	Descripcion		= Par_Descripcion,

	Usuario		= Aud_Usuario,
	FechaActual 	= Aud_FechaActual,
	DireccionIP 	= Aud_DireccionIP,
	ProgramaID  	= Aud_ProgramaID,
	Sucursal		= Aud_Sucursal,
	NumTransaccion	= Aud_NumTransaccion

where ConceptoContaID	= Par_ConceptoID;

select '000' as NumErr ,
	  'Concepto Modificado' as ErrMen,
	  'conceptoContableID' as control;

END TerminaStore$$