DELIMITER ;
DROP procedure IF EXISTS `FONDEOMOVIMIWSLIS`;

DELIMITER $$

CREATE PROCEDURE `FONDEOMOVIMIWSLIS`(
# ================================================================
# ------ STORE para extraer información de los movimientos de los créditos con base en un fondeador-------
# ================================================================
    -- VALORES MOVIMIENTOS
    Par_TipoMovimiento		CHAR(1),			-- Etiqueta del credito P: Pago de crédito (incluye prepago) C: Condonación R: Reversas de pagos de crédito (Se deberán enviar datos de las reversas de pagos de crédito realizadas). N: Notas de cargo realizadas.
    Par_CreditoID			TEXT,				-- Numero de Creditos
    Par_AmortizacionID		CHAR(2),				-- Numero de Amortizacion
    Par_FechaPago			VARCHAR(10),		-- Fecha en que se realizó el movimiento (pago, condonación o reversa)
    Par_Transaccion			VARCHAR(20),				-- Número de transacción o referencia

    -- VALORES CONSULTA GLOBAL
	Par_InstitutFondeoID	INT(11),			-- Numero de la institucion de fondeo 0 en caso de recursos propios, -1 en caso de toda la cartera sin importar el fondeador.
    Par_FechaCorte			VARCHAR(10),				-- Fecha de Fin
    Par_CreditoLis			TEXT,				-- Numero de Creditos, separados por coma

	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion

	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Sentencia 		TEXT;		-- Almacena la Sentencia de la Consulta
DECLARE	Var_FechaCorte		DATE;		-- Fecha corte
DECLARE Tip_Pago	   		CHAR(1);	-- pago de credito
DECLARE Tip_Reversa   		CHAR(1);	-- Reversa
DECLARE Tip_Condona   		CHAR(1);	-- Condonacion
DECLARE Tip_Global   		CHAR(1);	-- Indica que se realiza la consulta global
DECLARE Tip_NotCargo   		CHAR(1);	-- Nota Cargo


-- Declaracion de Constantes
DECLARE Entero_Cero    		INT(11);		-- Entero Cero
DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal Cero
DECLARE Cadena_Vacia   		CHAR(1);		-- Cadena Vacia
DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia

DECLARE Lis_Creditos		INT(11);		-- Lista de Creditos
DECLARE Lis_Accesorios		INT(11);		-- Lista de Pagos
DECLARE Lis_Condonaciones	INT(11);		-- Lista de Condonaciones
DECLARE Lis_Reversas		INT(11);		-- Lista de Reversas

DECLARE	Par_NumErr 			INT(11);
DECLARE	Par_ErrMen 			VARCHAR(400);
DECLARE Var_FechaSistema	DATE;			-- Almacena la Fecha del Sistema
DECLARE Var_FechaFiltro		DATE;
DECLARE Var_FechaPago		DATE;

-- Asignacion de Constantes
SET Entero_Cero				:= 0; 				-- Entero Cero
SET Decimal_Cero        	:= 0.00;			-- Decimal Cero
SET Cadena_Vacia			:= '';    			-- Cadena Vacia
SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
SET Lis_Creditos			:= 1; 				-- Lista de clientes
SET Lis_Accesorios			:= 2; 				-- Lista de Pagos
SET Lis_Condonaciones		:= 3; 				-- Lista de Condonaciones
SET Lis_Reversas			:= 4; 				-- Lista de Reversas
SET Tip_Pago				:= 'P';    			-- Pago
SET Tip_Reversa				:= 'R';    			-- Reversa
SET Tip_Condona				:= 'C';    			-- Condonacion
SET Tip_Global				:= 'G';    			-- GLOBAL
SET Tip_NotCargo			:= 'N';    			-- nota cargo


SET Par_NumErr				:= 000000;
SET Par_ErrMen				:= 'Datos Consultados Exitosamente';
SET Var_Sentencia			:= '';

SET Var_FechaSistema		:= (SELECT FechaSistema  FROM PARAMETROSSIS WHERE EmpresaID=1);

IF(IFNULL(Par_FechaCorte, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_FechaCorte 		:= Fecha_Vacia;
END IF;

SET Par_TipoMovimiento 		:= IFNULL(Par_TipoMovimiento, Cadena_Vacia);
SET Par_CreditoID 			:= IFNULL(Par_CreditoID, Cadena_Vacia);
SET Par_AmortizacionID 		:= IFNULL(Par_AmortizacionID, Cadena_Vacia);
SET Par_FechaPago 			:= IFNULL(Par_FechaPago, Cadena_Vacia);
SET Par_Transaccion 		:= IFNULL(Par_Transaccion, Cadena_Vacia);
SET Par_InstitutFondeoID 	:= IFNULL(Par_InstitutFondeoID, Entero_Cero);
SET Var_FechaCorte			:= STR_TO_DATE(Par_FechaCorte,'%Y-%m-%d');
SET Par_CreditoLis 			:= IFNULL(Par_CreditoLis, Cadena_Vacia);

-- SI SE RECIBE VALOR EN CONSULTA GLOBLA SE INGORAN LOS DEMAS FILTROS
IF(Par_InstitutFondeoID = -1 AND  Var_FechaCorte =Fecha_Vacia) THEN
	SET Par_TipoMovimiento 	:= Cadena_Vacia;
	SET Par_CreditoID 		:= Cadena_Vacia;
	SET Par_AmortizacionID 	:= Cadena_Vacia;
	SET Par_Transaccion 	:= Cadena_Vacia;
	SET Par_FechaPago		:= Cadena_Vacia;
	SET Var_FechaFiltro		:= Var_FechaCorte;
	SET Par_TipoMovimiento	:= Tip_Global;
ELSE
	SET Var_FechaPago		:= STR_TO_DATE(Var_FechaPago,'%Y-%m-%d');
	SET Var_FechaFiltro		:= Var_FechaPago;
END IF;


DROP TABLE IF EXISTS TMPFONDEOMOVIMIWSLIS_1;
CREATE TEMPORARY TABLE TMPFONDEOMOVIMIWSLIS_1(
	-- Datos Cliente
	clienteID				int(11), 		-- Id del cliente en Safi	,
	RFC 					char(13),		-- RFC del cliente
	-- datos credito
	creditoID				bigint(12),		-- Número único asignado al crédito por Safi
	productoID				int(11),		-- Identificador (ID) del producto al que pertenece el crédito.
	-- movimientos
	numAmortizacion			int(4),			-- Número de cuota o amortización
	numMovimiento			int(11),		-- Numero consecutivo de movimiento por cuota.
	tipoMovimiento 			char(1),		-- P: Pago de crédito (incluye prepago)  C: Condonación R: Reversas de pagos de crédito
	fechaMovimiento			date,			-- Fecha en que se dio el movimiento (pago o condonación)
	transaccion 			BIGINT(20),		-- Número de transacción o referencia
	totalMovimiento			decimal(14,2), 	-- Monto total del pago o condonado (Capital, Intereses, moratorios, IVAs, Accesorios, Comisiones, Seguros)
	capital					decimal(14,2),	-- Capital pagado o condonado
	totalInteres			decimal(14,2), 	-- Total del interés pagado o condonado
	totalIvaInteres			decimal(14,2),	--	IVA del interés ordinario
	moratorios				decimal(14,2),	--	Total del interés pagado o condonado
	IVAMoratorios			decimal(14,2),	--	IVA del interés moratorio.
	conceptoID				decimal(14,2),	--	ID del concepto del pago. Ver "Concepto" en "Catálogos"
	comisionApertura		decimal(14,2),	--	Comisión por apertura pagada
	IVAComisionApertura		decimal(14,2),	--	IVA de la comisión por apertura pagada
	interesComisionAper		decimal(14,2),	--	Interés pagado de la comisión por apertura
	comisionFaltaPago		decimal(14,2),	--	Monto de comisión por falta de pago que se pagó.
	IVAComisionFaltaPago	decimal(14,2),	--	IVA de la comisión por falta de pago.
	seguroFinanciado		decimal(14,2),	--	Seguro Financiado pagado
	IVASeguro				decimal(14,2),	--	IVA del seguro Financiado pagado
	interesSeguroFin		decimal(14,2),	--	Interés pagado del seguro financiado
	comisionDisposicion		decimal(14,2),	--	Comisión por Disposición pagada
	interesComisionDisp		decimal(14,2),	--	Interés pagado de la comisión por disposición
	comisionManejo			decimal(14,2),	--	Comisión por Manejo pagada
	origenPagoID			VARCHAR(2),		-- Identificador (ID) que indica por cuál medio se hizo el pago. Ver "OrigenPago" en "Catálogos"
	notaCargo				decimal(14,2),
	MontoIVANotasCargo		decimal(14,2)
);	

DROP TABLE IF EXISTS TMPFONDEOMOVIMIWSLIS_2;
CREATE TEMPORARY TABLE TMPFONDEOMOVIMIWSLIS_2(
	-- Datos Cliente
	clienteID				int(11), 		-- Id del cliente en Safi	,
	RFC 					char(13),		-- RFC del cliente
	-- datos credito
	creditoID				bigint(12),		-- Número único asignado al crédito por Safi
	productoID				int(11),		-- Identificador (ID) del producto al que pertenece el crédito.
	-- movimientos
	numAmortizacion			int(4),			-- Número de cuota o amortización
	numMovimiento			int(11),		-- Numero consecutivo de movimiento por cuota.
	tipoMovimiento 			char(1),		-- P: Pago de crédito (incluye prepago)  C: Condonación R: Reversas de pagos de crédito
	fechaMovimiento			date,			-- Fecha en que se dio el movimiento (pago o condonación)
	transaccion 			BIGINT(20),		-- Número de transacción o referencia
	totalMovimiento			decimal(14,2), 	-- Monto total del pago o condonado (Capital, Intereses, moratorios, IVAs, Accesorios, Comisiones, Seguros)
	capital					decimal(14,2),	-- Capital pagado o condonado
	totalInteres			decimal(14,2), 	-- Total del interés pagado o condonado
	totalIvaInteres			decimal(14,2),	--	IVA del interés ordinario
	moratorios				decimal(14,2),	--	Total del interés pagado o condonado
	IVAMoratorios			decimal(14,2),	--	IVA del interés moratorio.
	conceptoID				decimal(14,2),	--	ID del concepto del pago. Ver "Concepto" en "Catálogos"
	comisionApertura		decimal(14,2),	--	Comisión por apertura pagada
	IVAComisionApertura		decimal(14,2),	--	IVA de la comisión por apertura pagada
	interesComisionAper		decimal(14,2),	--	Interés pagado de la comisión por apertura
	comisionFaltaPago		decimal(14,2),	--	Monto de comisión por falta de pago que se pagó.
	IVAComisionFaltaPago	decimal(14,2),	--	IVA de la comisión por falta de pago.
	seguroFinanciado		decimal(14,2),	--	Seguro Financiado pagado
	IVASeguro				decimal(14,2),	--	IVA del seguro Financiado pagado
	interesSeguroFin		decimal(14,2),	--	Interés pagado del seguro financiado
	comisionDisposicion		decimal(14,2),	--	Comisión por Disposición pagada
	interesComisionDisp		decimal(14,2),	--	Interés pagado de la comisión por disposición
	comisionManejo			decimal(14,2),	--	Comisión por Manejo pagada
	origenPagoID			VARCHAR(2),		-- Identificador (ID) que indica por cuál medio se hizo el pago. Ver "OrigenPago" en "Catálogos"
	notaCargo				decimal(14,2),
	MontoIVANotasCargo		decimal(14,2)
);

DROP TABLE IF EXISTS TMPFONDEOMOVIMIWSLIS_3;
CREATE TEMPORARY TABLE TMPFONDEOMOVIMIWSLIS_3(
	-- datos credito
	creditoID				bigint(12),		-- Número único asignado al crédito por Safi
	numAmortizacion			int(4)			-- Número de cuota o amortización
);


SET Var_Sentencia := CONCAT(Var_Sentencia, ' INSERT INTO TMPFONDEOMOVIMIWSLIS_1');
-- datos cliente
SET Var_Sentencia := CONCAT(Var_Sentencia, '  SELECT 	CLI.ClienteID, CLI.RFCOficial, ');
-- datos credito
SET Var_Sentencia := CONCAT(Var_Sentencia, ' CRE.CreditoID, CRE.ProductoCreditoID, ');
-- datos movimientos
-- numAmortizacion, numMovimiento, tipoMovimiento , fechaMovimiento, transaccion
SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0,	0,	"",	 "1900-01-01",	0, ');
-- totalMovimiento, capital	,	totalInteres, totalIvaInteres, moratorios
SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0,	0,	0,	0,	0, ');
-- IVAMoratorios, conceptoID, comisionApertura, IVAComisionApertura, interesComisionAper
SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0,	0,	CRE.MontoComApert,	CRE.IVAComApertura,	0, ');
-- comisionFaltaPago,IVAComisionFaltaPago,seguroFinanciado,IVASeguro	,	interesSeguroFin
SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0,	0,	MontoSegOriginal,	0,	0, ');
-- comisionDisposicion interesComisionDisp. comisionManejo
SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0,	0,	0, 	 ');
-- ACCESORIOS
-- accesorioID nombreAccesorio montoAccesorio IVAAccesorio origenPagoID
-- SET Var_Sentencia := CONCAT(Var_Sentencia, ' 0, "",	0,	0,	 0');
SET Var_Sentencia := CONCAT(Var_Sentencia, ' "" ,0,0 ');

SET Var_Sentencia := CONCAT(Var_Sentencia, ' FROM 	CREDITOS CRE ' );
SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES	CLI ON CLI.ClienteID  = CRE.ClienteID ' );


-- Numero de la institucion de fondeo 0 en caso de recursos propios, -1 en caso de toda la cartera sin importar el fondeador.
IF ( Par_InstitutFondeoID != -1) THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE  CRE.InstitFondeoID = ', Par_InstitutFondeoID , '  ');
END IF;

IF( IFNULL(Par_CreditoLis, Cadena_Vacia) != Cadena_Vacia) THEN
	IF ( Par_InstitutFondeoID != -1) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND ');
	ELSE 
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE  ');
	END IF;
	SET Par_CreditoLis := concat(REPLACE(Par_CreditoLis,',',"','"));
	SET Var_Sentencia := CONCAT(Var_Sentencia, "  CRE.CreditoID in ('", Par_CreditoLis ,"')  ");
END IF;

IF (IFNULL(Var_FechaFiltro, Fecha_Vacia) = Fecha_Vacia) THEN
	SET Var_FechaFiltro =  Var_FechaSistema  ;
END IF;


-- SET Var_Sentencia := CONCAT(Var_Sentencia,' limit 500 ; ');
SET @Sentencia	= (Var_Sentencia);
PREPARE Ejecuta FROM @Sentencia;
EXECUTE Ejecuta;
DEALLOCATE PREPARE Ejecuta;



IF( Par_TipoMovimiento = Tip_Global)THEN
	-- SE INSERTAN LOS VALORES DEL TIPO DE MOVIMIENTO DE PAGO
	INSERT INTO TMPFONDEOMOVIMIWSLIS_2
		SELECT
			-- CLIENTE
			TMP.clienteID,	RFC,
			-- CREDITOS
			TMP.creditoID,	productoID,
			-- MOVIMIENTOS
			DET.AmortizacionID,		DET.AmortizacionID,			Tip_Pago,			DET.FechaPago,				DET.Transaccion,
			DET.MontoTotPago, 		DET.MontoCapOrd+DET.MontoCapAtr+DET.MontoCapVen,
			DET.MontoIntOrd+DET.MontoIntAtr+DET.MontoIntVen, 	DET.MontoIVA, 			DET.MontoIntMora,
			IVAMoratorios, 			conceptoID, 			comisionApertura,		IVAComisionApertura, 		interesComisionAper,
			comisionFaltaPago, 		IVAComisionFaltaPago, 	seguroFinanciado, 		IVASeguro, 					interesSeguroFin,
			comisionDisposicion,	interesComisionDisp	, 	comisionManejo,
			origenPagoID,			DET.MontoNotasCargo, 		DET.MontoIVANotasCargo	
		FROM TMPFONDEOMOVIMIWSLIS_1 TMP
			INNER JOIN DETALLEPAGCRE DET 		ON DET.CreditoID = TMP.creditoID
			WHERE DET.FechaPago <=  Var_FechaFiltro
		;

	-- SE INSERTAN LOS VALORES DEL TIPO DE CONDONACIONES
	INSERT INTO TMPFONDEOMOVIMIWSLIS_2
		SELECT
			-- CLIENTE
			TMP.clienteID,	RFC,
			-- CREDITOS
			TMP.creditoID,	productoID,
			-- MOVIMIENTOS
			numAmortizacion,	Consecutivo,			Tip_Condona,			CRE.FechaRegistro,		CRE.NumTransaccion,
			MontoComisiones+ MontoMoratorios+ MontoInteres+MontoCapital+MontoComisiones, MontoCapital, 		MontoInteres, 			totalIvaInteres, 		MontoMoratorios,
			IVAMoratorios, 			conceptoID, 			comisionApertura,		IVAComisionApertura, 	interesComisionAper,
			comisionFaltaPago, 		IVAComisionFaltaPago, 	seguroFinanciado, 		IVASeguro, 				interesSeguroFin,
			comisionDisposicion,	interesComisionDisp	, 	comisionManejo,
			origenPagoID,			0,						0
		FROM TMPFONDEOMOVIMIWSLIS_1 TMP
			INNER JOIN CREQUITAS CRE 		ON CRE.CreditoID = TMP.creditoID
		WHERE CRE.FechaRegistro <=  Var_FechaFiltro
		;

	-- SE INSERTAN LOS VALORES DEL TIPO DE REVERSA
	INSERT INTO TMPFONDEOMOVIMIWSLIS_2
		SELECT
			-- CLIENTE
			TMP.clienteID,	RFC,
			-- CREDITOS
			TMP.creditoID,	productoID,
			-- MOVIMIENTOS
			numAmortizacion,		numMovimiento,			Tip_Reversa,			REV.Fecha,				REV.TransaccionID,
			totalMovimiento, 		capital, 				totalInteres, 			totalIvaInteres, 		moratorios,
			IVAMoratorios, 			conceptoID, 			comisionApertura,		IVAComisionApertura, 	interesComisionAper,
			comisionFaltaPago, 		IVAComisionFaltaPago, 	seguroFinanciado, 		IVASeguro, 				interesSeguroFin,
			comisionDisposicion,	interesComisionDisp	, 	comisionManejo,
			origenPagoID,			notaCargo, 				MontoIVANotasCargo
		FROM TMPFONDEOMOVIMIWSLIS_1 TMP
			INNER JOIN REVERSAPAGCRE REV 		ON REV.CreditoID = TMP.creditoID
		WHERE REV.Fecha <=  Var_FechaFiltro
		;

	INSERT INTO TMPFONDEOMOVIMIWSLIS_2
	SELECT
			-- CLIENTE
			TMP.clienteID,	RFC,
			-- CREDITOS
			TMP.creditoID,	productoID,
			-- MOVIMIENTOS
			numAmortizacion,		numMovimiento,			Tip_NotCargo,			REV.FechaRegistro,		REV.NumTransaccion,
			totalMovimiento, 		REV.Capital, 			REV.Interes, 			REV.IVAInteres, 		REV.Moratorio,
			REV.IVAMoratorio,		conceptoID, 			comisionApertura,		IVAComisionApertura, 	interesComisionAper,
			comisionFaltaPago, 		IVAComisionFaltaPago, 	seguroFinanciado, 		IVASeguro, 				interesSeguroFin,
			comisionDisposicion,	interesComisionDisp	, 	comisionManejo,
			origenPagoID,			notaCargo, 				MontoIVANotasCargo
		FROM TMPFONDEOMOVIMIWSLIS_1 TMP
			INNER JOIN NOTASCARGO REV 		ON REV.CreditoID = TMP.creditoID
		WHERE REV.Fecha <=  Var_FechaFiltro
	;

	UPDATE TMPFONDEOMOVIMIWSLIS_3 TMP,
		DETALLEPAGCRE	DET	SET 
		origenPagoID =	CASE 
							WHEN OrigenPago = 'N' THEN '1'
							WHEN OrigenPago = 'S' THEN '4'
							WHEN OrigenPago = 'V' THEN '6'
							WHEN OrigenPago = 'C' THEN '2'
							WHEN OrigenPago = 'D' THEN '3'
							WHEN OrigenPago = 'R' THEN '5'
							WHEN OrigenPago = 'B' THEN '8'
							WHEN OrigenPago = 'A' THEN '8'
							WHEN OrigenPago = 'K' THEN '8'
							ELSE OrigenPago END  
		WHERE TMP.numAmortizacion = DET.AmortizacionID 
		AND TMP.CreditoID 	= DET.CreditoID;


END IF;

IF(Par_TipoMovimiento = Tip_Pago)THEN
	INSERT INTO TMPFONDEOMOVIMIWSLIS_2
		SELECT
			-- CLIENTE
			TMP.clienteID,	RFC,
			-- CREDITOS
			TMP.creditoID,	productoID,
			-- MOVIMIENTOS
			DET.AmortizacionID,		DET.AmortizacionID,			Tip_Pago,			DET.FechaPago,				DET.Transaccion,
			DET.MontoTotPago, 		DET.MontoCapOrd+DET.MontoCapAtr+DET.MontoCapVen,
			DET.MontoIntOrd+DET.MontoIntAtr+DET.MontoIntVen, 	DET.MontoIVA, 			DET.MontoIntMora,
			IVAMoratorios, 			conceptoID, 			comisionApertura,		IVAComisionApertura, 		interesComisionAper,
			comisionFaltaPago, 		IVAComisionFaltaPago, 	seguroFinanciado, 		IVASeguro, 					interesSeguroFin,
			comisionDisposicion,	interesComisionDisp	, 	comisionManejo,
			origenPagoID,			DET.MontoNotasCargo, 		DET.MontoIVANotasCargo
		FROM TMPFONDEOMOVIMIWSLIS_1 TMP
			INNER JOIN DETALLEPAGCRE DET 		ON DET.CreditoID = TMP.creditoID
		WHERE DET.AmortizacionID = Par_AmortizacionID
			AND TMP.creditoID 	= Par_CreditoID
			AND DET.FechaPago 	= Par_FechaPago
			AND DET.Transaccion = Par_Transaccion;

END IF;


IF(Par_TipoMovimiento = Tip_Condona)THEN
	INSERT INTO TMPFONDEOMOVIMIWSLIS_2
	SELECT
			-- CLIENTE
			max(TMP.clienteID),	max(RFC),
			-- CREDITOS
			max(TMP.creditoID),	max(productoID),
			-- MOVIMIENTOS
			max(AmortiCreID),			max(Consecutivo),			max(Tip_Condona),			max(CRE.FechaRegistro),		max(CRE.NumTransaccion),
			sum(MontoComisiones+ MontoMoratorios+ MontoInteres+MontoCapital+MontoComisiones), SUM(MontoCapital), SUM(MontoInteres), 	sum(totalIvaInteres), SUM(MontoMoratorios),
			sum(IVAMoratorios), 			max(conceptoID), 			sum(comisionApertura),		sum(IVAComisionApertura), 	sum(interesComisionAper),
			sum(comisionFaltaPago), 		sum(IVAComisionFaltaPago), 	sum(seguroFinanciado), 		sum(IVASeguro), 				sum(interesSeguroFin),
			sum(comisionDisposicion),	sum(interesComisionDisp), 	sum(comisionManejo),
			max(origenPagoID),			0,						0
		FROM TMPFONDEOMOVIMIWSLIS_1 TMP
			INNER JOIN CREQUITAS CRE 		ON CRE.CreditoID = TMP.creditoID
			inner  join CREDITOSMOVS movs on movs.CreditoID = CRE.CreditoID  
				and movs.NumTransaccion  = CRE.NumTransaccion 
		WHERE TMP.creditoID 	= Par_CreditoID
			AND CRE.FechaRegistro 	= Par_FechaPago
			AND CRE.NumTransaccion = Par_Transaccion
			and AmortiCreID = Par_AmortizacionID
		group by AmortiCreID;
END IF;


IF(Par_TipoMovimiento = Tip_Reversa)THEN
	INSERT INTO TMPFONDEOMOVIMIWSLIS_2
	SELECT
			-- CLIENTE
			TMP.clienteID,	RFC,
			-- CREDITOS
			TMP.creditoID,	productoID,
			-- MOVIMIENTOS
			numAmortizacion,		REV.TransaccionID,		Tip_Reversa,			REV.Fecha,				REV.TransaccionID,
			totalMovimiento, 		capital, 				totalInteres, 			totalIvaInteres, 		moratorios,
			IVAMoratorios, 			conceptoID, 			comisionApertura,		IVAComisionApertura, 	interesComisionAper,
			comisionFaltaPago, 		IVAComisionFaltaPago, 	seguroFinanciado, 		IVASeguro, 				interesSeguroFin,
			comisionDisposicion,	interesComisionDisp	, 	comisionManejo,
			origenPagoID,			notaCargo, 				MontoIVANotasCargo
		FROM TMPFONDEOMOVIMIWSLIS_1 TMP
			INNER JOIN REVERSAPAGCRE REV 		ON REV.CreditoID = TMP.creditoID
		WHERE TMP.creditoID 	= Par_CreditoID
			AND REV.Fecha 		= Par_FechaPago
			AND REV.TransaccionID = Par_Transaccion;
END IF;



IF(Par_TipoMovimiento = Tip_NotCargo)THEN
	INSERT INTO TMPFONDEOMOVIMIWSLIS_2
	SELECT
			-- CLIENTE
			TMP.clienteID,	RFC,
			-- CREDITOS
			TMP.creditoID,	productoID,
			-- MOVIMIENTOS
			AmortizacionID,			NotaCargoID,			Tip_NotCargo,			REV.FechaRegistro,		REV.NumTransaccion,
			totalMovimiento, 		REV.Capital, 			REV.Interes, 			REV.IVAInteres, 		REV.Moratorio,
			REV.IVAMoratorio,		conceptoID, 			comisionApertura,		IVAComisionApertura, 	interesComisionAper,
			comisionFaltaPago, 		IVAComisionFaltaPago, 	seguroFinanciado, 		IVASeguro, 				interesSeguroFin,
			comisionDisposicion,	interesComisionDisp	, 	comisionManejo,
			origenPagoID,			notaCargo, 				MontoIVANotasCargo
		FROM TMPFONDEOMOVIMIWSLIS_1 TMP
			INNER JOIN NOTASCARGO REV 		ON REV.CreditoID = TMP.creditoID
		WHERE AmortizacionID 	= Par_AmortizacionID
			AND TMP.creditoID 		= Par_CreditoID
			AND REV.FechaRegistro	= Par_FechaPago
			AND REV.NumTransaccion 	= Par_Transaccion;
END IF;



IF(Par_NumLis = Lis_Creditos) THEN -- 1
	select Par_NumErr AS codigoRespuesta,	Par_ErrMen as mensajeRespuesta,
		-- CLIENTE
		TMP.clienteID,	RFC,
		-- CREDITOS
		creditoID,	productoID,
		-- MOVIMIENTOS
		numAmortizacion,		numMovimiento,			tipoMovimiento,		fechaMovimiento,		transaccion,
		totalMovimiento, 		capital, 				totalInteres, 		totalIvaInteres, 		moratorios,
		IVAMoratorios, 			conceptoID, 			comisionApertura,	IVAComisionApertura, 	interesComisionAper,
		comisionFaltaPago, 		IVAComisionFaltaPago, 	seguroFinanciado, 	IVASeguro, 				interesSeguroFin,
		comisionDisposicion,	interesComisionDisp	, 	comisionManejo,		notaCargo, 				MontoIVANotasCargo
		-- accesorios
	--	accesorioID, 			nombreAccesorio, 		montoAccesorio, 	IVAAccesorio, 			origenPagoID
		FROM TMPFONDEOMOVIMIWSLIS_2 TMP;
END IF;

IF(Par_NumLis = Lis_Accesorios) THEN -- 2
	INSERT INTO TMPFONDEOMOVIMIWSLIS_3
		SELECT max(creditoID),  max(numAmortizacion)
		from TMPFONDEOMOVIMIWSLIS_2
		group by numAmortizacion, creditoID;

	select 	DET.CreditoID, 			DET.AmortizacionID, DET.AccesorioID, Descripcion, DET.MontoAccesorio,  
			DET.MontoIVAAccesorio, 	Entero_Cero as origenPagoID
	from DETALLEACCESORIOS DET,
		ACCESORIOSCRED ACC,
		TMPFONDEOMOVIMIWSLIS_3 TMP
	where ACC.AccesorioID= DET.AccesorioID
		AND TMP.CreditoID 			= DET.creditoID
		AND TMP.numAmortizacion 	= DET.AmortizacionID;


END IF;



DROP TABLE TMPFONDEOMOVIMIWSLIS_1;
DROP TABLE TMPFONDEOMOVIMIWSLIS_2;
DROP TABLE TMPFONDEOMOVIMIWSLIS_3;

END TerminaStore$$
