-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATOCREDITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOCREDITOCON`;
DELIMITER $$

CREATE PROCEDURE `CONTRATOCREDITOCON`(
-- SP PARA CONSULTAR LOS DATOS DE CREDITO DIVIDIDOS POR TIPO DE REPORTE
    Par_CredID		BIGINT(20),			-- Numero de Credito
    Par_NumCon		TINYINT UNSIGNED,	-- Numero de Consulta

-- AUDITORIA GENERAL - PARAMETROS DE LA AUDITORIA    
    Aud_EmpresaID		INT(11),		-- ID de la empresa
    Aud_Usuario			INT(11),		-- ID del usuario
    Aud_FechaActual		DATETIME,		-- Fecha actual
    Aud_DireccionIP		VARCHAR(15),	-- Direccion IP
    Aud_ProgramaID		VARCHAR(50),	-- Programa
	Aud_Sucursal	    INT(11),		-- ID de la sucursal
	Aud_NumTransaccion  BIGINT(20)		-- Numero de la transaccion
)
TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES
    DECLARE	Cadena_Vacia	CHAR(1);	    -- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;		    -- Fecha vacia
	DECLARE	Entero_Cero		INT(11);	    -- Entero en cero
    DECLARE	Entero_Uno		INT(11);	    -- Entero en uno
    DECLARE	Entero_Dos		INT(11);	    -- Entero en dos
    DECLARE	Decimal_Cero	DECIMAL(12,2);	-- Decimal en cero
    DECLARE NOENCONTRADO	VARCHAR(100);	-- Valor que indica que no existe
    -- CONSULTA DEL REPORTE - CONTRATOS CON RECA
	DECLARE Con_SegA	INT(2);	-- 1 _ ANEXO A
    DECLARE Con_SegB	INT(2);	-- 2 _ ANEXO B
    DECLARE Con_SegC	INT(2);	-- 3 _ ANEXO C
    DECLARE Con_SegD	INT(2);	-- 4 _ CONTRATO APERTURA DE CREDITO AViO AGROPECUARIO
    DECLARE Con_SegE	INT(2);	-- 5 _ PRECEPTOS LEGALES
    DECLARE Con_SegF	INT(2);	-- 6 _ CONSULTA DEL REPORTE RECA SOLICITUD DE CREDITO DE PERSONA FISICA
    DECLARE Con_SegG	INT(2);	-- 7 _ CONSULTA DEL REPORTE RECA SOLICITUD DE CREDITO DE PERSONA MORAL
    -- CONSULTA DEL REPORTE - CONTRATOS SIN RECA
    DECLARE Con_SegH	INT(2);	--  8 _ AUTORIZACION DE CARGO AUTOMATICO
    DECLARE Con_SegI	INT(2);	--  9 _ CESION DE DERECHOS
    DECLARE Con_SegJ	INT(2);	-- 10 _ DECLARATORIA DUD
    DECLARE Con_SegK	INT(2);	-- 11 _ PAGARE PAGO UNICO INTERES MENSUALDUD
    DECLARE Con_SegL	INT(2);	-- 12 _ PAGARE PAGO UNICO
    DECLARE Con_SegM	INT(2);	-- 13 _ PAGOS ADELANTADOS OK

-- DECLARACION DE VARIABLES 
	-- numCon 1    
    DECLARE Var_NombreCom	VARCHAR(100);	-- NombreComercial
    DECLARE Var_ValorCAT	DECIMAL(12,4);	-- ValorCAT
    DECLARE Var_TasaFija	DECIMAL(12,2);	-- TasaFija
    DECLARE Var_TasaMora	DECIMAL(12,4);	-- TasaMora
    DECLARE Var_MontoCred	DECIMAL(12,2);	-- MontoCredito
    DECLARE Var_TotCredito	DECIMAL(25,4);	-- TotalCredito
    DECLARE Var_FechaVencim	DATE;			-- FechaVencimiento
    DECLARE Var_FechaExig	DATE;			-- FechaExigible
    DECLARE Var_RegRECA		VARCHAR(100);	-- RegistroRECA
	-- numCon 2
    DECLARE Var_FechaMinis	DATE;			-- FechaDesembolso
    DECLARE Var_CreditoID	INT(11);		-- CreditoID
    DECLARE Var_NumAmor		INT(5);			-- NumAmortizacion
    DECLARE Var_FrecCap		CHAR(1);		-- FrecCapital
    DECLARE Var_CalIntDes	VARCHAR(100);	-- CalIntereses
    DECLARE Var_PorcAhoVol	DECIMAL(12,2);	-- AhorroVol
    DECLARE Var_MonComApert	DECIMAL(12,2);	-- MontoApert
    DECLARE	Var_IVAInteres	DECIMAL(12,2);	-- IVA 
    
    -- INICIO DE SECCION DEL CONTRATO 2
    DECLARE	Var_FechaPago   DATE;           -- Fecha de corte           NUEVO
    DECLARE Var_SaldoIns    DECIMAL(12,2);  -- Saldo insoluto           NUEVO
    DECLARE Var_AbonoCap    DECIMAL(12,2);  -- Abono capital            NUEVO
    DECLARE Var_NuevoSal    DECIMAL(12,2);  -- Nuevo saldo              NUEVO
    DECLARE Var_Seguro      DECIMAL(12,2);  -- Seguro                   NUEVO
    DECLARE Var_MonIntOr    DECIMAL(12,2);  -- Monto interes            NUEVO
    DECLARE Var_IvaIntOr    DECIMAL(12,2);  -- IVA interes              NUEVO
	DECLARE Var_MonOtrCom   DECIMAL(12,2);  -- Monto otras comisiones   NUEVO
    DECLARE Var_TotPago     DECIMAL(12,2);  -- Total a pagar            NUEVO

    DECLARE Var_TotAbono    DECIMAL(12,2);  -- Total de abono capital   NUEVO
    DECLARE Var_TotSeguro   DECIMAL(12,2);  -- Total de seguro          NUEVO
    DECLARE Var_TotMonInOr  DECIMAL(12,2);  -- Total de monto interes   NUEVO
    DECLARE Var_TotIvaInOr  DECIMAL(12,2);  -- Total de iva interes     NUEVO
    DECLARE Var_TotMonOtCo  DECIMAL(12,2);  -- Total de monto otras com NUEVO
    DECLARE Var_TotPagos    DECIMAL(12,2);  -- Suma total de total pago NUEVO
    -- FIN DE SECCION DEL CONTRATO 2

    -- numCon 3
    DECLARE Var_TipoCred 	CHAR(1);		-- Tipo Credito
	-- numCon 6
    DECLARE Var_Cuantas		INT(11);		-- Cuantos Credito
    DECLARE Var_MaxCredito	DECIMAL(12,2);	-- Maximo Credito
	-- numCon 8
    DECLARE Var_CuentaID	INT(11);		-- Cuenta ID
	-- numCon 11
    DECLARE Var_PlazoID		INT(11);		-- Plazo
    DECLARE Var_FechaInic	DATE;			-- Fecha Inicio
    DECLARE Var_MonCreL	    VARCHAR(250);	-- MontoCredito en Letra
    DECLARE Var_MontoDesemb	DECIMAL(14,2);	-- Monto Desembolso
    DECLARE Var_MonDesL     VARCHAR(250);   -- Monto Desembolsado en Letra
    
    
-- Variables De Flujo Interno 
	DECLARE Var_Inicial		    INT(11);	-- Ciclo Inicial
    DECLARE Var_TipoCredito     CHAR(1);
    DECLARE Var_SolicitudID     INT(11);
    DECLARE Var_EstatusSoli     CHAR(1);
    DECLARE EsReest             CHAR(1); 
    DECLARE EsDesemb            CHAR(1);
    DECLARE Var_CountAmort	INT(11);	
	-- FRECUENCIA CAPITAL 
	DECLARE Var_FrecCapDes	VARCHAR(100);	-- Descripcion FrecCapital
    DECLARE FrecCapS	CHAR(1);	-- Capital S
    DECLARE FrecCapC	CHAR(1);	-- Capital C
    DECLARE FrecCapQ	CHAR(1);	-- Capital Q
    DECLARE FrecCapM	CHAR(1);	-- Capital M
    DECLARE FrecCapP	CHAR(1);	-- Capital P
    DECLARE FrecCapB	CHAR(1);	-- Capital B
    DECLARE FrecCapT	CHAR(1);	-- Capital T
    DECLARE FrecCapR	CHAR(1);	-- Capital R
    DECLARE FrecCapE	CHAR(1);	-- Capital E
    DECLARE FrecCapA	CHAR(1);	-- Capital A
    DECLARE FrecCapL	CHAR(1);	-- Capital L
    DECLARE FrecCapU	CHAR(1);	-- Capital U
    DECLARE FrecCapD	CHAR(1);	-- Capital D
    -- DESCRIPCION FRECUENCIA
    DECLARE FrecCapSDes	    VARCHAR(100);	-- Capital S
    DECLARE FrecCapCDes	    VARCHAR(100);	-- Capital C
    DECLARE FrecCapQDes	    VARCHAR(100);	-- Capital Q
    DECLARE FrecCapMDes	    VARCHAR(100);	-- Capital M
    DECLARE FrecCapPDes	    VARCHAR(100);	-- Capital P
    DECLARE FrecCapBDes	    VARCHAR(100);	-- Capital B
    DECLARE FrecCapTDes	    VARCHAR(100);	-- Capital T
    DECLARE FrecCapRDes	    VARCHAR(100);	-- Capital R
    DECLARE FrecCapEDes	    VARCHAR(100);	-- Capital E
    DECLARE FrecCapADes		VARCHAR(100);	-- Capital A
    DECLARE FrecCapLDes		VARCHAR(100);	-- Capital L
    DECLARE FrecCapUDes		VARCHAR(100);	-- Capital U
    DECLARE FrecCapDDes		VARCHAR(100);	-- Capital D
    
    DECLARE Var_TipoCalInt	INT(11);		-- Tipo CalIntereses
    
    DECLARE Var_TipoCredDes	VARCHAR(100);	-- Descripcion Tipo Credito
    -- TIPOS DE CREDITO
	DECLARE TipoCredC		CHAR(1);		-- Tipo Credito C
    DECLARE TipoCredO		CHAR(1);		-- Tipo Credito O
    DECLARE TipoCredH		CHAR(1);		-- Tipo Credito H
    DECLARE TipoCredCDes	VARCHAR(100);	-- Tipo Credito Comercial
    DECLARE TipoCredODes	VARCHAR(100);	-- Tipo Credito Consumo
    DECLARE TipoCredHDes	VARCHAR(100);	-- Tipo Credito Hipotecario
-- Variables Sin Uso Aparente
    DECLARE Var_ProdCredID	INT(11);		-- Producto CreditoID
    DECLARE Var_TipCobCM	CHAR(1);		-- Tipo Cobro
    DECLARE TipCobComMoraT	CHAR(1);		-- Tipo Cobro Moratorio
    DECLARE Var_FactorMora	DECIMAL(5,3);	-- Factor Mora
    DECLARE	SaldosIns		VARCHAR(100);	-- Saldo Insoluto
    DECLARE	SaldosGlo		VARCHAR(100);	-- Saldo Globales
    DECLARE Var_ClienteID	INT(11);		-- Cliente ID
    DECLARE Var_EsPrin		CHAR(1);		-- Es Principal
    DECLARE EsPrinS			CHAR(1);		-- Es Principal S
    DECLARE Var_FechaVenci	DATE;			-- Fecha Vencimiento
    DECLARE Var_PlazoDes	VARCHAR(200);	-- Descripcion Plazo
    
-- LLAVES PARAMETRO
    DECLARE NomComer	VARCHAR(20);	-- Llave Parametro Nombre Comercial
    DECLARE ValCAT		VARCHAR(20);	-- Llave Parametro ValorCAT
    DECLARE TasaFij		VARCHAR(20);	-- Llave Parametro Tasa Fija
    DECLARE TasaMor		VARCHAR(20);	-- Llave Parametro Tasa Moral
    DECLARE MonCred		VARCHAR(20);	-- Llave Parametro Monto Credito

    DECLARE TotCred		VARCHAR(20);	-- Llave Parametro Total Credito
    DECLARE FechaVen	VARCHAR(20);	-- Llave Parametro Fecha Vencimiento
    DECLARE FechaEx		VARCHAR(20);	-- Llave Parametro Fecha Exigible
    DECLARE RegREC		VARCHAR(20);	-- Llave Parametro RECA
    DECLARE FechaMin	VARCHAR(20);	-- Llave Parametro Fecha Desembolso

    DECLARE CreditID	VARCHAR(20);	-- Llave Parametro Credito ID
    DECLARE NumAmor		VARCHAR(20);	-- Llave Parametro Numero Amortizacion
    DECLARE FrecCapDes	VARCHAR(20);	-- Llave Parametro Frecuencia Capital
    DECLARE CalIntDes	VARCHAR(20);	-- Llave Parametro Calculo Interes
    DECLARE PorcAho		VARCHAR(20);	-- Llave Parametro Porcentaje Ahorro

    DECLARE MonComApert	VARCHAR(20);	-- Llave Parametro Monto Comision Apertura
    DECLARE IVAInter	VARCHAR(20);	-- Llave Parametro IVA
    
    -- INICIO DE SECCION DEL CONTRATO 2
    DECLARE NumPago     VARCHAR(20);  -- Numero de pago           NUEVO 
    DECLARE	FechaPago   VARCHAR(20);  -- Fecha de corte           NUEVO
    DECLARE DiasTrans   VARCHAR(20);  -- Dias transcurridos       NUEVO 
    DECLARE SaldoIns    VARCHAR(20);  -- Saldo insoluto           NUEVO
    DECLARE AbonoCap    VARCHAR(20);  -- Abono capital            NUEVO
    DECLARE NuevoSal    VARCHAR(20);  -- Nuevo saldo              NUEVO
    DECLARE Seguro      VARCHAR(20);  -- Seguro                   NUEVO
    DECLARE MonIntOr    VARCHAR(20);  -- Monto interes            NUEVO
    DECLARE IvaIntOr    VARCHAR(20);  -- IVA interes              NUEVO
	DECLARE MonOtrCom   VARCHAR(20);  -- Monto otras comisiones   NUEVO
    DECLARE TotPago     VARCHAR(20);  -- Total a pagar            NUEVO

    DECLARE TotAbono    VARCHAR(20);  -- Total de abono capital   NUEVO
    DECLARE TotSeguro   VARCHAR(20);  -- Total de seguro          NUEVO
    DECLARE TotMonInOr  VARCHAR(20);  -- Total de monto interes   NUEVO
    DECLARE TotIvaInOr  VARCHAR(20);  -- Total de iva interes     NUEVO
    DECLARE TotMonOtCo  VARCHAR(20);  -- Total de monto otras com NUEVO
    DECLARE TotPagos    VARCHAR(20);  -- Suma total de total pago NUEVO
    -- FIN DE SECCION DEL CONTRATO 2

    DECLARE TipoCredDes	VARCHAR(20);	-- Llave Parametro Tipo Credito
    DECLARE Cuantas		VARCHAR(20);	-- Llave Parametro Cuanto Credito
    DECLARE MaxCredito	VARCHAR(20);	-- Llave Parametro Maximo Credito
	DECLARE CuentID		VARCHAR(20);	-- Llave Parametro Cuenta ID
    DECLARE CuentaAhoMon VARCHAR(20);	-- Llave Parametro Numero de Cuenta
    DECLARE PlazoDes	VARCHAR(20);	-- Llave Parametro Plazo
    DECLARE FechaInic	VARCHAR(20);	-- Llave Parametro Fecha Inicio
    DECLARE MontoDesem	VARCHAR(20);	-- Llave Parametro Monto Desembolso
    DECLARE TotCredL    VARCHAR(30);
    DECLARE MontoDesemL VARCHAR(30);

    DECLARE Transaccion	BIGINT(20);		-- Transaccion

-- ASIGNACION DE CONSTANTES
    SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
    SET Entero_Uno		:= 1;
    SET Entero_Dos		:= 2;
    SET Decimal_Cero	:= 0.00;
    SET NOENCONTRADO	:= 'NO ENCONTRADO';
  -- VALOR DEL REPORTE - CONTRATOS CON RECA
    SET Con_SegA	:= 1;	-- ANEXO A
    SET Con_SegB	:= 2;	-- ANEXO B
    SET Con_SegC	:= 3;	-- ANEXO C
    SET Con_SegD	:= 4;	-- CONTRATO APERTURA DE CREDITO AViO AGROPECUARIO
    SET Con_SegE	:= 5;	-- PRECEPTOS LEGALES
    SET Con_SegF	:= 6;	-- SOLICITUD DE CREDITO DE PERSONA FISICA
    SET Con_SegG	:= 7;	-- SOLICITUD DE CREDITO DE PERSONA MORAL
    -- VALOR DEL REPORTE - CONTRATOS SIN RECA
    SET Con_SegH	:= 8;	  -- AUTORIZACION DE CARGO AUTOMATICO
    SET Con_SegI	:= 9;	  -- CESION DE DERECHOS
    SET Con_SegJ	:= 10;	-- DECLARATORIA DUD
    SET Con_SegK	:= 11;	-- PAGARE PAGO UNICO INTERES MENSUAL DUD
    SET Con_SegL	:= 12;	-- REPORTE PAGARE PAGO UNICO
    SET Con_SegM	:= 13;	-- REPORTE PAGOS ADELANTADOS OK

-- ASIGNACION DE VARIABLES
    -- VARIABLE SIN USO APARENTE
    SET TipCobComMoraT	:= 'T';
    SET SaldosIns	:= 'SALDOS INSOLUTOS';
    SET SaldosGlo	:= 'SALDOS GLOBALES';
    SET EsPrinS		:= 'S';

    SET EsReest     := 'R';
    SET EsDesemb    := 'D';
    -- FRECUENCIA DE CAPITAL
    SET FrecCapS	:= 'S';
    SET FrecCapC	:= 'C';
    SET FrecCapQ	:= 'Q';
    SET FrecCapM	:= 'M';
    SET FrecCapP	:= 'P';
    SET FrecCapB	:= 'B';
    SET FrecCapT	:= 'T';
    SET FrecCapR	:= 'R';
    SET FrecCapE	:= 'E';
    SET FrecCapA	:= 'A';
    SET FrecCapL	:= 'L';
    SET FrecCapU	:= 'U';
    SET FrecCapD	:= 'D';
    -- DESCRIPCION FRECUENCIA DE CAPITAL
    SET FrecCapSDes	:= 'SEMANAL';
    SET FrecCapCDes	:= 'CATORCENAL';
    SET FrecCapQDes	:= 'QUINCENAL';
    SET FrecCapMDes	:= 'MENSUAL';
    SET FrecCapPDes	:= 'PERIODO';
    SET FrecCapBDes	:= 'BIMESTRAL';
    SET FrecCapTDes	:= 'TRIMESTRAL';
    SET FrecCapRDes	:= 'TETRAMESTRAL';
    SET FrecCapEDes	:= 'SEMESTRAL';
    SET FrecCapADes	:= 'ANUAL';
    SET FrecCapLDes	:= 'LIBRES';
    SET FrecCapUDes	:= 'PAGO UNICO';
    SET FrecCapDDes	:= 'DECENAL';

    -- TIPOS DE CREDITO
    SET TipoCredDes	    := 'creditType';
    SET TipoCredC	    := 'C';
    SET TipoCredO		:= 'O';
    SET TipoCredH		:= 'H';
    SET TipoCredCDes	:= 'COMERCIAL';
    SET TipoCredODes	:= 'CONSUMO';
    SET TipoCredHDes	:= 'HIPOTECARIO';

    -- VARIABLES MOSTRADAS EN CONSULTAS DE WS
    SET NomComer	:= 'commercialName';
    SET ValCAT		:= 'catValue';
    SET TasaFij		:= 'fixedRate';
    SET TasaMor		:= 'defaultRate';
    SET MonCred		:= 'creditAmount';
    SET TotCred		:= 'creditTotal';
    SET FechaVen	:= 'dueDate';
    SET FechaEx		:= 'limitDate';
    SET RegREC		:= 'recaRegistration';
    SET FechaMin	:= 'disbursementDate';
    SET CreditID	:= 'creditNumber';
    SET NumAmor		:= 'amortizationNumber';
    SET FrecCapDes	:= 'capitalFrecuency';
    SET CalIntDes	:= 'interestEstimate';
    SET PorcAho		:= 'voluntarySaving';
    SET MonComApert	:= 'openingAmount';
    SET IVAInter	:= 'iva';

     -- INICIO DE SECCION DEL CONTRATO 2
    SET NumPago     :=  'paymentNumber';        -- Numero de pago           NUEVO - LP
    SET	FechaPago   :=  'paymentDate';          -- Fecha de corte           NUEVO
    SET DiasTrans   :=  'daysPassed';           -- Dias transcurridos       NUEVO - LP
    SET SaldoIns    :=  'outstandingBal';       -- Saldo insoluto           NUEVO
    SET AbonoCap    :=  'capitalPayment';       -- Abono capital            NUEVO
    SET NuevoSal    :=  'newCapitalBal';        -- Nuevo saldo              NUEVO
    SET Seguro      :=  'insurance';            -- Seguro                   NUEVO
    SET MonIntOr    :=  'interestAmount';       -- Monto interes            NUEVO
    SET IvaIntOr    :=  'ivaInterestAmount';    -- IVA interes              NUEVO
	SET MonOtrCom   :=  'otherCommissions';     -- Monto otras comisiones   NUEVO
    SET TotPago     :=  'totalToPay';           -- Total a pagar            NUEVO

    SET TotAbono    :=  'sumPayments';          -- Total de abono capital   NUEVO
    SET TotSeguro   :=  'sumInsurances';        -- Total de seguro          NUEVO
    SET TotMonInOr  :=  'sumIntAmo';            -- Total de monto interes   NUEVO
    SET TotIvaInOr  :=  'sumIvaIntAmo';         -- Total de iva interes     NUEVO
    SET TotMonOtCo  :=  'sumOtCom';             -- Total de monto otras com NUEVO
    SET TotPagos    :=  'sumTotalPay';          -- Suma total de total pago NUEVO
    -- FIN DE SECCION DEL CONTRATO 2

    SET TipoCredDes	:= 'creditType';
    SET Cuantas		:= 'manyCredit';
    SET MaxCredito	:= 'maxCredit';
    SET CuentID		:= 'accountNumber';
    SET CuentaAhoMon:= 'accountBalance';
    SET PlazoDes	:= 'term';
    SET FechaInic	:= 'initialDate';
    SET MontoDesem	:= 'disbursementAmount';
    SET TotCredL    := 'creditTotalLetter';
    SET MontoDesemL := 'disbursementAmountLetter';
   
-- CONSULTAS EN WS
    -- numCon 1, 2 - productCreditNumber, commercialName, catValue
    IF (Par_NumCon = Con_SegA	|| Par_NumCon = Con_SegB) THEN
		SET Var_ProdCredID		:= IFNULL((SELECT ProductoCreditoID FROM CREDITOS WHERE CreditoID = Par_CredID), Entero_Cero);
		SET Var_NombreCom		:= IFNULL((SELECT NombreComercial FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProdCredID), Cadena_Vacia);
        SET Var_ValorCAT		:= IFNULL((SELECT ValorCat FROM CREDITOS WHERE CreditoID = Par_CredID), Decimal_Cero);
        SET Var_MonComApert		:= IFNULL((SELECT MontoComApert FROM CREDITOS WHERE CreditoID = Par_CredID), Decimal_Cero);
    END IF;
    
    -- numCon 1, 2, 11 - 12 - fixedRate, defaultRate, creditAmount
    IF (Par_NumCon = Con_SegA   ||  Par_NumCon = Con_SegB   ||  Par_NumCon = Con_SegK   ||  Par_NumCon = Con_SegL) THEN
		SET Var_TasaFija	:= IFNULL((SELECT TasaFija FROM CREDITOS WHERE CreditoID = Par_CredID), Decimal_Cero);
        SET Var_TipCobCM	:= IFNULL((SELECT TipCobComMorato FROM CREDITOS WHERE CreditoID = Par_CredID), Cadena_Vacia);
        
        IF (Var_TipCobCM = TipCobComMoraT) THEN
			SET Var_TasaMora	:= IFNULL((SELECT FactorMora FROM CREDITOS WHERE CreditoID = Par_CredID), Decimal_Cero);
		ELSE
			SET Var_FactorMora	:= IFNULL((SELECT FactorMora FROM CREDITOS WHERE CreditoID = Par_CredID), Decimal_Cero);
			SET Var_TasaMora	:= IFNULL(ROUND((Var_TasaFija * Var_FactorMora), Entero_Dos), Decimal_Cero);
        END IF;

        SET Var_MontoCred	:= IFNULL((SELECT MontoCredito FROM CREDITOS WHERE CreditoID = Par_CredID), Decimal_Cero);
	END IF;

    -- numCon 1 - creditTotal, dueDate, limitDate
    IF (Par_NumCon = Con_SegA) THEN
		SET Var_TotCredito	:= IFNULL((SELECT	SaldoCapVigent + SaldoCapAtrasad + SaldoCapVencido + SaldCapVenNoExi +
										SaldoInterOrdin + SaldoInterAtras + SaldoInterVenc + SaldoInterProvi + SaldoIntNoConta +
										SaldoIVAInteres FROM CREDITOS WHERE CreditoID = Par_CredID), Decimal_Cero);
		SET Var_FechaVencim	:= IFNULL((SELECT FechaVencim FROM AMORTICREDITO WHERE CreditoID = Par_CredID ORDER BY AmortizacionID ASC LIMIT 1), Fecha_Vacia);
        SET Var_FechaExig	:= IFNULL((SELECT FechaExigible FROM AMORTICREDITO WHERE CreditoID = Par_CredID ORDER BY AmortizacionID ASC LIMIT 1), Fecha_Vacia);
    END IF;

    -- numCon 1, 2, 4, 5, 7, 11 - productCreditNumber, recaRegistration
    IF (Par_NumCon = Con_SegA	|| Par_NumCon = Con_SegB	|| Par_NumCon = Con_SegC	||
		Par_NumCon = Con_SegD 	|| Par_NumCon = Con_SegE	|| Par_NumCon = Con_SegF	||
        Par_NumCon = Con_SegG	|| Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
        SET Var_ProdCredID	:= IFNULL((SELECT ProductoCreditoID FROM CREDITOS WHERE CreditoID = Par_CredID), Entero_Cero);
        SET Var_RegRECA		:= IFNULL((SELECT RegistroRECA FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProdCredID), Cadena_Vacia);
    END IF;

    -- numCon 2, 13 - disbursementDate
    IF (Par_NumCon = Con_SegB	|| Par_NumCon = Con_SegM) THEN
		SET Var_FechaMinis	:= IFNULL((SELECT FechaMinistrado FROM CREDITOS WHERE CreditoID = Par_CredID), Fecha_Vacia);
    END IF;

    -- numCon 2, 3, 7, 8, 11, 12, 13 - creditNumber
    IF ( Par_NumCon = Con_SegB	|| Par_NumCon = Con_SegC	|| Par_NumCon = Con_SegD	||
        Par_NumCon = Con_SegG	|| Par_NumCon = Con_SegH	|| Par_NumCon = Con_SegI	||
        Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL	|| Par_NumCon = Con_SegM) THEN
        SET Var_CreditoID	:= IFNULL((SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CredID), Entero_Cero);
    END IF;

    -- numCon 2 - capitalFrecuency, interestEstimate, amortizationNumber, voluntarySaving, openingAmount, iva
    IF (Par_NumCon = Con_SegB) THEN
        SELECT	NumAmortizacion,	FrecuenciaCap,	TipoCalInteres,		IVAInteres
        INTO	Var_NumAmor,		Var_FrecCap,	Var_TipoCalInt,		Var_IVAInteres
		FROM CREDITOS
		WHERE CreditoID = Par_CredID;

		SET Var_FrecCapDes	:= CASE Var_FrecCap
			WHEN FrecCapS THEN FrecCapSDes
            WHEN FrecCapC THEN FrecCapCDes
            WHEN FrecCapQ THEN FrecCapQDes
            WHEN FrecCapM THEN FrecCapMDes
            WHEN FrecCapP THEN FrecCapPDes
            WHEN FrecCapB THEN FrecCapBDes
            WHEN FrecCapT THEN FrecCapTDes
            WHEN FrecCapR THEN FrecCapRDes
            WHEN FrecCapE THEN FrecCapEDes
            WHEN FrecCapA THEN FrecCapADes
            WHEN FrecCapL THEN FrecCapLDes
            WHEN FrecCapU THEN FrecCapUDes
            WHEN FrecCapD THEN FrecCapDDes
            
            ELSE NOENCONTRADO
		END;


		SET Var_CalIntDes	:=	CASE Var_TipoCalInt
			WHEN Entero_Uno THEN SaldosIns
            WHEN Entero_Dos THEN SaldosGlo
                                    
            ELSE NOENCONTRADO
	    END;

		SET Var_ProdCredID	:= IFNULL((SELECT ProductoCreditoID FROM CREDITOS WHERE CreditoID = Par_CredID), Entero_Cero);
        SET Var_PorcAhoVol 	:= IFNULL((SELECT PorcAhoVol FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProdCredID), Decimal_Cero);
		SET Var_NumAmor		:= IFNULL(Var_NumAmor, Entero_Cero);
		SET Var_IVAInteres	:= IFNULL(Var_IVAInteres, Decimal_Cero);
    END IF;
        

    -- numCon 3 - productCreditID, creditType, creditTypeDescription, accountNumber
    IF (Par_NumCon = Con_SegC) THEN
		SET Var_ProdCredID	:= IFNULL((SELECT ProductoCreditoID FROM CREDITOS WHERE CreditoID = Par_CredID), Entero_Cero);
        SET Var_TipoCred 	:= IFNULL((SELECT Tipo FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProdCredID), Cadena_Vacia);
        SET Var_TipoCredDes	:=	CASE Var_TipoCred
			WHEN TipoCredC THEN TipoCredCDes
            WHEN TipoCredO THEN TipoCredODes
            WHEN TipoCredH THEN TipoCredHDes
            
            ELSE NOENCONTRADO
		END;
        SET Var_CuentaID	:= IFNULL((SELECT CuentaID FROM CREDITOS WHERE CreditoID = Par_CredID), Entero_Cero);
    END IF;

    -- numCon 6, 7 - clientNumber, manyCredit, maxCredit
    IF (Par_NumCon = Con_SegF	|| Par_NumCon = Con_SegG) THEN
		SET Var_ClienteID	:= IFNULL((SELECT ClienteID FROM CREDITOS WHERE CreditoID = Par_CredID), Entero_Cero);
        SET Var_Cuantas		:= IFNULL((SELECT COUNT(ClienteID) FROM CREDITOS WHERE ClienteID = Var_ClienteID), Entero_Cero);
        SET Var_MaxCredito	:= IFNULL((SELECT MAX(MontoCredito) FROM CREDITOS WHERE ClienteID = Var_ClienteID), Decimal_Cero);
    END IF;

    -- numCon 8 - accountNumber, idPrin
    IF (Par_NumCon = Con_SegH) THEN
		SET Var_CuentaID	:= IFNULL((SELECT CuentaID FROM CREDITOS WHERE CreditoID = Par_CredID), Entero_Cero);
        SET Var_EsPrin		:= IFNULL((SELECT EsPrincipal FROM CUENTASAHO WHERE CuentaAhoID = Var_CuentaID), Cadena_Vacia);
        IF (Var_EsPrin != EsPrinS) THEN
			SET Var_CuentaID	:= Entero_Cero;
        END IF;
    END IF;

    -- numCon 11, 12 - dueDate
    IF (Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
		SET	Var_FechaVenci	:= IFNULL((SELECT FechaVencimien FROM CREDITOS WHERE CreditoID = Par_CredID), Fecha_Vacia);
    END IF;

    -- numCon 11 - term, termDescription, initialDate
    IF (Par_NumCon = Con_SegK || Par_NumCon = Con_SegL) THEN
		SET Var_PlazoID		:= IFNULL((SELECT PlazoID FROM CREDITOS WHERE CreditoID =  Par_CredID), Entero_Cero);
        SET Var_PlazoDes	:= IFNULL((SELECT Descripcion from CREDITOSPLAZOS where PlazoID =Var_PlazoID), Cadena_Vacia);
        SET Var_FechaInic	:= IFNULL((SELECT FechaInicio FROM AMORTICREDITO WHERE CreditoID = Par_CredID ORDER BY AmortizacionID ASC LIMIT 1), Fecha_Vacia);

        SET Var_TotCredito	:= IFNULL((SELECT	SaldoCapVigent + SaldoCapAtrasad + SaldoCapVencido + SaldCapVenNoExi +
										SaldoInterOrdin + SaldoInterAtras + SaldoInterVenc + SaldoInterProvi + SaldoIntNoConta +
										SaldoIVAInteres FROM CREDITOS WHERE CreditoID = Par_CredID), Decimal_Cero);
        SET Var_MonCreL	:= FUNCIONNUMLETRAS(Var_TotCredito);
        SET Var_MontoDesemb := IFNULL((SELECT MontoDesemb FROM CREDITOS WHERE CreditoID =  Par_CredID), Decimal_Cero);
        SET Var_MonDesL   := FUNCIONNUMLETRAS(Var_MontoDesemb);
    END IF;

	IF (Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL	|| Par_NumCon = Con_SegM) THEN
		SET Var_MontoDesemb := IFNULL((SELECT MontoDesemb FROM CREDITOS WHERE CreditoID =  Par_CredID), Decimal_Cero);
    END IF;

    -- CREACION
    DROP TEMPORARY TABLE IF EXISTS `TMPCONTRATOSCREDITO`;

	CREATE TEMPORARY TABLE `TMPCONTRATOSCREDITO` (
		NumTransaccion	BIGINT(20),		-- NumTransaccion para identificar n procesos a la vez
        LlaveParametro	VARCHAR(100),	-- Nombre de la columna
        ValorParametro	VARCHAR(500)	-- Valor de la columna
	);

	CALL TRANSACCIONESPRO(Transaccion);

	-- INSERCIONES
    IF (Par_NumCon = Con_SegA) THEN
		INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, NomComer,	        Var_NombreCom),
				(Transaccion, ValCAT,	        Var_ValorCAT),
                (Transaccion, TasaFij,	        Var_TasaFija),
                (Transaccion, TasaMor,	        Var_TasaMora),
                (Transaccion, MonCred,	        Var_MontoCred),
                (Transaccion, TotCred,	        Var_TotCredito),
                (Transaccion, FechaVen,	        Var_FechaVencim),
                (Transaccion, FechaEx,	        Var_FechaExig),
				(Transaccion, MonComApert,	    Var_MonComApert),
				(Transaccion, RegREC,	        Var_RegRECA);
    END IF;

    IF (Par_NumCon = Con_SegB) THEN
    INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, FechaMin,		    Var_FechaMinis),
				(Transaccion, CreditID,		    Var_CreditoID),
                (Transaccion, NomComer,		    Var_NombreCom),
                (Transaccion, MonCred,		    Var_MontoCred),
                (Transaccion, NumAmor,		    Var_NumAmor),
                (Transaccion, FrecCapDes,	    Var_FrecCapDes),
                (Transaccion, CalIntDes,	    Var_CalIntDes),
                (Transaccion, TasaFij,		    Var_TasaFija),
                (Transaccion, PorcAho,		    Var_PorcAhoVol),
                (Transaccion, TasaMor,		    Var_TasaMora),
                (Transaccion, MonComApert,	    Var_MonComApert),
                (Transaccion, ValCAT,		    Var_ValorCAT),
                (Transaccion, IVAInter,		    Var_IVAInteres),
                (Transaccion, RegREC,		    Var_RegRECA);
        SET Var_TipoCredito := IFNULL((SELECT TipoCredito FROM CREDITOS WHERE CreditoID = Par_CredID), Cadena_Vacia);
        SET Var_SolicitudID := IFNULL((SELECT SolicitudCreditoID FROM CREDITOS WHERE CreditoID = Par_CredID), Entero_Cero);
        SET Var_EstatusSoli := IFNULL((SELECT Estatus FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Var_SolicitudID), Cadena_Vacia);

        IF (Var_TipoCredito = EsReest AND Var_EstatusSoli = EsDesemb) THEN
            SET Var_CountAmort	:= IFNULL((
                SELECT COUNT(AmortizacionID) 
                FROM SOLICITUDCREDITO Sol 
                INNER JOIN CREDITOS Cre 
                    ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
                    AND Sol.Estatus= EstDesembolsada
                    AND Sol.TipoCredito= CredReestructura
                INNER JOIN REESTRUCCREDITO Res
                    ON Res.CreditoOrigenID = Cre.CreditoID
                    AND Res.CreditoDestinoID = Cre.CreditoID
                    AND Cre.TipoCredito = CredReestructura
                INNER JOIN AMORTICREDITO Amo
                    ON Amo.CreditoID = Cre.CreditoID
                WHERE Amo.CreditoID = Par_CredID
                AND (Amo.FechaLiquida > Res.FechaRegistro
                    OR Amo.FechaLiquida = Fecha_Vacia)
            ), Entero_Cero);

            IF (Var_CountAmort > 0) THEN
                SET Var_Inicial		:= 0;

                -- INICIO DE SECCION DEL CONTRATO 2
                SET Var_TotAbono    := 0; -- Total de abono capital   NUEVO
                SET Var_TotSeguro   := 0; -- Total de seguro          NUEVO
                SET Var_TotMonInOr  := 0; -- Total de monto interes   NUEVO
                SET Var_TotIvaInOr  := 0; -- Total de iva interes     NUEVO
                SET Var_TotMonOtCo  := 0; -- Total de monto otras com NUEVO
                SET Var_TotPagos    := 0; -- Suma total de total pago NUEVO
                -- FIN DE SECCION DEL CONTRATO 2

                loop_amort : LOOP
                    IF (Var_Inicial >= Var_CountAmort) THEN
                        LEAVE loop_amort;
                    END  IF;

                    SELECT 
			            Amo.FechaExigible, Amo.Interes, Amo.IVAInteres, Amo.Capital, 
                        Amo.SaldoCapital, Amo.MontoOtrasComisiones, Amo.MontoIVAOtrasComisiones 
                    INTO 
                        Var_FechaPago, Var_MonIntOr, Var_IvaIntOr, Var_SaldoIns,
                        Var_NuevoSal, Var_Seguro, Var_MonOtrCom
                        FROM SOLICITUDCREDITO Sol
                        INNER JOIN CREDITOS Cre
                            ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
                            AND Sol.Estatus = EsDesemb
                            AND Sol.TipoCredito= EsReest
                        INNER JOIN REESTRUCCREDITO Res
                            ON Res.CreditoOrigenID = Cre.CreditoID
                            AND Res.CreditoDestinoID = Cre.CreditoID
                            AND Cre.TipoCredito = EsReest
                        INNER JOIN AMORTICREDITO Amo
                            ON Amo.CreditoID = Cre.CreditoID
                        WHERE Amo.CreditoID = Par_CredID
                        AND (Amo.FechaLiquida > Var_FechaRegistro
                            OR Amo.FechaLiquida = Fecha_Vacia);

                    SET Var_Inicial		:= Var_Inicial + 1;
                    -- INICIO DE SECCION DEL CONTRATO 2
                    SET	Var_FechaPago   := IFNULL(Var_FechaPago, Fecha_Vacia);      -- Fecha de corte           NUEVO
                    SET Var_SaldoIns    := IFNULL(Var_SaldoIns,  Decimal_Cero);     -- Saldo insoluto           NUEVO
                    SET Var_AbonoCap    := IFNULL(Var_SaldoIns,  Decimal_Cero);     -- Abono capital            NUEVO
                    SET Var_NuevoSal    := IFNULL(Var_NuevoSal,  Decimal_Cero);     -- Nuevo saldo              NUEVO
                    SET Var_Seguro      := IFNULL(Var_Seguro,    Decimal_Cero);     -- Seguro                   NUEVO
                    SET Var_MonIntOr    := IFNULL(Var_MonIntOr,  Decimal_Cero);     -- Monto interes            NUEVO
                    SET Var_IvaIntOr    := IFNULL(Var_IvaIntOr,  Decimal_Cero);     -- IVA interes              NUEVO
                    SET Var_MonOtrCom   := IFNULL(Var_MonOtrCom, Decimal_Cero);     -- Monto otras comisiones   NUEVO
                    SET Var_TotPago     := IFNULL((Var_AbonoCap + Var_Seguro + Var_MonIntOr + Var_IvaIntOr), Decimal_Cero);  -- Total a pagar            NUEVO

                    SET Var_TotAbono    := Var_TotAbono + Var_AbonoCap;     -- Total de abono capital   NUEVO
                    SET Var_TotSeguro   := Var_TotSeguro + Var_Seguro;      -- Total de seguro          NUEVO
                    SET Var_TotMonInOr  := Var_TotMonInOr + Var_MonIntOr;   -- Total de monto interes   NUEVO
                    SET Var_TotIvaInOr  := Var_TotIvaInOr + Var_IvaIntOr;   -- Total de iva interes     NUEVO
                    SET Var_TotMonOtCo  := Var_TotMonOtCo + Var_MonOtrCom;  -- Total de monto otras com NUEVO
                    SET Var_TotPagos    := Var_TotPagos + Var_TotPago;      -- Suma total de total pago NUEVO

                    INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
                    VALUES	(Transaccion, NumPago,	  Var_Inicial),
                            (Transaccion, FechaPago,  Var_FechaPago),
                            (Transaccion, DiasTrans,  Entero_Cero),
                            (Transaccion, SaldoIns,   Var_SaldoIns),
                            (Transaccion, AbonoCap,   Var_AbonoCap),
                            (Transaccion, NuevoSal,   Var_NuevoSal),
                            (Transaccion, Seguro,     Var_Seguro),
                            (Transaccion, MonIntOr,   Var_MonIntOr),
                            (Transaccion, IvaIntOr,   Var_IvaIntOr),
                            (Transaccion, MonOtrCom,  Var_MonOtrCom),
                            (Transaccion, TotPago,    Var_TotPago);
                END LOOP;

                INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
                VALUES	(Transaccion, TotAbono,   Var_TotAbono),
                        (Transaccion, TotSeguro,  Var_TotSeguro),
                        (Transaccion, TotMonInOr, Var_TotMonInOr),
                        (Transaccion, TotIvaInOr, Var_TotIvaInOr),
                        (Transaccion, TotMonOtCo, Var_TotMonOtCo),
                        (Transaccion, TotPagos,   Var_TotPagos);
            END IF;
        END IF;

        INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
        VALUES	(Transaccion, NumPago,	  Entero_Cero),
                (Transaccion, FechaPago,  Fecha_Vacia),
                (Transaccion, DiasTrans,  Entero_Cero),
                (Transaccion, SaldoIns,   Decimal_Cero),
                (Transaccion, AbonoCap,   Decimal_Cero),
                (Transaccion, NuevoSal,   Decimal_Cero),
                (Transaccion, Seguro,     Decimal_Cero),
                (Transaccion, MonIntOr,   Decimal_Cero),
                (Transaccion, IvaIntOr,   Decimal_Cero),
                (Transaccion, MonOtrCom,  Decimal_Cero),
                (Transaccion, TotPago,    Decimal_Cero),
                (Transaccion, TotAbono,   Decimal_Cero),
                (Transaccion, TotSeguro,  Decimal_Cero),
                (Transaccion, TotMonInOr, Decimal_Cero),
                (Transaccion, TotIvaInOr, Decimal_Cero),
                (Transaccion, TotMonOtCo, Decimal_Cero),
                (Transaccion, TotPagos,   Decimal_Cero);
    END IF;

    IF (Par_NumCon = Con_SegC) THEN
    INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, CreditID,		Var_CreditoID),
				(Transaccion, CuentID,		Var_CuentaID),
				(Transaccion, TipoCredDes,	Var_TipoCredDes),
				(Transaccion, RegREC,		Var_RegRECA);
                
    END IF;

    IF (Par_NumCon = Con_SegD) THEN
    INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, CreditID,		Var_CreditoID),
				(Transaccion, RegREC,		Var_RegRECA);
    END IF;

	IF (Par_NumCon = Con_SegE) THEN
		INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, RegREC,		Var_RegRECA);
    END IF;

	IF (Par_NumCon = Con_SegF	|| Par_NumCon = Con_SegG) THEN
		INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, Cuantas,		Var_Cuantas),
				(Transaccion, MaxCredito,	Var_MaxCredito),
				(Transaccion, RegREC,		Var_RegRECA);
    END IF;

	IF (Par_NumCon = Con_SegH) THEN
		INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, CreditID,		Var_CreditoID),
				(Transaccion, CuentID,		Var_CuentaID);
	END IF;

	IF (Par_NumCon = Con_SegI) THEN
		INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, CreditID,		Var_CreditoID);
	END IF;

	IF (Par_NumCon = Con_SegK) THEN
		INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, TotCred,		Var_TotCredito),
                (Transaccion, TotCredL,     Var_MonCreL),
                (Transaccion, MontoDesem,   Var_MontoDesemb),
                (Transaccion,  MontoDesemL,  Var_MonDesL),
				(Transaccion, FechaVen,		Var_FechaVenci),
				(Transaccion, CreditID,		Var_CreditoID),
                (Transaccion, PlazoDes,		Var_PlazoDes),
                (Transaccion, TasaFij,		Var_TasaFija),
                (Transaccion, FechaInic,	Var_FechaInic),
                (Transaccion, TasaMor,		Var_TasaMora),
                (Transaccion, RegREC,		Var_RegRECA);
	END IF;

	IF (Par_NumCon = Con_SegL) THEN
		INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, MonCred,		Var_MontoCred),
                (Transaccion, TotCred,		Var_TotCredito),
                (Transaccion, TotCredL,     Var_MonCreL),
                (Transaccion, MontoDesem,   Var_MontoDesemb),
                (Transaccion,  MontoDesemL,  Var_MonDesL),
				(Transaccion, FechaVen,		Var_FechaVenci),
				(Transaccion, CreditID,		Var_CreditoID),
                (Transaccion, TasaFij,		Var_TasaFija),
                (Transaccion, TasaMor,		Var_TasaMora),
                (Transaccion, RegREC,		Var_RegRECA);
	END IF;

	IF (Par_NumCon = Con_SegM) THEN
		INSERT INTO TMPCONTRATOSCREDITO(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, CreditID,		Var_CreditoID), 	
				(Transaccion, FechaMin,		Var_FechaMinis),
				(Transaccion, MontoDesem,	Var_MontoDesemb);
	END IF;

    SELECT NumTransaccion, LlaveParametro, ValorParametro FROM TMPCONTRATOSCREDITO;

    DROP TEMPORARY TABLE IF EXISTS `TMPCONTRATOSCREDITO`;
END TerminaStore$$
