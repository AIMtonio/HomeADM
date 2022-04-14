-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORAHOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORAHOMOD`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORAHOMOD`(
	Par_ConceptoAhoID	int(5),
	Par_EmpresaID 		int(11),
	Par_Cuenta			char(4),
	Par_Nomenclatura 	varchar(30),
	Par_NomenclaturaCR 	varchar(30),

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

Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;


if(ifnull(Par_ConceptoAhoID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta Vacio.' as ErrMen,
		 'conceptoAhoID' as control;
	LEAVE TerminaStore;

end if
;

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
update CUENTASMAYORAHO set
		ConceptoAhoID	= Par_ConceptoAhoID,
		EmpresaID		= Par_EmpresaID,
		Cuenta		= Par_Cuenta,
		Nomenclatura	= Par_Nomenclatura,
		NomenclaturaCR	= Par_NomenclaturaCR,

		EmpresaID		= Par_EmpresaID,
		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where  ConceptoAhoID 	= Par_ConceptoAhoID;

select '000' as NumErr ,
	  'Cuenta Contable Modificada Exitosamente.' as ErrMen,
	  'tipoCuentaID' as control;

END TerminaStore$$