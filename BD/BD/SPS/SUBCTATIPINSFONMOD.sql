-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPINSFONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPINSFONMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPINSFONMOD`(
	Par_ConceptoFonID	int(11),
   Par_TipoFondeador     char(1),
	Par_TipoInstitID	int(11),
	Par_SubCuenta		char(6),

	Par_Salida          char(1),
    inout Par_NumErr   int,
    inout Par_ErrMen   varchar(400),

	Aud_EmpresaID 		int(11),
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia		char(1);
DECLARE		Entero_Cero			int;
DECLARE		Float_Cero			float;
DECLARE		Numero			int;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Float_Cero			:= 0.0;
set Numero				:= 0;


if(ifnull(Par_TipoInstitID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Tipo de Institucion esta vacio.' as ErrMen,
		 'tipoInstitID' as control;
	LEAVE TerminaStore;

end if
;if(ifnull(Par_SubCuenta, Cadena_Vacia))= Cadena_Vacia then
	select '002' as NumErr,
		 'La SubCuenta esta Vacia.' as ErrMen,
		 'subCuenta' as control;
	LEAVE TerminaStore;

end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

update SUBCTATIPINSFON set
TipoInstitID	  = Par_TipoInstitID,
SubCuenta		  = Par_SubCuenta

where ConceptoFonID = Par_ConceptoFonID
	and TipoInstitID=Par_TipoInstitID
   and TipoFondeo=Par_TipoFondeador;

select '000' as NumErr,
	  concat("Subcuenta Modificada correctamente ")  as ErrMen,
	  'subCuenta' as control;

END TerminaStore$$