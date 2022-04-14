DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTARJETADEBVAL;
DELIMITER $$

CREATE PROCEDURE ISOTRXTARJETADEBVAL(
	-- Descripcion: Proceso que realiza la validacion de la tarjeta de debito
	-- Modulo: Procesos de ISOTRX
	Par_TipoOperacion		INT(11),			-- Tipo de operacion a realizar
	Par_NumeroTarjeta 		VARCHAR(16),		-- Numero de tarjeta
	INOUT Par_ClienteID		INT(11),			-- Identificador del cliente
	INOUT Par_CuentaAhoID	BIGINT(12),			-- Numero de la cuenta de ahorro
	Par_NatMovimiento		CHAR(1),			-- Naturaleza del movimiento de la operacion

	Par_MontoTransaccion	DECIMAL(12,2),		-- Monto total de la transacción
	Par_MontoAdicional		DECIMAL(12,2),		-- Monto de disposición en compra
	Par_GiroComercial		INT(11),			-- Catalogo ISOTRXCODGIROCOMER

	Par_Salida				CHAR(1),			-- Salida
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);	-- Variable de control
	DECLARE Var_CuentaAhoID			BIGINT(12);		-- Numero de la cuenta de ahorro
	DECLARE Var_TDEstatus			INT(11);		-- Estatus de la tarjeta de debido
	DECLARE Var_ClienteID			INT(11);		-- Identificador del cliente
	DECLARE Var_ClienteAux			INT(11);		-- Variable auxiliar del cliente
	DECLARE Var_SaldoCuenta			DECIMAL(12,2);	-- Saldo disponible de la cuenta
	DECLARE Var_MonedaID			INT(11);		-- Moneda id de la cuenta
	DECLARE Var_EstatusCta			CHAR(1);		-- Estatus de la cuenta
	DECLARE Var_FechaSistema		DATE;			-- Fecha del sistema
	DECLARE Var_EstatusTD			VARCHAR(50);	-- Estatus de la tarjeta
	DECLARE Var_EstatusCuenta		VARCHAR(50);	-- Estatus de la cuenta de ahorro
	DECLARE Var_OperacionExistente	VARCHAR(100);	-- Variable para las operaciones de reversa valido

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;			-- Fecha vacia
	DECLARE Entero_Cero				INT(11);		-- Entero cero
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Decimal cero
	DECLARE SalidaSI				CHAR(1); 		-- Salida SI
	DECLARE SalidaNO				CHAR(1); 		-- Salida NO
	DECLARE Con_SI					CHAR(1); 		-- Constante SI
	DECLARE Con_NO					CHAR(1); 		-- Constante NO
	DECLARE Entero_Dieciseis		INT(11);		-- Variable de entero diecisesis
	DECLARE Estatus_TDActivo		INT(11);		-- Estatus de la tarjeta activa
	DECLARE Estatus_CtaActivo		CHAR(1);		-- Estatus de la cuenta de ahorro
	DECLARE Nat_Cargo				CHAR(1);		-- Naturaleza cargos
	DECLARE Nat_Abono				CHAR(1);		-- Naturaleza abonos
	DECLARE Nat_Reversa				CHAR(1);		-- Naturaleza de reversa
	DECLARE Estatus_TDBloqueada		INT(11);		-- Estatus Bloqueada
	DECLARE Estatus_TDCancelada		INT(11);		-- Estatus Cancelada
	DECLARE Estatus_TDExpirada		INT(11);		-- Estatus Expirada
	DECLARE Estatus_TDDesbloqueada	INT(11);		-- Estatus Desbloqueada
	DECLARE Estatus_TDInactiva		INT(11);		-- Estatus inactiva
	DECLARE Estatus_TDRobada		INT(11);		-- Estatus Robada
	DECLARE Estatus_TDSuspendida	INT(11);		-- Estatus Suspendida
	DECLARE Estatus_TDPerdida		INT(11);		-- Estatus Perdida
	DECLARE	Estatus_CtaBloqueada	CHAR(1);		-- Estatus bloqueada
	DECLARE Estatus_CtaCancelada	CHAR(1);		-- Estatus cancelada
	DECLARE Estatus_CtaInactiva		CHAR(1);		-- Estatus inactiva

	-- Declaracion de numero de transacciones
	DECLARE Tran_Disposicion		INT(11);		-- Transaccion de tipo venta disposicion

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Entero_Cero					:= 0;
	SET Decimal_Cero				:= 0.00;
	SET Aud_FechaActual				:= NOW();
	SET Con_SI						:= 'S';
	SET Con_NO						:= 'N';
	SET SalidaSI					:= 'S';
	SET SalidaNO					:= 'N';
	SET Entero_Dieciseis			:= 16;
	SET Estatus_TDActivo			:= 7;
	SET Estatus_CtaActivo			:= 'A';
	SET Nat_Cargo					:= 'C';
	SET Nat_Abono					:= 'A';
	SET Nat_Reversa					:= 'R';
	SET Estatus_TDBloqueada			:= 8;
	SET Estatus_TDCancelada			:= 9;
	SET Estatus_TDExpirada			:= 10;
	SET Estatus_TDDesbloqueada		:= 11;
	SET Estatus_TDInactiva			:= 12;
	SET Estatus_TDRobada			:= 13;
	SET Estatus_TDSuspendida		:= 14;
	SET Estatus_TDPerdida			:= 15;
	SET	Estatus_CtaBloqueada		:= 'B';
	SET Estatus_CtaCancelada		:= 'C';
	SET Estatus_CtaInactiva			:= 'I';

	-- Asignacion de numero de transacciones
	SET Tran_Disposicion			:= 12;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXTARJETADEBVAL');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		-- Validacion de datos nulos
		SET Par_NumeroTarjeta		:= IFNULL(Par_NumeroTarjeta, Cadena_Vacia);
		SET Par_TipoOperacion		:= IFNULL(Par_TipoOperacion, Entero_Cero);
		SET Par_MontoTransaccion	:= IFNULL(Par_MontoTransaccion, Decimal_Cero);
		SET Par_MontoAdicional		:= IFNULL(Par_MontoAdicional, Decimal_Cero);
		SET Par_GiroComercial		:= IFNULL(Par_GiroComercial, Entero_Cero);
		SET Var_OperacionExistente	:= '1,2,3,4,5,6,7,8,9,10,16,17,18,21,40,41,42,96';

		-- Fecha del sistema
		SELECT 	FechaSistema,		MonedaBaseID
		INTO	Var_FechaSistema,	Var_MonedaID
		FROM PARAMETROSSIS;

		-- Validaciones
		IF(Par_NumeroTarjeta = Cadena_Vacia)THEN
			SET Par_NumErr	:= 1000;
			SET Par_ErrMen	:= 'El Numero de la Tarjeta se encuentra vacio';
			SET Var_Control	:= 'numeroTarjeta';
			LEAVE ManejoErrores;
		END IF;

		IF(LENGTH(Par_NumeroTarjeta)<> Entero_Dieciseis)THEN
			SET Par_NumErr	:= 1001;
			SET Par_ErrMen	:= 'El Numero de la Tarjeta es incorrecto';
			SET Var_Control	:= 'numeroTarjeta';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT TarjetaDebID FROM TARJETADEBITO WHERE TarjetaDebID = Par_NumeroTarjeta)THEN
			SET Par_NumErr  := 0005;
			SET Par_ErrMen  := 'El número de tarjeta no existe.';
			SET Var_Control	:= 'numeroTarjeta';
			LEAVE ManejoErrores;
		END IF;

		-- consultar cuenta de la tarjeta
		SELECT	CuentaAhoID ,		Estatus,		ClienteID,
			CASE
				WHEN Estatus = Estatus_TDBloqueada THEN
					"Bloqueada"
				WHEN Estatus = Estatus_TDCancelada THEN
					"Cancelada"
				WHEN Estatus = Estatus_TDExpirada THEN
					"Expirada"
				WHEN Estatus = Estatus_TDDesbloqueada THEN
					"Desbloqueada"
				WHEN Estatus = Estatus_TDInactiva THEN
					"Inactiva"
				WHEN Estatus = Estatus_TDRobada THEN
					"Robada"
				WHEN Estatus = Estatus_TDSuspendida THEN
					"Suspendida"
				WHEN Estatus = Estatus_TDPerdida THEN
					"Perdida"
				ELSE
					"Inactiva"
			END
		INTO	Var_CuentaAhoID,	Var_TDEstatus,	Var_ClienteID,
				Var_EstatusTD
		FROM TARJETADEBITO
		WHERE TarjetaDebID = Par_NumeroTarjeta;

		-- Validacion de datos nulos
		SET Var_EstatusTD := IFNULL(Var_EstatusTD, Cadena_Vacia);

		IF(Var_CuentaAhoID = Entero_Cero )then
			SET Par_NumErr	:= 1003;
			SET Par_ErrMen	:= 'La Tarjeta de Debito no tiene una cuenta de ahorro asociada.';
			SET Var_Control	:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_TDEstatus <> Estatus_TDActivo) THEN
			SET Par_NumErr	:= 0006;
			SET Par_ErrMen	:= CONCAT('La tarjeta se encuentra ',Var_EstatusTD);
			SET Var_Control	:= 'numeroTarjeta';
			LEAVE ManejoErrores;
		END IF;

		-- Proceso para validar que la cuenta exista y tenga saldos disponibles
		CALL SALDOSAHORROCON(Var_ClienteAux,	Var_SaldoCuenta,	Var_MonedaID,	Var_EstatusCta,	Var_CuentaAhoID);

		IF(Var_ClienteAux <> Var_ClienteID)THEN
			SET Par_NumErr	:= 1005;
			SET Par_ErrMen	:= 'El Cliente relacionado a la cuenta es diferente al cliente de la Tarjeta de Debito.';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		-- Estatus de la cuenta
		SELECT
			CASE
				WHEN Var_EstatusCta = Estatus_CtaBloqueada THEN
					"Bloqueada"
				WHEN Var_EstatusCta = Estatus_CtaCancelada THEN
					"Cancelada"
				WHEN Var_EstatusCta = Estatus_CtaInactiva THEN
					"Inactiva"
				ELSE
					"Desconocida"
			END
		INTO Var_EstatusCuenta;

		IF(Var_EstatusCta <> Estatus_CtaActivo)THEN
			SET Par_NumErr	:= 1006;
			SET Par_ErrMen	:= CONCAT('La Cuenta de Ahorro se encuentra ',Var_EstatusCuenta);
			SET Var_Control	:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_SaldoCuenta <= Decimal_Cero)THEN
			SET Par_NumErr	:= 0003;
			SET Par_ErrMen	:= 'Saldo Insuficiente en la Cuenta.';
			SET Var_Control	:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		-- SI LA NATURALEZA DEL MOVIMIENTO ES CARGO, SE INVOCA EL SP QUE VALIDA LOS LIMITES Y MONTO DE LA TARJETA
		IF(Par_NatMovimiento = Nat_Cargo)THEN

			IF(FIND_IN_SET(Par_TipoOperacion,Var_OperacionExistente) > Entero_Cero)THEN
				CALL ISOTRXTARJETADEBGIROVAL(
					Par_NumeroTarjeta,	Par_MontoTransaccion,	Par_MontoAdicional,	Par_GiroComercial,
					SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- SE INVOCA EL SP QUE REALIZA LA CONSULTAS DE LOS LIMITES
			CALL ISOTRXTARJETADEBLIMITEPRO(
				Par_TipoOperacion,		Par_NumeroTarjeta,		Nat_Cargo,			Par_MontoTransaccion,
				Par_MontoAdicional,		Par_GiroComercial,
				SalidaNO,				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);
			-- Se evalua el error
			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- SI EL MOVIMIENTO ES ABONO, SE VALIDAN LOS MAXIMOS DE CARGOS AL MES POR LAS CUENTAS DE AHORROS
		IF(Par_NatMovimiento = Nat_Abono)THEN
			CALL DEPCUENTASVAL(
				Var_CuentaAhoID,	Par_MontoTransaccion,	Var_FechaSistema,	Entero_Cero,
				SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);
			-- Se evalua el error
			IF(Par_NumErr <> Entero_Cero)THEN
			    SET Par_NumErr 		:= 0009;
				SET Par_ErrMen 		:= CONCAT('Límite Regulatorio Excedido. ', Par_ErrMen);
				LEAVE ManejoErrores;
			END IF;

			-- SE INVOCA EL SP QUE REALIZA LA CONSULTAS DE LOS LIMITES
			CALL ISOTRXTARJETADEBLIMITEPRO(
				Par_TipoOperacion,		Par_NumeroTarjeta,		Nat_Abono,			Par_MontoTransaccion,
				Par_MontoAdicional,		Par_GiroComercial,
				SalidaNO,				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);
			-- Se evalua el error
			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- SI EL MOVIMIENTO ES REVERSA
		IF(Par_NatMovimiento = Nat_Reversa)THEN

			-- SE INVOCA EL SP QUE REALIZA LA CONSULTAS DE LOS LIMITES
			CALL ISOTRXTARJETADEBLIMITEPRO(
				Par_TipoOperacion,		Par_NumeroTarjeta,		Nat_Abono,			Par_MontoTransaccion,
				Par_MontoAdicional,		Par_GiroComercial,
				SalidaNO,				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);
			-- Se evalua el error
			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ClienteID	:= Var_ClienteID;
		SET Par_CuentaAhoID	:= Var_CuentaAhoID;
		SET Par_ErrMen 		:= 'Tarjeta Valida Exitosamente.';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$