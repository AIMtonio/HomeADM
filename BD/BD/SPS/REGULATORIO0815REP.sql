-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIO0815REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIO0815REP`;DELIMITER $$

CREATE PROCEDURE `REGULATORIO0815REP`(
	Par_Anio           		INT,
	Par_Mes					INT,
	Par_NumReporte     		TINYINT UNSIGNED,

    Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

# Declaracion de variables
DECLARE Var_1Dia_7Dia				DECIMAL(16,2);	# Saldo al cierre del mes (de 1 a 7 dias)
DECLARE Var_8Dias_1Mes				DECIMAL(16,2);	# Saldo al cierre del mes (8 dias a 1 mes)
DECLARE Var_1Mes_3Mes				DECIMAL(16,2);	# Saldo al cierre del mes (mas de un mes a 3 meses)
DECLARE Var_3Mes_6Mes				DECIMAL(16,2);	# Saldo al cierre del mes (mas de 3 meses a 6 meses)
DECLARE Var_6Mes_1Anio				DECIMAL(16,2);	# Saldo al cierre del mes (mas de 6 meses a 1 año)
DECLARE Var_1anio_2Anio				DECIMAL(16,2);	# Saldo al cierre del mes (mas de 1 año a 2 años)
DECLARE Var_Mas_2Anio				DECIMAL(16,2);	# Saldo al cierre del mes (mas de 2 años)
DECLARE Var_1Dia_7DiaCede			DECIMAL(16,2);	# Saldo al cierre del mes (de 1 a 7 dias) para cedes
DECLARE Var_8Dias_1MesCede			DECIMAL(16,2);	# Saldo al cierre del mes (8 dias a 1 mes) para cedes
DECLARE Var_1Mes_3MesCede			DECIMAL(16,2);	# Saldo al cierre del mes (mas de un mes a 3 meses) para cedes
DECLARE Var_3Mes_6MesCede			DECIMAL(16,2);	# Saldo al cierre del mes (mas de 3 meses a 6 meses) para cedes
DECLARE Var_6Mes_1AnioCede			DECIMAL(16,2);	# Saldo al cierre del mes (mas de 6 meses a 1 año) para cedes
DECLARE Var_1anio_2AnioCede			DECIMAL(16,2);	# Saldo al cierre del mes (mas de 1 año a 2 años) para cedes
DECLARE Var_Mas_2AnioCede			DECIMAL(16,2);	# Saldo al cierre del mes (mas de 2 años) para cedes
DECLARE Var_1Dia_7DiaNum			INT(11);		# Numero de cuentas o contratos (de 1 a 7 dias)
DECLARE	Var_8Dias_1MesNum			INT(11);		# Numero de cuentas o contratos (8 dias a 1 mes)
DECLARE Var_1Mes_3MesNum			INT(11);		# Numero de cuentas o contratos (mas de un mes a 3 meses)
DECLARE Var_3Mes_6MesNum			INT(11);		# Numero de cuentas o contratos (mas de 3 meses a 6 meses)
DECLARE Var_6Mes_1AnioNum			INT(11);		# Numero de cuentas o contratos (mas de 6 meses a 1 año)
DECLARE Var_1anio_2AnioNum			INT(11);		# Numero de cuentas o contratos (mas de 1 año a 2 años)
DECLARE Var_Mas_2AnioNum			INT(11);		# Numero de cuentas o contratos (mas de 2 años)
DECLARE Var_1Dia_7DiaNumCede		INT(11);		# Numero de cuentas o contratos (de 1 a 7 dias)
DECLARE	Var_8Dias_1MesNumCede		INT(11);		# Numero de cuentas o contratos (8 dias a 1 mes) para cedes
DECLARE Var_1Mes_3MesNumCede		INT(11);		# Numero de cuentas o contratos (mas de un mes a 3 meses) para cedes
DECLARE Var_3Mes_6MesNumCede		INT(11);		# Numero de cuentas o contratos (mas de 3 meses a 6 meses) para cedes
DECLARE Var_6Mes_1AnioNumCede		INT(11);		# Numero de cuentas o contratos (mas de 6 meses a 1 año) para cedes
DECLARE Var_1anio_2AnioNumCede		INT(11);		# Numero de cuentas o contratos (mas de 1 año a 2 años) para cedes
DECLARE Var_Mas_2AnioNumCede		INT(11);		# Numero de cuentas o contratos (mas de 2 años) para cedes
DECLARE Var_6000UDIS				DECIMAL(16,2);	# Saldo al cierre del mes (Hasta 6,000 UDIS) para cuentas
DECLARE Var_6001_8000UDIS			DECIMAL(16,2);	# Saldo al cierre del mes (Entre 6,001 y 8,000 UDIS) para cuentas
DECLARE Var_8001_10000UDIS			DECIMAL(16,2);	# Saldo al cierre del mes (Entre 8,001 y 10,000 UDIS) para cuentas
DECLARE Var_10001_15000UDIS			DECIMAL(16,2);	# Saldo al cierre del mes (Entre 10,001 y 15,000 UDIS) para cuentas
DECLARE Var_15001_20000UDIS			DECIMAL(16,2);	# Saldo al cierre del mes (Entre 15,001 y 20,000 UDIS) para cuentas
DECLARE Var_20001_25000UDIS			DECIMAL(16,2);	# Saldo al cierre del mes (Entre 20,001 y 25,000 UDIS) para cuentas
DECLARE Var_25000MasUDIS			DECIMAL(16,2);	# Saldo al cierre del mes (Mas de 25,000 UDIS) para cuentas
DECLARE Var_6000UDISNum				INT(11);		# Numero de cuentas o contratos(Hasta 6,000 UDIS) para cuentas
DECLARE Var_6001_8000UDISNum		INT(11);		# Numero de cuentas o contratos (Entre 6,001 y 8,000 UDIS) para cuentas
DECLARE Var_8001_10000UDISNum		INT(11);		# Numero de cuentas o contratos (Entre 8,001 y 10,000 UDIS) para cuentas
DECLARE Var_10001_15000UDISNum		INT(11);		# Numero de cuentas o contratos (Entre 10,001 y 15,000 UDIS) para cuentas
DECLARE Var_15001_20000UDISNum		INT(11);		# Numero de cuentas o contratos (Entre 15,001 y 20,000 UDIS) para cuentas
DECLARE Var_20001_25000UDISNum		INT(11);		# Numero de cuentas o contratos (Entre 20,001 y 25,000 UDIS) para cuentas
DECLARE Var_25000MasUDISNum			INT(11);		# Numero de cuentas o contratos (Mas de 25,000 UDIS) para cuentas
DECLARE Var_6000UDISInv				DECIMAL(16,2);	# Saldo al cierre del mes (Hasta 6,000 UDIS) para inversiones
DECLARE Var_6001_8000UDISInv		DECIMAL(16,2);	# Saldo al cierre del mes (Entre 6,001 y 8,000 UDIS) para inversiones
DECLARE Var_8001_10000UDISInv		DECIMAL(16,2);	# Saldo al cierre del mes (Entre 8,001 y 10,000 UDIS) para inversiones
DECLARE Var_10001_15000UDISInv		DECIMAL(16,2);	# Saldo al cierre del mes (Entre 10,001 y 15,000 UDIS) para inversiones
DECLARE Var_15001_20000UDISInv		DECIMAL(16,2);	# Saldo al cierre del mes (Entre 15,001 y 20,000 UDIS) para inversiones
DECLARE Var_20001_25000UDISInv		DECIMAL(16,2);	# Saldo al cierre del mes (Entre 20,001 y 25,000 UDIS) para inversiones
DECLARE Var_25000MasUDISInv			DECIMAL(16,2);	# Saldo al cierre del mes (Mas de 25,000 UDIS) para inversiones
DECLARE Var_6000UDISNumInv			INT(11);		# Numero de cuentas o contratos(Hasta 6,000 UDIS) para inversiones
DECLARE Var_6001_8000UDISNumInv		INT(11);		# Numero de cuentas o contratos (Entre 6,001 y 8,000 UDIS) para inversiones
DECLARE Var_8001_10000UDISNumInv	INT(11);		# Numero de cuentas o contratos (Entre 8,001 y 10,000 UDIS) para inversiones
DECLARE Var_10001_15000UDISNumInv	INT(11);		# Numero de cuentas o contratos (Entre 10,001 y 15,000 UDIS) para inversiones
DECLARE Var_15001_20000UDISNumInv	INT(11);		# Numero de cuentas o contratos (Entre 15,001 y 20,000 UDIS) para inversiones
DECLARE Var_20001_25000UDISNumInv	INT(11);		# Numero de cuentas o contratos (Entre 20,001 y 25,000 UDIS) para inversiones
DECLARE Var_25000MasUDISNumInv		INT(11);		# Numero de cuentas o contratos (Mas de 25,000 UDIS) para inversiones

DECLARE Var_6000UDISCede			DECIMAL(16,2);	# Saldo al cierre del mes (Hasta 6,000 UDIS) para Cedes
DECLARE Var_6001_8000UDISCede		DECIMAL(16,2);	# Saldo al cierre del mes (Entre 6,001 y 8,000 UDIS) para Cedes
DECLARE Var_8001_10000UDISCede		DECIMAL(16,2);	# Saldo al cierre del mes (Entre 8,001 y 10,000 UDIS) para Cedes
DECLARE Var_10001_15000UDISCede		DECIMAL(16,2);	# Saldo al cierre del mes (Entre 10,001 y 15,000 UDIS) para Cedes
DECLARE Var_15001_20000UDISCede		DECIMAL(16,2);	# Saldo al cierre del mes (Entre 15,001 y 20,000 UDIS) para Cedes
DECLARE Var_20001_25000UDISCede		DECIMAL(16,2);	# Saldo al cierre del mes (Entre 20,001 y 25,000 UDIS) para Cedes
DECLARE Var_25000MasUDISCede		DECIMAL(16,2);	# Saldo al cierre del mes (Mas de 25,000 UDIS) para Cedes
DECLARE Var_6000UDISNumCede			INT(11);		# Numero de cuentas o contratos(Hasta 6,000 UDIS) para Cedes
DECLARE Var_6001_8000UDISNumCede	INT(11);		# Numero de cuentas o contratos (Entre 6,001 y 8,000 UDIS) para Cedes
DECLARE Var_8001_10000UDISNumCede	INT(11);		# Numero de cuentas o contratos (Entre 8,001 y 10,000 UDIS) para Cedes
DECLARE Var_10001_15000UDISNumCede	INT(11);		# Numero de cuentas o contratos (Entre 10,001 y 15,000 UDIS) para Cedes
DECLARE Var_15001_20000UDISNumCede	INT(11);		# Numero de cuentas o contratos (Entre 15,001 y 20,000 UDIS) para Cedes
DECLARE Var_20001_25000UDISNumCede	INT(11);		# Numero de cuentas o contratos (Entre 20,001 y 25,000 UDIS) para Cedes
DECLARE Var_25000MasUDISNumCede		INT(11);		# Numero de cuentas o contratos (Mas de 25,000 UDIS) para Cedes

DECLARE Var_SaldoCuentas			DECIMAL(16,2);	# Saldo en cuentas
DECLARE	Var_NumCuentas				INT(11);		# Numero de cuentas
DECLARE Var_FechaSistema			DATE;			# Fecha actual del sistema
DECLARE Var_FechaServer				DATE;			# Fecha actual del servidor
DECLARE Var_UDIS					DECIMAL(16,4);	# Valor mas reciente de un UDIS
DECLARE Var_FechaInicio				DATE;			# Almacena una fecha armada del parmetros anio y mes
DECLARE Var_FechaFin				DATE;			# Cierra el ranto de fecha para la busqueda
DECLARE Var_FechaMes				DATE;			# Cierra el ranto de fecha para la busqueda
DECLARE Var_FechaMaxima				DATETIME;			# Almacena una fecha maxima
DECLARE Var_FechaCieInv				DATETIME;			# Fecha de Cierre de INversion
DECLARE Var_FechaCieCede			DATETIME;			# Fecha de Cierre de CEDE


# Declaracion de constantes
DECLARE Entero_Cero				INT(2);			# Constante cero
DECLARE Decimal_Cero			DECIMAL(4,2);	# Constante DECIMAL
DECLARE Decimal_Uno				DECIMAL(4,2);	# Constante DECIMAL = 1
DECLARE Str_Tabulador			VARCHAR(20);	# Espacio en blando de un de tabulador
DECLARE Estatus_Pagado 			CHAR(1);		# Estatus Pagado
DECLARE Estatus_Vigente			CHAR(1);		# Estatus Vigente
DECLARE Estatus_Activo			CHAR(1);		# Estatus Activo
DECLARE Estatus_Bloqueado		CHAR(1);		# Estatus Bloqueado
DECLARE Estatus_Cancelado		CHAR(1);		# Estatus cancelado
DECLARE Dias_Mes				INT(11);		# Total de dias promedio que tiene un mes
DECLARE MonedaUDISID			INT(11);		# ID de la moneda UDIS
DECLARE Rep_Excel				INT(11);        # Tipo Reporte Excel
DECLARE Rep_Csv					INT(11);        # Tipo Reporte CSV
DECLARE Cliente_Inst			INT;
DECLARE Var_ClaveEntidad		VARCHAR(300);
DECLARE Clave_NivInst			VARCHAR(6);		# Clave de la Nivel Institución
DECLARE Var_ReporteID			VARCHAR(6);		# Clave del REPORTE REGULATORIO
DECLARE Var_ClaveFedera			VARCHAR(6);		# CLAVE DE LA FEDERACION
DECLARE Var_ClaveSaldo			INT;
DECLARE Var_ClaveVencim			INT;
DECLARE Var_Periodo     		VARCHAR(6);		#periodo que se reporta
# Constantes para la estructura del regulatorio
DECLARE TipoSaldo1				INT;
DECLARE TipoSaldo2				INT;
DECLARE Txt_Total				VARCHAR(10);
DECLARE Txt_PlazoVencim			VARCHAR(50);
DECLARE	Txt_RangoDeposi			VARCHAR(50);
DECLARE	Txt_PV_Grupo1			VARCHAR(50);
DECLARE	Txt_PV_Grupo2			VARCHAR(50);
DECLARE Txt_PV_Grupo3			VARCHAR(50);
DECLARE Txt_PV_Grupo4			VARCHAR(50);
DECLARE Txt_PV_Grupo5			VARCHAR(50);
DECLARE Txt_PV_Grupo6			VARCHAR(50);
DECLARE Txt_PV_Grupo7			VARCHAR(50);
DECLARE	Txt_RD_Grupo1			VARCHAR(50);
DECLARE	Txt_RD_Grupo2			VARCHAR(50);
DECLARE Txt_RD_Grupo3			VARCHAR(50);
DECLARE Txt_RD_Grupo4			VARCHAR(50);
DECLARE Txt_RD_Grupo5			VARCHAR(50);
DECLARE Txt_RD_Grupo6			VARCHAR(50);
DECLARE Txt_RD_Grupo7			VARCHAR(50);

DECLARE Cuenta_CNBV1			VARCHAR(30);
DECLARE Cuenta_CNBV2			VARCHAR(30);
DECLARE Cuenta_CNBV3			VARCHAR(30);
DECLARE Cuenta_CNBV4			VARCHAR(30);
DECLARE Cuenta_CNBV5			VARCHAR(30);
DECLARE Cuenta_CNBV6			VARCHAR(30);
DECLARE Cuenta_CNBV7			VARCHAR(30);
DECLARE Cuenta_CNBV8			VARCHAR(30);
DECLARE Cuenta_CNBV9			VARCHAR(30);
DECLARE Cuenta_CNBV10			VARCHAR(30);
DECLARE Cuenta_CNBV11			VARCHAR(30);
DECLARE Cuenta_CNBV12			VARCHAR(30);
DECLARE Cuenta_CNBV13			VARCHAR(30);
DECLARE Cuenta_CNBV14			VARCHAR(30);
DECLARE Cuenta_CNBV15			VARCHAR(30);
DECLARE Cuenta_CNBV16			VARCHAR(30);



# Asignacion de constantes
SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0;
SET Decimal_Uno			:= 1.0;
SET Str_Tabulador   	:= '     ';
SET Estatus_Pagado		:= 'P';
SET Estatus_Vigente		:= 'N';
SET Estatus_Activo		:= 'A';
SET Estatus_Bloqueado	:= 'B';
SET Estatus_Cancelado	:= 'C';
SET Dias_Mes			:= 30;
SET MonedaUDISID		:= 4;
SET Rep_Excel			:= 1;
SET Rep_Csv			    := 2;
SET Var_ReporteID		:= '0815';
SET Var_ClaveSaldo		:= 1;
SET Var_ClaveVencim   	:= 84;
SET TipoSaldo1			:= 1;
SET TipoSaldo2			:= 2;

# Constantes para la estructura del regulatorio
SET Txt_Total				:='Total';
SET Txt_PlazoVencim			:='Plazo al Vencimiento:';
SET	Txt_RangoDeposi			:='Rango de Depositos:';
SET	Txt_PV_Grupo1			:='De 1 a 7 dias 1/';
SET	Txt_PV_Grupo2			:='De 8 dias a 1 mes';
SET Txt_PV_Grupo3			:='Mas de 1 mes a 3 meses';
SET Txt_PV_Grupo4			:='Mas de 3 meses a 6 meses';
SET Txt_PV_Grupo5			:='Mas de 6 meses a 1 ano';
SET Txt_PV_Grupo6			:='Mas de 1 ano a 2 anos';
SET Txt_PV_Grupo7			:='Mas de 2 anos';
SET	Txt_RD_Grupo1			:='Hasta 6,000 UDIS';
SET	Txt_RD_Grupo2			:='Entre 6,001 y 8,000 UDIS';
SET Txt_RD_Grupo3			:='Entre 8,001 y 10,000 UDIS';
SET Txt_RD_Grupo4			:='Entre 10,001 y 15,000 UDIS';
SET Txt_RD_Grupo5			:='Entre 15,001 y 20,000 UDIS';
SET Txt_RD_Grupo6			:='Entre 20,001 y 25,000 UDIS';
SET Txt_RD_Grupo7			:='Mas de 25,000 UDIS';

SET Cuenta_CNBV1			:='225000000000';
SET Cuenta_CNBV2			:='225001000000';
SET Cuenta_CNBV3			:='225002000000';
SET Cuenta_CNBV4			:='225003000000';
SET Cuenta_CNBV5			:='225004000000';
SET Cuenta_CNBV6			:='225005000000';
SET Cuenta_CNBV7			:='225006000000';
SET Cuenta_CNBV8			:='225007000000';
SET Cuenta_CNBV9			:='225100000000';
SET Cuenta_CNBV10			:='225101000000';
SET Cuenta_CNBV11			:='225102000000';
SET Cuenta_CNBV12			:='225103000000';
SET Cuenta_CNBV13			:='225104000000';
SET Cuenta_CNBV14			:='225105000000';
SET Cuenta_CNBV15			:='225106000000';
SET Cuenta_CNBV16			:='225107000000';


# Asignacion de variables
SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
SET Var_FechaServer		:= CURRENT_DATE();
SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
SET Cliente_Inst		:= (SELECT ClienteInstitucion FROM PARAMETROSSIS);
SET Var_ClaveEntidad	:= (SELECT Ins.ClaveEntidad FROM PARAMETROSSIS Ins WHERE EmpresaID = Par_EmpresaID);
SET Clave_NivInst		:= (SELECT claveNivInstitucion FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);
SET Var_ClaveFedera		:= '030004';
-- se obtiene el numero de Transaccion
CALL TRANSACCIONESPRO(Aud_NumTransaccion);

# Se busca el valor de la moneda UDIS, verifica q exista un registro de la fecha actual
IF (Var_FechaSistema = Var_FechaFin) THEN

	SET Var_UDIS := (SELECT ROUND(IFNULL(TipCamDof, Decimal_Cero),2)
						FROM MONEDAS
						WHERE MonedaId = MonedaUDISID);

ELSE
	SET Var_FechaMaxima := (SELECT MAX(FechaActual) FROM `HIS-MONEDAS`
								WHERE	MonedaId = MonedaUDISID
									AND DATE(FechaActual) <= Var_FechaFin LIMIT 1);
	SET Var_UDIS := (SELECT ROUND(IFNULL(TipCamDof, Decimal_Cero),2)
						FROM `HIS-MONEDAS`
						WHERE MonedaId = MonedaUDISID
						AND FechaActual = Var_FechaMaxima
						LIMIT 1);

	IF(Par_Anio="2014" AND Par_Mes = '12')THEN
		SET Var_UDIS	:= 5.2703;
	END IF;

END IF;

SET Var_UDIS	:= IFNULL(Var_UDIS, Decimal_Uno);

# Para almacenar temporalmente todos los valores calculados para el reporte
DELETE FROM TMPREGR08A08110815; -- WHERE NumTransaccion = Aud_NumTransaccion;

# ================================= Creacion de Tablas Temporales ========================================
# Para almacenar temporalmente los movimientos del historial de  cuentas activas que corresponden al año y mes indicados
DROP TABLE IF EXISTS TMPHISCUENTASAHO;
CREATE TEMPORARY TABLE TMPHISCUENTASAHO(
    CuentaAhoID         BIGINT(12) NOT NULL,
    Saldo				DECIMAL(16,2),
    SaldoN				DECIMAL(16,2),
    PRIMARY KEY(CuentaAhoID,Saldo)
);


# Para almacenar temporalmente las inversiones vigentes y pagadas que corresponden al año y mes indicados
DROP TABLE IF EXISTS TMPINVERSIONESREG;
CREATE TEMPORARY TABLE TMPINVERSIONESREG(
    InversionID         INT(12) PRIMARY KEY,
    Monto				DECIMAL(16,2),
    MontoN				DECIMAL(16,2),
	FechaInicio			DATE,
	FechaVencimiento	DATE,
	PlazoDias			INT(11),
	INDEX idxFITmp(FechaInicio),
	INDEX idxFVTmp(FechaVencimiento)
);


# Para almacenar temporalmente las CEDES vigentes y pagadas que corresponden al año y mes indicados
DROP TABLE IF EXISTS TMPCEDESREG;
CREATE TEMPORARY TABLE TMPCEDESREG(
    CedeID         		INT(12) PRIMARY KEY,
    Monto				DECIMAL(16,2),
    MontoN				DECIMAL(16,2),
	FechaInicio			DATE,
	FechaVencimiento	DATE,
	PlazoDias			INT(11),
	INDEX idxFITmp(FechaInicio),
	INDEX idxFVTmp(FechaVencimiento)
);

# =================== SE PREPARAN LOS Reg_ConceptoS A IMPRIMIR EN EL REPORTE =======================
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto, NumTransaccion)
				VALUES(Var_ReporteID,	1,	Txt_Total, Aud_NumTransaccion);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto, 											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,2,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_PlazoVencim),	Decimal_Cero,		Entero_Cero,	Aud_NumTransaccion,	Cuenta_CNBV1);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,3,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_PV_Grupo1),		Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV2);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,4,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_PV_Grupo2),		Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV3);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,5,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_PV_Grupo3),		Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV4);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,6,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_PV_Grupo4),		Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV5);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,7,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_PV_Grupo5),		Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV6);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,8,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_PV_Grupo6),		Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV7);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,9,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_PV_Grupo7),		Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV8);


INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto, NumTransaccion)
				VALUES(Var_ReporteID,10,	Txt_Total, Aud_NumTransaccion);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,11,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_RangoDeposi),	Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV9);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,12,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_RD_Grupo1),	Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV10);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,13,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_RD_Grupo2),	Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV11);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,14,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_RD_Grupo3),	Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV12);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,15,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_RD_Grupo4),	Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV13);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,16,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_RD_Grupo5),	Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV14);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,17,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_RD_Grupo6),	Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV15);
INSERT INTO TMPREGR08A08110815 (Reg_ReporteID,Reg_Orden,		Reg_Concepto,											Saldo,				NumCuentas, NumTransaccion, Reg_CuentaCNBV)
				VALUES(Var_ReporteID,18,	CONCAT(REPEAT(Str_Tabulador, 4),Txt_RD_Grupo7),	Decimal_Cero,		Entero_Cero, Aud_NumTransaccion,	Cuenta_CNBV16);



# ======================= SE CALCULAN LOS MONTOS PARA CADA Reg_Concepto ==========================

SET Var_FechaMes := (SELECT MAX(Fecha) FROM `HIS-CUENTASAHO` WHERE Fecha <= Var_FechaFin);
SET Var_FechaCieInv := (SELECT MAX(FechaCorte) FROM HISINVERSIONES WHERE FechaCorte <= Var_FechaFin);
SET Var_FechaCieCede := (SELECT MAX(FechaCorte) FROM SALDOSCEDES WHERE FechaCorte <= Var_FechaFin);

-- SET Var_FechaMes := Var_FechaFin; YOZHUA
# Poblar la tabla temporal de inversiones para agilizar la busqueda
INSERT INTO TMPINVERSIONESREG (
		InversionID,		Monto,						MontoN,			PlazoDias,			FechaVencimiento)
SELECT	Inv.InversionID,	Inv.Monto + SaldoProvision,	Inv.Monto+ SaldoProvision,		DATEDIFF(Inv.FechaVencimiento, Var_FechaMes), FechaVencimiento
	FROM HISINVERSIONES Inv
	WHERE	Inv.Estatus	= Estatus_Vigente
	 AND 	Inv.ClienteID <> Cliente_Inst
	 AND	Inv.FechaCorte	= Var_FechaCieInv ;


SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero), IFNULL(COUNT(DISTINCT(Inv.InversionID)), Entero_Cero)
		FROM TMPINVERSIONESREG Inv
		WHERE FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 7 DAY)
INTO Var_1Dia_7Dia,	Var_1Dia_7DiaNum;


SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero),  IFNULL(COUNT(DISTINCT(Inv.InversionID)), Entero_Cero)
		FROM TMPINVERSIONESREG Inv
		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 7 DAY)
		AND 	FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 1 MONTH)
INTO Var_8Dias_1Mes,	Var_8Dias_1MesNum;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero),   IFNULL(COUNT(DISTINCT(Inv.InversionID)), Entero_Cero)
		FROM TMPINVERSIONESREG Inv

		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 1 MONTH)
		AND 	FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 3 MONTH)
INTO Var_1Mes_3Mes,	Var_1Mes_3MesNum;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero),   IFNULL(COUNT(DISTINCT(Inv.InversionID)), Entero_Cero)
		FROM TMPINVERSIONESREG Inv

		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 3 MONTH)
		AND 	FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 6 MONTH)
INTO Var_3Mes_6Mes,	Var_3Mes_6MesNum;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero),   IFNULL(COUNT(DISTINCT(Inv.InversionID)), Entero_Cero)
		FROM TMPINVERSIONESREG Inv

		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 6 MONTH)
		AND 	FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 1 YEAR)
INTO Var_6Mes_1Anio,	Var_6Mes_1AnioNum;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero),   IFNULL(COUNT(DISTINCT(Inv.InversionID)), Entero_Cero)
		FROM TMPINVERSIONESREG Inv
		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 1 YEAR)
		AND 	FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 2 YEAR)
INTO Var_1anio_2Anio,	Var_1anio_2AnioNum;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero),   IFNULL(COUNT(DISTINCT(Inv.InversionID)), Entero_Cero)
		FROM TMPINVERSIONESREG Inv
		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 2 YEAR)
INTO Var_Mas_2Anio,		Var_Mas_2AnioNum;


INSERT INTO TMPCEDESREG (
		CedeID,		Monto,						MontoN,			PlazoDias,			FechaVencimiento)
SELECT	Cede.CedeID,	SaldoCede.SaldoCapital + SaldoCede.SaldoIntProvision,	SaldoCede.SaldoCapital + SaldoCede.SaldoIntProvision,
		DATEDIFF(Cede.FechaVencimiento, Var_FechaMes), Cede.FechaVencimiento
	FROM SALDOSCEDES SaldoCede,
	     CEDES Cede
	WHERE	SaldoCede.CedeID 		= Cede.CedeID
	 AND 	SaldoCede.Estatus		= Estatus_Vigente
	 AND	SaldoCede.FechaCorte	= Var_FechaCieCede
	 AND 	Cede.ClienteID			<> Cliente_Inst;


SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero), IFNULL(COUNT(DISTINCT(Cede.CedeID)), Entero_Cero)
		FROM TMPCEDESREG Cede
		WHERE FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 7 DAY)
INTO Var_1Dia_7DiaCede,	Var_1Dia_7DiaNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero),  IFNULL(COUNT(DISTINCT(Cede.CedeID)), Entero_Cero)
		FROM TMPCEDESREG Cede
		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 7 DAY)
		AND 	FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 1 MONTH)
INTO Var_8Dias_1MesCede,	Var_8Dias_1MesNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero),   IFNULL(COUNT(DISTINCT(Cede.CedeID)), Entero_Cero)
		FROM TMPCEDESREG Cede
		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 1 MONTH)
		AND 	FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 3 MONTH)
INTO Var_1Mes_3MesCede,	Var_1Mes_3MesNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero),   IFNULL(COUNT(DISTINCT(Cede.CedeID)), Entero_Cero)
		FROM TMPCEDESREG Cede
		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 3 MONTH)
		AND 	FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 6 MONTH)
INTO Var_3Mes_6MesCede,	Var_3Mes_6MesNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero),   IFNULL(COUNT(DISTINCT(Cede.CedeID)), Entero_Cero)
		FROM TMPCEDESREG Cede
		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 6 MONTH)
		AND 	FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 1 YEAR)
INTO Var_6Mes_1AnioCede,	Var_6Mes_1AnioNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero),   IFNULL(COUNT(DISTINCT(Cede.CedeID)), Entero_Cero)
		FROM TMPCEDESREG Cede
		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 1 YEAR)
		AND 	FechaVencimiento <= DATE_ADD(Var_FechaMes, INTERVAL 2 YEAR)
INTO Var_1anio_2AnioCede,	Var_1anio_2AnioNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero),   IFNULL(COUNT(DISTINCT(Cede.CedeID)), Entero_Cero)
		FROM TMPCEDESREG Cede
		WHERE	FechaVencimiento > DATE_ADD(Var_FechaMes, INTERVAL 2 YEAR)
INTO Var_Mas_2AnioCede,		Var_Mas_2AnioNumCede;

# ---------------------------------------------------------------------------------------------------------

# Verifico si se trata del anio y mes actual
# Poblar la temporal para agilizar el proceso de busqueda y calculo
DROP TABLE IF EXISTS TMPMOVAHORROTRES815;
CREATE TEMPORARY TABLE  TMPMOVAHORROTRES815
	SELECT  CuentaAhoID,	Saldo AS Saldo
	FROM	`HIS-CUENTASAHO` His
	WHERE  	 His.Fecha =  Var_FechaMes
    AND 	His.ClienteID	<>Cliente_Inst
     AND 	(His.Estatus = Estatus_Activo OR His.Estatus = Estatus_Bloqueado);


SELECT	SUM(Saldo) INTO Var_SaldoCuentas
	FROM TMPMOVAHORROTRES815 His;


SET Var_NumCuentas :=(	 SELECT	 IFNULL(COUNT(DISTINCT(CuentaAhoID)), Entero_Cero)
							FROM TMPMOVAHORROTRES815 His);


INSERT INTO TMPHISCUENTASAHO(CuentaAhoID,	SaldoN,	Saldo )
	SELECT  DISTINCT tmp.CuentaAhoID,	(IFNULL(SUM(tmp.Saldo),Entero_Cero)),		(IFNULL(SUM(tmp.Saldo),Entero_Cero))
	FROM	TMPMOVAHORROTRES815 tmp
    GROUP BY tmp.CuentaAhoID;

DROP TABLE IF EXISTS TMPMOVAHORROTRES815;
DROP TABLE IF EXISTS TMPMOVAHORRODOS815;
DROP TABLE IF EXISTS TMPMOVAHORRO815;


SELECT	IFNULL(SUM(SaldoN),Decimal_Cero),	IFNULL(COUNT(DISTINCT(CuentaAhoID)), Entero_Cero)
	FROM	TMPHISCUENTASAHO
	WHERE	SaldoN <= ROUND((6000 *Var_UDIS),2)
INTO	Var_6000UDIS,			Var_6000UDISNum;

SELECT	IFNULL(SUM(SaldoN),Decimal_Cero),	IFNULL(COUNT(DISTINCT(CuentaAhoID)), Entero_Cero)
	FROM TMPHISCUENTASAHO
	WHERE SaldoN > ROUND((6000*Var_UDIS),2)
	AND SaldoN <= ROUND((8000*Var_UDIS),2)
INTO	Var_6001_8000UDIS,		Var_6001_8000UDISNum;

SELECT IFNULL(SUM(SaldoN),Decimal_Cero), IFNULL(COUNT((CuentaAhoID)), Entero_Cero)
	FROM TMPHISCUENTASAHO
	WHERE SaldoN > ROUND((8000*Var_UDIS),2)
		AND SaldoN <= ROUND((10000*Var_UDIS),2)
INTO Var_8001_10000UDIS,		Var_8001_10000UDISNum;

SELECT IFNULL(SUM(SaldoN),Decimal_Cero), IFNULL(COUNT((CuentaAhoID)), Entero_Cero)
	FROM TMPHISCUENTASAHO
	WHERE SaldoN > ROUND((10000*Var_UDIS),2)
		AND SaldoN <= ROUND((15000*Var_UDIS),2)
INTO Var_10001_15000UDIS,		Var_10001_15000UDISNum;

SELECT IFNULL(SUM(SaldoN),Decimal_Cero), IFNULL(COUNT((CuentaAhoID)), Entero_Cero)
	FROM TMPHISCUENTASAHO
	WHERE SaldoN > ROUND((15000*Var_UDIS),2)
		AND SaldoN <= ROUND((20000*Var_UDIS),2)
INTO Var_15001_20000UDIS,		Var_15001_20000UDISNum;

SELECT IFNULL(SUM(SaldoN),Decimal_Cero), IFNULL(COUNT((CuentaAhoID)), Entero_Cero)
	FROM TMPHISCUENTASAHO
	WHERE SaldoN > ROUND((20000*Var_UDIS),2)
		AND SaldoN <= ROUND((25000*Var_UDIS),2)
INTO Var_20001_25000UDIS,		Var_20001_25000UDISNum;

SELECT IFNULL(SUM(SaldoN),Decimal_Cero), IFNULL(COUNT((CuentaAhoID)), Entero_Cero)
	FROM TMPHISCUENTASAHO
	WHERE SaldoN > ROUND((25000*Var_UDIS),2)
INTO Var_25000MasUDIS,		Var_25000MasUDISNum;


# Poblar la tabla temporal de inversiones para agilizar las busqueda
TRUNCATE TMPINVERSIONESREG;
INSERT INTO TMPINVERSIONESREG (
		InversionID,	MontoN,						Monto								)
SELECT 	InversionID,	(Monto + SaldoProvision) ,(Monto + SaldoProvision)
	FROM HISINVERSIONES
	WHERE	Estatus	= Estatus_Vigente
	 AND 	ClienteID <> Cliente_Inst
	 AND	FechaCorte	= Var_FechaCieInv;


SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero), IFNULL(COUNT(Inv.InversionID), Entero_Cero)
	FROM TMPINVERSIONESREG Inv
	WHERE Inv.Monto <= ROUND(6000*Var_UDIS,2)
INTO Var_6000UDISInv,	Var_6000UDISNumInv;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero), IFNULL(COUNT(Inv.InversionID), Entero_Cero)
	FROM TMPINVERSIONESREG Inv
	WHERE Inv.Monto > ROUND(6000*Var_UDIS,2)
		AND Inv.Monto <= ROUND((8000*Var_UDIS),2)
INTO Var_6001_8000UDISInv,		Var_6001_8000UDISNumInv;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero), IFNULL(COUNT(Inv.InversionID), Entero_Cero)
	FROM TMPINVERSIONESREG Inv
	WHERE Inv.Monto > ROUND((8000*Var_UDIS),2)
		AND Inv.Monto <= ROUND((10000*Var_UDIS),2)
INTO Var_8001_10000UDISInv,		Var_8001_10000UDISNumInv;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero), IFNULL(COUNT(Inv.InversionID), Entero_Cero)
	FROM TMPINVERSIONESREG Inv
	WHERE Inv.Monto > ROUND((10000*Var_UDIS),2)
		AND Inv.Monto <= ROUND((15000*Var_UDIS),2)
INTO Var_10001_15000UDISInv,		Var_10001_15000UDISNumInv;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero), IFNULL(COUNT(Inv.InversionID), Entero_Cero)
	FROM TMPINVERSIONESREG Inv
	WHERE Inv.Monto > ROUND((15000*Var_UDIS),2)
		AND Inv.Monto <= ROUND((20000*Var_UDIS),2)
INTO Var_15001_20000UDISInv,		Var_15001_20000UDISNumInv;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero), IFNULL(COUNT(Inv.InversionID), Entero_Cero)
	FROM TMPINVERSIONESREG Inv
	WHERE Inv.Monto > ROUND((20000*Var_UDIS),2)
		AND Inv.Monto <=  ROUND((25000*Var_UDIS),2)
INTO Var_20001_25000UDISInv,		Var_20001_25000UDISNumInv;

SELECT IFNULL(SUM(Inv.MontoN), Decimal_Cero), IFNULL(COUNT(Inv.InversionID), Entero_Cero)
	FROM TMPINVERSIONESREG Inv
	WHERE Inv.Monto > ROUND((25000*Var_UDIS),2)
INTO Var_25000MasUDISInv,		Var_25000MasUDISNumInv;

SET Var_NumCuentas:= Var_6000UDISNum + Var_6001_8000UDISNum + Var_8001_10000UDISNum + Var_10001_15000UDISNum + Var_15001_20000UDISNum + Var_20001_25000UDISNum + Var_25000MasUDISNum;

# Poblar la tabla temporal de CEDE para agilizar las busqueda
TRUNCATE TMPCEDESREG;
INSERT INTO TMPCEDESREG (
		CedeID,			MontoN,						Monto								)
SELECT	SaldoCede.CedeID,	(SaldoCede.SaldoCapital + SaldoCede.SaldoIntProvision),	SaldoCede.SaldoCapital
	FROM SALDOSCEDES SaldoCede,
	     CEDES Cede
	WHERE	SaldoCede.CedeID 		= Cede.CedeID
	 AND 	SaldoCede.Estatus		= Estatus_Vigente
	 AND	SaldoCede.FechaCorte	= Var_FechaCieCede
	 AND 	Cede.ClienteID			<> Cliente_Inst;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero), IFNULL(COUNT(Cede.CedeID), Entero_Cero)
	FROM TMPCEDESREG Cede
	WHERE Cede.Monto <= ROUND(6000*Var_UDIS,2)
INTO Var_6000UDISCede,	Var_6000UDISNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero), IFNULL(COUNT(Cede.CedeID), Entero_Cero)
	FROM TMPCEDESREG Cede
	WHERE Cede.Monto > ROUND(6000*Var_UDIS,2)
		AND Cede.Monto <= ROUND((8000*Var_UDIS),2)
INTO Var_6001_8000UDISCede,		Var_6001_8000UDISNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero), IFNULL(COUNT(Cede.CedeID), Entero_Cero)
	FROM TMPCEDESREG Cede
	WHERE Cede.Monto > ROUND((8000*Var_UDIS),2)
		AND Cede.Monto <= ROUND((10000*Var_UDIS),2)
INTO Var_8001_10000UDISCede,		Var_8001_10000UDISNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero), IFNULL(COUNT(Cede.CedeID), Entero_Cero)
	FROM TMPCEDESREG Cede
	WHERE Cede.Monto > ROUND((10000*Var_UDIS),2)
		AND Cede.Monto <= ROUND((15000*Var_UDIS),2)
INTO Var_10001_15000UDISCede,		Var_10001_15000UDISNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero), IFNULL(COUNT(Cede.CedeID), Entero_Cero)
	FROM TMPCEDESREG Cede
	WHERE Cede.Monto > ROUND((15000*Var_UDIS),2)
		AND Cede.Monto <= ROUND((20000*Var_UDIS),2)
INTO Var_15001_20000UDISCede,		Var_15001_20000UDISNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero), IFNULL(COUNT(Cede.CedeID), Entero_Cero)
	FROM TMPCEDESREG Cede
	WHERE Cede.Monto > ROUND((20000*Var_UDIS),2)
		AND Cede.Monto <=  ROUND((25000*Var_UDIS),2)
INTO Var_20001_25000UDISCede,		Var_20001_25000UDISNumCede;

SELECT IFNULL(SUM(Cede.MontoN), Decimal_Cero), IFNULL(COUNT(Cede.CedeID), Entero_Cero)
	FROM TMPCEDESREG Cede
	WHERE Cede.Monto > ROUND((25000*Var_UDIS),2)
INTO Var_25000MasUDISCede,		Var_25000MasUDISNumCede;

# =====Var_1Dia_7DiaNum + Var_NumCuentas + Var_8Dias_1MesNum + Var_1Mes_3MesNum + Var_3Mes_6MesNum + Var_6Mes_1AnioNum + Var_1anio_2AnioNum + Var_Mas_2AnioNum================== SE INSERTAN LOS MONTOS PARA CADA Reg_Concepto ==========================

UPDATE TMPREGR08A08110815
	SET Saldo		= Var_1Dia_7Dia + Var_SaldoCuentas + Var_8Dias_1Mes + Var_1Mes_3Mes + Var_3Mes_6Mes + Var_6Mes_1Anio + Var_1anio_2Anio + Var_Mas_2Anio +
					  Var_1Dia_7DiaCede + Var_8Dias_1MesCede + Var_1Mes_3MesCede + Var_3Mes_6MesCede + Var_6Mes_1AnioCede + Var_1anio_2AnioCede + Var_Mas_2AnioCede,
		NumCuentas	= Var_1Dia_7DiaNum + Var_NumCuentas + Var_8Dias_1MesNum + Var_1Mes_3MesNum + Var_3Mes_6MesNum + Var_6Mes_1AnioNum + Var_1anio_2AnioNum + Var_Mas_2AnioNum +
					  Var_1Dia_7DiaNumCede + Var_8Dias_1MesNumCede + Var_1Mes_3MesNumCede + Var_3Mes_6MesNumCede + Var_6Mes_1AnioNumCede + Var_1anio_2AnioNumCede + Var_Mas_2AnioNumCede
WHERE Reg_Orden = 2
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_1Dia_7Dia  + Var_SaldoCuentas + Var_1Dia_7DiaCede ,
		NumCuentas	= Var_1Dia_7DiaNum + Var_NumCuentas + Var_1Dia_7DiaNumCede
WHERE Reg_Orden = 3
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_8Dias_1Mes + Var_8Dias_1MesCede,
		NumCuentas	= Var_8Dias_1MesNum + Var_8Dias_1MesNumCede
WHERE Reg_Orden = 4
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_1Mes_3Mes + Var_1Mes_3MesCede,
		NumCuentas	= Var_1Mes_3MesNum + Var_1Mes_3MesNumCede
WHERE Reg_Orden = 5
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_3Mes_6Mes + Var_3Mes_6MesCede,
		NumCuentas	= Var_3Mes_6MesNum + Var_3Mes_6MesNumCede
WHERE Reg_Orden = 6
	AND Reg_ReporteID = Var_ReporteID;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_6Mes_1Anio + Var_6Mes_1AnioCede,
		NumCuentas	= Var_6Mes_1AnioNum + Var_6Mes_1AnioNumCede
WHERE Reg_Orden = 7
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_1anio_2Anio + Var_1anio_2AnioCede,
		NumCuentas	= Var_1anio_2AnioNum + Var_1anio_2AnioNumCede
WHERE Reg_Orden = 8
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_Mas_2Anio + Var_Mas_2AnioCede,
		NumCuentas	= Var_Mas_2AnioNum + Var_Mas_2AnioNumCede
WHERE Reg_Orden = 9
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

# -----------------------------------------------
# SE CALCULAN LAS UDIS
UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_6000UDIS + Var_6001_8000UDIS + Var_8001_10000UDIS + Var_10001_15000UDIS + Var_15001_20000UDIS + Var_20001_25000UDIS + Var_25000MasUDIS
					+ Var_6000UDISInv + Var_6001_8000UDISInv + Var_8001_10000UDISInv + Var_10001_15000UDISInv + Var_15001_20000UDISInv + Var_20001_25000UDISInv + Var_25000MasUDISInv
					+ Var_6000UDISCede + Var_6001_8000UDISCede + Var_8001_10000UDISCede + Var_10001_15000UDISCede + Var_15001_20000UDISCede + Var_20001_25000UDISCede + Var_25000MasUDISCede,
		NumCuentas	= Var_6000UDISNum + Var_6001_8000UDISNum + Var_8001_10000UDISNum + Var_10001_15000UDISNum + Var_15001_20000UDISNum + Var_20001_25000UDISNum + Var_25000MasUDISNum
					+ Var_6000UDISNumInv + Var_6001_8000UDISNumInv + Var_8001_10000UDISNumInv + Var_10001_15000UDISNumInv + Var_15001_20000UDISNumInv + Var_20001_25000UDISNumInv + Var_25000MasUDISNumInv
					+ Var_6000UDISNumCede + Var_6001_8000UDISNumCede + Var_8001_10000UDISNumCede + Var_10001_15000UDISNumCede + Var_15001_20000UDISNumCede + Var_20001_25000UDISNumCede + Var_25000MasUDISNumCede
WHERE Reg_Orden = 11
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_6000UDIS + Var_6000UDISInv + Var_6000UDISCede,
		NumCuentas	= Var_6000UDISNum + Var_6000UDISNumInv + Var_6000UDISNumCede
WHERE Reg_Orden = 12
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_6001_8000UDIS + Var_6001_8000UDISInv + Var_6001_8000UDISCede,
		NumCuentas	= Var_6001_8000UDISNum + Var_6001_8000UDISNumInv + Var_6001_8000UDISNumCede
WHERE Reg_Orden = 13
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_8001_10000UDIS + Var_8001_10000UDISInv + Var_8001_10000UDISCede,
		NumCuentas	= Var_8001_10000UDISNum + Var_8001_10000UDISNumInv + Var_8001_10000UDISNumCede
WHERE Reg_Orden = 14
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_10001_15000UDIS + Var_10001_15000UDISInv + Var_10001_15000UDISCede,
		NumCuentas	= Var_10001_15000UDISNum + Var_10001_15000UDISNumInv + Var_10001_15000UDISNumCede
WHERE Reg_Orden = 15
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_15001_20000UDIS + Var_15001_20000UDISInv + Var_15001_20000UDISCede,
		NumCuentas	= Var_15001_20000UDISNum + Var_15001_20000UDISNumInv + Var_15001_20000UDISNumCede
WHERE Reg_Orden = 16
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_20001_25000UDIS + Var_20001_25000UDISInv + Var_20001_25000UDISCede,
		NumCuentas	= Var_20001_25000UDISNum + Var_20001_25000UDISNumInv + Var_20001_25000UDISNumCede
WHERE Reg_Orden = 17
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR08A08110815
	SET Saldo 		= Var_25000MasUDIS + Var_25000MasUDISInv + Var_25000MasUDISCede,
		NumCuentas	= Var_25000MasUDISNum + Var_25000MasUDISNumInv + Var_25000MasUDISNumCede
WHERE Reg_Orden = 18
	AND Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;

/*Periodo del reporte */
IF(Par_Mes < 10) THEN
    SET Var_Periodo    :=  CONCAT(Par_Anio,'0',Par_Mes);
  ELSE
    SET Var_Periodo    :=  CONCAT(Par_Anio,Par_Mes);
    END IF;

/* Reporte Regulatorio 0815 en Excel */
IF(Par_NumReporte = Rep_Excel) THEN
	# =================== SE OBTIENEN LOS DATOS PARA MOSTRAR EN EL REPORTE =======================
	SELECT Var_Periodo AS Periodo ,Var_ClaveFedera AS ClaveFedera,	Var_ClaveEntidad AS ClaveEntidad, Clave_NivInst AS NivelEntidad, Reg_Concepto AS Concepto, ROUND(Saldo,Entero_Cero) AS Saldo,		NumCuentas,		Var_UDIS
		FROM TMPREGR08A08110815
	WHERE Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion;
END IF;

/* Reporte Regulatorio 0815 Csv */
IF(Par_NumReporte = Rep_Csv) THEN
	/* SE REALIZA EL SELECT */
	(SELECT CONCAT(
		Clave_NivInst,	";",	Reg_CuentaCNBV,	";",
		Var_ReporteID,				";",	Var_ClaveSaldo,	";",	ROUND(Saldo,Entero_Cero)
	) AS Valor
		FROM TMPREGR08A08110815
	WHERE Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion
	AND Reg_Orden NOT IN (1,10))
	UNION ALL
	(SELECT CONCAT(
		Clave_NivInst,	";",	Reg_CuentaCNBV,	";",
		Var_ReporteID,				";",	Var_ClaveVencim,	";",	NumCuentas
	) AS Valor
		FROM TMPREGR08A08110815
	WHERE Reg_ReporteID = Var_ReporteID
	AND NumTransaccion = Aud_NumTransaccion
	AND Reg_Orden NOT IN (1,10));

END IF;

/* se limpian los datos en la tabla de paso*/
DELETE FROM TMPREGR08A08110815 WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$