-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANRESUMENCAJACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCONSOLIDADOCAJACON`;
DELIMITER $$


CREATE PROCEDURE `BANCONSOLIDADOCAJACON`(
	Par_AsesorID			INT(11),				-- ASESOR ID	
	Par_CordID				INT(11),				-- Coordinador ID
	Par_GerenteID			INT(11),				-- Gerente ID
	Par_NumCon				TINYINT UNSIGNED,		-- Numero de consulta
	
	Aud_EmpresaID			INT(11),				-- Auditoria
	Aud_Usuario				INT(11),				-- Auditoria

	Aud_FechaActual			DATETIME,				-- Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Auditoria
	Aud_Sucursal			INT(11),				-- Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Auditoria
	)

TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE	Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero			INT(1);				-- Entero cero
	DECLARE	Con_Promotor		INT(11);			-- Consulta principal por promotor o asesor 
	DECLARE Con_Coordinador		INT(11);			-- Consulta suma caja por coordinador
	DECLARE Con_Gerente			INT(11);			-- Consulta de suma caja por gerente
	DECLARE TipoOpDesemb		INT(11);			-- TipoOperacion desembolso	
	DECLARE TipoOpPrePagoCre		INT(11);		-- Tipo pago adelantado de credito		
	DECLARE TipoOpPagoCre		INT(11);			-- Tipo pago credito
	DECLARE Var_TipoCA			CHAR(2);			-- Tipo caja de atencion a publico
	DECLARE Var_TipoCP			CHAR(2);			-- Tipo caja principal
	DECLARE Var_EstatusPagado	CHAR(1);			-- Estatus pagado del crédito
	DECLARE Var_SumaTotal		DOUBLE(12,2);
	
	-- Declaracion de variables 
	DECLARE Var_PorRec			DECIMAL(10, 2);		-- Porcentaje recaudado
	DECLARE Var_TotalDesemb		INT(11);			-- Pagos desembolsados
	DECLARE Var_PagosAtrazados 	DECIMAL(12, 2);		-- Pagos atrazados
	DECLARE Var_PagosAdel		DECIMAL(12, 2);		-- Pagos adelantados
	DECLARE Var_PromotorID		INT(11);			-- Número del promotor
	DECLARE Var_SucursalID		INT(11);			-- Número de la sucursal
	DECLARE Var_UsuarioID		INT(11);			-- Número del usuario
	DECLARE Var_FechaHoy		DATETIME;			-- Fecha del sistema
	DECLARE Var_AsesorID		INT(11);			-- Número del asesor
	DECLARE Var_CordID			INT(11);			-- Número del coordinador
	DECLARE Var_CajaID			INT(11);			-- Número de la caja
	DECLARE Var_ClientesAtend	INT(11);			-- Clientes atendidos
	DECLARE Var_CreditLiber		INT(11);			-- Clientes liberados
	DECLARE Var_TotalRecaud		DECIMAL(14, 2);		-- Total recaudado
	DECLARE Var_TotalDesem		DECIMAL(14, 2);		-- Total desembolsado
	DECLARE Var_TotalExiDia		DECIMAL(14, 2);		-- Total exigibles al día
	DECLARE Var_CajaPrinID		INT(11);			-- Numero de Caja principal
	
	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET TipoOpPagoCre			:= 28;				-- Tipo de operacion de Pago de credito
	SET TipoOpPrePagoCre		:= 79;				-- Tipo de operacion de PrePago de credito
	SET TipoOpDesemb			:= 10;				-- Tipo de operacion para Desembolso de Credito
	SET Con_Promotor			:= 1;				-- Consulta principal
	SET Con_Coordinador			:= 2;				-- Consulta por coordinador
	SET Con_Gerente				:= 3;				-- Consulta por gerente
	SET Var_TipoCA				:='CA';				-- Tipo caja de atencion a publico
	SET Var_TipoCP				:='CP';				-- Tipo caja principal
	SET Var_EstatusPagado 		:= 'P';				-- Estatus del crédito pagado
	
	
	SET Var_AsesorID := IFNULL(Par_AsesorID, Entero_Cero);
	SET Var_CordID := IFNULL(Par_CordID, Entero_Cero);
	
	-- Consulta por Por promotor
	IF(Par_NumCon = Con_Promotor) THEN
		SELECT FechaSistema 
			INTO Var_FechaHoy
			FROM PARAMETROSSIS WHERE EmpresaID = Aud_EmpresaID;
		
		-- Obtenemos el id del usuario de ventanilla
		SELECT 		CA.CajaID, 		PRO.PromotorID
            INTO 	Var_CajaID, 	Var_PromotorID
			FROM CAJASVENTANILLA CA
            LEFT JOIN PROMOTORES PRO ON PRO.UsuarioID = CA.UsuarioID
            WHERE CA.UsuarioID = Var_AsesorID AND TipoCaja = Var_TipoCA;
		
		SET Var_CajaID := IFNULL(Var_CajaID, Entero_Cero);
		SET Var_PromotorID := IFNULL(Var_PromotorID, Entero_Cero);
		
		-- Contamos el numero de creditos desembolsados en caja.
		SELECT 		COUNT(MOV.CajaID)
			INTO 	Var_TotalDesemb
			FROM CAJASMOVS MOV
			WHERE Fecha = Var_FechaHoy AND TipoOperacion = TipoOpDesemb
			AND MOV.CajaID = Var_CajaID;
			
		-- Clientes registrados
		SELECT 		COUNT(ClienteID)
			INTO 	Var_ClientesAtend
			FROM CLIENTES 
			WHERE FechaAlta = Var_FechaHoy AND PromotorInicial = Var_PromotorID;
		
		-- Contamos los distintos clientes antendidos o registrados
		DELETE FROM TMP_BANCLIENTESATEN WHERE NumTransaccion = Aud_NumTransaccion;

		INSERT INTO TMP_BANCLIENTESATEN (ClienteID,		NumTransaccion)
			SELECT  DISTINCT(CRE.ClienteID),			Aud_NumTransaccion
				FROM CAJASMOVS MOVS
				INNER JOIN CREDITOS CRE ON CRE.CreditoID = MOVS.Instrumento
				WHERE MOVS.TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre,TipoOpDesemb) AND MOVS.Fecha = Var_FechaHoy
				AND MOVS.CajaID = Var_CajaID;
				
		INSERT INTO TMP_BANCLIENTESATEN (ClienteID,		NumTransaccion)
			SELECT DISTINCT(ClienteID),					Aud_NumTransaccion
				FROM CLIENTES
				WHERE PromotorInicial = Var_PromotorID
				AND FechaAlta = Var_FechaHoy;
		
		SELECT COUNT(DISTINCT(ClienteID))
			INTO Var_ClientesAtend
			FROM TMP_BANCLIENTESATEN
			WHERE NumTransaccion = Aud_NumTransaccion;

		DELETE FROM TMP_BANCLIENTESATEN WHERE NumTransaccion = Aud_NumTransaccion;
		
		SET Var_CajaID := IFNULL(Var_CajaID, Entero_Cero);

		-- Total REcaudado
		-- Sumamos el Monto recibido por pagos y prepagos de Credito.
		SELECT SUM(MOV.MontoEnFirme)
			INTO Var_TotalRecaud
			FROM CAJASMOVS MOV
			WHERE TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre) AND Fecha = Var_FechaHoy
			AND MOV.CajaID = Var_CajaID;

		-- Total Desembolsado
		-- Sumamos el Monto de desembolsos de Creditos.
		SELECT SUM(MOV.MontoEnFirme)
			INTO Var_TotalDesem
			FROM CAJASMOVS MOV
			WHERE TipoOperacion IN (TipoOpDesemb) AND Fecha = Var_FechaHoy
			AND MOV.CajaID = Var_CajaID;
		
		
		-- Creditos con pagos exigibles
		-- Se crea la tabla temporal de creditos id
		-- Creditoscon Coutas exigibles
		DELETE FROM TMP_BANCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;
		
		INSERT INTO TMP_BANCREDITOS (CreditoID,	NumTransaccion)
			SELECT DISTINCT(CRE.CreditoID),		Aud_NumTransaccion
				FROM AMORTICREDITO AMO
				INNER JOIN CREDITOS CRE ON CRE.CreditoID = AMO.CreditoID
				INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
				WHERE AMO.FechaExigible <= Var_FechaHoy
				AND SOL.PromotorID = Var_PromotorID
				AND (AMO.Estatus <> Var_EstatusPagado OR (AMO.Estatus = Var_EstatusPagado AND FechaLiquida = Var_FechaHoy));
				
		
		SELECT 		SUM(BANFNEXIGIBLEALDIA(CreditoID))
			INTO 	Var_TotalExiDia
			FROM TMP_BANCREDITOS
			WHERE NumTransaccion = Aud_NumTransaccion;

		DELETE FROM TMP_BANCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;
			
		-- Almacenamos en la tabla temporal los creditos atendidos
		INSERT INTO TMP_BANCREDITOS (CreditoID,	NumTransaccion)
			SELECT DISTINCT(Instrumento),		Aud_NumTransaccion
				FROM CAJASMOVS
				WHERE TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre) AND Fecha = Var_FechaHoy
				AND CajaID = Var_CajaID;
				
		
		-- Consulta atrazados
		SELECT 		SUM(DET.MontoTotPago)
			INTO 	Var_PagosAtrazados
			FROM DETALLEPAGCRE DET
			INNER JOIN AMORTICREDITO AMOR ON AMOR.CreditoID = DET.CreditoID AND AMOR.AmortizacionID = DET.AmortizacionID
			INNER JOIN TMP_BANCREDITOS CATE ON CATE.CreditoID = AMOR.CreditoID AND CATE.NumTransaccion = Aud_NumTransaccion
			INNER JOIN CREDITOS CRE ON CRE.CreditoID = DET.CreditoID
			INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
			WHERE DET.FechaPago = Var_FechaHoy AND AMOR.FechaExigible < Var_FechaHoy AND SOL.PromotorID = Var_PromotorID;
			
		-- adelantados
		SELECT 		SUM(DET.MontoTotPago)
			INTO 	Var_PagosAdel
			FROM DETALLEPAGCRE DET
			INNER JOIN AMORTICREDITO AMOR ON AMOR.CreditoID = DET.CreditoID AND AMOR.AmortizacionID = DET.AmortizacionID
			INNER JOIN TMP_BANCREDITOS CATE ON CATE.CreditoID = AMOR.CreditoID AND CATE.NumTransaccion = Aud_NumTransaccion
			INNER JOIN CREDITOS CRE ON CRE.CreditoID = DET.CreditoID
			INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
			WHERE DET.FechaPago = Var_FechaHoy AND AMOR.FechaExigible > Var_FechaHoy AND SOL.PromotorID = Var_PromotorID;
		
		SET Var_PagosAtrazados := IFNULL(Var_PagosAtrazados, Entero_Cero);
		SET Var_TotalRecaud := IFNULL(Var_TotalRecaud, Entero_Cero);
		SET Var_TotalExiDia := IFNULL(Var_TotalExiDia, Entero_Cero);
		SET Var_PagosAdel	:= IFNULL(Var_PagosAdel, Entero_Cero);
		SET Var_ClientesAtend := IFNULL(Var_ClientesAtend, Entero_Cero);
		SET Var_SumaTotal := (Var_PagosAdel + Var_PagosAtrazados + Var_TotalExiDia);
		IF(Var_SumaTotal > Entero_Cero && Var_TotalRecaud > Entero_Cero) THEN
			SET Var_PorRec := ROUND(Var_SumaTotal / Var_TotalRecaud, 2);
		END IF;
		
		SET Var_PorRec := IFNULL(Var_PorRec, Entero_Cero);

		DELETE FROM TMP_BANCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;
		

		SET Var_TotalDesem := IFNULL(Var_TotalDesem, Entero_Cero);

		SELECT	Var_CajaID AS CajaID, Var_PagosAdel AS PagosAnticipados, Var_PagosAtrazados AS PagosAtrazados,	Var_TotalExiDia AS TotalPagosExi, Var_TotalDesemb AS CantCredOtorg,
				Var_TotalRecaud AS MontoTotRec, Var_PorRec AS PorcentRec, Var_ClientesAtend AS ClientesAtend, 	Var_TotalDesem AS MontoTotDes;
	END IF;

	-- Consulta por Gerente
	IF(Par_NumCon = Con_Coordinador) THEN
		SELECT FechaSistema 
			INTO Var_FechaHoy
			FROM PARAMETROSSIS WHERE EmpresaID = Aud_EmpresaID;
		
		-- Obtenemos el numero de caja principal
		SELECT 		CajaID,				SucursalID
            INTO 	Var_CajaPrinID,		Var_SucursalID
			FROM CAJASVENTANILLA
            WHERE UsuarioID = Par_CordID AND TipoCaja = Var_TipoCP;

        SET Var_CajaPrinID := IFNULL(Var_CajaPrinID, Entero_Cero);

        DELETE FROM TMP_BANCAJEROS WHERE NumTransaccion = Aud_NumTransaccion;

        INSERT INTO TMP_BANCAJEROS(CajaID, 	UsuarioID, 			PromotorID,			NumTransaccion)
        	SELECT 		CA.CajaID, 			CA.UsuarioID,		PRO.PromotorID,		Aud_NumTransaccion
				FROM CAJASVENTANILLA CA
				LEFT JOIN PROMOTORES PRO ON PRO.UsuarioID = CA.UsuarioID
				WHERE CA.SucursalID = Var_SucursalID AND TipoCaja = Var_TipoCA;

		SET Var_UsuarioID := IFNULL(Var_UsuarioID, Entero_Cero);
		SET Var_CajaID := IFNULL(Var_CajaID, Entero_Cero);
		SET Var_PromotorID := IFNULL(Var_PromotorID, Entero_Cero);
		
		-- Contamos el numero de creditos desembolsados en caja.
		SELECT 		COUNT(MOVS.CajaID)
			INTO 	Var_TotalDesemb
			FROM CAJASMOVS MOVS
			INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.CajaID = MOVS.CajaID AND CAJ.NumTransaccion = Aud_NumTransaccion
			WHERE MOVS.Fecha = Var_FechaHoy AND MOVS.TipoOperacion = TipoOpDesemb;

			
		-- Clientes registrados
		SELECT COUNT(CLI.ClienteID)
		INTO Var_ClientesAtend
			FROM CLIENTES CLI
			INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.PromotorID = CLI.PromotorInicial AND CAJ.NumTransaccion = Aud_NumTransaccion
			WHERE FechaAlta = Var_FechaHoy;
		
		
		
		-- Contamos los distintos clientes antendidos o registrados
		DELETE FROM TMP_BANCLIENTESATEN WHERE NumTransaccion = Aud_NumTransaccion;
		INSERT INTO TMP_BANCLIENTESATEN (ClienteID, 	NumTransaccion)
			SELECT  DISTINCT(CRE.ClienteID),		Aud_NumTransaccion
				FROM CAJASMOVS MOVS
				INNER JOIN CREDITOS CRE ON CRE.CreditoID = MOVS.Instrumento
				INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.CajaID = MOVS.CajaID AND CAJ.NumTransaccion = Aud_NumTransaccion
				WHERE MOVS.TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre,TipoOpDesemb) AND MOVS.Fecha = Var_FechaHoy;
				
		INSERT INTO TMP_BANCLIENTESATEN (ClienteID, 	NumTransaccion)
			SELECT DISTINCT(ClienteID),				Aud_NumTransaccion
				FROM CLIENTES CLI
				INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.PromotorID = CLI.PromotorInicial AND CAJ.NumTransaccion = Aud_NumTransaccion
				AND FechaAlta = Var_FechaHoy;
		
		SELECT COUNT(DISTINCT(ClienteID))
			INTO Var_ClientesAtend
			FROM TMP_BANCLIENTESATEN
			WHERE NumTransaccion = Aud_NumTransaccion;

		DELETE FROM TMP_BANCLIENTESATEN WHERE NumTransaccion = Aud_NumTransaccion;
		

		SET Var_CajaID := IFNULL(Var_CajaID, Entero_Cero);

		-- Total REcaudado
		-- Sumamos el Monto recibido por pagos y prepagos de Credito.
		SELECT SUM(MOVS.MontoEnFirme)
			INTO Var_TotalRecaud
			FROM CAJASMOVS MOVS
			INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.CajaID = MOVS.CajaID AND CAJ.NumTransaccion = Aud_NumTransaccion
			WHERE MOVS.TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre) AND MOVS.Fecha = Var_FechaHoy;

		-- Total Desembolsado
		-- Sumamos el Monto de desembolsos de Creditos.
		SELECT SUM(MOV.MontoEnFirme)
			INTO Var_TotalDesem
			FROM CAJASMOVS MOV
			WHERE TipoOperacion IN (TipoOpDesemb) AND Fecha = Var_FechaHoy
			AND MOV.CajaID = Var_CajaPrinID;
		
		
		-- Creditos con pagos exigibles
		-- Se crea la tabla temporal de creditos id
		-- Creditoscon Coutas exigibles
		DELETE FROM TMP_BANCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;

		INSERT INTO TMP_BANCREDITOS (CreditoID, NumTransaccion)
			SELECT DISTINCT(CRE.CreditoID),		Aud_NumTransaccion
				FROM AMORTICREDITO AMO
				INNER JOIN CREDITOS CRE ON CRE.CreditoID = AMO.CreditoID
				INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
				INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.PromotorID = SOL.PromotorID AND CAJ.NumTransaccion = Aud_NumTransaccion
				WHERE AMO.FechaExigible <= Var_FechaHoy
				AND (AMO.Estatus <> Var_EstatusPagado OR (AMO.Estatus = Var_EstatusPagado AND FechaLiquida = Var_FechaHoy));
				
		
		SELECT 		SUM(BANFNEXIGIBLEALDIA(CreditoID))
			INTO 	Var_TotalExiDia
			FROM TMP_BANCREDITOS
			WHERE NumTransaccion = Aud_NumTransaccion;



		DELETE FROM TMP_BANCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;

		INSERT INTO TMP_BANCREDITOS (CreditoID, 		NumTransaccion)
			SELECT DISTINCT(MOVS.Instrumento),		Aud_NumTransaccion
				FROM CAJASMOVS MOVS
				INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.CajaID = MOVS.CajaID AND CAJ.NumTransaccion = Aud_NumTransaccion
				WHERE MOVS.TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre) 
				AND MOVS.Fecha = Var_FechaHoy;
		
		-- Consulta atrazados
		SELECT 		SUM(DET.MontoTotPago)
			INTO 	Var_PagosAtrazados
			FROM DETALLEPAGCRE DET
			INNER JOIN AMORTICREDITO AMOR ON AMOR.CreditoID = DET.CreditoID AND AMOR.AmortizacionID = DET.AmortizacionID
			INNER JOIN TMP_BANCREDITOS CATE ON CATE.CreditoID = AMOR.CreditoID AND CATE.NumTransaccion = Aud_NumTransaccion
			INNER JOIN CREDITOS CRE ON CRE.CreditoID = DET.CreditoID
			INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
			INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.PromotorID = SOL.PromotorID AND CAJ.NumTransaccion = Aud_NumTransaccion
			WHERE DET.FechaPago = Var_FechaHoy 
			AND AMOR.FechaExigible < Var_FechaHoy;
			
		-- adelantados
		SELECT 		SUM(DET.MontoTotPago)
			INTO 	Var_PagosAdel
			FROM DETALLEPAGCRE DET
			INNER JOIN AMORTICREDITO AMOR ON AMOR.CreditoID = DET.CreditoID AND AMOR.AmortizacionID = DET.AmortizacionID
			INNER JOIN TMP_BANCREDITOS CATE ON CATE.CreditoID = AMOR.CreditoID AND CATE.NumTransaccion = Aud_NumTransaccion
			INNER JOIN CREDITOS CRE ON CRE.CreditoID = DET.CreditoID
			INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
			INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.PromotorID = SOL.PromotorID AND CAJ.NumTransaccion = Aud_NumTransaccion
			WHERE DET.FechaPago = Var_FechaHoy 
			AND AMOR.FechaExigible > Var_FechaHoy;
		
		SET Var_PagosAtrazados := IFNULL(Var_PagosAtrazados, Entero_Cero);
		SET Var_TotalRecaud := IFNULL(Var_TotalRecaud, Entero_Cero);
		SET Var_TotalExiDia := IFNULL(Var_TotalExiDia, Entero_Cero);
		SET Var_PagosAdel	:= IFNULL(Var_PagosAdel, Entero_Cero);
		SET Var_ClientesAtend := IFNULL(Var_ClientesAtend, Entero_Cero);
		SET Var_SumaTotal := (Var_PagosAdel + Var_PagosAtrazados + Var_TotalExiDia);
		IF(Var_SumaTotal > Entero_Cero && Var_TotalRecaud > Entero_Cero) THEN
			SET Var_PorRec := ROUND(Var_SumaTotal / Var_TotalRecaud, 2);
		END IF;
		
		SET Var_PorRec := IFNULL(Var_PorRec, Entero_Cero);
		SET Var_TotalDesem := IFNULL(Var_TotalDesem, Entero_Cero);

		DELETE FROM TMP_BANCAJEROS WHERE NumTransaccion = Aud_NumTransaccion;
		DELETE FROM TMP_BANCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;

		-- Devolvemos el resultado
		SELECT	Var_CajaID AS CajaID, Var_PagosAdel AS PagosAnticipados, Var_PagosAtrazados AS PagosAtrazados,	Var_TotalExiDia AS TotalPagosExi, Var_TotalDesemb AS CantCredOtorg,
				Var_TotalRecaud AS MontoTotRec, Var_PorRec AS PorcentRec, Var_ClientesAtend AS ClientesAtend, 	Var_TotalDesem AS MontoTotDes;
	END IF;


	-- Consulta por Coordinador
	IF(Par_NumCon = Con_Gerente) THEN
		SELECT FechaSistema 
			INTO Var_FechaHoy
			FROM PARAMETROSSIS WHERE EmpresaID = Aud_EmpresaID;
		
		-- Obtenemos el numero de caja principal
		SELECT 		CajaID,				SucursalID
            INTO 	Var_CajaPrinID,		Var_SucursalID
			FROM CAJASVENTANILLA
            WHERE UsuarioID = Par_CordID AND TipoCaja = Var_TipoCP;

        SET Var_CajaPrinID := IFNULL(Var_CajaPrinID, Entero_Cero);

        DELETE FROM TMP_BANCAJEROS WHERE NumTransaccion = Aud_NumTransaccion;

        INSERT INTO TMP_BANCAJEROS (CajaID,		UsuarioID,			PromotorID, 		NumTransaccion)
        	SELECT 		CA.CajaID, 				CA.UsuarioID,		PRO.PromotorID,		Aud_NumTransaccion
				FROM CAJASVENTANILLA CA
				LEFT JOIN PROMOTORES PRO ON PRO.UsuarioID = CA.UsuarioID
				WHERE CA.SucursalID = Var_SucursalID AND TipoCaja = Var_TipoCA;

		SET Var_UsuarioID := IFNULL(Var_UsuarioID, Entero_Cero);
		SET Var_CajaID := IFNULL(Var_CajaID, Entero_Cero);
		SET Var_PromotorID := IFNULL(Var_PromotorID, Entero_Cero);
		
		-- Contamos el numero de creditos desembolsados en caja.
		SELECT 		COUNT(MOVS.CajaID)
			INTO 	Var_TotalDesemb
			FROM CAJASMOVS MOVS
			INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.CajaID = MOVS.CajaID AND CAJ.NumTransaccion = Aud_NumTransaccion
			WHERE MOVS.Fecha = Var_FechaHoy AND MOVS.TipoOperacion = TipoOpDesemb;

			
		-- Clientes registrados
		SELECT COUNT(CLI.ClienteID)
		INTO Var_ClientesAtend
			FROM CLIENTES CLI
			INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.PromotorID = CLI.PromotorInicial AND CAJ.NumTransaccion = Aud_NumTransaccion
			WHERE FechaAlta = Var_FechaHoy;
		
		
		
		-- Contamos los distintos clientes antendidos o registrados
		DELETE FROM TMP_BANCLIENTESATEN WHERE NumTransaccion = Aud_NumTransaccion;
		
		INSERT INTO TMP_BANCLIENTESATEN(ClienteID, 	NumTransaccion)
			SELECT  DISTINCT(CRE.ClienteID),		Aud_NumTransaccion
				FROM CAJASMOVS MOVS
				INNER JOIN CREDITOS CRE ON CRE.CreditoID = MOVS.Instrumento
				INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.CajaID = MOVS.CajaID AND CAJ.NumTransaccion = Aud_NumTransaccion
				WHERE MOVS.TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre,TipoOpDesemb) AND MOVS.Fecha = Var_FechaHoy;
				
		INSERT INTO TMP_BANCLIENTESATEN(ClienteID, 	NumTransaccion)
			SELECT DISTINCT(ClienteID),				Aud_NumTransaccion
				FROM CLIENTES CLI
				INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.PromotorID = CLI.PromotorInicial AND CAJ.NumTransaccion = Aud_NumTransaccion
				AND FechaAlta = Var_FechaHoy;
		
		SELECT COUNT(DISTINCT(ClienteID))
			INTO Var_ClientesAtend
			FROM TMP_BANCLIENTESATEN
			WHERE NumTransaccion = Aud_NumTransaccion;

		DELETE FROM TMP_BANCLIENTESATEN WHERE NumTransaccion = Aud_NumTransaccion;
		
		SET Var_CajaID := IFNULL(Var_CajaID, Entero_Cero);

		-- Total REcaudado
		-- Sumamos el Monto recibido por pagos y prepagos de Credito.
		SELECT SUM(MOVS.MontoEnFirme)
			INTO Var_TotalRecaud
			FROM CAJASMOVS MOVS
			INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.CajaID = MOVS.CajaID AND CAJ.NumTransaccion = Aud_NumTransaccion
			WHERE MOVS.TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre) AND MOVS.Fecha = Var_FechaHoy;

		-- Total Desembolsado
		-- Sumamos el Monto de desembolsos de Creditos.
		SELECT SUM(MOV.MontoEnFirme)
			INTO Var_TotalDesem
			FROM CAJASMOVS MOV
			WHERE TipoOperacion IN (TipoOpDesemb) AND Fecha = Var_FechaHoy
			AND MOV.CajaID = Var_CajaPrinID;
		
		
		-- Creditos con pagos exigibles
		-- Se crea la tabla temporal de creditos id
		-- Creditoscon Coutas exigibles
		DELETE FROM TMP_BANCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;
		
		INSERT INTO TMP_BANCREDITOS (CreditoID,			NumTransaccion)
			SELECT DISTINCT(CRE.CreditoID),				Aud_NumTransaccion
				FROM AMORTICREDITO AMO
				INNER JOIN CREDITOS CRE ON CRE.CreditoID = AMO.CreditoID
				INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
				INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.PromotorID = SOL.PromotorID AND CAJ.NumTransaccion = Aud_NumTransaccion
				WHERE AMO.FechaExigible <= Var_FechaHoy
				AND (AMO.Estatus <> Var_EstatusPagado OR (AMO.Estatus = Var_EstatusPagado AND FechaLiquida = Var_FechaHoy));
				
		
		SELECT 		SUM(BANFNEXIGIBLEALDIA(CreditoID))
			INTO 	Var_TotalExiDia
			FROM TMP_BANCREDITOS
			WHERE NumTransaccion = Aud_NumTransaccion;
			
		-- Creditos Atendidos
		DELETE FROM TMP_BANCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;

		INSERT INTO TMP_BANCREDITOS (CreditoID,		NumTransaccion)
			SELECT DISTINCT(MOVS.Instrumento),		Aud_NumTransaccion
				FROM CAJASMOVS MOVS
				INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.CajaID = MOVS.CajaID AND CAJ.NumTransaccion = Aud_NumTransaccion
				WHERE MOVS.TipoOperacion IN (TipoOpPagoCre, TipoOpPrePagoCre) 
				AND MOVS.Fecha = Var_FechaHoy;
		
		-- Consulta atrazados
		SELECT 		SUM(DET.MontoTotPago)
			INTO 	Var_PagosAtrazados
			FROM DETALLEPAGCRE DET
			INNER JOIN AMORTICREDITO AMOR ON AMOR.CreditoID = DET.CreditoID AND AMOR.AmortizacionID = DET.AmortizacionID
			INNER JOIN TMP_BANCREDITOS CATE ON CATE.CreditoID = AMOR.CreditoID AND CATE.NumTransaccion = Aud_NumTransaccion
			INNER JOIN CREDITOS CRE ON CRE.CreditoID = DET.CreditoID
			INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
			INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.PromotorID = SOL.PromotorID AND CAJ.NumTransaccion = Aud_NumTransaccion
			WHERE DET.FechaPago = Var_FechaHoy 
			AND AMOR.FechaExigible < Var_FechaHoy;
			
		-- adelantados
		SELECT 		SUM(DET.MontoTotPago)
			INTO 	Var_PagosAdel
			FROM DETALLEPAGCRE DET
			INNER JOIN AMORTICREDITO AMOR ON AMOR.CreditoID = DET.CreditoID AND AMOR.AmortizacionID = DET.AmortizacionID
			INNER JOIN TMP_BANCREDITOS CATE ON CATE.CreditoID = AMOR.CreditoID AND CATE.NumTransaccion = Aud_NumTransaccion
			INNER JOIN CREDITOS CRE ON CRE.CreditoID = DET.CreditoID
			INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
			INNER JOIN TMP_BANCAJEROS CAJ ON CAJ.PromotorID = SOL.PromotorID AND CAJ.NumTransaccion = Aud_NumTransaccion
			WHERE DET.FechaPago = Var_FechaHoy 
			AND AMOR.FechaExigible > Var_FechaHoy;
		
		SET Var_PagosAtrazados := IFNULL(Var_PagosAtrazados, Entero_Cero);
		SET Var_TotalRecaud := IFNULL(Var_TotalRecaud, Entero_Cero);
		SET Var_TotalExiDia := IFNULL(Var_TotalExiDia, Entero_Cero);
		SET Var_PagosAdel	:= IFNULL(Var_PagosAdel, Entero_Cero);
		SET Var_ClientesAtend := IFNULL(Var_ClientesAtend, Entero_Cero);
		SET Var_SumaTotal := (Var_PagosAdel + Var_PagosAtrazados + Var_TotalExiDia);
		IF(Var_SumaTotal > Entero_Cero && Var_TotalRecaud > Entero_Cero) THEN
			SET Var_PorRec := ROUND(Var_SumaTotal / Var_TotalRecaud, 2);
		END IF;
		SET Var_PorRec := IFNULL(Var_PorRec, Entero_Cero);
		SET Var_TotalDesem := IFNULL(Var_TotalDesem, Entero_Cero);

		DELETE FROM TMP_BANCAJEROS WHERE NumTransaccion = Aud_NumTransaccion;
		DELETE FROM TMP_BANCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;

		-- Devolvemos el resultado
		SELECT	Var_CajaID AS CajaID, Var_PagosAdel AS PagosAnticipados, Var_PagosAtrazados AS PagosAtrazados,	Var_TotalExiDia AS TotalPagosExi, Var_TotalDesemb AS CantCredOtorg,
				Var_TotalRecaud AS MontoTotRec, Var_PorRec AS PorcentRec, Var_ClientesAtend AS ClientesAtend, 	Var_TotalDesem AS MontoTotDes;
	END IF;
END TerminaStore$$
