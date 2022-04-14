-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAGRAFICA099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAGRAFICA099PRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTAGRAFICA099PRO`(

	-- SP para obtener los Datos para la grafica del estado de cuenta
	Par_AnioMes						INT(11),						-- Año y Mes Estado Cuenta
	Par_SucursalID					INT(11),						-- Numero de Sucursal
	Par_FecIniMes					DATE,							-- Fecha Inicio Mes
	Par_FecFinMes					DATE							-- Fecha Fin Mes
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Con_Cadena_Vacia		VARCHAR(1);						-- Cadena Vacia
	DECLARE	Con_Fecha_Vacia			DATE;							-- Fecha Vacia
	DECLARE	Con_Entero_Cero			INT(11);						-- Entero Cero
	DECLARE	Con_Moneda_Cero			INT(11);						-- Moneda Cero
	DECLARE Var_TiposCuenta			VARCHAR(45);					-- Tipos de Cuentas

	DECLARE EtiquetaSaldoInicial	VARCHAR(20);					-- Etiqueta para el saldo inicial de la cuenta
	DECLARE EtiquetaDepositos		VARCHAR(20);					-- Etiqueta para los depositos de la cuenta
	DECLARE EtiquetaRetiros			VARCHAR(20);					-- Etiqueta para los retiros de la cuenta
	DECLARE EtiquetaIntereses		VARCHAR(20);					-- Etiqueta para los intereses de la cuenta
	DECLARE EtiquetaRetencion		VARCHAR(20);					-- Etiqueta para las retenciones del ISR

	DECLARE EtiquetaComisiones		VARCHAR(20);					-- Etiqueta para las comisiones generadas por la cuenta
	DECLARE EtiquetaSaldoActual		VARCHAR(20);					-- Etiqueta para el saldo actual de la cuenta

	-- Asignacion de Constantes
	SET Con_Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Con_Fecha_Vacia				:= '1900-01-01';				-- Fecha Vacia
	SET Con_Entero_Cero				:= 0;							-- Entero Cero
	SET Con_Moneda_Cero				:= 0.00;						-- Moneda Cero
	SET EtiquetaSaldoInicial		:= 'SALDO INICIAL';				--

	SET EtiquetaDepositos			:= 'DEPOSITOS';
	SET EtiquetaRetiros				:= 'RETIROS';
	SET EtiquetaIntereses			:= 'INTERESES';
	SET EtiquetaRetencion			:= 'RETENCIÓN(ISR)';

	SET EtiquetaComisiones			:= 'COMISIONES';
	SET EtiquetaSaldoActual			:= 'SALDO ACTUAL';


SET SQL_SAFE_UPDATES	=	0;


	DROP TABLE IF EXISTS TMPEDOCTAGRAFICA;
	CREATE TABLE TMPEDOCTAGRAFICA (
		`AnioMes`			INT(11),
		`SucursalID`		INT(11),
		`ClienteID`			INT(11),
		`Descripcion`		VARCHAR(45),
		`Monto`				DECIMAL(14,2),
		`CuentaAhoID`		BIGINT(12)
	);

	CREATE INDEX IDX_TMPEDOCTAGRAFICA_ANIOMES USING BTREE ON TMPEDOCTAGRAFICA (AnioMes);
	CREATE INDEX IDX_TMPEDOCTAGRAFICA_CLIENTE USING BTREE ON TMPEDOCTAGRAFICA (ClienteID);
	CREATE INDEX IDX_TMPEDOCTAGRAFICA_SUCURSAL USING BTREE ON TMPEDOCTAGRAFICA (SucursalID);

	INSERT INTO TMPEDOCTAGRAFICA(
								AnioMes,			SucursalID,			ClienteID,			Descripcion,			Monto,
								CuentaAhoID
	)SELECT 					AnioMes, 			SucursalID,			ClienteID,			EtiquetaSaldoInicial, 	SaldoMesAnterior,
								CuentaAhoID
	FROM EDOCTAHEADERCTA;


	INSERT INTO TMPEDOCTAGRAFICA(
								AnioMes,			SucursalID,			ClienteID,			Descripcion,			Monto,
								CuentaAhoID
	)SELECT 					AnioMes, 			SucursalID,			ClienteID,			EtiquetaDepositos, 		Depositos,
								CuentaAhoID
	FROM EDOCTAHEADERCTA;

	INSERT INTO TMPEDOCTAGRAFICA(
								AnioMes,			SucursalID,			ClienteID,			Descripcion,				Monto,
								CuentaAhoID
	)SELECT 					AnioMes, 			SucursalID,			ClienteID,			EtiquetaRetiros, 			Retiros,
								CuentaAhoID
	FROM EDOCTAHEADERCTA;

	INSERT INTO TMPEDOCTAGRAFICA(
								AnioMes,			SucursalID,			ClienteID,			Descripcion,			Monto,
								CuentaAhoID
	)SELECT 					AnioMes, 			SucursalID,			ClienteID,			EtiquetaIntereses, 		InteresPerido,
								CuentaAhoID
	FROM EDOCTAHEADERCTA;

	INSERT INTO TMPEDOCTAGRAFICA(
								AnioMes,			SucursalID,			ClienteID,			Descripcion,		Monto,
								CuentaAhoID
	)SELECT 					AnioMes, 			SucursalID,			ClienteID,			EtiquetaRetencion, 	ISRRetenido,
								CuentaAhoID
	FROM EDOCTAHEADERCTA;

	INSERT INTO TMPEDOCTAGRAFICA(
								AnioMes,			SucursalID,			ClienteID,			Descripcion,				Monto,
								CuentaAhoID
	)SELECT 					AnioMes, 			SucursalID,			ClienteID,			EtiquetaComisiones, 		MontoComision,
								CuentaAhoID
	FROM EDOCTAHEADERCTA;


	INSERT INTO TMPEDOCTAGRAFICA(
								AnioMes,			SucursalID,			ClienteID,			Descripcion,		Monto,
								CuentaAhoID
	)SELECT 					AnioMes, 			SucursalID,			ClienteID,			EtiquetaSaldoActual, 	SaldoActual,
								CuentaAhoID
	FROM EDOCTAHEADERCTA;



	INSERT INTO EDOCTAGRAFICA(
								AnioMes,			SucursalID,			ClienteID,			Descripcion,		Monto,
								CuentaAhoID
	)SELECT 					AnioMes, 			SucursalID,			ClienteID,			Descripcion, 		Monto,
								CuentaAhoID
	FROM TMPEDOCTAGRAFICA;

END TerminaStore$$