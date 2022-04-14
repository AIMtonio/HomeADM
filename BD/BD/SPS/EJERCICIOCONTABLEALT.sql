-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EJERCICIOCONTABLEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EJERCICIOCONTABLEALT`;DELIMITER $$

CREATE PROCEDURE `EJERCICIOCONTABLEALT`(
	Par_TipoEjercicio	char(1),
	Par_Inicio			date,
	Par_Fin				date,


	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)
	)
TerminaStore: BEGIN

DECLARE 	Var_EjercicioID 	int;
DECLARE 	Var_FinAnteri	date;
DECLARE 	Var_SigDiaHabil	date;
DECLARE 	Var_EsHabil		char(1);

DECLARE	Estatus_Vigente	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Entero_Uno		int;
DECLARE	Act_Ejercicio	int;

Set	Estatus_Vigente		:= 'N';
Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Entero_Uno			:= 1;
Set	Act_Ejercicio		:= 1;

if( Par_Inicio >= Par_Fin) then
	select '001' as NumErr,
		 'Error en las Fechas de Inicio y Fin.' as ErrMen,
		 'inicioEjercicio' as control;
	LEAVE TerminaStore;
end if;


set Var_FinAnteri := (select ifnull(Max(Fin),Fecha_Vacia)
					from EJERCICIOCONTABLE);

set Var_EjercicioID := (select ifnull(Max(EjercicioID),Entero_Cero) + 1
					from EJERCICIOCONTABLE);
set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into EJERCICIOCONTABLE
				(EjercicioID,		TipoEjercicio,		Inicio,			Fin,				FechaCierre,
				UsuarioCierre,		Estatus,			EmpresaID,		Usuario,			FechaActual,
				DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion)
		values   (
				Var_EjercicioID,	Par_TipoEjercicio,	Par_Inicio,		Par_Fin, 			Fecha_Vacia,
				Entero_Cero,		Estatus_Vigente, 	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


call PARAMETROSSISACT(
	Entero_Cero,	Fecha_Vacia,	Entero_Cero,	Cadena_Vacia,	Cadena_Vacia,
	Entero_Cero,	Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,	Entero_Cero,
	Var_EjercicioID,	Entero_Cero,	Act_Ejercicio,	Aud_Usuario,	Aud_FechaActual,
	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);




select '000' as NumErr,
	  "Ejercicio Actualizado: " as ErrMen,
	  'inicioEjercicio' as control,
	  Var_EjercicioID as consecutivo;


END TerminaStore$$