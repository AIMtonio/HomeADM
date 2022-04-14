DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTARJETADEBLIMITEPRO;
DELIMITER $$

CREATE PROCEDURE ISOTRXTARJETADEBLIMITEPRO(
	-- Descripcion: Proceso que realiza la validacion de la tarjeta de debito
	-- Modulo: Procesos de ISOTRX
	Par_TipoOperacion		INT(11),			-- Tipo de operacion a realizar
	Par_NumeroTarjeta 		VARCHAR(16),		-- Numero de tarjeta
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
	DECLARE Var_MontoDispoDiario	DECIMAL(12,2);	-- Monto disponible diario
	DECLARE Var_LimiteDispoDiario	DECIMAL(12,2);	-- Limite de disposicion diario
	DECLARE Var_LimiteNumRetiros	INT(11);		-- Limite de numero de retiros
	DECLARE Var_DispoDiario			INT(11);		-- Disposicion diario
	DECLARE Var_MontoDispoMes		DECIMAL(12,2);	-- Disponible al mes
	DECLARE Var_LimiteDispoMes		DECIMAL(12,2);	-- Disposicion al mes
	DECLARE Var_Continuar			INT(11);		-- Bandera que indica si se continua una operacion
	DECLARE Var_LimiteNumConsultas	INT(11);		-- Limite de numero de consultas
	DECLARE Var_TDNumeroConsultas	INT(11);		-- Numero de consultas
	DECLARE Var_MontoDispoLibre		DECIMAL(12,2);	-- Monto disponible libre
	DECLARE Var_MontoDispoMesLibre	DECIMAL(12,2);	-- Monto disponible al mes

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
	DECLARE Nat_Abono				CHAR(1);		-- Naturaleza abobos
	DECLARE Con_DispoDiario			INT(11);		-- Disponible diario
	DECLARE Con_NumDispoDia			INT(11);		-- Numero de disposicion diario
	DECLARE Con_DispoMes			INT(11);		-- Disposicion al mes
	DECLARE Con_NumConsultaMes		INT(11);		-- Numero de consultas al mes

	-- Declaracion de numero de transacciones
	DECLARE Tran_Disposicion		INT(11);		-- Transaccion de tipo venta disposicion
	DECLARE Tran_Consulta			INT(11);		-- Transaccion de tipo consulta
	DECLARE Tran_ReversoConsulta	INT(11);		-- Transaccion de tipo reverso de consulta
	DECLARE Tran_ReversoDisposicion	INT(11);		-- Transaccion de tipo reverso disposicion
	DECLARE Tran_VentaNormal		INT(11);		-- Transaccion de tipo venta normal
	DECLARE Tran_VentaCAT			INT(11);		-- Transaccion de tipo venta CAT
	DECLARE Tran_VentaInternet		INT(11);		-- Transaccion de tipo venta por internet
	DECLARE Tran_VentaManual		INT(11);		-- Transaccion de tipo venta manual
	DECLARE Tran_VentaQPS			INT(11);		-- Transaccion de tipo venta QPS
	DECLARE Tran_VentaMoTo			INT(11);		-- Transaccion de tipo venta MoTo
	DECLARE Tran_VentaConPromocion	INT(11);		-- Transaccion de tipo venta con promocion
	DECLARE Tran_VentaVoz			INT(11);		-- Transaccion de tipo venta venta de voz
	DECLARE Tran_ReversoVenta		INT(11);		-- Transaccion de tipo reverso de la venta

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
	SET Con_DispoDiario				:= 1;
	SET Con_NumDispoDia				:= 1;
	SET Con_DispoMes				:= 2;
	Set Con_NumConsultaMes			:= 3;

	-- Asignacion de numero de transacciones
	SET Tran_VentaNormal			:= 1;
	SET Tran_VentaConPromocion		:= 3;
	SET Tran_VentaManual			:= 5;
	SET Tran_VentaInternet			:= 6;
	SET Tran_VentaMoTo				:= 7;
	SET Tran_VentaVoz				:= 8;
	SET Tran_VentaQPS				:= 9;
	SET Tran_VentaCAT				:= 10;
	SET Tran_Disposicion			:= 12;
	SET Tran_ReversoVenta			:= 26;
	SET Tran_ReversoDisposicion		:= 27;
	SET Tran_ReversoConsulta		:= 28;
	SET Tran_Consulta				:= 30;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXTARJETADEBLIMITEPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		-- Validacion de datos nulos
		SET Par_NumeroTarjeta		:= IFNULL(Par_NumeroTarjeta, Cadena_Vacia);
		SET Par_TipoOperacion		:= IFNULL(Par_TipoOperacion, Entero_Cero);
		SET Par_MontoTransaccion	:= IFNULL(Par_MontoTransaccion, Decimal_Cero);
		SET Par_MontoAdicional		:= IFNULL(Par_MontoAdicional, Decimal_Cero);
		SET Par_GiroComercial		:= IFNULL(Par_GiroComercial, Entero_Cero);
		SET Var_Continuar			:= Entero_Cero;

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


		-- Se obtiene la cuenta de ahorro
		SELECT	CuentaAhoID
		INTO	Var_CuentaAhoID
		FROM TARJETADEBITO
 		WHERE TarjetaDebID = Par_NumeroTarjeta;

		-- Se consulta el saldo actual del cliente
		SELECT	SaldoDispon
		INTO	Var_SaldoCuenta
		FROM CUENTASAHO
		WHERE CuentaAhoID = Var_CuentaAhoID;

		SELECT
				IFNULL(tar.MontoDispoDiario, Decimal_Cero),
				IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID,tar.ClienteID, tar.TipoTarjetaDebID, Con_DispoDiario), Decimal_Cero),
				IFNULL(FUNCIONLIMITENUM(tar.TarjetaDebID, tar.ClienteID, tar.TipoTarjetaDebID, Con_NumDispoDia), Entero_Cero),
				IFNULL(tar.NoDispoDiario, Entero_Cero),
				IFNULL(tar.MontoDispoMes, Decimal_Cero),
				IFNULL(FUNCIONLIMITEMONTO(tar.TarjetaDebID, tar.ClienteID, tar.TipoTarjetaDebID, Con_DispoMes), Decimal_Cero),
				FUNCIONLIMITENUM(tar.TarjetaDebID, tar.ClienteID, tar.TipoTarjetaDebID, Con_NumConsultaMes),
				tar.NoConsultaSaldoMes
		INTO	Var_MontoDispoDiario,							Var_LimiteDispoDiario,
				Var_LimiteNumRetiros, 							Var_DispoDiario,
				Var_MontoDispoMes,								Var_LimiteDispoMes,
				Var_LimiteNumConsultas,							Var_TDNumeroConsultas
		FROM TARJETADEBITO tar
		WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

		-- Validacion de datos nulos
		SET Var_CuentaAhoID 		:= IFNULL(Var_CuentaAhoID, Entero_Cero);
		SET Var_SaldoCuenta			:= IFNULL(Var_SaldoCuenta, Decimal_Cero);
		SET Var_TDNumeroConsultas	:= IFNULL(Var_TDNumeroConsultas, Entero_Cero);
		SET Var_LimiteDispoMes		:= IFNULL(Var_LimiteDispoMes, Entero_Cero);
		SET Var_LimiteNumConsultas	:= IFNULL(Var_LimiteNumConsultas, Entero_Cero);

		-- Cuando la operacion es por disposicion
		IF(Par_TipoOperacion = Tran_Disposicion)THEN

			IF(Par_MontoTransaccion > Var_SaldoCuenta)THEN
				SET Par_NumErr	:= 0003;
				SET Par_ErrMen	:= 'Saldo Insuficiente en la Cuenta.';
				SET Var_Control	:= 'cuentaAhoID';
				LEAVE ManejoErrores;
			END IF;

			IF (Var_MontoDispoDiario < Var_LimiteDispoDiario) THEN
				SET Var_MontoDispoLibre = Var_LimiteDispoDiario - Var_MontoDispoDiario;
				IF (Par_MontoTransaccion <= Var_MontoDispoLibre)THEN
					SET Var_Continuar := Entero_Cero;
				ELSE
					SET Par_NumErr	:= 1322;
					SET Par_ErrMen	:= 'Limite de Retiro de Efectivo diario excedido.';
					SET Var_Control	:= 'numeroTarjeta';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_NumErr	:= 1322;
				SET Par_ErrMen	:= 'Limite de Retiro de Efectivo diario excedido.';
				SET Var_Control	:= 'numeroTarjeta';
				LEAVE ManejoErrores;
			END IF;

			IF (Var_MontoDispoMes < Var_LimiteDispoMes) THEN
				SET Var_MontoDispoMesLibre := Var_LimiteDispoMes - Var_MontoDispoMes;
				IF (Par_MontoTransaccion <= Var_MontoDispoMesLibre) THEN
					SET Var_Continuar := Entero_Cero;
				ELSE
					SET Par_NumErr	:= 1325;
					SET Par_ErrMen	:= 'Limite de Retiro de Efectivo Mensual excedido.';
					SET Var_Control	:= 'numeroTarjeta';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_NumErr	:= 1325;
				SET Par_ErrMen	:= 'Limite de Retiro de Efectivo Mensual excedido.';
				SET Var_Control	:= 'numeroTarjeta';
				LEAVE ManejoErrores;
			END IF;

			-- Se realiza el update de los limites de disposicion de tarjetas
			UPDATE TARJETADEBITO SET
				NoDispoDiario		= IFNULL(NoDispoDiario, Entero_Cero) + 1,
				NoDispoMes			= IFNULL(NoDispoMes, Entero_Cero) + 1,
				MontoDispoDiario	= IFNULL(MontoDispoDiario, Decimal_Cero) + Par_MontoTransaccion,
				MontoDispoMes		= IFNULL(MontoDispoMes, Decimal_Cero) + Par_MontoTransaccion
			WHERE TarjetaDebID = Par_NumeroTarjeta;
		END IF;

		-- Cuando la operacion es por consultas de saldos
		IF(Par_TipoOperacion = Tran_Consulta)THEN

			-- Se realiza la consulta de numero de consultas realizadas
			IF(Var_TDNumeroConsultas >= Var_LimiteNumConsultas)THEN
				SET Par_NumErr	:= 1323;
				SET Par_ErrMen	:= 'Limite de Consultas excedido.';
				SET Var_Control	:= 'numeroTarjeta';
				LEAVE ManejoErrores;
			END IF;

			-- Se afecta los campos de consultas
			UPDATE TARJETADEBITO SET
				NoConsultaSaldoMes	= IFNULL(NoConsultaSaldoMes, Entero_Cero) + 1,
				MontoDispoDiario	= IFNULL(MontoDispoDiario, Decimal_Cero) + Par_MontoTransaccion,
				MontoDispoMes		= IFNULL(MontoDispoMes, Decimal_Cero) + Par_MontoTransaccion
			WHERE TarjetaDebID = Par_NumeroTarjeta;
		END IF;

		-- SI LA NATURALEZA DEL MOVIMIENTO ES CARGO
		IF(Par_NatMovimiento = Nat_Cargo AND Par_TipoOperacion IN(Tran_VentaNormal,Tran_VentaConPromocion,Tran_VentaManual,
																Tran_VentaInternet,Tran_VentaMoTo,Tran_VentaVoz,
																Tran_VentaQPS,Tran_VentaCAT))THEN

			-- El update se realiza para los movimientos de cargos
			UPDATE TARJETADEBITO SET
				NoCompraDiario		= IFNULL(NoCompraDiario,Entero_Cero) + 1,
				NoCompraMes			= IFNULL(NoCompraMes, Entero_Cero) + 1,
				MontoCompraDiario	= IFNULL(MontoCompraDiario, Decimal_Cero) + Par_MontoTransaccion,
				MontoCompraMes		= IFNULL(MontoCompraMes, Decimal_Cero) + Par_MontoTransaccion
			WHERE TarjetaDebID		= Par_NumeroTarjeta;
		END IF;

		-- SI EL MOVIMIENTO ES ABONO, SE REALIZAN LOS CARGOS
		IF(Par_NatMovimiento = Nat_Abono AND Par_TipoOperacion = Tran_ReversoVenta )THEN

			-- Se realiza el update inverso, es decir una reversa
			UPDATE TARJETADEBITO SET
				NoCompraDiario		= IFNULL(NoCompraDiario,Entero_Cero) - 1,
				NoCompraMes			= IFNULL(NoCompraMes, Entero_Cero) - 1,
				MontoCompraDiario	= IFNULL(MontoCompraDiario, Decimal_Cero) - Par_MontoTransaccion,
				MontoCompraMes		= IFNULL(MontoCompraMes, Decimal_Cero) - Par_MontoTransaccion
			WHERE TarjetaDebID = Par_NumeroTarjeta;
		END IF;

		-- CUANDO ES UN REVERSO DE DISPOSICION, SE APLICA EL MOVIMIENTO INVERSO
		IF(Par_TipoOperacion = Tran_ReversoDisposicion)THEN

			-- Se realiza el update de los limites de disposicion de tarjetas
			UPDATE TARJETADEBITO SET
				NoDispoDiario		= IFNULL(NoDispoDiario, Entero_Cero) - 1,
				NoDispoMes			= IFNULL(NoDispoMes, Entero_Cero) - 1,
				MontoDispoDiario	= IFNULL(MontoDispoDiario, Decimal_Cero) - Par_MontoTransaccion,
				MontoDispoMes		= IFNULL(MontoDispoMes, Decimal_Cero) - Par_MontoTransaccion
			WHERE TarjetaDebID = Par_NumeroTarjeta;
		END IF;

		-- SE REALIZA UNA AFECTACION CUANDO EL TIPO DE OPERACION ES UNA REVERSO DE CONSULTA
		IF(Par_TipoOperacion = Tran_ReversoConsulta)THEN

			-- Se realiza la operacion inversa de de consultas
			UPDATE TARJETADEBITO SET
				NoConsultaSaldoMes	= IFNULL(NoConsultaSaldoMes, Entero_Cero) - 1,
				MontoDispoDiario	= IFNULL(MontoDispoDiario, Decimal_Cero) - Par_MontoTransaccion,
				MontoDispoMes		= IFNULL(MontoDispoMes, Decimal_Cero) - Par_MontoTransaccion
			WHERE TarjetaDebID = Par_NumeroTarjeta;
		END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Tarjeta Actualiza Exitosamente.';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$