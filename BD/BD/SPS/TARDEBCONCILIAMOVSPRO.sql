-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCILIAMOVSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONCILIAMOVSPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONCILIAMOVSPRO`(
	Par_NumMovID		int,
	Par_FolioCargaID	int,
	Par_DetalleID		int,
	Par_NumTrans		int,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN
DECLARE Cadena_Vacia	char(1);
DECLARE Entero_Cero		int;
DECLARE Par_NumErr		int;
DECLARE Par_ErrMen		varchar(100);
DECLARE Var_Control		varchar(20);
DECLARE Salida_NO		char(1);

Set Cadena_Vacia	:= '';
Set Entero_Cero		:= 0;
Set Salida_NO 		:= 'N';

	ManejoErrores: BEGIN



		CALL TARDEBBITACORAMOVSACT(
			Par_NumMovID, 	Par_FolioCargaID, 	Par_DetalleID, 	Par_NumTrans,	Salida_NO,
			Par_NumErr,		Par_ErrMen, 		Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
			Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		CALL TARDEBCONCILIADETAACT(
			Par_NumMovID, 	Par_FolioCargaID, 	Par_DetalleID, 	Par_NumTrans,	Salida_NO,
			Par_NumErr,		Par_ErrMen, 		Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
			Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
		Set	Par_NumErr	:= Entero_Cero ;
		Set Par_ErrMen	:= 'Conciliacion Realizada Correctamente';
		Set Var_Control := Cadena_Vacia;

	END ManejoErrores;

	SELECT Par_NumErr as NumErr,
		Par_ErrMen	as ErrMen,
		Var_Control as control,
		Entero_Cero as consecutivo;

END TerminaStore$$