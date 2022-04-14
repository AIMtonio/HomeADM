-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORFONDEOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORFONDEOMOD`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORFONDEOMOD`(
	Par_ConceptoFonID	int(11),
   Par_TipoFondeador    char(1),
	Par_Cuenta			varchar(12),
	Par_Nomenclatura	varchar(30),

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


if(ifnull(Par_Nomenclatura,	Cadena_Vacia))=Cadena_Vacia then
	select '001' as NumErr,
		 'La Nomenclatura esta vacia.' as ErrMen,
		 'conceptoFonID' as control;
	LEAVE TerminaStore;

end if;
if(ifnull(Par_Cuenta,Cadena_Vacia))=Cadena_Vacia then
	select '002' as NumErr,
		 'La Cuenta esta vacia.' as ErrMen,
		 'conceptoFonID' as control;
	LEAVE TerminaStore;

end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

update CUENTASMAYORFONDEO set
Cuenta	  		= Par_Cuenta,
Nomenclatura		  = Par_Nomenclatura,
EmpresaID 	      =	Aud_EmpresaID,
Usuario			  =	Aud_Usuario	,
FechaActual	      = Aud_FechaActual,
DireccionIP	      = Aud_DireccionIP,
ProgramaID	      = Aud_ProgramaID,
Sucursal	      = Aud_Sucursal,
NumTransaccion	  = Aud_NumTransaccion
where ConceptoFondID = Par_ConceptoFonID and TipoFondeo=Par_TipoFondeador;

select '000' as NumErr,
	  concat("Cuenta Mayor Modificado: ", convert(Par_Cuenta, CHAR))  as ErrMen,
	  'cuenta' as control;

END TerminaStore$$