-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANRESUMENCAJACON
DELIMITER ;

DROP PROCEDURE IF EXISTS `BANRESUMENCAJACON`;

DELIMITER $$

CREATE PROCEDURE `BANRESUMENCAJACON`(
	Par_CajaID			INT(11),				-- caja ID	
	Par_NumCon			INT(11),				-- Numero de consulta
	
	Aud_EmpresaID		INT(11),				-- Auditoria
	Aud_Usuario			INT(11),				-- Auditoria

	Aud_FechaActual		DATETIME,				-- Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Auditoria
	Aud_Sucursal		INT,					-- Auditoria
	Aud_NumTransaccion	BIGINT(20)				-- Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia				CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);		-- Entero Cero
	DECLARE	Con_ResCaja					INT(11);		-- Resumen de Caja
	DECLARE TipoOpPagoCre				INT(11);		-- Tipo de operacion de Pago de credito
	DECLARE TipoOpPrePagoCre			INT(11);		-- Tipo de operacion de PrePago de credito
	DECLARE TipoOpDesemb				INT(11);		-- Tipo de operacion para Desembolso de Credito
	DECLARE Est_Pagado					CHAR(1);		-- Estatus pagado
	DECLARE Var_TipoCajaPrin			CHAR(2);		-- Tipo de Caja Principal
	DECLARE Est_Activo					CHAR(1);		-- Estatus Activo
    DECLARE Decimal_Cero				DECIMAL(12,2);	-- Decimal Cero
	
	-- Declaracion de Variables
	DECLARE Var_FechaActual				DATE;			-- Fecha Actual del sistema
	DECLARE Var_UsuarioID				INT(11);		-- ID del Usuario de Caja
	DECLARE Var_PromotorID				INT(11);		-- ID del Promor de Caja
	DECLARE Var_NumTranSalIni			BIGINT(20);		-- Numero de Transaccion del Saldo Inicial
	DECLARE Var_SaldoInicial			DECIMAL(12,2);	-- Saldo Inicial de la Caja
	DECLARE Var_CantCliReg				INT(11);		-- Cantidad de clientes registrados por el promotor
	DECLARE Var_TotalPagCre				DECIMAL(12,2);	-- Total de pagos de credito del dia
	DECLARE Var_TotalMontoDesemb		DECIMAL(12,2);	-- Total de Desembolsos de credito del dia
	DECLARE Var_CantCliAten				INT(11);		-- Cantidad total de clientes atendidos y registrados
	DECLARE Var_TotMontoExi				DECIMAL(14,2);	-- Total del monto exigible del dia
	DECLARE Var_PorcRec					DECIMAL(10,2);	-- Porcentaje de recaudacion
	DECLARE Var_SucursalCajaID			INT(11);		-- ID de la Sucursal de la Caja
	DECLARE Var_CajaPrincipalID			INT(11);		-- ID de la caja principal
    DECLARE Var_TotalAnti				DECIMAL(12,2);	-- Total de Anticipos
    DECLARE Var_TotalAtras				DECIMAL(12,2);	-- Total de Atrasos
	
	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';				-- Cadena Vacia
	SET Fecha_Vacia 				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Con_ResCaja					:= 1;				-- Resumen de Caja
	SET TipoOpPagoCre				:= 28;				-- Tipo de operacion de Pago de credito
	SET TipoOpPrePagoCre			:= 79;				-- Tipo de operacion de PrePago de credito
	SET TipoOpDesemb				:= 10;				-- Tipo de operacion para Desembolso de Credito
	SET Est_Pagado					:= 'P';				-- Estatus pagado
	SET Var_TipoCajaPrin			:= 'CP';			-- Tipo de Caja Principal
	SET Est_Activo					:= 'A';				-- Estatus Activo
    SET Decimal_Cero				:= 0.00;			-- Decimal Cero
	

	IF(Par_NumCon = Con_ResCaja) THEN
		SELECT 		FechaSistema
			INTO 	Var_FechaActual
			FROM PARAMETROSSIS;
	
		-- Consultamos la informacion de la caja
        SELECT 		CAJA.UsuarioID,		PRO.PromotorID,   CAJA.SucursalID
            INTO 	Var_UsuarioID,		Var_PromotorID,   Var_SucursalCajaID 
            FROM CAJASVENTANILLA CAJA
            LEFT JOIN PROMOTORES PRO ON PRO.UsuarioID = CAJA.UsuarioID
            WHERE CajaID = Par_CajaID;
            
        SET Var_PromotorID := IFNULL(Var_PromotorID, Entero_Cero);
        
        
        SELECT CajaID
			INTO Var_CajaPrincipalID
            FROM CAJASVENTANILLA
            WHERE SucursalID = Var_SucursalCajaID
            AND TipoCaja = Var_TipoCajaPrin
            AND Estatus = Est_Activo
            AND EstatusOpera = Est_Activo;
            
		SET Var_CajaPrincipalID := IFNULL(Var_CajaPrincipalID, Entero_Cero);
        
        -- Consultamos la transaccion para el monto inicial de la caja
        SELECT MIN(NumTransaccion)
			INTO Var_NumTranSalIni
			FROM CAJASTRANSFER
			WHERE CajaDestino = Par_CajaID
			AND CajaOrigen = Var_CajaPrincipalID
			AND CAST(Fecha AS DATE) = Var_FechaActual;
			
		SET Var_NumTranSalIni := IFNULL(Var_NumTranSalIni, Entero_Cero);
        
        -- Obtenemos el monto inicial de la caja por transferencia entre cajas
		SELECT  	SUM(DEN.Valor * TRAN.Cantidad)
			INTO 	Var_SaldoInicial
			FROM CAJASTRANSFER TRAN
			INNER JOIN DENOMINACIONES DEN ON DEN.DenominacionID = TRAN.DenominacionID
			WHERE TRAN.NumTransaccion = Var_NumTranSalIni;
			
		SET Var_SaldoInicial := IFNULL(Var_SaldoInicial, Entero_Cero);
            
		-- Contamos los clientes registrados para el promotor ligado a la caja
        SELECT COUNT(ClienteID)
			INTO Var_CantCliReg
            FROM CLIENTES
            WHERE PromotorInicial = Var_PromotorID
            AND FechaAlta = Var_FechaActual;
            
		-- Sumamos el Monto recibido por pagos y prepagos de Credito.
		SELECT SUM(MOV.MontoEnFirme)
			INTO Var_TotalPagCre
			FROM CAJASMOVS MOV
			WHERE TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre) AND Fecha = Var_FechaActual
			AND MOV.CajaID = Par_CajaID;
			
		SET Var_TotalPagCre := IFNULL(Var_TotalPagCre, Entero_Cero);
			
		-- Sumamos el Monto desembolsado de creditos en caja.
		SELECT 		SUM(MOV.MontoEnFirme)
			INTO 	Var_TotalMontoDesemb
			FROM CAJASMOVS MOV
			WHERE Fecha = Var_FechaActual AND TipoOperacion = TipoOpDesemb
			AND MOV.CajaID = Par_CajaID;

		SET Var_TotalMontoDesemb := IFNULL(Var_TotalMontoDesemb, Entero_Cero);
		
		-- Contamos los distintos clientes antendidos o registrados
		DROP TABLE IF EXISTS TMP_CLIENTESATEN;
		CREATE TEMPORARY TABLE TMP_CLIENTESATEN(
			ClienteID			INT(11),
			INDEX(ClienteID)	
		);
		
		INSERT INTO TMP_CLIENTESATEN
			SELECT  DISTINCT(CRE.ClienteID)
				FROM CAJASMOVS MOVS
				INNER JOIN CREDITOS CRE ON CRE.CreditoID = MOVS.Instrumento
				WHERE MOVS.TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre,TipoOpDesemb) AND MOVS.Fecha = Var_FechaActual
				AND MOVS.CajaID = Par_CajaID;
				
		INSERT INTO TMP_CLIENTESATEN
			SELECT DISTINCT(ClienteID)
				FROM CLIENTES
				WHERE PromotorInicial = Var_PromotorID
				AND FechaAlta = Var_FechaActual;
		
		SELECT COUNT(DISTINCT(ClienteID))
			INTO Var_CantCliAten
			FROM TMP_CLIENTESATEN;
			
		-- Creditoscon Coutas exigibles
		DROP TABLE IF EXISTS TMP_CREDITOSEXI;
		CREATE TEMPORARY TABLE TMP_CREDITOSEXI(
			CreditoID BIGINT(12),
			INDEX (CreditoID)
		);
		
		INSERT INTO TMP_CREDITOSEXI
			SELECT DISTINCT(CRE.CreditoID)
				FROM AMORTICREDITO AMO
				INNER JOIN CREDITOS CRE ON CRE.CreditoID = AMO.CreditoID
				INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
				WHERE AMO.FechaExigible <= Var_FechaActual
				AND SOL.PromotorID = Var_PromotorID
				AND (AMO.Estatus <> Est_Pagado OR (AMO.Estatus = Est_Pagado AND FechaLiquida = Var_FechaActual));
		
		SELECT 		SUM(BANFNEXIGIBLEALDIA(CreditoID))
			INTO 	Var_TotMontoExi
			FROM TMP_CREDITOSEXI;
			
		SET Var_TotalPagCre := IFNULL(Var_TotalPagCre, Entero_Cero);
		SET Var_TotMontoExi := IFNULL(Var_TotMontoExi, Entero_Cero);
		SET Var_PorcRec := Entero_Cero;
		IF(Var_TotMontoExi > Entero_Cero) THEN
            SET Var_PorcRec :=  ROUND(Var_TotalPagCre/Var_TotMontoExi,2);
		END IF;
        
        -- TABLA TEMPORAL PARA REGISTRO DE CREDITOS COBRADOS AL DIA
		DROP TABLE IF EXISTS TMP_CAJASMOVS;
		CREATE TEMPORARY TABLE TMP_CAJASMOVS(
            CajaID			INT(11),
            Instrumento		BIGINT(20)
		);
        INSERT INTO TMP_CAJASMOVS
        SELECT CajaID, Instrumento 
        FROM CAJASMOVS
		WHERE Fecha = Var_FechaActual
			AND TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre)
            AND CajaID = Par_CajaID
		GROUP BY Instrumento, CajaID;
        
        -- SALDO TOTAL ANTICIPOS
        SELECT SUM(DET.MontoTotPago)
			INTO Var_TotalAnti
		FROM DETALLEPAGCRE DET
		INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = DET.CreditoID
						AND AMO.AmortizacionID = DET.AmortizacionID
		INNER JOIN TMP_CAJASMOVS TMP ON TMP.Instrumento = DET.CreditoID
		WHERE DET.FechaPago = Var_FechaActual
		AND AMO.FechaExigible > Var_FechaActual
		AND TMP.CajaID = Par_CajaID;  
        
		-- SALDO TOTAL ATRASO
		SELECT SUM(DET.MontoTotPago)
			INTO Var_TotalAtras
		FROM DETALLEPAGCRE DET
		INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = DET.CreditoID
						AND AMO.AmortizacionID = DET.AmortizacionID
		INNER JOIN TMP_CAJASMOVS TMP ON TMP.Instrumento = DET.CreditoID
		WHERE DET.FechaPago = Var_FechaActual
		AND AMO.FechaExigible < Var_FechaActual
		AND TMP.CajaID = Par_CajaID;
        
		SELECT	  	CajaID, 	   						SaldoEfecMN,							Var_SaldoInicial AS SaldoInicial,		Var_TotalMontoDesemb AS SaldoPagCred,		Var_CantCliAten	AS CantCliAtendidos,
					Var_CantCliReg AS CantCliReg,		Var_PorcRec	AS PorcRecaudacion,			Var_TotalPagCre AS MontoTotalRec,		Var_TotMontoExi AS MontoTotExigible,		IFNULL(Var_TotalAnti,Decimal_Cero) AS TotalAnti,
                    IFNULL(Var_TotalAtras,Decimal_Cero) AS TotalAtras
            FROM CAJASVENTANILLA
            WHERE CajaID = Par_CajaID;
	END IF;

END TerminaStore$$
