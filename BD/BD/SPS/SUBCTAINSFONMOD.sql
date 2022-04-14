-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAINSFONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAINSFONMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTAINSFONMOD`(
	Par_ConceptoFonID	int(11),
   Par_TipoFondeador    char(1),
	Par_InstitutFondID	int(11),
	Par_SubCuenta		char(6),

	Par_Salida				char(1),
	inout	Par_NumErr 		int,
	inout	Par_ErrMen  	varchar(350),
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


if(ifnull(Par_ConceptoFonID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta vacio.' as ErrMen,
		 'conceptoFonID' as control;
	LEAVE TerminaStore;

end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

update SUBCTAINSFON set
InstitutFondID	  =Par_InstitutFondID,
SubCuenta		  = Par_SubCuenta,
EmpresaID 	      =	Aud_EmpresaID,
Usuario			  =	Aud_Usuario	,
FechaActual	      = Aud_FechaActual,
DireccionIP	      = Aud_DireccionIP,
ProgramaID	      = Aud_ProgramaID,
Sucursal	      = Aud_Sucursal,
NumTransaccion	  = Aud_NumTransaccion
where ConceptoFonID = Par_ConceptoFonID
	and InstitutFondID=Par_InstitutFondID
   and TipoFondeo = Par_TipoFondeador;

select '000' as NumErr,
	  concat("Subcuenta Modificada correctamente")  as ErrMen,
	  'subCuentaIns' as control;

END TerminaStore$$