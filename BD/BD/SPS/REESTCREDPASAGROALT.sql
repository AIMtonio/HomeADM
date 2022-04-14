-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REESTCREDPASAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REESTCREDPASAGROALT`;DELIMITER $$

CREATE PROCEDURE `REESTCREDPASAGROALT`(
# ==================================================================================================================
# ---------------------- SP PARA DAR DE ALTA UNA REESTRUCTURA DE CREDITO PASIVO AGRO  -----------------------------
# ==================================================================================================================
	Par_FechaRegistro		DATE,			-- Fecha de alta del tratamiento al credito
	Par_UsuarioID 			INT(11),		-- Usuario que registra el tratamiento al credito
	Par_CreditoOrigenID		BIGINT(12),		-- Credito a renovar o reestructurar
	Par_CreditoDestinoID 	BIGINT(12),		-- Credito renovador o rfeestructurador
	Par_SaldoCredAnteri		DECIMAL(12,2), 	-- Saldo del credito origen

	Par_EstatusCredAnt	 	CHAR(1),		-- Estatus del credito origen en el momento de sus tratamiento
	Par_EstatusCreacion		CHAR(1),		-- Estatus con el que nace el credito destino, V=vigente, B=vencido
	Par_NumDiasAtraOri		INT(11),		-- Numero de dias de atrado del credito origen
	Par_NumPagoSoste 		INT(11),		-- Numero de pagos sostenidos que se aplicaran al credito destino para su regularizacion
	Par_NumPagoActual 		INT(11),		-- Numero de pagos sostenidos aplicados a la fecha al credito destino

	Par_Regularizado 		CHAR(1),		-- Indica si el credito destino esta regualarizado o no
	Par_FechaRegula 		DATE,			-- Fecha en la el credito destino alcanza su regularizacion
	Par_NumeroReest 		INT(11), 		-- Numero de tratamientos aplicados al mismo credito
	Par_ReservaInteres		DECIMAL(14,2),	-- Monto de EPRC para interes en cuentas de orden
	Par_SaldoInteres		DECIMAL(14,2),	-- Saldo del Interes refinanciado con el tratamiento al credito

	Par_SaldoInteresMora	DECIMAL(14,2),	-- Saldo del Interes refinanciado con el tratamiento al credito
	Par_SaldoComisiones		DECIMAL(14,2),	-- Saldo del Interes refinanciado con el tratamiento al credito
	Par_Origen 				CHAR(1),		-- Tipo de Tratamiento: O= Renovacion, R= Reestructura
	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),

	INOUT	Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Var_NomControl			CHAR(20);
	DECLARE Var_Tratamiento			VARCHAR(20);
	DECLARE Var_EstatusReest		CHAR(1);
	DECLARE Var_SolicitudCreditoID	BIGINT(20);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_CuentaAhoID			BIGINT(12);
	DECLARE Var_NumAmorti			INT(11);
    DECLARE Var_NumAmorInt			INT(11);
	DECLARE Var_CreditoID       	BIGINT(12);
	DECLARE Var_AmortizID      	 	INT;
	DECLARE Var_Cantidad        	DECIMAL(14,2);
	DECLARE Var_Consecutivo     	BIGINT;
	DECLARE Var_MonedaID        	INT(11);
    DECLARE	Var_FechaInicio			DATE;
	DECLARE Var_TipoPagoCapital 	CHAR(1);
	DECLARE Var_FrecuenciaCap		CHAR(1);
    DECLARE	Var_FrecuenciaInt		CHAR(1);
	DECLARE	Var_PeriodicidadCap 	INT;
	DECLARE	Var_PeriodicidadInt 	INT;
	DECLARE Var_DiaMesCapital		INT;
	DECLARE Var_DiaMesInteres   	INT;
	DECLARE	Var_MontoCuota			DECIMAL(14,2);
	DECLARE Var_ValorCAT			DECIMAL(14,4);
    DECLARE Var_SucCliReest			INT(11);
    DECLARE Var_ProdCreID			INT(11);
    DECLARE Var_ClasifCre			CHAR(1);
    DECLARE Var_SubClasifID 		INT(11);
    DECLARE Var_EstatusAmor			CHAR(1);
    DECLARE Var_FechaSistema		DATE;
	DECLARE Var_AmoCredStr      	VARCHAR(30);
    DECLARE Var_Poliza				BIGINT(20);
    DECLARE Var_SalCapVig			DECIMAL(14,2);
    DECLARE Var_SaldCapAtr			DECIMAL(14,2);
    DECLARE Var_SaldCapVen			DECIMAL(14,2);
    DECLARE Var_SaldCapVenNoEx		DECIMAL(14,2);
    DECLARE Var_MontoOpera			DECIMAL(14,2);
    DECLARE Var_MontoConta			DECIMAL(14,2);
    DECLARE Var_MontoIVAComCont		DECIMAL(14,2);
    DECLARE Var_TipoConsultaSIC		CHAR(2);
    DECLARE Var_FolioConsultaBC		VARCHAR(30);
    DECLARE Var_FolioConsultaCC 	VARCHAR(30);
    DECLARE Var_NumReestr			INT(11);		-- Numero de Reestructuras
    DECLARE Var_ConsecutivRes		BIGINT(20);		-- Numer Consecutivo
    DECLARE Var_TotalAdeudoCap		DECIMAL(14,2);
	DECLARE Var_TotalAdeudoInt		DECIMAL(14,2);
	DECLARE Var_TotalAdeudoMora		DECIMAL(14,2);
	DECLARE Var_TotalAdeudoCom		DECIMAL(14,2);
	DECLARE Var_AdeudoInt			DECIMAL(14,2);
	DECLARE Var_AdeudoMora			DECIMAL(14,2);
	DECLARE Var_AdeudoCom			DECIMAL(14,2);


    DECLARE Var_NumAmortPas			INT(11);		-- Numero de Amortizaciones del Credito Activo
    DECLARE Var_MaxAmorPas			INT(11);		-- Maxima Amortizacion creada del Credito Activo
    DECLARE Var_MinAmorPas			INT(11);		-- Minima Amortizacion creada del Credito Activo
    DECLARE Var_AdeudoCredPas		DECIMAL(14,2);	-- Adeudo del Credito Pasivo
    DECLARE Var_MontoAmorPas		DECIMAL(14,2);	-- Monto por Amortizaciones en el credito Pasivo
    DECLARE Var_MontoAcumPas		DECIMAL(14,2);	-- Monto actualizado en las amortizaciones del credito
    DECLARE Var_CreditoFonID 		BIGINT(20);		--
    DECLARE Var_AmortizacionID		INT(11);
	DECLARE Var_SaldoCapVigente		DECIMAL(12, 2);
	DECLARE Var_SaldoCapAtrasad		DECIMAL(12, 2);
    DECLARE Var_NumMaxDiasMora	INT(11);


    DECLARE Var_EstatusCre     		CHAR(1);
	DECLARE Var_PagaIva 			CHAR(1);			/* Guarda el valor para saber si el credito paga IVA*/
	DECLARE Var_IVA 				DECIMAL(12,2);		/* Guarda el valor del IVA */
	DECLARE Var_InstitutFondID		INT(11);			/* Guarda el valor de la institucion de fondeo */
	DECLARE Var_PlazoContable		CHAR(1);			/* Guarda el valor de plazo contable C.- Corto plazo L.- Largo Plazo*/
	DECLARE Var_TipoInstitID		INT(11);			/* Guarda el valor tipo de institucion */
    DECLARE Var_NacionalidadIns		CHAR(1);			/* Guarda el valor de nacionalidad de la institucion*/
	DECLARE Var_EsRevolvente		CHAR(1);
	DECLARE Var_TipoRevol			CHAR(1);			/* Tipo de Revolvencia*/
    DECLARE Var_LineaFondeoID		INT;				/* Linea de fondeo ID */
    DECLARE Var_MontoOtorga     	DECIMAL(14,2);
    DECLARE Var_CobraISR    		CHAR(1);            /* No cobra ISR */
    DECLARE Var_TipoFondeo  		CHAR(1);            /* Tipo de Operacion: I-Inversionista, F.- Fondeador */
    DECLARE Par_CreditoFonID		BIGINT(20);			-- Numero del Credito Pasivo
    DECLARE Var_SaldoPago       	DECIMAL(12, 2);
    DECLARE Var_InstitucionID		INT(11);			-- ID institucion de linea de fondeo anterior
    DECLARE Var_NumCtaInstit		VARCHAR(20);		-- Numero de Cuenta Bancaria.
    DECLARE Var_NumCtaInstitStr 	VARCHAR(50);		/* Numero de cuenta Institucion convertida a caracter */
    DECLARE Var_CantidPagar     	DECIMAL(14,4);
    DECLARE Var_IVACantidPagar  	DECIMAL(12, 2);
    DECLARE Var_TotalBancos    	 	DECIMAL(14,2);
    DECLARE Var_TotalRetener   	 	DECIMAL(14,2);
    DECLARE Var_CreditoStr			VARCHAR(20);


	DECLARE Var_TipoCredito			CHAR(1);
	DECLARE Var_MontoPago       	DECIMAL(14,2);
	DECLARE Var_PagoAplica     	 	DECIMAL(14,2);
	DECLARE Par_Consecutivo     	BIGINT;
	DECLARE MontoCred           	DECIMAL(14,2);
	DECLARE	Var_MontoComAp			DECIMAL(14,2);
	DECLARE Var_IVAComAp  			DECIMAL(14,2);
	DECLARE Var_MontoSegVida		DECIMAL(14,2);
	DECLARE PrePago_NO          	CHAR(1);
	DECLARE Finiquito_SI       	 	CHAR(1);
	DECLARE Var_CargoCuenta			CHAR(1); -- Indica que se trata de un pago con cargo a cuenta
	DECLARE Str_NumErr          	CHAR(3);
	DECLARE Var_RelaEstatus 		CHAR(1);
	DECLARE EstatusPagado       	CHAR(1);
	DECLARE MovTesoPago				CHAR(4);			/* Indica el tipo de movimiento de tesoreria pago de credito pasivo tabla TIPOSMOVTESO */
    DECLARE Est_Vigente    			CHAR(1);
	DECLARE Var_ConcepFonCap		INT(11);			# concepto de capital que corresponde con la tabla CONCEPTOSFONDEO
    DECLARE OtorgaCrePasID			CHAR(4); 						# ID del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO
    DECLARE Var_AcfectacioConta 	CHAR(1); 						# VARIA DE AFECTACION CONTABLE SI='S',NO='N'

	# Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Entero_Cero     		INT;
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Var_SI          		CHAR(1);
	DECLARE Var_NO          		CHAR(1);
	DECLARE Estatus_Cancela    	 	CHAR(1);
	DECLARE Estatus_Pagado      	CHAR(1);
	DECLARE EstaInactivo    		CHAR(1);
	DECLARE EstaAutoriza    		CHAR(1);
	DECLARE SalidaSI        		CHAR(1);
	DECLARE SalidaNO        		CHAR(1);
	DECLARE OrigenReestructura		CHAR(1);
	DECLARE OrigenRenovacion		CHAR(1);
	DECLARE Estatus_Vigente			CHAR(1);
	DECLARE Estatus_Vencido			CHAR(1);
	DECLARE Estatus_Atrasado		CHAR(1);
	DECLARE Estatus_Desembolso  	CHAR(1);
	DECLARE Estatus_Alta 			CHAR(1);
	DECLARE Estatus_Autorizado		CHAR(1);
    DECLARE Estatus_Vig				CHAR(1);
	DECLARE CalendarioReestruc		INT(11);
	DECLARE Mov_CapVigente      	INT(11);
	DECLARE Mov_CapVeNoExi      	INT(11);
    DECLARE Mov_CapAtrasado			INT(11);
    DECLARE Mov_CapVencido			INT(11);
	DECLARE Con_CapVigente 			INT(11);
	DECLARE Con_CapAtrasado			INT(11);
	DECLARE Con_CapVencido			INT(11);
	DECLARE Con_CapVeNoExi 			INT(11);
	DECLARE Nat_Cargo           	CHAR(1);
	DECLARE DescripcionMov			VARCHAR(100);
	DECLARE PagLibres				CHAR(1);
    DECLARE AltaPoliza_SI   		CHAR(1);
    DECLARE AltaPoliza_NO   		CHAR(1);
	DECLARE AltaPolCre_NO   		CHAR(1);
	DECLARE AltaPolCre_SI   		CHAR(1);
	DECLARE AltaMovAho_SI   		CHAR(1);
	DECLARE AltaMovAho_NO   		CHAR(1);
	DECLARE AltaMovCre_SI   		CHAR(1);
	DECLARE AltaMovCre_NO   		CHAR(1);
	DECLARE Nat_Abono       		CHAR(1);
    DECLARE Pro_PasoVenc			INT(11);
	DECLARE ConcReestrRen			INT(11);
    DECLARE Tol_DifPago				DECIMAL(10,4);
	DECLARE Con_Origen				CHAR(1);

    DECLARE Var_CtaOrdAbo			INT(11);						# Cta. Orden Correlativa (Abono) con la tabla CONCEPTOSFONDEO
	DECLARE Var_CtaOrdCar			INT(11);						# Cta. Orden Contingente (Cargo) con la tabla CONCEPTOSFONDEO
    DECLARE Var_ConcepConDes		INT(11);						# concepto de contable  de DESEMBOLSO DE CREDITO CREDITO PASIVO tabla CONCEPTOSCONTA

	-- Reestructuras

    DECLARE Act_TipoActInteres	INT(11);
    DECLARE FechaReal			CHAR(1);	# Tipo de Calculo de interes R:FechaReal
    DECLARE	Pol_Automatica		CHAR(1);		/* Indica que se trata de una poliza automatica */
    DECLARE Des_PagoCred   	 	VARCHAR(50);
	DECLARE Con_PagoCred    	VARCHAR(50);
    DECLARE RevPagoCuota    	CHAR(1);            /* Revolvencia En cada pago de cuota */

	# Declaracion de cursores
    		DECLARE CURSORAMORTI CURSOR FOR
		SELECT  Amo.CreditoFondeoID,	Amo.AmortizacionID,		Amo.SaldoCapVigente,	Amo.SaldoCapAtrasad, Cre.MonedaID
			FROM AMORTIZAFONDEO Amo,
				 CREDITOFONDEO	Cre
			WHERE	Amo.CreditoFondeoID = Cre.CreditoFondeoID
			  AND	Cre.CreditoFondeoID	= Par_CreditoFonID
			  AND	Cre.Estatus		= 'N'
			  AND	(	Amo.Estatus		= 'A'           -- En Atraso
			  OR		Amo.Estatus		= 'N'	)         -- Vigente
			ORDER BY Amo.FechaExigible;


	DECLARE CURSORFONDEOMOVS CURSOR FOR
		SELECT AMO.CreditoFondeoID,  AMO.AmortizacionID, Aud_NumTransaccion,	AMO.Capital
			FROM
			AMORTIZAFONDEO AS AMO INNER JOIN
			CREDITOFONDEO AS CRED ON AMO.CreditoFondeoID = CRED.CreditoFondeoID
			WHERE
				CRED.CreditoFondeoID = Par_CreditoFonID
				AND CRED.Estatus ='N'
				AND AMO.Capital> Entero_Cero
				AND AMO.Estatus = 'N';

	# Asignacion de Constantes
	SET Cadena_Vacia    	:= '';              -- Cadena o String Vacio
	SET Fecha_Vacia     	:= '1900-01-01';    -- Fecha vacia
	SET Entero_Cero     	:= 0;               -- Entero en Cero
	SET Decimal_Cero		:= 0.0;				-- Decimal cero
	SET Var_SI          	:= 'S';             -- Valor para Si
	SET Var_NO          	:= 'N';             -- Valor para Si
	SET Estatus_Cancela     := 'C';             -- Estatus de la Reest: Cancelado
	SET Estatus_Pagado      := 'P';             -- Estatus del Credito: Pagado
	SET EstaInactivo    	:= 'I';             -- Estatus del Credito: Inactivo
	SET EstaAutoriza    	:= 'A';             -- Estatus del Credito: Autorizado
	SET SalidaSI        	:= 'S';             -- El Store SI genera una Salida
	SET SalidaNO        	:= 'N';             -- El Store NO genera una Salida
	SET OrigenReestructura	:= 'R';             -- Tipo de Tratamiento: Reestructura
	SET OrigenRenovacion	:= 'O';				-- Tipo de tratamiento: Renovacion
	SET Estatus_Vigente		:= 'V';				-- Estatus vigente
    SET Estatus_Vencido		:= 'B'; 			-- Estatus vencido
    SET Estatus_Atrasado	:= 'A'; 			-- Estatus Atrasado
	SET Estatus_Desembolso	:= 'D';				-- Estatus desembolsado
	SET Estatus_Alta		:= 'A';				-- Estatus del registro en REESTRUCCREDITO, A=alta, C=cancelado, D=desembolsado
	SET Estatus_Autorizado	:= 'A';				-- Estatus liberado
    SET Estatus_Vig			:= 'N';				-- Estatus Vigente creditos pasivos
	SET CalendarioReestruc	:= 2;				-- Calendario de pagos para credito reestructura
	SET Mov_CapVigente      := 1;  		       	-- Tipo del Movimiento de Credito: Capital Vigente (TIPOSMOVSCRE)
    SET Mov_CapAtrasado 	:= 2;    			-- Tipo del Movimiento de Credito: Capital Atrasado (TIPOSMOVSCRE)
	SET Mov_CapVencido  	:= 3; 				-- Tipo del Movimiento del Credito: Capital Vencido (TIPOSMOVSCRE)
	SET Mov_CapVeNoExi      := 4;  		       	-- Tipo del Movimiento de Credito: Capital Vencido No Exigible
    SET Con_CapVigente 		:= 1;				-- Concepto Cartera: Capital Vigente
	SET Con_CapAtrasado		:= 2;				-- Concepto Cartera: Capital Atrasado
	SET Con_CapVencido		:= 3; 				-- Concepto Cartera: Capital Vencido
	SET Con_CapVeNoExi 		:= 4;				-- Concepto Cartera: Capital Vencido No Exigible
	SET Nat_Cargo           := 'C';             -- Naturaleza de Cargo
	SET DescripcionMov		:= 'REESTRUCTURA DE CREDITO PASIVO';
	SET PrePago_NO          := 'N';             -- El Tipo de Pago No es PrePago
	SET Finiquito_SI        := 'S';
	SET Var_CargoCuenta		:= 'C';
	SET Str_NumErr			:= '0';
	SET EstatusPagado       := 'P';		       	-- Estatus de Pagado
	SET PagLibres			:= 'L';
    SET AltaPoliza_SI   	:= 'S';             -- Alta de la Poliza Contable: SI
	SET AltaPoliza_NO   	:= 'N';             -- Alta de la Poliza Contable: NO
	SET AltaPolCre_SI   	:= 'S';             -- Alta de la Poliza Contable de Credito: SI
	SET AltaPolCre_NO   	:= 'N';             -- Alta de la Poliza Contable de Credito: NO
	SET AltaMovCre_NO   	:= 'N';             -- Alta de los Movimientos de Credito: NO
	SET AltaMovCre_SI   	:= 'S';             -- Alta de los Movimientos de Credito: SI
	SET AltaMovAho_NO   	:= 'N';             -- Alta de los Movimientos de Ahorro: NO
	SET AltaMovAho_SI   	:= 'S';             -- Alta de los Movimientos de Ahorro: SI.
	SET Nat_Abono       	:= 'A';             -- Naturaleza de Abono.
    SET Pro_PasoVenc		:= 205;
    SET ConcReestrRen		:= 66;
    SET Tol_DifPago			:= 0.05;
    SET Con_Origen			:= 'S';				-- Constante Origen donde se llama el SP (S= safy, W=WS)1
    SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

    SET Act_TipoActInteres	:= 1;				-- Fondeo por Financiamiento
    SET	Pol_Automatica		:= 'A';				-- Indica que se trata de una poliza automatica
    SET Des_PagoCred    	:= 'PAGO DE CREDITO PASIVO';
	SET Con_PagoCred    	:= 'PAGO DE CREDITO PASIVO';
    SET Par_Consecutivo		:= 0;
    SET RevPagoCuota		:= 'P';				/* Revolvencia En cada pago de cuota*/
    SET MovTesoPago			:= '31';			/* Indica el tipo de movimiento de tesoreria pago de credito pasivo tabla TIPOSMOVTESO */
    SET Est_Vigente			:= 'N';				-- Estatus Vigente
    SET FechaReal			:= 'R';				-- Fecha Real
    SET Var_ConcepFonCap	:= 1; 							# concepto de capital que corresponde con la tabla CONCEPTOSFONDEO
    SET OtorgaCrePasID		:= 30; 							# ID del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO
    SET Var_CtaOrdAbo		:= 12;							# Cta. Orden Correlativa (Abono) con la tabla CONCEPTOSFONDEO
	SET Var_CtaOrdCar		:= 11;							# Cta. Orden Contingente (Cargo) con la tabla CONCEPTOSFONDEO
    SET Var_ConcepConDes	:= 23; 							# concepto de contable  de DESEMBOLSO DE CREDITO CREDITO PASIVO tabla CONCEPTOSCONTA

    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
			   SET Par_NumErr  = 999;
			   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-REESTCREDPASAGROALT');
			   SET Var_NomControl  = 'SQLEXCEPTION';
			END;

	# Inicializacion de variables
    SET Var_TotalBancos     := Entero_Cero;
    SET Var_TotalRetener    := Entero_Cero;

    SELECT NumMaxDiasMora INTO Var_NumMaxDiasMora FROM PARAMETROSSIS LIMIT 1;

    SET Var_NumMaxDiasMora  := IFNULL(Var_NumMaxDiasMora, Entero_Cero);



    SELECT  	FechaAutoriza, 			TipoPagoCapital, 		FrecuenciaCap,			FrecuenciaInt,			PeriodicidadCap,
				PeriodicidadInt,		DiaMesCapital,			DiaMesInteres,			MontoCuota
		INTO 	Var_FechaInicio, 		Var_TipoPagoCapital,	Var_FrecuenciaCap,		Var_FrecuenciaInt, 		Var_PeriodicidadCap,
				Var_PeriodicidadInt,	Var_DiaMesCapital,		Var_DiaMesInteres,		Var_MontoCuota
		FROM SOLICITUDCREDITO
		WHERE Relacionado = Par_CreditoOrigenID AND TipoCredito = OrigenReestructura AND Estatus = Estatus_Desembolso;


    # Se obtiene el numero del credito pasivo
    SET Par_CreditoFonID 	:= (SELECT CreditoFondeoID FROM RELCREDPASIVOAGRO
									WHERE CreditoID = Par_CreditoOrigenID);

	SET Var_AdeudoCredPas	:= (SELECT FUNCIONTOTALCAPPASIVO(Par_CreditoFonID));	-- Adeudo Total del Credito Pasivo


    SELECT	Cre.Estatus,		Cre.MonedaID,			IFNULL(PagaIVA,Var_NO),			Cre.InstitutFondID,				PlazoContable,
			TipoInstitID,		Cre.NacionalidadIns,	IFNULL(PorcentanjeIVA/100,0),	IFNULL(EsRevolvente,Var_NO),	TipoRevolvencia,
			Cre.LineaFondeoID,	Cre.Monto,				IFNULL(ins.CobraISR,Var_NO),    Cre.TipoFondeador
	INTO
			Var_EstatusCre,		Var_MonedaID,			Var_PagaIva,					Var_InstitutFondID,				Var_PlazoContable,
			Var_TipoInstitID,	Var_NacionalidadIns,	Var_IVA,				 		Var_EsRevolvente,				Var_TipoRevol,
			Var_LineaFondeoID,	Var_MontoOtorga,		Var_CobraISR,   				Var_TipoFondeo
			FROM	CREDITOFONDEO Cre,
					LINEAFONDEADOR Lin,
					INSTITUTFONDEO ins
			WHERE	Cre.CreditoFondeoID	= Par_CreditoFonID
			 AND	Cre.LineaFondeoID 	= Lin.LineaFondeoID
			 AND	ins.InstitutFondID	= Lin.InstitutFondID;


	SELECT	lin.InstitucionID, 		lin.NumCtaInstit,	AfectacionConta
	INTO 	Var_InstitucionID,		Var_NumCtaInstit,	Var_AcfectacioConta
		FROM	LINEAFONDEADOR lin
		WHERE	lin.LineaFondeoID    = Var_LineaFondeoID
			AND lin.InstitutFondID = Var_InstitutFondID;


	IF(Var_PagaIva <> Var_SI) THEN
		SET Var_IVA := Decimal_Cero;
	ELSE
		SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
	END IF;

	SELECT 	SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasad,2)),  -- Var_TotalAdeudoCap
			SUM(ROUND(SaldoInteresAtra + SaldoInteresPro,2)), -- Var_AdeudoInt
			SUM(ROUND(SaldoMoratorios,2)) AS Var_AdeudoMora, -- Var_AdeudoMora
			SUM(ROUND(SaldoComFaltaPa,2) + ROUND(SaldoOtrasComis,2)),	-- Var_AdeudoCom
			SUM(ROUND(SaldoInteresAtra + SaldoInteresPro,2) +
				ROUND( 	ROUND(SaldoInteresAtra * Var_IVA, 2) +
						ROUND(SaldoInteresPro * Var_IVA, 2), 2)), -- Var_TotalAdeudoInt
			SUM(ROUND(SaldoMoratorios,2) +
				ROUND( ROUND(SaldoMoratorios * Var_IVA,2), 2)),   -- Var_TotalAdeudoMora
			SUM(ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_IVA,2) +
				ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_IVA,2))-- Var_TotalAdeudoCom

	INTO	Var_TotalAdeudoCap,		Var_AdeudoInt,		Var_AdeudoMora,		Var_AdeudoCom,		Var_TotalAdeudoInt,
			Var_TotalAdeudoMora,	Var_TotalAdeudoCom
	FROM AMORTIZAFONDEO
	WHERE CreditoFondeoID = Par_CreditoFonID
		AND Estatus IN (Est_Vigente, Estatus_Atrasado );



		SET Var_Tratamiento	:= 'Reestructurar';
		SET Var_SaldoPago := (SELECT FUNCIONTOTALCAPPASIVO(Par_CreditoFonID));	-- Adeudo Total del Credito Pasivo


	# ============================================================================================================================
	# -------------------------------------- VALIDACIONES PARA UNA REESTRUCTURA DE CREDITO ---------------------------------------
	SET Var_CreditoStr	:= CONVERT(Par_CreditoFonID, CHAR(15));
	-- Se obtienen los datos de la nueva Solicitud de Credito
	IF(Par_Origen = OrigenReestructura) THEN


		IF EXISTS (SELECT CreditoOrigenID FROM  REESTRUCCREDITOFONDEO
												WHERE CreditoOrigenID = Par_CreditoFonID
													AND Origen = OrigenRenovacion
													AND EstatusReest  = Estatus_Desembolso LIMIT 1) THEN
			SET Par_NumErr      := 001;
			SET Par_ErrMen      := 'No se Permite Reestructurar un Cr&eacute;dito Pasivo Renovado.';
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_TotalAdeudoCom > Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := CONCAT('El Cr&eacute;dito Pasivo a Reestructurar tiene Adeudo de Comisiones: $', FORMAT(Var_TotalAdeudoCom, 2),'. Folio: ',Par_CreditoFonID);
			SET Var_NomControl := 'montoAutorizado';
			LEAVE TerminaStore;
		END IF;
		IF(Var_TotalAdeudoMora > Entero_Cero) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := CONCAT('El Cr&eacute;dito Pasivo a Reestructurar tiene Adeudo de Inter&eacute;s Moratorio: $', FORMAT(Var_TotalAdeudoMora, 2),'. Folio: ',Par_CreditoFonID);
			SET Var_NomControl := 'montoAutorizado';
			LEAVE TerminaStore;
		END IF;
		IF(Var_TotalAdeudoInt > Entero_Cero) THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := CONCAT('El Cr&eacute;dito Pasivo a Reestructurar tiene Adeudo de Intereses: $', FORMAT(Var_TotalAdeudoInt, 2),'. Folio: ',Par_CreditoFonID);
			SET Var_NomControl := 'montoAutorizado';
			LEAVE TerminaStore;
		END IF;
		IF(Par_NumDiasAtraOri > Var_NumMaxDiasMora AND Var_EstatusCre = Estatus_Vencido) THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := CONCAT('El Numero de D&iacute;as de Mora del Cr&eacute;dito Pasivo a Reestructurar es Mayor al Permitido.<br>',
									  'D&iacute;as Mora Cr&eacute;dito: ',Par_NumDiasAtraOri, '<br>',
									  'D&iacute;as Mora Permitidos: ', Var_NumMaxDiasMora, '.<br>',
                                      'Folio: ',Par_CreditoFonID);
			SET Var_NomControl := 'solicitudCreditoID';
			LEAVE TerminaStore;
		END IF;

		SET Var_Consecutivo := Entero_Cero;

		-- Se crea el encabezado de la Poliza
		CALL MAESTROPOLIZASALT(
				Var_Poliza,			Par_EmpresaID,		Par_FechaRegistro, 		Pol_Automatica,		ConcReestrRen,
				DescripcionMov,		SalidaNO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr > Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		# CURSOR para realizar los movimientos operativos y contables de las amortizaciones originales del credito
        # SE PAGAN LAS AMORTIZACIONES ANTERIORES
		OPEN CURSORAMORTI;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP

				FETCH CURSORAMORTI INTO
					Var_CreditoFonID,       Var_AmortizacionID,     Var_SaldoCapVigente,    Var_SaldoCapAtrasad,	Var_MonedaID;

					-- Inicializaciones
					SET Var_CantidPagar		:= Decimal_Cero;
					SET Var_IVACantidPagar	:= Decimal_Cero;

					/* Se convierte el numero de cuenta de institucion a char para utilizarlo en la referencia */
			 		SET Var_NumCtaInstitStr := CONVERT(Var_NumCtaInstit,CHAR);

					/*Pago de Capital Vigente */
					IF(Var_SaldoPago	>= Var_SaldoCapVigente) THEN
						SET	Var_CantidPagar		:= Var_SaldoCapVigente;
					ELSE
						SET	Var_CantidPagar		:= Var_SaldoPago;
					END IF;

					SET Var_IVACantidPagar	:= Decimal_Cero;

					/* Se manda a llamar al sp que hace el pago de capital vigente, aplica movimientos operativos y contables */
					CALL PAGCREFONCAPVIGPRO(
						Var_CreditoFonID,		Var_AmortizacionID,			Var_MonedaID,		Var_InstitutFondID,			Var_InstitucionID,
						Var_NumCtaInstit,		Var_PlazoContable,			Var_TipoInstitID,	Var_NacionalidadIns,		DescripcionMov,
						Var_TipoFondeo,			Var_Poliza,					Var_CantidPagar,	Var_IVACantidPagar,			Var_FechaSistema,
						Var_FechaSistema,		Var_NumCtaInstitStr,		SalidaNO,			Par_NumErr,					Par_ErrMen,
						Par_Consecutivo,		Par_EmpresaID,				Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,
						Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;


					/* Se llama al metodo para aplicar la Revolvencia, si la Revolvencia es en Cada Pago de Capital */
                    # AFECTACION CONTABLE DE LA LINEA DE FONDEO (SE ACTUALIZA EL SALDO DE LA LINEA DE FONDEO)
					IF (Var_EsRevolvente = Var_SI AND Var_TipoRevol = RevPagoCuota) THEN
						CALL CREFONAPLICAREVPRO(
							Var_LineaFondeoID,  Var_CantidPagar,    Var_MonedaID,       Var_InstitutFondID,	Var_FechaSistema,
                            Var_CreditoFonID,   Var_Poliza,         SalidaNO,			Var_Poliza,         Par_NumErr,
                            Par_ErrMen,         Par_Consecutivo,	Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                            Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;

					SET Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

                    -- Se marcan las amortizaciones como Pagadas
                    UPDATE AMORTIZAFONDEO SET
						Estatus 		= Estatus_Pagado,
						FechaLiquida 	= Par_FechaRegistro
					WHERE CreditoFondeoID	= Par_CreditoFonID
					AND AmortizacionID = Var_AmortizacionID;
					/* si ya no hay saldo para aplicar se sale del ciclo */
					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;


				END LOOP CICLO;
			END;
		CLOSE CURSORAMORTI;

		IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
		END IF;

		/* Se hace el movimiento operativo y contable de tesoreria */
			/* Se afecta la Cuenta de Bancos por el monto del Pago - La Retencion */

		SET Var_MontoPago	 := Var_AdeudoCredPas - ROUND(Var_SaldoPago,2);
		SET Var_TotalBancos := Var_MontoPago - Var_TotalRetener;

		CALL CONTAFONDEOPRO(
			Var_MonedaID,       Entero_Cero,        Var_InstitutFondID,	Var_InstitucionID,		Var_NumCtaInstit,
			Par_CreditoFonID,	Var_PlazoContable,	Var_TipoInstitID,	Var_NacionalidadIns,	Entero_Cero,
			DescripcionMov,		Var_FechaSistema,	Var_FechaSistema,	Var_FechaSistema,		Var_TotalBancos,
			Var_CreditoStr,		Var_CreditoStr,		AltaPoliza_NO,      Entero_Cero,			Cadena_Vacia,
			Nat_Abono,			Cadena_Vacia,		Nat_Cargo,			AltaMovCre_SI,			MovTesoPago,
			Var_NO,             Entero_Cero,		Entero_Cero,		Var_NO,					Var_TipoFondeo,
			Var_NO,				Var_Poliza,			Par_Consecutivo,	Par_NumErr,				Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion );

            IF(Par_NumErr > Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		-- Se valida el tipo de Pago de Capital para generar las amortizaciones cuando sean CRECIENTES o IGUALES
	  IF(Var_TipoPagoCapital = PagLibres) THEN

        # SE OBTIENE EL NUMERO DE AMORTIZACIONES QUE SE CREARON EN LA REESTRUCTURA DEL CREDITO ACTIVO
        SET Var_NumAmortPas := (SELECT COUNT(AmortizacionID)
								FROM AMORTICREDITO
                                WHERE Estatus <> Estatus_Pagado
                                AND CreditoID = Par_CreditoOrigenID);

        SET Var_MaxAmorPas := (SELECT MAX(AmortizacionID)
								FROM AMORTICREDITO
                                WHERE Estatus <> Estatus_Pagado
                                AND CreditoID = Par_CreditoOrigenID);

		SET Var_MinAmorPas	:= (SELECT MIN(AmortizacionID)
								FROM AMORTICREDITO
                                WHERE Estatus <> Estatus_Pagado
                                AND CreditoID = Par_CreditoOrigenID);

        SET Var_MontoAcumPas := Decimal_Cero;



		# SE CREAN LAS AMORTIZACIONES DEL CREDITO PASIVO
		CALL AMORTIZAFONDEOAGROALT (
				Par_CreditoFonID,		Par_CreditoOrigenID,	SalidaNO,			Par_NumErr,			Par_ErrMen,
                Par_Consecutivo,		Par_EmpresaID,			Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,			Aud_NumTransaccion);

        IF(Par_NumErr > Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        SET Var_MontoAmorPas 	:= (Var_AdeudoCredPas/Var_NumAmortPas);	-- Monto de Capital por Amortizacion

        # Se realiza ciclo para actualizar el capital de las amortizaciones de la reestructura
		WHILE(Var_MinAmorPas < Var_MaxAmorPas) DO

			UPDATE	AMORTIZAFONDEO
				SET	Capital 		= Var_MontoAmorPas
			WHERE	AmortizacionID	= Var_MinAmorPas
				AND CreditoFondeoID	= Par_CreditoFonID;

			SET Var_MontoAcumPas := Var_MontoAcumPas + Var_MontoAmorPas;	-- Monto que se ha ido actualizando de capital
			SET Var_MinAmorPas := Var_MinAmorPas + 1;     					-- Incrementa el numero de Amortizacion

        END WHILE;

        -- Se setea valor para el monto de la ultima amortizacion de la reestructura del credito pasivo.
        SET Var_MontoAmorPas  := Var_AdeudoCredPas - Var_MontoAcumPas;

        -- Se actualiza el capital para la ultima amortizacion del credito reestructurado.
       UPDATE AMORTIZAFONDEO
                SET Capital = Var_MontoAmorPas
                WHERE AmortizacionID = Var_MaxAmorPas
                AND CreditoFondeoID = Par_CreditoFonID;

		END IF;


		# AFECTACION CONTABLE DE LA LINEA DE FONDEO (SE ACTUALIZA EL SALDO DE LA LINEA DE FONDEO)
        -- Se actualiza la linea de fondeo de credito
		CALL SALDOSLINEAFONACT(
			Var_LineaFondeoID,	Nat_Cargo,			Var_AdeudoCredPas,				SalidaNO,				Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
			LEAVE ManejoErrores;
		END IF;


        -- CUENTA ORDEN LINEA DE FONDEO --
		IF(Var_AcfectacioConta = Var_SI)THEN
			-- --------------------------------------------------------------------------------------
			-- Se manda a llamar sp para hacer la parte contable que corresponde con la cuenta de orden
			-- contingente (Cargo)
			-- --------------------------------------------------------------------------------------
			CALL CONTAFONDEOPRO(
				Var_MonedaID,							Var_LineaFondeoID,						Var_InstitutFondID,		Var_InstitucionID,		Var_NumCtaInstit,
				Par_CreditoFonID,						Var_PlazoContable,						Var_TipoInstitID,		Var_NacionalidadIns,	Var_CtaOrdCar,
				DescripcionMov,						Var_FechaSistema,							Var_FechaSistema,		Var_FechaSistema,		Var_AdeudoCredPas,
				CONVERT(Par_CreditoFonID,CHAR),		CONVERT(Par_CreditoFonID,CHAR),				Var_NO,					Entero_Cero,			Nat_Abono,
				Nat_Abono,								Nat_Abono,								Nat_Abono,				Var_NO,					OtorgaCrePasID,
				Var_NO,									Entero_Cero,							Mov_CapVigente,			Var_SI,					Var_TipoFondeo,
				SalidaNO,								Var_Poliza,								Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
				Par_EmpresaID,							Aud_Usuario,							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,							Aud_NumTransaccion  );

			IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
				LEAVE ManejoErrores;
			END IF;

			-- --------------------------------------------------------------------------------------
			-- Se manda a llamar sp para hacer la parte contable que corresponde con la cuenta de orden
			-- contingente (Abono)
			-- --------------------------------------------------------------------------------------
			CALL CONTAFONDEOPRO(
				Var_MonedaID,							Var_LineaFondeoID,						Var_InstitutFondID,		Var_InstitucionID,		Var_NumCtaInstit,
				Par_CreditoFonID,						Var_PlazoContable,						Var_TipoInstitID,		Var_NacionalidadIns,	Var_CtaOrdAbo,
				DescripcionMov,							Var_FechaSistema,						Var_FechaSistema,		Var_FechaSistema,		Var_AdeudoCredPas,
				CONVERT(Par_CreditoFonID,CHAR),		CONVERT(Par_CreditoFonID,CHAR),				Var_NO,					Entero_Cero,			Nat_Cargo,
				Nat_Cargo,								Nat_Cargo,								Nat_Cargo,				Var_NO,					OtorgaCrePasID,
				Var_NO,									Entero_Cero,							Mov_CapVigente,			Var_SI,					Var_TipoFondeo,
				SalidaNO,								Var_Poliza,								Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
				Par_EmpresaID,							Aud_Usuario,							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,							Aud_NumTransaccion  );

			IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
				LEAVE ManejoErrores;
			END IF;
		END IF; -- Afectacion contable Linea
		-- FIN CUENTA ORDEN LINEA DE FONDEO

        -- Se manda a llamar sp para hacer la parte contable
		CALL CONTAFONDEOPRO(
			Var_MonedaID,							Var_LineaFondeoID,					Var_InstitutFondID,		Var_InstitucionID,			Var_NumCtaInstit,
			Par_CreditoFonID,						Var_PlazoContable,					Var_TipoInstitID,		Var_NacionalidadIns,		Var_ConcepFonCap,
			DescripcionMov,							Var_FechaSistema,					Var_FechaSistema,		Var_FechaSistema,			Var_AdeudoCredPas,
			CONVERT(Par_CreditoFonID,CHAR),			CONVERT(Par_CreditoFonID,CHAR),		Var_NO,					Var_ConcepConDes,			Nat_Abono,
			Nat_Cargo,								Nat_Cargo,							Nat_Abono,				Var_SI,						OtorgaCrePasID,
			Var_NO,									Entero_Cero,						Mov_CapVigente,			Var_NO,						Var_TipoFondeo,
			SalidaNO,								Var_Poliza,							Par_Consecutivo,		Par_NumErr,					Par_ErrMen,
			Par_EmpresaID,							Aud_Usuario,						Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,							Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		# CURSOR para registrar el saldo de capital de las amortizaciones que nacen con la reestructura en capital vigente o en vencido no exigible
		# Se generan los movimientos operativos y contables.
		# CURSOR para registrar el saldo de capital de las amortizaciones en capital vigente o en vencido no exigible
		OPEN CURSORFONDEOMOVS;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP
				FETCH CURSORFONDEOMOVS INTO
					Var_CreditoID, 	Var_AmortizID,	Aud_NumTransaccion,	Var_Cantidad;

					CALL CREDITOFONDMOVSALT(
						Var_CreditoID,		Var_AmortizID,		Aud_NumTransaccion,		Var_FechaSistema,	Var_FechaSistema,
						Mov_CapVigente,		Nat_Cargo,			Var_MonedaID,			Var_Cantidad,		DescripcionMov,
						Par_CreditoOrigenID,SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_Consecutivo,
						Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr > Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
					-- Se manda a llamar sp para hacer la parte contable por el monto total desembolsado.
					CALL CONTAFONDEOPRO(
						Var_MonedaID,							Var_LineaFondeoID,						Var_InstitutFondID,		Var_InstitucionID,		Var_NumCtaInstit,
						Par_CreditoFonID,					Var_PlazoContable,							Var_TipoInstitID,		Var_NacionalidadIns,	Var_ConcepFonCap,
						DescripcionMov,						Var_FechaSistema,							Var_FechaSistema,		Var_FechaSistema,		Var_Cantidad,
						CONVERT(Par_CreditoFonID,CHAR),		CONVERT(Par_CreditoFonID,CHAR),				AltaPoliza_NO,			Entero_Cero,			Nat_Abono,
						Nat_Cargo,								Nat_Cargo,								Nat_Abono,				Var_NO,					OtorgaCrePasID,
						Var_NO,									Entero_Cero,							Mov_CapVigente,			Var_SI,					Var_TipoFondeo,
						SalidaNO,								Var_Poliza,								Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
						Par_EmpresaID,							Aud_Usuario,							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,							Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE CICLO;
					END IF;
				END LOOP CICLO;
			END;
		CLOSE CURSORFONDEOMOVS;

        IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
		END IF;


		# Actualizan los intereses de las nuevas amortizaciones que nacen con la reestructura
		CALL AMORTIZAFONDEOACT(
			Par_CreditoFonID,	Act_TipoActInteres,		FechaReal,				SalidaNO,			Par_NumErr,
            Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

         IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
		END IF;

			SET Var_NumAmorti	:= (SELECT COUNT(AmortizacionID)
									FROM AMORTIZAFONDEO
									WHERE CreditoFondeoID = Par_CreditoFonID AND Estatus IN (Estatus_Vig, Estatus_Atrasado, EstatusPagado));

			SET Var_NumAmorInt	:= (SELECT COUNT(Interes)
									FROM AMORTIZAFONDEO
									WHERE CreditoFondeoID = Par_CreditoFonID
									AND Estatus IN (Estatus_Vig, Estatus_Atrasado, EstatusPagado)
									AND Interes > Decimal_Cero);

			UPDATE CREDITOFONDEO SET
				Estatus         	= Par_EstatusCreacion,
				NumAmortizacion 	= Var_NumAmorti,
                NumAmortInteres 	= Var_NumAmorInt,
				TipoCredito			= OrigenReestructura,
                Monto				= Par_SaldoCredAnteri,
                FechaInicio			= Var_FechaInicio,
				TipoPagoCapital		= Var_TipoPagoCapital,
				FrecuenciaCap		= Var_FrecuenciaCap,
				FrecuenciaInt		= Var_FrecuenciaInt,
				PeriodicidadCap		= Var_PeriodicidadCap,
				PeriodicidadInt		= Var_PeriodicidadInt,
				DiaMesCapital		= Var_DiaMesCapital,
				DiaMesInteres		= Var_DiaMesInteres,
				MontoCuota			= Var_MontoCuota,

				Usuario         	= Aud_Usuario,
				FechaActual     	= Aud_FechaActual,
				DireccionIP     	= Aud_DireccionIP,
				ProgramaID      	= Aud_ProgramaID,
				Sucursal        	= Aud_Sucursal,
				NumTransaccion  	= Aud_NumTransaccion
			WHERE CreditoFondeoID	= Par_CreditoFonID;

			SET Var_EstatusReest := Estatus_Desembolso;
			SET	Par_NumErr := Entero_Cero;
			SET	Par_ErrMen := CONCAT('Cr&eacute;dito Reestructurado Exitosamente: ', Par_CreditoOrigenID );

		END IF; -- Termina: IF(Par_Origen = OrigenReestructura) THEN


		#======================================================================================================================================
		# ------------------------------------------- SE REGISTRA EL CREDITO EN LA TABLA DE TRATAMIENTOS ---------------------------------------
		SET Var_NumReestr := (SELECT COUNT(CreditoOrigenID) FROM REESTRUCCREDITOFONDEO
								WHERE CreditoOrigenID = Par_CreditoFonID);

		SET Var_NumReestr := (IFNULL(Var_NumReestr,Entero_Cero));


        IF(Var_NumReestr > Entero_Cero) THEN


			UPDATE REESTRUCCREDITOFONDEO
				SET NumPagoSoste	= Par_NumPagoSoste,
					NumeroReest	 	= Par_NumeroReest,
					NumDiasAtraOri 	= Par_NumDiasAtraOri,
					EstatusReest 	= Par_EstatusCredAnt,
					EstatusCredAnt 	= Par_EstatusCredAnt,
					EstatusCreacion = Par_EstatusCreacion
            WHERE CreditoOrigenID 	= Par_CreditoFonID;


		 ELSE


			INSERT INTO REESTRUCCREDITOFONDEO(
					FechaRegistro,  		UsuarioID,          	CreditoOrigenID,    	CreditoDestinoID,   	SaldoCredAnteri,
					EstatusCredAnt, 		EstatusCreacion,    	NumDiasAtraOri,     	NumPagoSoste,       	NumPagoActual,
					Regularizado,   		FechaRegula,        	NumeroReest,        	ReservaInteres,     	SaldoInteres,
					SaldoInteresMora,		SaldoComisiones,		EstatusReest,			Origen,					EmpresaID,
                    Usuario,            	FechaActual, 			DireccionIP,			ProgramaID,				Sucursal,
                    NumTransaccion  )
			VALUES(
					Par_FechaRegistro,  	Par_UsuarioID,          Par_CreditoFonID,   	Par_CreditoFonID,   	Par_SaldoCredAnteri,
					Par_EstatusCredAnt, 	Par_EstatusCreacion,    Par_NumDiasAtraOri,     Par_NumPagoSoste,       Par_NumPagoActual,
					Par_Regularizado,   	Par_FechaRegula,        Par_NumeroReest,        Par_ReservaInteres,     Par_SaldoInteres,
					Par_SaldoInteresMora,	Par_SaldoComisiones,	Var_EstatusReest,   	Par_Origen,				Par_EmpresaID,
                    Aud_Usuario,            Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
                    Aud_NumTransaccion);

	 END IF;

	END ManejoErrores;  -- End del Handler de Errores


	 IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_NomControl 	AS control,
				Entero_Cero 	AS consecutivo;
	END IF;

END TerminaStore$$