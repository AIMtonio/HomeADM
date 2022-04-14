-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERFONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPERFONMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPERFONMOD`(
	Par_ConceptoFondID		int(11),
   Par_TipoFondeador    char(1),
	Par_Fisica				char(6),
	Par_FisicaActEmp		char(6),
	Par_Moral				char(6),
	Par_Salida				char(1),

	inout	Par_NumErr 		int,
	inout	Par_ErrMen  	varchar(350),
	Aud_EmpresaID 			int(11),
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,

	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
		)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia		char(1);
DECLARE		Entero_Cero			int;
DECLARE		Numero			int;


Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
set Numero				:= 0;

if(ifnull(Par_ConceptoFondID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta vacio.' as ErrMen,
		 'fisica' as control;
	LEAVE TerminaStore;
end if;
Set Aud_FechaActual := CURRENT_TIMESTAMP();

update SUBCTATIPERFON set
	Fisica			= Par_Fisica,
	FisicaActEmp	= Par_FisicaActEmp,
	Moral			= Par_Moral,
	EmpresaID 	    = Aud_EmpresaID,
	Usuario			= Aud_Usuario	,
	FechaActual	    = Aud_FechaActual,
	DireccionIP	    = Aud_DireccionIP,
	ProgramaID	    = Aud_ProgramaID,
	Sucursal	    = Aud_Sucursal,
	NumTransaccion	= Aud_NumTransaccion
where ConceptoFondID = Par_ConceptoFondID
and TipoFondeo = Par_TipoFondeador;

select '000' as NumErr,
	  concat("Subcuenta Modificada Correctamente.")  as ErrMen,
	  'fisica' as control;

END TerminaStore$$