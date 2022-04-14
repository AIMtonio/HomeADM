-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDITOCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDITOCONTPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGOCREDITOCONTPRO`(
	--  ===================================================================
	--  - SP DE PROCESO QUE REALIZA EL PAGO DE CREDITO CONTINGENTES --
	--  ===================================================================
	Par_CreditoID			BIGINT(12),
	Par_CuentaAhoID			BIGINT(12),
	Par_MontoPagar			DECIMAL(14,2),
	Par_MonedaID			INT(11),
	Par_EsPrePago			CHAR(1),

	Par_Finiquito			CHAR(1),
	Par_EmpresaID			INT(11),
	Par_Salida				CHAR(1),
	Par_AltaEncPoliza		CHAR(1),
	INOUT Var_MontoPago		DECIMAL(14,2),

	INOUT Par_Poliza		BIGINT(20),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,
	Par_ModoPago			CHAR(1),
	Par_Origen				CHAR(1),
	/* Parametros de Auditoria */
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_ProgOriginalID			VARCHAR(50);
	DECLARE ConcepCtaOrdenDeu			INT;
	DECLARE ConcepCtaOrdenCor			INT;
	DECLARE Var_CreditoID 				BIGINT(12);
	DECLARE Var_AmortizacionID			INT(4);
	DECLARE Var_SaldoCapVigente			DECIMAL(12, 2);
	DECLARE Var_SaldoCapAtrasa			DECIMAL(12, 2);
	DECLARE Var_SaldoCapVencido			DECIMAL(12, 2);
	DECLARE Var_SaldoCapVenNExi			DECIMAL(12, 2);
	DECLARE Var_SaldoInteresOrd			DECIMAL(12, 4);
	DECLARE Var_SaldoInteresAtr			DECIMAL(12, 4);
	DECLARE Var_SaldoInteresVen			DECIMAL(12, 4);
	DECLARE Var_SaldoInteresPro			DECIMAL(12, 4);
	DECLARE Var_SaldoIntNoConta			DECIMAL(12, 4);
	DECLARE Var_SaldoMoratorios			DECIMAL(12, 2);
	DECLARE Var_SaldoMoraVenci			DECIMAL(12, 2);
	DECLARE Var_SaldoMoraCarVen			DECIMAL(12, 2);
	DECLARE	Var_SaldoSeguroCuota 		DECIMAL(12, 2);      		-- Monto del seguro por cuota
	DECLARE Var_SaldoComFaltaPa			DECIMAL(12, 2);
	DECLARE Var_SaldoOtrasComis			DECIMAL(12, 2);
	DECLARE Var_EstatusCre      		CHAR(1);
	DECLARE Var_MonedaID        		INT;
	DECLARE Var_FechaInicio     		DATE;
	DECLARE Var_FechaVencim     		DATE;
	DECLARE Var_FechaExigible   		DATE;
	DECLARE Var_AmoEstatus      		CHAR(1);
	DECLARE Var_EsGrupal        		CHAR(1);
	DECLARE Var_SolCreditoID    		BIGINT;
	DECLARE Var_GrupoID         		INT;
	DECLARE Var_CicloGrupo      		INT;
	DECLARE Var_CicloActual     		INT;
	DECLARE Var_GrupoCtaID      		INT;
	DECLARE Var_SaldoPago       		DECIMAL(14, 4);
	DECLARE Var_CantidPagar     		DECIMAL(14, 4);
	DECLARE Var_IVACantidPagar  		DECIMAL(12, 2);
	DECLARE Var_FechaSistema    		DATE;
	DECLARE Var_FecAplicacion   		DATE;
	DECLARE Var_EsHabil					CHAR(1);
	DECLARE Var_IVASucurs       		DECIMAL(8, 4);
	DECLARE Var_SucCliente      		INT;
	DECLARE Var_ClienteID				INT;
	DECLARE Var_ProdCreID				INT;
	DECLARE Var_ClasifCre				CHAR(1);
	DECLARE Var_CuentaAhoStr			VARCHAR(20);
	DECLARE Var_CreditoStr				VARCHAR(20);
	DECLARE Var_NumAmorti				INT;
	DECLARE Var_NumAmoPag				INT;
	DECLARE Var_NumAmoExi				INT;
	DECLARE Var_CueClienteID			BIGINT;
	DECLARE Var_Cue_Saldo				DECIMAL(12,2);
	DECLARE Var_CueMoneda				INT;
	DECLARE Var_CueEstatus				CHAR(1);
	DECLARE Var_MontoDeuda				DECIMAL(14,2);
	DECLARE Var_CliPagIVA				CHAR(1);
	DECLARE Var_IVAIntOrd				CHAR(1);
	DECLARE Var_IVAIntMor				CHAR(1);
	DECLARE Var_ValIVAIntOr				DECIMAL(12,2);
	DECLARE Var_ValIVAIntMo				DECIMAL(12,2);
	DECLARE Var_ValIVAGen				DECIMAL(12,2);
	DECLARE Var_EsReestruc				CHAR(1);
	DECLARE Var_EstCreacion				CHAR(1);
	DECLARE Var_Regularizado			CHAR(1);
	DECLARE Var_ResPagAct       		INT;
	DECLARE Var_NumPagSos       		INT;
	DECLARE Var_ProxAmorti      		INT;
	DECLARE Var_DiasAntici      		INT;
	DECLARE Var_IntAntici       		DECIMAL(14,4);
	DECLARE Var_ProyInPagAde    		CHAR(1);
	DECLARE Var_SaldoCapita     		DECIMAL(14,2);
	DECLARE Var_CreTasa         		DECIMAL(12,4);
	DECLARE Var_DiasCredito     		INT;
	DECLARE Mov_AboConta        		INT;
	DECLARE Mov_CarConta        		INT;
	DECLARE Mov_CarOpera        		INT;
	DECLARE Var_Frecuencia      		CHAR(1);
	DECLARE Var_DiasPermPagAnt  		INT;
	DECLARE Var_ComAntici       		DECIMAL(14,4);      -- Para el Control de la Liquidacion Anticipada o Finiquito
	DECLARE Var_IVAComAntici    		DECIMAL(14,2);      -- Para el Control de la Liquidacion Anticipada o Finiquito,
	DECLARE Var_PermiteLiqAnt   		CHAR(1);
	DECLARE Var_CobraComLiqAnt  		CHAR(1);
	DECLARE Var_TipComLiqAnt    		CHAR(1);
	DECLARE Var_ComLiqAnt       		DECIMAL(14,4);
	DECLARE Var_DiasGraciaLiq   		INT;
	DECLARE Var_IntActual       		DECIMAL(14,2);
	DECLARE Var_FecVenCred      		DATE;
	DECLARE Var_SubClasifID     		INT;
	DECLARE Var_TipCobComFal    		CHAR(1);
	DECLARE Var_SalCapitales    		DECIMAL(14,2);
	DECLARE Var_NumCapAtra     	 		INT;
	DECLARE Var_ManejaLinea				CHAR(1);			/*variable para guardar el valor de si o no maneja linea el producto de credito*/
	DECLARE Var_EsRevolvente			CHAR(1);			/* Variable para saber si es revolvente la linea */
	DECLARE Var_LineaCredito			BIGINT;				/* Variable para guardar la linea de credito*/
	DECLARE	Var_DivContaIng				CHAR(1);
	DECLARE Var_InverEnGar      		INT;
	DECLARE Var_ProdUsaGarLiq			CHAR(1);
	DECLARE Var_LiberaAlLiquidar		CHAR(1);
	DECLARE	Var_PagoAdeSinProy			CHAR(1);
	DECLARE Var_CalInteresID    		INT;
	DECLARE Var_ProvisionAcum   		DECIMAL(14,4);
	DECLARE Var_Interes         		DECIMAL(14,4);
	DECLARE Var_TotCapital      		DECIMAL(14,2);
	DECLARE Var_Dias            		INT;
	DECLARE Var_DiasAmor				INT;
	DECLARE Var_Control					VARCHAR(100);
	DECLARE Var_NumRecPago				INT;
    DECLARE Var_Poliza					BIGINT;
	/*COMISION ANUAL*/
	DECLARE Var_CobraComAnual			CHAR(1);
	DECLARE Var_SaldoComAnual			DECIMAL(14,2);
	/*FIN COMISION ANUAL*/
	DECLARE Var_TipoLiquidacion			CHAR(1);
	DECLARE Var_LiquidaCred				CHAR(1);

	DECLARE Var_MontoComAp      		DECIMAL(12,2);		--  Monto de la Comision por Apertura
	DECLARE Var_IVAComAp       	 		DECIMAL(12,2);		--  Monto del IVA de la Comision por Apertura
	DECLARE	Var_MontoCont				DECIMAL(14,2);  	--  Monto Comision Contabilizado
	DECLARE Var_MontoIVACont			DECIMAL(14,2);		--  Monto del IVA de la Comision por Apertura Contabilizado
	DECLARE Var_MontoAmort				DECIMAL(14,2);		--  Monto de la Comision a contabilizar
	DECLARE Var_MontoIVAAmort			DECIMAL(14,2);		--  Monto IVA de la Comision a contabilizar
	DECLARE Var_MontoSeguro				DECIMAL(14,2);
	DECLARE Var_MontoSeguroOp			DECIMAL(14,2);		--  Monto del Seguro Operativo
	DECLARE Var_MontoSeguroCont			DECIMAL(14,2);		--  Monto del Seguro Contable
	DECLARE Var_MontoIVASeguroOp		DECIMAL(14,2);	--  Monto del IVA del Seguro Operativo
	DECLARE Var_MontoIVASeguroCont		DECIMAL(14,2);	--  Monto del IVA del Seguro Contable

	DECLARE Var_NumeroAmort				INT(11);			--  Numero de Amortizaciones
	DECLARE Saldo_CapAtrasado 			DECIMAL(14,2);		--  Saldo de Capital Atrasado
	DECLARE Saldo_IntAtrasado			DECIMAL(14,2);		--  Saldo de Interes Atrasado
	DECLARE Var_FechaMinAtraso			DATE;				--  Fecha de Atraso de la primera amortizacion que se encuentre atrasada
	DECLARE Var_AmortizacionIDAtr		INT(11);			--  Amortizacion ID
	DECLARE Var_MontoCredito			DECIMAL(14,2);		--  Monto Original del Credito
	DECLARE Var_PorcMontoCred			DECIMAL(14,2);		--  Monto correspondiente al 20% del Monto Original del Credito
	DECLARE Var_MontoPagado				DECIMAL(14,2);		--  Monto pagado del Credito
	DECLARE Var_CapitalVigente			DECIMAL(14,2);		--  Saldo Capital Vigente
    DECLARE Var_Refinancia				CHAR(1);			-- Refinancia Intereses


	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Cons_No				CHAR(1);
	DECLARE Cons_Si				CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(12, 2);
	DECLARE Decimal_Cien    	DECIMAL(12, 2);
	DECLARE Esta_Activo     	CHAR(1);
	DECLARE Esta_Cancelado  	CHAR(1);
	DECLARE Esta_Inactivo   	CHAR(1);
	DECLARE Esta_Vencido    	CHAR(1);
	DECLARE Esta_Vigente    	CHAR(1);
	DECLARE Esta_Atrasado   	CHAR(1);
	DECLARE Esta_Pagado     	CHAR(1);
	DECLARE Var_SalidaNO    	CHAR(1);
	DECLARE Par_SalidaSI    	CHAR(1);
	DECLARE Var_AltaPoliza  	CHAR(1);
	DECLARE AltaPoliza_SI   	CHAR(1);
	DECLARE AltaPoliza_NO   	CHAR(1);
	DECLARE AltaPolCre_NO   	CHAR(1);
	DECLARE AltaPolCre_SI   	CHAR(1);
	DECLARE AltaMovAho_SI   	CHAR(1);
	DECLARE AltaMovAho_NO   	CHAR(1);
	DECLARE AltaMovCre_SI   	CHAR(1);
	DECLARE AltaMovCre_NO   	CHAR(1);
	DECLARE Finiquito_SI    	CHAR(1);
	DECLARE Finiquito_NO    	CHAR(1);
	DECLARE PrePago_SI      	CHAR(1);
	DECLARE PrePago_NO      	CHAR(1);
	DECLARE SI_ProyectInt   	CHAR(1);
	DECLARE NO_ProyectInt   	CHAR(1);
	DECLARE Mov_IntPro      	INT;
	DECLARE Con_IntDeven    	INT;
	DECLARE Con_IngreInt    	INT;
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Nat_Abono       	CHAR(1);
	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE SiPagaIVA      		CHAR(1);
	DECLARE Coc_PagoCred    	INT;
	DECLARE Aho_PagoCred    	CHAR(4);
	DECLARE Con_AhoCapital  	INT;
	DECLARE Mov_CapVigente  	INT;
	DECLARE Mov_CapAtrasado 	INT;
	DECLARE Mov_CapVencido  	INT;
	DECLARE Mov_CapVencidoNE	INT;
	DECLARE Mov_IntOrdinario    INT;
	DECLARE Mov_IntAtrasado		INT;
	DECLARE Mov_IntVencido		INT;
	DECLARE Mov_IntNoContab		INT;
	DECLARE Mov_IntProvision	INT;
	DECLARE Mov_Moratorio		INT;
	DECLARE Mov_ComFalPag		INT;
	DECLARE Mov_IVAInteres		INT;
	DECLARE Mov_IVAIntMora		INT;
	DECLARE Mov_IVAComFaPag		INT;
	DECLARE Mov_ComLiqAnt       INT;
	DECLARE Mov_IVAComLiqAnt    INT;
	DECLARE Con_CapVigente		INT;
	DECLARE Con_CapAtrasado		INT;
	DECLARE Con_CapVencido		INT;
	DECLARE Con_CapVencidoNE	INT;
	DECLARE Con_IngInteres		INT;
	DECLARE Con_IngIntMora		INT;
	DECLARE Con_IngFalPag		INT;
	DECLARE Con_IVAInteres		INT;
	DECLARE Con_IVAMora			INT;
	DECLARE Con_IVAFalPag		INT;
	DECLARE Con_CtaOrdInt		INT;
	DECLARE Con_CorIntDev		INT;
	DECLARE Con_CtaOrdMor		INT;
	DECLARE Con_CorIntMor		INT;
	DECLARE Con_CtaOrdCom		INT;
	DECLARE Con_CorComFal		INT;
	DECLARE Con_IntAtrasado		INT;
	DECLARE Con_IntVencido		INT;
	DECLARE Con_ComFiniqui		INT;
	DECLARE Con_IVAComFin		INT;
	DECLARE Tol_DifPago			DECIMAL(10,4);
	DECLARE Des_PagoCred		VARCHAR(50);
	DECLARE Con_PagoCred		VARCHAR(50);
	DECLARE Ref_PagAnti			VARCHAR(50);
	DECLARE No_EsReestruc		CHAR(1);
	DECLARE Si_EsReestruc		CHAR(1);
	DECLARE Si_Regulariza		CHAR(1);
	DECLARE No_Regulariza		CHAR(1);
	DECLARE Si_EsGrupal			CHAR(1);
	DECLARE NO_EsGrupal			CHAR(1);
	DECLARE SI_PermiteLiqAnt	CHAR(1);
	DECLARE SI_CobraLiqAnt		CHAR(1);
	DECLARE Cob_FalPagCuota		CHAR(1);
	DECLARE Cob_FalPagFinal		CHAR(1);
	DECLARE SiManejaLinea		CHAR(1);		/* Si maneja linea */
	DECLARE NoManejaLinea		CHAR(1);		/* NO maneja linea */
	DECLARE SiEsRevolvente		CHAR(1);		/* Si Es Revolvente */
	DECLARE NoEsRevolvente		CHAR(1);		/* NO Es Revolvente */
	DECLARE Act_PagoSost		INT;
	DECLARE Proyeccion_Int  	CHAR(1);
	DECLARE Monto_Fijo      	CHAR(1);
	DECLARE Por_Porcentaje  	CHAR(1);
	DECLARE Mon_MinPago     	DECIMAL(12,2);
	DECLARE Act_LiberarPagCre	INT;
	DECLARE ValorSI				CHAR(1);
	DECLARE ValorNO				CHAR(1);
	DECLARE VarSucursalLin      INT;		 		-- Variables para el CURSOR
	DECLARE MonedaLinea         INT(11);
	DECLARE Tasa_Fija       	INT;
	DECLARE EstatusDesembolso	CHAR(1);
	DECLARE DiasRegula			INT;
	DECLARE Prog_Reestructura 	VARCHAR(50);
	DECLARE TipoActInteres		INT(11);
	DECLARE SiCobSeguroCuota	CHAR(1);
	DECLARE SiCobIVASeguroCuota	CHAR(1);
	DECLARE LiquidacionTotal	CHAR(1);
	DECLARE LiquidacionParcial	CHAR(1);
	DECLARE Var_DescComAper		VARCHAR(100);	--  Descripcion: Comision por Apertura
	DECLARE Var_DcIVAComApe		VARCHAR(100);	--  Descripcion: IVA Comision por Apertura
	DECLARE Con_ContComApe		INT(11);		--  Concepto Cartera: Comision por Apertura
	DECLARE Con_ContIVACApe		INT(11); 		--  Concepto Cartera: IVA Comision por Apertura
	DECLARE Con_ContGastos		INT(11);		--  Concento Cartera: Cuenta Puente para la Comision por Apertura ***********
	DECLARE Con_OrigenWS		CHAR(1);
	DECLARE Frec_Unico			CHAR(1);
    DECLARE FechaReal			CHAR(1);


	/* DECLARACION DE CURSORES */
	DECLARE CURSORAMORTI CURSOR FOR
		SELECT	Amo.CreditoID,			Amo.AmortizacionID,		Amo.SaldoCapVigente,	Amo.SaldoCapAtrasa,		Amo.SaldoCapVencido,
				Amo.SaldoCapVenNExi,	Amo.SaldoInteresOrd,	Amo.SaldoInteresAtr,	Amo.SaldoInteresVen,	Amo.SaldoInteresPro,
				Amo.SaldoIntNoConta,	Amo.SaldoMoratorios,	Amo.SaldoComFaltaPa,	Amo.SaldoOtrasComis,	Cre.MonedaID,
				Amo.FechaInicio,		Amo.FechaVencim,		Amo.FechaExigible,		Amo.Estatus,			Amo.SaldoMoraVencido,
				Amo.SaldoMoraCarVen,	Amo.SaldoSeguroCuota,	Cre.CobraComAnual,		Amo.SaldoComisionAnual
			FROM	AMORTICREDITOCONT	Amo,
					CREDITOSCONT		Cre
			WHERE	Amo.CreditoID 	= Cre.CreditoID
			  AND	Cre.CreditoID	= Par_CreditoID
			  AND	(Cre.Estatus	= Esta_Vigente
			   OR		Cre.Estatus	= Esta_Vencido)
			  AND	(Amo.Estatus	= Esta_Vigente
			  OR		Amo.Estatus	= Esta_Vencido
			  OR		Amo.Estatus	= Esta_Atrasado)
			ORDER BY FechaExigible;

		-- CURSOR Para Pagar al Final del Pago Ordinario, La Comision por Falta de Pago
	DECLARE CURSORCOMFALPAG CURSOR FOR
		SELECT	Amo.CreditoID,		Amo.AmortizacionID,		Amo.SaldoComFaltaPa,	Cre.MonedaID,	Amo.FechaInicio,
				Amo.FechaVencim,	Amo.FechaExigible,		Amo.Estatus
			FROM	AMORTICREDITOCONT	Amo,
					CREDITOSCONT		Cre
			WHERE	Amo.CreditoID 	= Cre.CreditoID
			  AND	Cre.CreditoID	= Par_CreditoID
			  AND	(Cre.Estatus	= Esta_Vigente
			   OR		Cre.Estatus	= Esta_Vencido)
			  AND	(Amo.Estatus	= Esta_Vigente
			  OR		Amo.Estatus	= Esta_Vencido
			  OR		Amo.Estatus	= Esta_Atrasado)
			AND Amo.SaldoComFaltaPa > Entero_Cero
			ORDER BY FechaExigible;

	-- Asignacion de Constantes
	SET Cadena_Vacia    := '';              -- String Vacio
	SET Cons_No		    := 'N';              -- Constante No
	SET Cons_Si		    := 'S';              -- Constante SI
	SET Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero     := 0;               -- Entero en Cero
	SET Decimal_Cero    := 0.00;            -- DECIMAL Cero
	SET Decimal_Cien    := 100.00;          -- DECIMAL en Cien

	SET Esta_Activo     := 'A';             -- Estatus Activo
	SET Esta_Cancelado  := 'C';             -- Estatus Cancelado
	SET Esta_Inactivo   := 'I';             -- Estatus Inactivo
	SET Esta_Vencido    := 'B';             -- Estatus Vencido
	SET Esta_Vigente    := 'V';             -- Estatus Vigente
	SET	Esta_Pagado     := 'P';             -- Estatus Pagado
	SET Esta_Atrasado   := 'A';             -- Estatus Atrasado

	SET Aho_PagoCred    := '101';           -- Concepto de Ahorro: Pago de Credito
	SET Con_AhoCapital  := 1;               -- Concepto Contable de Ahorro: Pasivo

	SET Var_SalidaNO    := 'N';             -- Ejecutar Store sin Regreso o Mensaje de Salida
	SET Par_SalidaSI    := 'S';	            -- Ejecutar Store Con Regreso o Mensaje de Salida
	SET SiManejaLinea	:= 'S';	            /* Si maneja linea */
	SET NoManejaLinea	:= 'N';	            /* No maneja linea */
	SET SiEsRevolvente	:= 'S';	            /* Si Es Revolvente */
	SET NoEsRevolvente	:= 'N';	            /* No Es Revolvente */

	SET PrePago_SI      := 'S';             -- SI es un PrePago
	SET PrePago_NO      := 'N';             -- NO es un PrePago
	SET Finiquito_SI    := 'S';             -- SI es un Finiquito o Liquidacion Total Anticipada
	SET Finiquito_NO    := 'N';             -- NO es un Finiquito o Liquidacion Total Anticipada
	SET SI_ProyectInt   := 'S';             -- El Producto de Credito si Proyecta Interes
	SET NO_ProyectInt   := 'N';             -- El Producto de Credito si Proyecta Interes
	SET Mov_IntPro      := 14;              -- Tipo de Movimiento de Credito: Interes Provisionado
	SET Con_IntDeven    := 19;              -- Concepto Contable Interes Devengado
	SET Con_IngreInt    := 5;               -- Concepto Contable Ingreso por Interes
	SET AltaPoliza_SI   := 'S';             -- Alta de la Poliza Contable: SI
	SET AltaPoliza_NO   := 'N';             -- Alta de la Poliza Contable: NO
	SET AltaPolCre_SI   := 'S';             -- Alta de la Poliza Contable de Credito: SI
	SET AltaPolCre_NO   := 'N';             -- Alta de la Poliza Contable de Credito: NO
	SET AltaMovCre_NO   := 'N';             -- Alta de los Movimientos de Credito: NO
	SET AltaMovCre_SI   := 'S';             -- Alta de los Movimientos de Credito: SI
	SET AltaMovAho_NO   := 'N';             -- Alta de los Movimientos de Ahorro: NO
	SET AltaMovAho_SI   := 'S';             -- Alta de los Movimientos de Ahorro: SI.

	SET Nat_Cargo       := 'C';             -- Naturaleza de Cargo
	SET Nat_Abono       := 'A';             -- Naturaleza de Abono.
	SET Pol_Automatica  := 'A';             -- Tipo de Poliza: Automatica
	SET SiPagaIVA       := 'S';             -- El Cliente si Paga IVA
	SET Coc_PagoCred    := 54;              -- Concepto Contable de Cartera: Pago de Credito
	SET SiCobSeguroCuota	:= 'S';
	SET SiCobIVASeguroCuota := 'S';

	SET Mov_CapVigente  	:= 1;
	SET Mov_CapAtrasado 	:= 2;
	SET Mov_CapVencido  	:= 3;
	SET Mov_CapVencidoNE    := 4;
	SET Mov_IntOrdinario    := 10;
	SET Mov_IntAtrasado 	:= 11;
	SET Mov_IntVencido  	:= 12;
	SET Mov_IntNoContab 	:= 13;
	SET Mov_IntProvision    := 14;
	SET Mov_Moratorio   	:= 15;
	SET Mov_ComFalPag   	:= 40;
	SET Mov_IVAInteres  	:= 20;
	SET Mov_IVAIntMora  	:= 21;
	SET Mov_IVAComFaPag 	:= 22;
	SET Mov_ComLiqAnt   	:= 42;          -- Comision por Administracion: Liquidacion Anticipada
	SET Mov_IVAComLiqAnt    := 24;      	-- IVA Comision por Administracion: Liquidacion Anticipada

	SET Con_CapVigente  	:= 1;           -- Concepto Contable de Credito: Capital Vigente (CONCEPTOSCARTERA)
	SET Con_CapAtrasado 	:= 2;           -- Concepto Contable de Credito: Atrasado (CONCEPTOSCARTERA)
	SET Con_CapVencido  	:= 3;           -- Concepto Contable de Credito: Capital Vencido (CONCEPTOSCARTERA)
	SET Con_CapVencidoNE    := 4;       	-- Concepto Contable de Credito: Capital Vencido no Exigible
	SET Con_IngInteres  	:= 5;           -- Concepto Contable de Credito: Ingreso por Interes
	SET Con_IngIntMora  	:= 6;           -- Concepto Contable de Credito: Ingreso por Moratorios
	SET Con_IngFalPag   	:= 7;           -- Concepto Contable de Credito: Ingreso Comision Falta de Pago
	SET Con_IVAInteres  	:= 8;           -- Concepto Contable de Credito: IVA de Interes
	SET Con_IVAMora     	:= 9;           -- Concepto Contable de Credito: IVA Moratorios
	SET Con_IVAFalPag   	:= 10;          -- Concepto Contable de Credito: IVA Falta de Pago
	SET Con_CtaOrdInt   	:= 11;          -- Concepto Contable de Credito: Cta de Orden de Interes
	SET Con_CorIntDev   	:= 12;          -- Concepto Contable de Credito: Correlativa Cta de Orden de Interes
	SET Con_CtaOrdMor   	:= 13;          -- Concepto Contable de Credito: Cta de Orden de Moratorios
	SET Con_CorIntMor   	:= 14;          -- Concepto Contable de Credito: Correlativa Cta de Orden de Moratorios
	SET Con_CtaOrdCom   	:= 15;          -- Concepto Contable de Credito: Cta de Orden de Com Falta de Pago
	SET Con_CorComFal   	:= 16;          -- Concepto Contable de Credito: Correlativa Cta de Orden de Com Falta de Pago
	SET Con_IntAtrasado 	:= 20;          -- Concepto Contable de Credito: Interes Atrasado
	SET Con_IntVencido  	:= 21;          -- Concepto Contable de Credito: Interes Vencido
	SET Con_ComFiniqui  	:= 27;          -- Concepto Contable de Cartera: Comision por Finiquito
	SET Con_IVAComFin   	:= 28;          -- Concepto Contable de Cartera: IVA Comision por Finiquito
	SET Tol_DifPago     	:= 0.05;

	SET No_EsReestruc   	:= 'N';
	SET Si_EsReestruc   	:= 'S';
	SET Si_Regulariza   	:= 'S';
	SET No_Regulariza   	:= 'N';
	SET Si_EsGrupal     	:= 'S';
	SET NO_EsGrupal     	:= 'N';
	SET SI_PermiteLiqAnt    := 'S';         -- El Producto Si Permite Liquidacion Anticipada
	SET SI_CobraLiqAnt      := 'S';         -- El Producto Si Cobra Comision por Liquidacion Anticipada
	SET Cob_FalPagCuota     := 'C';         -- Cobro de la Comision en Cada Cuota (Tradicional)
	SET Cob_FalPagFinal     := 'F';         -- Cobro de la Comision al Final de la Prelacion
	SET Proyeccion_Int      := 'P'; 		-- Tipo de Comision por Finiquito: Proyeccion de Interes
	SET Monto_Fijo          := 'M'; 		-- Tipo de Comision por Finiquito: Monto Fijo
	SET Por_Porcentaje      := 'S'; 		-- Tipo de Comision Porcentaje del Sald Insoluto

	SET Act_PagoSost    	:= 2;
	SET Act_LiberarPagCre	:= 3;
	SET Mon_MinPago     	:= 0.01;
	SET TipoActInteres		:= 1;			-- Tipo de Actualizacion (intereses)
	SET Ref_PagAnti     	:= 'PAGO ANTICIPADO CONTINGENTE';
	SET Des_PagoCred    	:= 'PAGO DE CREDITO CONTINGENTE';
	SET Con_PagoCred    	:= 'PAGO DE CREDITO CONTINGENTE';
	SET Aud_ProgramaID  	:= 'PAGOCREDITOCONTPRO';
	SET ValorSI				:='S';
	SET ValorNO				:='N';
	SET Tasa_Fija       	:= 1;
	SET ConcepCtaOrdenDeu	:= 53;			-- Linea Credito Cta. Orden
	SET ConcepCtaOrdenCor	:= 54;			-- Linea Credito Corr. Cta Orden
	SET EstatusDesembolso	:= 'D';			-- Estatus desembolsada de una reestructura-renovacion
	SET DiasRegula			:= 60;
	SET Var_NumRecPago		:= 0;
	SET LiquidacionTotal	:= 'T';
	SET LiquidacionParcial	:= 'P';
	SET Var_DescComAper		:= 'COMISION POR APERTURA';
	SET Var_DcIVAComApe		:= 'IVA COMISION POR APERTURA';
	SET Con_ContComApe  	:= 22; 				-- CONCEPTOSCARTERA: 22 Comision por Apertura
	SET Con_ContIVACApe 	:= 23; 				-- CONCEPTOSCARTERA: 23 IVA Comision por Apertura
	SET Con_ContGastos		:= 58; 				-- Cuenta Puente para la Comision por Apertura
	SET Con_OrigenWS 		:= 'W';
	SET Var_EsHabil			:= 'S';
	SET Frec_Unico			:= 'U';			-- Frecuencia Unica
	SET FechaReal			:= 'R';			-- Recalcular intereses a la fecha real

ManejoErrores:BEGIN

	  DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDITOCONTPRO');
		END;

	SELECT FechaSistema, 	DiasCredito, 		DivideIngresoInteres
	INTO Var_FechaSistema, 	Var_DiasCredito, 	Var_DivContaIng
		FROM PARAMETROSSIS;

	SET Aud_FechaActual		:= NOW();
    SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_Poliza			:= Par_Poliza;

	SET	Var_DivContaIng	:= IFNULL(Var_DivContaIng, Cadena_Vacia);
	SET	Var_PagoAdeSinProy	:= ValorNO;

	SELECT  Cli.SucursalOrigen,     Cre.ClienteID,      Pro.ProducCreditoID,    Des.Clasificacion,      Cre.NumAmortizacion,
			Cre.Estatus,            Cli.PagaIVA,        Pro.CobraIVAInteres,    Pro.CobraIVAMora,       Pro.EsReestructura,
			Res.EstatusCreacion,    Res.Regularizado,   Res.NumPagoActual,      Pro.EsGrupal,           Cre.SolicitudCreditoID,
			Pro.ProyInteresPagAde,  Cre.TasaFija,       Cre.MonedaID,           Cre.FrecuenciaCap,      Cre.FechaVencimien,
			Cre.GrupoID,            Cre.CicloGrupo,     Des.SubClasifID,        Pro.TipoPagoComFalPago, Pro.ManejaLinea,
			Pro.EsRevolvente,       Cre.LineaCreditoID,	Cre.CalcInteresID,
			(Cre.SaldoCapVigent + Cre.SaldCapVenNoExi + Cre.SaldoCapAtrasad + Cre.SaldoCapVencido),
            Cre.MontoComApert,		Cre.IVAComApertura,		Cre.ComAperCont,		Cre.IVAComAperCont,
            Cre.MontoCredito,		Cre.Refinancia

	INTO    Var_SucCliente,         Var_ClienteID,      Var_ProdCreID,      Var_ClasifCre,      Var_NumAmorti,
			Var_EstatusCre,         Var_CliPagIVA,      Var_IVAIntOrd,      Var_IVAIntMor,      Var_EsReestruc,
			Var_EstCreacion,        Var_Regularizado,   Var_ResPagAct,      Var_EsGrupal,       Var_SolCreditoID,
			Var_ProyInPagAde,       Var_CreTasa,        Var_MonedaID,       Var_Frecuencia,     Var_FecVenCred,
			Var_GrupoID,            Var_CicloGrupo,     Var_SubClasifID,    Var_TipCobComFal,   Var_ManejaLinea,
			Var_EsRevolvente,       Var_LineaCredito,   Var_CalInteresID,	Var_SaldoCapita,
            Var_MontoComAp,			Var_IVAComAp,		Var_MontoCont,		Var_MontoIVACont,
            Var_MontoCredito,		Var_Refinancia
	FROM CREDITOSCONT Cre
	INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
	INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
	INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
	LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID
	WHERE Cre.CreditoID = Par_CreditoID;

	SET Var_EstCreacion     := IFNULL(Var_EstCreacion, Cadena_Vacia);
	SET Var_Regularizado    := IFNULL(Var_Regularizado, Cadena_Vacia);
	SET Var_ResPagAct    	:= IFNULL(Var_ResPagAct, Entero_Cero);
	SET Var_SubClasifID    	:= IFNULL(Var_SubClasifID, Entero_Cero);
	SET Var_TipCobComFal    := IFNULL(Var_TipCobComFal, Cadena_Vacia);
    SET Var_MontoCredito    := IFNULL(Var_MontoCredito, Decimal_Cero);
	SET Var_LineaCredito 	:= IFNULL(Var_LineaCredito, Entero_Cero);

	-- Buscamos la Dias Permitidos para el Adelanto del Pago
	SELECT Dpa.NumDias INTO Var_DiasPermPagAnt
		FROM CREDDIASPAGANT Dpa
		WHERE Dpa.ProducCreditoID = Var_ProdCreID
		  AND Dpa.Frecuencia = Var_Frecuencia;

	SET Var_DiasPermPagAnt  := IFNULL(Var_DiasPermPagAnt, Entero_Cero);
    -- Monto correspondiente al 20% del Monto del Credito
    SET Var_PorcMontoCred := ((Var_MontoCredito * 20)/100);

	IF(Var_EstCreacion = Cadena_Vacia) THEN
	    SET Var_EsReestruc  := No_EsReestruc;
	ELSE
	    SET Var_EsReestruc  := SI_EsReestruc;
	END IF;

	SELECT IVA INTO Var_IVASucurs
		FROM SUCURSALES
		WHERE SucursalID	= Var_SucCliente;

	SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);
	SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, SiPagaIVA);
	SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, SiPagaIVA);
	SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);

	-- Inicializaciones
	SET Var_ValIVAIntOr := Entero_Cero;
	SET Var_ValIVAIntMo := Entero_Cero;
	SET Var_ValIVAGen   := Entero_Cero;
	SET Var_NumPagSos   := Entero_Cero;
	SET Var_ComAntici   := Entero_Cero;
	SET Var_DiasAntici  := Entero_Cero;

	IF (Var_CliPagIVA = SiPagaIVA) THEN
		SET Var_ValIVAGen  := Var_IVASucurs;

		IF (Var_IVAIntOrd = SiPagaIVA) THEN
			SET Var_ValIVAIntOr  := Var_IVASucurs;
		END IF;

		IF (Var_IVAIntMor = SiPagaIVA) THEN
			SET Var_ValIVAIntMo  := Var_IVASucurs;
		END IF;
	END IF;

	-- Revisamos si es una Liquidacion Anticipada o Finiquito
	 IF( Par_Finiquito = Finiquito_SI) THEN
		SET Con_PagoCred := "LIQUIDACION ANT.CREDITO CONTINGENTE";
		SET Var_FecVenCred := IFNULL(Var_FecVenCred, Fecha_Vacia);

		-- Obtenemos las Condiciones de la Comision por Finiquito
		SELECT  PermiteLiqAntici, 	CobraComLiqAntici, 		TipComLiqAntici,
				ComisionLiqAntici, 	DiasGraciaLiqAntici
		INTO    Var_PermiteLiqAnt, 	Var_CobraComLiqAnt, 	Var_TipComLiqAnt,
				Var_ComLiqAnt, 		Var_DiasGraciaLiq
		FROM ESQUEMACOMPRECRE
			WHERE ProductoCreditoID = Var_ProdCreID;

		SET Var_PermiteLiqAnt   := IFNULL(Var_PermiteLiqAnt, Cadena_Vacia);
		SET Var_CobraComLiqAnt  := IFNULL(Var_CobraComLiqAnt, Cadena_Vacia);
		SET Var_TipComLiqAnt    := IFNULL(Var_TipComLiqAnt, Cadena_Vacia);
		SET Var_ComLiqAnt       := IFNULL(Var_ComLiqAnt, Entero_Cero);
		SET Var_DiasGraciaLiq   := IFNULL(Var_DiasGraciaLiq, Entero_Cero);

		IF(Var_FecVenCred != Fecha_Vacia AND Var_FecVenCred >= Var_FechaSistema) THEN
			SET Var_DiasAntici := DATEDIFF(Var_FecVenCred, Var_FechaSistema);
		ELSE
			SET Var_DiasAntici := Entero_Cero;
		END IF;

	   IF(Var_DiasAntici > Var_DiasGraciaLiq AND Var_PermiteLiqAnt = SI_PermiteLiqAnt AND
		   Var_CobraComLiqAnt = SI_CobraLiqAnt) THEN

			-- * VALIDAR EL TIPO DE COMISION
			IF(Var_TipComLiqAnt = Proyeccion_Int) THEN
				-- * SI ES PROYECCION
				-- Obtenemos el Monto del Interes Pendiente de Devengar
				SELECT SUM(Interes) INTO Var_ComAntici
				FROM AMORTICREDITOCONT
					WHERE CreditoID   = Par_CreditoID
					  AND FechaVencim > Var_FechaSistema
					  AND Estatus     != Esta_Pagado;
				SET Var_ComAntici   := IFNULL(Var_ComAntici, Entero_Cero);

				-- Obtenemos el Saldo De Interes de la Amortizacion Actual o Vigente
				SELECT (Amo.SaldoInteresPro + Amo.SaldoIntNoConta) INTO Var_IntActual
					FROM AMORTICREDITOCONT Amo
					WHERE Amo.CreditoID   = Par_CreditoID
					  AND Amo.FechaVencim > Var_FechaSistema
					  AND Amo.FechaInicio <= Var_FechaSistema
					  AND Amo.Estatus     != Esta_Pagado;
				SET Var_IntActual   := IFNULL(Var_IntActual, Entero_Cero);
				SET Var_ComAntici   := ROUND(Var_ComAntici - Var_IntActual,2);

			ELSEIF (Var_TipComLiqAnt = Por_Porcentaje) THEN        -- En Base a Porcentaje de Saldo Insoluto
					SET Var_ComAntici   := ROUND(Var_SaldoCapita * Var_ComLiqAnt / Decimal_Cien,2);
				ELSE
					SET Var_ComAntici   := Var_ComLiqAnt;               -- En Base a Monto Fijo
				END IF; -- Endif Del Tipo de Cobro
		END IF; -- Endif Perimite Finiquito y Dias de Gracia

		IF(Var_ComAntici < Entero_Cero) THEN
			SET Var_ComAntici   := Entero_Cero;
		END IF;

		SELECT TipoLiquidacion  INTO Var_TipoLiquidacion
        	FROM CREDITOSCONT
        		WHERE Relacionado = Par_CreditoID LIMIT 1;

        SET Var_TipoLiquidacion	:= IFNULL(Var_TipoLiquidacion, Cadena_Vacia);

        IF(Var_TipoLiquidacion = LiquidacionTotal) THEN
		-- Monto Total del Adeudo
			SELECT FUNCIONTOTDEUDACRECONT(Par_CreditoID) INTO Var_MontoDeuda;
		ELSE
			-- Monto Parcial del Adeudo
			SELECT FUNCIONPARCDEUDACRE(Par_CreditoID) INTO Var_MontoDeuda;
        END IF;

		SET Var_MontoDeuda := IFNULL(Var_MontoDeuda, Decimal_Cero) +
							  Var_ComAntici + ROUND(Var_ComAntici * Var_ValIVAIntOr,2);

		IF(Var_TipoLiquidacion = LiquidacionTotal) THEN
			IF(ABS(Var_MontoDeuda - Par_MontoPagar) > Tol_DifPago) THEN
					SET Par_NumErr		:= '100';
					SET Par_ErrMen		:= CONCAT('Credito: ', CONVERT(Par_CreditoID,CHAR), ' .En una Liquidacion Anticipada el Monto de Pago debe ser el Total ',
											 'del Adeudo. Adeudo Total: $', CONVERT(FORMAT(Var_MontoDeuda,2), CHAR),
											' Monto del Pago: $', CONVERT(FORMAT(Par_MontoPagar,2), CHAR));
					SET Par_Consecutivo	:= 0;
					SET Var_Control		:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF; -- END IF(Var_TipoLiquidacion = LiquidacionTotal) THEN
	END IF; --  IF( Par_Finiquito = Finiquito_SI) THEN


	CALL DIASFESTIVOSCAL(
		Var_FechaSistema,	Entero_Cero,		Var_FecAplicacion,		Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	CALL SALDOSAHORROCON(
		Var_CueClienteID, Var_Cue_Saldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);

	IF(IFNULL(Var_CueEstatus, Cadena_Vacia)) != Esta_Activo THEN
			SET Par_NumErr		:= '01';
			SET Par_ErrMen		:= 'La Cuenta No Existe o no Esta Activa ';
			SET Par_Consecutivo	:= 0;
			SET Var_Control		:= 	'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_CueClienteID, Entero_Cero)) != Var_ClienteID THEN
		SET Par_NumErr		:= '02';
		SET Par_ErrMen		:= CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),
								' No Pertenece al Cliente: ', CONVERT(Var_ClienteID, CHAR),
								'Cliente al que Pertence: ' , CONVERT(Var_CueClienteID, CHAR));
		SET Par_Consecutivo	:= 0;
		SET Var_Control		:= 	'cuentaAhoID';
	END IF; -- IF(IFNULL(Var_CueClienteID, Entero_Cero)) != Var_ClienteID

	IF(IFNULL(Var_CueMoneda, Entero_Cero)) != Par_MonedaID THEN
			SET Par_NumErr		:= '03';
			SET Par_ErrMen		:= 'La Moneda No Corresponde con la Cuenta.';
			SET Par_Consecutivo	:= 0;
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Var_Cue_Saldo, Decimal_Cero)) < Par_MontoPagar THEN
			SET Par_NumErr		:= '04';
			SET Par_ErrMen		:= 'Saldo Insuficiente en la Cuenta del Cliente.';
			SET Par_Consecutivo	:= 0;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_EstatusCre, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr		:= '05';
			SET Par_ErrMen		:= 'El Credito No Existe.';
			SET Par_Consecutivo	:= 0;
		LEAVE ManejoErrores;
	END IF;

	IF(Var_EstatusCre != Esta_Vigente) THEN
			SET Par_NumErr		:= '06';
			SET Par_ErrMen		:= 'Estatus del Credito Incorrecto.';
			SET Par_Consecutivo	:= 0;
			SET Var_Control		:= 'monto';
		LEAVE ManejoErrores;
	END IF;

	/* Respaldamos las tablas de CREDITOSCONT, AMORTICREDITOCONT, CREDITOSMOVS antes de realizar el pago (usado para la reversa)*/

	CALL RESPAGCREDITOCONTPRO(
		Par_CreditoID,	Var_SalidaNO,		Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

	IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN

		CALL MAESTROPOLIZASALT(
				Par_Poliza,			Par_EmpresaID,		Var_FecAplicacion, 		Pol_Automatica,			Coc_PagoCred,
				Con_PagoCred,		Var_SalidaNO, 		Par_NumErr,				Par_ErrMen,				Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
	        LEAVE ManejoErrores;
	    END IF;

	END IF;

	SET Var_SaldoPago       := Par_MontoPagar;
	SET Var_CuentaAhoStr    := CONVERT(Par_CuentaAhoID, CHAR(15));
	SET Var_CreditoStr      := CONVERT(Par_CreditoID, CHAR(15));

	-- Cobramos la Comision por Finiquito o Liquidacion Anticipada
	IF( Par_Finiquito = Finiquito_SI AND Var_ComAntici > Entero_Cero) THEN
		--  COMISION DIFERIDA
		--  Se verifica si aun tiene Saldo de Comision pendiente por contabilizar
		IF(Var_MontoCont>Decimal_Cero) THEN
			--  Si el monto de la Comision por apertura es mayor que cero, se procede a generar los asientos contables
			IF(Var_MontoComAp > Decimal_Cero)THEN

				SET Var_MontoAmort		:= ROUND(Var_MontoCont,2);	--  Obtiene el monto que se abona a la cuenta de Com. por Apert

				--  Se realiza el CARGO a la cuenta Puente (Gasto)
				CALL CONTACREDITOSCONTPRO (
					Par_CreditoID,			Entero_Cero,				Entero_Cero,			Entero_Cero,			Var_FechaSistema,
					Var_FechaSistema,		Var_MontoAmort,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
					Var_SubClasifID,		Var_SucCliente,				Var_DescComAper,		Cadena_Vacia,			AltaPoliza_NO,
					Entero_Cero,			Var_Poliza,					AltaPolCre_SI,			AltaMovCre_NO,			Con_ContGastos,
					Entero_Cero,			Nat_Cargo,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
					Var_SalidaNO,			Par_NumErr,					Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
					Cadena_Vacia,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Ref_PagAnti,
					Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				--  Se realiza el ABONO a la cuenta de Comision por Apertura de Credito
				CALL CONTACREDITOSCONTPRO (
					Par_CreditoID,			Entero_Cero,				Entero_Cero,			Entero_Cero,			Var_FechaSistema,
					Var_FechaSistema,		Var_MontoAmort,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
					Var_SubClasifID,		Var_SucCliente,				Var_DescComAper,		Cadena_Vacia,			AltaPoliza_NO,
					Entero_Cero,			Var_Poliza,					AltaPolCre_SI,			AltaMovCre_NO,			Con_ContComApe,
					Entero_Cero,			Nat_Abono,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
					Var_SalidaNO,			Par_NumErr,					Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
					Cadena_Vacia,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Ref_PagAnti,
					Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				--  Actualizando el Campo ComAperCont para disminuir lo que ya ha sido contabilizado
				UPDATE CREDITOSCONT SET
					ComAperCont = ComAperCont - Var_MontoAmort
				WHERE CreditoID= Par_CreditoID;

			END IF;

		END IF;        --   FIN COMISION DIFERIDA

		-- Obtenemos la Amortizacion "Vigente-Actual", a la cual Cargar la Comision
		SELECT MIN(AmortizacionID) INTO Var_ProxAmorti
			FROM AMORTICREDITOCONT
			WHERE CreditoID     = Par_CreditoID
			  AND FechaVencim >= Var_FechaSistema
			  AND Estatus     != Esta_Pagado;

	    -- Cargo de los Gastos de Admon o Liq. Anticipada
	    CALL CONTACREDITOSCONTPRO (
			Par_CreditoID,			Var_ProxAmorti,				Entero_Cero,			Entero_Cero,			Var_FechaSistema,
			Var_FecAplicacion,		Var_ComAntici,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
			Var_SubClasifID,		Var_SucCliente,				Des_PagoCred,			Ref_PagAnti,			AltaPoliza_NO,
			Entero_Cero,			Var_Poliza,					AltaPolCre_NO,			AltaMovCre_SI,			Entero_Cero,
			Mov_ComLiqAnt,			Nat_Cargo,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
			Var_SalidaNO,			Par_NumErr,					Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
			Cadena_Vacia,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	    -- Pago de los Gastos de Admon o Liq. Anticipada
	    CALL CONTACREDITOSCONTPRO (
	        Par_CreditoID,      	Var_ProxAmorti,     	Entero_Cero,        	Entero_Cero,		Var_FechaSistema,
	        Var_FecAplicacion,  	Var_ComAntici,      	Var_MonedaID,			Var_ProdCreID,      Var_ClasifCre,
	        Var_SubClasifID,    	Var_SucCliente,			Des_PagoCred,       	Ref_PagAnti,        AltaPoliza_NO,
	        Entero_Cero,			Var_Poliza,         	AltaPolCre_SI,     	 	AltaMovCre_SI,      Con_ComFiniqui,
	        Mov_ComLiqAnt,      	Nat_Abono,          	AltaMovAho_NO,      	Cadena_Vacia,		Cadena_Vacia,
	        Var_SalidaNO,			Par_NumErr,         	Par_ErrMen,         	Par_Consecutivo,	Par_EmpresaID,
	        Par_ModoPago,			Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,	Aud_ProgramaID,
	        Aud_Sucursal,       	Aud_NumTransaccion);

	    IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Pago del IVA Gastos de Admon o Liq. Anticipada
		SET Var_IVAComAntici    := ROUND(Var_ComAntici * Var_ValIVAIntOr, 2);

		IF(Var_IVAComAntici > Entero_Cero) THEN

			CALL CONTACREDITOSCONTPRO (
				Par_CreditoID,      	Var_ProxAmorti,     Entero_Cero,        Entero_Cero,		Var_FechaSistema,
				Var_FecAplicacion,  	Var_IVAComAntici,   Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    	Var_SucCliente,		Des_PagoCred,       Ref_PagAnti,        AltaPoliza_NO,
				Entero_Cero,			Var_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Con_IVAComFin,
				Mov_IVAComLiqAnt,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,
				Var_SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,	Par_EmpresaID,
				Par_ModoPago,			Aud_Usuario,        Aud_FechaActual,   	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,       	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Var_SaldoPago   := Var_SaldoPago - Var_ComAntici - Var_IVAComAntici;

		-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
		UPDATE AMORTICREDITOCONT Tem
			SET NumTransaccion = Aud_NumTransaccion
				WHERE AmortizacionID = Var_ProxAmorti
					AND CreditoID = Par_CreditoID;

	END IF;

	/* SE OBTIENEN VALORES */
	IF(Var_ManejaLinea = SiManejaLinea)THEN
		SELECT	MonedaID,	SucursalID
				INTO
				MonedaLinea,	VarSucursalLin
			FROM  LINEASCREDITO
			WHERE LineaCreditoID = Var_LineaCredito;
	END IF;

	OPEN CURSORAMORTI;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		CICLO:LOOP

		FETCH CURSORAMORTI INTO
			Var_CreditoID,          Var_AmortizacionID ,    Var_SaldoCapVigente,    Var_SaldoCapAtrasa,
			Var_SaldoCapVencido,    Var_SaldoCapVenNExi,    Var_SaldoInteresOrd,    Var_SaldoInteresAtr,
			Var_SaldoInteresVen,    Var_SaldoInteresPro,    Var_SaldoIntNoConta,    Var_SaldoMoratorios,
			Var_SaldoComFaltaPa,    Var_SaldoOtrasComis,    Var_MonedaID,           Var_FechaInicio,
			Var_FechaVencim,        Var_FechaExigible,      Var_AmoEstatus,			Var_SaldoMoraVenci,
			Var_SaldoMoraCarVen,	Var_SaldoSeguroCuota,	Var_CobraComAnual,		Var_SaldoComAnual;

		-- Inicializaciones
		SET Var_CantidPagar			:= Decimal_Cero;
		SET Var_IVACantidPagar		:= Decimal_Cero;
		SET Var_NumPagSos       	:= Entero_Cero;
		SET	Var_SaldoMoraVenci		:= IFNULL(Var_SaldoMoraVenci, Entero_Cero);
		SET	Var_SaldoMoraCarVen		:= IFNULL(Var_SaldoMoraCarVen, Entero_Cero);
        SET	Var_SaldoSeguroCuota 	:= IFNULL(Var_SaldoSeguroCuota, Decimal_Cero);
		SET Var_SalCapitales     	:= Var_SaldoCapVigente + Var_SaldoCapAtrasa +
								   Var_SaldoCapVencido + Var_SaldoCapVenNExi;
		SET Var_CobraComAnual		:= IFNULL(Var_CobraComAnual, Cons_No);
		SET Var_SaldoComAnual		:= IFNULL(Var_SaldoComAnual, Entero_Cero);

		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	   IF( DATE_SUB(Var_FechaExigible, INTERVAL Var_DiasPermPagAnt DAY) > Var_FechaSistema AND Par_Finiquito = Finiquito_NO) THEN
			LEAVE CICLO;
		END IF;

		-- Consideraciones en el Cobro de la Comision por Falta de Pago
		-- De acuerdo a la Parametrizacion del Producto de Credito, la Comision por Falta de Pago
		-- Se puede Cobar en Cada Cuota, o Al final de la Prelacion, Siendo el ultimo concepto que se Pague.
		IF (Var_SaldoComFaltaPa >= Mon_MinPago AND Var_TipCobComFal = Cob_FalPagCuota) THEN

			SET	Var_IVACantidPagar = ROUND((Var_SaldoComFaltaPa *  Var_ValIVAGen), 2);

			IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoComFaltaPa + Var_IVACantidPagar)) THEN
				SET	Var_CantidPagar		:= Var_SaldoComFaltaPa;
			ELSE
				SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
										   ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);

				SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
			END IF;

	        CALL  PAGCRECONTCOMFALPRO (
	            Var_CreditoID,	    Var_AmortizacionID, 	Var_FechaInicio,    Var_FechaVencim,	Par_CuentaAhoID,
                Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,	Var_CantidPagar,    Var_IVACantidPagar,
                Var_MonedaID,       Var_ProdCreID,			Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
                Des_PagoCred,		Var_CuentaAhoStr,   	Var_Poliza,         Var_SalidaNO,		Par_NumErr,
                Par_ErrMen,			Par_Consecutivo,    	Par_EmpresaID,      Par_ModoPago,		Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,    	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

	        IF(Par_NumErr != Entero_Cero)THEN
				LEAVE CICLO;
			END IF;

	        -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
	        UPDATE AMORTICREDITOCONT Tem
			SET NumTransaccion = Aud_NumTransaccion
				WHERE AmortizacionID = Var_AmortizacionID
					AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		-- Pago de Comision x Anualidad
		IF(Var_CobraComAnual = Cons_Si) THEN/*COMISION ANUAL*/
			SET Var_IVACantidPagar	:= Entero_Cero;
			SET Var_CantidPagar 	:= Entero_Cero;

			IF(Var_ValIVAGen > Entero_Cero) THEN
				SET Var_IVACantidPagar 		:= ROUND((Var_SaldoComAnual * Var_ValIVAGen), 2);
			ELSE
				SET Var_IVACantidPagar 		:= Decimal_Cero;
			END IF;

			-- Se obtiene el Monto a Pagar
			IF(ROUND(Var_SaldoPago,2) >= (Var_SaldoComAnual + Var_IVACantidPagar)) THEN
				SET Var_CantidPagar		:= Var_SaldoComAnual;
			  ELSE
				SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
				SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
			END IF;

			CALL PAGCRECOMANUALCONTPRO (
				Var_CreditoID,		Var_AmortizacionID,		Var_FechaInicio,	Var_FechaVencim,	Par_CuentaAhoID,
				Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,	Var_CantidPagar,	Var_IVACantidPagar,
				Var_MonedaID,		Var_ProdCreID,			Var_ClasifCre,		Var_SubClasifID,	Var_SucCliente,
				Des_PagoCred,		Var_CuentaAhoStr,		Var_Poliza,			Var_SalidaNO,		Par_NumErr,
				Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,		Par_ModoPago,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
			    LEAVE CICLO;
			END IF;

			-- Se actualiza el Numero de Transaccion en AMORTICREDITOCONT
			UPDATE AMORTICREDITOCONT Tem
			SET NumTransaccion = Aud_NumTransaccion
				WHERE AmortizacionID = Var_AmortizacionID
					AND CreditoID = Par_CreditoID;

			-- Se obtiene el monto disponible para realizar los pagos siguientes
			SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;/*COMISION ANUAL*/
		END IF; -- FIN Pago Comision x Anualidad

		-- Saldo de Interes Moratorio de Cartera Vigente
		IF (Var_SaldoMoratorios >= Mon_MinPago) THEN

			SET	Var_IVACantidPagar = ROUND((Var_SaldoMoratorios *  Var_ValIVAIntMo), 2);

			IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoMoratorios + Var_IVACantidPagar)) THEN
				SET	Var_CantidPagar		:=  Var_SaldoMoratorios;
			ELSE
				SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
										   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

				SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);
			END IF;

	        CALL  PAGCRECONTMORAPRO (
	            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
	            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
	            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
	            Des_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Var_SalidaNO,		Par_NumErr,
	            Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,		Aud_Usuario,
	            Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

	        IF(Par_NumErr != Entero_Cero)THEN
			    LEAVE CICLO;
			END IF;

			-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
			UPDATE AMORTICREDITOCONT Tem
			SET NumTransaccion = Aud_NumTransaccion
				WHERE AmortizacionID = Var_AmortizacionID
					AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		IF (Var_SaldoInteresAtr >= Mon_MinPago) THEN

			SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresAtr, 2) *  Var_ValIVAIntOr), 2);

			IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresAtr, 2) + Var_IVACantidPagar)) THEN
				SET	Var_CantidPagar		:=  Var_SaldoInteresAtr;
			ELSE
				SET	Var_CantidPagar		:= Var_SaldoPago -
										   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

				SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);
			END IF;

			CALL PAGCREINTATRCONTPRO (
				Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
				Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
				Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
				Des_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Var_SalidaNO,		Par_NumErr,
				Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,		Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
			    LEAVE CICLO;
			END IF;

			-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
			UPDATE AMORTICREDITOCONT Tem
			SET NumTransaccion = Aud_NumTransaccion
				WHERE AmortizacionID = Var_AmortizacionID
					AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		IF(Par_EsPrePago = PrePago_NO AND Par_Finiquito = Finiquito_NO AND
			Var_ProyInPagAde = NO_ProyectInt AND Var_FechaExigible > Var_FechaSistema
			AND (
			Var_EstatusCre = Esta_Vigente
			OR (Var_EsReestruc = SI_EsReestruc AND
				Var_EstCreacion  = Esta_Vencido AND
				Var_Regularizado = No_Regulariza))) THEN

			SET Var_PagoAdeSinProy = ValorSI;

		END IF;

		--  se devenga interes proyectado cuando es un pago de cuota adelantado (NO Prepago, NI finiquito)
		IF(Par_EsPrePago = PrePago_NO AND Par_Finiquito = Finiquito_NO AND
			Var_ProyInPagAde = SI_ProyectInt AND Var_FechaExigible > Var_FechaSistema
			AND (
			Var_EstatusCre = Esta_Vigente
			OR (Var_EsReestruc = SI_EsReestruc AND
				Var_EstCreacion  = Esta_Vencido AND
				Var_Regularizado = No_Regulariza))) THEN

			CALL CREANTIINTERECONTPRO(
				Var_CreditoID,      Var_EstatusCre,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Var_CreTasa,        Var_DiasCredito,    Var_FecAplicacion,
				Var_FechaSistema,   Var_Poliza,         Var_IntAntici,      Var_SalidaNO,		Par_NumErr,
				Par_ErrMen,			Par_EmpresaID,      Par_ModoPago,		Aud_Usuario,        Aud_FechaActual,
				Aud_DireccionIP,  	Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
			    LEAVE CICLO;
			END IF;

			SET Var_SaldoInteresPro := Var_SaldoInteresPro + IFNULL(Var_IntAntici, Entero_Cero);
		END IF;

		IF (Var_SaldoInteresPro >= Mon_MinPago) THEN

			SET	Var_IVACantidPagar := ROUND((ROUND(Var_SaldoInteresPro, 2) *  Var_ValIVAIntOr), 2);

			IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresPro, 2) + Var_IVACantidPagar)) THEN
				SET	Var_CantidPagar		:=  Var_SaldoInteresPro;
			ELSE
				 SET Var_CantidPagar    := Var_SaldoPago - ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr,2);

				 SET Var_IVACantidPagar := ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);
			END IF;

	        CALL PAGCREINTPROCONTPRO (
	            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
	            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
	            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
	            Des_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Var_SalidaNO,		Par_NumErr,
	            Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,     	Par_ModoPago,		Aud_Usuario,
	            Aud_FechaActual,  	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
			    LEAVE CICLO;
			END IF;

			-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
			UPDATE AMORTICREDITOCONT Tem
			SET NumTransaccion = Aud_NumTransaccion
				WHERE AmortizacionID = Var_AmortizacionID
					AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		-- Verificamos si Aplica Proyectar Intereses en Pago Adelantado de la Cuota
	    IF(Par_EsPrePago = PrePago_NO AND Par_Finiquito = Finiquito_NO AND
	        Var_ProyInPagAde = SI_ProyectInt AND Var_FechaExigible > Var_FechaSistema AND
	        Var_EstatusCre = Esta_Vencido) THEN

	        CALL CREANTIINTERECONTPRO(
	            Var_CreditoID,      Var_EstatusCre,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
	            Var_SubClasifID,    Var_SucCliente,     Var_CreTasa,        Var_DiasCredito,    Var_FecAplicacion,
	            Var_FechaSistema,   Var_Poliza,         Var_IntAntici,      Var_SalidaNO,		Par_NumErr,
	            Par_ErrMen,			Par_EmpresaID,      Par_ModoPago,		Aud_Usuario,        Aud_FechaActual,
	            Aud_DireccionIP,  	Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion );

            IF(Par_NumErr != Entero_Cero)THEN
			    LEAVE CICLO;
			END IF;

			SET Var_SaldoIntNoConta := Var_SaldoIntNoConta + IFNULL(Var_IntAntici, Entero_Cero);
		END IF;

		IF (Var_SaldoCapAtrasa >= Mon_MinPago) THEN

			IF(ROUND(Var_SaldoPago,2)	>= Var_SaldoCapAtrasa) THEN
				SET	Var_CantidPagar		:= Var_SaldoCapAtrasa;
			ELSE
				SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2);
			END IF;

	        CALL PAGCRECAPATRCONTPRO (
	            Var_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,		Var_FechaVencim,    	Par_CuentaAhoID,
	            Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  	Var_CantidPagar,    	Decimal_Cero,
	            Var_MonedaID,       Var_ProdCreID,      	Var_ClasifCre,      	Var_SubClasifID,    	Var_SucCliente,
	            Des_PagoCred,       Var_CuentaAhoStr,   	Var_Poliza,         	Var_SalidaNO,			Par_NumErr,
	            Par_ErrMen,			Par_Consecutivo,    	Par_EmpresaID,      	Par_ModoPago,			Aud_Usuario,
	            Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
			    LEAVE CICLO;
			END IF;

			-- Ajuste para el proceso de pago revolvente en lineas de credito contigentes
			SET Var_CantidPagar := ROUND(Var_CantidPagar,2);
			CALL PAGCRELINCONTPRO (
				Var_CreditoID,		Var_AmortizacionID,		Var_CantidPagar,	Var_Poliza,
				Var_SalidaNO,		Par_NumErr,				Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero) THEN
				LEAVE CICLO;
			END IF;

			-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
			UPDATE AMORTICREDITOCONT Tem SET
				NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
			  AND CreditoID = Par_CreditoID;

			SET	Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		IF (Var_SaldoCapVigente >= Mon_MinPago) THEN

			IF(Var_SaldoPago	>= Var_SaldoCapVigente) THEN
				SET	Var_CantidPagar		:= Var_SaldoCapVigente;
			ELSE
				SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2);
			END IF;

			CALL PAGCRECAPVIGCONTPRO (
	            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
	            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Decimal_Cero,
	            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
	            Des_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Var_SalidaNO,		Par_NumErr,
	            Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,		Aud_Usuario,
	            Aud_FechaActual,  	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
			    LEAVE CICLO;
			END IF;

			-- Ajuste para el proceso de pago revolvente en lineas de credito contigentes
			SET Var_CantidPagar := ROUND(Var_CantidPagar,2);
			CALL PAGCRELINCONTPRO(
				Var_CreditoID,		Var_AmortizacionID,		Var_CantidPagar,	Var_Poliza,
				Var_SalidaNO,		Par_NumErr,				Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero) THEN
				LEAVE CICLO;
			END IF;

			-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
			UPDATE AMORTICREDITOCONT Tem SET
				NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
			  AND CreditoID = Par_CreditoID;

			SET	Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		END LOOP CICLO;
	END;
	CLOSE CURSORAMORTI;

	IF( Par_NumErr <> Entero_Cero ) THEN
		LEAVE ManejoErrores;
	END IF;

	-- Verificamos si el Tipo de Cobro de la Comision por Falta de Pago es al Final de la Prelacion
	IF(ROUND(Var_SaldoPago,2) > Decimal_Cero AND Var_TipCobComFal = Cob_FalPagFinal) THEN
		OPEN CURSORCOMFALPAG;
		BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		CICLOFALPAG:LOOP

			FETCH CURSORCOMFALPAG INTO
				Var_CreditoID,          Var_AmortizacionID ,    Var_SaldoComFaltaPa,    Var_MonedaID,
				Var_FechaInicio,        Var_FechaVencim,        Var_FechaExigible,      Var_AmoEstatus;

			-- Inicializacion
			SET Var_CantidPagar		:= Decimal_Cero;
			SET Var_IVACantidPagar	:= Decimal_Cero;

			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLOFALPAG;
			END IF;

			IF( DATE_SUB(Var_FechaExigible, INTERVAL Var_DiasPermPagAnt DAY) > Var_FechaSistema AND
				Par_Finiquito = Finiquito_NO) THEN
				LEAVE CICLOFALPAG;
			END IF;

			IF (Var_SaldoComFaltaPa >= Mon_MinPago) THEN

				SET	Var_IVACantidPagar := ROUND((Var_SaldoComFaltaPa *  Var_ValIVAGen), 2);

				IF(Var_SaldoPago	>= (Var_SaldoComFaltaPa + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar		:= Var_SaldoComFaltaPa;
				ELSE
					SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
											   ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);

	                SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
	            END IF;

	            CALL  PAGCRECONTCOMFALPRO (
	                Var_CreditoID,	    Var_AmortizacionID, 	Var_FechaInicio,   	 	Var_FechaVencim,		Par_CuentaAhoID,
	                Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,		Var_CantidPagar,    	Var_IVACantidPagar,
	                Var_MonedaID,       Var_ProdCreID,			Var_ClasifCre,      	Var_SubClasifID,    	Var_SucCliente,
	                Des_PagoCred,		Var_CuentaAhoStr,   	Var_Poliza,         	Var_SalidaNO,			Par_NumErr,
	                Par_ErrMen,			Par_Consecutivo,    	Par_EmpresaID,      	Par_ModoPago,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    	Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE CICLOFALPAG;
				END IF;

				-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
				UPDATE AMORTICREDITOCONT Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;

				SET	Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);

				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLOFALPAG;
				END IF;

			END IF;
			END LOOP CICLOFALPAG;
		END;
		CLOSE CURSORCOMFALPAG;
	END IF;

	SET Var_SaldoPago  := IFNULL(Var_SaldoPago, Entero_Cero);

	IF(Var_SaldoPago < Entero_Cero) THEN
		SET Var_SaldoPago   := Entero_Cero;
	END IF;

	SET	Var_MontoPago:= Par_MontoPagar - ROUND(Var_SaldoPago,2);

	IF (Var_MontoPago<= Decimal_Cero) THEN
			SET Par_NumErr		:= '100';
			SET Par_ErrMen		:= 'El Credito no Presenta Adeudos.';
			SET Par_Consecutivo	:= 0;
			SET Var_Control		:= 'creditoID';
	ELSE
		-- Amortizaciones que hayan Sido Afectada con el Pago Para evitar Marcar Como Pagadas, aquellas Amortizaciones
		-- Futuras que no Tienen Capital que son de Solo Interes
		UPDATE AMORTICREDITOCONT Amo SET
			Amo.Estatus		= Esta_Pagado,
			Amo.FechaLiquida	= Var_FechaSistema
			WHERE (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa + Amo.SaldoCapVencido + Amo.SaldoCapVenNExi +
				  Amo.SaldoInteresOrd + Amo.SaldoInteresAtr + Amo.SaldoInteresVen + Amo.SaldoInteresPro +
				  Amo.SaldoIntNoConta + Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen +
				  Amo.SaldoComFaltaPa + Amo.SaldoOtrasComis ) <= Tol_DifPago
			  AND Amo.CreditoID 	= Par_CreditoID
			  AND Amo.Estatus 	!= Esta_Pagado
			  AND Amo.NumTransaccion = Aud_NumTransaccion;

         --  Se obtiene el numero de amortizaciones atrasadas
        SET Var_NumeroAmort := (SELECT COUNT(*) FROM AMORTICREDITOCONT
								WHERE Estatus = Esta_Atrasado
                                AND CreditoID = Par_CreditoID);
		SET Var_NumeroAmort := IFNULL(Var_NumeroAmort, Entero_Cero);

         --  Se obtiene la fecha de la primer amortizacion atrasada
        SET Var_FechaMinAtraso := (SELECT MIN(FechaExigible) FROM AMORTICREDITOCONT
									WHERE CreditoID =  Par_CreditoID
                                    AND Estatus = Esta_Atrasado);

        --  Se obtiene el ID de la primer amortizacion atrasada
        SET Var_AmortizacionIDAtr	:= (SELECT MIN(AmortizacionID) FROM AMORTICREDITOCONT
										WHERE CreditoID =  Par_CreditoID
										AND Estatus = Esta_Atrasado);

		SET Var_FechaMinAtraso := IFNULL(Var_FechaMinAtraso, Fecha_Vacia);

		--  Se realiza la suma de capital atrasado e interes atrasado
        SELECT	SUM(SaldoCapAtrasa), 	SUM(SaldoInteresAtr)
			INTO	Saldo_CapAtrasado, 	Saldo_IntAtrasado
		FROM AMORTICREDITOCONT
			WHERE CreditoID = Par_CreditoID
            	AND AmortizacionID = Var_AmortizacionIDAtr;

        --  Si el numero de amortizaciones es mayor a cero
		IF(Var_NumeroAmort > Entero_Cero) THEN
			--  Si el interes atrasado es mayor a acero y el capital atrasado es mayor a cero
			IF(Saldo_IntAtrasado > Entero_Cero AND Saldo_CapAtrasado > Entero_Cero) THEN
				--  Se actualiza la fecha de atraso de capital y la fecha de atraso del interes con la fecha de atraso de la primera amortizacion atrasada
				UPDATE CREDITOSCONT SET
		 			FechaAtrasoCapital = Var_FechaMinAtraso,
					FechaAtrasoInteres = Var_FechaMinAtraso
				WHERE CreditoID = Par_CreditoID;
			END IF;

            --  Si el saldo del interes atrasado es igual a cero y el saldo del capital atrasado es mayor a cero
            IF(Saldo_IntAtrasado = Entero_Cero AND Saldo_CapAtrasado > Entero_Cero) THEN
				--  Solo se actualiza la fecha de atraso de capital
				UPDATE CREDITOSCONT SET
		 			FechaAtrasoCapital = Var_FechaMinAtraso
				WHERE CreditoID = Par_CreditoID;

				--  Se obtiene la nueva fecha minima de atraso de la amortizacion que adeude interes atrasado
				SET Var_FechaMinAtraso 	:= (SELECT MIN(FechaExigible) FROM AMORTICREDITOCONT
											WHERE CreditoID =  Par_CreditoID
											AND Estatus = Esta_Atrasado
											AND SaldoInteresAtr != Entero_Cero);
				SET Var_FechaMinAtraso 	:= IFNULL(Var_FechaMinAtraso, Fecha_Vacia);
                --  Se actualiza la fecha de atraso de interes
				UPDATE CREDITOSCONT SET
					FechaAtrasoInteres = Var_FechaMinAtraso
				WHERE CreditoID = Par_CreditoID;
			END IF;
            --  Si el saldo de capital atrasado es igual a cero y el interes atrasado es mayor a cero
            IF(Saldo_CapAtrasado = Entero_Cero AND Saldo_IntAtrasado > Entero_Cero) THEN

				SET Var_FechaMinAtraso 	:= (SELECT MIN(FechaExigible) FROM AMORTICREDITOCONT
											WHERE CreditoID =  Par_CreditoID
											AND Estatus = Esta_Atrasado
											AND SaldoInteresAtr != Entero_Cero);
				SET Var_FechaMinAtraso 	:= IFNULL(Var_FechaMinAtraso, Fecha_Vacia);
                --  Se actualiza la fecha de atraso del interes
				UPDATE CREDITOSCONT SET
					FechaAtrasoInteres = Var_FechaMinAtraso
				WHERE CreditoID = Par_CreditoID;
			END IF;

		ELSE
			 UPDATE CREDITOSCONT SET
				FechaAtrasoCapital = Fecha_Vacia,
				FechaAtrasoInteres = Fecha_Vacia
			WHERE CreditoID = Par_CreditoID;
        END IF;

		-- Si es un Finiquito Marcamos las cuotas como Pagadas
		IF( Par_Finiquito = Finiquito_SI) THEN
			IF(Var_TipoLiquidacion = LiquidacionTotal) THEN
				UPDATE AMORTICREDITOCONT Amo SET
					Amo.Estatus			= Esta_Pagado,
					Amo.FechaLiquida	= Var_FechaSistema
				WHERE Amo.CreditoID  = Par_CreditoID
				  AND Amo.Estatus 	!= Esta_Pagado;

				UPDATE CREDITOSCONT SET
					FechaAtrasoCapital = Fecha_Vacia,
					FechaAtrasoInteres = Fecha_Vacia
				WHERE CreditoID = Par_CreditoID;
			END IF;

			IF(Var_TipoLiquidacion = LiquidacionParcial) THEN

				UPDATE AMORTICREDITOCONT Amo SET
					Amo.Estatus			= Esta_Pagado,
					Amo.FechaLiquida	= Var_FechaSistema
				WHERE Amo.CreditoID 	= Par_CreditoID
				  AND (Amo.Estatus 	= Esta_Vencido OR Amo.Estatus 	= Esta_Atrasado);

				UPDATE CREDITOSCONT SET
					FechaAtrasoCapital = Fecha_Vacia,
					FechaAtrasoInteres = Fecha_Vacia
				WHERE CreditoID = Par_CreditoID;

            END IF;
		END IF;

		SELECT COUNT(AmortizacionID) INTO Var_NumAmoPag
			FROM AMORTICREDITOCONT
				WHERE CreditoID	= Par_CreditoID
			  	AND Estatus	= Esta_Pagado;

		SET Var_NumAmoPag := IFNULL(Var_NumAmoPag, Entero_Cero);

	    SELECT COUNT(AmortizacionID) INTO Var_NumAmorti
			FROM AMORTICREDITOCONT
				WHERE CreditoID	= Par_CreditoID;

		SET Var_NumAmorti := IFNULL(Var_NumAmorti, Entero_Cero);

		IF (Var_NumAmorti = Var_NumAmoPag) THEN

			UPDATE CREDITOSCONT SET
				Estatus			= Esta_Pagado,
				FechTerminacion	= Var_FechaSistema,

				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE CreditoID = Par_CreditoID;


            SET Var_MontoCont := (SELECT ComAperCont FROM CREDITOSCONT WHERE CreditoID = Par_CreditoID);
            --  Se verifica si aun tiene Saldo de Comision pendiente por contabilizar
			IF(Var_MontoCont>Decimal_Cero) THEN
				--  Si el monto de la Comision por apertura es mayor que cero, se procede a generar los asientos contables
				IF(Var_MontoComAp > Decimal_Cero)THEN

					SET Var_MontoAmort:= ROUND(Var_MontoCont,2); 	--  Obtiene el monto que se abona a la cuenta de Com. por Apert

					--  Se realiza el CARGO a la cuenta Puente (Gasto)
					CALL CONTACREDITOSCONTPRO (
						Par_CreditoID,			Entero_Cero,				Entero_Cero,			Entero_Cero,			Var_FechaSistema,
						Var_FechaSistema,		Var_MontoAmort,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
						Var_SubClasifID,		Var_SucCliente,				Var_DescComAper,		Cadena_Vacia,			AltaPoliza_NO,
						Entero_Cero,			Var_Poliza,					AltaPolCre_SI,			AltaMovCre_NO,			Con_ContGastos,
						Entero_Cero,			Nat_Cargo,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
						Var_SalidaNO,			Par_NumErr,					Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
						Cadena_Vacia,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Ref_PagAnti,
						Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;


					--  Se realiza el ABONO a la cuenta de Comision por Apertura de Credito
					CALL CONTACREDITOSCONTPRO (
						Par_CreditoID,			Entero_Cero,				Entero_Cero,			Entero_Cero,			Var_FechaSistema,
						Var_FechaSistema,		Var_MontoAmort,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
						Var_SubClasifID,		Var_SucCliente,				Var_DescComAper,		Cadena_Vacia,			AltaPoliza_NO,
						Entero_Cero,			Var_Poliza,					AltaPolCre_SI,			AltaMovCre_NO,			Con_ContComApe,
						Entero_Cero,			Nat_Abono,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
						Var_SalidaNO,			Par_NumErr,					Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
						Cadena_Vacia,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Ref_PagAnti,
						Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					--  Actualizando el Campo ComAperCont para disminuir lo que ya ha sido contabilizado
					UPDATE CREDITOSCONT SET
						ComAperCont = ComAperCont - Var_MontoAmort
					WHERE CreditoID= Par_CreditoID;

				END IF;

			END IF;

		END IF;

		CALL CONTAAHORROPRO (
			Par_CuentaAhoID,	Var_CueClienteID,	Aud_NumTransaccion,	Var_FechaSistema,	Var_FecAplicacion,
			Nat_Cargo,			Var_MontoPago,		Des_PagoCred,		Var_CreditoStr,		Aho_PagoCred,
			Var_MonedaID,		Var_SucCliente,		AltaPoliza_NO,		Entero_Cero,		Var_Poliza,
			AltaMovAho_SI,		Con_AhoCapital,		Nat_Cargo,			Par_NumErr,			Par_ErrMen,
			Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
		/* Comentado porque se confirmara su uso para reversas
		CALL DEPOSITOPAGOCREPRO (
			Par_CreditoID,		Var_MontoPago,	Var_FechaSistema,		Par_EmpresaID,		Var_SalidaNO,
			Par_NumErr,			Par_ErrMen,		Par_Consecutivo,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
		*/
		CALL RESPAGCREDITOCONTALT(
			Aud_NumTransaccion,	Par_CuentaAhoID,	Par_CreditoID,	Var_MontoPago,		Var_SalidaNO,
			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;

	END IF;

	-- Si se pago Adelantadamente SIN proyectar los intereses, entonces lo tratamos
	-- Como un prepago y Recalculamos los intereses de la Tabla de Amortizacion
	IF (Var_PagoAdeSinProy = ValorSI) THEN-- Actualizacion de los intereses
		-- Actualizacion de los intereses
		IF(Var_Refinancia = ValorSI) THEN
			# Recalculo de intereses con refinanciamiento
			CALL AMORTICREDITOAGROACT(
				Par_CreditoID,		TipoActInteres,			FechaReal,				Var_SalidaNO,		Par_NumErr,
				Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		ELSE
			CALL AMORTICREDITOCONTACT(
				Par_CreditoID,		TipoActInteres,    	Var_SalidaNO,		Par_NumErr, 		Par_ErrMen,
				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	SET Par_NumErr		:= Entero_Cero;
	SET Par_ErrMen		:= 'Pago Aplicado Exitosamente';
	SET Par_Consecutivo	:= Entero_Cero;
	SET Var_Control		:= 'creditoID';

END ManejoErrores;

IF (Par_Salida = ValorSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$