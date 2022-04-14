-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPRODUCCARTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPRODUCCARTALT`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPRODUCCARTALT`(
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
DECLARE		NumSubCuenta			int;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Float_Cero			:= 0.0;
Set 	NumSubCuenta			:= 0;

if(ifnull(Par_ConceptoCarID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta Vacio.' as ErrMen,
		 'conceptoCarnID' as control;
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

if exists (select ConceptoCarID, ProducCreditoID from SUBCTAPRODUCCART
				where ConceptoCarID=Par_ConceptoCarID
					and ProducCreditoID=Par_ProducCreditoID) then
			select '005' as NumErr,
					 'El Registro ya Existe.' as ErrMen,
					 'producCreditoID' as control;
				LEAVE TerminaStore;
end if;
Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into SUBCTAPRODUCCART
			values (  	Par_ConceptoCarID,	 	Par_ProducCreditoID,		Par_SubCuenta,
					Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion
					);
select '000' as NumErr,
	  concat("Subcuenta Agregada Exitosamente: ", convert(Par_ConceptoCarID, CHAR))  as ErrMen,
	  'subCuenta' as control;
END TerminaStore$$