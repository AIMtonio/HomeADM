-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPCAJADIVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPCAJADIVALT`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPCAJADIVALT`(
	Par_ConceptoMonID	int(11),
	Par_TipoCaja		char(2),
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
	insert into SUBCTATIPCAJADIV (
				ConceptoMonID,		TipoCaja,			SubCuenta,		EmpresaID,		Usuario,
				FechaActual,		DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
		values	(Par_ConceptoMonID,	Par_TipoCaja,		Par_SubCuenta,	Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

set Par_NumErr		:= 0;
set Par_ErrMen		:='Subcuenta Agregada ';

END ManejoErrores;

	if (Par_Salida = Salida_SI) then
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				'tipoCaja' as control,
				Entero_Cero as consecutivo;
	end if;

end TerminaStore$$