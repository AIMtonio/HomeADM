-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERIODOCONTABLELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PERIODOCONTABLELIS`;DELIMITER $$

CREATE PROCEDURE `PERIODOCONTABLELIS`(
	Par_EjercicioID		int,
	Par_PeriodoID			int,
	Par_EmpresaID			int,
	Par_NumLis			tinyint unsigned,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal		int;
DECLARE	Lis_PorPeriodo	int;
DECLARE	Lis_Foranea		int;
DECLARE	Lis_PeriodoPorCerrar		int;
DECLARE	Lis_PeriodoCerrado		int;
DECLARE	NoCerrado		char(1);
DECLARE	Cerrado		char(1);


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia	:= '1900-01-01';
Set	Entero_Cero	:= 0;
Set	Lis_Principal	:= 1;
Set	Lis_PorPeriodo	:= 2;
Set	Lis_Foranea	:= 3;
Set	Lis_PeriodoPorCerrar:= 4;
Set	Lis_PeriodoCerrado	:= 5;
Set	NoCerrado	:= 'N';
Set	Cerrado	:= 'C';

if(Par_NumLis = Lis_Principal) then
	select 	EjercicioID, 	PeriodoID, Inicio, Fin,
			FechaCierre,	UsuarioCierre,	Estatus
		from PERIODOCONTABLE
		where EjercicioID = Par_EjercicioID;
end if;

if(Par_NumLis = Lis_PorPeriodo) then
	select 	EjercicioID, 	PeriodoID, Inicio, Fin,
			FechaCierre,	UsuarioCierre,	Estatus
		from PERIODOCONTABLE
		where EjercicioID	= Par_EjercicioID
		and	  PeriodoID	= Par_PeriodoID;
end if;

if(Par_NumLis = Lis_Foranea) then
	select 	PeriodoID
		from PERIODOCONTABLE
		where EjercicioID	= Par_EjercicioID;
end if;

if(Par_NumLis = Lis_PeriodoPorCerrar) then
	select 	EjercicioID, 	PeriodoID, Inicio, Fin,
			FechaCierre,	UsuarioCierre,	Estatus
		from PERIODOCONTABLE
		where EjercicioID	= Par_EjercicioID
		and   Estatus	= NoCerrado
        limit 1;
end if;

if(Par_NumLis = Lis_PeriodoCerrado) then
	select 	EjercicioID, 	PeriodoID, Inicio, Fin,
			FechaCierre,	UsuarioCierre,	Estatus
		from PERIODOCONTABLE
		where EjercicioID	= Par_EjercicioID
		and 	  Estatus	= Cerrado;
end if;

END TerminaStore$$