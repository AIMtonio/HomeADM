-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCARMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORCARMOD`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORCARMOD`(
	Par_ConceptoCarID	int(11),
	Par_Cuenta			char(4),
	Par_Nomenclatura 	varchar(60),
	Par_NomenclaturaCR 	varchar(60),

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


if(ifnull(Par_ConceptoCarID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta Vacio.' as ErrMen,
		 'conceptoCarID' as control;
	LEAVE TerminaStore;

end if
;if(ifnull(Aud_EmpresaID, Entero_Cero))= Entero_Cero then
	select '002' as NumErr,
		 'El Numero de Empresa esta Vacio.' as ErrMen,
		 'empresaID' as control;
	LEAVE TerminaStore;

end if;

if(ifnull(Par_Cuenta, Cadena_Vacia))= Cadena_Vacia then
	select '003' as NumErr,
		 'La Cuenta esta Vacia.' as ErrMen,
		 'cuenta' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Nomenclatura, Cadena_Vacia))= Cadena_Vacia then
	select '004' as NumErr,
		 'La Nomenclatura esta Vacia.' as ErrMen,
		 'nomenclatura' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NomenclaturaCR, Cadena_Vacia))= Cadena_Vacia then
	select '004' as NumErr,
		 'La Nomenclatura esta Vacia.' as ErrMen,
		 'nomenclatura' as control;
	LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();
update CUENTASMAYORCAR set
		ConceptoCarID	= Par_ConceptoCarID,
		Cuenta		= Par_Cuenta,
		Nomenclatura	= Par_Nomenclatura,
		NomenclaturaCR	= Par_NomenclaturaCR,

	  EmpresaID		= Aud_EmpresaID,
		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where  ConceptoCarID 	= Par_ConceptoCarID;

select '000' as NumErr ,
	  concat("Cuenta Modificada Exitosamente: ",convert(Par_ConceptoCarID,char)) as ErrMen,
	  'conceptoCarID' as control;

END TerminaStore$$