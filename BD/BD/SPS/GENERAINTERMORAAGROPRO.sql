-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAINTERMORAAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERAINTERMORAAGROPRO`;
DELIMITER $$


CREATE PROCEDURE `GENERAINTERMORAAGROPRO`(
/* SP QUE RECALCULA LOS INTERESES MORATORIOS DE AMORTIZACIONES ATRASADAS EN CREDITOS AGRO */

    Par_Fecha           DATE,			# Fecha de Ministracion
    Par_CreditoID		BIGINT(20),		# Numero de credito
    Par_Monto			DECIMAL(18,2),	# Monto Pendiente desembolsado

    /*Parametros de Auditoria */
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
			)

TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_CreditoID		BIGINT(12);		# Numero de credito
	DECLARE Var_AmortizacionID	INT(11);		# Numero de amortizacion
	DECLARE Var_FechaInicio		DATE;			# Fecha de inicio de la amotizacion
	DECLARE Var_FechaVencim		DATE;			# Fecha de vencimiento de la amortizacion
	DECLARE Var_FechaExigible   DATE;			# Fecha exigible de la amortizacion
	DECLARE Var_EmpresaID		INT(11);		# Numero de empresa
	DECLARE Var_CreCapVig		DECIMAL(14,2);	# Capital vigente del credito
	DECLARE Var_AmoCapVig		DECIMAL(14,2);	# Capital vigente de la amortizacion
	DECLARE Var_AmoCapVNE		DECIMAL(14,2);	# Capital vencido no exigible de la amortizacion
	DECLARE Var_FormulaID 		INT(11);		# Formula(Tasa)
	DECLARE Var_TasaFija 		DECIMAL(12,4);	# Valor tasa fija
	DECLARE Var_MonedaID		INT(11);		# Moneda ID
	DECLARE Var_Estatus			CHAR(1);		# Estatus del credito
	DECLARE Var_StatuAmort		CHAR(1);		# Esatus de la amortizacion
	DECLARE Var_SucCliente	  	INT(11);		# Sucursal del cliente
	DECLARE Var_ProdCreID		INT(11);		# Numero de producto de credito
	DECLARE Var_ClasifCre       CHAR(1);		# Clasifiacion del destino de credito
	DECLARE Var_FactorMora		DECIMAL(10,4);	# Factor moratorio
	DECLARE Var_ValorTasa		DECIMAL(12,4);	# Valor de la tasa
	DECLARE Var_DiasCredito		DECIMAL(10,2);	# Dias (PARAMETROSSIS)
	DECLARE Var_IntereMor		DECIMAL(12,4);	# Valor del interes moratorio
	DECLARE Var_IntProvis		DECIMAL(14,4);	# Valor interes provisionado
	DECLARE Var_IntAtrasado		DECIMAL(14,4);	# Valor interes atrasado
	DECLARE Var_IntVencido		DECIMAL(14,4);	# Valor interes vencido
	DECLARE Var_FecMorato		DATE;			# Fecha de cobro de moratorios
	DECLARE Var_CobraMora       CHAR(1);		# Cobra Moratorio
	DECLARE Var_TipCobComMor    CHAR(1);		# Tipo de forma de cobro de moratorios
	DECLARE Var_FecApl          DATE;			# Fecha de apliacion
	DECLARE Var_EsHabil         CHAR(1);		# Es dia habil
	DECLARE SalCapital          DECIMAL(14,2);	# Saldo de Capital

	DECLARE DiasInteres         DECIMAL(10,2);	# Dias de interes
	DECLARE Ref_GenInt          VARCHAR(50);
	DECLARE Mov_AboConta		INT(11);		# Movimiento Abono Contable
	DECLARE Mov_CarConta		INT(11);		# Movimiento Cargo Contable
	DECLARE Mov_CarOpera		INT(11);		# Movimiento Cargo Operativo
	DECLARE Mov_AboOpera		INT(11);		# Movimiento Abono Operativo
	DECLARE Var_Poliza          BIGINT;			# Numero de Poliza
	DECLARE Par_NumErr          INT(11);		# Numero de Error
	DECLARE Par_ErrMen          VARCHAR(100);	# Mensaje de Error
	DECLARE Par_Consecutivo     BIGINT;			# Consecutivo
	DECLARE Var_ContadorCre     INT(11);		# Numero de registros
	DECLARE Var_DifMorMov       DECIMAL(14,2);  # almacena el valor del abonos - cargos  de los movimientos cuando se cobra mora y los dias de gracia ya vencieron
	DECLARE Var_SubClasifID     INT(11);		# Subclasificacion(Destino de Credito)
	DECLARE Var_SucursalCred	INT(11);		# Sucursal del credito
	DECLARE	Var_TipoContaMora	CHAR(1);		# Tipo de contabilizacion del interes moratorio


	/* Declaracion de Constantes */
	DECLARE Estatus_Vigente 	CHAR(1);
	DECLARE Estatus_Vencida 	CHAR(1);
	DECLARE Estatus_Atrasado  	CHAR(1);
	DECLARE Cre_Vencido     	CHAR(1);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Decimal_Cero    	DECIMAL(12, 2);
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Nat_Abono       	CHAR(1);
	DECLARE Dec_Cien        	DECIMAL(10,2);
	DECLARE Com_MonOriCap   	CHAR(1);
	DECLARE Com_MonOriTot   	CHAR(1);
	DECLARE Com_SaldoAmo    	CHAR(1);
	DECLARE Pro_PasoAtras   	INT(11);
	DECLARE Mov_MoraVigen 		INT(11);
	DECLARE Mov_MoraCarVen 		INT(11);
	DECLARE Mov_CapAtrasado 	INT(11);
	DECLARE Mov_CapVigente  	INT(11);
	DECLARE Mov_CapVencido  	INT(11);
	DECLARE Mov_ComFalPago  	INT(11);
	DECLARE Mov_InterPro    	INT(11);
	DECLARE Mov_IntAtras    	INT(11);
	DECLARE Mov_IntVencido  	INT(11);
	DECLARE Mov_CapVenNoEx  	INT(11);
	DECLARE Con_CueOrdMor   	INT(11);
	DECLARE Con_CorOrdMor   	INT(11);
	DECLARE Con_MoraDeven   	INT(11);
	DECLARE Con_MoraIngreso		INT(11);
	DECLARE Con_CapVigente  	INT(11);
	DECLARE Con_CapAtrasado 	INT(11);
	DECLARE Con_CapVencido  	INT(11);
	DECLARE Con_CueOrdComFP 	INT(11);
	DECLARE Con_CorOrdComFP 	INT(11);
	DECLARE Con_IntDevVig   	INT(11);
	DECLARE Con_IntAtrasado 	INT(11);
	DECLARE Con_IntVencido  	INT(11);
	DECLARE Con_CapVenNoEx  	INT(11);
	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE Con_GenIntere   	INT(11);
	DECLARE Par_SalidaNO    	CHAR(1);
	DECLARE AltaPoliza_NO   	CHAR(1);
	DECLARE AltaPolCre_SI   	CHAR(1);
	DECLARE AltaMovCre_SI   	CHAR(1);
	DECLARE AltaMovCre_NO   	CHAR(1);
	DECLARE AltaMovAho_NO   	CHAR(1);
	DECLARE DescMinis      		VARCHAR(100);
	DECLARE TipoMovCapOrd   	INT(11);
	DECLARE TipoMovCapAtr   	INT(11);
	DECLARE TipoMovCapVen   	INT(11);
	DECLARE TipoMovCapVN    	INT(11);
	DECLARE No_EsReestruc   	CHAR(1);
	DECLARE Si_EsReestruc   	CHAR(1);
	DECLARE Si_Regulariza   	CHAR(1);
	DECLARE No_Regulariza   	CHAR(1);
	DECLARE Act_PagoSost    	INT(11);
	DECLARE SI_CobraMora    	CHAR(1);
	DECLARE SI_Prorratea    	CHAR(1);
	DECLARE Inte_Activo     	CHAR(1);
	DECLARE Per_Diario     	 	CHAR(1);
	DECLARE Per_Evento      	CHAR(1);
	DECLARE Por_Amorti      	CHAR(1);
	DECLARE Por_Credito     	CHAR(1);
	DECLARE Mora_CtaOrden		CHAR(1);
    DECLARE Mora_NVeces         CHAR(1);
	DECLARE Mora_TasaFija       CHAR(1);
	DECLARE Des_ErrorGral      	VARCHAR(100);
	DECLARE Des_ErrorLlavDup    VARCHAR(100);
	DECLARE Des_ErrorCallSP     VARCHAR(100);
	DECLARE Des_ErrorValNulos   VARCHAR(100);


	/* Asignacion de Constantes */
	SET Estatus_Vigente 	:= 'V';             -- Estatus Amortizacion: Vigente
	SET Estatus_Vencida 	:= 'B';             -- Estatus Amortizacion: Vencido
	SET Estatus_Atrasado	:= 'A';             -- Estatus Amortizacion: Atrasado
	SET Cre_Vencido     	:= 'B';             -- Estatus Credito: Vencido
	SET Cadena_Vacia    	:= '';                  -- Cadena Vacia
	SET Fecha_Vacia     	:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero     	:= 0;               -- Entero en Cero
	SET Decimal_Cero    	:= 0.00;            -- Decimal Cero
	SET Nat_Cargo       	:= 'C';             -- Naturaleza de Cargo
	SET Nat_Abono       	:= 'A';             -- Naturaleza de Cargo
	SET Dec_Cien        	:= 100.00;			-- Decimal Cien
	SET Com_MonOriCap   	:= 'C';				-- Criterio Comision: Monto Original de la Cuota Capital
	SET Com_MonOriTot   	:= 'T';             -- Criterio Comision: Monto Original de la Cuota Capital + Int + IVA
	SET Com_SaldoAmo    	:= 'S';             -- Criterio Comision: Saldo de la Cuota
	SET Mora_NVeces     	:= 'N';             -- Tipo de Cobro de Moratorios: N Veces la Tasa Ordinaria
	SET Mora_TasaFija   	:= 'T';             -- Tipo de Cobro de Moratorios: Tasa Fija Anualizada
	SET Pro_PasoAtras   	:= 202;             -- Numero de Proceso Batch: Trapsaso a Atrasado
	SET Mov_MoraVigen 		:= 15;              -- Tipo de Movimiento de Credito: Moratorios
	SET	Mov_MoraCarVen		:= 17;				-- Tipo de Movimiento de Credito: Moratorios de Cartera Vencida
	SET Mov_CapAtrasado 	:= 2;               -- Tipo de Movimiento de Credito: Capital Atrasado
	SET Mov_CapVigente  	:= 1;               -- Tipo de Movimiento de Credito: Capital Vigente
	SET Mov_ComFalPago  	:= 40;              -- Tipo de Movimiento de Credito: Comision x Falta de Pago
	SET Mov_InterPro    	:= 14;              -- Tipo de Movimiento de Credito: Interes Provisionado
	SET Mov_IntAtras    	:= 11;              -- Tipo de Movimiento de Credito: Interes Atrasado
	SET Mov_CapVencido  	:= 3;               -- Tipo de Movimiento de Credito: Interes Vencido
	SET Mov_IntVencido  	:= 12;      	    -- Tipo de Movimiento de Credito: Interes Vencido
	SET Mov_CapVenNoEx  	:= 4;               -- Tipo de Movimiento de Credito: Capital Vencido no Exigible
	SET Con_CueOrdMor   	:= 13;              -- Concepto Contable: Cuentas de Orden de Moratorios
	SET Con_CorOrdMor   	:= 14;              -- Concepto Contable: Correlativa de Orden de Moratorios
	SET Con_CueOrdComFP 	:= 15;	            -- Concepto Contable: Cuentas de Orden Comision Falta de Pago
	SET Con_CorOrdComFP 	:= 16;              -- Concepto Contable: Correlativa de Orden Comision Falta de Pago
	SET Con_MoraDeven   	:= 33;              -- Concepto Contable: Interes Moratorio Devengado
	SET Con_MoraIngreso		:= 6;				-- Concepto Contable: Ingreso por Interes Moratorio
	SET Con_CapVigente  	:= 1;               -- Concepto Contable: Capital Vigente
	SET Con_CapAtrasado 	:= 2;               -- Concepto Contable: Capital Atrasado
	SET Con_IntDevVig   	:= 19;              -- Concepto Contable: Interes Devengado
	SET Con_IntAtrasado 	:= 20;              -- Concepto Contable: Interes Atrasado
	SET Con_IntVencido  	:= 21;              -- Concepto Contable: Interes Vencido
	SET Con_CapVencido  	:= 3;               -- Concepto Contable: Capital Vigente
	SET Con_CapVenNoEx  	:= 4;               -- Concepto Contable: Capital Vencido No Exigible
	SET Pol_Automatica  	:= 'A';             -- Tipo de Poliza: Automatica
	SET Con_GenIntere   	:= 52;              -- Tipo de Proceso Contable: Generacion de Interes de Cartera
	SET Par_SalidaNO    	:= 'N';             -- El store no Arroja una Salida
	SET AltaPoliza_NO   	:= 'N';             -- Alta del Encabezado de la Poliza: NO
	SET AltaPolCre_SI   	:= 'S';             -- Alta de la Poliza de Credito: SI
	SET AltaMovCre_NO   	:= 'N';             -- Alta del Movimiento de Credito: SI
	SET AltaMovCre_SI   	:= 'S';             -- Alta del Movimiento de Credito: NO
	SET AltaMovAho_NO   	:= 'N';             -- Alta del Movimiento de Ahorro: NO
	SET SI_Prorratea    	:= 'S';             -- SI Prorratea la Comision por Falta de Pago
	SET Inte_Activo     	:= 'A';             -- Integrante Activo del Grupo
	SET Per_Diario      	:= 'D';             -- Periodiciad en el Cobro de FalPago: Diario
	SET Per_Evento      	:= 'C';             -- Periodiciad en el Cobro de FalPago: Por Evento o Atraso
	SET Por_Amorti      	:= 'A';             -- Tipo de Cobro de FalPago: Por Amortizacion
	SET Por_Credito     	:= 'C';             -- Tipo de Cobro de FalPago: Por Credito
	SET DescMinis      		:= 'DESEMBOLSO DE CREDITO';	-- Descripcion del proceso de ministracion
	SET Ref_GenInt      	:= 'GENERACION INTERES MORATORIO';

	SET TipoMovCapOrd   	:= 1;               -- Tipo de Movimiento de Credito: Capital Ordinario
	SET TipoMovCapAtr   	:= 2;               -- Tipo de Movimiento de Credito: Capital Atrasado
	SET TipoMovCapVen   	:= 3;               -- Tipo de Movimiento de Credito: Capital Vencido
	SET TipoMovCapVN    	:= 4;               -- Tipo de Movimiento de Credito: Capital Vencido No Exigible.

	SET No_EsReestruc       := 'N';             -- El Producto de Credito no es para Reestructuras
	SET Si_EsReestruc       := 'S';             -- El credito si es una Reestructura
	SET Si_Regulariza       := 'S';             -- La Reestructura ya fue Regularizada
	SET No_Regulariza       := 'N';             -- La Reestructura NO ha sido Regularizada
	SET Act_PagoSost        := 2;               -- Tipo de Actualizacion de la Reest: Pagos Sostenidos
	SET SI_CobraMora        := 'S';             -- Si Cobra Interes Moratorio
	SET Mora_CtaOrden		:= 'C';             -- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden

	SET Des_ErrorGral       := 'ERROR DE SQL GENERAL';
	SET Des_ErrorLlavDup    := 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET Des_ErrorCallSP     := 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET Des_ErrorValNulos   := 'ERROR VALORES NULOS';

	SELECT DiasCredito,	TipoContaMora INTO Var_DiasCredito, Var_TipoContaMora FROM PARAMETROSSIS;
	SET	Var_TipoContaMora	:= IFNULL(Var_TipoContaMora, Cadena_Vacia);

	TRUNCATE TABLE TMPCREDCIEMORAAGRO;
	INSERT INTO TMPCREDCIEMORAAGRO
    SELECT	Cre.CreditoID,			Amo.AmortizacionID,	Amo.FechaInicio,		Amo.FechaVencim,		Amo.FechaExigible,
			Cre.EmpresaID,			Cre.SaldoCapVigent,	Amo.SaldoCapVenNExi,	CalcInteresID,			Cre.TasaFija,
			Cre.MonedaID,			Cre.Estatus,		Cli.SucursalOrigen,		Cre.ProductoCreditoID,  Des.Clasificacion,
			Cre.FactorMora,			Amo.Estatus,		Amo.SaldoInteresPro,    Amo.SaldoInteresAtr,	Amo.SaldoInteresVen,
             -- Este Case se puso aqui, para discriminar y no evaluar aquellas amortizaciones
             -- muy Viejas (Cuya Fecha de Exigibilidad tiene mas de los Dias de gracia
             -- del producto mas 15 dias de "Colchon") para que no evalue la funcion FUNCIONDIAHABIL
             -- Esto para ayudar a mejorar el preformance del cierre y hacer menos evaluaciones.
             CASE WHEN Amo.FechaExigible < DATE_SUB(Par_Fecha, INTERVAL (GraciaMoratorios + 15 ) DAY) THEN
                        Amo.FechaExigible
                  ELSE
                        FUNCIONDIAHABIL(Amo.FechaExigible, GraciaMoratorios, Par_EmpresaID)
             END,
             Pro.CobraMora,			Cre.TipCobComMorato,	Cre.SolicitudCreditoID,	Des.SubClasifID,	Cre.SucursalID
            FROM AMORTICREDITO Amo,
                 CLIENTES Cli,
                 PRODUCTOSCREDITO Pro,
                 DESTINOSCREDITO Des,
                 CREDITOS Cre
          LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID
            WHERE Amo.CreditoID 	= Cre.CreditoID
              AND Cre.ClienteID		= Cli.ClienteID
              AND Cre.ProductoCreditoID	= Pro.ProducCreditoID
              AND Cre.DestinoCreID  = Des.DestinoCreID
			AND (Amo.Estatus		=  'V'
				OR Amo.Estatus		=  'A'
				OR Amo.Estatus		=  'B')
              AND (Cre.Estatus		=  'V'
				OR Cre.Estatus		=  'B')
              AND  Amo.FechaExigible <= Par_Fecha
              AND Amo.CreditoID 	= Par_CreditoID;


	SELECT  	CreditoID,			AmortizacionID,		FechaInicio,		FechaVencim,        FechaExigible,
				EmpresaID,			SaldoCapVigent,     SaldoCapVenNExi,    CalcInteresID,      TasaFija,
				MonedaID,			CreEstatus,         SucursalOrigen,     ProductoCreditoID,  TipoProduc,
				FactorMora,			AmoEstatus,         AmoSaldoInteresPro,	AmoSaldoInteresAtr, AmoSaldoInteresVen,
                AmoFecGraMora,		CobraMora,			TipCobComMorato, 	SubClasifID,        SucursalCredito
	INTO
			Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible,
			Var_EmpresaID,      Var_CreCapVig,      Var_AmoCapVNE,      Var_FormulaID,      Var_TasaFija,
			Var_MonedaID,       Var_Estatus,        Var_SucCliente,     Var_ProdCreID,      Var_ClasifCre,
			Var_FactorMora,     Var_StatuAmort,     Var_IntProvis,		Var_IntAtrasado,    Var_IntVencido,
            Var_FecMorato,      Var_CobraMora,    Var_TipCobComMor,     Var_SubClasifID,    Var_SucursalCred
    FROM TMPCREDCIEMORAAGRO
    WHERE ( AmoFecGraMora <= Par_Fecha);


	SET Var_FecApl	:= Par_Fecha;
	SELECT   COUNT(CreditoID) INTO Var_ContadorCre FROM TMPCREDCIEMORAAGRO;
	SET Var_ContadorCre := IFNULL(Var_ContadorCre, Entero_Cero);

	IF (Var_ContadorCre > Entero_Cero) THEN
		CALL MAESTROPOLIZAALT(
			Var_Poliza,		Par_EmpresaID,      Var_FecApl,     Pol_Automatica,		Con_GenIntere,
			Ref_GenInt,		Par_SalidaNO,       Aud_Usuario,    Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,       Aud_NumTransaccion);
	END IF;

    -- Inicializacion
    SET DiasInteres         := Entero_Cero;
    SET Var_IntereMor       := Entero_Cero;
    SET Var_ValorTasa       := Entero_Cero;
	SET	Var_SucursalCred	:= IFNULL(Var_SucursalCred, Aud_Sucursal);

    # ======================== GENERACION DE MORATORIOS ==============================
	 -- Generacion de Intereses moratorios
    IF(Var_FecMorato <= Par_Fecha AND Var_CobraMora = SI_CobraMora) THEN

		-- Verificamos como Registrar Operativa y Contablemente los moratorios, dependiendo lo que especifique en la parametrizacion
		-- Si se contabiliza en cuentas de orden o en cuentas de ingresos
		IF(Var_TipoContaMora = Mora_CtaOrden) THEN
			SET Mov_AboConta    := Con_CorOrdMor;
			SET Mov_CarConta    := Con_CueOrdMor;
			SET Mov_CarOpera    := Mov_MoraVigen;
		ELSE
			-- Verificamos si el Credito esta Vigente o Vencido, para saber como contabilizar
			IF( Var_Estatus = Estatus_Vigente) THEN
				SET Mov_AboConta    := Con_MoraIngreso;
				SET Mov_CarConta    := Con_MoraDeven;
				SET Mov_CarOpera    := Mov_MoraVigen;
			ELSE
				SET Mov_AboConta    := Con_CorOrdMor;
				SET Mov_CarConta    := Con_CueOrdMor;
				SET Mov_CarOpera    := Mov_MoraCarVen;
			END IF;
		END IF;

		SET SalCapital	:= IFNULL(Par_Monto,Decimal_Cero);

		CALL CRECALCULOTASAPRO(
			Var_CreditoID,  Var_FormulaID,  Var_TasaFija,   Par_Fecha,          Var_FechaInicio,
			Var_EmpresaID,  Var_ValorTasa,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion	);

		/*cuando el cliente no ha pagado y terminan sus dias de gracia, se generan los intereses
		  desde el primer dia de no pago hasta el dia de hoy. */
		IF (Var_TipCobComMor = Mora_NVeces) THEN
			SET Var_FactorMora  = Var_FactorMora * Var_ValorTasa;
		END IF;

			SET	DiasInteres		:= (SELECT DATEDIFF(Par_Fecha, Var_FechaExigible) );

			SET Var_IntereMor	:= (ROUND(SalCapital *  Var_FactorMora /
										(Var_DiasCredito * Dec_Cien) * DiasInteres, 2)  );

		-- se realizan los movimientos contables y operativos del cargo por interes moratorio
		IF (Var_IntereMor > Decimal_Cero) THEN
				CALL  CONTACREDITOPRO (
				Var_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,    	Par_Fecha,
				Var_FecApl,			Var_IntereMor,      Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     DescMinis,         	Ref_GenInt,     	AltaPoliza_NO,
				Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,  	Mov_CarConta,
				Mov_CarOpera,       Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		/*Par_SalidaNO,*/
				Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,  	Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
				Aud_NumTransaccion);

				CALL  CONTACREDITOPRO (
				Var_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,    	Par_Fecha,
				Var_FecApl,			Var_IntereMor,      Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     DescMinis,         	Ref_GenInt,     	AltaPoliza_NO,
				Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,  	Mov_AboConta,
				Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		/*Par_SalidaNO,*/
				Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,  	Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
				Aud_NumTransaccion  );


		END IF;  -- Endif de Var_IntereMor (Moratorios) mayor que cero
	END IF; -- EndIf Generacion de Intereses moratorios


TRUNCATE TABLE TMPCREDCIEMORAAGRO;

END TerminaStore$$