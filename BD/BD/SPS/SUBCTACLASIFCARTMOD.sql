-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACLASIFCARTMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTACLASIFCARTMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTACLASIFCARTMOD`(
	Par_ConceptoCarID	int(11),
	Par_Consumo	 		char(2),
	Par_Comercial		char(2),
	Par_Vivienda 		char(2),

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

end if;if(ifnull(Aud_EmpresaID, Entero_Cero))= Entero_Cero then
	select '002' as NumErr,
		 'El Numero de Empresa esta Vacio.' as ErrMen,
		 'empresaID' as control;
	LEAVE TerminaStore;
end if;
Set Aud_FechaActual := CURRENT_TIMESTAMP();

update SUBCTACLASIFCART set
		ConceptoCarID	= Par_ConceptoCarID,
		Consumo			= Par_Consumo,
		Comercial		= Par_Comercial,
		Vivienda 		= Par_Vivienda,

		EmpresaID		= Aud_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where  ConceptoCarID = Par_ConceptoCarID;

select '000' as NumErr ,
	  concat("SubCuenta Modificada Exitosamente: ",convert(Par_ConceptoCarID,char)) as ErrMen,
	  'consumo' as control;

END TerminaStore$$