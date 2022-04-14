-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFECHASCALENDARIONOMCAL
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHASCALENDARIONOMCAL`;
DELIMITER $$

CREATE FUNCTION `FNFECHASCALENDARIONOMCAL`(
-- FUNSION PARA EL EL CALCULO DE LA FECHA DE INICIO LA PRIMERA AMORTIZACION
	Par_ConvenioNominaID 	 BIGINT UNSIGNED,	-- CONVENNIO DE NOMINA
	Par_InstitNominaID 	 	 INT(11),			-- INSTITUCION DE NOMINA
	Par_FechaDesembolsoCre	 DATE				-- FECHA DEL SISTEMA
) RETURNS date
    DETERMINISTIC
BEGIN
-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT(11);
	DECLARE Entero_Err				INT(11);
    DECLARE Var_FechaInicioCre 		DATE;
	DECLARE Var_FechaVenc		 	DATE;

-- DECLARACION DE VARIABLES
	DECLARE Var_FechaMes			INT(11);
	DECLARE Var_FechaAnio			INT(11);
	DECLARE Var_ManejaCalendario	CHAR(1);
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_FechaLimite			DATE;
	DECLARE Var_InstitNominaID		INT(11);
	DECLARE Var_ManejaFechaIniCal	CHAR(1);
	DECLARE Var_No					CHAR(1);
	DECLARE Var_Si					CHAR(1);
	DECLARE Var_NumCuotas			INT(11);
	DECLARE Var_CuotaID				INT(11);

	DECLARE Var_Activo				CHAR(1);
	DECLARE Entero_Uno				INT(11);
	DECLARE Es_DiaHabil				CHAR(1);
	DECLARE Var_Control				VARCHAR(20);
    DECLARE Var_FechaVencimiento	DATE;

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
    SET Entero_Err				:= -1;
	SET Entero_Cero				:= 0;
	SET Entero_Uno 				:= 1;
	SET Var_No					:= 'N';
	SET Var_Si					:= 'S';
	SET Var_Activo				:= 'A';

	SET Par_FechaDesembolsoCre	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	SET Var_FechaMes 			:= MONTH(Par_FechaDesembolsoCre);
	SET Var_FechaAnio 			:= YEAR(Par_FechaDesembolsoCre);
	SET Var_ManejaCalendario 	:= (SELECT ManejaCalendario FROM CONVENIOSNOMINA WHERE ConvenioNominaID = Par_ConvenioNominaID);
 	SET Var_ManejaCalendario	:= IFNULL(Var_ManejaCalendario,'N');
	SET Var_FechaSistema 		:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	SET Var_InstitNominaID		:= (SELECT IFNULL(InstitNominaID, Entero_Cero) FROM INSTITNOMINA WHERE InstitNominaID=Par_InstitNominaID);

	SET Par_ConvenioNominaID 	:= IFNULL(Par_ConvenioNominaID, Entero_Cero);
	SET Par_InstitNominaID 		:= IFNULL(Par_InstitNominaID, Entero_Cero);
    SET Var_FechaInicioCre		:= Fecha_Vacia;


	-- Si el Parametro Maneja Calendario esta encendido
	 IF(Var_ManejaCalendario = Var_Si) THEN

		 SET Var_ManejaFechaIniCal := (SELECT ManejaFechaIniCal FROM CONVENIOSNOMINA WHERE ConvenioNominaID = Par_ConvenioNominaID);
		 SET Var_ManejaFechaIniCal := IFNULL(Var_ManejaFechaIniCal, Var_No);
		 IF(Var_ManejaFechaIniCal = Var_No) THEN

			SET Var_FechaInicioCre := Par_FechaDesembolsoCre;
			/*****************FECHA DE VENCIMIENTO*******************/
			SELECT NumCuotas,CalendarioIngID
				INTO Var_NumCuotas, Var_CuotaID
			FROM CALENDARIOINGRESOS
			WHERE InstitNominaID = Par_InstitNominaID
			AND ConvenioNominaID = Par_ConvenioNominaID
			AND Anio >= Var_FechaAnio
			AND FechaLimiteEnvio > Par_FechaDesembolsoCre
			ORDER BY FechaLimiteEnvio ASC
			LIMIT 1;

			/*****************FECHA DE VENCIMIENTO*******************/

			SET Var_NumCuotas := IFNULL(Var_NumCuotas,Entero_Err);

			-- VALIDACION SI EL NUMERO DE CUOTAS ES 0
			IF(Var_NumCuotas = Entero_Cero) THEN

				SELECT FechaPrimerDesc
					INTO Var_FechaVenc
				FROM CALENDARIOINGRESOS
				WHERE InstitNominaID = Par_InstitNominaID
				AND ConvenioNominaID = Par_ConvenioNominaID
				AND Anio >= Var_FechaAnio
				AND FechaLimiteEnvio >Par_FechaDesembolsoCre
				ORDER BY FechaLimiteEnvio ASC
				LIMIT 1;


			END IF;

			-- VALIDACION SI EL NUMERO DE CUOTAS ES MAYOR A 0
			IF(Var_NumCuotas > Entero_Cero)THEN
				SET Var_CuotaID := Var_CuotaID + Var_NumCuotas;
                SELECT FechaPrimerDesc INTO Var_FechaVenc
					FROM CALENDARIOINGRESOS
					WHERE CalendarioIngID = Var_CuotaID
					AND InstitNominaID = Par_InstitNominaID
					AND ConvenioNominaID = Par_ConvenioNominaID;
			END IF;

            SET Var_FechaVenc := IFNULL(Var_FechaVenc, Fecha_Vacia);

		END IF; -- FIN MANEJA FECHA INICIAL NO


		-- MANEJA FECHA INICIAL SI
		IF(Var_ManejaFechaIniCal = Var_Si) THEN
			SET Var_NumCuotas := Entero_Err;
			SET Var_CuotaID	  := Entero_Err;

			SELECT NumCuotas, CalendarioIngID
				INTO Var_NumCuotas, Var_CuotaID
			FROM CALENDARIOINGRESOS
			WHERE InstitNominaID = Par_InstitNominaID
			AND ConvenioNominaID = Par_ConvenioNominaID
			AND Anio >= Var_FechaAnio
			AND FechaLimiteEnvio >Par_FechaDesembolsoCre
			ORDER BY FechaLimiteEnvio ASC
			LIMIT 1;

			SET Var_NumCuotas := IFNULL(Var_NumCuotas,Entero_Err);

			IF(Var_NumCuotas = Entero_Cero) THEN
				SELECT FechaLimiteEnvio, FechaPrimerDesc
					INTO Var_FechaLimite, Var_FechaVenc
				FROM CALENDARIOINGRESOS
				WHERE CalendarioIngID = Var_CuotaID;

				CALL DIASHABILFESTIVOSCAL(DATE_FORMAT(Var_FechaLimite, '%Y-%m-%d'), Entero_Uno,"DF", Var_FechaInicioCre, Es_DiaHabil, Entero_Cero,
										Entero_Cero, Fecha_Vacia, Cadena_Vacia,Cadena_Vacia, Entero_Cero,Entero_Cero);


			ELSE
				SET Var_CuotaID := Var_CuotaID + Var_NumCuotas;
				SELECT 	FechaLimiteEnvio,	FechaPrimerDesc
					INTO Var_FechaLimite, 	Var_FechaVenc
					FROM CALENDARIOINGRESOS
				WHERE CalendarioIngID = Var_CuotaID ;

				CALL DIASHABILFESTIVOSCAL(DATE_FORMAT(Var_FechaLimite, '%Y-%m-%d'), Entero_Uno,"DF", Var_FechaInicioCre, Es_DiaHabil, Entero_Cero,
										Entero_Cero, Fecha_Vacia, Cadena_Vacia,Cadena_Vacia, Entero_Cero,Entero_Cero);

			END IF;
		END IF;

	 END IF; -- FIN MANEJA CALENDARIO


    SET Var_FechaInicioCre :=  IFNULL(Var_FechaInicioCre, Fecha_Vacia);

RETURN Var_FechaInicioCre;
END$$
