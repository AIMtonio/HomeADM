-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFECHACONTRATOSOFINI
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHACONTRATOSOFINI`;DELIMITER $$

CREATE FUNCTION `FNFECHACONTRATOSOFINI`(
-- Funcion que formatea la fecha del contrato de SOFINI
	Par_Fecha  DATE
) RETURNS varchar(500) CHARSET latin1
    DETERMINISTIC
BEGIN

	-- Declaracion de variables
	DECLARE Var_FechaCompleta VARCHAR(500);
	DECLARE Var_Dia				INT(2);
	DECLARE Var_Mes				INT(2);
	DECLARE Var_Anio			INT(4);
	DECLARE Var_DiaNombre		VARCHAR(20);
	DECLARE Var_MesNombre		VARCHAR(20);
	DECLARE Var_AnioNombre		VARCHAR(30);

	SET Var_Dia 		:= DAY(Par_Fecha);
	SET Var_Mes 		:= MONTH(Par_Fecha);
	SET Var_Anio 		:= YEAR(Par_Fecha);

	SET Var_DiaNombre :=
					CASE
						WHEN Var_Dia = 1 THEN 'Primer'
						WHEN Var_Dia = 2 THEN 'Segundo'
						WHEN Var_Dia = 3 THEN 'Tercer'
						WHEN Var_Dia = 4 THEN 'Cuarto'
						WHEN Var_Dia = 5 THEN 'Quinto'
						WHEN Var_Dia = 6 THEN 'Sexto'
						WHEN Var_Dia = 7 THEN 'Septimo'
						WHEN Var_Dia = 8 THEN 'Octavo'
						WHEN Var_Dia = 9 THEN 'Noveno'
						WHEN Var_Dia = 10 THEN 'Decimo'
						WHEN Var_Dia = 11 THEN 'Decimo primer'
						WHEN Var_Dia = 12 THEN 'Decimo segundo'
						WHEN Var_Dia = 13 THEN 'Decimo tercer'
						WHEN Var_Dia = 14 THEN 'Decimo cuarto'
						WHEN Var_Dia = 15 THEN 'Decimo quinto'
						WHEN Var_Dia = 16 THEN 'Decimo sexto'
						WHEN Var_Dia = 17 THEN 'Decimo septimo'
						WHEN Var_Dia = 18 THEN 'Decimo octavo'
						WHEN Var_Dia = 19 THEN 'Decimo noveno'
						WHEN Var_Dia = 20 THEN 'Vigesimo'
						WHEN Var_Dia = 21 THEN 'Vigesimo primer'
						WHEN Var_Dia = 22 THEN 'Vigesimo segundo'
						WHEN Var_Dia = 23 THEN 'Vigesimo tercer'
						WHEN Var_Dia = 24 THEN 'Vigesimo cuarto'
						WHEN Var_Dia = 25 THEN 'Vigesimo quinto'
						WHEN Var_Dia = 26 THEN 'Vigesimo sexto'
						WHEN Var_Dia = 27 THEN 'Vigesimo septimo'
						WHEN Var_Dia = 28 THEN 'Vigesimo octavo'
						WHEN Var_Dia = 29 THEN 'Vigesimo noveno'
						WHEN Var_Dia = 30 THEN 'Trigesimo'
						WHEN Var_Dia = 31 THEN 'Trigesimo primer'
					END;

	SET Var_MesNombre	:=
			CASE
				WHEN Var_Mes = 1 THEN 'Enero'
				WHEN Var_Mes = 2 THEN 'Febrero'
				WHEN Var_Mes = 3 THEN 'Marzo'
				WHEN Var_Mes = 4 THEN 'Abril'
				WHEN Var_Mes = 5 THEN 'Mayo'
				WHEN Var_Mes = 6 THEN 'Junio'
				WHEN Var_Mes = 7 THEN 'Julio'
				WHEN Var_Mes = 8 THEN 'Agosto'
				WHEN Var_Mes = 9 THEN 'Septiembre'
				WHEN Var_Mes = 10 THEN 'Octubre'
				WHEN Var_Mes = 11 THEN 'Noviembre'
				WHEN Var_Mes = 12 THEN 'Diciembre'
			END;

	SET Var_AnioNombre := FUNCIONNUMEROSLETRAS(Var_Anio);

	SET Var_FechaCompleta := CONCAT(Var_Dia,' (',Var_DiaNombre,') dia del mes de ',Var_MesNombre , ' del año ', Var_Anio,' (',FNCAPITALIZAPALABRA(Var_AnioNombre),')');

	RETURN Var_FechaCompleta;
END$$