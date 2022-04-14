-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREVERTICALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREVERTICALPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGOCREVERTICALPRO`(
-- -----------------------------------------------------------------------------------
# ========== REALIZA EL PAGO DE UN CREDITO DE MANERA VERTICAL ====================
-- -----------------------------------------------------------------------------------
    Par_CreditoID       BIGINT,			# ID de credito al que se le efectuara el pago
    Par_MontoPagar	    DECIMAL(12,2),	# Monto del pago que esta realizando
	Par_ModoPago		CHAR(1),		# Forma de pago Efectivo o con cargo a cuenta
	Par_CuentaAhoID     BIGINT(12),		# ID de la cuenta de ahorro sobre la cual se haran los movimientos
	Par_Poliza			BIGINT,			# Numero de poliza
	Par_OrigenPago		CHAR(1),		# Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
    Par_Salida          CHAR(1),

    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)

TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE VarControl			CHAR(20);		# Almacena el elemento que es incorrecto
    DECLARE	Var_MontoSaldo		DECIMAL(12,2);	# Almacena el monto de saldo disponible
	DECLARE Var_SucCliente  	INT;			# Almacena la sucursal del socio
    DECLARE Var_MonedaID    	INT(11);		# Almacena el tipo de moneda
    DECLARE Var_CreEstatus  	CHAR(1);		# Almacena el estatus del credito

    DECLARE Var_CueClienteID	INT;			# Almacena la cuenta del cliente
	DECLARE	Var_CueSaldo		DECIMAL(14,2);	# Almacena el saldo de la cuenta
	DECLARE	Var_CueMoneda		INT;			# Almacena la moneda de la cuenta
	DECLARE	Var_CueEstatus		CHAR(1);		# ALmacena el estatus de la cuenta
	DECLARE Var_ClienteID		INT;			# Alamcena el ID del socio

    DECLARE Var_MontoPago		DECIMAL(14,2);	# Almacena el monto a pagar
	DECLARE Var_Consecutivo		BIGINT;			# Consecutivo
	DECLARE Var_FechaSistema	DATE;			# Fecha del sistema
	DECLARE Var_CreditoStr		VARCHAR(20);	# Guarda el ID del credito en varchar
	DECLARE Var_TotalAdeudo     DECIMAL(18,4);  # Almacena el total del Adeudo del credito
	DECLARE Var_FechaActPago	DATETIME;		# Fecha del pago más reciente.
	DECLARE Var_DifDiasPago		INT;			# Diferencia entre fechas de pago en días.

	# Declaracion de constantes
	DECLARE Cadena_Vacia    	CHAR(1);		# Cadena vacia
	DECLARE Fecha_Vacia			DATE;			# Fecha vacia
	DECLARE Entero_Cero     	INT;			# Entero cero
	DECLARE Decimal_Cero		DECIMAL(4,2);	# Decimal cero
	DECLARE SalidaNO        	CHAR(1);		# El store NO arroja una salida
	DECLARE SalidaSI        	CHAR(1);		# El store SI arroja una salida

	DECLARE Estatus_Vigente    	CHAR(1);		# Estatus vigente
	DECLARE Estatus_Vencido    	CHAR(1);		# Estatus vencido
	DECLARE Des_PagoCredito		VARCHAR(50);	# Descripcion del pago de credito
	DECLARE EsGrupal_NO			CHAR(1);		# Es un credito grupal
    DECLARE Aho_PagoCred    	CHAR(4);		# Concepto de Ahorro: Pago de Credito

    DECLARE AltaPoliza_NO   	CHAR(1);		# Indica que no de alta una nueva poliza contable
	DECLARE AltaMovAho_SI   	CHAR(1);		# Alta de los Movimientos de Ahorro: SI.
	DECLARE Con_AhoCapital  	INT;			# Concepto Contable de Ahorro: Pasivo
    DECLARE Nat_Cargo       	CHAR(1);		# Naturaleza de Cargo

    DECLARE Var_Observaciones	VARCHAR(200);	# Observaciones del castigo
	DECLARE CastPagVertical		CHAR(1);		# Tipo de Castigo: Pago de credito vertical
    DECLARE Var_MotivoCastigoID INT;			# Motivo de Castigo por pago de credito vertical
	DECLARE CobranzaNinuna		INT;			# Tipo de Cobranza sobre el Credito : Ninguna
	DECLARE Var_NumRecPago		int;

	# Asignacion  de constantes
	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero		:= 0.0;
	SET SalidaNO       		:= 'N';
	SET SalidaSI        	:= 'S';
	SET Estatus_Vigente 	:= 'V';
	SET Estatus_Vencido 	:= 'B';
	SET Des_PagoCredito     := 'PAGO DE CREDITO';
	SET EsGrupal_NO			:= 'N';
	SET Aho_PagoCred    	:= '101';
	SET AltaPoliza_NO   	:= 'N';
	SET AltaMovAho_SI   	:= 'S';
	SET Con_AhoCapital  	:= 1;
	SET Aud_ProgramaID  	:= 'PAGOCREVERTICALPRO';
	SET Nat_Cargo       	:= 'C';
	Set CastPagVertical		:= 'V';
	SET Var_MotivoCastigoID := 4;
	SET Var_Observaciones	:= 'CANCELACION ADMINISTRATIVA';
	SET Var_MontoPago		:= Par_MontoPagar;
    SET CobranzaNinuna		:= 1;
	SET Var_NumRecPago		:= 0;

	SET Var_CreditoStr      := CONVERT(Par_CreditoID, CHAR(15));

	SELECT  Cli.SucursalOrigen,     Cre.MonedaID,   	Cre.Estatus,		Cli.ClienteID
			INTO
			Var_SucCliente,         Var_MonedaID,   	Var_CreEstatus,		Var_ClienteID
	FROM PRODUCTOSCREDITO Pro,
		  CLIENTES Cli,
			DESTINOSCREDITO Des,
			CREDITOS Cre
		WHERE Cre.CreditoID			= Par_CreditoID
		  AND Cre.ProductoCreditoID	= Pro.ProducCreditoID
		  AND Cre.ClienteID			= Cli.ClienteID
		  AND Cre.DestinoCreID      = Des.DestinoCreID;


	SELECT FechaSistema	INTO  Var_FechaSistema FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;
	SET Var_TotalAdeudo   := (SELECT FUNCIONTOTDEUDACRE(Par_CreditoID));
	SET Var_TotalAdeudo	  := IFNULL(Var_TotalAdeudo,  Decimal_Cero);


	ManejoErrores: BEGIN

		SET Aud_FechaActual		:= NOW();
		-- SE VALIDA QUE NO SE HAYA RECIBIDO UN PAGO DE CREDITO SI AUN NO PASA MAS DE UN MINUTO.
		# SE OBTIENE LA FECHA DEL PAGO MÁS RECIENTE.
		SET Var_FechaActPago := (SELECT MAX(FechaActual) FROM DETALLEPAGCRE WHERE CreditoID = Par_CreditoID AND FechaPago = Var_FechaSistema);
		SET Var_FechaActPago := IFNULL(Var_FechaActPago,Fecha_Vacia);

		# SE CALCULA LA DIFERENCIA ENTRE LAS FECHAS EN DÍAS
		SET Var_DifDiasPago := DATEDIFF(Aud_FechaActual,Var_FechaActPago);
		SET Var_DifDiasPago := IFNULL(Var_DifDiasPago,Entero_Cero);

		# SI EL PAGO ES EN EL MISMO DÍA, SE VALIDA QUE HAYA PASADO AL MENOS 1 MIN.
		IF(Var_DifDiasPago=Entero_Cero)THEN
			IF(TIMEDIFF(Aud_FechaActual,Var_FechaActPago)<= time('00:01:00'))THEN
				SET Par_NumErr		:= '001';
				SET Par_ErrMen		:= 'Ya se realizo un pago de credito para el cliente indicado, favor de intentarlo nuevamente en un minuto.';
				SET VarControl		:= 'creditoID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

	# ===================================================  SECCION DE VALIDACIONES ANTES DE ENTRAR AL CICLO DE PAGOS  ==================================================
		IF(IFNULL(Par_CreditoID,  Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El Numero de Credito esta Vacio.';
			SET VarControl  := 'creditoID' ;
			LEAVE ManejoErrores;

		ELSE IF(Var_CreEstatus != Estatus_Vigente AND Var_CreEstatus != Estatus_Vencido ) THEN
				SET Par_NumErr  := '002';
				SET Par_ErrMen  := 'El Credito debe estar Vigente o Vencido.';
				SET VarControl  := 'creditoID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_MontoPagar,  Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr  := '003';
			SET Par_ErrMen  := 'El Monto a Pagar esta Vacio.';
			SET VarControl  := 'montoPagar' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ModoPago,  Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := 'Indique el Modo de Pago.';
			SET VarControl  := 'modoPago' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Poliza,  Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := '005';
			SET Par_ErrMen  := 'El Numero de Poliza esta Vacio.';
			SET VarControl  := 'polizaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaAhoID,  Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := '006';
			SET Par_ErrMen  := 'El Numero de Cuenta esta Vacio.';
			SET VarControl  := 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		CALL SALDOSAHORROCON(Var_CueClienteID, 	Var_CueSaldo,	 Var_CueMoneda, 	Var_CueEstatus,	 Par_CuentaAhoID);
		IF(IFNULL(Par_CuentaAhoID,  Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr		:= '007';
			SET Par_ErrMen		:= 'La Cuenta no Existe.';
			SET VarControl		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Var_CueClienteID, Entero_Cero) != Var_ClienteID) THEN

			IF (Var_EsGrupal = EsGrupal_NO) THEN
				SET Par_NumErr		:= '008';
				SET Par_ErrMen		:= CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),
										' No Pertenece al Socio ', CONVERT(Var_ClienteID, char), '.');
				SET VarControl		:= 'cuentaAhoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Var_CueMoneda, Entero_Cero) != Var_MonedaID) THEN
			SET Par_NumErr		:= '010';
			SET Par_ErrMen		:= 'La Moneda no corresponde con la Cuenta.';
			SET VarControl		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_MontoPagar > Var_TotalAdeudo) THEN
        SET Par_NumErr			:= '011';
			SET Par_ErrMen		:= 'El Saldo de la Cuenta es Mayor al Adeudo Total del Credito.';
			SET VarControl		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		# Respaldamos las tablas de CREDITOS, AMORTICREDITO, CREDITOSMOVS antes de realizar el pago (usado para la reversa)
		CALL RESPAGCREDITOPRO(
			Par_CreditoID,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		# ====================== PAGO Y CASTIGO DE INTERESES MORATORIOS ======================
        IF(Par_MontoPagar > Decimal_Cero) THEN
			CALL PAGOVERINTMORACREPRO(
					Par_CreditoID,			Par_MontoPagar,		Par_ModoPago,		Par_CuentaAhoID, 	Par_Poliza,
					Par_OrigenPago,			SalidaNO,			Par_NumErr,			Par_ErrMen,			Var_MontoSaldo,
					Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;

			ELSE
				SET Par_MontoPagar 	 :=   Var_MontoSaldo;
			END IF;
		END IF;

		# ====================== PAGO Y CASTIGO DE INTERESES VENCIDOS ======================
		IF(Par_MontoPagar > Decimal_Cero) THEN
			CALL PAGOVERINTVENCREPRO(
					Par_CreditoID,		Par_MontoPagar,		Par_ModoPago,		Par_CuentaAhoID, 	Par_Poliza,
					Par_OrigenPago,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Var_MontoSaldo,
					Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);


			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;

			ELSE
				SET Par_MontoPagar 	 :=  Var_MontoSaldo;
			END IF;
		END IF;

		# ====================== PAGO Y CASTIGO DE INTERESES VIGENTES ======================
        IF(Par_MontoPagar > Decimal_Cero) THEN
			CALL PAGOVERINTPROVCREPRO(
					Par_CreditoID,		Par_MontoPagar,		Par_ModoPago,		Par_CuentaAhoID, 	Par_Poliza,
					Par_OrigenPago,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Var_MontoSaldo,
					Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;

			ELSE
				SET Par_MontoPagar 	 := Var_MontoSaldo;
			END IF;
		END IF;


		# ====================== PAGO Y CASTIGO DE CAPITAL ======================
		 IF(Par_MontoPagar > Decimal_Cero) THEN
			CALL PAGOVERCAPITALCREPRO(
					Par_CreditoID,		Par_MontoPagar,		Par_ModoPago,		Par_CuentaAhoID, 	Par_Poliza,
					Par_OrigenPago,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Var_MontoSaldo,
					Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;

			ELSE
				SET Par_MontoPagar 	:=   Var_MontoSaldo;
			END IF;
		END IF;

		# ====================== PAGO Y CASTIGO DE INTERESES NO CONTABILIZADOS Y CUENTAS DE ORDEN ======================
		IF(Par_MontoPagar > Decimal_Cero) THEN
			CALL PAGOVERINTNOCONTCREPRO(
					Par_CreditoID,		Par_MontoPagar,		Par_ModoPago,		Par_CuentaAhoID, 	Par_Poliza,
					Par_OrigenPago,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Var_MontoSaldo,
					Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		# ======================== SE AFECTA EL MOVIMIENTO DE PAGO A LA CUENTA DE AHORRO =================
		IF(Var_MontoPago > Entero_Cero)THEN

			CALL CONTAAHORROPRO (
					Par_CuentaAhoID,	Var_CueClienteID,	Aud_NumTransaccion,		Var_FechaSistema,	Var_FechaSistema,
					Nat_Cargo,			Var_MontoPago,		Des_PagoCredito,		Var_CreditoStr,		Aho_PagoCred,
					Var_MonedaID,		Var_SucCliente,		AltaPoliza_NO,			Entero_Cero,		Par_Poliza,
					AltaMovAho_SI,		Con_AhoCapital,		Nat_Cargo,				Par_NumErr,			Par_ErrMen,
					Var_Consecutivo,	Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		# Se respalda el pago efectuado para complementar los datos necesarios para la reversa de pago de credito
		CALL RESPAGCREDITOALT(
			Aud_NumTransaccion,	Par_CuentaAhoID,	Par_CreditoID,		Var_MontoPago,		Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		# ============================== COMIENZA EL CASTIGO DEL CREDITO =========================
		CALL CRECASTIGOPRO(
				Par_CreditoID,		Par_Poliza,			Var_MotivoCastigoID,		Var_Observaciones,		CastPagVertical,
				CobranzaNinuna, 	AltaPoliza_NO,		SalidaNO,			Par_EmpresaID,				Par_NumErr,
                Par_ErrMen,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,
                Aud_Sucursal,		Aud_NumTransaccion
                );


		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		IF(Var_MontoPago > Decimal_Cero) THEN
				SET Par_NumErr      := '000';
				SET Par_ErrMen      := CONCAT('Pago Aplicado Exitosamente: ',FORMAT(Var_MontoPago,2));
			ELSE
				SET Par_NumErr      	:= '000';
				SET Par_ErrMen      := CONCAT('Credito Castigado Exitosamente: ',CONVERT(Par_CreditoID,CHAR));
		END IF;

		# ==========================================================================================

		END ManejoErrores;  # End del Handler de Errores

		IF(Par_Salida = SalidaSI) THEN
			SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
					Par_ErrMen 		AS ErrMen,
					VarControl	 	AS control,
					Par_CreditoID 	AS consecutivo;
		END IF;

	END TerminaStore$$