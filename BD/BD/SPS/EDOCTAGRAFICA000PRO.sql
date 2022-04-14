-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAGRAFICA000PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAGRAFICA000PRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTAGRAFICA000PRO`(
	# SP para obtener los Datos para la grafica del estado de cuenta
    Par_AnioMes     INT(11),			# Año y Mes Estado Cuenta
    Par_SucursalID  INT(11),			# Numero de Sucursal
    Par_FecIniMes   DATE,				# Fecha Inicio Mes
    Par_FecFinMes   DATE				# Fecha Fin Mes
)
TerminaStore: BEGIN

# Declaracion de Constantes
DECLARE	Con_Cadena_Vacia		VARCHAR(1);		# Cadena Vacia
DECLARE	Con_Fecha_Vacia			DATE;			# Fecha Vacia
DECLARE	Con_Entero_Cero			INT(11);		# Entero Cero
DECLARE	Con_Moneda_Cero			INT(11);		# Moneda Cero
DECLARE Var_TiposCuenta			VARCHAR(45);    # Tipos de Cuentas

# Asignacion de Constantes
SET Con_Cadena_Vacia		= '';				# Cadena Vacia
SET Con_Fecha_Vacia			= '1900-01-01';		# Fecha Vacia
SET Con_Entero_Cero			= 0;				# Entero Cero
SET Con_Moneda_Cero			= 0.00;				# Moneda Cero
SET Var_TiposCuenta 		='';                # Tipos de Cuentas

SET SQL_SAFE_UPDATES=0;

# Se obtienen los tipos de cuentas
SET Var_TiposCuenta=(select TipoCuentaID from EDOCTAPARAMS);

	INSERT INTO EDOCTAGRAFICA
	SELECT AnioMes, SucursalID, ClienteID,'SALDO INICIAL', SUM(SaldoMesAnterior),CuentaAhoID
	FROM EDOCTARESUMCTA
	WHERE FIND_IN_SET(TipoCuentaID, Var_TiposCuenta)
	GROUP BY ClienteID, CuentaAhoID, AnioMes, SucursalID;

	INSERT INTO EDOCTAGRAFICA
	SELECT AnioMes, SucursalID, ClienteID,'DEPOSITOS', SUM(Depositos),CuentaAhoID
	FROM EDOCTARESUMCTA
	WHERE FIND_IN_SET(TipoCuentaID, Var_TiposCuenta)
	GROUP BY ClienteID, CuentaAhoID, AnioMes, SucursalID;

	INSERT INTO EDOCTAGRAFICA
	SELECT AnioMes, SucursalID, ClienteID,'RETIROS', SUM(Retiros),CuentaAhoID
	FROM EDOCTARESUMCTA
	WHERE FIND_IN_SET(TipoCuentaID, Var_TiposCuenta)
	GROUP BY ClienteID, CuentaAhoID, AnioMes, SucursalID;

	INSERT INTO EDOCTAGRAFICA
	SELECT AnioMes, SucursalID, ClienteID,'INTERESES', SUM(Interes),CuentaAhoID
	FROM EDOCTARESUMCTA
	WHERE FIND_IN_SET(TipoCuentaID, Var_TiposCuenta)
	GROUP BY ClienteID, CuentaAhoID, AnioMes, SucursalID;

	INSERT INTO EDOCTAGRAFICA
	SELECT AnioMes, SucursalID, ClienteID,'RETENCION(ISR)', sum(ISR),CuentaAhoID
	FROM EDOCTARESUMCTA
	WHERE FIND_IN_SET(TipoCuentaID, Var_TiposCuenta)
	GROUP BY ClienteID, CuentaAhoID, AnioMes, SucursalID;

	INSERT INTO EDOCTAGRAFICA
	SELECT AnioMes, SucursalID, ClienteID,'COMISIONES', sum(Comisiones),CuentaAhoID
	FROM EDOCTARESUMCTA
	WHERE FIND_IN_SET(TipoCuentaID, Var_TiposCuenta)
	GROUP BY ClienteID, CuentaAhoID, AnioMes, SucursalID;

	INSERT INTO EDOCTAGRAFICA
	SELECT AnioMes, SucursalID, ClienteID,'SALDO ACTUAL', SUM(SaldoActual),CuentaAhoID
	FROM EDOCTARESUMCTA
	WHERE FIND_IN_SET(TipoCuentaID, Var_TiposCuenta)
	GROUP BY ClienteID, CuentaAhoID, AnioMes, SucursalID;



END TerminaStore$$