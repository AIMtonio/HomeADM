-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOSANTICIPADOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOSANTICIPADOSREP`;

DELIMITER $$
CREATE PROCEDURE `PAGOSANTICIPADOSREP`(
	-- REPORTE QUE MUESTRA LOS PAGOS ANTICIPADOS QUE HA RECIBIDO LA CARTERA TRADICIONAL Y AGRO
	-- Modulo Cartera Agro
	Par_FechaInicio				DATE, 				# Fecha de inicio
	Par_FechaFinal				DATE, 				# Fecha final
	Par_TipoReporte				TINYINT UNSIGNED,	# Indica el Tipo de Reporte 1: Cartera Tradicional   2: Cartera Agro

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(60),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Cons_NO				CHAR(1);
	DECLARE Cons_SI				CHAR(1);
	DECLARE Est_Inactivo		CHAR(1);
	DECLARE Est_Procesado		CHAR(1);
	DECLARE Con_Principal		INT(11);
	DECLARE Con_CreditosAgro	INT(11);

	-- Asignacion  de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Entero_Cero			:= 0;				-- Entero Cero
	SET	Decimal_Cero		:= 0.0;				-- Decimal Cero
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Cons_NO				:= 'N';				-- Constante: NO
	SET Cons_SI				:= 'S';				-- Constante: SI
	SET Est_Inactivo		:= 'I';				-- Estatus: Inactivo
	SET Est_Procesado		:= 'P';				--
	SET	Con_Principal		:= 1;				-- Reporte: Detalle de Pagos de Creditos Activos
	SET Con_CreditosAgro	:= 2;				-- Reporte: Detalle de Pagos de Creditos Activos Agropecuarios
	SET Aud_FechaActual 	:= NOW();

	-- Tabla que almancena los datos de la Cartera Tradicional y Agro
	DROP TABLE IF EXISTS TMPPAGOSANTICREP;
	CREATE TEMPORARY TABLE TMPPAGOSANTICREP(
	ClienteID		INT(11),				-- Numero de Cliente
	NombreCliente	VARCHAR(200),			-- Nombre Completo del Cliente
	TipoCredito		VARCHAR(50),			-- Tipo de Credito: Activo/Activo Residual/ Activo Contingente
	CreditoID       BIGINT(12),     		-- Numero de Credito
	SucursalID      INT(11),        		-- Numero de Sucursal

	NombreSucursal  VARCHAR(50),    		-- Nombre de la Sucursal
	TipoFondeo		CHAR(1),				-- Tipo de Fondeo: Recursos Propios o Fondeador,
	InstitFondeoID	INT(11),				-- ID de la Institucion de Fondeo
	NombreInstitFon	VARCHAR(200),			-- Nombre de la Institucion de Fondeo
	CreditoPasivoID	BIGINT(20),				-- Numero del Credito Pasivo

	CreditoFondeoID	BIGINT(20),				-- Numero del Credito que maneja el Fondeador
	AmortizacionID	INT(11),				-- Numero de Amortizacion
	FechaVencim     DATE,          		 	-- Fecha de Vencimiento de la cuota que recibió el pago
	FechaDeposito   DATE,           		-- Fecha en que se realizó el depósito de efectivo a la cuenta eje
	FechaAplicacion DATE,           		-- Fecha en que se realizó la aplicación del pago al crédito.

	DiasDepAplica   INT(11),        		-- Dias transcurridos entre la fecha de depósito y la fecha de aplicación
	Capital         DECIMAL(14,2),			-- Monto de Capital pagado
	InteresOrd      DECIMAL(14,2),  		-- Monto de Interes Ordinario pagado
	InteresMoratorio DECIMAL(14,2),  		-- Interés Moratorio pagado.
	IVA             DECIMAL(14,2),  		-- IVA Total Pagado

	TotalPagado     DECIMAL(14,2),			-- Suma de las Columnas Capital + InteresOrd + InteresMoratorio + IVA
	FechaPagoFondeo	DATE,					-- Fecha de Pago a la Fuente de Fondeo,
	DiasPagoFondeo	INT(11),				-- Dias Trascurridos entre el Pago del Credito Activo con el Pasivo
	MontoPagoFondeo	DECIMAL(14,2),			-- Monto Total que se le Paga al Fondeador
	FolioPagoActivo	BIGINT(20),				-- Numero de Transaccion correspondiente al Pago del Credito Activo
	EsContingente	CHAR(1),				-- Indica si el credito es contingente

	NotasCargo		DECIMAL(14,2),			-- Monto de Notas de Cargo pagado
	IvaNotasCargo	DECIMAL(14,2),			-- Monto de IVA de Notas de Cargo pagado

	INDEX TMPPAGOSANTICREP_idx1(ClienteID),
	INDEX TMPPAGOSANTICREP_idx2(CreditoID),
	INDEX TMPPAGOSANTICREP_idx3(SucursalID),
	INDEX TMPPAGOSANTICREP_idx4(AmortizacionID),
	INDEX TMPPAGOSANTICREP_idx5(FechaAplicacion) );

	-- SECCION PARA OBTENER LOS PAGOS ANTICIPADOS DE LA CARTERA TRADICIONAL
	IF(Par_TipoReporte = Con_Principal) THEN

		INSERT INTO TMPPAGOSANTICREP(
		ClienteID,			NombreCliente,		CreditoID,			SucursalID,			TipoFondeo,
		InstitFondeoID,		AmortizacionID,		FechaVencim,		FechaDeposito,		FechaAplicacion,
		Capital,			InteresOrd,			InteresMoratorio,	IVA,				TotalPagado,
		NotasCargo,			IvaNotasCargo)

		SELECT MAX(Cre.ClienteID),			MAX(Cli.NombreCompleto),	MAX(Det.CreditoID),		MAX(Cre.SucursalID),	MAX(Cre.TipoFondeo),
				MAX(Cre.InstitFondeoID),	MAX(Amo.AmortizacionID),	MAX(Amo.FechaExigible),	MAX(Det.FechaPago),		MAX(Det.FechaPago),
				SUM(Det.MontoCapOrd),       SUM(Det.MontoIntOrd),		SUM(Det.MontoIntMora),	SUM(Det.MontoIVA),		SUM(Det.MontoTotPago),
				SUM(Det.MontoNotasCargo),	SUM(Det.MontoIVANotasCargo)
		 FROM 	DETALLEPAGCRE Det
		INNER JOIN AMORTICREDITO Amo
			ON	Det.CreditoID 		= Amo.CreditoID
			AND Det.AmortizacionID	= Amo.AmortizacionID
		INNER JOIN CREDITOS Cre
			ON 	Det.CreditoID 	= Cre.CreditoID
			AND Amo.CreditoID 	= Cre.CreditoID
		INNER JOIN CLIENTES Cli
			ON	Det.ClienteID 	= Cli.ClienteID
			AND Amo.ClienteID	= Cli.ClienteID
			AND Cre.ClienteID 	= Cli.ClienteID
		WHERE (Det.FechaPago >= Par_FechaInicio AND Det.FechaPago <= Par_FechaFinal)
		AND	Det.FechaPago < Amo.FechaExigible
		AND Cre.EsAgropecuario = Cons_NO
		GROUP BY Det.CreditoID, Det.FechaPago;

		-- SE ACTUALIZA EL NOMBRE DE LA SUCURSAL
		UPDATE TMPPAGOSANTICREP T
		INNER JOIN SUCURSALES S
		ON T.SucursalID = S.SucursalID
		SET NombreSucursal = S.NombreSucurs;

		-- SE ACTUALIZA EL NOMBRE DE LA INSTITUCION DE FONDEO
		UPDATE TMPPAGOSANTICREP T
		INNER JOIN INSTITUTFONDEO I
		ON T.InstitFondeoID = I.InstitutFondID
		SET T.NombreInstitFon = I.NombreInstitFon;

		-- SE ACTUALIZAN LAS FECHAS DE DEPOSITO
		UPDATE TMPPAGOSANTICREP T
		INNER JOIN DEPOSITOREFERE D
		ON T.CreditoID = D.ReferenciaMov
		AND T.TotalPagado = D.MontoMov
		SET FechaDeposito = D.FechaAplica;

		-- RESULTADO FINAL PARA REPORTE
		SELECT	ClienteID,		NombreCliente,		CreditoID, 			NombreSucursal,		NombreInstitFon,
				FechaVencim,	FechaDeposito,		FechaAplicacion,	DATEDIFF(FechaAplicacion,FechaDeposito) AS DiasDepAplica,
				Capital,		InteresOrd,			InteresMoratorio,	IVA,				TotalPagado,
				NotasCargo,		IvaNotasCargo
				FROM TMPPAGOSANTICREP;

		DROP TABLE IF EXISTS TMPPAGOSANTICREP;
	END IF;

		-- SECCION PARA OBTENER LOS PAGOS ANTICIPADOS DE LA CARTERA TRADICIONAL
	IF(Par_TipoReporte = Con_CreditosAgro) THEN
		-- Tabla que almancena los datos de la Cartera Tradicional y Agro
		DROP TABLE IF EXISTS TMPPAGOCREDPASIVOSREP;
		CREATE TEMPORARY TABLE TMPPAGOCREDPASIVOSREP(

		CreditoPasivoID	BIGINT(20),				-- Numero del Credito Pasivo
		CreditoID       BIGINT(12),     		-- Numero de Credito
		MontoPagoFondeo	DECIMAL(14,2),			-- Monto Total que se le Paga al Fondeador
		FechaPago		DATE,           		-- Fecha en que se realizó la aplicacion del pago
		FolioPagoActivo	BIGINT(20),				-- Numero de Transaccion correspondiente al Pago del Credito Activo

		INDEX TMPPAGOCREDPASIVOSREP_idx1(CreditoPasivoID),
		INDEX TMPPAGOCREDPASIVOSREP_idx2(CreditoID) );

		-- SE INSERTAN LOS CREDITOS AGRO
		INSERT INTO TMPPAGOSANTICREP(
			ClienteID,			NombreCliente,		TipoCredito,		CreditoID,			SucursalID,
			TipoFondeo,			InstitFondeoID,		CreditoFondeoID,	AmortizacionID,     FechaVencim,
			FechaDeposito,		FechaAplicacion,	Capital,			InteresOrd,			InteresMoratorio,
			IVA,				TotalPagado,		FolioPagoActivo,	EsContingente)

		SELECT
			MAX(Cre.ClienteID),		MAX(Cli.NombreCompleto),	CASE WHEN(MAX(Cre.EstatusGarantiaFIRA) = 'I') THEN 'Activo'
																	 WHEN (MAX(Cre.EstatusGarantiaFIRA) = 'P') THEN 'Activo Residual'
																	 ELSE 'Activo'
																END,
			Det.CreditoID,			MAX(Cre.SucursalID),		MAX(Cre.TipoFondeo),	MAX(Cre.InstitFondeoID),	MAX(Cre.CreditoIDFIRA),
			Det.AmortizacionID,		MAX(Amo.FechaExigible),		MAX(Det.FechaPago),		Det.FechaPago,				SUM(Det.MontoCapOrd),
			SUM(Det.MontoIntOrd),	SUM(Det.MontoIntMora),		SUM(Det.MontoIVA),		SUM(Det.MontoTotPago),		Det.Transaccion,
			Cons_NO
		 FROM 	DETALLEPAGCRE Det
			INNER JOIN AMORTICREDITO Amo
				ON	Det.CreditoID 		= Amo.CreditoID
				AND Det.AmortizacionID	= Amo.AmortizacionID
			INNER JOIN CREDITOS Cre
				ON 	Det.CreditoID 	= Cre.CreditoID
				AND Amo.CreditoID 	= Cre.CreditoID
			INNER JOIN CLIENTES Cli
				ON	Det.ClienteID 	= Cli.ClienteID
				AND Amo.ClienteID	= Cli.ClienteID
				AND Cre.ClienteID 	= Cli.ClienteID
			WHERE (Det.FechaPago >= Par_FechaInicio AND Det.FechaPago <= Par_FechaFinal)
			AND	Det.FechaPago < Amo.FechaExigible
			AND Cre.EsAgropecuario = Cons_SI
			GROUP BY Det.CreditoID, Det.FechaPago, Det.Transaccion, Det.AmortizacionID;

		-- SE INSERTAN LOS CREDITOS CONTINGENTES
		INSERT INTO TMPPAGOSANTICREP(
			ClienteID,			NombreCliente,		TipoCredito,		CreditoID,			SucursalID,
			TipoFondeo,			InstitFondeoID,		AmortizacionID,		FechaVencim,		FechaDeposito,
			FechaAplicacion,	Capital,			InteresOrd,			InteresMoratorio,	IVA,
			TotalPagado,		FolioPagoActivo,	CreditoPasivoID,	EsContingente)

		SELECT
			MAX(Cre.ClienteID),			MAX(Cli.NombreCompleto),	'Activo Contingente',		Det.CreditoID,				MAX(Cre.SucursalID),
			MAX(Cre.TipoFondeo),		MAX(Cre.InstitFondeoID),	Det.AmortizacionID,			MAX(Amo.FechaExigible),		MAX(Det.FechaPago),
			Det.FechaPago,				SUM(Det.MontoCapOrd),		SUM(Det.MontoIntOrd),		SUM(Det.MontoIntMora),		SUM(Det.MontoIVA),
			SUM(Det.MontoTotPago),		Det.Transaccion,			MAX(Cre.CreditoFondeoID),	Cons_SI
		 FROM 	DETALLEPAGCRECONT Det
			INNER JOIN AMORTICREDITOCONT Amo
				ON	Det.CreditoID 		= Amo.CreditoID
				AND Det.AmortizacionID	= Amo.AmortizacionID
			INNER JOIN CREDITOSCONT Cre
				ON 	Det.CreditoID 	= Cre.CreditoID
				AND Amo.CreditoID 	= Cre.CreditoID
			INNER JOIN CLIENTES Cli
				ON	Det.ClienteID 	= Cli.ClienteID
				AND Amo.ClienteID	= Cli.ClienteID
				AND Cre.ClienteID 	= Cli.ClienteID
			WHERE (Det.FechaPago >= Par_FechaInicio AND Det.FechaPago <= Par_FechaFinal)
			AND	Det.FechaPago < Amo.FechaExigible
			GROUP BY Det.CreditoID, Det.FechaPago, Det.Transaccion, Det.AmortizacionID;

		-- SE ACTUALIZA EL NOMBRE DE LA SUCURSAL
		UPDATE TMPPAGOSANTICREP T
		INNER JOIN SUCURSALES S
		ON T.SucursalID = S.SucursalID
		SET NombreSucursal = S.NombreSucurs;

		-- SE ACTUALIZA EL NOMBRE DE LA INSTITUCION DE FONDEO
		UPDATE TMPPAGOSANTICREP T
		INNER JOIN INSTITUTFONDEO I
		ON T.InstitFondeoID = I.InstitutFondID
		SET T.NombreInstitFon = I.NombreInstitFon;

		-- SE ACTUALIZAN LAS FECHAS DE DEPOSITO
		UPDATE TMPPAGOSANTICREP T
		INNER JOIN DEPOSITOREFERE D
		ON T.CreditoID = D.ReferenciaMov
		SET FechaDeposito = D.FechaAplica
        WHERE D.Status = 'A' AND T.TotalPagado = D.MontoMov AND TipoCanal = 1 ;

		-- SE ACTUALIZA EL NUMERO DEL CREDITO PASIVO
		UPDATE TMPPAGOSANTICREP T
		INNER JOIN RELCREDPASIVOAGRO R
		ON T.CreditoID = R.CreditoID
		AND IFNULL(T.EsContingente, Cons_NO) <> Cons_SI
		SET T.CreditoPasivoID = R.CreditoFondeoID;

		-- SE INSERTAN LOS PAGOS QUE HA TENIDO UN CREDITO PASIVO
		INSERT INTO TMPPAGOCREDPASIVOSREP(
				CreditoPasivoID,		CreditoID,										MontoPagoFondeo,
				FechaPago,				FolioPagoActivo)
		SELECT	Det.CreditoFondeoID,	IFNULL(MAX(Det.CreditoID), Entero_Cero),		SUM(Det.MontoTotPago),
				Det.FechaPago,			IFNULL(Det.FolioPagoActivo, Entero_Cero)
		FROM 	DETALLEPAGFON Det
		WHERE Det.FechaPago BETWEEN Par_FechaInicio AND Par_FechaFinal
		  AND Det.CreditoFondeoID IN (SELECT CreditoPasivoID FROM TMPPAGOSANTICREP GROUP BY CreditoPasivoID)
		  AND IFNULL(FolioPagoActivo, Entero_Cero) <> Entero_Cero
		GROUP BY Det.CreditoFondeoID, Det.FechaPago, Det.FolioPagoActivo;

		UPDATE TMPPAGOSANTICREP T1
		INNER JOIN TMPPAGOCREDPASIVOSREP T2
		ON T1.CreditoID = T2.CreditoID
		AND T1.CreditoPasivoID = T2.CreditoPasivoID
		AND T1.FolioPagoActivo = T2.FolioPagoActivo
		SET T1.FechaPagoFondeo = T2.FechaPago,
			T1.MontoPagoFondeo = T2.MontoPagoFondeo;

		SELECT
		ClienteID,			NombreCliente,		TipoCredito,		CreditoID,		NombreSucursal,
		NombreInstitFon,	IFNULL(CreditoPasivoID,Entero_Cero) AS CreditoPasivoID,	CreditoFondeoID,
		FechaVencim,		FechaDeposito,		FechaAplicacion,	DATEDIFF(FechaAplicacion, FechaDeposito) AS DiasDepAplica,
		Capital,			InteresOrd,			InteresMoratorio,	IVA,			TotalPagado,
		IFNULL(FechaPagoFondeo, Fecha_Vacia) AS FechaPagoFondeo,	IFNULL(DATEDIFF(FechaPagoFondeo, FechaAplicacion), Entero_Cero) AS DiasPagoFondeo,
		IFNULL(MontoPagoFondeo, Decimal_Cero) AS MontoPagoFondeo
		FROM TMPPAGOSANTICREP;

		DROP TABLE IF EXISTS TMPPAGOSANTICREP;
	END IF;


END TerminaStore$$
