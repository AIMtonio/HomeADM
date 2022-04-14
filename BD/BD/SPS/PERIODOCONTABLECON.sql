-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERIODOCONTABLECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PERIODOCONTABLECON`;
DELIMITER $$


CREATE PROCEDURE `PERIODOCONTABLECON`(
	Par_EjercicioID		int,
	Par_PeriodoID		int,
	Par_Fecha			date,
	Par_EmpresaID		int,
	Par_NumCon			tinyint unsigned,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
)

TerminaStore: BEGIN


DECLARE	Cadena_Vacia	 char(1);
DECLARE	Fecha_Vacia		 date;
DECLARE	Entero_Cero		 int;
DECLARE Est_Cerrado		 CHAR(1);
DECLARE	Con_Principal	 int;
DECLARE	Con_Vigente		 int;
DECLARE	Con_Foranea		 int;
DECLARE Var_PrimerDiaMes date;
DECLARE Var_FechaInicio  DATE;
DECLARE Con_FechaEst	 int;
DECLARE Con_FechaPerCon	 int;
DECLARE Con_Ejercicio	 int;

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Con_Principal		:= 1;
Set	Con_Vigente			:= 2;
Set	Con_Foranea			:= 3;
Set Con_FechaEst		:= 4;
SET	Con_FechaPerCon     := 5;
SET	Con_Ejercicio     	:= 6;
SET Est_Cerrado			:= 'C';

if(Par_NumCon = Con_Principal) then
	select 	EjercicioID, PeriodoID, 		TipoPeriodo, Inicio, Fin,
			FechaCierre,	UsuarioCierre,	Estatus
		from PERIODOCONTABLE
		where EjercicioID = Par_EjercicioID
		  and PeriodoID = Par_PeriodoID;
end if;

if(Par_NumCon = Con_Vigente) then
	select 	EjercicioID, PeriodoID, 		TipoPeriodo, Inicio, Fin,
			FechaCierre,	UsuarioCierre,	Estatus
		from PERIODOCONTABLE,
			PARAMETROSSIS Par
		where EjercicioID = EjercicioVigente
		  and PeriodoID = PeriodoVigente;
end if;

if(Par_NumCon = Con_Foranea) then
	select 	EjercicioID, PeriodoID, 		Inicio, Fin,
			Estatus
		from PERIODOCONTABLE
		where EjercicioID = Par_EjercicioID
		  and PeriodoID = Par_PeriodoID;
end if;
if(Par_NumCon = Con_FechaEst) then
set Var_PrimerDiaMes:= convert(DATE_ADD(Par_Fecha, interval -1*(day(Par_Fecha))+1 day),date);
 select 	Estatus
		from PERIODOCONTABLE
		where Inicio = Var_PrimerDiaMes;
end if;

IF(Par_NumCon = Con_FechaPerCon) THEN
	SELECT 	max(Inicio)
		INTO Var_FechaInicio
		FROM PERIODOCONTABLE
	WHERE 	Inicio <= Par_Fecha
	AND Estatus != Est_Cerrado;

	SET Var_FechaInicio := IFNULL(Var_FechaInicio, Fecha_Vacia);

	SELECT Var_FechaInicio;

END IF;

IF(Par_NumCon = Con_Ejercicio) THEN
	SELECT 	 EjercicioID, PeriodoID, Inicio, 	Fin, 	Estatus
	FROM PERIODOCONTABLE
	WHERE EjercicioID = Par_EjercicioID
	AND PeriodoID = 12;

END IF;






END TerminaStore$$