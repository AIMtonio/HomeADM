-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EJERCICIOCONTABLECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EJERCICIOCONTABLECON`;DELIMITER $$

CREATE PROCEDURE `EJERCICIOCONTABLECON`(
	Par_EjercicioID 	int,
	Par_TipoEjercicio	char(1),
	Par_Inicio			date,
	Par_Fin			date,
	Par_EmpresaID		int,
	Par_NumConsul		tinyint unsigned,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Vigente		int;
DECLARE	Con_Ejercicio		int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Vigente		:= 1;
Set	Con_Ejercicio		:= 2;


if(Par_NumConsul = Con_Vigente) then
	select EjercicioID, TipoEjercicio, Inicio, Fin
	from  EJERCICIOCONTABLE Eje,
		PARAMETROSSIS Par
	where EjercicioID 	 = EjercicioVigente;
end if;


if(Par_NumConsul = Con_Ejercicio) then
	select 	EjercicioID, 	TipoEjercicio, Inicio, Fin
	from EJERCICIOCONTABLE
	where EjercicioID = Par_EjercicioID;
end if;

END TerminaStore$$