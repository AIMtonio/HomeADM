-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGC045300003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGC045300003REP`;
DELIMITER $$


CREATE PROCEDURE `REGC045300003REP`(
	Par_Fecha           DATE,				-- Fecha del Reporte
	Par_NumReporte      TINYINT UNSIGNED,	-- Tipo de Reporte

    Par_EmpresaID       INT(11),			-- Parametro de Auditoria Empresa ID
    Aud_Usuario         INT(11),			-- Parametro de Auditoria Usuario ID
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria Programa ID
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria Sucursal OD
    Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria Numero Transaccion
	)

TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE	Var_ClaveEntidad	VARCHAR(300);
DECLARE Var_Periodo			CHAR(6);
DECLARE Var_UltFecEPRC 		DATE;
DECLARE Var_FechaIniMesSis	DATE;
DECLARE Var_MesAnterior 	DATE;

-- DECLARACION DE CONSTANTES
DECLARE Decimal_Cero	DECIMAL(21,2);
DECLARE Fecha_Vacia		DATE;
DECLARE Rep_Excel       INT(11);
DECLARE Rep_Csv			INT(11);
DECLARE tipomoneda		INT(11);

DECLARE Tipo_Cartera	INT(11);
DECLARE Tipo_EPRC		INT(11);
DECLARE folio_form		CHAR(4);
DECLARE Tipo_Saldo		CHAR(1);
DECLARE Tipo_EPRC_CAL	CHAR(3);
DECLARE Tipo_EPRC_ADI   CHAR(3);
DECLARE Nivel_D			CHAR(1);
DECLARE ESTCRE_VENCIDO	CHAR(1);
DECLARE CLASIF_REEST	CHAR(1);
DECLARE Rest_ORI_NA		CHAR(3);
DECLARE CADENA_VACIA	CHAR(1);
DECLARE Cla_Comercial   CHAR(1);
DECLARE Cla_Consumo     CHAR(1);
DECLARE Cla_Vivienda    CHAR(1);
DECLARE Baja_Liquida	INT(11);
DECLARE Baja_Venta		INT(11);

DECLARE Baja_Reestruct	INT(11);
DECLARE Baja_Renovacion	INT(11);
DECLARE Baja_Covid19	INT(11);
DECLARE Tipo_Renovacion	CHAR(1);
DECLARE Tipo_Reestruct	CHAR(1);

DECLARE Tipo_Diferido	CHAR(1);
DECLARE Clave_Reporte	CHAR(3);
DECLARE Entero_Uno		INT(11);

-- Asignacion de Constantes
SET Decimal_Cero	:= 0.0;
SET Fecha_Vacia		:= '1900-01-01';		-- Fecha Vacia


SET Rep_Excel       := 	1;
SET Rep_Csv			:= 	2;
SET tipomoneda		:= 	14;
SET folio_form		:= 	'417';
SET Tipo_Saldo		:= 	'1';
SET Tipo_Cartera	:= 	9;
SET Tipo_EPRC		:= 	10;


SET Tipo_EPRC_CAL	:= 	'CAL';
SET Tipo_EPRC_ADI	:= 	'ADI';
SET Nivel_D			:=	'D';
SET ESTCRE_VENCIDO	:=	'B';
SET CLASIF_REEST	:=	'R';
SET Rest_ORI_NA		:= 	'na';
SET CADENA_VACIA	:=	'';

SET Cla_Comercial   := 'C';
SET Cla_Consumo     := 'O';
SET Cla_Vivienda    := 'H';
SET	Baja_Liquida	:= 132;			-- Clave de la Baja: Liquidacion o Pago del Acreditado
SET	Baja_Reestruct	:= 133;			-- Clave de la Baja: Reestructura
SET	Baja_Renovacion	:= 134;			-- Clave de la Baja: Renovacion
SET Baja_Covid19	:= 160;
SET Baja_Venta		:= 136; -- Clave 136	En balance: Venta o cesión de cartera

SET	Tipo_Renovacion := 'O';			-- Tipo de Tratamiento: Renovacion
SET	Tipo_Reestruct 	:= 'R';			-- Tipo de Tratamiento: Reestructura
SET Tipo_Diferido	:= 'D';			-- Tipo de Tratamiento: Diferido Covid-19
SET	Clave_Reporte 	:= '453';		-- Clave del Reporte
SET Entero_Uno		:= 1;


SET Var_Periodo = CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),1,4),
					  SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),5,2));

SET Var_ClaveEntidad	:= IFNULL((SELECT Par.ClaveEntidad
								FROM PARAMETROSSIS Par
								WHERE Par.EmpresaID = Par_EmpresaID), CADENA_VACIA);

SET Var_FechaIniMesSis	:= DATE_ADD(Par_Fecha, INTERVAL -1*(DAY(Par_Fecha))+1 DAY);
SET Var_MesAnterior		:= DATE_SUB(Var_FechaIniMesSis, INTERVAL 1 DAY);


DROP TABLE IF EXISTS TMP_CREDITOSBAJA;

CREATE temporary TABLE TMP_CREDITOSBAJA (
	CreditoID			BIGINT,
	IdenCreditoCNBV		VARCHAR(29),
	FechTerminacion		DATE,
	TipoBaja			INT,
	SaldoInsoluto		DECIMAL(14,2),
	MontoPagado			DECIMAL(14,2),
	MontoCastigos		DECIMAL(14,2),
	MontoCondona		DECIMAL(14,2),
	MontoQuita			DECIMAL(14,2),
	MontoBonifica		DECIMAL(14,2),
	MontoDescuento		DECIMAL(14,2),
	MontoDacion			DECIMAL(14,2),
	MontoFueraB			DECIMAL(14,2),
	EPRCCancel			DECIMAL(14,2),
	EPRCAdiCancel		DECIMAL(14,2),
	FechaSaldos			DATE
	);

CREATE INDEX idx_TMP_CREDITOSBAJA_1 ON TMP_CREDITOSBAJA(CreditoID);


DROP TABLE IF EXISTS TMP_CREDITOSBAJA_VTA;
CREATE temporary TABLE TMP_CREDITOSBAJA_VTA (
	CreditoID			BIGINT,
	IdenCreditoCNBV		VARCHAR(29),
	FechTerminacion		DATE,
	TipoBaja			INT,
	SaldoInsoluto		DECIMAL(14,2),
	MontoPagado			DECIMAL(14,2),
	MontoCastigos		DECIMAL(14,2),
	MontoCondona		DECIMAL(14,2),
	MontoQuita			DECIMAL(14,2),
	MontoBonifica		DECIMAL(14,2),
	MontoDescuento		DECIMAL(14,2),
	MontoDacion			DECIMAL(14,2),
	MontoFueraB			DECIMAL(14,2),
	EPRCCancel			DECIMAL(14,2),
	EPRCAdiCancel		DECIMAL(14,2),
	FechaSaldos			DATE
	);

CREATE INDEX idx_TMP_CREDITOSBAJA_VTA_1 ON TMP_CREDITOSBAJA_VTA(CreditoID);


-- Query Principal para los Creditos que fueron pagados en el Periodo (Mes)
INSERT INTO TMP_CREDITOSBAJA
	SELECT	Cre.CreditoID,	Cre.IdenCreditoCNBV,	Cre.FechTerminacion,	Baja_Liquida,	Decimal_Cero,
			Decimal_Cero,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,	Decimal_Cero,
			Decimal_Cero,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,	Decimal_Cero,
			DATE_SUB(FechTerminacion, INTERVAL 1 DAY) AS FechaSaldos
	 FROM CREDITOS Cre
	 WHERE
	 	Cre.Estatus not in ('C', 'X') AND
		FechTerminacion BETWEEN Var_FechaIniMesSis AND Par_Fecha;

-- AGREGAMOS LAS REESTRUCTURAS
INSERT INTO TMP_CREDITOSBAJA
	SELECT	 Crd.CreditoID,	Crd.IdenCreditoCNBV,	Crd.FechTerminacion,	Tipo_Reestruct,	Decimal_Cero,
			Decimal_Cero,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,	Decimal_Cero,
			Decimal_Cero,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,	Decimal_Cero,
			DATE_SUB(Cre.FechaRegistro, INTERVAL 1 DAY) AS FechaSaldos

	 FROM REESTRUCCREDITO Cre,
		  CREDITOS Crd
	 WHERE
		Crd.Estatus not in ('C', 'X')  AND
	 	Cre.FechaRegistro BETWEEN Var_FechaIniMesSis AND Par_Fecha
	   AND Cre.Origen = Tipo_Reestruct
	   AND Cre.Origen = Crd.CreditoID
	   AND ( IFNULL(FechTerminacion, Fecha_Vacia) = Fecha_Vacia
		OR   IFNULL(FechTerminacion, Fecha_Vacia) > Par_Fecha );

-- AGREGAMOS LOS DIFERIDOS
INSERT INTO TMP_CREDITOSBAJA
SELECT	 Crd.CreditoID,	Crd.IdenCreditoCNBV,	Crd.FechTerminacion,		Baja_Covid19,	Decimal_Cero,
			Decimal_Cero,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,	Decimal_Cero,
			Decimal_Cero,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,	Decimal_Cero,
			DATE_SUB(Cre.FechaAplicacion, INTERVAL 1 DAY) AS FechaSaldos

	 FROM CREDITOSDIFERIDOS Cre,
		  CREDITOS Crd
	 WHERE Crd.Estatus not in ('C', 'X')
	   AND Cre.FechaAplicacion BETWEEN Var_FechaIniMesSis AND Par_Fecha
	   AND Cre.CreditoID = Crd.CreditoID
	   AND Cre.NumeroDiferimientos = Entero_Uno;


INSERT INTO TMP_CREDITOSBAJA
SELECT	 Crd.CreditoID,	Crd.IdenCreditoCNBV,	Crd.FechTerminacion,		Baja_Covid19,	Decimal_Cero,
			Decimal_Cero,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,	Decimal_Cero,
			Decimal_Cero,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,	Decimal_Cero,
			DATE_SUB(Cre.FechaAplicacion, INTERVAL 1 DAY) AS FechaSaldos

	 FROM CREDITOSDIFERIDOS Cre,
		  CREDITOS Crd
	 WHERE Crd.Estatus not in ('C', 'X')
	   AND Cre.FechaAplicacion BETWEEN Var_FechaIniMesSis AND Par_Fecha
	   AND Cre.CreditoOrigenID = Crd.CreditoID
	   AND Cre.NumeroDiferimientos = Entero_Uno;


DELETE C.* FROM
TMP_CREDITOSBAJA C, CREDITOSDIFERIDOS D
WHERE C.CreditoID = D.CreditoID
AND D.FechaAplicacion BETWEEN Var_FechaIniMesSis AND Par_Fecha
AND C.TipoBaja <> Baja_Covid19;

DELETE C.* FROM
TMP_CREDITOSBAJA C, CREDITOSDIFERIDOS D
WHERE C.CreditoID = D.CreditoOrigenID
AND D.FechaAplicacion BETWEEN Var_FechaIniMesSis AND Par_Fecha
AND C.TipoBaja <> Baja_Covid19;


-- MONTO PAGADO AL MOMENTO DE LA BAJA
UPDATE TMP_CREDITOSBAJA Tem, SALDOSCREDITOS Sal SET

	Tem.MontoPagado	  = (Sal.PagoCapVigDia + Sal.PagoCapAtrDia + Sal.PagoCapVenDia +
						 Sal.PagoCapVenNexDia + Sal.PagoIntOrdDia + Sal.PagoIntVenDia +
						 Sal.PagoIntAtrDia + Sal.PagoIntCalNoCon + Sal.PagoComisiDia +
						 Sal.PagoMoratorios)
	WHERE Sal.CreditoID = Tem.CreditoID
	AND Sal.FechaCorte = Tem.FechTerminacion;


-- SALDO INSOLUTO DEL CREDITO AL MOMENTO DE LA BAJA
-- Tomamos el Saldo del Dia Anterior

UPDATE TMP_CREDITOSBAJA Tem, SALDOSCREDITOS Sal SET

		Tem.SaldoInsoluto = (Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi +
							 Sal.SalCapVigente +  Sal.SalComFaltaPago +  Sal.SaldoComServGar + Sal.SaldoMoraCarVen +
							 Sal.SaldoMoraVencido + Sal.SalIntAtrasado + Sal.SalIntNoConta +
							 Sal.SalIntProvision + Sal.SalIntVencido + Sal.SalMoratorios +
							 Sal.SalOtrasComisi)

	WHERE Sal.CreditoID = Tem.CreditoID
	AND Sal.FechaCorte = Tem.FechaSaldos;

-- CREDITOS CASTIGADOS
DROP TABLE IF EXISTS TMP_CASTIGOSMES;

CREATE TEMPORARY TABLE TMP_CASTIGOSMES (
	CreditoID			BIGINT,
	CapitalCastigado	DECIMAL(14,2),
	InteresCastigado	DECIMAL(14,2),
	IntMoraCastigado	DECIMAL(14,2),
	TotalCastigo		DECIMAL(14,2)
	);

CREATE INDEX idx_TMP_CASTIGOSMES_1 ON TMP_CASTIGOSMES(CreditoID);

INSERT INTO TMP_CASTIGOSMES
	SELECT Cas.CreditoID,	Cas.CapitalCastigado,	Cas.InteresCastigado,	Cas.IntMoraCastigado,	Cas.TotalCastigo
		FROM CRECASTIGOS Cas
		WHERE Fecha BETWEEN Var_FechaIniMesSis AND Par_Fecha;

UPDATE TMP_CREDITOSBAJA Tem, TMP_CASTIGOSMES Cas SET
	 Tem.MontoCastigos = Cas.TotalCastigo
	WHERE Tem.CreditoID = Cas.CreditoID;

DROP TABLE IF EXISTS TMP_CASTIGOSMES;


-- =========== QUITAS
DROP TABLE IF EXISTS TMP_CONDONACIONES;

CREATE TEMPORARY TABLE TMP_CONDONACIONES (
	CreditoID		BIGINT,
	MontoCondona	DECIMAL(14,2),
	MontoMoratorios	DECIMAL(14,2)
);

CREATE INDEX idx_TMP_CONDONACIONES_1 ON TMP_CONDONACIONES(CreditoID);

INSERT INTO TMP_CONDONACIONES
	SELECT	Con.CreditoID,
			SUM(Con.MontoComisiones + Con.MontoMoratorios + Con.MontoInteres + Con.MontoCapital) AS MontoCondona,
			SUM(Con.MontoMoratorios) AS MontoMoratorios

		FROM CREQUITAS Con
		WHERE Con.FechaRegistro BETWEEN Var_FechaIniMesSis AND Par_Fecha
		GROUP BY Con.CreditoID;

UPDATE TMP_CREDITOSBAJA Tem, TMP_CONDONACIONES Con SET
	Tem.MontoCondona = Con.MontoCondona,
	Tem.MontoFueraB = Con.MontoMoratorios

	WHERE Tem.CreditoID = Con.CreditoID;

DROP TABLE IF EXISTS TMP_CONDONACIONES;

-- ================== ERPC Cancelada

DROP TABLE IF EXISTS TMP_EPRC;

CREATE TEMPORARY TABLE TMP_EPRC (
	CreditoID	BIGINT,
	Reserva		DECIMAL(14,2)
);

CREATE INDEX idx_TMP_EPRC_1 ON TMP_EPRC(CreditoID);

INSERT INTO TMP_EPRC
	SELECT Res.CreditoID, (Res.SaldoResCapital + Res.SaldoResInteres)
		FROM CALRESCREDITOS Res,
			 TMP_CREDITOSBAJA Tem
		WHERE Res.Fecha = Var_MesAnterior
		  AND Res.CreditoID = Tem.CreditoID;


UPDATE TMP_CREDITOSBAJA Tem, TMP_EPRC Cas SET
	Tem.EPRCCancel = ABS(Cas.Reserva) -- * -1 --vmartinez

	WHERE Tem.CreditoID = Cas.CreditoID
	  AND Tem.TipoBaja != Baja_Reestruct;

DROP TABLE IF EXISTS TMP_EPRC;


-- ==== EPRC Adicional
DROP TABLE IF EXISTS TMP_EPRCADI;

CREATE TEMPORARY TABLE TMP_EPRCADI(
	CreditoID 	BIGINT,
	Monto		DECIMAL(14,2)
	);

CREATE INDEX idx_TMP_EPRCADI_1 ON TMP_EPRCADI(CreditoID);

INSERT INTO TMP_EPRCADI
SELECT Sal.CreditoID, (Sal.SalIntVencido + Sal.SaldoMoraVencido)
	FROM SALDOSCREDITOS Sal,
		 TMP_CREDITOSBAJA Tem
	WHERE Sal.FechaCorte = Var_MesAnterior
	AND  Sal.CreditoID = Tem.CreditoID;


UPDATE TMP_CREDITOSBAJA Tem,TMP_EPRCADI Cas SET
	Tem.EPRCAdiCancel = ABS(Cas.Monto) * -1
	WHERE Tem.CreditoID = Cas.CreditoID;

DROP TABLE IF EXISTS TMP_EPRCADI;

-- CREDITOS RENOVADOS
UPDATE TMP_CREDITOSBAJA Tem, REESTRUCCREDITO Res SET
		Tem.TipoBaja = Baja_Renovacion
	WHERE Tem.CreditoID = Res.CreditoOrigenID
	  AND Res.FechaRegistro  BETWEEN Var_FechaIniMesSis AND Par_Fecha
	  AND Res.Origen = Tipo_Renovacion;


-- CREDITOS VENDIDOS **********************************************************************************
-- AGREGAMOS LOS VENDIDOS
INSERT INTO TMP_CREDITOSBAJA_VTA
	SELECT	Cre.CreditoID,	Cre.IdenCreditoCNBV,	Cre.FechTerminacion,	Baja_Venta,
			ifnull(Ven.SaldoCapAtrasa,Decimal_Cero)		+ ifnull(Ven.SaldoCapVencido,Decimal_Cero)	+ ifnull(Ven.SaldoCapVenNExi,Decimal_Cero) +
			ifnull(Ven.SaldoCapVigente,Decimal_Cero)	+ ifnull(Ven.SaldoComFaltaPa,Decimal_Cero) 	+ ifnull(Ven.SalMoraCarVen,Decimal_Cero) 	+
			ifnull(Ven.SalMoraVencido,Decimal_Cero) 	+ ifnull(Ven.SaldoInteresAtr,Decimal_Cero) 	+ ifnull(Ven.SaldoIntNoConta,Decimal_Cero) +
			ifnull(Ven.SaldoInteresPro,Decimal_Cero) 	+ ifnull(Ven.SaldoInteresVen,Decimal_Cero) 	+ ifnull(Ven.SaldoMoratorios,Decimal_Cero) +
			ifnull(Ven.SaldoOtrasComis,Decimal_Cero),
			Decimal_Cero,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,	Decimal_Cero,
			Decimal_Cero,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,	ABS(ifnull(Ven.SaldoInteresVen,Decimal_Cero) + ifnull(Ven.SalMoraVencido,Decimal_Cero)) * -1,
			DATE_SUB(FechTerminacion, INTERVAL 1 DAY) AS FechaSaldos
	 FROM	CREDITOS Cre,
	 		HISCREDITOSVENTACAR Ven
	 WHERE Cre.CreditoID = Ven.CreditoID
	 	AND Cre.Estatus in ('X') AND Ven.Tipo="PROCESADO"
		AND FechTerminacion BETWEEN Var_FechaIniMesSis AND Par_Fecha;

--  reservas  --------------------------------------------------------------------------------------
DROP TABLE IF EXISTS TMP_REG453RESVTA;
CREATE temporary TABLE TMP_REG453RESVTA (
	CreditoID			BIGINT,
	FecAntRes 			DATE
	);
CREATE INDEX idx_TMP_REG453RESVTA_1 ON TMP_REG453RESVTA(CreditoID);

INSERT INTO TMP_REG453RESVTA
SELECT  cal.CreditoID ,	IFNULL(MAX(cal.Fecha), Fecha_Vacia)
	FROM CALRESCREDITOSVTA cal
	INNER JOIN TMP_CREDITOSBAJA_VTA his ON cal.CreditoID = his.CreditoID
	GROUP BY cal.CreditoID ;

DROP TABLE IF EXISTS TMP_REG453RESVTA_1;
CREATE temporary TABLE TMP_REG453RESVTA_1 (
	CreditoID			BIGINT,
	ReservaCapital 		DECIMAL(14,2),
	ReservaInteres 		DECIMAL(14,2)
	);
CREATE INDEX idx_TMP_REG453RESVTA_1_1 ON TMP_REG453RESVTA_1(CreditoID);
INSERT INTO TMP_REG453RESVTA_1
SELECT CAL.CreditoID, SUM(ifnull(SaldoResInteres,Decimal_Cero)), SUM(ifnull(SaldoResCapital,Decimal_Cero))
    FROM CALRESCREDITOSVTA CAL
    inner join TMP_REG453RESVTA TMP on TMP.CreditoID = CAL.CreditoID
      AND CAL.Fecha = TMP.FecAntRes
		AND  TMP.FecAntRes != Fecha_Vacia
GROUP BY CAL.CreditoID;

UPDATE TMP_CREDITOSBAJA_VTA Tem, TMP_REG453RESVTA_1 Res SET
		Tem.EPRCCancel =  ABS(ReservaCapital + ReservaInteres) * -1
	WHERE Tem.CreditoID = Res.CreditoID;

-- AGREGAMOS LOS DIFERIDOS
INSERT INTO TMP_CREDITOSBAJA
SELECT	 *
	 FROM TMP_CREDITOSBAJA_VTA Cre;

DROP TABLE IF EXISTS TMP_ULT_PAGO;
CREATE temporary TABLE TMP_ULT_PAGO(
	CreditoID BIGINT(20) PRIMARY KEY,
	FechaPago DATE,
	NumTransaccion BIGINT
);

DROP TABLE IF EXISTS TMP_SALDO_ULT_PAGO;
CREATE TEMPORARY TABLE TMP_SALDO_ULT_PAGO(
	CreditoID BIGINT(20) PRIMARY KEY,
	SaldoLiquida DECIMAL(16,2),
	SaldoInsoluto DECIMAL(16,2)
);

INSERT INTO TMP_ULT_PAGO
SELECT det.CreditoID,MAX(det.FechaPago) AS FechaUltPago, MAX(det.NumTransaccion)
FROM DETALLEPAGCRE det,TMP_CREDITOSBAJA baj
WHERE det.CreditoID = baj.CreditoID
AND det.FechaPago >= Var_FechaIniMesSis
GROUP BY det.CreditoID;

INSERT INTO TMP_SALDO_ULT_PAGO
SELECT det.CreditoID,SUM(det.MontoTotPago),
sum( det.MontoCapOrd+ det.MontoCapAtr+det.MontoCapVen+det.MontoIntOrd+det.MontoIntAtr+det.MontoIntVen+det.MontoIntMora)
FROM DETALLEPAGCRE det,TMP_ULT_PAGO baj
WHERE det.CreditoID = baj.CreditoID
AND det.FechaPago = baj.FechaPago
-- AND det.NumTransaccion = baj.NumTransaccion
GROUP BY det.CreditoID;

UPDATE TMP_CREDITOSBAJA baj,TMP_SALDO_ULT_PAGO sal
	SET baj.MontoPagado = sal.SaldoLiquida,
		baj.SaldoInsoluto = sal.SaldoInsoluto
WHERE baj.CreditoID = sal.CreditoID;


DELETE FROM TMP_SALDO_ULT_PAGO;
DROP TABLE IF EXISTS TMP_SALDO_ULT_PAGO;
CREATE TEMPORARY TABLE TMP_SALDO_ULT_PAGO(
	CreditoID BIGINT(20) PRIMARY KEY,
	SaldoLiquida DECIMAL(16,2)
);


INSERT INTO TMP_SALDO_ULT_PAGO
SELECT mov.CreditoID,
sum(mov.Cantidad)
FROM CREDITOSMOVS mov,TMP_CREDITOSBAJA baj
WHERE mov.FechaAplicacion BETWEEN Var_FechaIniMesSis AND Par_Fecha
AND mov.CreditoID = baj.CreditoID
AND mov.TipoMovCreID IN(12)
AND mov.NatMovimiento = 'A'
AND( mov.Descripcion LIKE '%PAGO%'
OR mov.Descripcion LIKE '%CONDONA%'
OR mov.Descripcion LIKE '%CASTIGO%')
GROUP BY mov.CreditoID;

UPDATE TMP_CREDITOSBAJA baj,TMP_SALDO_ULT_PAGO sal
	SET baj.EPRCAdiCancel =  sal.SaldoLiquida
WHERE baj.CreditoID = sal.CreditoID;


DELETE FROM TMP_SALDO_ULT_PAGO;
INSERT INTO TMP_SALDO_ULT_PAGO
SELECT mov.CreditoID,
sum(mov.Cantidad)
FROM CREDITOSMOVS mov,TMP_CREDITOSBAJA baj
WHERE mov.FechaAplicacion BETWEEN Var_FechaIniMesSis AND Par_Fecha
AND mov.CreditoID = baj.CreditoID
AND mov.TipoMovCreID IN(13,15)
AND mov.NatMovimiento = 'A'
AND( mov.Descripcion LIKE '%PAGO%'
OR mov.Descripcion LIKE '%CONDONA%'
OR mov.Descripcion LIKE '%CASTIGO%')
GROUP BY mov.CreditoID;

UPDATE TMP_CREDITOSBAJA baj, TMP_SALDO_ULT_PAGO sal
	SET baj.MontoFueraB =  sal.SaldoLiquida
WHERE baj.CreditoID = sal.CreditoID;

-- === Reporte


	IF( Par_NumReporte = Rep_Excel) THEN

		SELECT 	Var_Periodo,		Var_ClaveEntidad,	Clave_Reporte AS Reporte,
				IdenCreditoCNBV, 	TipoBaja, 			SaldoInsoluto,
                MontoPagado, 		MontoCastigos, 		MontoCondona,
                MontoQuita, 		MontoBonifica, 		MontoDescuento,
                MontoDacion, 		MontoFueraB, 		EPRCCancel,
                EPRCAdiCancel
		FROM TMP_CREDITOSBAJA;


	ELSE
			IF( Par_NumReporte = Rep_Csv) THEN

                SELECT IFNULL(CONCAT(Clave_Reporte			, ';',
						IdenCreditoCNBV						, ';',
                        TipoBaja							, ';',
                        IFNULL(SaldoInsoluto,Decimal_Cero)	, ';',
						IFNULL(MontoPagado,Decimal_Cero)	, ';',
                        IFNULL(MontoCastigos,Decimal_Cero)	, ';',
                        IFNULL( MontoCondona,Decimal_Cero)	, ';',
						IFNULL(MontoQuita,Decimal_Cero)		, ';',
                        IFNULL(MontoBonifica,Decimal_Cero)	, ';',
                        IFNULL(MontoDescuento,Decimal_Cero)	, ';',
						IFNULL(MontoDacion,Decimal_Cero)	, ';',
                        IFNULL(MontoFueraB,Decimal_Cero)	, ';',
                        IFNULL(EPRCCancel,Decimal_Cero)		, ';',
						IFNULL(EPRCAdiCancel,Decimal_Cero)), Cadena_Vacia) AS Valor
				FROM TMP_CREDITOSBAJA;



			END IF;
	END IF;


END TerminaStore$$