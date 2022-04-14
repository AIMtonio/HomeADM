-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDAKUBOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAMONEDAKUBOALT`;DELIMITER $$

CREATE PROCEDURE `SUBCTAMONEDAKUBOALT`(
	Par_ConceptoKuboID	int(11),
	Par_MonedaID		int(11),
	Par_SubCuenta	 	char(2),

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

if(ifnull(Par_ConceptoKuboID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta Vacio.' as ErrMen,
		 'ConceptoKuboID' as control;
	LEAVE TerminaStore;

end if;if(ifnull(Aud_EmpresaID, Entero_Cero))= Entero_Cero then
	select '002' as NumErr,
		 'El Numero de Empresa esta Vacio.' as ErrMen,
		 'empresaID' as control;
	LEAVE TerminaStore;

end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into SUBCTAMONEDAKUBO
			values (  	Par_ConceptoKuboID,	 	Par_MonedaID,		Par_SubCuenta,
					Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion
					);
select '000' as NumErr,
	  concat("Subcuenta Agregada: ", convert(Par_ConceptoKuboID, CHAR))  as ErrMen,
	  'ConceptoKuboID' as control;
END TerminaStore$$