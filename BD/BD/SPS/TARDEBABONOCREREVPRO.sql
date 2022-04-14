-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBABONOCREREVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBABONOCREREVPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBABONOCREREVPRO`(
	# =====================================================================================
	# ----- SP QUE DA REVERSA A LOS MOVIMIENTOS DE ABONO Y PAGO DE CREDITO (OXXO) -------
	# =====================================================================================

	Par_TipoOperacion			CHAR(2),			-- Tipo de Operacion
	Par_NumeroTarjeta       	CHAR(16),			-- Numero de Tarjeta
	Par_Referencia				VARCHAR(12),		-- Referencia
	Par_MontoTransaccion    	DECIMAL(12,2),		-- Monto de la Transaccion

	Par_MonedaID            	INT(11), 			-- Id moneda
	Par_NumTransaccion      	VARCHAR(10), 		-- Numero de transaccion
	Par_FechaActual         	DATETIME,			-- Fecha actual

	INOUT NumeroTransaccion		VARCHAR(20),		-- Numero de transaccion
	INOUT SaldoContableAct		VARCHAR(13),		-- Saldo contable activo
	INOUT SaldoDisponibleAct	VARCHAR(13),		-- Saldo disponible activo
	INOUT CodigoRespuesta   	VARCHAR(3),			-- Codigo de respuesta

    INOUT FechaAplicacion		VARCHAR(4),			-- Fecha de aplicacion
	Par_TardebMovID				INT(11)				-- Id de TardebMov
	)
TerminaStore: BEGIN


	-- Declaracion de variables
	DECLARE Var_CuentaOrigen        BIGINT(12);				-- Valor del numero de cuenta Origen
    DECLARE Var_CuentaDestino       BIGINT(12);				-- Valor del numero de cuenta Destino
	DECLARE Var_ClienteOri			INT(11);				-- Valor de origen del cliente
    DECLARE Var_TipoCuenta			VARCHAR(100);				-- Tipo de la Cuenta Destino
	DECLARE Par_ReferenciaMov		VARCHAR(50);	        -- Valor de referencia de movimiento
	DECLARE Var_DesAhorro           VARCHAR(150);			-- Descripcion compra con tarjeta
	DECLARE Var_SaldoDispoAct    	DECIMAL(12,2);			-- Valor del saldo disponible actual
	DECLARE Var_BloqueID            INT(11);				-- Valor motivo bloqueo
	DECLARE Var_NatMovimiento       CHAR(1);				-- Valor de la naturaleza de movimiento
	DECLARE Var_TipoBloqID          INT(11);				-- Valor tipo de bloqueo con tarjeta
	DECLARE Var_NumTransaccion  	BIGINT(20);				-- Se obtiene el numero de transaccion
	DECLARE Var_SaldoContable		DECIMAL(12,2);			-- Saldo contable de la cuenta
    DECLARE	Var_FechaSistema		DATE;					-- Valor de la fecha del sistema
    DECLARE Var_SucursalCli			INT(11);				-- Valor de la sucursal del cliente
    DECLARE Var_PolizaID			INT(11);				-- Valor del id de la poliza
    DECLARE Var_SaldoCtaOri			DECIMAL(12,2);			-- Saldo de la Cuenta
    DECLARE Var_MonedaCtaOri		INT(11);				-- Moneda de la Cuenta
    DECLARE Var_StatusCtaOri		CHAR(1);				-- Estatus de la Cuenta
    DECLARE Var_Fecha				DATETIME;				-- Fecha del Sistema (Hora. MIN, Seg)
    DECLARE Var_NumCtaDest			INT(11);				-- Numero de Cuentas Destino

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Entero_Cero     		INT(11);
	DECLARE Decimal_Cero    		DECIMAL(12,2);
	DECLARE Saldo_Cero				VARCHAR(13);
    DECLARE Fecha_Vacia     		DATE;
	DECLARE Salida_SI       		CHAR(1);
	DECLARE Salida_NO       		CHAR(1);
	DECLARE Aud_EmpresaID   		INT(11);
	DECLARE Aud_Usuario     		INT(11);
	DECLARE Aud_FechaActual			DATETIME;
	DECLARE Aud_DireccionIP 		VARCHAR(15);
	DECLARE Aud_ProgramaID  		VARCHAR(50);
	DECLARE Aud_Sucursal    		INT(11);
	DECLARE Error_Key       		INT(11);
	DECLARE Est_Procesado			CHAR(1);
    DECLARE BloqueoSaldo			CHAR(1);
    DECLARE Est_Registrado			CHAR(1);
	DECLARE CuentaInterna			CHAR(1);				-- Cuenta interna
    DECLARE DescripcionMov			VARCHAR(100);			-- Descripcion del movimiento
    DECLARE Con_DescriMov   		VARCHAR(50);
    DECLARE Con_PagoCre				VARCHAR(50);
    DECLARE TipoMovAhoID			INT(11);
	DECLARE Con_TransCtas			INT(11);
    DECLARE Concepto_Aho			INT(11);
    DECLARE Con_OperaPagTar			INT(11);
    DECLARE ConceptoTarDeb  		INT(11);
    DECLARE Con_AhoCapital  		INT(11);					-- Ahorro de capital
    DECLARE AltaEncPolizaSI			CHAR(1);
    DECLARE AltaEncPolizaNO			CHAR(1);
    DECLARE AltaPolCre_SI			CHAR(1);
    DECLARE Pol_Automatica  		CHAR(1);
    DECLARE Est_Activa				CHAR(1);
    DECLARE Nat_Cargo       		CHAR(1);
    DECLARE Nat_Abono				CHAR(1);
	DECLARE Par_Consecutivo			INT(11);
	DECLARE TipBloqTarjeta			INT(11);
    DECLARE Par_NumErr				INT(11);
	DECLARE Par_ErrMen         	 	VARCHAR(150);
    DECLARE Nat_Mov					CHAR(1);
    DECLARE Est_Autorizada			CHAR(1);



	-- Asignacion de constantes

	SET Cadena_Vacia    	:= '';				-- Cadena vacia
	SET Entero_Cero     	:= 0;				-- Entero cero
	SET Decimal_Cero    	:= '0.00';			-- DECIMAL cero
	SET Saldo_Cero			:= 'C000000000000';		-- Saldo cero
	SET Fecha_Vacia     	:= '1900-01-01';  		-- Fecha vacia
	SET Salida_SI       	:= 'S';				-- El Store SI genera una Salida
	SET Salida_NO       	:= 'N';				-- El Store NO genera una Salida
	SET Aud_EmpresaID   	:= 1;				-- Campo de Auditoria
	SET Aud_Usuario     	:= 1;				-- Campo de Auditoria
	SET Aud_DireccionIP 	:= 'localhost';		-- Campo de Auditoria
	SET Aud_ProgramaID  	:= 'workbench';		-- Campo de Auditoria
	SET Aud_Sucursal    	:= 1;				-- Campo de Auditoria
	SET Error_Key       	:= Entero_Cero;		-- Numero de error: Cero
	SET Est_Procesado		:= 'P'; 			-- Estatus de la tarjeta: Procesado
	SET BloqueoSaldo		:= 'B';				-- Bloqueo de Saldo
	SET Est_Registrado		:= 'R';      		-- Estatus de Ristrado TARDEBBITACORAMOVS
    SET CuentaInterna		:= 'I';				-- Cuenta Tipo Interna
    SET DescripcionMov		:= 'REVERSA ABONO A PAGO DE CREDITO';
    SET Con_DescriMov		:= 'REVERSA APLICACION DE PAGO A CREDITO';
	SET Con_PagoCre			:= 'REVERSA ABONO A CREDITO';
	SET TipoMovAhoID		:= 12;
	SET Con_TransCtas		:= 90;
	SET	Concepto_Aho		:= 1;
	SET Con_OperaPagTar		:= 1; 				-- Concepto CUENTASMAYORDEB (Cuenta de Bancos)
    SET ConceptoTarDeb  	:= 300;     		-- Numero de concepto correspondiente a tarjeta de debito
    SET Con_AhoCapital  	:= 1; 				-- Concepto de ahorro de capital
    SET AltaEncPolizaSI		:= 'S';
    SET AltaEncPolizaNO		:= 'N';
    SET AltaPolCre_SI		:= 'S';
	SET Pol_Automatica  	:= 'A';   			-- Genera poliza de manera automatica
    SET Est_Activa			:= 'A';				-- Estatus ACTIVA
    SET Nat_Cargo       	:= 'C';        	 	-- Naturaleza de Cargo
    SET Nat_Abono			:= 'A';				-- Naturaleza de Abono
    SET Par_Consecutivo		:= 0;
	SET Nat_Mov				:= 'B';				-- Movimiento BLOQUEO
    SET TipBloqTarjeta      := 3;				-- Tipo Bloqueo :Tarjeta Debito
    SET Est_Autorizada		:= 'A';				-- Estatus Autorizada

	-- Asignacion de variables
	SET Aud_FechaActual		:= NOW();
	SET FechaAplicacion		:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);
    SET Var_FechaSistema 	:= (SELECT FechaSistema  FROM PARAMETROSSIS);
	SET Var_Fecha			:= IFNULL(CONCAT(DATE(Var_FechaSistema)," ",CURRENT_TIME), Fecha_Vacia);
	SET Var_TipoCuenta		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'TipoCuentaTarDeb');
    SET Var_DesAhorro 		:= CONCAT("REVERSA ERROR EN TRASPASO DE CUENTA");


	# SE VALIDA QUE EL MONTO DE LA TRANSACCION NO SEA CERO
	IF (IFNULL(Par_MontoTransaccion, Decimal_Cero) = Decimal_Cero) THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "110";
		SET FechaAplicacion		:= FechaAplicacion;
        LEAVE TerminaStore;
    END IF;
    # SE VALIDA QUE EL NUMERO DE TARJETA NO ESTE VACIO
	IF (IFNULL(Par_NumeroTarjeta, Cadena_Vacia) = Cadena_Vacia) THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "110";
		SET FechaAplicacion		:= FechaAplicacion;
        LEAVE TerminaStore;
    END IF;


    # SE OBTIENE EL NUMERO DE LA CUENTA DE AHORRO
    SET Var_CuentaOrigen := ( SELECT CuentaAhoID FROM TARJETADEBITO tar
								WHERE tar.TarjetaDebID = Par_NumeroTarjeta);

	# SE OBTIENEN LOS DATOS GENERALES DE LA CUENTA DE AHORRO
	CALL SALDOSAHORROCON(
		Var_ClienteOri,     Var_SaldoCtaOri,    Var_MonedaCtaOri,   Var_StatusCtaOri,
		Var_CuentaOrigen );

         # SE VALIDA QUE EL ESTATUS DE LA CUENTA ESTE ACTIVA
    IF (IFNULL(Var_StatusCtaOri, Cadena_Vacia)  != Est_Activa) THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "110";
		SET FechaAplicacion		:= FechaAplicacion;
        LEAVE TerminaStore;
    END IF;

    # SE OBTIENE LA CUENTA DESTINO
    SET Var_CuentaDestino := (SELECT CuentaAhoID
								FROM CUENTASAHO
								WHERE ClienteID = Var_ClienteOri
                                AND FIND_IN_SET(TipoCuentaID,Var_TipoCuenta) > 0
                                LIMIT 1);

   	SET Var_CuentaDestino := IFNULL(Var_CuentaDestino,Entero_Cero);
	# SE OBTIENE LA SUCURSAL ORIGEN DEL CLIENTE
	SET Var_SucursalCli := (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Var_ClienteOri);

	-- Inicalizacion
	SET Var_ClienteOri   		:= IFNULL(Var_ClienteOri, Entero_Cero);
	SET Par_ReferenciaMov  		:= CONCAT("TAR **** ", SUBSTRING(Par_NumeroTarjeta,13, 4));
	SET Par_MontoTransaccion	:= IFNULL(Par_MontoTransaccion, Decimal_Cero);

	SET Var_CuentaOrigen 	:= IFNULL(Var_CuentaOrigen, Entero_Cero);
    SET Var_SucursalCli		:= IFNULL(Var_SucursalCli, Entero_Cero);

	-- Se genera un numero de transaccion
	CALL TARDEBTRANSACPRO(Var_NumTransaccion);

	# SE DA DE ALTA EL ENCABEZADO DE LA POLIZA
	CALL MAESTROPOLIZASALT(
		Var_PolizaID,		Aud_EmpresaID,		Var_FechaSistema,	Pol_Automatica,		ConceptoTarDeb,
		Con_PagoCre,		Salida_NO,			Par_NumErr,     	Par_ErrMen,			Aud_Usuario,
    	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Var_NumTransaccion);

# ===== TRANSFERENCIA ENTRE LA CUENTA EJE Y CREDITU RED SI EXISTIO MOVIMIENTO =====

    # Valida Cuenta Destino -------
	IF Var_CuentaDestino <> Var_CuentaOrigen AND  Var_CuentaDestino <> Entero_Cero THEN

			# Validar si existe un Abono por el monto de la transaccion en la cuenta
			SET Var_NumCtaDest := ( SELECT COUNT(*) FROM CUENTASAHOMOV
				WHERE CuentaAhoID = Var_CuentaDestino
				AND NatMovimiento = 'A'
				AND CantidadMov = Par_MontoTransaccion
				AND NumTransaccion = Par_NumTransaccion);

			SET Var_NumCtaDest := IFNULL(Var_NumCtaDest, Entero_Cero);

			SELECT SaldoDispon
				INTO Var_SaldoDispoAct
				FROM CUENTASAHO
				WHERE CuentaAhoID = Var_CuentaDestino;
			-- ================ FIN DE BLOQUEO DE SALDO A LA CUENTA EJE

			IF Var_NumCtaDest > Entero_Cero AND Var_SaldoDispoAct >= Par_MontoTransaccion  THEN


				# Se realiza el cargo a la cuenta eje
				CALL CARGOABONOCTAPRO(
					Var_CuentaDestino,		Var_ClienteOri,			Var_NumTransaccion,		Var_FechaSistema,		Var_FechaSistema,
					Nat_Cargo,				Par_MontoTransaccion,	DescripcionMov,			Par_ReferenciaMov,		TipoMovAhoID,
					Par_MonedaID,			Var_SucursalCli,		AltaEncPolizaNO,		Con_TransCtas,			Var_PolizaID,
					AltaPolCre_SI,			Concepto_Aho,			Nat_Cargo,				Salida_NO,				Par_NumErr,
					Par_ErrMen, 			Par_Consecutivo,		Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Var_NumTransaccion);


				# Se realiza el abono a la cuenta creditu red
				CALL CARGOABONOCTAPRO(
					Var_CuentaOrigen,	Var_ClienteOri,		Var_NumTransaccion,		Var_FechaSistema,		Var_FechaSistema,
					Nat_Abono,			Par_MontoTransaccion,	DescripcionMov,		Par_ReferenciaMov,		TipoMovAhoID,
					Par_MonedaID,		Var_SucursalCli,	AltaEncPolizaNO,		Con_TransCtas,			Var_PolizaID,
					AltaPolCre_SI,		Concepto_Aho,		Nat_Abono,				Salida_NO,				Par_NumErr,
					Par_ErrMen,	 		Par_Consecutivo,	Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Var_NumTransaccion);

			END IF;

	END IF;
	# Fin Valida Cuenta


# ===== TRANSFERENCIA ENTRE LA CUENTA DE BANCOS Y CUENTA EJE =====
	IF (Par_MontoTransaccion <> Decimal_Cero ) THEN

		# Validar si se tiene un bloqueo para la cuenta con el monto
		SELECT BloqueoID
		INTO Var_BloqueID
		FROM BLOQUEOS
		WHERE CuentaAhoID = Var_CuentaOrigen
		AND NatMovimiento = Nat_Mov
		AND FolioBloq = Entero_Cero
		AND TiposBloqID = TipBloqTarjeta
		AND NumTransaccion = Par_NumTransaccion;

		SET Var_BloqueID := IFNULL(Var_BloqueID,Entero_Cero);

		IF Var_BloqueID <> Entero_Cero THEN

			CALL BLOQUEOSPRO(
				Var_BloqueID, 	 'D', 					Var_CuentaOrigen,	Var_Fecha,			Par_MontoTransaccion,
				Var_FechaSistema,  	TipBloqTarjeta,		Var_DesAhorro,      Var_NumTransaccion, Cadena_Vacia,
				Cadena_Vacia,  	Salida_SI,  			Par_NumErr,      	Par_ErrMen,         Par_Empresa,
				Aud_Usuario,   	Aud_FechaActual,		Aud_DireccionIP, 	Aud_ProgramaID,     Aud_Sucursal,
				Var_NumTransaccion);

			# Validar si Falla

		END IF;

		SELECT SaldoDispon
			INTO Var_SaldoDispoAct
			FROM CUENTASAHO
			WHERE CuentaAhoID = Var_CuentaOrigen;


		IF Var_SaldoDispoAct >= Par_MontoTransaccion THEN
			# SE CARGA LA CUENTA EJE PARA EL REVERSO
			UPDATE CUENTASAHO SET
				AbonosDia		= AbonosDia		- Par_MontoTransaccion,
				AbonosMes		= AbonosMes		- Par_MontoTransaccion,
				Saldo 			= (SaldoDispon + SaldoBloq) - Par_MontoTransaccion,
				SaldoDispon		= (((SaldoDispon + SaldoBloq + SaldoSBC) - Par_MontoTransaccion) - SaldoBloq - SaldoSBC)
			WHERE CuentaAhoID 	= Var_CuentaOrigen;

			# MOVIMIENTO OPERATIVO EN LA CUENTA DE AHORRO: PAGO DE CREDITO
			INSERT INTO CUENTASAHOMOV(
					CuentaAhoID,	    	NumeroMov,	            Fecha,				NatMovimiento,		CantidadMov,
					DescripcionMov,	 		ReferenciaMov,			TipoMovAhoID,		MonedaID,	  		PolizaID,
					EmpresaID, 				Usuario,			 	FechaActual,		DireccionIP, 		ProgramaID,
					Sucursal,             	NumTransaccion)
			VALUES(
					Var_CuentaOrigen,    	Var_NumTransaccion, 	Var_FechaSistema,	'C',      			Par_MontoTransaccion,
					Con_DescriMov,      	Par_NumTransaccion,		TipoMovAhoID,		Par_MonedaID,   	Entero_Cero,
					Aud_EmpresaID,			Aud_Usuario,        	Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,			Var_NumTransaccion);

			-- MOVIMIENTO CONTABLE
			IF (Par_MontoTransaccion <> Decimal_Cero ) THEN
	            # SE REALIZA EL CARGO A LA CUENTA EJE
				CALL POLIZASAHORROPRO(
					Var_PolizaID,       Aud_EmpresaID,  	Var_FechaSistema, 		Var_ClienteOri,      		Con_AhoCapital,
					Var_CuentaOrigen,   Par_MonedaID,   	Par_MontoTransaccion,	Entero_Cero,        		Con_DescriMov,
					Par_ReferenciaMov,  Salida_NO,			Par_NumErr,				Par_ErrMen,Aud_Usuario,    	Aud_FechaActual,
	                Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       	Var_NumTransaccion);

				# SE REALIZA EL ABONO A LA CUENTA DE BANCOS
				CALL POLIZATARJETAPRO(
					Var_PolizaID,       Aud_EmpresaID,      Var_FechaSistema,		Par_NumeroTarjeta,  Var_ClienteOri,
					Con_OperaPagTar,    Par_MonedaID,       Entero_Cero,    	Par_MontoTransaccion,	Con_DescriMov,
					Par_ReferenciaMov,	Entero_Cero,		Salida_NO,          	Par_NumErr,     	Par_ErrMen,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,
					Var_NumTransaccion);

			END IF;

		ELSE
			# setear error para que realice rollback
			SET Error_Key := 1;

		END IF;

	END IF;




	SELECT 	Saldo, 	SaldoDispon
		INTO Var_SaldoContable,Var_SaldoDispoAct
		FROM 	CUENTASAHO
		WHERE	CuentaAhoID	  =	Var_CuentaOrigen;

	UPDATE TARDEBBITACORAMOVS SET
			NumTransaccion 	= Var_NumTransaccion,
			Estatus			= Est_Procesado
		WHERE TipoOperacionID= Par_TipoOperacion
		AND TarjetaDebID = Par_NumeroTarjeta
		AND NumTransaccion = Entero_Cero
		AND TarDebMovID = Par_TardebMovID
		AND Estatus = Est_Registrado;

	IF ( Error_Key = Entero_Cero ) THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Var_NumTransaccion,CHAR), 6, 0);
		SET SaldoContableAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoContable,CHAR) , '.', ''), 12, 0));
		SET SaldoDisponibleAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoDispoAct,CHAR) , '.', ''), 12, 0));
		SET CodigoRespuesta   	:= "000";
		SET FechaAplicacion		:= FechaAplicacion;
	ELSE
		SET NumeroTransaccion	:= 	LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "412";
		SET FechaAplicacion		:= FechaAplicacion;
		ROLLBACK;
	END IF;

END TerminaStore$$