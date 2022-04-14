-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPRODUCCARTMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPRODUCCARTMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPRODUCCARTMOD`(
	Par_ConceptoCarID	int(11),
	Par_ProducCreditoID	int(11),
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

Set Par_ProducCreditoID := ifnull(Par_ProducCreditoID,Entero_Cero);
if(Par_ProducCreditoID=Entero_Cero) then
	select '002' as NumErr,
		 'El producto de Credito esta Vacio.' as ErrMen,
		 'producCreditoID' as control;
	LEAVE TerminaStore;
end if;

Set Par_SubCuenta := ifnull(Par_SubCuenta,Cadena_Vacia);
if(Par_SubCuenta=Cadena_Vacia) then
	select '003' as NumErr,
		 'La Subcuenta esta Vacia.' as ErrMen,
		 'producCreditoID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Aud_EmpresaID, Entero_Cero))= Entero_Cero then
	select '004' as NumErr,
		 'El Numero de Empresa esta Vacio.' as ErrMen,
		 'empresaID' as control;
	LEAVE TerminaStore;
end if;

if not exists (select ConceptoCarID, ProducCreditoID from SUBCTAPRODUCCART
				where ConceptoCarID=Par_ConceptoCarID
					and ProducCreditoID=Par_ProducCreditoID) then
			select '005' as NumErr,
					 'El Registro No Existe.' as ErrMen,
					 'producCreditoID' as control;
				LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

update SUBCTAPRODUCCART set
		ConceptoCarID	= Par_ConceptoCarID,
		ProducCreditoID	= Par_ProducCreditoID	,
		SubCuenta		= Par_SubCuenta	,

		EmpresaID		= Aud_EmpresaID,
		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where  ConceptoCarID = Par_ConceptoCarID
	and	   ProducCreditoID	= Par_ProducCreditoID	;

select '000' as NumErr ,
	  concat("Subcuenta Modificada Exitosamente: ",convert(Par_ConceptoCarID,char)) as ErrMen,
	  'subCuenta' as control;

END TerminaStore$$