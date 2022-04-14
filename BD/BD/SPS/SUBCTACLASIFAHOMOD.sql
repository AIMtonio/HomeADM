-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACLASIFAHOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTACLASIFAHOMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTACLASIFAHOMOD`(
	Par_ConceptoAhoID	int(5),
	Par_Clasificacion	char(1),
	Par_SubCuenta	 	char(6),

	Par_EmpresaID 		int(11),
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
DECLARE		Decimal_Cero			decimal(12,2);
DECLARE		NumSubCuenta			int;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Decimal_Cero			:= 0.0;
Set 	NumSubCuenta			:= 0;

if(ifnull(Par_ConceptoAhoID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta Vacio.' as ErrMen,
		 'conceptoAhoID' as control;
	LEAVE TerminaStore;

end if;if(ifnull(Par_EmpresaID, Entero_Cero))= Entero_Cero then
	select '002' as NumErr,
		 'El Numero de Empresa esta Vacio.' as ErrMen,
		 'empresaID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_SubCuenta, Cadena_Vacia))= Cadena_Vacia then
	select '003' as NumErr,
		 'La Subcuenta esta Vacia.' as ErrMen,
		 'subCuenta3' as control;
	LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

update SUBCTACLASIFAHO set
		SubCuenta		= Par_SubCuenta,

		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where	ConceptoAhoID 	= Par_ConceptoAhoID
	and		Clasificacion	= Par_Clasificacion;

select '000' as NumErr ,
	  concat("SubCuenta Modificada Exitosamente: ",convert(Par_ConceptoAhoID,char)) as ErrMen,
	  'consumo' as control;


END TerminaStore$$