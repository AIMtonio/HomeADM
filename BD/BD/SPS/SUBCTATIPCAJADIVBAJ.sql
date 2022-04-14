-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPCAJADIVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPCAJADIVBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPCAJADIVBAJ`(
	Par_ConceptoMonID	int(11),
	Par_TipoCaja		char(2),

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
TerminaStore:Begin

DECLARE		Cadena_Vacia	char(1);
DECLARE		Entero_Cero		int;
DECLARE 	Salida_SI       char(1);
DECLARE 	Salida_NO       char(1);


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

 DELETE FROM SUBCTATIPCAJADIV
		where ConceptoMonID = Par_ConceptoMonID
			 and  TipoCaja=Par_TipoCaja;


set Par_NumErr		:= 0;
set Par_ErrMen		:=' SubCuenta Contable Eliminada';

END ManejoErrores;
	if (Par_Salida = Salida_SI) then
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				'tipoCaja' as control,
				Entero_Cero as consecutivo;
	end if;
end TerminaStore$$