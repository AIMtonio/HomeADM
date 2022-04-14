-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSFECHASCALENDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSFECHASCALENDPRO`;DELIMITER $$

CREATE PROCEDURE `SMSFECHASCALENDPRO`(
	Par_Periodicid		char(1),		-- Periodicidad  (Semanal (S), Quincenal (Q), Mensual(M), B.-Bimestral , A.-Anual)
	Par_FechaInicio		date,			-- fecha de inicio de envio
	Par_FechaFin		date,			-- fecha de fin de envio
	Par_Campania		int,
	Par_ArchCargaID		int,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE		Var_NoMsjEnv	int;
DECLARE 		FechaInicio		date;
DECLARE 		FechaFin		date;

-- Declaracion de Constantes
DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE  		SalidaSI		char(1);
DECLARE  		SalidaNO		char(1);
DECLARE 		NumErr   		 int;
DECLARE 		ErrMen    		varchar(400);
DECLARE		FrecuenDias		int;
DECLARE		Contador		int;
DECLARE		FrecDiario		char(1);
DECLARE		FrecSemanal		char(1);
DECLARE		DiasDiario		int;
DECLARE		DiasSemanal		int;
DECLARE		FrecQuincenal	char(1);
DECLARE		DiasQuincenal	int;
DECLARE		FrecMensual		char(1);
DECLARE		DiasMensual		int;
DECLARE		FrecBimestral	char(1);
DECLARE		DiasBimestral	int;
DECLARE		FrecAnual		char(1);
DECLARE		DiasAnual		int;


-- Asignacion de Constantes
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set SalidaSI		:='S';
Set SalidaNO		:='N';
Set NumErr   		:= 0;
Set ErrMen 			:= '';
Set	FrecDiario		:= 'D';
Set	FrecSemanal		:= 'S';
Set	DiasDiario		:= 1;
Set	DiasSemanal		:= 7;
Set	FrecQuincenal	:= 'Q';
Set	DiasQuincenal	:= 15;
Set	FrecMensual		:= 'M';
Set	DiasMensual		:= 30;
Set	FrecBimestral	:= 'B';
Set	DiasBimestral	:= 60;
Set	FrecAnual		:= 'A';
Set	DiasAnual		:= 365;

set FechaInicio		:= Par_FechaInicio;

if exists(select ifnull(ArchivoCargaID,Entero_Cero)
			FROM SMSCALENDARIO
			where ArchivoCargaID = Par_ArchCargaID) then

	Set Aud_FechaActual := CURRENT_TIMESTAMP();

	CALL SMSCALENDARIOBAJ(Par_ArchCargaID,	Par_Campania,	SalidaNO,			NumErr,				ErrMen,
						   Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						   Aud_Sucursal,	Aud_NumTransaccion);

end if;


-- Compara el valor de periodicidad de envio para asignarle un valor en dias en caso de quincenales y semanales
	if (Par_Periodicid = FrecQuincenal) then
		set FrecuenDias	:= DiasQuincenal;
	else
		if (Par_Periodicid = FrecSemanal) then
			set FrecuenDias	:= DiasSemanal;
		else
			if (Par_Periodicid = FrecDiario) then
				set FrecuenDias	:= DiasDiario;
			else
				if (Par_Periodicid = FrecMensual) then
					set FrecuenDias	:= DiasMensual;
				else
					if (Par_Periodicid = FrecBimestral) then
						set FrecuenDias	:= DiasBimestral;
					else
						if (Par_Periodicid = FrecAnual) then
							set FrecuenDias	:= DiasAnual;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;

-- Numero de envios a insertar
if ifnull(FrecuenDias,Entero_Cero) = Entero_Cero then
	set Var_NoMsjEnv:=(DATEDIFF(Par_FechaFin,Par_FechaInicio)/FrecuenDias);
else
	set Var_NoMsjEnv:= Entero_Cero;
end if;


Set Contador := 1;

-- select Var_NoMsjEnv;

-- se calculan las Fechas
while (Contador <= Var_NoMsjEnv ) do
	 -- envios semanales
	if (Par_Periodicid = FrecSemanal ) then
				set FechaFin 	:= DATE_ADD(FechaInicio, INTERVAL FrecuenDias DAY);
	else
		-- envios diarios
		if (Par_Periodicid = FrecDiario ) then
				set FechaFin 	:= DATE_ADD(FechaInicio, INTERVAL FrecuenDias DAY);
		else
			-- envios quincenales
			if (Par_Periodicid = FrecQuincenal) then
				if (day(FechaInicio) = 15) then
					set FechaFin 	:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
				else
					if (day(FechaInicio) >28) then
						set FechaFin := convert(concat(year(DATE_ADD(FechaInicio, interval 1 month)) , '-' ,
											month(DATE_ADD(FechaInicio, interval 1 month)), '-' , '15'),date);
					else
						set FechaFin 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL day(FechaInicio) day), INTERVAL 15 DAY);
						if  (FechaFin <= FechaInicio) then
							set FechaFin := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)) , '-' ,
													month(DATE_ADD(FechaInicio, interval 1 month)) , '-' , '15'),date);
						end	if;
					end	if;
				end if;
			end if;
		end if;
		-- envios Mensuales
		if (Par_Periodicid = FrecMensual) then
				set FechaFin := convert(	DATE_ADD(FechaInicio, interval 1 month) ,date);
		end if;

			-- envios Bimestrales
		if (Par_Periodicid = FrecBimestral) then
				set FechaFin := convert(	DATE_ADD(FechaInicio, interval 2 month) ,date);
		end if;

			-- envios Anuales
		if (Par_Periodicid = FrecAnual) then
				set FechaFin := convert(	DATE_ADD(FechaInicio, interval 1 year) ,date);
		end if;

	end if;

	if( FechaFin <=   Par_FechaFin)then

	Set Aud_FechaActual := CURRENT_TIMESTAMP();

		INSERT INTO `SMSCALENDARIO`
									(`CalendarioID`,	`FechaEnvio`,		`CampaniaID`,		`ArchivoCargaID`,	`EmpresaID`,
									 `Usuario`,			`FechaActual`,		`DireccionIP`,		`ProgramaID`,		`Sucursal`,
									`NumTransaccion`)
									VALUES
									(Contador,			FechaFin,			Par_Campania,		Par_ArchCargaID,		Par_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
									Aud_NumTransaccion);

	end if;

-- Si la fecha de fin calculada es mayor o igual a la de final real, incrementa el contador para finalizar
	if( FechaFin >=  Par_FechaFin)then
		set Contador := Var_NoMsjEnv;
	end if;


set FechaInicio := FechaFin;
set Contador = Contador+1;

end while;

 select CalendarioID,	FechaEnvio, Aud_NumTransaccion
	from SMSCALENDARIO
	where NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$