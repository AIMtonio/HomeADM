-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPCAJADIVMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPCAJADIVMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPCAJADIVMOD`(
	Par_ConceptoMonID	int(11),
	Par_TipoCaja		varchar(2),
	Par_SubCuenta		varchar(15),

	Par_Salida			char(1),
	inout Par_NumErr	int,
	inout Par_ErrMen	varchar(350),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore:BEGIN


DECLARE		Cadena_Vacia	char(1);
DECLARE		Entero_Cero		int;
DECLARE 	Salida_SI       char(1);
DECLARE		Salida_NO       char(1);


Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set Salida_SI			:= 'S';
Set Salida_NO			:= 'N';

ManejoErrores: BEGIN


set Par_NumErr  := Entero_Cero;
set Par_ErrMen  := Cadena_Vacia;
set Aud_FechaActual := now();


if(ifnull(Par_ConceptoMonID, Entero_Cero))= Entero_Cero then
	set Par_NumErr	:= 1;
	set Par_ErrMen	:=' El Concepto esta vacio';
	LEAVE TerminaStore;
end if;
if(ifnull(Par_TipoCaja, Cadena_Vacia))= Cadena_Vacia then
	set Par_NumErr	:= 2;
	set Par_ErrMen	:='El tipo de Caja esta vacio';
	LEAVE TerminaStore;
end if;
if(ifnull(Par_SubCuenta, Entero_Cero))= Entero_Cero then
	set Par_NumErr	:= 3;
	set Par_ErrMen	:=' La Subcuenta esta vacia';
	LEAVE TerminaStore;
end if;
	update SUBCTATIPCAJADIV set
		ConceptoMonID	= Par_ConceptoMonID,
		TipoCaja		=Par_TipoCaja,
		SubCuenta		=Par_SubCuenta,

		EmpresaID		=Par_EmpresaID,
		Usuario			=Aud_Usuario,
		FechaActual		=Aud_FechaActual,
		DireccionIP		=Aud_DireccionIP,
		ProgramaID		=Aud_ProgramaID,
		Sucursal		=Aud_Sucursal,
		NumTransaccion	=Aud_NumTransaccion

	where ConceptoMonID =Par_ConceptoMonID
		and TipoCaja	=Par_TipoCaja;

set Par_NumErr		:= 0;
set Par_ErrMen		:=' SubCuenta  Contable Modificada';

END ManejoErrores;

	if (Par_Salida = Salida_SI) then
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				'tipoCaja' as control,
				Par_ConceptoMonID as consecutivo;
	end if;

end TerminaStore$$