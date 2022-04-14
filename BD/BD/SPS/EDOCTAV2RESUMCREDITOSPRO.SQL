-- EDOCTAV2RESUMCREDITOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2RESUMCREDITOSPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2RESUMCREDITOSPRO`(
	-- SP PARA GENERAR INFORMACION DE RESUMEN DE CREDITOS PARA EL ESTADO DE CUENTA BIENESTAR
	Par_Salida							CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr					INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen					VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	Par_EmpresaID 						INT(11),			-- Parametros de auditoria
	Aud_Usuario							INT(11),			-- Parametros de auditoria
	Aud_FechaActual						DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP						VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID						VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal						INT(11), 			-- Parametros de auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Parametros de auditoria
)

TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_FechaCorte				DATE;				-- Variable para la fecha corte
	DECLARE Var_AnioMes					INT(11);			-- Variable para obtener el periodo parametrizado
	DECLARE Var_AnioMesStr				VARCHAR(10);		-- Anio y Mes en formato cadena
	DECLARE Var_FecIniMes				DATE;				-- Fecha de Fin de mes
	DECLARE Var_FecFinMes				DATE;				-- Fecha de Fin de mes
	DECLARE Var_Anio					INT(11);			-- Anio
	DECLARE Var_MesIni					INT(11);			-- Mes Inicio
	DECLARE Var_MesFin					INT(11);			-- Mes Fin
	DECLARE Var_FolioProceso			BIGINT(20);			-- Folio de procesamiento
	DECLARE Var_Control					VARCHAR(50);		-- Variable para control de excepciones

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);			-- Entero Cero
	DECLARE Entero_Uno					INT(1);				-- Entero Uno
	DECLARE Var_EstVigente				CHAR(1);			-- Estatus Vigente
	DECLARE Var_EstVencido				CHAR(1);			-- Estatus Vencido
	DECLARE Var_EstCastigado			CHAR(1);			-- Estatus Castigado
	DECLARE Var_EstPagado				CHAR(1);			-- Estatus Pagado
	DECLARE Var_EstAtrasado				CHAR(1);			-- Estatus Atrasado
	DECLARE Var_EstEliminado			CHAR(1);			-- Estatus Eliminado
	DECLARE Var_LeyendaPagado			VARCHAR(50);		-- Leyenda Pagado
	DECLARE Var_PagoInmediato			VARCHAR(50);		-- Leyenda pago inmediato
	DECLARE Var_SI						CHAR(1);			-- Etiquete Si
	DECLARE Var_DiaUnoDelMes			CHAR(2);			-- Dia Primero del mes
	DECLARE Var_TipoProdCred			INT(11);			-- TipoProducto CREDITO de la tabla EDOCTAV2PRODUCTOS

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Entero_Uno						:= 1;				-- Entero Uno
	SET Var_EstVigente					:= 'V';				-- Estatus Credito : VIGENTE
	SET Var_EstVencido					:= 'B';				-- Estatus Credito : VENCIDO
	SET Var_EstCastigado 				:= 'K';				-- Estatus Credito : CASTIGADO
	SET Var_EstPagado 					:= 'P';				-- Estatus Credito : PAGADO
	SET Var_EstAtrasado					:= 'A';				-- Estatus Credito : ATRASADO
	SET Var_EstEliminado				:= 'E';				-- Estatus Credito : ELIMINADO
	SET Var_LeyendaPagado				:= 'PAGADO';		-- Leyenda Pagado
	SET Var_PagoInmediato				:= 'INMEDIATO';		-- Leyenda Pago inmediato
	SET Var_SI							:= 'S';				-- Etiquete Si
	SET Var_DiaUnoDelMes				:= '01';			-- Asignacion de Dia Primero del mes
	SET Var_TipoProdCred				:= 4;				-- 4 = Productos de Credito que deben aparecer en el Estado de Cuenta

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2RESUMCREDITOSPRO');
			SET Var_Control = 'sqlException';
		END;

	-- Se obtiene el periodo con el que se trabajará

	SELECT		MesProceso,		FechaInicio,	FechaFin,		FolioProceso
		INTO	Var_AnioMes,	Var_FecIniMes,	Var_FecFinMes,	Var_FolioProceso
		FROM	EDOCTAV2PARAMS
		LIMIT	Entero_Uno;

	TRUNCATE TABLE TMPEDOCTAV2RESUMCREDITOS;

	DELETE FROM EDOCTAV2RESUMCREDITOS
	WHERE FolioProcesoID = Var_FolioProceso;

	-- Se obtiene la ultima fecha corte registrada en los saldos de credito en el rango de fechas de corte para cada uno de los creditos
	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2FECHACORTE;

	CREATE TEMPORARY TABLE TMPEDOCTAV2FECHACORTE
	SELECT	CreditoID, MAX(FechaCorte) AS FechaCorte
	FROM SALDOSCREDITOS
	WHERE FechaCorte >= Var_FecIniMes
	  AND FechaCorte <= Var_FecFinMes
	GROUP BY CreditoID;

	CREATE INDEX IDX_TMPEDOCTAV2FECHACORTE_1 ON TMPEDOCTAV2FECHACORTE(CreditoID, FechaCorte);



	-- Se genera una copia de SALDOSCREDITOS solo con el ultimo registro de cada credito
	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2SALDOSCREDITO;

	CREATE TEMPORARY TABLE TMPEDOCTAV2SALDOSCREDITO
	SELECT Sal.*, DATE(IFNULL(Cre.FechaElimina, Fecha_Vacia)) AS FechaElimina
	FROM TMPEDOCTAV2FECHACORTE Tmp
	INNER JOIN SALDOSCREDITOS Sal ON Tmp.CreditoID = Sal.CreditoID AND Tmp.FechaCorte = Sal.FechaCorte
	INNER JOIN CREDITOS Cre on Tmp.CreditoID = Cre.CreditoID ;

	CREATE INDEX IDX_TMPEDOCTAV2SALDOSCREDITO_01_Cred ON TMPEDOCTAV2SALDOSCREDITO(CreditoID);
	CREATE INDEX IDX_TMPEDOCTAV2SALDOSCREDITO_02_Cli  ON TMPEDOCTAV2SALDOSCREDITO(ClienteID);


	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2FECHACORTE;

	-- Insercion de creditos vivos
	INSERT INTO TMPEDOCTAV2RESUMCREDITOS	(	AnioMes,		SucursalID,				ClienteID,			CreditoID,			FechaCorte, 
												MonedaID,		ProductoCreditoID,		ValorIVAInt,		Producto,   		SaldoInsoluto,
												FechaProxPago,  FechaLeyenda,   		MontoProximoPago,   FechTerminacion,	ValorIVAMora,
												ValorIVAAccesorios	)
									SELECT		DISTINCT Var_AnioMes,	Entero_Cero,				Cli.ClienteID,			Cre.CreditoID,		Cre.FechaCorte,
									     		Cre.MonedaID,	Cre.ProductoCreditoID,		Entero_Cero,			Cadena_Vacia,       Cre.SalCapVigente + Cre.SalCapAtrasado + Cre.SalCapVencido + Cre.SalCapVenNoExi AS SaldoInsoluto,
												Cre.FechaProximoPago,
												IF (Cre.DiasAtraso > Entero_Cero, Var_PagoInmediato, CAST(DATE_FORMAT(Cre.FechaProximoPago, '%Y-%m-%d') AS CHAR)),
												IF (Cre.DiasAtraso > Entero_Cero, Cre.MontoProximoPago, Cre.MontoProximoPago),
												Cre.FechaLiquida,		Entero_Cero,		Entero_Cero
										FROM EDOCTAV2DATOSCTE Cli
										INNER JOIN TMPEDOCTAV2SALDOSCREDITO Cre FORCE INDEX (IDX_TMPEDOCTAV2SALDOSCREDITO_02_Cli) ON Cli.ClienteID = Cre.ClienteID AND (	Cre.EstatusCredito IN (Var_EstVigente, Var_EstVencido)
										   																																	OR (  (Cre.EstatusCredito = Var_EstCastigado AND Cre.FechaElimina = Fecha_Vacia ) OR (Cre.EstatusCredito = Var_EstCastigado AND Cre.FechaElimina >= Var_FecIniMes AND Cre.FechaElimina <= Var_FecFinMes )  )
																																									   		OR ( Cre.EstatusCredito = Var_EstEliminado   AND Cre.FechaElimina >= Var_FecIniMes AND Cre.FechaElimina <= Var_FecFinMes)
																																									   	)
										INNER JOIN EDOCTAV2PRODUCTOS PROD ON Cre.ProductoCreditoID = PROD.ProductoID AND PROD.TipoProducto = Var_TipoProdCred
										WHERE	Cre.EstatusCredito IN (Var_EstVigente, Var_EstVencido)
												OR (  (Cre.EstatusCredito = Var_EstCastigado AND Cre.FechaElimina = Fecha_Vacia ) OR (Cre.EstatusCredito = Var_EstCastigado AND Cre.FechaElimina >= Var_FecIniMes AND Cre.FechaElimina <= Var_FecFinMes )  )
										   		OR ( Cre.EstatusCredito = Var_EstEliminado   AND Cre.FechaElimina >= Var_FecIniMes AND Cre.FechaElimina <= Var_FecFinMes) ;									   
	
	-- Insercion de creditos pagados
	INSERT INTO TMPEDOCTAV2RESUMCREDITOS	(	AnioMes,		SucursalID,			ClienteID,			CreditoID,			 FechaCorte, 
												MonedaID,      	ProductoCreditoID,	ValorIVAInt,		Producto,			SaldoInsoluto,
												FechaProxPago,  FechaLeyenda,        MontoProximoPago, 	FechTerminacion,	ValorIVAMora,	
												ValorIVAAccesorios	)
									SELECT		DISTINCT Var_AnioMes,	Entero_Cero,			Cli.ClienteID,		 Cre.CreditoID,		Cre.FechaCorte, 
									        	Cre.MonedaID,  	Cre.ProductoCreditoID,	Entero_Cero,		Cadena_Vacia,       Cre.SalCapVigente + Cre.SalCapAtrasado + Cre.SalCapVencido + Cre.SalCapVenNoExi AS SaldoInsoluto,
												Fecha_Vacia,
												IF (Cre.DiasAtraso > Entero_Cero, Var_PagoInmediato, CAST(DATE_FORMAT(Cre.FechaExigible, '%Y-%m-%d') AS CHAR)),
												IF (Cre.DiasAtraso > Entero_Cero, Cre.MontoTotalExi, Cre.MontoTotalExi),
												Cre.FechaLiquida,		Entero_Cero,		Entero_Cero
										FROM EDOCTAV2DATOSCTE Cli
										INNER JOIN TMPEDOCTAV2SALDOSCREDITO Cre FORCE INDEX (IDX_TMPEDOCTAV2SALDOSCREDITO_02_Cli) ON Cli.ClienteID = Cre.ClienteID 	AND Cre.EstatusCredito = Var_EstPagado
																																									AND Cre.FechaLiquida >= Var_FecIniMes
																																									AND Cre.FechaLiquida <= Var_FecFinMes
																																									AND ( Cre.FechaElimina >= Fecha_Vacia  OR (  Cre.FechaElimina >= Var_FecIniMes AND Cre.FechaElimina <= Var_FecFinMes )  )
										INNER JOIN EDOCTAV2PRODUCTOS PROD ON Cre.ProductoCreditoID = PROD.ProductoID AND PROD.TipoProducto = Var_TipoProdCred
										WHERE Cre.EstatusCredito = Var_EstPagado
										  AND Cre.FechaLiquida >= Var_FecIniMes
										  AND Cre.FechaLiquida <= Var_FecFinMes
										  AND ( Cre.FechaElimina = Fecha_Vacia  OR (  Cre.FechaElimina >= Var_FecIniMes AND Cre.FechaElimina <= Var_FecFinMes )  ) ;

	-- Se obtiene la numero de sucursal del cliente
	UPDATE TMPEDOCTAV2RESUMCREDITOS Edo, CLIENTES Cli
	SET	Edo.SucursalID	= Cli.SucursalOrigen
	WHERE Edo.ClienteID	= Cli.ClienteID;

	-- Se saca la informacion del nombre del producto
	UPDATE TMPEDOCTAV2RESUMCREDITOS Edo
		INNER JOIN PRODUCTOSCREDITO ProdC ON Edo.ProductoCreditoID = ProdC.ProducCreditoID
	SET	Edo.Producto = ProdC.Descripcion;

	-- INSERTAMOS EN LA TABLA FINAL
	INSERT INTO EDOCTAV2RESUMCREDITOS	(	AnioMes,			SucursalID,			ClienteID,			CreditoID,			ProductoCreditoID,
											Producto,			SaldoInsoluto,		FechaProxPago,		FechaLeyenda,		MontoProximoPago,
											FolioProcesoID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
											ProgramaID,			Sucursal,			NumTransaccion	)
								SELECT		AnioMes,			SucursalID,			ClienteID,			CreditoID,			ProductoCreditoID,
											Producto,			SaldoInsoluto,		FechaProxPago,		FechaLeyenda,		MontoProximoPago,
											Var_FolioProceso,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
									FROM	TMPEDOCTAV2RESUMCREDITOS;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso de extraccion de Resumen de Creditos Ejecutado con Exito';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;


	IF (Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;

END TerminaStore$$
