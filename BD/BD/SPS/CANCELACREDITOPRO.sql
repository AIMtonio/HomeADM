-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELACREDITOPRO`;
DELIMITER $$

CREATE PROCEDURE `CANCELACREDITOPRO`(
# ===========================================================
# --------- SP PARA EL PROCESO DE CANCELACION DE CREDITOS ---------
# ===========================================================
	Par_CreditoID		BIGINT(12),			# Numero de Credito
	INOUT Par_Poliza	BIGINT(20),			# Numero de Poliza
    Par_Capital			DECIMAL(14,2),		# Monto Capital a Cancelar
    Par_Interes			DECIMAL(14,2),		# Monto Interes a Cancelar
    Par_MontoGarantia	DECIMAL(14,2),		# Monto Garantia a Cancelar
    Par_MontoComAper	DECIMAL(14,2),		# Monto de la comision por apertura
    Par_UsuarioAut		INT(11),			# Usuario que autoriza la cancelacion
    Par_MotivoCancela	VARCHAR(200),		# Motivo de la cancelacion

    Par_Salida          CHAR(1),			# Salida S:SI N:NO
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	-- Parametros de Auditoria
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_TipoDispersion		CHAR(1);			-- Indica el tipo de dispersion C:Cheque  S:Spei  O:Orden de Pago
    DECLARE Var_SaldoDipon          DECIMAL(12,2);		-- Saldo disponible de la cuenta
    DECLARE Var_MontoCancela		DECIMAL(14,2);		-- Monto Total a Cancelar
    DECLARE Var_GarLiquida			DECIMAL(12,2);		-- Monto cobrado de garantia Liquida
    DECLARE Var_PorcGarLiq			DECIMAL(12,2);		-- Porcentaje de garantia liquida
    DECLARE Var_InverEnGar      	INT(11);			-- Cantidad de inversiones en garantia
	DECLARE Var_Control             VARCHAR(100);		-- Variable de control
    DECLARE Var_ForCobComAp			CHAR(1);			-- Forma de Cobro de Comision por Apertura
    DECLARE Var_CuentaAhoID			BIGINT(12);			-- Numero de Cuenta de Ahorro del Cliente
    DECLARE Var_ProductoCredID		INT(11);			-- Numero de producto de credito
	DECLARE Var_MontoComAp			DECIMAL(12,2);		-- Monto de Comision por Apertura
    DECLARE Var_BloqueoID       	INT(11);			-- Clave de bloqueo
    DECLARE Var_FechaOper			DATE;				-- Fecha de Operacion
	DECLARE Var_FechaApl        	DATE;				-- Fecha de Aplicacion
    DECLARE Var_EsHabil         	CHAR(1);			-- Indica si el dia es habil
    DECLARE Var_Descripcion    	 	VARCHAR(100);		-- Descripcion del Movimiento
    DECLARE Var_SucCliente      	INT(11);			-- Sucursal del Cliente
    DECLARE Var_ClienteID       	INT(11);			-- Numero de Cliente
    DECLARE Var_MontoCred       	DECIMAL(14,2);		-- Monto del Credito
    DECLARE Var_MonedaID        	INT(11);			-- Clave Moneda
    DECLARE Var_ClasifCre       	CHAR(1);			-- Clasificacion del Credito
    DECLARE Var_SubClasifID     	INT(11);			-- Subclasificacion del Credito
    DECLARE Par_Consecutivo     	BIGINT(20);			-- Consecutivo
    DECLARE Var_TipoMovCred			INT(11);			-- Tipo de movimiento de credito
    DECLARE Var_CreditoID       	BIGINT(12);		 	-- Variables Var_CreditoID para el CURSOR
    DECLARE Var_AmortizID       	INT(11);			-- Variable Var_AmortizID para el CURSOR
    DECLARE Var_Cantidad       	 	DECIMAL(14,2);		-- Variable Var_Cantidad para el CURSOR
    DECLARE Var_SoliciCredID    	BIGINT(20);			-- Numero de Solicitud de Credito
    DECLARE Var_FolioBlo			INT(11);			-- Folio del Bloqueo
    DECLARE Var_FolioDesb			INT(11);			-- Folio de Desbloqueo
    DECLARE Var_FolioDisper			INT(11);			-- Folio de la Dispersion
    DECLARE CtaAhoID				BIGINT(12);			-- Cuenta de Ahorro(Movimientos en Dispersion)
    DECLARE Var_MontoMov			DECIMAL(12,2);		-- Monto de Movimiento de la Dispersion
    DECLARE var_RefCuentCheq		VARCHAR(150);		-- Referencia Cuenta-Cheque(Dispersion)
    DECLARE Var_ReferenciaMov		VARCHAR(35);		-- Referencia Movimiento(Dispersion)
    DECLARE Var_EstTeso				CHAR(1);			-- Estatus del Movimiento de Tesoreria
    DECLARE Var_TipoMovimiento		INT(11);			-- Tipo de Movimiento de Tesoreria
    DECLARE Var_FormaPago			INT(1);				-- Forma de Pago de la Dispersion
    DECLARE Mon_Base				INT(11);			-- Moneda Base (PARAMETROSSIS)
    DECLARE Var_InstitucionID		INT(11);			-- Institucion
    DECLARE Var_CuentaBancaria		VARCHAR(20);		-- Cuenta Bancaria
    DECLARE Var_ProveedorID			INT(11);			-- Proveedor
    DECLARE Var_NumeroCheque		VARCHAR(25);		-- Numero de Cheque
    DECLARE Var_Refere				VARCHAR(100);		-- Referencia del Movimiento
    DECLARE Var_AltaMovAho			CHAR(1);			-- Indica si se realizaran los movimentos a la cuenta de Ahorro S:SI  N:NO
    DECLARE Var_ClaveDispMov		INT(11);			-- Clave de Dispersion por movimiento
    DECLARE Tip_MovAho				CHAR(4);			-- Tipo de movimiento de ahorro
    DECLARE Var_ComAperPagada		DECIMAL(12,2);		-- Monto Comision por Apertura Pagada
    DECLARE Var_TipoChequera		CHAR(1);			-- Tipo Chequera E:Estandar   P:Proforma
	DECLARE Des_Contable			VARCHAR(200);		-- Descripcion Movimientos Tesoreria

	DECLARE Var_MontoPagadoAcc		DECIMAL(14,2);		-- Monto Pagado de Accesorios
	DECLARE Var_AbrevAccesorio		VARCHAR(20);		-- Abreviatura del Accesorio
	DECLARE Var_CobraIVAAc			CHAR(1);			-- Indica si el Accesorio cobra IVA
	DECLARE Var_MontoAccesorio		DECIMAL(14,2);		-- Indica el que se cobro de accesorios
	DECLARE Var_MontoIVAAccesorio	DECIMAL(14,2);		-- Indica el monto de iva que se cobro del accesorio
	DECLARE Var_TipoFormaCobroAcc 	CHAR(1);			-- Forma de Cobro de los Accesorios.
	DECLARE Var_ConcepCarteraAcc	INT(11);			-- Concepto de Cartera
	DECLARE Var_ConceptoIVACarAcc	INT(11);			-- Concepto de Cartera al que corresponde el accesorio
	DECLARE Var_AccesorioID			INT(11);			-- Numero de Accesorio
	DECLARE Var_DescAccesorio		VARCHAR(100);		-- Variable Descripción Acceosorio
	DECLARE Var_DescIVAAcc			VARCHAR(100);		-- Variable Descripción IVA Accesorio
	DECLARE Var_RefGenAcc			VARCHAR(50);		-- Descripcion de la referencia de generacion de accesorios
	DECLARE Var_RefGenIVAAcc		VARCHAR(50);		-- Descripcion de la referencia de generacion del IVA de accesorios
    DECLARE Var_AccesoriosRow       VARCHAR(100);       -- Almacena los accesorios activos para un credito.
    DECLARE Var_numAccesorios       INT(11);
    DECLARE Var_Contador            INT(11);

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(12,2);
    DECLARE Fecha_Vacia         	DATE;

	DECLARE SalidaSI				CHAR(1);
    DECLARE Cons_NO					CHAR(1);
    DECLARE Cons_SI					CHAR(1);
	DECLARE DispersionSPEI      	CHAR(1);
	DECLARE DispersionCheque    	CHAR(1);
	DECLARE DispersionOrden			CHAR(1);
	DECLARE DispersionEfectivo		CHAR(1);
    DECLARE Act_LiberarPagCre		INT(11);
    DECLARE Programada				CHAR(1);
    DECLARE Nat_Bloqueo         	CHAR(1);
    DECLARE Nat_Desbloqueo      	CHAR(1);
    DECLARE Blo_Desemb				INT(11);
    DECLARE DescripBloqSPEI     	VARCHAR(40);
	DECLARE DescripBloqCheq     	VARCHAR(40);
    DECLARE	DescripBloqOrden		VARCHAR(50);
    DECLARE Deb_RevDesemb      	 	INT(11);
	DECLARE Var_CuentaAhoStr    	VARCHAR(20);
	DECLARE AltaPoliza_SI       	CHAR(1);
	DECLARE AltaPoliza_NO       	CHAR(1);
	DECLARE AltaPolCre_SI       	CHAR(1);
	DECLARE AltaMovAho_SI       	CHAR(1);
	DECLARE AltaMovAho_NO       	CHAR(1);
	DECLARE AltaMovCre_NO       	CHAR(1);
    DECLARE AltaMovCre_SI			CHAR(1);
	DECLARE AltaPolCre_NO       	CHAR(1);
    DECLARE Con_ContDesem       	INT(11);
    DECLARE Con_ContCapCre      	INT(11);
    DECLARE Nat_Cargo           	CHAR(1);
	DECLARE Nat_Abono           	CHAR(1);
    DECLARE Tip_MovAhoDesem     	CHAR(3);
	DECLARE Mov_CapVigente      	INT(11);
    DECLARE Est_Cancelado			CHAR(1);
    DECLARE Tipo_DesbDisper			INT(11);
    DECLARE Des_Desbloqueo    		VARCHAR(50);
    DECLARE No_Conciliado			CHAR(1);
    DECLARE Es_Automatico			CHAR(1);
    DECLARE Cheque					INT(11);
	DECLARE OrdenPago				INT(11);
    DECLARE Tip_MovAhoSPEI      	CHAR(4);
	DECLARE Tip_MovAhoCHEQ      	CHAR(4);
    DECLARE SI_AltaMovAho       	CHAR(1);
    DECLARE Est_Concilado  			CHAR(1);
    DECLARE Var_TipoChequeDesem 	CHAR(4);
    DECLARE Var_TipoSpeiDesemb  	CHAR(4);
    DECLARE Act_CancelaCre			INT(11);
    DECLARE Act_CancelaCheque		INT(11);
    DECLARE Con_CancelaCred			INT(11);
    DECLARE Des_ConceptoCont		VARCHAR(200);
    DECLARE Pol_Automatica  		CHAR(1);
    DECLARE Anticipado				CHAR(1);
    DECLARE Desc_Desembolso			VARCHAR(200);
    DECLARE RegistroPantalla		CHAR(1);
	DECLARE Var_MovOtrasComisiones	INT(11);			-- Tipo del Movimiento de Credito: Otras Comisiones (TIPOSMOVSCRE)
	DECLARE Var_MovIVAOtrasComis	INT(11);			-- Tipo del Movimiento de Credito: IVA Otras Comisiones (TIPOSMOVSCRE)
	DECLARE Var_FormaFinanciada		CHAR(1);			-- Forma de Cobro F:FINANCIADA
    DECLARE Var_SI                  CHAR(1);
    DECLARE Salida_NO               CHAR(1);

    DECLARE CURSORAMORTI CURSOR FOR
		SELECT  Amo.CreditoID,  Amo.AmortizacionID, Aud_NumTransaccion, Amo.Capital
			FROM 	AMORTICREDITO Amo
					INNER JOIN CREDITOS Cre ON Amo.CreditoID   = Cre.CreditoID
			WHERE	Cre.CreditoID   = Par_CreditoID
			AND 	Amo.Estatus   	= 'V'
			AND 	(Cre.Estatus  	= 'V')
			AND 	Amo.Capital 	> 0 ;

	-- Asignacion de Constantes

	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Cadena_Vacia				:= '';				-- Caden Vacia
	SET Decimal_Cero				:= 0.0;				-- DECIMAL Cero
    SET Fecha_Vacia         		:= '1900-01-01';    -- Fecha Vacia
    SET SalidaSI					:= 'S';				-- Salida SI

	SET Cons_NO						:= 'N';				-- Constante NO
    SET Cons_SI						:= 'S';				-- Constante SI
    SET DispersionSPEI     		 	:= 'S';    		 	-- Tipo de Dispersion por SPEI
	SET DispersionCheque    		:= 'C';     		-- Tipo de Dispersion por Cheque
	SET DispersionOrden	    		:= 'O';     		-- Tipo de Dispersion por Orden de pago
	SET DispersionEfectivo    		:= 'E';     		-- Tipo de Dispersion por Efectivo
    SET Act_LiberarPagCre			:= 3;
	SET Programada					:= 'P';				-- Cobro Comision Programada
    SET Nat_Bloqueo         		:= 'B';    		 	-- Naturaleza de Bloqueo
    SET Nat_Desbloqueo      		:= 'D';     		-- Naturaleza de Desbloqueo
    SET Blo_Desemb          		:= 1;       		-- Tipo de Bloqueo de Saldo en Cta: Dispersion del Desembolso
    SET DescripBloqSPEI     		:= 'BLOQUEO DE SALDO POR SPEI';
	SET DescripBloqCheq     		:= 'BLOQUEO DE SALDO POR CHEQUE';
    SET DescripBloqOrden			:= 'BLOQUEO DE SALDO POR ORDEN DE PAGO';
    SET Var_Descripcion     		:= 'CANCELACION DE CREDITO';
    SET Con_ContDesem       		:= 58;      		-- Concepto Contable de Reversa Desembolso (CONCEPTOSCONTA)
	SET AltaPoliza_SI       		:= 'S';     		-- Alta de Poliza Contable General: SI
	SET AltaPoliza_NO       		:= 'N';	    		-- Alta de Poliza Contable General: NO
	SET AltaPolCre_SI      		 	:= 'S';				-- Alta de Poliza Contable de Credito: SI
	SET AltaPolCre_NO       		:= 'N';     		-- Alta de Poliza Contable de Credito: NO
	SET AltaMovAho_SI       		:= 'S';     		-- Alta de Movimiento de Ahorro: SI
	SET AltaMovAho_NO       		:= 'N';     		-- Alta de Movimiento de Ahorro: NO
	SET AltaMovCre_NO       		:= 'N';     		-- Alta de Movimiento de Credito: NO
    SET AltaMovCre_SI       		:= 'S';     		-- Alta de Movimiento de Credito: NO
    SET Con_ContCapCre      		:= 1;       		-- Concepto Contable de Credito: Capital (CONCEPTOSCARTERA)
    SET Nat_Cargo           		:= 'C';     		-- Naturaleza de Cargo
	SET Nat_Abono           		:= 'A';     		-- Naturaleza de Abono.
    SET Tip_MovAhoDesem     		:= '300';			-- Tipo de Movimiento en Cta de Ahorro: Desembsolso (TIPOSMOVSAHO)
    SET Mov_CapVigente      		:= 1;  				-- Tipo del Movimiento de Credito: Capital Vigente (TIPOSMOVSCRE)
    SET Est_Cancelado				:= 'C';				-- Estatus Cancelado
    SET Deb_RevDesemb       		:= 12;      		-- Tipo de Desbloqueo de Saldo en Cta: Reversa de Desembolso
    SET Tipo_DesbDisper     		:= 1;       		-- Tipo DesBloqueo: Por Dispersion
    SET Des_Desbloqueo      		:= 'DESBLOQUEO POR DISPERSION';
	SET No_Conciliado       		:= 'N';     		-- Movimiento no Conciliado
	SET Es_Automatico				:= 'A';				-- Es Automatico
	SET Cheque						:= 2;
	SET OrdenPago					:= 5;
    SET Tip_MovAhoSPEI      		:= '224';  		 	-- Tipo de Movimiento de Ahorro: Envi­o de SPEI
	SET Tip_MovAhoCHEQ      		:= '15';			-- Tipo de Movimiento de Ahorro: Entrega de Cheque
    SET SI_AltaMovAho       		:= 'S';    		 	-- Alta del Movimiento de Ahorro: SI
    SET Est_Concilado	 			:= 'C';				-- indica valor para estatus conciliado
    SET Var_TipoChequeDesem			:= '12';			-- TIPOSMOVTESO: Cheque por Desembolso de Credito
    SET Var_TipoSpeiDesemb			:= '2';				-- TIPOSMOVTESO: SPEI por Desembolso de Credito
	SET Act_CancelaCre				:= 14;				-- Cancelacion de Credito(CREDITOSACT)
	SET Act_CancelaCheque			:= 3;				-- Cancelacion del Cheque(CHEQUESEMITIDOS)
	SET Con_CancelaCred				:= 67;				-- Concepto Contable Cancelacion de Creditos
    SET Des_ConceptoCont			:= 'CANCELACION DE CREDITO';	-- Descripcion Cancelacion de Creditos
    SET Pol_Automatica  			:= 'A';             -- Tipo de Poliza: Automatica
    SET Anticipado					:= 'A';
    SET Desc_Desembolso				:= 'CANC. DESEMBOLSO CREDITO';
    SET RegistroPantalla			:= 'P';				-- Resgistro realizado en pantalla
	SET Var_MovOtrasComisiones		:= 43;				-- TIPOSMOVSCRE: Otras Comisiones
	SET Var_MovIVAOtrasComis		:= 26;				-- TIPOSMOVSCRE: IVA Otras Comisiones
	SET Var_FormaFinanciada			:= 'F';				-- Forma de Cobro F:FINANCIADA
    SET Var_SI                      := 'S';
    SET Salida_NO                   := 'N';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CANCELACREDITOPRO');
				SET Var_Control := 'sqlexception';
			END;


    SELECT FechaSucursal INTO Var_FechaOper
			FROM SUCURSALES
			WHERE SucursalID = Aud_Sucursal;
	SET Mon_Base		:= (SELECT  MonedaBaseID FROM PARAMETROSSIS);

	SET Var_FechaOper   := IFNULL(Var_FechaOper, Fecha_Vacia);


	# *** VALIDACIONES GENERALES ***
    CALL CANCELACREDITOVAL(
		Par_CreditoID,	Cons_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,
		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	CALL DIASFESTIVOSCAL(
		Var_FechaOper,  Entero_Cero,        Var_FechaApl,       Var_EsHabil,    Aud_EmpresaID,
		Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

    # Consulta General
	SELECT	Cre.TipoDispersion,		Cre.AporteCliente,		Cre.PorcGarLiq,			Cre.CuentaID,				Cre.ProductoCreditoID,
			Cre.ForCobroComAper,	(Cre.MontoComApert+IVAComApertura),				Cli.SucursalOrigen,			Cre.MontoCredito,
            Cre.MonedaID,            Des.Clasificacion,		Des.SubClasifID,		Cre.ClienteID,				Cre.SolicitudCreditoID,
            Cre.FolioDispersion,	Cre.ComAperPagado
            INTO
            Var_TipoDispersion,		Var_GarLiquida,			Var_PorcGarLiq,			Var_CuentaAhoID,			Var_ProductoCredID,
			Var_ForCobComAp,		Var_MontoComAp,			Var_SucCliente,			Var_MontoCred,				Var_MonedaID,
            Var_ClasifCre,			Var_SubClasifID,		Var_ClienteID,			Var_SoliciCredID,			Var_FolioDisper,
			Var_ComAperPagada
    FROM CREDITOS Cre
    INNER JOIN	CLIENTES Cli		ON Cre.ClienteID	= Cli.ClienteID
    INNER JOIN  DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
    WHERE CreditoID = Par_CreditoID;

    	# Monto a cancelar
	IF(Var_ForCobComAp = Programada OR  Var_ForCobComAp = Anticipado) THEN
		SET Var_MontoCancela := (Par_Capital + Var_ComAperPagada) ;
	ELSE
		SET Var_MontoCancela := (Par_Capital) ;
    END IF;

    SET Var_CuentaAhoStr    := CONVERT(Var_CuentaAhoID, CHAR);
    SET Var_ClaveDispMov 	:= (SELECT ClaveDispMov FROM DISPERSIONMOV WHERE DispersionID = Var_FolioDisper AND CreditoID = Par_CreditoID);

    # Datos de la dispersion
	SELECT	Dis.CuentaAhoID,		Est_Concilado,			Dis.InstitucionID,	Teso.NumCtaInstit,	DisMov.Monto,
			DisMov.Referencia,		DisMov.TipoMovDIspID,	DisMov.ProveedorID,	CASE WHEN	DisMov.TipoMovDIspID = Var_TipoChequeDesem
																					THEN  CONCAT(DisMov.Referencia,"/CHEQUE:")
																					ELSE DisMov.Referencia END,
			DisMov.FormaPago,		DisMov.CuentaDestino
	INTO	CtaAhoID,				Var_EstTeso,			Var_InstitucionID,	Var_CuentaBancaria,	Var_MontoMov,
			Var_ReferenciaMov,		Var_TipoMovimiento,		Var_ProveedorID,	var_RefCuentCheq,	Var_FormaPago,
			Var_NumeroCheque
		FROM DISPERSION Dis,
			 DISPERSIONMOV DisMov,
			 CUENTASAHOTESO Teso
		WHERE DisMov.DispersionID   = Var_FolioDisper
		  AND DisMov.ClaveDispMov   = Var_ClaveDispMov
		  AND Dis.FolioOperacion    = DisMov.DispersionID
		  AND Teso.InstitucionID    = Dis.InstitucionID
		  AND Teso.NumCtaInstit     = Dis.NumCtaInstit;

	-- Si el numero de poliza es 0, se da de alta el encabezado de la poliza
	IF (Par_Poliza = Entero_Cero) THEN
		CALL MAESTROPOLIZASALT(
			Par_Poliza,			Aud_EmpresaID,		Var_FechaOper,	Pol_Automatica,		Con_CancelaCred,
			Des_ConceptoCont,	Cons_NO,			Par_NumErr,		Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


    IF(Var_ComAperPagada > Decimal_Cero) THEN

		# REVERSA COMISION POR APERTURA PROGRAMADA
		CALL CANCELACOMAPERPRO(
					Par_CreditoID,		Var_CuentaAhoID,	Var_ClienteID,		Var_MonedaID,		Var_ProductoCredID,
					Var_ComAperPagada,	Var_ForCobComAp,	Par_Poliza,			Cons_NO,			Par_NumErr,
					Par_ErrMen,	   	 	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


    IF(Var_FormaPago = Cheque )THEN
		SET var_RefCuentCheq 	:= CONCAT(var_RefCuentCheq,Var_NumeroCheque);
	END IF;
    SET Var_TipoChequera := (SELECT TipoChequera FROM CHEQUESEMITIDOS
							WHERE NumeroCheque = Var_NumeroCheque
                            AND InstitucionID = Var_InstitucionID
                            AND CuentaInstitucion = Var_CuentaBancaria
                            AND REPLACE(Referencia,'CREDITO ',Cadena_Vacia) = Par_CreditoID);

    IF( Var_TipoDispersion = DispersionSPEI OR Var_TipoDispersion = DispersionCheque OR Var_TipoDispersion = DispersionOrden) THEN

        # Se verifica si existe un bloqueo por desembolso de credito
        SET Var_FolioBlo := (SELECT	Blo.BloqueoID
							FROM  BLOQUEOS Blo
							WHERE Blo.Referencia 	= Par_CreditoID
							AND Blo.TiposBloqID     = Tipo_DesbDisper
							AND Blo.NatMovimiento   = Nat_Bloqueo
							AND Blo.FolioBloq 		= Entero_Cero
							AND Blo.CuentaAhoID 	= Var_CuentaAhoID);

		# Se verifica si existe un desbloqueo por dispersion
		SET Var_FolioDesb := (SELECT	Blo.BloqueoID
							FROM  BLOQUEOS Blo
							WHERE Blo.Referencia 	= Par_CreditoID
							AND Blo.TiposBloqID     = Tipo_DesbDisper
							AND Blo.NatMovimiento   = Nat_Desbloqueo
                            AND Blo.Descripcion 	= Des_Desbloqueo
							AND Blo.FolioBloq 		= Entero_Cero
							AND Blo.CuentaAhoID 	= Var_CuentaAhoID);

        SET Var_FolioBlo	:= IFNULL(Var_FolioBlo, Entero_Cero);
		SET Var_FolioDesb	:= IFNULL(Var_FolioDesb, Entero_Cero);
        # Se valida si existe un bloqueo por desembolso
        IF(Var_FolioBlo = Entero_Cero) THEN
			# Se valida si existe un desbloqueo por dispersion
			IF(Var_FolioDesb != Entero_Cero) THEN
				IF(Var_TipoDispersion != DispersionEfectivo) THEN
					# Se realiza la cancelacion de la comision por disposicion
					CALL CANCELACOMDISPOSPRO(
						Par_CreditoID,			Var_CuentaAhoID,	Var_ClienteID,		Var_InstitucionID,		Par_Poliza,
						Cons_NO,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,
                        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion  );

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

                END IF;

                /* Alta del Movimiento Operativo de la Cuenta Nostro de Tesoreria */
				CALL TESORERIAMOVSALT(
					CtaAhoID,		Var_FechaOper,		Var_MontoMov,		Var_Descripcion,		IFNULL(var_RefCuentCheq,Var_ReferenciaMov),
					Var_EstTeso,	Nat_Abono,			Es_Automatico,		Var_TipoMovimiento,		Entero_Cero,
					Cons_NO,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,		Aud_EmpresaID,
					Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion  );

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				IF(Var_FormaPago = Cheque )THEN
					SET Var_Refere := Var_NumeroCheque;
				ELSE
					IF(Var_FormaPago = OrdenPago)THEN
						SET Var_Refere := Var_ReferenciaMov;
					ELSE
						SET Var_Refere := CONCAT(Var_ReferenciaMov,'-',Var_NumeroCheque);
					END IF;
				END IF;

                -- Seleccionamos el Tipo de Movimiento en la Cta de Ahorro
				IF (Var_TipoMovimiento =  Var_TipoSpeiDesemb) THEN
					SET Tip_MovAho  := Tip_MovAhoSPEI;
				ELSE
					SET Tip_MovAho  := Tip_MovAhoCHEQ;
				END IF;

				IF (Var_TipoMovimiento =  Var_TipoSpeiDesemb) THEN
					SET Des_Contable := 'CANC. SPEI POR DESEMBOLSO DE CREDITO';
				ELSE
					IF (Var_TipoMovimiento =  Var_TipoChequeDesem) THEN
						SET Des_Contable := 'CANC. CHEQUE POR DESEMBOLSO DE CREDITO';
					ELSE

						SET Des_Contable := 'CANC. ORDEN PAGO POR DESEMBOLSO DE CREDITO';
                    END IF;

				END IF;

                SET Var_AltaMovAho := SI_AltaMovAho;

				# Se realizan los movimientos contables de Tesoreria
				CALL CONTATESOREPRO(
					Aud_Sucursal,       Mon_Base,           Var_InstitucionID,  Var_CuentaBancaria,		Entero_Cero,
					Var_ProveedorID,    Entero_Cero,        Var_FechaOper,		Var_FechaOper,       	Var_MontoMov,
					Des_Contable,    	Var_Refere,			Var_CuentaBancaria, AltaPoliza_NO,     		Par_Poliza,
					Entero_Cero,		Entero_Cero,        Nat_Cargo,          Var_AltaMovAho,     	Var_CuentaAhoID,
					Var_ClienteID,      Tip_MovAho,         Nat_Abono,			Cons_NO,          		Par_NumErr,
					Par_ErrMen,			Par_Consecutivo,    Aud_EmpresaID,      Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


                /* Actualizacion del Saldo de la Cuenta de Bancos */
				CALL SALDOSCTATESOACT(
					Var_CuentaBancaria,	Var_InstitucionID,	Var_MontoMov,       Nat_Abono,      Cons_NO,
					Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Aud_EmpresaID,  Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

                -- El estatus del cheque se actualiza a cancelado
                IF(Var_FormaPago = Cheque )THEN
					CALL CHEQUESEMITIDOSACT(
						Var_InstitucionID,	Var_CuentaBancaria,	Var_NumeroCheque,	Var_TipoChequera,	Act_CancelaCheque,
						Cons_NO,			Par_NumErr,         Par_ErrMen, 		Aud_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   	Aud_NumTransaccion);
                END IF;

                -- El estatus de la orden de pago se actualiza a Conciliado
                IF(Var_FormaPago = OrdenPago)THEN
					  UPDATE ORDENPAGODESCRED SET
						Estatus				= Est_Concilado,
                        EmpresaID   		= Aud_EmpresaID,
						Usuario     		= Aud_Usuario,
						FechaActual     	= Aud_FechaActual,
						DireccionIP     	= Aud_DireccionIP,
						ProgramaID      	= Aud_ProgramaID,
						Sucursal        	= Aud_Sucursal,
						NumTransaccion  	= Aud_NumTransaccion
					WHERE REPLACE(Referencia,'CREDITO ',Cadena_Vacia) = Par_CreditoID
						AND InstitucionID = Var_InstitucionID
						AND NumCtaInstit = Var_CuentaBancaria;
                END IF;

                -- El estatus de los movimientos de tesorería se actualizan a Conciliado
				UPDATE TESORERIAMOVS SET
					Status		 		= Est_Concilado,
                    EmpresaID 			= Aud_EmpresaID,
					Usuario 			= Aud_Usuario,
					FechaActual 		= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID 			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion  	= Aud_NumTransaccion
				WHERE ReferenciaMov LIKE CONCAT('%', Par_CreditoID, '%')
				AND NatMovimiento = Nat_Cargo
				AND Status = No_Conciliado;

				IF(Var_FormaPago = OrdenPago)THEN
					UPDATE TESORERIAMOVS SET
						Status		 		= Est_Concilado,
						EmpresaID 			= Aud_EmpresaID,
						Usuario 			= Aud_Usuario,
						FechaActual 		= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID 			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion  	= Aud_NumTransaccion
					WHERE NatMovimiento = Nat_Cargo
					AND Status = No_Conciliado
                    AND CuentaAhoID = CtaAhoID
                    AND MontoMov = Var_MontoMov
                    AND TipoRegristro = RegistroPantalla;

                END IF;

            ELSE

				# Si no existe un desbloqueo por dispersion se valida que exista saldo disponible en la cuenta del Cliente
				SET Var_SaldoDipon := (SELECT SaldoDispon
											FROM CUENTASAHO
											WHERE CuentaAhoID= Var_CuentaAhoID);

				SET Var_SaldoDipon := IFNULL(Var_SaldoDipon, Decimal_Cero);

				# Se valida que el monto a cancelar, este disponible en la cuenta del cliente.
				IF(Var_SaldoDipon < Var_MontoCancela) THEN
					SET Par_NumErr	:= 1;
					SET Par_ErrMen	:= 'Saldo Insuficiente en la Cuenta del Cliente';
					LEAVE ManejoErrores;

				END IF;-- IF(Var_SaldoDipon <= Var_MontoCancela) THEN


			END IF; -- IF(Var_FolioDesb != Entero_Cero) THEN

		ELSE

		-- Si existe un bloqueo y no se autorizo la dispersion, se obtiene el numero de bloqueo para proceder con el desbloqueo
			SELECT BloqueoID INTO Var_BloqueoID
			FROM BLOQUEOS
			WHERE CuentaAhoID	 = Var_CuentaAhoID
			  AND NatMovimiento = Nat_Bloqueo
			  AND TiposBloqID = Blo_Desemb
			  AND Referencia = Par_CreditoID
			  AND FolioBloq = Entero_Cero
			  AND ( Descripcion = DescripBloqSPEI
			  OR    Descripcion = DescripBloqCheq
			  OR	Descripcion = DescripBloqOrden);

			SET Var_BloqueoID   := IFNULL(Var_BloqueoID, Entero_Cero);

			-- Se realiza el desbloqueo por cancelacion de credito
			CALL BLOQUEOSPRO(
				Var_BloqueoID,  	Nat_Desbloqueo, 	Var_CuentaAhoID,    	Var_FechaOper,      Entero_Cero,
				Var_FechaOper,  	Deb_RevDesemb,  	Var_Descripcion,    	Par_CreditoID,     	Cadena_Vacia,
				Cadena_Vacia,   	Cons_NO,      		Par_NumErr, 			Par_ErrMen,  		Aud_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,   		Aud_ProgramaID, 	Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			# Si no existe un desbloqueo por dispersion se valida que exista saldo disponible en la cuenta del Cliente
			SET Var_SaldoDipon := (SELECT SaldoDispon
										FROM CUENTASAHO
										WHERE CuentaAhoID= Var_CuentaAhoID);

			SET Var_SaldoDipon := IFNULL(Var_SaldoDipon, Decimal_Cero);

			# Se valida que el monto a cancelar, este disponible en la cuenta del cliente.
			IF(Var_SaldoDipon < Var_MontoCancela) THEN
				SET Par_NumErr	:= 1;
				SET Par_ErrMen	:= CONCAT('Saldo Insuficiente en la Cuenta del Cliente: ', Var_SaldoDipon, ' Monto a cancelar: ', Var_MontoCancela);
				LEAVE ManejoErrores;

			END IF;-- IF(Var_SaldoDipon <= Var_MontoCancela) THEN


        END IF;-- IF(Var_FolioBlo != Entero_Cero) THEN

    ELSE
		# Se obtiene el saldo disponible de la cuenta del Cliente
		SET Var_SaldoDipon := (SELECT SaldoDispon
									FROM CUENTASAHO
									WHERE CuentaAhoID= Var_CuentaAhoID);

		SET Var_SaldoDipon := IFNULL(Var_SaldoDipon, Decimal_Cero);

        # Se valida que el monto a cancelar, este disponible en la cuenta del cliente.
        IF(Var_SaldoDipon < Var_MontoCancela) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'Saldo Insuficiente en la Cuenta del Cliente';
			LEAVE ManejoErrores;

        END IF;

    END IF;	-- END IF(Var_TipoDispersion = Spei OR Var_TipoDispersion = Orden_Pago)
	# Se valida si el producto de credito cobra un porcentaje de garantia liquida
	IF(Var_PorcGarLiq > Decimal_Cero) THEN

		# Se valida si el credito tiene un pago de garantia liquida
		IF(Var_GarLiquida > Decimal_Cero) THEN

			# Se realiza la llamada al SP que realiza la cancelacion de la garantia liquida del credito
			CALL CANCELAGARANTIALIQPRO(
				Par_CreditoID,		Var_ClienteID,		Par_Poliza,			Cons_NO,			Par_NumErr,
				Par_ErrMen,	   	 	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			# Se revisa si hay inversiones comprometidas con creditos
			SET Var_InverEnGar	:= (SELECT COUNT(CreditoID)
									FROM CREDITOINVGAR
									WHERE CreditoID = Par_CreditoID);

			SET Var_InverEnGar	:= IFNULL(Var_InverEnGar, Entero_Cero);
			# Si la inversion esta respaldando a un credito, se libera
			IF(Var_InverEnGar >Entero_Cero)THEN
				CALL CREDITOINVGARACT(
						Entero_Cero,		Par_CreditoID,		Entero_Cero,	Par_Poliza,			Act_LiberarPagCre,
						Cons_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
					);
				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;  -- END IF(Var_GarLiquida > Decimal_Cero)
	END IF;	-- END IF(Var_PorcGarLiq > Decimal_Cero)

	# REVERSA DE INTERESES DEVENGADOS
	CALL CANCELAINTERECREPRO(
				Par_CreditoID,		Par_Poliza,			Var_FechaOper,		Cons_NO,			Par_NumErr,
				Par_ErrMen,	   	 	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;


	# CURSOR para la cancelacion del capital por cada amortizacion
	OPEN CURSORAMORTI;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH CURSORAMORTI INTO
				Var_CreditoID, 	Var_AmortizID,	Aud_NumTransaccion,	Var_Cantidad;

				SET Var_TipoMovCred   := Mov_CapVigente;

				CALL  CREDITOSMOVSALT (
					Var_CreditoID,      Var_AmortizID,      Aud_NumTransaccion, Var_FechaOper,		Var_FechaApl,
					Var_TipoMovCred,    Nat_Abono,          Var_MonedaID,		Var_Cantidad,       Var_Descripcion,
					Var_CuentaAhoStr,   Par_Poliza,			Cadena_Vacia,		Par_NumErr,         Par_ErrMen,
					Par_Consecutivo,	Cadena_Vacia,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				-- CANCELACION DE ACCESORIOS

                -- Obtner los accesorios:
                    DELETE FROM TMPACCESORIOSAMORTI 
                    WHERE NumeroTransaccion = Aud_NumTransaccion;
                    SET @consecutivo := 0;

                    INSERT INTO TMPACCESORIOSAMORTI 
                            (   Consecutivo,    AccesorioID,     CreditoID,  NumeroTransaccion)
                    SELECT      (@consecutivo := @consecutivo + 1), Det.AccesorioID, CreditoID, Aud_NumTransaccion
                    FROM        DETALLEACCESORIOS Det
                    INNER JOIN  ACCESORIOSCRED Ac ON Det.AccesorioID = Ac.AccesorioID
                    WHERE Det.CreditoID     = Var_CreditoID
                    AND Det.AmortizacionID  = Var_AmortizID;

                    SELECT COUNT(Consecutivo)
                    INTO Var_numAccesorios
                    FROM TMPACCESORIOSAMORTI
                    WHERE CreditoID = Var_CreditoID
                        AND NumeroTransaccion = Aud_NumTransaccion;
                    SET Var_numAccesorios := IFNULL(Var_numAccesorios, Entero_Cero);

                    SET @consecutivo = 1;

                -- Inicia While sobre Var_AccesoriosRo
                    WHILE @consecutivo <= Var_numAccesorios DO
    					
                        -- Extraer el id del accesorio
                        SELECT AccesorioID
                        INTO Var_AccesorioID
                        FROM TMPACCESORIOSAMORTI TMP
                        WHERE TMP.NumeroTransaccion = Aud_NumTransaccion
                        AND   TMP.Consecutivo       = @consecutivo; 

                        SET Var_AccesorioID := IFNULL(Var_AccesorioID, Entero_Cero);

                        SELECT  Det.MontoPagado,		Ac.NombreCorto,		Det.CobraIVA, 	Det.SaldoVigente, Det.SaldoIVAAccesorio,
    							Det.TipoFormaCobro,		Det.AccesorioID
    					INTO 	Var_MontoPagadoAcc,		Var_AbrevAccesorio,	Var_CobraIVAAc,	Var_MontoAccesorio,	Var_MontoIVAAccesorio,
    							Var_TipoFormaCobroAcc,	Var_AccesorioID
    					FROM DETALLEACCESORIOS Det
    				    INNER JOIN ACCESORIOSCRED Ac
    				    ON Det.AccesorioID = Ac.AccesorioID
    					WHERE Det.CreditoID 		= Var_CreditoID
    					   AND Det.AmortizacionID	= Var_AmortizID
    					   AND Ac.AccesorioID 		= Var_AccesorioID;


    					IF Var_TipoFormaCobroAcc = Var_FormaFinanciada THEN

    				    	SET Var_ConcepCarteraAcc := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA WHERE Descripcion = Var_AbrevAccesorio);

    						IF(Var_CobraIVAAc = Var_SI) THEN
    							SET Var_ConceptoIVACarAcc := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA WHERE Descripcion = CONCAT('IVA ', Var_AbrevAccesorio) );
    						END IF;

    						-- SE ASIGNA VALOR PARA LA REFERENCIA DEL MOVIMIENTO
    						SET Var_RefGenAcc 			:= CONCAT('CANCELACION DE ACCESORIO ', Var_AbrevAccesorio);
    						SET Var_RefGenIVAAcc		:= CONCAT('CANCELACION IVA DE ACCESORIO', Var_AbrevAccesorio);

    						SET Var_DescAccesorio		:= CONCAT('CANCELACION ACCESORIO ', Var_AbrevAccesorio);
    						SET Var_DescIVAAcc			:= CONCAT('CANCELACION IVA ACCESORIO ', Var_AbrevAccesorio);

    						-- INGRESO POR CONCEPTO DE OTRA COMISIONES(ACCESORIOS)
    						IF (Var_MontoAccesorio > Decimal_Cero) THEN
    							-- SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS PARA CANCELAR ACCESORIOS
    							CALL CONTACCESORIOSCREDPRO (
    								Var_CreditoID,			Var_AmortizID,				Var_AccesorioID,		Entero_Cero,			Entero_Cero,
    								Var_FechaOper,			Var_FechaApl,				Var_MontoAccesorio,		Var_MonedaID,			Var_ProductoCredID,
    								Var_ClasifCre,			Var_SubClasifID, 			Var_SucCliente,			Var_DescAccesorio, 		Var_RefGenAcc,
    								AltaPoliza_NO,			Entero_Cero,				Par_Poliza, 			AltaPolCre_NO,			AltaMovCre_SI,
    								Var_ConcepCarteraAcc,	Var_MovOtrasComisiones,		Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,
    								Nat_Abono, 				Cadena_Vacia,				Salida_NO,				Par_NumErr,				Par_ErrMen,
    								Par_Consecutivo,		Aud_EmpresaID,				Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,
    								Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

    							IF (Par_NumErr <> Entero_Cero)THEN
    								LEAVE ManejoErrores;
    							END IF;
    						END IF;



    						IF(Var_MontoIVAAccesorio != Decimal_Cero) THEN
    							-- SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS CANCELAR IVA ACCESORIOS
    							CALL CONTACCESORIOSCREDPRO (
    								Var_CreditoID,			Var_AmortizID,				Var_AccesorioID,		Entero_Cero,			Entero_Cero,
    								Var_FechaOper,			Var_FechaApl,				Var_MontoIVAAccesorio,	Var_MonedaID,			Var_ProductoCredID,
    								Var_ClasifCre,			Var_SubClasifID, 			Var_SucCliente,			Var_DescIVAAcc,			Var_RefGenIVAAcc,
    								AltaPoliza_NO,			Entero_Cero,				Par_Poliza, 			AltaPolCre_NO,			AltaMovCre_SI,
    								Var_ConceptoIVACarAcc,	Var_MovIVAOtrasComis, 		Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,
    								Nat_Abono, 				Cadena_Vacia,				Salida_NO,				Par_NumErr,				Par_ErrMen,
    								Par_Consecutivo,		Aud_EmpresaID,				Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,
    								Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

    							IF (Par_NumErr <> Entero_Cero)THEN
    								LEAVE ManejoErrores;
    							END IF;

    						END IF;

    				    END IF;

                        SET @consecutivo := @consecutivo + 1;

                    END WHILE; -- Termina While Accesorios

                    DELETE FROM TMPACCESORIOSAMORTI 
                    WHERE NumeroTransaccion = Aud_NumTransaccion;
			END LOOP;
		END;
	CLOSE CURSORAMORTI;


 -- Movimientos contables por concepto del capital
	CALL  CONTACREDITOSPRO (
		Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,			Var_FechaOper,
		Var_FechaApl,       Var_MontoCred,      Var_MonedaID,		Var_ProductoCredID,     Var_ClasifCre,
		Var_SubClasifID,    Var_SucCliente,		Desc_Desembolso,    Var_CuentaAhoStr,   	AltaPoliza_NO,
		Con_ContDesem,		Par_Poliza,      	AltaPolCre_SI,      AltaMovCre_NO,      	Con_ContCapCre,
		Entero_Cero,		Nat_Abono,          AltaMovAho_SI,      Tip_MovAhoDesem,		Nat_Cargo,
		Cadena_Vacia,		Cons_NO,         	Par_NumErr,			Par_ErrMen,         	Par_Consecutivo,
		Aud_EmpresaID,		Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion  );

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;


	-- SE ACTUAALIZA EL ESTATUS DE LA TABLA SOLICITUDCREDITO, CREDITOS Y AMORTICREDITO
   CALL CREDITOSACT(
		Par_CreditoID,		Entero_Cero,		Fecha_Vacia,		Entero_Cero,		Act_CancelaCre,
		Fecha_Vacia,		Fecha_Vacia,		Decimal_Cero,	 	Decimal_Cero,		Entero_Cero,
		Cadena_Vacia,		Cadena_Vacia,    	Entero_Cero,		Cons_NO,			Par_NumErr,
		Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal, 		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;


	# Se realiza el insert a la tabla BITACORACREDCANCEL
	CALL BITACORACREDCANCELALT(
		Par_CreditoID,		Var_ClienteID,		Var_CuentaAhoID,	Var_FechaOper, 		Par_MotivoCancela,
        Var_MontoCancela,	Par_Capital,		Par_Interes,		Var_GarLiquida,		Var_ComAperPagada,
        Aud_Usuario,		Par_UsuarioAut,		Par_Poliza,			Cons_NO,			Par_NumErr,
        Par_ErrMen,        	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,		Aud_Sucursal, 		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;


		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Credito Cancelado Exitosamente.';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'creditoID' AS control,
				Par_CreditoID AS consecutivo;
	END IF;


END TerminaStore$$