-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROAHOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPROAHOMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPROAHOMOD`(
	Par_ConceptoAhoID	int(5),
	Par_EmpresaID 		int(11),
	Par_TipoProductoID	int(11),
	Par_SubCuenta	 	char(6),

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


if(ifnull(Par_ConceptoAhoID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta Vacio.' as ErrMen,
		 'conceptoAhoID' as control;
	LEAVE TerminaStore;

end if
;if(ifnull(Par_EmpresaID, Entero_Cero))= Entero_Cero then
	select '002' as NumErr,
		 'El Numero de Empresa esta Vacio.' as ErrMen,
		 'empresaID' as control;
	LEAVE TerminaStore;

end if;
Set Aud_FechaActual := CURRENT_TIMESTAMP();
update SUBCTATIPROAHO set
		ConceptoAhoID	= Par_ConceptoAhoID,
		EmpresaID		= Par_EmpresaID,
		TipoProductoID	= Par_TipoProductoID,
		SubCuenta		= Par_SubCuenta	,

		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where  ConceptoAhoID 	= Par_ConceptoAhoID
	and	 TipoProductoID	= Par_TipoProductoID;

select '000' as NumErr ,
	  'SubCuenta Contable Modificada.' as ErrMen,
	  'tipoCuentaID' as control;

END TerminaStore$$