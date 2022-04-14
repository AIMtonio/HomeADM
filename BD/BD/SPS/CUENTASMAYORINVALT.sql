-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORINVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORINVALT`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORINVALT`(
	Par_ConceptoInvID	int(5),
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
DECLARE		Numero			int;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Float_Cero			:= 0.0;
set 	Numero			:= 0;

if(ifnull(Par_ConceptoInvID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Concepto esta Vacio.' as ErrMen,
		 'conceptoInvID' as control;
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
		 'La Nomenclatura Costos esta Vacia.' as ErrMen,
		 'nomenclaturaCR' as control;
	LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();
insert into CUENTASMAYORINV
			values (  	Par_ConceptoInvID,		Par_Cuenta,			Par_Nomenclatura,
					Par_NomenclaturaCR,
					Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion
					);
select '000' as NumErr,
	  concat("Cuenta Agregada: ", convert(Par_ConceptoInvID, CHAR))  as ErrMen,
	  'conceptoInvID' as control;

END TerminaStore$$