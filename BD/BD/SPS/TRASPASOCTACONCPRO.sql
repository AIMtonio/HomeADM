-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRASPASOCTACONCPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TRASPASOCTACONCPRO`;

DELIMITER $$
CREATE PROCEDURE `TRASPASOCTACONCPRO`(
	# =====================================================================================
	# ----- STORED QUE REALIZA EL TRASPASO ENTRE LA CUENTA DE BANCOS, CUENTA EJE Y CREDITU RED -------
	# =====================================================================================

	Par_NumAutoriza		INT(11),		# Numero de Autorizacion
	Par_ConciliaID		INT(11),		# Numero de Conciliacion
	Par_DetalleID		INT(11),		# Detalle de Conciliacion
	Par_NumCuenta		VARCHAR(19),	# Numero de Tarjeta
	Par_TipoTrans		CHAR(2),		# Tipo Transaccion
	Par_Estatus_Con		CHAR(1),		# Estatus Conciliacion S:SI   N:NO
	Par_Monto			DECIMAL(12,2),	# Monto de la Operacion
	Par_Salida			CHAR(1), 		# Parametro de Salida
	INOUT	Par_NumErr	INT(11),		# Numero de Error
	INOUT	Par_ErrMen	VARCHAR(400), 	# Mensaje de Salida

	# PARAMETROS DE AUDITORIA
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore:BEGIN

	# DECLARACION DE VARIABLES
	DECLARE Var_CuentaOrigen 	BIGINT(12);		# Valor del numero de cuenta Origen
    DECLARE Var_CuentaDestino   BIGINT(12);		# Valor del numero de cuenta Destino
    DECLARE Var_ClienteOri		INT(11);		# Numero del Cliente de Origen
	DECLARE Var_NumTransaccion	BIGINT(20);		# Numero de transaccion
	DECLARE	Var_FechaSistema	DATE;			# Fecha del Sistema
	DECLARE Par_ReferenciaMov	VARCHAR(50);	# Valor de referencia de movimiento
	DECLARE Var_PolizaID		INT(11);		# Numero de Poliza
	DECLARE Var_TipoCuenta		VARCHAR(100);		# Tipo de la Cuenta Destino
	DECLARE Var_SaldoCtaOri		DECIMAL(12,2);	# Saldo de la Cuenta
	DECLARE Var_MonedaCtaOri	INT(11);		# Moneda de la Cuenta
	DECLARE Var_StatusCtaOri	CHAR(1);		# Estatus de la Cuenta
	DECLARE Var_SucursalCli		INT(11);		# Sucursal del Cliente
    DECLARE Var_NumCtaDest		INT(11);				-- Numero de Cuentas Destino

    # DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);			# Cadena vacia
	DECLARE Entero_Cero			INT(11);			# Entero cero
    DECLARE Decimal_Cero    	DECIMAL(12,2);		# DECIMAL cero
	DECLARE Var_Control			VARCHAR(20);		# Variable de control
	DECLARE Salida_NO			CHAR(1);			# Store SI tiene una salida
	DECLARE Salida_SI			CHAR(1);			# Store NO tiene una salida
	DECLARE ActConciliado		INT(11);			#
	DECLARE EstConciliado		CHAR(1);			# Estado conciliado
	DECLARE Nat_Cargo 			CHAR(1);			# Naturaleza del cargo
	DECLARE Nat_Abono			CHAR(1);			# Naturaleza del abono
	DECLARE Con_DescriMov 		VARCHAR(50);		# Concepto descripcion de movimiento
	DECLARE TipoMovAhoID		INT(11);			# Tipo de movimiento de ahorro
	DECLARE Par_MonedaID		INT(11);			# Valor modena
	DECLARE Pol_Automatica 		CHAR(1);			# Genera poliza de manera automática
	DECLARE ConceptoTarDeb 		INT(11);			# Numero de concepto corriespondiente a tarjeta de debito
	DECLARE Con_PagoCre			VARCHAR(50);		# Concepto de pago de credito
	DECLARE Con_AhoCapital 		INT(11);			# Concepto de ahorro de capital
	DECLARE Con_OperaPagTar		INT(11);			# Concepto cuenta de banco
    DECLARE CuentaInterna		CHAR(1);   			# Cuenta tipo interna
    DECLARE AltaEncPolizaNO		CHAR(1);			# Alta encabezado de poliza NO
    DECLARE AltaPolCre_SI		CHAR(1);			# Alta poliza de credito SI
	DECLARE Con_TransCtas		INT(11);			# Concepto traspaso entre cuentas
	DECLARE Concepto_Aho		INT(11);			# Cuenta de ahorro
	DECLARE Par_Consecutivo		INT(11);			# Valor consecutivo
    DECLARE DescripcionMov		VARCHAR(100);		# Descripcion movimiento
    DECLARE Cons_SI				CHAR(1);			# Constante SI
    DECLARE Esta_Activo     	CHAR(1);			# Estado Activo
    DECLARE Est_Autorizada		CHAR(1);
	DECLARE Con_NO				CHAR(1);			-- Constante NO
	DECLARE Aplica_Cuenta		CHAR(1);			-- Constante Aplica a Cuenta de Ahorro

	# ASIGNACION DE CONSTANTES
	SET Cadena_Vacia		:= '';		# Constante Cadena Vacia
	SET Entero_Cero			:= 0;		# Constante Entero Cero
    SET Decimal_Cero    	:= '0.00';	# DECIMAL cero
	SET Salida_NO 			:= 'N';		# Constante NO
	SET Salida_SI			:= 'S';		# Constante SI
	SET Cons_SI				:= 'S';		# Constante SI
	SET TipoMovAhoID		:= 12;		# Tipo de Movimiento de Ahorro
    SET Con_AhoCapital 		:= 1; 		# Concepto de ahorro de capital
	SET Con_OperaPagTar		:= 1; 		# Concepto CUENTASMAYORDEB (Cuenta de Bancos)
    SET Con_TransCtas		:= 90;		# Concepto Traspaso entre Cuentas
	SET	Concepto_Aho		:= 1;		# Concepto de Ahorro
    SET ConceptoTarDeb 		:= 300; 	# Numero de concepto correspondiente a tarjeta de debito
	SET Par_MonedaID		:= 1;		# Valor Moneda
	SET Pol_Automatica 		:= 'A'; 	# Genera poliza de manera automatica
    SET AltaEncPolizaNO		:= 'N';		# Alta encabezado de Poliza: NO
	SET AltaPolCre_SI		:= 'S';		# Alta Poliza de Credito: SI
	SET Nat_Cargo 			:= 'C';		# Naturaleza de Cargo
	SET Nat_Abono			:= 'A';		# Naturaleza de Abono

    SET Con_DescriMov		:= 'APLICACION DE PAGO A CREDITO';	# Concepto Descripcion de movimiento
	SET Con_PagoCre			:= 'ABONO A CREDITO';	# Descripcion Concepto Pago de Credito
    SET DescripcionMov		:= 'ABONO A PAGO DE CREDITO';	# Descripcion movimiento
	SET EstConciliado		:= 'C';		# Estatus Conciliado
	SET CuentaInterna		:= 'I';		# Cuenta Tipo Interna
	SET Par_Consecutivo		:= 0;		# Valor Consecutivo
    SET Esta_Activo     	:= 'A';     # Estatus Activo
    SET Est_Autorizada		:= 'A';		# Estatus Autorizada
	SET Con_NO				:= 'N';
	SET Aplica_Cuenta		:= 'S';

	SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_TipoCuenta		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'TipoCuentaTarDeb');
    SET Aud_FechaActual		:= NOW();	# Fecha Actual
-- SELECT Par_Estatus_Con,Par_NumErr, Par_ErrMen;
	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TRASPASOCTACONCPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		# SE OBTIENE EL NUMERO DE LA CUENTA DE AHORRO
		SET Var_CuentaOrigen := ( SELECT CuentaAhoID FROM TARJETADEBITO tar
								WHERE tar.TarjetaDebID = Par_NumCuenta);


		# SE OBTIENEN LOS DATOS GENERALES DE LA CUENTA DE AHORRO
		CALL SALDOSAHORROCON(
		Var_ClienteOri, Var_SaldoCtaOri, Var_MonedaCtaOri, Var_StatusCtaOri,
		Var_CuentaOrigen );

		# SE OBTIENE LA CUENTA DESTINO
		SET Var_CuentaDestino :=(	SELECT CuentaAhoID
									FROM CUENTASAHO
									WHERE ClienteID = Var_ClienteOri
										AND FIND_IN_SET(TipoCuentaID,Var_TipoCuenta) > 0
									LIMIT 1);

		SET Var_CuentaDestino := IFNULL(Var_CuentaDestino, Entero_Cero);

		IF(IFNULL(Var_StatusCtaOri, Cadena_Vacia)) != Esta_Activo THEN
			SET Par_NumErr		:= '01';
			SET Par_ErrMen		:= 'La Cuenta No Existe o no Esta Activa ';
			SET Par_Consecutivo	:= 0;
			SET Var_Control		:= 	'';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Monto,  Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'El Monto a Pagar esta Vacio.';
			SET Var_Control  := '' ;
			LEAVE ManejoErrores;
		END IF;


        IF(IFNULL(Par_NumCuenta,  Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := '003';
			SET Par_ErrMen  := 'El Numero de Cuenta esta Vacio.';
			SET Var_Control  := '' ;
			LEAVE ManejoErrores;
		END IF;

		# SE OBTIENE LA SUCURSAL ORIGEN DEL CLIENTE
		SET Var_SucursalCli 	:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Var_ClienteOri);

		-- Inicalizacion
		SET Var_ClienteOri 		:= IFNULL(Var_ClienteOri, Entero_Cero);
		SET Par_ReferenciaMov	:= CONCAT("TAR **** ", SUBSTRING(Par_NumCuenta,13, 4));
		SET Par_Monto			:= IFNULL(Par_Monto, Decimal_Cero);


		SET Var_CuentaOrigen 	:= IFNULL(Var_CuentaOrigen, Entero_Cero);
		SET Var_SucursalCli		:= IFNULL(Var_SucursalCli, Entero_Cero);

       -- SELECT Par_Estatus_Con,Par_NumErr, Par_ErrMen;
		# SE REALIZA EL TRASPASO ENTRE CUENTAS
		IF(Par_Estatus_Con = Cons_SI) THEN
			 # ===== TRANSFERENCIA ENTRE LA CUENTA DE BANCOS Y CUENTA EJE =====
			 IF (Par_Monto <> Decimal_Cero ) THEN

				# SE ABONA LA CUENTA EJE
				UPDATE CUENTASAHO SET
					AbonosDia		= AbonosDia		+ Par_Monto,
					AbonosMes		= AbonosMes		+ Par_Monto,
					Saldo 			= (SaldoDispon + SaldoBloq) + Par_Monto,
					SaldoDispon		= (((SaldoDispon + SaldoBloq + SaldoSBC) + Par_Monto) - SaldoBloq - SaldoSBC)
				WHERE CuentaAhoID 	= Var_CuentaOrigen;

				-- MOVIMIENTO OPERATIVO EN LA CUENTA DE AHORRO: PAGO DE CREDITO

				INSERT INTO CUENTASAHOMOV(
						CuentaAhoID,		NumeroMov,	 		Fecha,				NatMovimiento,		CantidadMov,
						DescripcionMov,		ReferenciaMov,		TipoMovAhoID,		MonedaID,	 		PolizaID,
						EmpresaID, 			Usuario,			FechaActual,		DireccionIP, 		ProgramaID,
						Sucursal, 			NumTransaccion)
				VALUES(
						Var_CuentaOrigen, 	Aud_NumTransaccion, Var_FechaSistema,	Nat_Abono, 			Par_Monto,
						Con_DescriMov, 		Par_ReferenciaMov,	TipoMovAhoID,		Par_MonedaID, 		Entero_Cero,
						Aud_EmpresaID,		Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);


				# MOVIMIENTO CONTABLE

				# SE DA DE ALTA EL ENCABEZADO DE LA POLIZA
				CALL MAESTROPOLIZASALT(
					Var_PolizaID,		Aud_EmpresaID,		Var_FechaSistema,		Pol_Automatica,		ConceptoTarDeb,
					Con_PagoCre,		Salida_NO,			Par_NumErr,     		Par_ErrMen,			Aud_Usuario,
                    Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


                IF(Par_NumErr > Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				# SE REALIZA EL ABONO A LA CUENTA EJE
				CALL POLIZASAHORROPRO(
					Var_PolizaID, 		Aud_EmpresaID, 		Var_FechaSistema, 	Var_ClienteOri, 	Con_AhoCapital,
					Var_CuentaOrigen,	Par_MonedaID, 		Entero_Cero, 		Par_Monto, 			Con_DescriMov,
					Par_ReferenciaMov,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
                    Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal, 		Aud_NumTransaccion);


                IF(Par_NumErr > Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				# SE REALIZA EL CARGO A LA CUENTA DE BANCOS
				CALL POLIZATARJETAPRO(
					Var_PolizaID, 		Aud_EmpresaID, 		Var_FechaSistema,		Par_NumCuenta, 		Var_ClienteOri,
					Con_OperaPagTar, 	Par_MonedaID, 		Par_Monto,				Entero_Cero, 		Con_DescriMov,
					Par_ReferenciaMov,	Entero_Cero,		Salida_NO, 				Par_NumErr, 		Par_ErrMen,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr > Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;


			# ===== TRANSFERENCIA ENTRE LA CUENTA EJE Y CREDITU RED =====
			IF Var_CuentaDestino <> Var_CuentaOrigen AND Var_CuentaDestino <> Entero_Cero THEN

					SET Var_NumCtaDest := (SELECT COUNT(CuentaDestino)
								FROM CUENTASTRANSFER
								WHERE CuentaDestino=Var_CuentaDestino
								  AND ClienteID = Var_ClienteOri
								  AND Estatus = Est_Autorizada);

		            IF(Var_NumCtaDest = Entero_Cero) THEN
						# Se realiza el registro de transferencia entre cuentas
						CALL CUENTASTRANSFERALT(
							Var_ClienteOri,		Entero_Cero,		Entero_Cero,		Cadena_Vacia,	Cadena_Vacia,
							Cadena_Vacia,		Var_FechaSistema,	CuentaInterna,		Entero_Cero,	Entero_Cero,
							Var_CuentaDestino,	Var_ClienteOri,		Entero_Cero,		Cadena_Vacia,	Con_NO,
							Aplica_Cuenta,		Entero_Cero,
							Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,	Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
					END IF;
					IF(Par_NumErr > Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					# Se realiza el cargo a la cuenta eje
					CALL CARGOABONOCTAPRO(
						Var_CuentaOrigen,	Var_ClienteOri,			Aud_NumTransaccion,	Var_FechaSistema,	Var_FechaSistema,
						Nat_Cargo,			Par_Monto,				DescripcionMov,		Par_ReferenciaMov,	TipoMovAhoID,
						Par_MonedaID,		Var_SucursalCli,		AltaEncPolizaNO,	Con_TransCtas,		Var_PolizaID,
						AltaPolCre_SI,		Concepto_Aho,			Nat_Cargo,			Salida_NO,			Par_NumErr,
						Par_ErrMen, 		Par_Consecutivo,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


		            IF(Par_NumErr > Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					# Se realiza el abono a la cuenta creditu red
					CALL CARGOABONOCTAPRO(
						Var_CuentaDestino,	Var_ClienteOri,		Aud_NumTransaccion,		Var_FechaSistema,		Var_FechaSistema,
						Nat_Abono,			Par_Monto,			DescripcionMov,			Par_ReferenciaMov,		TipoMovAhoID,
						Par_MonedaID,		Var_SucursalCli,	AltaEncPolizaNO,		Con_TransCtas,			Var_PolizaID,
						AltaPolCre_SI,		Concepto_Aho,		Nat_Abono,				Salida_NO,				Par_NumErr,
						Par_ErrMen,	 		Par_Consecutivo,	Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr > Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
		 	END IF;

			 UPDATE TARDEBCONCILIADETA	SET
					EstatusConci	= EstConciliado
				WHERE ConciliaID 	= Par_ConciliaID
				AND DetalleID	= Par_DetalleID
				AND NumCuenta 	= Par_NumCuenta
				AND TipoTransaccion = Par_TipoTrans
				AND NumAutorizacion = Par_NumAutoriza;
		END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= 'Pago Procesado Exitosamente.';
			SET Var_Control := Cadena_Vacia;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen	 AS ErrMen,
			Cadena_Vacia AS control,
			Cadena_Vacia AS consecutivo;

END IF;

END TerminaStore$$