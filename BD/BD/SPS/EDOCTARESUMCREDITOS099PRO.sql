-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCREDITOS099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMCREDITOS099PRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTARESUMCREDITOS099PRO`(
	-- SP PARA GENERAR INFORMACION DE RESUMEN DE CREDITOS PARA EL ESTADO DE CUENTA DE LOS NUEVOS CLIENTES EN TRONCO PRINCIPAL
	Par_AnioMes							INT(11),			-- Anio y Mes Estado Cuenta
	Par_SucursalID						INT(11),			-- Numero de Sucursal
	Par_IniMes							DATE,				-- Fecha Inicio Mes
	Par_FinMes							DATE				-- Fecha Fin Mes
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_FechaCorte				DATE;				-- Variable para la fecha corte

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);			-- Entero Cero
	DECLARE	Moneda_Cero					INT(11);			-- Decimal Cero

	DECLARE EstatusVigente				CHAR(1);			-- Estatus Vigente
	DECLARE EstatusVencido				CHAR(1);			-- Estatus Vencido
	DECLARE EstatusCastigado			CHAR(1);			-- Estatus Castigado
	DECLARE EstatusPagado				CHAR(1);			-- Estatus Pagado
	DECLARE EstatusAtrasado				CHAR(1);			-- Estatus Atrasado

	DECLARE LeyendaPagado				VARCHAR(50);		-- Leyenda Pagado
	DECLARE PagoInmediato				VARCHAR(50);		-- Leyenda pago inmediato

	DECLARE Con_SI						CHAR(1);			-- Etiquete Si
	DECLARE MontoProxTotal				CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Moneda_Cero						:= 0.00;			-- Decimal Cero

	SET EstatusVigente					:= 'V';				-- Estatus Credito: VIGENTE
	SET EstatusVencido					:= 'B';				-- Estatus Credito: VENCIDO
	SET EstatusCastigado 				:= 'K';				-- Estatus Credito: CASTIGADO
	SET EstatusPagado 					:= 'P';				-- Estatus Credito: PAGADO
	SET EstatusAtrasado					:= 'A';				-- Estatus Credito: ATRASADO

	SET LeyendaPagado					:= 'PAGADO';		-- Leyenda Pagado
	SET PagoInmediato					:= 'INMEDIATO';		-- Leyenda Pago inmediato
	SET Con_SI							:= 'S';				-- Etiquete Si
	SET MontoProxTotal					:= 'T';				-- Etiqueta para funcion de monto total de proximo pago

	-- Se obtiene la ultima fecha corte registrada en los saldos de credito en el rango de fechas de corte
	SET Var_FechaCorte:= (SELECT MAX(FechaCorte)
							FROM SALDOSCREDITOS
							 WHERE FechaCorte >= Par_IniMes AND FechaCorte <= Par_FinMes);

		-- Se crea tabla temporal para extraer la informacion del resumen del credito
		DROP TABLE IF EXISTS TMPEDOCTARESUM099CREDITOS;

		CREATE TEMPORARY TABLE TMPEDOCTARESUM099CREDITOS (
			`AnioMes`					INT(11),			-- AnioMes
			`SucursalID`				INT(11),			-- SucursalID
			`ClienteID`					INT(11),			-- ClienteID
			`CreditoID`					BIGINT(12),			-- CreditoID
			`MonedaID`					INT(11),			-- MonedaID
			`ProductoCreditoID`			INT(11),			-- ProductoCreditoID
			`ValorIVAInt`				DECIMAL(14,2),		-- ValorIVAInt
			`Producto`					VARCHAR(50),		-- Producto
			`SaldoInsoluto`				DECIMAL(14,2),		-- SaldoInsoluto
			`FechaProxPago`				DATE,				-- FechaProxPago
			`FechaLeyenda`				VARCHAR(25),		-- FechaLeyenda
			`MontoProximoPago`			DECIMAL(12,2),		-- MontoProximoPago
			`FechTerminacion`			DATE,				-- FechTerminacion
			`ValorIVAMora`				DECIMAL(14,2),		-- ValorIVAMora
			`ValorIVAAccesorios`		DECIMAL(14,2)		-- ValorIVAAccesorios

		);
		CREATE INDEX IDX_TMPEDOCTARESUM099CREDITOS_ANIOMES USING BTREE ON TMPEDOCTARESUM099CREDITOS (AnioMes);
		CREATE INDEX IDX_TMPEDOCTARESUM099CREDITOS_CLIENTE USING BTREE ON TMPEDOCTARESUM099CREDITOS (ClienteID);
		CREATE INDEX IDX_TMPEDOCTARESUM099CREDITOS_SUCURSAL USING BTREE ON TMPEDOCTARESUM099CREDITOS (SucursalID);


		-- INSERTA LOS RESUMEN DEL CREDITO DE CADA CLIENTE
		INSERT INTO TMPEDOCTARESUM099CREDITOS
		SELECT	Par_AnioMes,								-- AnioMes
				Entero_Cero,                				-- SucursalID
				Cred.ClienteID,             				-- ClienteID
				Cred.CreditoID, 							-- CreditoID
				Cred.MonedaID,								-- MonedaID
				Cred.ProductoCreditoID,						-- ProductoCreditoID
				Moneda_Cero,								-- ValorIVAInt
				Cadena_Vacia,								-- Producto
				Moneda_Cero,								-- SaldoInsoluto
				Fecha_Vacia,								-- FechaProxPago
				IF(Cred.Estatus = EstatusPagado,
					LeyendaPagado, Cadena_Vacia
				  ),										-- FechaLeyenda
				Moneda_Cero,								-- MontoProximoPago
				Cred.FechTerminacion,						-- FechTerminacion
				Moneda_Cero,								-- ValorIVAMora
				Moneda_Cero									-- ValorIVAAccesorios
		FROM CREDITOS Cred
		WHERE Estatus IN (EstatusVigente, EstatusVencido, EstatusCastigado)
		OR (Estatus = EstatusPagado
				AND  FechTerminacion >= Par_IniMes
				AND  FechTerminacion <= Par_FinMes );


		-- Se obtiene la numero de sucursal del cliente
		UPDATE TMPEDOCTARESUM099CREDITOS Edo, CLIENTES Cli
				SET Edo.SucursalID = Cli.SucursalOrigen
		WHERE Edo.ClienteID = Cli.ClienteID;

		-- Se saca la información del producto nombre
		UPDATE TMPEDOCTARESUM099CREDITOS Edo
		INNER JOIN PRODUCTOSCREDITO ProdC	ON Edo.ProductoCreditoID = ProdC.ProducCreditoID
			SET Edo.Producto = ProdC.Descripcion;

		-- Se obtiene el saldo insuluto de cada credito, correspondiente a la ultima fecha de corte registrada de saldos de los creditos
		UPDATE TMPEDOCTARESUM099CREDITOS Edo
		INNER JOIN SALDOSCREDITOS Scred						ON Edo.CreditoID = Scred.CreditoID
															AND Scred.FechaCorte = Var_FechaCorte
			SET Edo.SaldoInsoluto		= Scred.SalCapVigente + Scred.SalCapAtrasado + Scred.SalCapVencido + Scred.SalCapVenNoExi;

		-- Sacamos las fechas proximo pago y la leyenda
		DROP TABLE IF EXISTS TMPEDOCTARESUMCREDITOSFECHA;
		CREATE TEMPORARY TABLE TMPEDOCTARESUMCREDITOSFECHA (
				`CreditoID`				BIGINT(12),
				`FechaPago`				DATE
		);
		CREATE INDEX IDX_TMPEDOCTARESUMCREDITOSFECHA_CREDITOID USING BTREE ON TMPEDOCTARESUMCREDITOSFECHA (CreditoID);


		INSERT INTO TMPEDOCTARESUMCREDITOSFECHA(
				CreditoID,			FechaPago
		)SELECT
				Amo.CreditoID,		MIN(Amo.FechaExigible) AS FechaPago
		FROM AMORTICREDITO Amo INNER JOIN TMPEDOCTARESUM099CREDITOS TmpResum ON Amo.CreditoID = TmpResum.CreditoID
		WHERE Amo.FechaExigible > Par_FinMes
		  AND Amo.Estatus		!= EstatusPagado
		GROUP BY CreditoID;

		UPDATE	TMPEDOCTARESUM099CREDITOS Edo
		INNER JOIN SALDOSCREDITOS Scred						ON Edo.CreditoID			= Scred.CreditoID
		INNER JOIN TMPEDOCTARESUMCREDITOSFECHA TmpResum		ON TmpResum.CreditoID		= Edo.CreditoID
															AND Scred.FechaCorte		= Var_FechaCorte
			SET		Edo.FechaProxPago	= IF(Scred.DiasAtraso = Entero_Cero , TmpResum.FechaPago , Fecha_Vacia),
					Edo.FechaLeyenda	= CASE WHEN Scred.DiasAtraso = Entero_Cero	THEN IFNULL(CAST(DATE_FORMAT(TmpResum.FechaPago, '%Y-%m-%d') AS CHAR), PagoInmediato)
																					ELSE PagoInmediato
																					END;


		UPDATE TMPEDOCTARESUM099CREDITOS Edo, CREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
			SET Edo.ValorIVAInt = CASE WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_SI	THEN IFNULL(Suc.IVA, Moneda_Cero)
																									ELSE Moneda_Cero
																									END,
			Edo.ValorIVAMora = CASE WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Moneda_Cero)
																								ELSE Moneda_Cero
																								END,
			Edo.ValorIVAAccesorios = CASE WHEN Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Moneda_Cero)
																	ELSE Moneda_Cero
																	END
		WHERE Edo.CreditoID = Cre.CreditoID
		  AND Prod.ProducCreditoID = Cre.ProductoCreditoID
		  AND Edo.ClienteID = Cli.ClienteID
		  AND Cli.SucursalOrigen = Suc.SucursalID;

		UPDATE TMPEDOCTARESUM099CREDITOS Edo
			SET	Edo.MontoProximoPago = FNEXIGIBLEPROXPAGEDOCTA(CreditoID, Var_FechaCorte, MontoProxTotal)
		WHERE Edo.MontoProximoPago = Moneda_Cero;


		-- INSERTAMOS EN LA TABLA FINAL
 		INSERT INTO EDOCTARESUM099CREDITOS
 		(
 				AnioMes,			SucursalID,			ClienteID,			CreditoID,			Producto,
 				SaldoInsoluto,		FechaProxPago,		FechaLeyenda,		MontoProximoPago, 	ValorIvaCred,
 				ValorIVAMora,		ValorIVAAccesorios,	EmpresaID,			Usuario,			FechaActual,
				DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion
 		)
 		SELECT	AnioMes,			SucursalID,			ClienteID,			CreditoID,			Producto,
 				SaldoInsoluto,		FechaProxPago,		FechaLeyenda,		MontoProximoPago,	ValorIVAInt,
 				ValorIVAMora,		ValorIVAAccesorios,	Entero_Cero,		Entero_Cero,		Fecha_Vacia,
				Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,		Entero_Cero
 		FROM TMPEDOCTARESUM099CREDITOS;

END TerminaStore$$