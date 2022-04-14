-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERCRED099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAHEADERCRED099PRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAHEADERCRED099PRO`(
	-- SP PARA OBTENER LOS DATOS DEL CLIENTE
	Par_AnioMes    		 	 	 	 	INT(11),					-- Anio y Mes Estado Cuenta
	Par_IniMes							DATE,						-- Fecha Inicio Mes
	Par_FinMes							DATE						-- Fecha Fin Mes
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);					-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;						-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);					-- Entero Cero
	DECLARE	Moneda_Cero					INT(11);					-- Decimal Cero
	DECLARE NoProcesado					INT(11);					-- Numero Proceso: 1

	DECLARE NoEsInversion				CHAR(1);					-- Cuenta no es inversion: N
	DECLARE EsInversion					CHAR(1);					-- Cuenta es inversion: S
	DECLARE EstatusActiva				CHAR(1);					-- Estatus de la cuenta: ACTIVA
	DECLARE EstatusCancelado			CHAR(1);					-- Estatus de la cuenta: CANCELADA
	DECLARE EstatusBloqueado			CHAR(1);					-- Estatus de la cuenta: BLOQUEADA
	DECLARE EstatusInactiva				CHAR(1);					-- Estatus de la cuenta: INACTIVA
	DECLARE EstatusAtrasado				CHAR(1);					-- Estatus Atrasado
	DECLARE EstatusRegistrada			CHAR(1);					-- Estatus de la cuenta: REGISTRADA


	DECLARE Con_StaVigente				CHAR(1);					-- Estatus de la inversion: VIGENTE
	DECLARE Con_StaVencido				CHAR(1);					-- Estatus de la inversion: VENCIDO
	DECLARE Con_StaPagado				CHAR(1);					-- Estatus de la inversion: PAGADO
	DECLARE Con_StaCancelado			CHAR(1);					-- Estatus de la inversion: CANCELADO

	DECLARE EstatusVigente				CHAR(1);					-- Mes anterior a la fecha
	DECLARE EstatusVencido				CHAR(1);					-- Mes anterior a la fecha
	DECLARE EstatusCastigado 			CHAR(1);					-- Mes anterior a la fecha
	DECLARE EstatusPagado 				CHAR(1);					-- Mes anterior a la fecha

	DECLARE LeyendaPagado				VARCHAR(50);				-- Leyenda Pagado
	DECLARE Var_TipCobTasaFija			CHAR(1);					-- Tipo de cobro de comision de mora - Tasa Fija
	DECLARE Var_TipCobFacMora			CHAR(1);					-- Tipo de cobro de comision de mora - N veces factor mora

	-- DECLARACION DE VARIABLES
	DECLARE Var_FechaCorteIni			DATE;
	DECLARE Var_FechaActual				DATETIME;
	DECLARE Var_Contador				INT(11);
	DECLARE Var_TotalRegistros			INT(11);
	DECLARE Var_CreditoID				BIGINT(20);
	DECLARE Var_ClienteID				INT(11);
	DECLARE Var_CapitalApagar			DECIMAL(18,2);
	DECLARE Var_InteresNormalApagar		DECIMAL(18,2);
	DECLARE Var_IvaInteresNomalApagar	DECIMAL(18,2);
	DECLARE Var_OtrosCargosApagar		DECIMAL(18,2);
	DECLARE Var_IvaOtrosCargosApagar	DECIMAL(18,2);
	DECLARE Var_Moratorios				DECIMAL(18,2);
	DECLARE Var_IVAMoratorios			DECIMAL(18,2);
	DECLARE Var_CuoMontoAccesorio		DECIMAL(18,2);
	DECLARE Var_CuoIVAAccesorio			DECIMAL(18,2);
	DECLARE Var_ValorIvaCred			DECIMAL(14,2);

	DECLARE Entero_Uno					INT(11);
	DECLARE DireccionIPVacia			VARCHAR(50);

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';						-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';			-- Fecha Vacia
	SET Entero_Cero						:= 0;						-- Entero Cero
	SET Moneda_Cero						:= 0.00;					-- Decimal Cero
	SET NoProcesado						:= 1; 						-- Numero Proceso: 1

	SET NoEsInversion					:= 'N';						-- No es cuenta de inversion
	SET EsInversion						:= 'S';						-- Es una cuenta de inversion
	SET EstatusActiva					:= 'A';						-- Estatus de la cuenta: ACTIVA
	SET EstatusCancelado				:= 'C';						-- Estatus de la cuenta: CANCELADA
	SET EstatusBloqueado				:= 'B';						-- Estatus de la cuenta: BLOQUEADA
	SET EstatusInactiva					:= 'I';						-- Estatus de la cuenta: INACTIVA
	SET EstatusRegistrada				:= 'R';						-- Estatus de la cuenta: REGISTRADA

	SET Con_StaVigente					:= 'N';						-- Estatus de la inversion: VIGENTE
	SET Con_StaVencido    				:= 'V';						-- Estatus de la inversion: VENCIDO
	SET Con_StaPagado					:= 'P';						-- Estatus de la inversion: PAGADO
	SET Con_StaCancelado				:= 'C';						-- Estatus de la inversion: CANCELADO

	SET EstatusVigente					:= 'V';						-- Estatus Credito: VIGENTE
	SET EstatusVencido					:= 'B';						-- Estatus Credito: VENCIDO
	SET EstatusCastigado 				:= 'K';						-- Estatus Credito: CASTIGADO
	SET EstatusPagado 					:= 'P';						-- Estatus Credito: PAGADO
	SET EstatusAtrasado					:= 'A';						-- Estatus Credito: ATRASADO

	SET LeyendaPagado					:= 'PAGADO';				-- Leyenda Pagado
	SET Var_TipCobTasaFija				:= 'T';						-- Tipo de cobro de comision de mora - Tasa Fija
	SET Var_TipCobFacMora				:= 'N';						-- Tipo de cobro de comision de mora - N veces factor mora

	SET Entero_Uno						:= 1;
	SET DireccionIPVacia				:= "127.0.0.1";

		-- SE CREA TABLA TEMPORAL PARA OBTENER LOS CREDITOS DEL CLIENTE YA OBTENIDOS
		DROP TABLE IF EXISTS TMPEDOCTARESUMCREDITOSSIMP;
		CREATE TEMPORARY TABLE TMPEDOCTARESUMCREDITOSSIMP (
			`ClienteID`					INT(11),
			`CreditoID`					BIGINT(12),
			`Producto`					VARCHAR(100),
			`SaldoInsoluto`				DECIMAL(14,2),
			`MontoProximoPago`			DECIMAL(14,2),
			`FechaLeyenda`				VARCHAR(50),
			`ValorIvaCred`				DECIMAL(14,2)
		);

		CREATE INDEX IDX_TMPEDOCTARESUMCREDITOSSIMP_CLIENTE USING BTREE ON TMPEDOCTARESUMCREDITOSSIMP (ClienteID);
		CREATE INDEX IDX_TMPEDOCTARESUMCREDITOSSIMP_CREDITO USING BTREE ON TMPEDOCTARESUMCREDITOSSIMP (CreditoID);

		INSERT INTO TMPEDOCTARESUMCREDITOSSIMP(
												ClienteID,		CreditoID,		Producto,		SaldoInsoluto,		MontoProximoPago,
												FechaLeyenda,	ValorIvaCred
		)SELECT
												ClienteID,		CreditoID,		Producto,		SaldoInsoluto,		MontoProximoPago,
												FechaLeyenda,	ValorIvaCred
		FROM	EDOCTARESUM099CREDITOS;

		-- SE CREA LA TABLA TEMPORAL PARA AGREGAR LOS DATOS DE EXTRACCION
		DROP TABLE IF EXISTS TMPEDOCTAHEADERCRED;
		CREATE TABLE `TMPEDOCTAHEADERCRED` (
			`AnioMes`				INT(11),					-- AnioMes
			`CreditoID`				BIGINT(20),					-- simple.CreditoID
			`ClienteID`				INT(11),					-- simple.ClienteID
			`NombreProducto`		VARCHAR(100),				-- simple.Producto
			`MontoOtorgado`			DECIMAL(14,2),   			-- cred.MontoCredito
			`FechaVencimiento`		DATE,						-- cred.FechaVencimien
			`SaldoInsoluto`			DECIMAL(14,2),				-- simple.SaldoInsoluto
			`SaldoInicial`			DECIMAL(14,2),				-- Saldo inicial del credito
			`Pagos`					VARCHAR(50),				-- Pagos
			`Cat`					DECIMAL(18,2),				-- cred.ValorCAT
			`TasaFija`				DECIMAL(18,2),				-- cred.TasaFija SI KUBO TRABAJA SOBRE TASA FIJA O TASA VARIABLE
			`TasaMoratoria`			DECIMAL(18,2),				-- TasaFija * FactorMora de creditos
			`IntPagadoPerido`		DECIMAL(18,2),				-- lo de abajo Interes
			`IvaIntPagadoPerido`	DECIMAL(18,2),				-- Suma de todo lo que traiga MontoIVA si no cobran comisiones.
			`TotalComisionesPagar`	DECIMAL(14,2),				-- Indica el total de comisiones a pagar
			`IvaComPagadoPeriodo`	DECIMAL(18,2),				-- Indica el IVA pagado por periodo
			`TotalPagar`			DECIMAL(14,2),				-- MontoProximoPago
			`CapitalApagar`			DECIMAL(14,2),				-- vacio
			`InteresNormalApagar`	DECIMAL(14,2),				-- vacio
			`IvaInteresNomalApagar`	DECIMAL(14,2),				-- vacio
			`OtrosCargosApagar`		DECIMAL(14,2),				-- vacio
			`IvaOtrosCargosApagar`	DECIMAL(14,2),				-- vacio
			`FechaProximoPago`		DATE,						-- Fecha del proximo pago
			`FechaProxPagoLeyenda`	VARCHAR(50),				-- Leyenda de fecha del proxio pago
			`ValorIvaCred`			DECIMAL(14,2),
			`Moratorios`			DECIMAL(14,2),				-- Moratorios a pagar
			`IVAMoratorios`			DECIMAL(14,2),				-- IVA de moratorios a pagar
			`SalMontoAccesorio`		DECIMAL(14,2),				-- Almacena el importe de los accesorios
			`SalIVAAccesorio`		DECIMAL(14,2),				-- Almacena el importe de IVA de los accesorios
			`CuoMontoAccesorio`		DECIMAL(14,2),				-- Almacena la cuota de los accesorios
			`CuoIVAAccesorio`		DECIMAL(14,2),				-- Almacena el IVA de los accesorios
			`LitrosMeta` 			DECIMAL(14,2),  			-- Litros Consumidos del Vehiculo
			`TotalLitros` 			DECIMAL(14,2),  			-- Total de litros
			`LitConsumidos` 		DECIMAL(14,2) 				-- Consumo total de litros en un periodo
		);
		CREATE INDEX IDX_TMPEDOCTAHEADERCRED_ANIOMES USING BTREE ON TMPEDOCTAHEADERCRED (AnioMes);
		CREATE INDEX IDX_TMPEDOCTAHEADERCRED_CLIENTE USING BTREE ON TMPEDOCTAHEADERCRED (ClienteID);

		INSERT INTO TMPEDOCTAHEADERCRED
		SELECT
				Par_AnioMes,						-- AnioMes
				TmpEdoResCred.CreditoID,			-- CreditoID
				TmpEdoResCred.ClienteID,			-- ClienteID
				TmpEdoResCred.Producto,				-- NombreProducto
				cred.MontoCredito,					-- MontoOtorgado
				cred.FechaVencimien,				-- FechaVencimiento
				TmpEdoResCred.SaldoInsoluto,		-- SaldoInsoluto
				Moneda_Cero,						-- SaldoInicial
				Cadena_Vacia,						-- Pagos
				IFNULL(cred.ValorCAT, Moneda_Cero),	-- Cat
				cred.TasaFija,						-- TasaFija
				CASE cred.TipCobComMorato WHEN Var_TipCobTasaFija THEN cred.FactorMora ELSE cred.TasaFija * cred.FactorMora END,	-- TasaMoratoria
				Moneda_Cero,						-- IntPagadoPerido
				Moneda_Cero,						-- IvaIntPagadoPerido
				Moneda_Cero,						-- TotalComisionesPagar
				Moneda_Cero,						-- IvaComPagadoPeriodo
				TmpEdoResCred.MontoProximoPago,		-- TotalPagar
				Moneda_Cero, 						-- CapitalApagar
				Moneda_Cero,						-- InteresNormalApagar
				Moneda_Cero,						-- IvaInteresNomalApagar
				Moneda_Cero,						-- OtrosCargosApagar
				Moneda_Cero,						-- IvaOtrosCargosApagar
				Fecha_Vacia,						-- FechaProximoPago
				TmpEdoResCred.FechaLeyenda,			-- FechaProxPagoLeyenda
				TmpEdoResCred.ValorIvaCred,
				Moneda_Cero,
				Moneda_Cero,
				Moneda_Cero,						-- importe de los accesorios
				Moneda_Cero,						-- importe de IVA de los accesorios
				Moneda_Cero,						-- importe de cuota de los accesorios
				Moneda_Cero,						-- importe de IVA de la cuota de los accesorios
				Entero_Cero,						-- Litros Consumidos del Vehiculo
				Entero_Cero,						-- Total de litros
				Entero_Cero							-- Consumo total de litros en un periodo
		FROM CREDITOS cred
		INNER JOIN  TMPEDOCTARESUMCREDITOSSIMP TmpEdoResCred  ON TmpEdoResCred.CreditoID = cred.CreditoID
															  AND TmpEdoResCred.ClienteID = cred.ClienteID
		WHERE Estatus IN (EstatusVigente, EstatusVencido, EstatusCastigado)
		OR (Estatus = EstatusPagado
				AND  FechTerminacion >= Par_IniMes
				AND  FechTerminacion <= Par_FinMes);


		DROP TABLE IF EXISTS TMP_EDOCTADETALLEPAGCRE;
		CREATE TABLE `TMP_EDOCTADETALLEPAGCRE` (
			`CreditoID`			BIGINT(12) NOT NULL COMMENT 'Id del Credito',
			`MontoIntOrd`		DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Ordinario',
			`MontoIntAtr`		DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Atrasado',
			`MontoIntVen`		DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Vencido',
			`MontoIntMora`		DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Mora',
			`MontoIVA`			DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado IVA',
			`MontoNotasCargo`	DECIMAL(14,2) DEFAULT 0.00 COMMENT 'Monto pagado por Notas de Cargo',
			`MontoIVANotasCargo` DECIMAL(14,2) DEFAULT 0.00 COMMENT 'Monto de IVA pagado por Notas de Cargo'
		);

		INSERT INTO TMP_EDOCTADETALLEPAGCRE
		SELECT	 CreditoID
				,SUM(MontoIntOrd) AS MontoIntOrd
				,SUM(MontoIntAtr) AS MontoIntAtr
				,SUM(MontoIntVen) AS MontoIntVen
				,SUM(MontoIntMora) AS MontoIntMora
				,SUM(MontoIVA) AS MontoIVA,
				SUM(MontoNotasCargo) AS MontoNotasCargo,
				SUM(MontoIVANotasCargo) AS MontoIVANotasCargo
		FROM DETALLEPAGCRE
		WHERE FechaPago >= Par_IniMes
		AND FechaPago <=  Par_FinMes
		GROUP BY CreditoID;

		UPDATE  TMPEDOCTAHEADERCRED Res, TMP_EDOCTADETALLEPAGCRE Tmp
		SET		Res.IntPagadoPerido		= ROUND((Tmp.MontoIntOrd + Tmp.MontoIntAtr + Tmp.MontoIntVen), 2),
				Res.IvaIntPagadoPerido	= ROUND(Tmp.MontoIVA, 2),
				Res.TotalComisionesPagar = IFNULL(Res.TotalComisionesPagar, Entero_Cero) + ROUND(Tmp.MontoNotasCargo, 2),
				Res.IvaComPagadoPeriodo = IFNULL(Res.IvaComPagadoPeriodo, Entero_Cero) + ROUND(Tmp.MontoIVANotasCargo, 2)
		WHERE Res.CreditoID = Tmp.CreditoID;


		DROP TABLE IF EXISTS TMPAMORTIZACIONESCRE;
		CREATE TABLE TMPAMORTIZACIONESCRE(
			CreditoID			BIGINT(12),
			TotalCuotas			INT,
			Cubiertas			INT(4),
			PorCubrir     		INT(4),
			CapitalCubierto		DECIMAL(14,2),
			PRIMARY KEY(CreditoID)
		);

		INSERT INTO TMPAMORTIZACIONESCRE(
			CreditoID,		TotalCuotas,		Cubiertas,		PorCubrir,		CapitalCubierto)
		SELECT cre.CreditoID
			,COUNT(amor.AmortizacionID)
			,SUM(CASE WHEN amor.Estatus= EstatusPagado THEN 1 ELSE 0 END)
			,SUM(CASE WHEN amor.Estatus <> EstatusPagado THEN 1 ELSE 0 END)
			,MAX(cre.MontoCredito) - SUM(CASE WHEN amor.Estatus <> 'P' THEN  (amor.SaldoCapVigente + amor.SaldoCapAtrasa + amor.SaldoCapVencido + amor.SaldoCapVenNExi) END)
		FROM CREDITOS cre
		INNER JOIN AMORTICREDITO amor ON cre.CreditoID = amor.CreditoID
		INNER JOIN TMPEDOCTAHEADERCRED TmpEdoHeader ON cre.CreditoID = TmpEdoHeader.CreditoID
		WHERE cre.Estatus IN (EstatusVigente, EstatusVencido)
		GROUP BY cre.CreditoID;


		UPDATE TMPEDOCTAHEADERCRED edo
		INNER JOIN TMPAMORTIZACIONESCRE tmp ON edo.CreditoID=tmp.CreditoID
			SET edo.Pagos = CONCAT(tmp.Cubiertas, ' DE ', tmp.TotalCuotas);


		-- Proceso para extraer el desglose del monto Atrasado

		DROP TABLE IF EXISTS TMPAMORTICREDITOHEADER;
		CREATE TEMPORARY TABLE TMPAMORTICREDITOHEADER (
				`ClienteID`				INT,
				`CreditoID`				BIGINT(12),
				`AmortizacionID`		INT,
				`CapitalApagar`			DECIMAL(14,2),
				`InteresNormalApagar`	DECIMAL(14,2),
				`IvaInteresNomalApagar`	DECIMAL(14,2),
				`OtrosCargosApagar`		DECIMAL(14,2),
				`IvaOtrosCargosApagar`	DECIMAL(14,2),
				`ValorIvaCred`			DECIMAL(14,2),
				`Moratorios`			DECIMAL(14,2),
				`IVAMoratorios`			DECIMAL(14,2),
				`CuoMontoAccesorio`		DECIMAL(14,2),				-- Almacena la cuota de los accesorios
				`CuoIVAAccesorio`		DECIMAL(14,2)				-- Almacena el IVA de los accesorios

		);
		CREATE INDEX IDX_TMPAMORTICREDITOHEADER_CREDITOID USING BTREE ON TMPAMORTICREDITOHEADER (CreditoID);
		CREATE INDEX IDX_TMPAMORTICREDITOHEADER_CLIENTEID USING BTREE ON TMPAMORTICREDITOHEADER (ClienteID);

		-- Se extrae todos los creditos que estan vivos
		INSERT INTO TMPAMORTICREDITOHEADER (
												ClienteID,				CreditoID,			AmortizacionID,			CapitalApagar,		InteresNormalApagar,
												IvaInteresNomalApagar,	OtrosCargosApagar,	IvaOtrosCargosApagar,	ValorIvaCred,		Moratorios,
												IVAMoratorios
		)
		SELECT 									ClienteID,				CreditoID,			Entero_Cero,			Moneda_Cero,		Moneda_Cero,
												Moneda_Cero,			Moneda_Cero,		Moneda_Cero,			ValorIvaCred,		Moneda_Cero,
												Moneda_Cero
		FROM TMPEDOCTAHEADERCRED
		WHERE FechaProxPagoLeyenda != LeyendaPagado;



		-- Creamos tabla para guardar las amortizaciones que no se pagaron en meses anteriores
		DROP TABLE IF EXISTS TMPAMORTICREPAGOHEADER;
		CREATE TABLE TMPAMORTICREPAGOHEADER (
				`RegistroID`			INT(11) NOT NULL,
				`ClienteID`				INT(11),
				`CreditoID`				BIGINT(12),
				`AmortizacionID`		INT(11),
				`Estatus`				CHAR(1),
				`SaldoCapVigente`		DECIMAL(14,2),
				`SaldoCapAtrasa` 		DECIMAL(14,2),
				`SaldoCapVencido`		DECIMAL(14,2),
				`SaldoCapVenNExi`		DECIMAL(14,2),
				`SaldoInteresOrd`		DECIMAL(14,2),
				`SaldoInteresAtr`		DECIMAL(14,2),
				`SaldoInteresVen`		DECIMAL(14,2),
				`SaldoInteresPro`		DECIMAL(14,2),
				`SaldoIntNoConta`		DECIMAL(14,2),
				`SaldoIVAInteres`		DECIMAL(14,2),
				`SaldoMoratorios`		DECIMAL(14,2),
				`SaldoIVAMorato` 		DECIMAL(14,2),
				`SaldoComFaltaPa`		DECIMAL(14,2),
				`SaldoIVAComFalP`		DECIMAL(14,2),
				`SaldoComServGar`		DECIMAL(14,2),
				`SaldoIVAComSerGar`		DECIMAL(14,2),
				`SaldoOtrasComis`		DECIMAL(14,2),
				`SaldoIVAComisi` 		DECIMAL(14,2),
				`SaldoNotCargoRev`		DECIMAL(14,2),
				`SaldoNotCargoSinIVA`	DECIMAL(14,2),
				`SaldoNotCargoConIVA`	DECIMAL(14,2),
				`ValorIvaCred`			DECIMAL(14,2),
				PRIMARY KEY(RegistroID),
				KEY INDEX_1(ClienteID),
				KEY INDEX_2(CreditoID)
		);

		SET @Var_Registro := Entero_Cero;

		INSERT INTO TMPAMORTICREPAGOHEADER(
										RegistroID,
										ClienteID,					CreditoID,						AmortizacionID,						Estatus,						SaldoCapVigente,
										SaldoCapAtrasa,				SaldoCapVencido,				SaldoCapVenNExi,					SaldoInteresOrd,				SaldoInteresAtr,
										SaldoInteresVen,			SaldoInteresPro,				SaldoIntNoConta,					SaldoIVAInteres,				SaldoMoratorios,
										SaldoIVAMorato,				SaldoComFaltaPa,				SaldoIVAComFalP,					SaldoComServGar,                SaldoIVAComSerGar,
										SaldoOtrasComis,			SaldoIVAComisi,                 SaldoNotCargoRev,			        SaldoNotCargoSinIVA,			SaldoNotCargoConIVA,
										ValorIvaCred
		)
		SELECT							(@Var_Registro := @Var_Registro + 1) AS RegistroID,
										AmorCred.ClienteID,			AmorCred.CreditoID,				AmorCred.AmortizacionID,			AmorCred.Estatus,				AmorCred.SaldoCapVigente,
										AmorCred.SaldoCapAtrasa,	AmorCred.SaldoCapVencido,		AmorCred.SaldoCapVenNExi,			AmorCred.SaldoInteresOrd,		AmorCred.SaldoInteresAtr,
										AmorCred.SaldoInteresVen,	AmorCred.SaldoInteresPro,		AmorCred.SaldoIntNoConta,			AmorCred.SaldoIVAInteres,		AmorCred.SaldoMoratorios,
										AmorCred.SaldoIVAMorato,	AmorCred.SaldoComFaltaPa,		AmorCred.SaldoIVAComFalP,           AmorCred.SaldoComServGar,       AmorCred.SaldoIVAComSerGar,
										AmorCred.SaldoOtrasComis,	AmorCred.SaldoIVAComisi,        AmorCred.SaldoNotCargoRev,	        AmorCred.SaldoNotCargoSinIVA,	AmorCred.SaldoNotCargoConIVA,
										TmpAmorCre.ValorIvaCred
		FROM AMORTICREDITO AmorCred INNER JOIN TMPAMORTICREDITOHEADER TmpAmorCre ON  AmorCred.ClienteID = TmpAmorCre.ClienteID
																		   AND   AmorCred.CreditoID = TmpAmorCre.CreditoID
		WHERE AmorCred.Estatus != EstatusPagado
		AND	AmorCred.Estatus IN (EstatusVencido,EstatusAtrasado,EstatusVigente)
		AND AmorCred.FechaExigible <= Par_FinMes;

		-- Obtenemos el maximo de los registros a iterar
		SET Var_TotalRegistros	:= (SELECT COUNT(*) FROM TMPAMORTICREPAGOHEADER);
		-- Inicializacion del contador para el ciclo
		SET Var_Contador		:= 1;

		-- Ciclo para iterar los registros
		WHILE(Var_Contador <= Var_TotalRegistros)DO
			SELECT	ClienteID,		CreditoID,		ValorIvaCred
			INTO	Var_ClienteID,	Var_CreditoID,	Var_ValorIvaCred
			FROM TMPAMORTICREPAGOHEADER
			WHERE RegistroID = Var_Contador;

			-- Validacion de datos nulos
			SET Var_ClienteID		:= IFNULL(Var_ClienteID, Entero_Cero);
			SET Var_CreditoID		:= IFNULL(Var_CreditoID, Entero_Cero);
			SET Var_ValorIvaCred	:= IFNULL(Var_ValorIvaCred, Entero_Cero);

			-- Capital a Pagar
			SELECT	SUM(TmpAmorPago.SaldoCapVencido + TmpAmorPago.SaldoCapVigente + TmpAmorPago.SaldoCapVenNExi + TmpAmorPago.SaldoCapAtrasa) AS CapitalApagar,
					SUM(TmpAmorPago.SaldoInteresVen + TmpAmorPago.SaldoInteresOrd + TmpAmorPago.SaldoInteresAtr + TmpAmorPago.SaldoInteresPro + TmpAmorPago.SaldoIntNoConta) AS InteresNormalApagar,
					SUM(TmpAmorPago.SaldoInteresVen + TmpAmorPago.SaldoInteresOrd + TmpAmorPago.SaldoInteresAtr + TmpAmorPago.SaldoInteresPro + TmpAmorPago.SaldoIntNoConta) * Var_ValorIvaCred AS IvaInteresNomalApagar,
					SUM(TmpAmorPago.SaldoComFaltaPa + TmpAmorPago.SaldoComServGar + TmpAmorPago.SaldoOtrasComis + TmpAmorPago.SaldoNotCargoRev + TmpAmorPago.SaldoNotCargoSinIVA + TmpAmorPago.SaldoNotCargoConIVA) AS OtrosCargosApagar,
					SUM(TmpAmorPago.SaldoComFaltaPa + TmpAmorPago.SaldoComServGar + TmpAmorPago.SaldoOtrasComis + TmpAmorPago.SaldoNotCargoConIVA) * Var_ValorIvaCred AS IvaOtrosCargosApagar,
					SUM(TmpAmorPago.SaldoMoratorios) AS Moratorios,
					SUM(TmpAmorPago.SaldoMoratorios) * Var_ValorIvaCred AS IVAMoratorios,
					SUM(TmpAmorPago.SaldoOtrasComis) AS CuoMontoAccesorio,
					SUM(TmpAmorPago.SaldoIVAComisi) AS CuoIVAAccesorio
			INTO	Var_CapitalApagar,	Var_InteresNormalApagar,	Var_IvaInteresNomalApagar,	Var_OtrosCargosApagar,	Var_IvaOtrosCargosApagar,
					Var_Moratorios,		Var_IVAMoratorios,			Var_CuoMontoAccesorio,		Var_CuoIVAAccesorio
			FROM TMPAMORTICREPAGOHEADER TmpAmorPago
			WHERE ClienteID = Var_ClienteID
				AND CreditoID = Var_CreditoID
			GROUP BY ClienteID, CreditoID;

			-- Validacion de datos nulos
			SET Var_CapitalApagar 			:= IFNULL(Var_CapitalApagar, Entero_Cero);
			SET Var_InteresNormalApagar		:= IFNULL(Var_InteresNormalApagar, Entero_Cero);
			SET Var_IvaInteresNomalApagar	:= IFNULL(Var_IvaInteresNomalApagar, Entero_Cero);
			SET Var_OtrosCargosApagar		:= IFNULL(Var_OtrosCargosApagar, Entero_Cero);
			SET Var_IvaOtrosCargosApagar	:= IFNULL(Var_IvaOtrosCargosApagar, Entero_Cero);
			SET Var_Moratorios				:= IFNULL(Var_Moratorios, Entero_Cero);
			SET Var_IVAMoratorios			:= IFNULL(Var_IVAMoratorios, Entero_Cero);
			SET Var_CuoMontoAccesorio		:= IFNULL(Var_CuoMontoAccesorio, Entero_Cero);
			SET Var_CuoIVAAccesorio			:= IFNULL(Var_CuoIVAAccesorio, Entero_Cero);

			-- Realizamos la actualizacion a la tabla
			UPDATE TMPAMORTICREDITOHEADER
				SET
					CapitalApagar			= Var_CapitalApagar,
					InteresNormalApagar		= Var_InteresNormalApagar,
					IvaInteresNomalApagar	= Var_IvaInteresNomalApagar,
					OtrosCargosApagar		= Var_OtrosCargosApagar,
					IvaOtrosCargosApagar	= Var_IvaOtrosCargosApagar,
					Moratorios				= Var_Moratorios,
					IVAMoratorios			= Var_IVAMoratorios,
					CuoMontoAccesorio		= Var_CuoMontoAccesorio,
					CuoIVAAccesorio			= Var_CuoIVAAccesorio
			WHERE ClienteID = Var_ClienteID
				AND CreditoID = Var_CreditoID;

			-- Inicializacion de variables
			SET Var_Contador 				:= Var_Contador + 1;
			SET Var_ClienteID				:= Entero_Cero;
			SET Var_CreditoID				:= Entero_Cero;
			SET Var_ValorIvaCred			:= Entero_Cero;
			SET Var_CapitalApagar			:= Entero_Cero;
			SET Var_InteresNormalApagar		:= Entero_Cero;
			SET Var_IvaInteresNomalApagar	:= Entero_Cero;
			SET Var_OtrosCargosApagar		:= Entero_Cero;
			SET Var_IvaOtrosCargosApagar	:= Entero_Cero;
			SET Var_Moratorios				:= Entero_Cero;
			SET Var_IVAMoratorios			:= Entero_Cero;
			SET Var_CuoMontoAccesorio		:= Entero_Cero;
			SET Var_CuoIVAAccesorio			:= Entero_Cero;
		END WHILE;

		/*Actualiza Cuota de accesorios e IVA accesorios*/
			UPDATE TMPEDOCTAHEADERCRED Edo
			INNER JOIN TMPAMORTICREDITOHEADER TmpMort ON Edo.CreditoID = TmpMort.CreditoID

				SET	Edo.CapitalApagar			= IFNULL(TmpMort.CapitalApagar, Moneda_Cero),
					Edo.InteresNormalApagar		= IFNULL(TmpMort.InteresNormalApagar, Moneda_Cero),
					Edo.IvaInteresNomalApagar	= IFNULL(TmpMort.IvaInteresNomalApagar, Moneda_Cero),
					Edo.OtrosCargosApagar		= IFNULL(TmpMort.OtrosCargosApagar, Moneda_Cero),
					Edo.IvaOtrosCargosApagar	= IFNULL(TmpMort.IvaOtrosCargosApagar, Moneda_Cero),
					Edo.Moratorios				= IFNULL(TmpMort.Moratorios, Moneda_Cero),
					Edo.IVAMoratorios			= IFNULL(TmpMort.IVAMoratorios, Moneda_Cero),

-- Actualiza CuoMontoAccesorio y CuoIVAAccesorio
					Edo.CuoMontoAccesorio		= IFNULL(TmpMort.CuoMontoAccesorio, Moneda_Cero),
					Edo.CuoIVAAccesorio			= IFNULL(TmpMort.CuoIVAAccesorio, Moneda_Cero);



		SET Var_FechaCorteIni := (SELECT MIN(FechaCorte)
				FROM SALDOSCREDITOS
				 WHERE FechaCorte >= Par_IniMes AND FechaCorte <= Par_FinMes);

		UPDATE TMPEDOCTAHEADERCRED Edo, SALDOSCREDITOS Sal
			SET Edo.SaldoInicial = IFNULL((Sal.SalCapVigente + Sal.SalCapatrasado +
												Sal.SalCapVencido + Sal.SalCapVenNoExi), Moneda_Cero)
		WHERE Sal.FechaCorte = Var_FechaCorteIni
		  AND Edo.CreditoID = Sal.CreditoID;


		/*Actualiza los importes de accesorios e IVA accesorios*/
		UPDATE TMPEDOCTAHEADERCRED Edo, SALDOSCREDITOS Sal
			SET Edo.SalMontoAccesorio	= IFNULL((Sal.SalMontoAccesorio), Moneda_Cero),
				Edo.SalIVAAccesorio		= IFNULL((Sal.SalIVAAccesorio), Moneda_Cero)
		WHERE Sal.FechaCorte = Var_FechaCorteIni
		  AND Edo.CreditoID = Sal.CreditoID;


		-- Limpiamos la tabla para posteriormente guardar los litros de los creditos.
		DELETE FROM EDOCTATMPCALCULOLITROS;
		INSERT INTO EDOCTATMPCALCULOLITROS(
			CreditoID,		Meta,								Total,											EmpresaID, 	Usuario,
			FechaActual, 	DireccionIP, 						ProgramaID, 									Sucursal,	NumTransaccion
		)
		SELECT
			INF.CreditoID,	IFNULL(AVG(INF.GNV), Entero_Cero),	IFNULL(SUM(INFWS.LitConsumidos), Entero_Cero), 	Entero_Uno, Entero_Uno,
			Fecha_Vacia,	DireccionIPVacia,					Entero_Uno,										Entero_Uno,	Entero_Uno
		FROM INFOADICIONALCRED AS INF
			INNER JOIN INFOADICIONALCREDWS AS INFWS ON  INFWS.CreditoID = INF.CreditoID
			GROUP BY INF.CreditoID;

		-- Limpiamos la tabla para posteriormente guardar los litros de los creditos.
		DELETE FROM EDOCTATMPLITROSCONSUMIDOS;
		INSERT INTO EDOCTATMPLITROSCONSUMIDOS(
			CreditoID,		Consumidos,										EmpresaID, 	Usuario,	FechaActual,
			DireccionIP, 	ProgramaID, 									Sucursal,	NumTransaccion
		)
		SELECT
			INFWS.CreditoID,	IFNULL(SUM(INFWS.LitConsumidos), Entero_Cero), 	Entero_Uno, Entero_Uno,	Fecha_Vacia,
			DireccionIPVacia,	Entero_Uno,									Entero_Uno,	Entero_Uno
		FROM INFOADICIONALCREDWS AS INFWS
			WHERE INFWS.Fecha BETWEEN Par_IniMes AND Par_FinMes
			GROUP BY INFWS.CreditoID;


		/*Actualizamos los LitrosMeta */
		UPDATE TMPEDOCTAHEADERCRED Edo, EDOCTATMPCALCULOLITROS CALIT
			SET Edo.LitrosMeta	= CALIT.Meta
		WHERE Edo.CreditoID = CALIT.CreditoID;

		/*Actualizamos los TotalLitros */
		UPDATE TMPEDOCTAHEADERCRED Edo, EDOCTATMPCALCULOLITROS CALIT
			SET Edo.TotalLitros	= CALIT.Total
		WHERE Edo.CreditoID = CALIT.CreditoID;

		/*Actualizamos los LitConsumidos */
		UPDATE TMPEDOCTAHEADERCRED Edo, EDOCTATMPLITROSCONSUMIDOS LITCON
			SET Edo.LitConsumidos	= LITCON.Consumidos
		WHERE Edo.CreditoID = LITCON.CreditoID;

		/*Se agrgan los campos correspondientes a los accesorios*/

		-- INSERTAMOS EN LA TABLA FINAL
		INSERT INTO EDOCTAHEADERCRED(
										AnioMes,			CreditoID,				ClienteID,				NombreProducto,
										MontoOtorgado,		FechaVencimiento,		SaldoInsoluto,			SaldoInicial,
										Pagos,				Cat,					TasaFija,				TasaMoratoria,
										IntPagadoPerido,	IvaIntPagadoPerido,		TotalComisionesPagar,	IvaComPagadoPeriodo,
										TotalPagar,			CapitalApagar,			InteresNormalApagar,	IvaInteresNomalApagar,
										OtrosCargosApagar,	IvaOtrosCargosApagar,	FechaProximoPago,		FechaProxPagoLeyenda,
										Moratorios,			IVAMoratorios,			EmpresaID,				Usuario,
										FechaActual,		DireccionIP,			ProgramaID,				Sucursal,
										NumTransaccion,		SalMontoAccesorio,		SalIVAAccesorio,		CuoMontoAccesorio,
										CuoIVAAccesorio,	LitrosMeta,				TotalLitros,			LitConsumidos
		)SELECT
										AnioMes,			CreditoID,				ClienteID,				NombreProducto,
										MontoOtorgado,		FechaVencimiento,		SaldoInsoluto,			SaldoInicial,
										Pagos,				Cat,					TasaFija,				TasaMoratoria,
										IntPagadoPerido,	IvaIntPagadoPerido,		TotalComisionesPagar,	IvaComPagadoPeriodo,
										TotalPagar,			CapitalApagar,			InteresNormalApagar,	IvaInteresNomalApagar,
										OtrosCargosApagar,	IvaOtrosCargosApagar,	FechaProximoPago,		FechaProxPagoLeyenda,
										Moratorios,			IVAMoratorios,			Entero_Cero,			Entero_Cero,
										Fecha_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Entero_Cero,
										Entero_Cero,		SalMontoAccesorio,		SalIVAAccesorio,		CuoMontoAccesorio,
										CuoIVAAccesorio,	LitrosMeta,				TotalLitros,			LitConsumidos
		FROM TMPEDOCTAHEADERCRED;

END TerminaStore$$
