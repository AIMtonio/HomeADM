-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERINVMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPERINVMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPERINVMOD`(
	Par_ConceptoInverID	int(5),
	Par_Fisica		 	char(2),
	Par_Moral			char(2) ,

	Aud_EmpresaID			int,
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

Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Float_Cero			:= 0.0;


if(ifnull(Par_ConceptoInverID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta Vacio.' as ErrMen,
		 'conceptoInverID' as control;
	LEAVE TerminaStore;

end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();
update SUBCTATIPERINV set
		ConceptoInverID	= Par_ConceptoInverID,
		Fisica		= Par_Fisica,
		Moral			= Par_Moral		,

		EmpresaID		= Aud_EmpresaID,
		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where  ConceptoInverID 	= Par_ConceptoInverID;

select '000' as NumErr ,
	  'SubCuenta Contable Modificada.' as ErrMen,
	  'conceptoInverID' as control;

END TerminaStore$$