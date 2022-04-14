-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNDIASCARTERAFIRACAL
DELIMITER ;
DROP FUNCTION IF EXISTS `FNDIASCARTERAFIRACAL`;
DELIMITER $$

CREATE FUNCTION `FNDIASCARTERAFIRACAL`(
# FUNCION QUE DEVUELVE DIAS DE CUMPLIMIENTO/INCUMPLIMIENTO UTILIZADO EN EL REPORTE ARCHIVOS DE MONITOREO FIRA
	Par_NumConsulta		INT(11),		-- Numero de Consulta
	Par_CreditoID		BIGINT(12),		-- Numero de Credito
    Par_FechaInicio		DATE,			-- Fecha de Inicio
	Par_FechaCorte		DATE			-- Fecha de Corte

) RETURNS int(11)
    DETERMINISTIC
BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_FechaReestr		DATE;
	DECLARE Var_DiasAtraso		INT(11);
    DECLARE Var_Valor			INT(11);
    DECLARE Var_SolicitudCred	INT(11);
    DECLARE Var_Periodicidad	INT(11);
    DECLARE Var_DiasCump		INT(11);

	-- DECLARACION DE CONSTANTES
    DECLARE Entero_Cero			INT(11);
    DECLARE Fecha_Vacia			DATE;
    DECLARE Con_DiasMax			INT(1);
    DECLARE Con_DiasIncRees		INT(11);
    DECLARE Con_PeriodoRees		INT(11);
    DECLARE Con_DiasCumpRees	INT(11);
    DECLARE NumDiasPermit		INT(11);



    -- ASIGNACION DE CONSTANTES
    SET Entero_Cero := 0;
    SET Fecha_Vacia	:= '1900-01-01';
	SET Con_DiasMax	:= 1;
    SET Con_DiasIncRees := 2;
    SET Con_PeriodoRees	:= 3;
    SET Con_DiasCumpRees := 4;
    SET NumDiasPermit := 365;

    # Días de maximo incumplimiento
	IF(Par_NumConsulta = Con_DiasMax) THEN
		SELECT	MAX(DiasAtraso)
		INTO Var_DiasAtraso
		FROM SALDOSCREDITOS
			WHERE CreditoID = Par_CreditoID AND
				FechaCorte BETWEEN Par_FechaInicio AND Par_FechaCorte
			GROUP BY CreditoID;

		SET Var_DiasAtraso := IFNULL(Var_DiasAtraso, Entero_Cero);
		SET Var_Valor := Var_DiasAtraso;
    END IF;

    # Numero de dias de los pagos incumplidos previos a la reestructura
    IF(Par_NumConsulta = Con_DiasIncRees) THEN
		SET Var_FechaReestr := (SELECT IFNULL(FechaRegistro, Fecha_Vacia) FROM REESTRUCCREDITO
									WHERE CreditoDestinoID = Par_CreditoID);

		SET Var_FechaReestr := IFNULL(Var_FechaReestr,Fecha_Vacia);

		IF(Var_FechaReestr <> Fecha_Vacia) THEN
			SELECT	MAX(DiasAtraso)
				INTO Var_DiasAtraso
			FROM SALDOSCREDITOS
			WHERE CreditoID = Par_CreditoID AND
				FechaCorte BETWEEN Par_FechaCorte AND Par_FechaInicio
			GROUP BY CreditoID;

		ELSE
			SET Var_DiasAtraso := Entero_Cero;
		END IF;
			SET Var_DiasAtraso := IFNULL(Var_DiasAtraso, Entero_Cero);
			SET Var_Valor := Var_DiasAtraso;
    END IF;

    # Periodo de la amortizacion pactada originalmente
    IF (Par_NumConsulta = Con_PeriodoRees) THEN

        SET Var_Periodicidad := (SELECT PeriodicidadCap FROM SOLICITUDCREDITO WHERE CreditoID = Par_CreditoID LIMIT 1);
		SET Var_Periodicidad := IFNULL(Var_Periodicidad, Entero_Cero);
        SET Var_Valor := Var_Periodicidad;
    END IF;

    # Dias de cumplimiento posterior a la reestructura
    IF(Par_NumConsulta = Con_DiasCumpRees) THEN

        SET Var_DiasCump := (SELECT DATEDIFF(FechaRegula, FechaRegistro) FROM REESTRUCCREDITO WHERE CreditoDestinoID = Par_CreditoID LIMIT 1);
		SET Var_DiasCump := IFNULL(Var_DiasCump, Entero_Cero);
		SET Var_Valor := Var_DiasCump;

    END IF;

    IF(Var_Valor > NumDiasPermit) THEN
    	SET Var_Valor := NumDiasPermit;
    END IF;
	RETURN Var_Valor;
END$$
