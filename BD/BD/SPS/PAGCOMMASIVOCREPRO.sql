-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCOMMASIVOCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCOMMASIVOCREPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCOMMASIVOCREPRO`(
-- -----------------------------------------------------------------------------------------------------------------------
# ========== REALIZA EL PAGO DEL TOTAL DE COMISIONES DE TODOS LOS CREDITOS ( Comision por Falta de Pago, Comision por Seguro,
#								 y Comision por Apertura de Credito)============
-- -----------------------------------------------------------------------------------------------------------------------
	Par_TipoCobro		CHAR(1),			# Tipo Cobro I:Individual   M:Masivo
    Par_TipoComision	CHAR(2),			# Tipo de Pago de Comision
    Par_CreditoID       BIGINT(12),			# ID de credito al que se le efectuara el pago
	Par_ModoPago		CHAR(1),			# Forma de pago Efectivo o con cargo a cuenta
	Par_CuentaAhoID     BIGINT(12),			# ID de la cuenta de ahorro sobre la cual se haran los movimientos
	Par_Poliza			BIGINT,				# Numero de poliza
	Par_ComFaltPag		DECIMAL(12,2),		# Monto Comision Falta de Pago
    Par_ComSeguroCuota	DECIMAL(12,2),		# Monto Comision Seguro por Cuota
    Par_ComApCred		DECIMAL(12,2),		# Monto Comision Apertura de Credito
    Par_ComAnual		DECIMAL(12,2),		# Monto Comision Apertura de Credito
    Par_ComAnualLin		DECIMAL(12,2),		# Monto Comisión Anualidad Linea de Crédito
    Par_Salida          CHAR(1),

    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
    INOUT Par_Consecutivo	BIGINT,


    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
		)
TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE varControl 		    		VARCHAR(100);	# almacena el elemento que es incorrecto
	DECLARE Var_TipoComision			CHAR(2);		# Tipo de Comision
    DECLARE Var_CueClienteID			BIGINT(12);		# Cuenta del cliente
	DECLARE Var_CueSaldo				DECIMAL(12,2);	# Saldo actual disponible en la cuenta
	DECLARE Var_CueMoneda				INT(11);		# Tipo de moneda de la cuenta
	DECLARE Var_CueEstatus				CHAR(1);		# Estatus de la cuenta
    DECLARE Var_IVA						DECIMAL(12,2);	# porcentaje de iva general
    DECLARE Var_SucursalID      		INT(11);		# ID de la sucursal del cliente
	DECLARE Var_ClienteID				INT(11);		# ID del cliente
    DECLARE Var_PagaIVA					CHAR(1); 		# Indica si el cliente paga iva
    DECLARE Var_CobraSeguroCuota		CHAR(1);
	DECLARE Var_CobraIVASeguroCuota		CHAR(1);
    DECLARE Var_CobraComAnualLin 		CHAR(1);		-- Indica si cobra comisión anual de linea de crédito
    DECLARE Var_ComisionCobradaLin 		CHAR(1);		-- Indica si la comisión anual de la linea ya fue cobrada
    DECLARE OrigenPago_Otros	 		CHAR(1);

	# Declaracion de constantes
	DECLARE Cadena_Vacia    			CHAR(1);		# Cadena vacia
	DECLARE Entero_Cero     			INT(11);		# Entero cero
	DECLARE Decimal_Cero				DECIMAL(4,2);	# DECIMAL cero
	DECLARE SalidaNO        			CHAR(1);		# El store NO arroja una salida
	DECLARE SalidaSI        			CHAR(1);		# El store SI arroja una salida
    DECLARE Monto_MinimoPago    		DECIMAL(12,2);	# Monto minimo permitido para efectar un pago
	DECLARE ComAperCredito				CHAR(2);		# Cobra Comision por Apertura de Credito
    DECLARE ComFaltaPago				CHAR(2);		# Cobra Comision por Falta de Pago
    DECLARE ComSeguroCuota				CHAR(2);		# Cobra Comision de Seguro por Cuota
    DECLARE ComAnual					CHAR(2);		# Cobra Comision Anual
    DECLARE SiPagaIVA       			CHAR(1);        # Si paga IVA
    DECLARE SiCobSeguroCuota			CHAR(1);		# Cobra Seguro por Cuota
    DECLARE SiCobIVASeguroCuota			CHAR(1);		# Cobra IVA del Seguro por Cuota

	# Asignacion  de constantes
	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero		:= 0.0;
	SET SalidaNO       		:= 'N';
	SET SalidaSI        	:= 'S';
    SET Monto_MinimoPago	:= 0.01;
    SET ComAperCredito		:= 'CA';
    SET ComFaltaPago		:= 'FP';
    SET ComSeguroCuota		:= 'PS';
    SET ComAnual			:= 'AN';
    SET SiPagaIVA			:= 'S';
    SET SiCobSeguroCuota	:= 'S';
	SET SiCobIVASeguroCuota := 'S';
	SET OrigenPago_Otros	:= 'O';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
			   SET Par_NumErr  = 999;
			   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCOMMASIVOCREPRO');
			   SET varControl  = 'SQLEXCEPTION';
			END;

	SELECT  Cli.ClienteID,				Cli.SucursalOrigen,		Cli.PagaIVA, Cre.CobraSeguroCuota,
            Cre.CobraIVASeguroCuota
	INTO 	Var_ClienteID,				Var_SucursalID,			Var_PagaIVA, Var_CobraSeguroCuota,
            Var_CobraIVASeguroCuota
	FROM CLIENTES Cli
		INNER JOIN CREDITOS Cre ON (Cli.ClienteID = Cre.ClienteID)
		INNER JOIN PRODUCTOSCREDITO Pro ON (Cre.ProductoCreditoID = Pro.ProducCreditoID)
		INNER JOIN DESTINOSCREDITO Des ON (Cre.DestinoCreID = Des.DestinoCreID)
		LEFT  JOIN REESTRUCCREDITO Res ON (Res.CreditoDestinoID = Cre.CreditoID)
	WHERE Cre.CreditoID = Par_CreditoID;

	IF (Var_PagaIVA = SiPagaIVA) THEN
		SET Var_IVA  := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_SucursalID);
	END IF;

	SET Var_IVA	:= IFNULL(Var_IVA,  Decimal_Cero);



	# Se consulta el Saldo Total de la Cuenta
	CALL SALDOSAHORROCON(Var_CueClienteID, 	Var_CueSaldo,	 Var_CueMoneda, 	Var_CueEstatus,	 Par_CuentaAhoID);
	 # ===================================  SE REALIZA EL PAGO DE LA COMISION POR APERTURA DE CREDITO  ======================================
    IF(Par_TipoComision = ComAperCredito) THEN
		IF(Par_ComApCred > Monto_MinimoPago) THEN
			SET Par_ComApCred := ROUND(Par_ComApCred * (Var_IVA+1),2);
			SET Var_TipoComision := ComAperCredito;

            IF(IFNULL(Var_CueSaldo, Decimal_Cero) < Par_ComApCred) THEN
				SET Par_NumErr		:= '001';
				SET Par_ErrMen		:= 'Saldo Insuficiente en la Cuenta del Socio.';
				SET varControl		:= 'cuentaAhoID';
				LEAVE ManejoErrores;
			END IF;

			# Se realizan los pagos individuales de los Creditos
			CALL PAGOCOMISIONCREPRO(
				Par_TipoCobro,		Var_TipoComision,	Entero_Cero,			Par_CreditoID,		Par_ComApCred,
				Par_ModoPago,		Par_CuentaAhoID,	Par_Poliza,				OrigenPago_Otros,	Par_Salida,
				Par_NumErr,   		Par_ErrMen,   		Par_Consecutivo,		Par_EmpresaID,	    Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,    	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;
	# ===================================  SE REALIZA EL PAGO DE SALDO DE COMISION POR FALTA DE PAGO  ======================================
	IF(Par_TipoComision = ComFaltaPago) THEN
		IF(IFNULL(Var_CueSaldo, Decimal_Cero) < Par_ComFaltPag) THEN
			SET Par_NumErr		:= '001';
			SET Par_ErrMen		:= 'Saldo Insuficiente en la Cuenta del Socio.';
			SET varControl		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
        END IF;

		IF(Par_ComFaltPag > Monto_MinimoPago) THEN
			SET Var_TipoComision := ComFaltaPago;
            SET Par_ComFaltPag := ROUND(Par_ComFaltPag * (Var_IVA+1),4);

			# Se realizan los pagos individuales de los Creditos
			CALL PAGOCOMISIONCREPRO(
				Par_TipoCobro,		Var_TipoComision,	Entero_Cero,		Par_CreditoID,		Par_ComFaltPag,
				Par_ModoPago,		Par_CuentaAhoID,	Par_Poliza,			OrigenPago_Otros,	Par_Salida,
				Par_NumErr,   		Par_ErrMen,   		Par_Consecutivo,	Par_EmpresaID,	    Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,    	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
    END IF;

	# ===================================  SE REALIZA EL PAGO DE SEGURO POR CUOTA  ======================================
	IF(Par_TipoComision = ComSeguroCuota) THEN

		IF(Par_ComSeguroCuota > Monto_MinimoPago) THEN

			-- Se verifica el cobro del IVA de Seguro por Cuota
			IF(Var_CobraIVASeguroCuota = SiCobIVASeguroCuota) THEN
				SET Par_ComSeguroCuota := ROUND(Par_ComSeguroCuota * (Var_IVA+1),2);
			ELSE
				SET Par_ComSeguroCuota 		:= Par_ComSeguroCuota;
			END IF;
			SET Var_TipoComision := ComSeguroCuota;
			# Se realizan los pagos individuales de los Creditos
			CALL PAGOCOMISIONCREPRO(
				Par_TipoCobro,		Var_TipoComision,	Entero_Cero,		Par_CreditoID,		Par_ComSeguroCuota,
				Par_ModoPago,		Par_CuentaAhoID,	Par_Poliza,			OrigenPago_Otros,	Par_Salida,
				Par_NumErr,   		Par_ErrMen,   		Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,    	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;
    END IF;

    	# ===================================  SE REALIZA EL PAGO COMISION ANUAL  ======================================
	IF(Par_TipoComision = ComAnual) THEN

		IF(Par_ComSeguroCuota > Monto_MinimoPago) THEN
			-- Se verifica el cobro del IVA de Seguro por Cuota
			SET Par_ComAnual := ROUND(Par_ComAnual * (Var_IVA+1),2);
			SET Var_TipoComision := ComAnual;
			# Se realizan los pagos individuales de los Creditos
			CALL PAGOCOMISIONCREPRO(
				Par_TipoCobro,		Var_TipoComision,	Entero_Cero,		Par_CreditoID,		Par_ComAnual,
				Par_ModoPago,		Par_CuentaAhoID,	Par_Poliza,			OrigenPago_Otros,	Par_Salida,
				Par_NumErr,   		Par_ErrMen,   		Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,    	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;
    END IF;

     -- ===================== Inicio Comisión Anual Linea de Crédito ============================
    SELECT 	CobraComAnual, 		ComisionCobrada
		INTO Var_CobraComAnualLin,	Var_ComisionCobradaLin
	FROM LINEASCREDITO
	WHERE LineaCreditoID = Var_LineaCreditoID;

	IF( IFNULL(Var_LineaCreditoID,Entero_Cero)<>Entero_Cero AND
		IFNULL(Var_CobraComAnualLin,Cadena_Vacia)=Cons_Si AND
        IFNULL(Var_ComAnualCobradaLin,Cadena_Vacia)=Cons_No) THEN

        CALL COBROCOMANUALLINEAPRO(
			Par_CreditoID,		Var_ClienteID,		Par_MontoPagar,			Par_CuentaAhoID,		Par_Poliza,
            Var_MonedaID,		Par_Salida,         Par_NumErr,    			Par_ErrMen,				Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
            Aud_NumTransaccion);
    END IF;
    -- ===================== Fin Comisión Anual Linea de Crédito ============================

        SET Par_NumErr := 0;
		SET Par_ErrMen := 'Pago Realizado Exitosamente.';
		SET varControl := '';

	END ManejoErrores;  # END del Handler de Errores

	IF(Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				varControl	 	AS control,
				Par_CreditoID 	AS consecutivo;
	END IF;

END TerminaStore$$