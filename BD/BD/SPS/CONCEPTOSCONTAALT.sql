-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCONTAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSCONTAALT`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSCONTAALT`(
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

if(ifnull(Par_ConceptoID, Entero_Cero)) = Entero_Cero then
	select '002' as NumErr,
		 'El Numero esta Vacio.' as ErrMen,
		 'conceptoContableID' as control;
	LEAVE TerminaStore;
end if;


insert into CONCEPTOSCONTA values   (
	Par_ConceptoID,	Par_EmpresaID,	Par_Descripcion,	Aud_Usuario,	Aud_FechaActual,
	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

select '000' as NumErr,
	  concat("Concepto Agregado: ", convert(Par_ConceptoID, CHAR))  as ErrMen,
	  'conceptoContableID' as control;

END TerminaStore$$