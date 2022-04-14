-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACLASIFAHOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTACLASIFAHOALT`;


	Par_ConceptoAhoID	int(5),
	Par_EmpresaID 		int(11),
	Par_Clasificacion	char(1),
	Par_SubCuenta	 	char(6),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)


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

insert into SUBCTACLASIFAHO (
	ConceptoAhoID,		EmpresaID,			Clasificacion,		SubCuenta,		Usuario,
	FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion
)values (
	Par_ConceptoAhoID,	Par_EmpresaID, 		Par_Clasificacion,	Par_SubCuenta,	Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
);

select '000' as NumErr,
	  concat("Subcuenta Agregada: ", convert(Par_ConceptoAhoID, CHAR))  as ErrMen,
	  'conceptoAhoID' as control;
END TerminaStore$$