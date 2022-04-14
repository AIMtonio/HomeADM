-- GENERAINTERECREPENDIENTEPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS GENERAINTERECREPENDIENTEPRO;

DELIMITER $$

CREATE PROCEDURE GENERAINTERECREPENDIENTEPRO(
	-- SP para poner al dia el interes ordinario de los creditos de nomina
	Par_Fecha							DATE,				-- Fecha de Generacion de Intereses

	Par_EmpresaID 						INT(11),			-- Parametros de auditoria
	Aud_Usuario							INT(11),			-- Parametros de auditoria
	Aud_FechaActual						DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP						VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID						VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal						INT(11), 			-- Parametros de auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Parametros de auditoria
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

	DECLARE Var_ProductoNomina			CHAR(1);			-- Indica si el producto de credito es de nomina
	DECLARE Var_MontoCredito			DECIMAL(14,2);		-- Monto original del credito

	DECLARE Var_DiasDiferencia			INT(11);			-- Numero de dias que han transcurrido desde el inicio de una cuota hasta el dia actual
	DECLARE Var_ContAmort				INT(11);			-- Variable contador para el ciclo de las amortizaciones
	DECLARE Var_Refinancia				CHAR(1);			-- Indica si el credito refinancia
	DECLARE Var_ExcepAjusteIntCreMigr	CHAR(1);   			-- Define si se ajusta o no el interes devengado con lo pactado en las amortizaciones de los creditos migrados. S = Si, N = No

	DECLARE Par_Salida					CHAR(1);
	DECLARE Par_NumErr					INT(11);
	DECLARE Par_ErrMen					VARCHAR(400);

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

	DECLARE Var_EstActualizado			CHAR(1);			-- Indica si el estatus de instalacion de nomina es A : Actualizado

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
	SET Ref_GenInt						:= 'GENERACION INTERES';
	SET Aud_ProgramaID					:= 'GENERAINTERECREPENDIENTEPRO';

	SET Des_ErrorGral					:= 'ERROR DE SQL GENERAL';
	SET Des_ErrorLlavDup				:= 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET Des_ErrorCallSP					:= 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET Des_ErrorValNulos				:= 'ERROR VALORES NULOS';
	SET Var_LlaveParametro				:= 'ManejaCovenioNomina';	-- Maneje convenios nomina
	SET Var_SI							:= 'S';
	SET Var_No							:= 'N';

	SET Var_EstActualizado				:= 'A';				-- Indica si el estatus de instalacion de nomina es A : Actualizado

	SET Par_Salida						:= 'N';

	ManejoErrores: BEGIN

		DROP TEMPORARY TABLE IF EXISTS TMPPUESTAALDIAINTERESORD;
		CREATE TEMPORARY TABLE TMPPUESTAALDIAINTERESORD (
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
			ProductoNomina		CHAR(1),
			SaldoCapVigent		DECIMAL(14,2),
			SaldCapVenNoExi		DECIMAL(14,2),
			Interes				DECIMAL(14,2),
			SaldoInteresPro		DECIMAL(14,2),
			SaldoIntNoConta		DECIMAL(14,2),
			SaldoInteresVen		DECIMAL(14,2),
			Refinancia			CHAR(1),
			MontoCredito		DECIMAL(14,2),
			InteresRefinanciar	DECIMAL(14,2),
			PRIMARY KEY (CreditoID, AmortizacionID)
		);

		INSERT INTO TMPPUESTAALDIAINTERESORD (
						CreditoID,				AmortizacionID,			FechaInicio,			FechaVencimiento,		FechaExigible,
						EmpresaID,				CalcInteresID,			TasaFija,				MonedaID,				Estatus,
						SucursalOrigen,			ProducCreditoID,		Clasificacion,			SubClasifID,			SucursalID,
						TipoCalInteres,			ProductoNomina,			SaldoCapVigent,			SaldCapVenNoExi,		Interes,
						SaldoInteresPro,		SaldoIntNoConta,		SaldoInteresVen,		Refinancia,				MontoCredito,
						InteresRefinanciar	)
			SELECT		CRE.CreditoID,			AMO.AmortizacionID,		AMO.FechaInicio,		AMO.FechaVencim,		AMO.FechaExigible,
						CRE.EmpresaID,			CRE.CalcInteresID,		CRE.TasaFija,			CRE.MonedaID,			CRE.Estatus,
						CLI.SucursalOrigen,		CRE.ProductoCreditoID,	DES.Clasificacion,		DES.SubClasifID,        CRE.SucursalID,
						CRE.TipoCalInteres,		Cadena_Vacia,			CRE.SaldoCapVigent,		CRE.SaldCapVenNoExi,	AMO.Interes,
						AMO.SaldoInteresPro,	AMO.SaldoIntNoConta,	AMO.SaldoInteresVen,	CRE.Refinancia,			CRE.MontoCredito,
						CRE.InteresRefinanciar
				FROM	CREDITOS CRE
				INNER JOIN AMORTICREDITO AMO	ON CRE.CreditoID = AMO.CreditoID
											   AND AMO.FechaInicio <= Par_Fecha
											   AND IFNULL(AMO.NumProyInteres, Entero_Cero) = Entero_Cero
											   AND AMO.Estatus IN (Estatus_Vigente, Estatus_Vencida)
				INNER JOIN CLIENTES CLI			ON CRE.ClienteID = CLI.ClienteID
				INNER JOIN DESTINOSCREDITO DES	ON CRE.DestinoCreID = DES.DestinoCreID
				WHERE CRE.Estatus IN (Estatus_Vigente, Estatus_Vencida)
				  AND CRE.EstatusNomina = Var_EstActualizado
				  AND CRE.DevengaNomina = Var_No
				  AND CRE.TipoCalInteres = Int_SalGlobal;

		SELECT		COUNT(CreditoID)
			INTO	Var_ContadorCre
			FROM	TMPPUESTAALDIAINTERESORD;

		SET Var_Contador	:= Entero_Cero;

		IF (Var_ContadorCre > Entero_Cero) THEN

			SELECT		DiasCredito
				INTO	Var_DiasCredito
				FROM	PARAMETROSSIS;

			SELECT		ValorParametro
				INTO	Var_ManejaConvenio
				FROM	PARAMGENERALES
				WHERE	LlaveParametro = Var_LlaveParametro;

			SELECT		ValorParametro
				INTO	Var_ExcepAjusteIntCreMigr
				FROM	PARAMGENERALES
				WHERE	LlaveParametro = LlaveExcepAjusteIntCreMigrado;

			-- Inicializacion de variables globales
			SET Var_ManejaConvenio				:= IFNULL(Var_ManejaConvenio, Var_No);
			SET Var_ExcepAjusteIntCreMigr		:= IFNULL(Var_ExcepAjusteIntCreMigr, Var_No);
			SET Var_DiasCredito					:= IFNULL(Var_DiasCredito, Entero_Cero);
			SET Var_SigFecha					:= DATE_ADD(Par_Fecha, INTERVAL Entero_Uno DAY);
			SET Var_FecApl						:= Par_Fecha;
			SET Var_FechaFinMes					:= (SELECT LAST_DAY(Par_Fecha));
			SET Var_FechaFinMes					:= IFNULL(Var_FechaFinMes, Fecha_Vacia);
			SET Mov_AboConta					:= Con_IngreInt;
			SET Mov_CarConta					:= Con_IntDeven;
			SET Mov_CarOpera					:= Mov_IntPro;

			CALL MAESTROPOLIZAALT(
				Var_Poliza,			Par_EmpresaID,		Var_FecApl,			Pol_Automatica,		Con_GenIntere,
				Ref_GenInt,			Par_SalidaNO,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IteraTabla: WHILE Var_Contador < Var_ContadorCre DO

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
				SET Var_ProductoNomina	:= Cadena_Vacia;
				SET Var_CreCapVNE		:= Entero_Cero;
				SET Var_Interes			:= Entero_Cero;
				SET Var_SalIntPro		:= Entero_Cero;
				SET Var_SalIntNoC		:= Entero_Cero;
				SET Var_SalIntVen		:= Entero_Cero;
				SET Var_Refinancia		:= Cadena_Vacia;
				SET Var_MontoCredito	:= Entero_Cero;
				SET Var_InteresRef		:= Entero_Cero;
				SET InterXdia			:= Entero_Cero;
				SET Var_ValorTasa		:= Entero_Cero;
				SET Var_Intere			:= Entero_Cero;
				SET SalCapital			:= Entero_Cero;
				SET Var_CapAju			:= Entero_Cero;
				SET Var_AbrevAccesorio	:= Cadena_Vacia;
				SET Var_ConceptoCartera	:= Entero_Cero;
				SET Var_CreditoStr		:= Cadena_Vacia;
				SET Var_CobraAccesorios	:= Cadena_Vacia;
				SET Var_DescConcepto	:= Cadena_Vacia;
				SET Ref_GenAccesorios	:= Cadena_Vacia;
				SET Var_MontoInteres	:= Entero_Cero;
				SET Var_SaldoInteres	:= Entero_Cero;
				SET Nuevo_Interes		:= Entero_Cero;
				SET Var_CreCapVig		:= Entero_Cero;


				SELECT		CreditoID,			AmortizacionID,			FechaInicio,			FechaVencimiento,		FechaExigible,
							EmpresaID,			CalcInteresID,			TasaFija,				MonedaID,				Estatus,
							SucursalOrigen,		ProducCreditoID,		Clasificacion,			SubClasifID,			SucursalID,
							TipoCalInteres,		ProductoNomina,			SaldoCapVigent,			SaldCapVenNoExi,		Interes,
							SaldoInteresPro,	SaldoIntNoConta,		SaldoInteresVen,		Refinancia,				MontoCredito,
							InteresRefinanciar
					INTO	Var_CreditoID,		Var_AmortizacionID,		Var_FechaInicio, 		Var_FechaVencim,		Var_FechaExigible,
							Var_EmpresaID,		Var_FormulaID,			Var_TasaFija,			Var_MonedaID,			Var_Estatus,
							Var_SucCliente,		Var_ProdCreID,			Var_ClasifCre,			Var_SubClasifID,		Var_SucursalCred,
							Var_TipoCalInt,		Var_ProductoNomina,		Var_CreCapVig,			Var_CreCapVNE,			Var_Interes,
							Var_SalIntPro,		Var_SalIntNoC,			Var_SalIntVen,			Var_Refinancia,			Var_MontoCredito,
							Var_InteresRef
					FROM	TMPPUESTAALDIAINTERESORD
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
				SET Var_ProductoNomina	:= IFNULL(Var_ProductoNomina, Var_No);
				SET Var_CreCapVig		:= IFNULL(Var_CreCapVig, Entero_Cero);
				SET Var_CreCapVNE		:= IFNULL(Var_CreCapVNE, Entero_Cero);
				SET Var_Interes			:= IFNULL(Var_Interes, Entero_Cero);
				SET Var_SalIntPro		:= IFNULL(Var_SalIntPro, Entero_Cero);
				SET Var_SalIntNoC		:= IFNULL(Var_SalIntNoC, Entero_Cero);
				SET Var_SalIntVen		:= IFNULL(Var_SalIntVen, Entero_Cero);
				SET Var_Refinancia		:= IFNULL(Var_Refinancia, Cadena_Vacia);
				SET Var_MontoCredito	:= IFNULL(Var_MontoCredito, Entero_Cero);
				SET Var_InteresRef		:= IFNULL(Var_InteresRef, Entero_Cero);

				IF (Par_Fecha < Var_FechaVencim) THEN

					SET Var_DiasDiferencia	:= DATEDIFF(Par_Fecha, Var_FechaInicio);

				ELSE

					SET Var_DiasDiferencia	:= DATEDIFF(Var_FechaVencim, Var_FechaInicio);

				END IF;

				SET Var_DiasDiferencia	:= IFNULL(Var_DiasDiferencia, Entero_Cero);

				IF (Var_DiasDiferencia	> Entero_Cero) THEN

					SET Var_ContAmort	:= Entero_Cero;

					IteraDiasDif: WHILE Var_ContAmort < Var_DiasDiferencia DO

						SET SalCapital		:= Entero_Cero;
						SET Var_CreCapVig	:= Entero_Cero;
						SET Var_CreCapVNE	:= Entero_Cero;
						SET Var_InteresRef	:= Entero_Cero;
						SET Var_Intere		:= Entero_Cero;
						SET Nuevo_Interes	:= Entero_Cero;
						SET Var_SalIntPro	:= Entero_Cero;
						SET Var_SalIntVen	:= Entero_Cero;
						SET Var_SalIntNoC	:= Entero_Cero;

						SELECT		SaldoCapVigent,		SaldCapVenNoExi,	InteresRefinanciar
							INTO	Var_CreCapVig,		Var_CreCapVNE,		Var_InteresRef
							FROM	CREDITOS
							WHERE	CreditoID = Var_CreditoID;

						SET Var_CreCapVig		:= IFNULL(Var_CreCapVig, Entero_Cero);
						SET Var_CreCapVNE		:= IFNULL(Var_CreCapVNE, Entero_Cero);
						SET Var_InteresRef		:= IFNULL(Var_InteresRef, Entero_Cero);

						SET SalCapital := Var_CreCapVig + Var_CreCapVNE;

						SET Var_CapAju  := (SELECT		IFNULL(SUM(SaldoCapVigente + SaldoCapVenNExi), Decimal_Cero)
												FROM	AMORTICREDITO
												WHERE	CreditoID		= Var_CreditoID
												  AND	AmortizacionID	< Var_AmortizacionID
												  AND	Estatus			!= Estatus_Pagada
												GROUP BY CreditoID);

						SET Var_CapAju := IFNULL(Var_CapAju, Entero_Cero);

						SET SalCapital := SalCapital - Var_CapAju;

						CALL CRECALCULOTASAPRO(
							Var_CreditoID,		Var_FormulaID,		Var_TasaFija,		Par_Fecha,			Var_FechaInicio,
							Var_EmpresaID,		Var_ValorTasa,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						IF(Var_Refinancia = Cons_SI) THEN

							-- Como el credito refinancia al saldo de capital se le suma el interes acumulado de meses anteriores
							SET SalCapital := SalCapital + Var_InteresRef;

						END IF;

						SELECT		SaldoInteresPro,	SaldoInteresVen,	SaldoIntNoConta
							INTO	Var_SalIntPro,		Var_SalIntVen,		Var_SalIntNoC
							FROM	AMORTICREDITO
							WHERE	AmortizacionID = Var_AmortizacionID
							  AND	CreditoID = Var_CreditoID;

						SET Var_SalIntPro	:= IFNULL(Var_SalIntPro, Entero_Cero);
						SET Var_SalIntVen	:= IFNULL(Var_SalIntVen, Entero_Cero);
						SET Var_SalIntNoC	:= IFNULL(Var_SalIntNoC, Entero_Cero);

						-- Se calcula el interes saldos globales
						IF(Var_TipoCalInt = Int_SalGlobal) THEN

							SET InterXdia		:= ROUND((Var_MontoCredito*Var_ValorTasa) / (Var_DiasCredito * Dec_Cien), 2);
							SET Var_Intere		:=  ROUND(InterXdia * DiasInteres, 2);

							SET Nuevo_Interes	:= ROUND(Var_Intere + IFNULL(Var_SalIntPro, Entero_Cero) +
																		IFNULL(Var_SalIntVen,Entero_Cero) +
																		IFNULL(Var_SalIntNoC, Entero_Cero), 2);

							IF(Nuevo_Interes > Var_Interes) THEN

								SET Nuevo_Interes := ROUND(Var_Interes - IFNULL(Var_SalIntPro, Entero_Cero) -
																			IFNULL(Var_SalIntVen,Entero_Cero) -
																			IFNULL(Var_SalIntNoC, Entero_Cero), 2);
							ELSE

								IF (Nuevo_Interes = Var_Interes) THEN
									SET Nuevo_Interes := Entero_Cero;
								END IF;

								IF (Nuevo_Interes < Var_Interes) THEN
									SET Nuevo_Interes := Var_Intere;
								END IF;

							END IF;

							SET Var_Intere	:= Nuevo_Interes;

							SET Var_Intere	:= IFNULL(Var_Intere, Entero_Cero);

						END IF;

						IF (Var_Intere > Entero_Cero) THEN

							CALL  CONTACREDITOPRO (
									Var_CreditoID,			Var_AmortizacionID,		Entero_Cero,			Entero_Cero,			Par_Fecha,
									Var_FecApl,				Var_Intere,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
									Var_SubClasifID,		Var_SucCliente,			Des_CieDia,				Ref_GenInt,				AltaPoliza_NO,
									Entero_Cero,			Var_Poliza,				AltaPolCre_SI,			AltaMovCre_SI,			Mov_CarConta,
									Mov_CarOpera,			Nat_Cargo,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
									Cadena_Vacia,			/*Par_SalidaNO,*/		Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
									Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Var_SucursalCred,		Aud_NumTransaccion);

							CALL  CONTACREDITOPRO (
									Var_CreditoID,			Var_AmortizacionID,		Entero_Cero,			Entero_Cero,			Par_Fecha,
									Var_FecApl,				Var_Intere,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
									Var_SubClasifID,		Var_SucCliente,			Des_CieDia,				Ref_GenInt,				AltaPoliza_NO,
									Entero_Cero,			Var_Poliza,				AltaPolCre_SI,			AltaMovCre_NO,			Mov_AboConta,
									Entero_Cero,			Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
									Cadena_Vacia,			/*Par_SalidaNO,*/		Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
									Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Var_SucursalCred,		Aud_NumTransaccion);

							IF(Var_Refinancia = Var_SI) THEN

								-- Se actualiza el campo Interes Acumulado de la tabla de CREDITOS esto con el fin de mantener el interes que se va acumulando diariamente
								UPDATE CREDITOS SET
									InteresAcumulado	= InteresAcumulado + Var_Intere
								WHERE CreditoID			= Var_CreditoID;

								-- Si la fecha es un fin de mes, se actualiza el campo InteresRefinanciar con el valor de InteresAcumulado
								-- (lo que se ha ido acumulando hasta el fin de mes
								IF(Par_Fecha = Var_FechaFinMes) THEN

									UPDATE CREDITOS SET
										InteresRefinanciar	= InteresAcumulado
									WHERE CreditoID			= Var_CreditoID;

								END IF;

							END IF;
						END IF;

						SET Var_ContAmort	:= Var_ContAmort + Entero_Uno;

					END WHILE IteraDiasDif;

				END IF;

				IF (Var_FechaVencim >= Par_Fecha) THEN

					UPDATE CREDITOS CRE
					SET	DevengaNomina	= Var_SI,
						EmpresaID		= Par_EmpresaID,
						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE CreditoID		= Var_CreditoID;

				END IF;

				SET Var_CreditoStr := CONCAT(CONVERT(Var_CreditoID, CHAR), '-', CONVERT(Var_AmortizacionID, CHAR));

				SET Var_Contador	:= Var_Contador + Entero_Uno;

			END WHILE IteraTabla;

		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso de Devengamiento de Interes de Accesorios ejecutado Exitosamente';
		SET Var_Control	:= 'usuarioID';
	END ManejoErrores;

	DROP TEMPORARY TABLE IF EXISTS TMPPUESTAALDIAINTERESORD;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_NumErr				AS consecutivo;
	END IF;

END TerminaStore$$