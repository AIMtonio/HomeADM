-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDACARTMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAMONEDACARTMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTAMONEDACARTMOD`(
	Par_ConceptoCarID	int(11),
	Par_MonedaID		int(11),
	Par_SubCuenta	 	char(3),

	Aud_EmpresaID		int,
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

if(ifnull(Par_ConceptoCarID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta Vacio.' as ErrMen,
		 'conceptoCarID' as control;
	LEAVE TerminaStore;

end if;

Set Par_MonedaID := ifnull(Par_MonedaID,Entero_Cero);
if(Par_MonedaID=Entero_Cero) then
	select '002' as NumErr,
		 'El Numero de Moneda esta Vacio.' as ErrMen,
		 'monedaID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Aud_EmpresaID, Entero_Cero))= Entero_Cero then
	select '003' as NumErr,
		 'El Numero de Empresa esta Vacio.' as ErrMen,
		 'empresaID' as control;
	LEAVE TerminaStore;
end if;

Set Par_SubCuenta := ifnull(Par_SubCuenta,Cadena_Vacia);
if(Par_SubCuenta=Cadena_Vacia) then
	select '004' as NumErr,
		 'La Subcuenta esta Vacia.' as ErrMen,
		 'subCuenta1' as control;
	LEAVE TerminaStore;
end if;

if not exists (select ConceptoCarID, MonedaID from SUBCTAMONEDACART
				where ConceptoCarID=Par_ConceptoCarID and MonedaID=Par_MonedaID) then
		select '005' as NumErr,
				 'El Registro No Existe.' as ErrMen,
				 'monedaID' as control;
			LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

update SUBCTAMONEDACART set
		ConceptoCarID	= Par_ConceptoCarID,
		MonedaID		= Par_MonedaID,
		SubCuenta		= Par_SubCuenta	,

		EmpresaID		= Aud_EmpresaID,
		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where  ConceptoCarID = Par_ConceptoCarID
	and	 MonedaID		= Par_MonedaID;

select '000' as NumErr ,
	  concat("Subcuenta Modificada Exitosamente: ",convert(Par_ConceptoCarID,char)) as ErrMen,
	  'subCuenta1' as control;

END TerminaStore$$