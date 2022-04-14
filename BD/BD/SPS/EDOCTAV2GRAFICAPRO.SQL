-- SP EDOCTAV2GRAFICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2GRAFICAPRO;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2GRAFICAPRO`(
	-- SP para obtener los Datos para la grafica del estado de cuenta

	)
TerminaStore: BEGIN
-- Declaracion de Constantes
DECLARE	Con_Cadena_Vacia		VARCHAR(1);		# Cadena Vacia
DECLARE	Con_Fecha_Vacia			DATE;			# Fecha Vacia
DECLARE	Con_Entero_Cero			INT(11);		# Entero Cero
DECLARE	Con_Moneda_Cero			INT(11);		# Moneda Cero
DECLARE Var_TiposCuenta			VARCHAR(45);    # Tipos de Cuentas
DECLARE Par_AnioMes				INT(11);		# Año y Mes Estado Cuenta
DECLARE Par_FecIniMes			DATE;			# Fecha Inicio Mes
DECLARE Par_FecFinMes			DATE;			# Fecha Fin Mes

-- Asignacion de Constantes
SET Con_Cadena_Vacia		= '';				# Cadena Vacia
SET Con_Fecha_Vacia			= '1900-01-01';		# Fecha Vacia
SET Con_Entero_Cero			= 0;				# Entero Cero
SET Con_Moneda_Cero			= 0.00;				# Moneda Cero
SET Var_TiposCuenta 		='';                # Tipos de Cuentas

SET SQL_SAFE_UPDATES = 0;

	SELECT 	MesProceso,		FechaInicio,	FechaFin
		INTO Par_AnioMes,	Par_FecIniMes,	Par_FecFinMes
	FROM EDOCTAV2PARAMS LIMIT 1;

	INSERT INTO EDOCTAV2GRAFICA
	SELECT 	NULL,
			AnioMes, ClienteID, CuentaAhoID, 'SALDO INICIAL', SUM(SaldoMesAnterior),
			1
	FROM EDOCTAV2HEADERCTA
	GROUP BY AnioMes, ClienteID, CuentaAhoID;

	INSERT INTO EDOCTAV2GRAFICA
	SELECT 	NULL,
			AnioMes, ClienteID, CuentaAhoID, 'DEPOSITOS', SUM(DepositosMes),
			2
	FROM EDOCTAV2HEADERCTA
	GROUP BY AnioMes, ClienteID, CuentaAhoID;

	INSERT INTO EDOCTAV2GRAFICA
	SELECT 	NULL,
			AnioMes, ClienteID, CuentaAhoID, 'RETIROS', SUM(RetirosMes),
			3
	FROM EDOCTAV2HEADERCTA
	GROUP BY AnioMes, ClienteID, CuentaAhoID;

	INSERT INTO EDOCTAV2GRAFICA
	SELECT 	NULL,
			AnioMes, ClienteID, CuentaAhoID, 'INTERESES', SUM(InteresPerido),
			4
	FROM EDOCTAV2HEADERCTA
	GROUP BY AnioMes, ClienteID, CuentaAhoID;

	INSERT INTO EDOCTAV2GRAFICA
	SELECT 	NULL,
			AnioMes, ClienteID, CuentaAhoID, 'RETENCION(ISR)', sum(ISRRetenido),
			5
	FROM EDOCTAV2HEADERCTA
	GROUP BY AnioMes, ClienteID, CuentaAhoID;

	INSERT INTO EDOCTAV2GRAFICA
	SELECT 	NULL,
			AnioMes, ClienteID, CuentaAhoID, 'COMISIONES', sum(MontoComision),
			6
	FROM EDOCTAV2HEADERCTA
	GROUP BY AnioMes, ClienteID, CuentaAhoID;

	INSERT INTO EDOCTAV2GRAFICA
	SELECT 	NULL,
			AnioMes, ClienteID, CuentaAhoID, 'SALDO ACTUAL', SUM(SaldoActual),
			7
	FROM EDOCTAV2HEADERCTA
	GROUP BY AnioMes, ClienteID, CuentaAhoID;

END TerminaStore$$
