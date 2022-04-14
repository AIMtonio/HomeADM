-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNDEPREAMORTIZACION
DELIMITER ;
DROP FUNCTION IF EXISTS `FNDEPREAMORTIZACION`;

DELIMITER $$
CREATE FUNCTION `FNDEPREAMORTIZACION`(
	-- Funcion para consultar el monto a Depreciar de un Activo
	-- Activos --> Reportes --> Catalogo Activos / Depreciacion de Activos
	Par_ActivoID				INT(11),	-- ID de Activo
	Par_FechaInicio 			DATE,		-- Fecha Inicial de Consulta
	Par_FechaFin				DATE,		-- Fecha Final de Consulta
	Par_Anio					INT(11),	-- Anio de Cconsulta
	Par_Mes						INT(11),	-- Mes de Consulta
	Par_TipoConsulta			INT(11)		-- Numero de consulta
) RETURNS DECIMAL(18,2)
	DETERMINISTIC
BEGIN
	-- Declaracion de Variables
	DECLARE Var_Anio				INT(11);		-- Añio del Activo
	DECLARE Var_Mes					INT(11);		-- Mes del Activo
	DECLARE Var_MaxAnioActivo		INT(11);		-- Maximo Añio del Activo
	DECLARE Var_MaxMesActivo		INT(11);		-- Maximo Mes del Activo a un Año en especifico

	DECLARE Var_DepreAmortiID		INT(11);		-- Consecutivo del movimiento de depreciacion y amortizacion del activo
	DECLARE Var_ValidaDepreAmortiID	INT(11);		-- Validacion para determinar si existe el Consecutivo del movimiento de depreciacion y amortizacion del activo
	DECLARE Var_MontoDepreciar		DECIMAL(18,2);	-- Monto a Depreciar

	-- Declaracion de Consultas
	DECLARE Con_Mensual 		INT(11);		-- Consulta Monto a Depreciar de un Activo por Mes
	DECLARE Con_Anual 			INT(11);		-- Consulta Monto a Depreciar de un Activo por Anio
	DECLARE Con_DepAcomulada	INT(11);		-- Consulta Monto a Depreciado Acomulado por Activo a una fecha
	DECLARE Con_SalDepreciar	INT(11);		-- Consulta Monto a Por Depreciar por Activo a una fecha

	-- Declaracion de constantes
	DECLARE Cadena_Vacia 		CHAR(1);		-- Cadena Vacia
	DECLARE Entero_Cero			INT(11);		-- Entero Cero
	DECLARE Decimal_Cero 		DECIMAL(12,2);	-- Decimal Cero
	DECLARE Fecha_Vacia 		DATE;			-- Fecha Vacia

	-- Asignacion de Consultas
	SET Con_Mensual				:= 1;
	SET Con_Anual				:= 2;
	SET Con_DepAcomulada		:= 3;
	SET Con_SalDepreciar		:= 4;

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET Entero_Cero				:= 0;
	SET Decimal_Cero 			:= 0.00;
	SET Fecha_Vacia				:= '1900-01-01';

	SET Par_ActivoID		:= IFNULL(Par_ActivoID, Entero_Cero);
	SET Par_FechaInicio		:= IFNULL(Par_FechaInicio, Fecha_Vacia);
	SET Par_FechaFin		:= IFNULL(Par_FechaFin, Fecha_Vacia);
	SET Par_Anio			:= IFNULL(Par_Anio, Entero_Cero);
	SET Par_Mes				:= IFNULL(Par_Mes, Entero_Cero);
	SET Par_TipoConsulta	:= IFNULL(Par_TipoConsulta, Entero_Cero);

	-- Consulta Anual
	IF( Par_TipoConsulta = Con_Anual ) THEN
		SELECT	SUM(IFNULL(MontoDepreciar, Decimal_Cero))
		INTO	Var_MontoDepreciar
		FROM BITACORADEPREAMORTI Bita
		WHERE Bita.ActivoID = Par_ActivoID
		  AND Bita.Anio = Par_Anio
		  AND Bita.Mes >= Par_Mes
		  AND Bita.FechaAplicacion BETWEEN Par_FechaInicio AND Par_FechaFin;
	END IF;

	-- Consulta mensual
	IF( Par_TipoConsulta = Con_Mensual ) THEN
		SELECT	SUM(IFNULL(MontoDepreciar, Decimal_Cero))
		INTO	Var_MontoDepreciar
		FROM BITACORADEPREAMORTI Bita
		WHERE Bita.ActivoID = Par_ActivoID
		  AND Bita.Anio = Par_Anio
		  AND Bita.Mes = Par_Mes
		  AND Bita.FechaAplicacion BETWEEN Par_FechaInicio AND Par_FechaFin;
	END IF;

	-- Consulta Monto a Depreciado Acomulado por Activo a una fecha
	-- Consulta Monto a Por Depreciar por Activo a una fecha
	IF( Par_TipoConsulta IN (Con_DepAcomulada, Con_SalDepreciar) ) THEN

		SET Var_Anio := YEAR(Par_FechaFin);
		SET Var_Mes  := MONTH(Par_FechaFin);

		SELECT IFNULL(COUNT(*), Entero_Cero)
		INTO Var_ValidaDepreAmortiID
		FROM BITACORADEPREAMORTI Bita
		WHERE Bita.ActivoID = Par_ActivoID
		  AND Bita.Anio = YEAR(Par_FechaFin)
		  AND Bita.Mes = MONTH(Par_FechaFin);

		IF( Var_ValidaDepreAmortiID = Entero_Cero ) THEN

			SELECT IFNULL(MAX(Bita.Anio), Entero_Cero)
			INTO Var_MaxAnioActivo
			FROM BITACORADEPREAMORTI Bita
			WHERE Bita.ActivoID = Par_ActivoID
			  AND Bita.Anio BETWEEN YEAR(Par_FechaInicio) AND YEAR(Par_FechaFin);

			SELECT IFNULL(MAX(Bita.Mes), Entero_Cero)
			INTO Var_MaxMesActivo
			FROM BITACORADEPREAMORTI Bita
			WHERE Bita.ActivoID = Par_ActivoID
			  AND Bita.Anio = Var_MaxAnioActivo;

			SET Var_Anio := Var_MaxAnioActivo;
			SET Var_Mes  := Var_MaxMesActivo;

		END IF;

		-- Obtengo el INPC del Mes
		SELECT IFNULL(DepreAmortiID, Entero_Cero)
		INTO Var_DepreAmortiID
		FROM BITACORADEPREAMORTI
		WHERE ActivoID = Par_ActivoID
		  AND Anio = Var_Anio
		  AND Mes  = Var_Mes;

		-- Consulta Monto a Depreciado Acomulado por Activo a una fecha
		IF( Par_TipoConsulta = Con_DepAcomulada ) THEN
			SELECT	IFNULL(DepreciadoAcumulado, Decimal_Cero)
			INTO	Var_MontoDepreciar
			FROM BITACORADEPREAMORTI Bita
			WHERE Bita.ActivoID = Par_ActivoID
			  AND Bita.DepreAmortiID = Var_DepreAmortiID;
		END IF;

		-- Consulta Monto a Por Depreciar por Activo a una fecha
		IF( Par_TipoConsulta = Con_SalDepreciar ) THEN
			SELECT	IFNULL(SaldoPorDepreciar, Decimal_Cero)
			INTO	Var_MontoDepreciar
			FROM BITACORADEPREAMORTI Bita
			WHERE Bita.ActivoID = Par_ActivoID
			  AND Bita.DepreAmortiID = Var_DepreAmortiID;
		END IF;

	END IF;

	RETURN IFNULL(Var_MontoDepreciar, Decimal_Cero);
END$$