-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASFESTIVOSINVERSA
DELIMITER ;
DROP FUNCTION IF EXISTS `DIASFESTIVOSINVERSA`;DELIMITER $$

CREATE FUNCTION `DIASFESTIVOSINVERSA`(
	Par_Fecha			date,
	Par_NumDias			int,

	Par_HabilDomingo	Char(1),
	Par_HabilSabado		Char(1)
) RETURNS date
    DETERMINISTIC
BEGIN

DECLARE FechaFinal		date;
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int(1);
DECLARE Dias_Contador	int(11);
DECLARE Contador		int(11);
DECLARE DiaDomingo		int;
DECLARE DiaSabado		int;
DECLARE Var_Si			char(1);
DECLARE Var_No			char(1);
DECLARE	Entero_Uno		int(1);
declare var_Par_NumDias int(2);

Set	Cadena_Vacia	:=	'';
Set	Fecha_Vacia		:= 	'1900-01-01';
Set	Entero_Cero		:= 	0;
Set Dias_Contador	:=  0;
Set DiaDomingo		:=  1;
Set	DiaSabado		:=  2;
Set Var_Si			:=	'S';
Set	Var_No			:= 	'N';
Set Contador		:=	0;
Set Entero_Uno		:=  1;

set FechaFinal	:= Par_Fecha;

set Par_NumDias	:= ifnull(Par_NumDias,Entero_Cero);

if(Par_NumDias > Entero_Uno) then
	Set Par_NumDias := Par_NumDias - Entero_Uno;
end if;

set FechaFinal	:=date_add(Par_Fecha, INTERVAL -Par_NumDias DAY);

if(Par_HabilDomingo= Var_Si )then

			WHILE  Contador <= Par_NumDias  DO

				IF (SELECT ifnull(count(*),Entero_Cero)
					from DIASFESTIVOS
					where Fecha = FechaFinal) > 0 THEN
					SET Dias_Contador = Dias_Contador + 1;
				END IF;
					SET Contador := Contador +1;
					SET FechaFinal :=date_add(FechaFinal, INTERVAL +Entero_Uno DAY);
			END WHILE;
	else
		if(Par_HabilSabado = Var_Si) then

					WHILE  Contador <= Par_NumDias  DO

					IF (SELECT ifnull(count(*),Entero_Cero)
						from DIASFESTIVOS
						where Fecha = FechaFinal) > 0  OR
						DAYOFWEEK(FechaFinal) = 1  THEN

						SET Dias_Contador = Dias_Contador + 1;
					end if;

				SET Contador := Contador +1;
				SET FechaFinal :=date_add(FechaFinal, INTERVAL +Entero_Uno DAY);

				END WHILE;
		else

			set var_Par_NumDias =0;
				IF (SELECT ifnull(count(*),Entero_Cero)
						from DIASFESTIVOS
						where Fecha = FechaFinal) > 0  THEN
				SET FechaFinal :=date_add(FechaFinal, INTERVAL -Entero_Uno DAY);
				set var_Par_NumDias = var_Par_NumDias+1;
				end if;

				if(DAYOFWEEK(FechaFinal) = 1) then
				SET FechaFinal :=date_add(FechaFinal, INTERVAL -2 DAY);
				set var_Par_NumDias = var_Par_NumDias+2;
				end if;

				if(DAYOFWEEK(FechaFinal) = 7 ) then
				SET FechaFinal :=date_add(FechaFinal, INTERVAL -Entero_Uno DAY);
				set var_Par_NumDias = var_Par_NumDias+1;
				end if;


			WHILE  Contador <= var_Par_NumDias  DO


					IF (SELECT ifnull(count(*),Entero_Cero)
						from DIASFESTIVOS
						where Fecha = FechaFinal) > 0  OR
						DAYOFWEEK(FechaFinal) = 1 OR
						DAYOFWEEK(FechaFinal) = 7 THEN

						SET Dias_Contador = Dias_Contador + 1;
					end if;

				SET Contador := Contador +1;
				SET FechaFinal :=date_add(FechaFinal, INTERVAL +Entero_Uno DAY);

				END WHILE;
		end if;
end if;

	 set Dias_Contador := Dias_Contador + Par_NumDias ;

set FechaFinal:=date_add(Par_Fecha, INTERVAL -Dias_Contador DAY);

RETURN FechaFinal;
END$$