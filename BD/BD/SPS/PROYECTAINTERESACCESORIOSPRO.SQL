-- PROYECTAINTERESACCESORIOSPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS PROYECTAINTERESACCESORIOSPRO;

DELIMITER $$

CREATE PROCEDURE PROYECTAINTERESACCESORIOSPRO(
	-- SP para la proyeccion de intereses de los accesorios
	Par_CreditoID				BIGINT(12),		-- Numero de credito
	Par_AmortiCreID				INT(4),			-- Numero de amortizacion
	Par_PolizaID				BIGINT(20),

	Par_Salida					CHAR(1),		-- Parametro de salida Si

	INOUT	Par_NumErr			INT(11),		-- Parametro de salida Numero de error
	INOUT	Par_ErrMen			VARCHAR(400),	-- parametro de salida  mensaje de error

	Par_EmpresaID				INT(11),		-- Parametro de auditoria
	Aud_Usuario					INT(11),		-- Parametro de auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal				INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable para el nombre de un control
	DECLARE Var_CreditoID				BIGINT(12);			-- Identificador de un credito
	DECLARE Var_AmortizacionID			INT(11);
	DECLARE Var_FechaInicio				DATE;
	DECLARE Var_FechaVencim				DATE;
	DECLARE Var_FechaExigible			DATE;
	DECLARE Var_EmpresaID				INT(11);
	DECLARE Var_CreCapVig				DECIMAL(14,2);
	DECLARE Var_CreCapVNE				DECIMAL(14,2);
	DECLARE Var_FormulaID				INT(11);
	DECLARE Var_TasaFija				DECIMAL(12,4);
	DECLARE Var_MonedaID				INT(11);
	DECLARE Var_Estatus					CHAR(1);
	DECLARE Var_SucCliente				INT(11);
	DECLARE Var_ProdCreID				INT(11);
	DECLARE Var_ClasifCre				CHAR(1);
	DECLARE Var_TipoCalInt				INT(11);
	DECLARE Var_Interes					DECIMAL(14,4);
	DECLARE Var_SucursalCred			INT(11);
	DECLARE Var_SalIntNoC				DECIMAL(14,4);
	DECLARE Var_SalIntPro				DECIMAL(14,4);
	DECLARE Var_SalIntVen				DECIMAL(14,4);

	DECLARE Var_UltimoDia				CHAR(1);
	DECLARE Var_CreditoStr				VARCHAR(30);		-- Variable para almacenar el identificador de un credito en formato string
	DECLARE Var_ValorTasa				DECIMAL(12,4);
	DECLARE Var_DiasCredito				DECIMAL(10,2);
	DECLARE Var_Intere					DECIMAL(12,4);
	DECLARE Var_FecApl					DATE;
	DECLARE Var_EsHabil					CHAR(1);
	DECLARE SalCapital					DECIMAL(14,2);
	DECLARE Var_CapAju					DECIMAL(14,2);
	DECLARE Ref_GenInt					VARCHAR(50);
	DECLARE Error_Key					INT(11);
	DECLARE Mov_AboConta				INT(11);
	DECLARE Mov_CarConta				INT(11);
	DECLARE Mov_CarOpera				INT(11);
	DECLARE Var_Poliza					BIGINT;
	DECLARE Par_Consecutivo				BIGINT;
	DECLARE Es_DiaHabil					CHAR(1);
	DECLARE Var_ContadorCre				BIGINT(20);			-- Contador del numero total de registros de la tabla temporal
	DECLARE Var_Contador				BIGINT(20);			-- Contador incremental para iterar el ciclo while
	DECLARE Var_SigFecha				DATE;
	DECLARE Var_SubClasifID				INT(11);
	DECLARE Var_FechaFinMes				DATE;				-- Indica el fin de mes de acuerdo a la fecha de inicio de la amortizacion
	DECLARE Var_FechaInicioMes			DATE;				-- Indica la fecha de inicio de mes de acuerdo a la fecha de fin de mes
	DECLARE Var_InteresRef				DECIMAL(14,2);
	DECLARE Var_CreditoMigrado			BIGINT(12);			-- Credito Migrado SAFI
	DECLARE Var_ExcepAjusteIntCreMigrado CHAR(1);			-- Define si se ajusta o no el interes devengado con lo pactado en las amortizaciones de los creditos migrados , valores: S = Si, N=No
	-- DIFERIMIENTO
	DECLARE	Var_CreditoDifer			BIGINT(12);
	DECLARE	Var_InteresTotal			BIGINT(12);
	-- >>>

	DECLARE Var_NumCliProEsp			INT(11);			-- Numero identificador de cliente especifico
	DECLARE Var_ConvNomID				INT(11);			-- Identificador de un convenio de nomina
	DECLARE Var_ManejaCalend			CHAR(1);			-- Indica si el convenio de nomina maneja calendario de ingresos
	DECLARE Var_ManejaFechIni			CHAR(1);			-- Indica si el convenio de nomina maneja fecha inicial
	DECLARE Var_DiasDurCuota			INT(11);			-- Dias de duracion de la cuota entre fecha de inicio y de vencimiento
	DECLARE Var_SumIntDeveng			DECIMAL(14,2);		-- Suma del interes devengado a lo largo de la vida de la cuota
	DECLARE Var_DiasSinDeven			INT(11);			-- Numero de dias en los que no se ha devengado interes para un credito
	DECLARE Var_DevengaNomina			CHAR(1);			-- Bandera del credito que indica si no estaba devengando intereses

	DECLARE Var_AccesorioID				INT(11);			-- Identificador de un accesorio
	DECLARE Var_MontoAccesorio			DECIMAL(14,2);		-- Monto total del accesorio

	DECLARE Var_AbrevAccesorio			VARCHAR(20);		-- Abreviatura del accesorio
	DECLARE Var_ConceptoCartera			INT(11);			-- Concepto de Cartera al que corresponde el accesorio
	DECLARE Var_CobraAccesorios			CHAR(1);			-- Indica si el credito cobra accesorios
	DECLARE Ref_GenAccesorios 			VARCHAR(100);		-- Referencia para la generacion del interes de accesorios
	DECLARE Var_DescConcepto			VARCHAR(500);		-- Descripcion de un concepto contable

	DECLARE Var_MontoInteres			DECIMAL(14,2);		-- Monto del interes de accesorio total de la cuota
	DECLARE Var_SaldoInteres			DECIMAL(14,2);		-- Saldo del interes del accesorio de la cuota

	DECLARE Var_DescAccesorio			VARCHAR(200);

	DECLARE Var_InteresDev				DECIMAL(14,2);
	DECLARE Var_FechaSistema			DATE;

	-- Declaracion de Constantes
	DECLARE Estatus_Vigente				CHAR(1);
	DECLARE Estatus_Vencida				CHAR(1);
	DECLARE Estatus_Pagada				CHAR(1);
	DECLARE Cre_Vencido					CHAR(1);
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Fecha_Vacia					DATE;
	DECLARE Entero_Cero					INT(11);
	DECLARE Entero_Uno					INT(11);
	DECLARE Decimal_Cero				DECIMAL(12, 2);
	DECLARE Nat_Cargo					CHAR(1);
	DECLARE Nat_Abono					CHAR(1);
	DECLARE Dec_Cien					DECIMAL(10,2);
	DECLARE Pro_GenIntere				INT(11);
	DECLARE Mov_IntPro					INT(11);
	DECLARE Mov_IntNoConta				INT(11);
	DECLARE Con_IntDeven				INT(11);
	DECLARE Con_IngreInt				INT(11);
	DECLARE Con_CueOrdInt				INT(11);
	DECLARE Con_CorOrdInt				INT(11);
	DECLARE Pol_Automatica				CHAR(1);
	DECLARE Con_GenIntere				INT;
	DECLARE Par_SalidaNO				CHAR(1);
	DECLARE AltaPoliza_NO				CHAR(1);
	DECLARE AltaPolCre_SI				CHAR(1);
	DECLARE AltaMovCre_SI				CHAR(1);
	DECLARE AltaMovCre_NO				CHAR(1);
	DECLARE AltaMovAho_NO				CHAR(1);
	DECLARE Int_SalInsol				INT(11);
	DECLARE Int_SalGlobal				INT(11);
	DECLARE For_TasaFija				INT(11);
	DECLARE SI_UltimoDia				CHAR(1);
	DECLARE NO_UltimoDia				CHAR(1);
	DECLARE DiasInteres					DECIMAL(10,2);
	DECLARE InterXdia					DECIMAL(12,2);
	DECLARE MontoOrig					DECIMAL(12,2);
	DECLARE Nuevo_Interes				DECIMAL(14,4);  	-- Interes de la amortizacion a ajustar
	DECLARE Var_LlaveCliProEsp			VARCHAR(20);		-- Llave para consulta del numero de cliente especifico
	DECLARE Var_NumCliProATE			INT(11);			-- Numero de cliente especifico de Apoyo a Tu Economia (ATE)
	DECLARE Var_EstEnviado				CHAR(1);			-- Estatus E : Enviado
	DECLARE Var_EstNoEnviado			CHAR(1);			-- Estatus N : No Enviado
	DECLARE Var_TipoFormaCobro			CHAR(1);			-- Indica el tipo de forma de cobro del accesorio
	DECLARE Var_TipoDeduccion			CHAR(1);			-- Tipo de forma de cobro de accesorio por deduccion
	DECLARE Var_TipoFinanciam			CHAR(1);			-- Tipo de forma de cobro de accesorio por financiamiento

	DECLARE Si_Regulariza				CHAR(1);
	DECLARE No_Regulariza				CHAR(1);
	DECLARE Des_CieDia					VARCHAR(100);
	DECLARE Des_ErrorGral				VARCHAR(100);
	DECLARE Des_ErrorLlavDup			VARCHAR(100);
	DECLARE Des_ErrorCallSP				VARCHAR(100);
	DECLARE Des_ErrorValNulos			VARCHAR(100);
	DECLARE Cons_SI						CHAR(1);			-- Constante SI
	DECLARE Cons_NO						CHAR(1);			-- Constante NO
	DECLARE LlaveExcepAjusteIntCreMigrado  VARCHAR(50);
	DECLARE Var_LlaveParametro			VARCHAR(50);		-- Llave de parametros
	DECLARE Var_ManejaConvenio			CHAR(5);			-- MANEJA CONVENIO DE NOMINA
	DECLARE Var_EsProducNomina			CHAR(1);			-- Si el producto de Credito es de nomina
	DECLARE Var_SI						CHAR(1);			-- SI
	DECLARE Var_InteresCal				DECIMAL(14,4);
	DECLARE Var_No						CHAR(1);			-- NO

	DECLARE Var_TextoDevengam			VARCHAR(100);		-- Texto para encontrar el concepto de devengamiento por accesorio
	DECLARE Var_ConceptoGenInt			INT(11);			-- Concepto Contable Generacion Interes Accesorios

	DECLARE Var_TipoMovIntAcc			INT(11);			-- Tipo de movimiento de credito Interes Accesorios

	-- Asignacion de Constantes
	SET Estatus_Vigente					:= 'V';				-- Estatus Amortizacion: Vigente
	SET Estatus_Vencida					:= 'B';				-- Estatus Amortizacion: Vencido
	SET Estatus_Pagada					:= 'P';				-- Estatus Amortizacion: Pagada
	SET Cre_Vencido						:= 'B';				-- Estatus Credito: Vencido
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero en Cero
	SET Entero_Uno						:= 1;				-- Entero en Uno
	SET Decimal_Cero					:= 0.00;			-- Decimal Cero
	SET Nat_Cargo						:= 'C';				-- Naturaleza de Cargo
	SET Nat_Abono						:= 'A';				-- Naturaleza de Abono
	SET Dec_Cien						:= 100.00;			-- Decimal Cien
	SET Pro_GenIntere					:= 201;				-- Numero de Proceso Batch: Generacion de Interes
	SET Mov_IntPro						:= 14;				-- Tipo de Movimiento de Credito: Interes Provisionado
	SET Mov_IntNoConta					:= 13;				-- Tipo de Movimiento de Credito: Interes Provisionado
	SET Con_IntDeven					:= 19;				-- Concepto Contable: Interes Devengado
	SET Con_IngreInt					:= 5;				-- Concepto Contable: Ingreso por Intereses
	SET Con_CueOrdInt					:= 11;				-- Concepto Contable: Orden Intereses
	SET Con_CorOrdInt					:= 12;				-- Concepto Contable: Correlativa Intereses
	SET Pol_Automatica					:= 'A';				-- Tipo de Poliza: Automatica
	SET Con_GenIntere					:= 51;				-- Tipo de Proceso Contable: Generacion de Interes Ordinario
	SET Par_SalidaNO					:= 'N';				-- El store no Arroja una Salida
	SET AltaPoliza_NO					:= 'N';				-- Alta del Encabezado de la Poliza: NO
	SET AltaPolCre_SI					:= 'S';				-- Alta de la Poliza de Credito: SI
	SET AltaMovCre_NO					:= 'N';				-- Alta del Movimiento de Credito: NO
	SET AltaMovCre_SI					:= 'S';				-- Alta del Movimiento de Credito: SI
	SET AltaMovAho_NO					:= 'N';				-- Alta del Movimiento de Ahorro: NO
	SET Int_SalInsol					:= 1;				-- Calculo de Interes Sobre Saldos Insolutos
	SET Int_SalGlobal					:= 2;				-- Calculo de Interes Sobre Saldos Globales
	SET For_TasaFija					:= 1;				-- Formula de Calculo de Interes: Tasa Fija
	SET SI_UltimoDia					:= 'S';				-- Ultimo Dia del calculo de Interes: SI
	SET NO_UltimoDia					:= 'N';				-- Ultimo Dia del calculo de Interes: NO
	SET DiasInteres						:= 1;				-- Dias para el Calculo de Interes: Un Dia
	SET Cons_SI							:= 'S';				-- Constante: SI
	SET Cons_NO							:= 'N';				-- Constante: NO
	SET LlaveExcepAjusteIntCreMigrado	:= 'ExcepAjusteIntCreMigrado';

	SET Des_CieDia						:= 'CIERRE DIARIO CARTERA';
	SET Ref_GenInt						:= 'GENERACION INTERES ACCESORIOS';
	SET Aud_ProgramaID					:= 'GENERAINTEREACCESPRO';

	SET Des_ErrorGral					:= 'ERROR DE SQL GENERAL';
	SET Des_ErrorLlavDup				:= 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET Des_ErrorCallSP					:= 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET Des_ErrorValNulos				:= 'ERROR VALORES NULOS';
	SET Var_LlaveParametro				:= 'ManejaCovenioNomina';	-- Maneje convenios nomina
	SET Var_SI							:= 'S';
	SET Var_No							:= 'N';
	SET Var_LlaveCliProEsp				:= 'CliProcEspecifico';	-- Llave para consulta del numero de cliente especifico
	SET Var_NumCliProATE				:= 49;					-- Numero de cliente especifico de Apoyo a Tu Economia (ATE)
	SET Var_EstEnviado					:= 'E';					-- Estatus E : Enviado
	SET Var_EstNoEnviado				:= 'N';					-- Estatus N : No Enviado

	SET Var_TipoDeduccion				:= 'D';					-- Tipo de forma de cobro de accesorio por deduccion
	SET Var_TipoFinanciam				:= 'F';					-- Tipo de forma de cobro de accesorio por financiamiento

	SET Var_ConceptoGenInt				:= 1107;				-- Concepto Contable Generacion Interes Accesorios

	SET Var_TipoMovIntAcc				:= 57;					-- Tipo de movimiento de credito Interes Accesorios
	SET Var_TextoDevengam				:= 'DEVENGAMIENTO INTERES ';
	SET Var_Poliza						:= Par_PolizaID;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-PROYECTAINTERESACCESORIOSPRO');
			SET Var_Control = 'sqlException';
		END;

		DROP TEMPORARY TABLE IF EXISTS TMPGENERAINTERESACCESORIOS;
		CREATE TEMPORARY TABLE TMPGENERAINTERESACCESORIOS (
			CreditoID			BIGINT(12),
			AmortizacionID		INT(11),
			FechaInicio			DATE,
			FechaVencimiento	DATE,
			FechaExigible		DATE,
			EmpresaID			INT(11),
			CalcInteresID		INT(11),
			TasaFija			DECIMAL(12,4),
			MonedaID			INT(11),
			Estatus				CHAR(1),
			SucursalOrigen		INT(11),
			ProducCreditoID		INT(11),
			Clasificacion		CHAR(1),
			SubClasifID			INT(11),
			SucursalID			INT(11),
			TipoCalInteres		INT(11),
			ConvenioNominaID	INT(11),
			DevengaNomina		CHAR(1),
			AccesorioID			INT(11),
			MontoAccesorio		DECIMAL(14,2),
			CobraAccesorios		CHAR(1),
			MontoInteres		DECIMAL(14,2),
			SaldoInteres		DECIMAL(14,2),
			PRIMARY KEY (CreditoID, AmortizacionID, AccesorioID)
		);

		INSERT INTO TMPGENERAINTERESACCESORIOS (
						CreditoID,				AmortizacionID,			FechaInicio,			FechaVencimiento,		FechaExigible,
						EmpresaID,				CalcInteresID,			TasaFija,				MonedaID,				Estatus,
						SucursalOrigen,			ProducCreditoID,		Clasificacion,			SubClasifID,			SucursalID,
						TipoCalInteres,			ConvenioNominaID,		DevengaNomina,			AccesorioID,			MontoAccesorio,
						CobraAccesorios,		MontoInteres,			SaldoInteres	)
			SELECT		CRE.CreditoID,			AMO.AmortizacionID,		AMO.FechaInicio,		AMO.FechaVencim,		AMO.FechaExigible,
						CRE.EmpresaID,			CRE.CalcInteresID,		CRE.TasaFija,			CRE.MonedaID,			CRE.Estatus,
						CLI.SucursalOrigen,		CRE.ProductoCreditoID,	DES.Clasificacion,		DES.SubClasifID,        CRE.SucursalID,
						CRE.TipoCalInteres,		CRE.ConvenioNominaID,	CRE.DevengaNomina,		DA.AccesorioID,			DA.MontoAccesorio,
						CRE.CobraAccesorios,	DA.MontoIntCuota,		DA.SaldoInteres
				FROM	CREDITOS CRE
				INNER JOIN AMORTICREDITO AMO	ON CRE.CreditoID = AMO.CreditoID
											   AND AMO.AmortizacionID = Par_AmortiCreID
				INNER JOIN CLIENTES CLI			ON CRE.ClienteID = CLI.ClienteID
				INNER JOIN DESTINOSCREDITO DES	ON CRE.DestinoCreID = DES.DestinoCreID
				INNER JOIN DETALLEACCESORIOS DA	ON CRE.CreditoID = DA.CreditoID
											   AND AMO.AmortizacionID = DA.AmortizacionID
											   AND DA.TipoFormaCobro IN (Var_TipoDeduccion, Var_TipoFinanciam)
											   AND DA.GeneraInteres = Var_SI
											   AND DA.NumProyInteres = Entero_Cero
				WHERE CRE.CreditoID = Par_CreditoID
				  AND CRE.Estatus IN (Estatus_Vigente, Estatus_Vencida)
				  AND CRE.EstatusNomina NOT IN (Var_EstEnviado, Var_EstNoEnviado)
				  AND CRE.TipoCalInteres = Int_SalGlobal;

		SELECT		DiasCredito
			INTO	Var_DiasCredito
			FROM	PARAMETROSSIS;

		SELECT		FechaSistema
			INTO	Var_FechaSistema
			FROM	PARAMETROSSIS;

		SET Var_DiasCredito					:= IFNULL(Var_DiasCredito, Entero_Cero);
		SET Var_SigFecha					:= DATE_ADD(Var_FechaSistema, INTERVAL Entero_Uno DAY);
		SET Var_FecApl						:= Var_FechaSistema;

		SELECT		COUNT(CreditoID)
			INTO	Var_ContadorCre
			FROM	TMPGENERAINTERESACCESORIOS;

		SET Var_Contador	:= Entero_Cero;

		IF (Var_ContadorCre > Entero_Cero) THEN

			IteraAccesorios: WHILE Var_Contador < Var_ContadorCre DO

				SET Var_CreditoID		:= Entero_Cero;
				SET Var_AmortizacionID	:= Entero_Cero;
				SET Var_FechaInicio		:= Fecha_Vacia;
				SET Var_FechaVencim		:= Fecha_Vacia;
				SET Var_FechaExigible	:= Fecha_Vacia;
				SET Var_EmpresaID		:= Entero_Cero;
				SET Var_FormulaID		:= Entero_Cero;
				SET Var_TasaFija		:= Entero_Cero;
				SET Var_MonedaID		:= Entero_Cero;
				SET Var_Estatus			:= Cadena_Vacia;
				SET Var_SucCliente		:= Entero_Cero;
				SET Var_ProdCreID		:= Entero_Cero;
				SET Var_ClasifCre		:= Cadena_Vacia;
				SET Var_SubClasifID		:= Entero_Cero;
				SET Var_SucursalCred	:= Entero_Cero;
				SET Var_TipoCalInt		:= Entero_Cero;
				SET Var_ConvNomID		:= Entero_Cero;
				SET Var_DevengaNomina	:= Cadena_Vacia;
				SET Var_AccesorioID		:= Entero_Cero;
				SET Var_MontoAccesorio	:= Entero_Cero;

				SET InterXdia			:= Entero_Cero;
				SET Var_ValorTasa		:= Entero_Cero;
				SET Var_Intere			:= Entero_Cero;

				SET Var_AbrevAccesorio	:= Cadena_Vacia;
				SET Var_ConceptoCartera	:= Entero_Cero;
				SET Var_CreditoStr		:= Cadena_Vacia;
				SET Var_CobraAccesorios	:= Cadena_Vacia;
				SET Var_DescConcepto	:= Cadena_Vacia;
				SET Ref_GenAccesorios	:= Cadena_Vacia;
				SET Var_MontoInteres	:= Entero_Cero;
				SET Var_SaldoInteres	:= Entero_Cero;

				SET Var_UltimoDia 		:= NO_UltimoDia;

				SELECT		CreditoID,			AmortizacionID,			FechaInicio,			FechaVencimiento,		FechaExigible,
							EmpresaID,			CalcInteresID,			TasaFija,				MonedaID,				Estatus,
							SucursalOrigen,		ProducCreditoID,		Clasificacion,			SubClasifID,			SucursalID,
							TipoCalInteres,		ConvenioNominaID,		DevengaNomina,			AccesorioID,			MontoAccesorio,
							MontoInteres,		SaldoInteres,			CobraAccesorios
					INTO	Var_CreditoID,		Var_AmortizacionID,		Var_FechaInicio, 		Var_FechaVencim,		Var_FechaExigible,
							Var_EmpresaID,		Var_FormulaID,			Var_TasaFija,			Var_MonedaID,			Var_Estatus,
							Var_SucCliente,		Var_ProdCreID,			Var_ClasifCre,			Var_SubClasifID,		Var_SucursalCred,
							Var_TipoCalInt,		Var_ConvNomID,			Var_DevengaNomina,		Var_AccesorioID,		Var_MontoAccesorio,
							Var_MontoInteres,	Var_SaldoInteres,		Var_CobraAccesorios
					FROM	TMPGENERAINTERESACCESORIOS
					LIMIT	Var_Contador, Entero_Uno;

				SET Var_CreditoID		:= IFNULL(Var_CreditoID, Entero_Cero);
				SET Var_AmortizacionID	:= IFNULL(Var_AmortizacionID, Entero_Cero);
				SET Var_FechaInicio		:= IFNULL(Var_FechaInicio, Fecha_Vacia);
				SET Var_FechaVencim		:= IFNULL(Var_FechaVencim, Fecha_Vacia);
				SET Var_FechaExigible	:= IFNULL(Var_FechaExigible, Fecha_Vacia);
				SET Var_EmpresaID		:= IFNULL(Var_EmpresaID, Entero_Cero);
				SET Var_FormulaID		:= IFNULL(Var_FormulaID, Entero_Cero);
				SET Var_TasaFija		:= IFNULL(Var_TasaFija, Entero_Cero);
				SET Var_MonedaID		:= IFNULL(Var_MonedaID, Entero_Cero);
				SET Var_Estatus			:= IFNULL(Var_Estatus, Cadena_Vacia);
				SET Var_SucCliente		:= IFNULL(Var_SucCliente, Entero_Cero);
				SET Var_ProdCreID		:= IFNULL(Var_ProdCreID, Entero_Cero);
				SET Var_ClasifCre		:= IFNULL(Var_ClasifCre, Cadena_Vacia);
				SET Var_SubClasifID		:= IFNULL(Var_SubClasifID, Entero_Cero);
				SET Var_SucursalCred	:= IFNULL(Var_SucursalCred, Entero_Cero);
				SET Var_TipoCalInt		:= IFNULL(Var_TipoCalInt, Entero_Cero);
				SET Var_ConvNomID		:= IFNULL(Var_ConvNomID, Entero_Cero);
				SET Var_DevengaNomina	:= IFNULL(Var_DevengaNomina, Cadena_Vacia);
				SET Var_AccesorioID		:= IFNULL(Var_AccesorioID, Entero_Cero);
				SET Var_MontoAccesorio	:= IFNULL(Var_MontoAccesorio, Entero_Cero);
				SET Var_CobraAccesorios	:= IFNULL(Var_CobraAccesorios, Cadena_Vacia);
				SET Var_MontoInteres	:= IFNULL(Var_MontoInteres, Entero_Cero);
				SET Var_SaldoInteres	:= IFNULL(Var_SaldoInteres, Entero_Cero);

				SET Var_Intere	:= ROUND(Var_MontoInteres - Var_SaldoInteres, 2);

				SET Var_Intere	:= IFNULL(Var_Intere, Entero_Cero);

				IF(Var_CobraAccesorios = Var_SI AND Var_Intere > Entero_Cero) THEN

					SELECT		ACC.NombreCorto
						INTO	Var_AbrevAccesorio
						FROM	DETALLEACCESORIOS DET
						INNER JOIN ACCESORIOSCRED ACC ON DET.AccesorioID = ACC.AccesorioID
						WHERE DET.CreditoID = Var_CreditoID
						  AND DET.AccesorioID = Var_AccesorioID
						LIMIT Entero_Uno;

					SET Var_AbrevAccesorio	:= IFNULL(Var_AbrevAccesorio, Cadena_Vacia);
					SET Var_DescConcepto	:= CONCAT(Var_TextoDevengam, Var_AbrevAccesorio);

					SELECT		ConceptoCarID
						INTO	Var_ConceptoCartera
						FROM	CONCEPTOSCARTERA
						WHERE	Descripcion = Var_DescConcepto;

					SET Var_ConceptoCartera	:= IFNULL(Var_ConceptoCartera, Entero_Cero);

					-- Si existe el concepto para ese accesorio
					IF (Var_ConceptoCartera > Entero_Cero) THEN

						SET Ref_GenAccesorios	:= CONCAT('INTERES OTRAS COMISIONES ' , Var_AbrevAccesorio);
						SET Var_DescAccesorio	:= CONCAT('INTERES ACCESORIOS CREDITO ', Var_AbrevAccesorio);
						SET Ref_GenAccesorios	:= IFNULL(Ref_GenAccesorios, Cadena_Vacia);

						-- Cargo
						CALL CONTACCESORIOSCREDPRO (
							Var_CreditoID,			Var_AmortizacionID,			Var_AccesorioID,		Entero_Cero,			Entero_Cero,
							Var_FechaSistema,		Var_FecApl,					Var_Intere,				Var_MonedaID,			Var_ProdCreID,
							Var_ClasifCre,			Var_SubClasifID, 			Var_SucCliente,			Var_DescAccesorio, 		Ref_GenAccesorios,
							AltaPoliza_NO,			Entero_Cero,				Var_Poliza, 			Var_SI,					AltaMovCre_SI,
							Var_ConceptoCartera,	Var_TipoMovIntAcc,			Nat_Cargo,				Var_No,					Cadena_Vacia,
							Cadena_Vacia, 			Cadena_Vacia,				Var_No,					Par_NumErr,				Par_ErrMen,
							Par_Consecutivo,		Par_EmpresaID,				Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
							Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,	 		Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							-- SET Error_Key	:= 99;
							LEAVE ManejoErrores;
						END IF;

						-- Abono
						CALL CONTACCESORIOSCREDPRO (
							Var_CreditoID,			Var_AmortizacionID,			Var_AccesorioID,		Entero_Cero,			Entero_Cero,
							Var_FechaSistema,		Var_FecApl,					Var_Intere,				Var_MonedaID,			Var_ProdCreID,
							Var_ClasifCre,			Var_SubClasifID, 			Var_SucCliente,			Var_DescAccesorio, 		Ref_GenAccesorios,
							AltaPoliza_NO,			Entero_Cero,				Var_Poliza, 			Var_SI,					AltaMovCre_NO,
							Con_IntDeven,			Entero_Cero, 				Nat_Abono,				Var_No,					Cadena_Vacia,
							Cadena_Vacia, 			Cadena_Vacia,				Var_No,					Par_NumErr,				Par_ErrMen,
							Par_Consecutivo,		Par_EmpresaID,				Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
							Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,	 		Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							-- SET Error_Key	:= 99;
							LEAVE ManejoErrores;
						END IF;

						UPDATE DETALLEACCESORIOS SET
							NumProyInteres	= NumProyInteres + Entero_Uno
						WHERE CreditoID = Var_CreditoID
						  AND AccesorioID = Var_AccesorioID
						  AND AmortizacionID = Var_AmortizacionID;

					END IF;

				END IF;

				SET Var_CreditoStr := CONCAT(CONVERT(Var_CreditoID, CHAR), '-', CONVERT(Var_AmortizacionID, CHAR));

				SET Var_Contador	:= Var_Contador + Entero_Uno;

			END WHILE IteraAccesorios;

		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso de Devengamiento de Interes de Accesorios ejecutado Exitosamente';
		SET Var_Control	:= 'usuarioID';
	END ManejoErrores;

	-- DROP TEMPORARY TABLE IF EXISTS TMPGENERAINTERESACCESORIOS;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_NumErr				AS consecutivo;
	END IF;

END TerminaStore$$