DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXNIPCONSULTAPRO;
DELIMITER $$

CREATE PROCEDURE ISOTRXNIPCONSULTAPRO(
	-- Descripcion: Proceso operativo que realiza la devolucion y cancelacion de operaciones de isotrx
	-- Modulo: Procesos de ISOTRX
	Par_EmisorID					INT(11),		-- Identificador provisto por ISOTRX
	Par_MensajeID					VARCHAR(50),	-- Identificador del Mensaje. Valor único global.
	Par_TipoOperacion				INT(11),		-- Catalogo CATTIPOPERACIONISOTRX
	Par_ResultadoOperacion			INT(11),		-- Siempre enviarán 1 Aprobada, 0 = Sin Respuesta,1 = Aprobada , 2 = Declinada , 3 = Rechazada
	Par_EstatusOperacion			INT(11),		-- Estatus de operaciòn 0 = Indefinida ,1 = Abierta,2 = Completada ,3 = Devuelta ,5 = Cancelada ,6 = Reversa

	Par_FechaOperacion				DATE,			-- Fecha en formato AAAAMMDD
	Par_HoraOperacion				TIME,			-- Hora en formato HHMMSS
	Par_CodigoRespuesta				VARCHAR(2),		-- Código de respuesta del autorizador, ver catalogo ISOTRXCODRESPUESTA
	Par_CodigoAutorizacion			VARCHAR(6),		-- Código es el que se utilizará para aplicar reversos.
	Par_CodigoRechazo				INT(11),		-- Catalogo ISOTRXCODRECHAZO

	Par_GiroComercial				INT(11),		-- Catalogo ISOTRXCODGIROCOMER
	Par_NumeroAfiliacion			INT(11),		-- Id identificador del comercio
	Par_NombreComercio				VARCHAR(50),	-- Nombre del comercio
	Par_ModoEntrada					INT(11),		-- Catalogo ISOTRXMODOENTRADA
	Par_PuntoAcceso					INT(11),		-- Catalogo ISOTRXPUNTOACCES

	Par_NumeroCuenta				BIGINT(20),		-- Número de Cuenta del Emisor
	Par_NumeroTarjeta				VARCHAR(16),	-- Número de Tarjeta del SAFI
	Par_CodigoMoneda				INT(11),		-- Código de Moneda  484 = MX Pesos,840 = USD Dollar,484 = MX Pesos, 840 = USD Dollar
	Par_MontoTransaccion			DECIMAL(12,2),	-- Monto total de la transacción
	Par_MontoAdicional				DECIMAL(12,2),	-- Monto de disposición en compra

	Par_MontoRemplazo				DECIMAL(12,2),	-- Monto de remplazo por devolución o disposicion parcial
	Par_MontoComision				DECIMAL(12,2),	-- Monto de comisión por disposición
	Par_FechaTransaccion			VARCHAR(4),		-- Fecha en formato MMDD
	Par_HoraTransaccion				VARCHAR(6),		-- Hora en formato HHMMSS
	Par_SaldoDisponible				DECIMAL(12,4),	-- Saldo disponible

	Par_ProDiferimiento				INT(11),		-- Número de meses a diferir el primer pago.
	Par_ProNumeroPagos				INT(11),		-- Número de parcialidades en las que se divide el monto.
	Par_ProTipoPlan					INT(11),		-- Tipo plan 0 = Sin Plan,3 = Sin Intereses ,5 = Con Intereses ,7 = Diferimiento
	Par_OriCodigoAutorizacion		VARCHAR(6),		-- Tomado de la transacción original
	Par_OriFechaTransaccion			DATE,			-- Fecha de la transacción original, formato MMDD

	Par_OriHoraTransaccion			TIME,			-- Hora de la transacción original,  formato HHMMSS
	Par_DesNumeroCuenta				BIGINT(20),		-- Número de cuenta destino de la trasferencia local
	Par_DesNumeroTarjeta			VARCHAR(16),	-- Número de tarjeta destino de la transferencia local
	Par_TrsClaveRastreo				VARCHAR(30),	-- Clave de rastreo de la transferencia
	Par_TrsInstitucionRemitente		INT(11),		-- Clave de la institución desde donde se envía la transferencia

	Par_TrsNombreEmisor				VARCHAR(50),	-- Nombre de quien envía la transferencia
	Par_TrsTipoCuentaRemitente		INT(11),		-- Tipo de Cuenta de quien envía la transferencia
	Par_TrsCuentaRemitente			VARCHAR(16),	-- Numero de cuenta de quien envía la transferencia
	Par_TrsConceptoPago				VARCHAR(50),	-- Concepto de la transferencia
	Par_TrsReferenciaNumerica		INT(11),		-- Referencia numérica asociada a la transferencia

	INOUT Par_Poliza				BIGINT(20),		-- Numero de poliza para registrar los detalles contables

	Par_Salida						CHAR(1),		-- Especifica salida o no del sp: Si:'S' y No:'N'
	INOUT Par_NumErr				INT(11),		-- Numero de error
	INOUT Par_ErrMen				VARCHAR(400),	-- Mensaje de error descripctivo

	Par_EmpresaID					INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario						INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual					DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP					VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID					VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal					INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion				BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);	-- Variable de control
	DECLARE Var_ClienteID			INT(11);		-- Identificador del cliente
	DECLARE Var_CuentaAhoID			BIGINT(12);		-- Numero de la cuenta de ahorro
	DECLARE Var_MonedaID			INT(11);		-- Moneda id de la cuenta
	DECLARE Var_FechaSistema		DATE;			-- Fecha del sistema
	DECLARE Var_DescripcionReversa	VARCHAR(250);	-- Descripcion de la operacion para la reversa
	DECLARE Var_Descripcion			VARCHAR(250);	-- Descripcion de la operacion
	DECLARE Var_CodigoAutorizacion	BIGINT(20);		-- Codigo de la operacion original
	DECLARE Var_FechaOperacion		DATE;			-- Fecha de la operacion original
	DECLARE Var_HoraOperacion		DATETIME;		-- Hora de la operacion original
	DECLARE Var_MontoTransaccion	DECIMAL(12,4);	-- Variable para almacenar el monto de la operacion
	DECLARE Var_SaldoDisponible		DECIMAL(12,2);	-- Variable para almacenar el saldo disponible de la cuenta
	DECLARE Var_SucursalCliente		INT(11);		-- Sucursal del cliente
	DECLARE Var_IVA					DECIMAL(12,2);	-- porcentaje del iva a calcular
	DECLARE Var_DesOperacion		VARCHAR(250);	-- Descripcion de la operacion
	DECLARE Var_DescripcionIVA		VARCHAR(250);	-- Descripcion de la operacion de la comision del iva
	DECLARE Var_MontoIVAComision	DECIMAL(12,2);	-- Variable para almacenar el monto del iva de la comision
	DECLARE Var_ClientePagaIVA		CHAR(1);		-- Variable para almacenar si el cliente cobra iva

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;			-- Fecha vacia
	DECLARE Entero_Cero				INT(11);		-- Entero cero
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Decimal cero
	DECLARE SalidaSI				CHAR(1); 		-- Salida SI
	DECLARE SalidaNO				CHAR(1); 		-- Salida NO
	DECLARE Con_SI					CHAR(1); 		-- Constante SI
	DECLARE Con_NO					CHAR(1); 		-- Constante NO
	DECLARE Mov_Pasivo				INT(11);		-- Movimento contable pasivo
	DECLARE Mov_CompraDebito		INT(11);		-- Movimiento de la cuenta de ahorro
	DECLARE Tar_OperaPos			INT(11);		-- Movimiento contable de la tarjeta
	DECLARE Conta_tarjeta			INT(11);		-- Contable de tarjeta
	DECLARE Var_EncabezadoNo		CHAR(1); 		-- Alta de encabezado
	DECLARE Var_AltaMovAhoSI		CHAR(1); 		-- Alta de movimiento de ahorro
	DECLARE Var_AltaPolTarSI		CHAR(1); 		-- Alta de movimiento de tarjeta
	DECLARE Nat_Cargo				CHAR(1);		-- Naturaleza cargos
	DECLARE Nat_Abono				CHAR(1);		-- Naturaleza abobos
	DECLARE Entero_Cien				INT(11);		-- Entero cien
	DECLARE Mov_ComisionAhoTD		INT(11);		-- COMISION CONSULTA SALDO CON TD
	DECLARE Mov_IVAComisionAhoTD	INT(11);		-- IVA COMISION CONSULTA SALDO CON TD
	DECLARE Tar_OperacionATM		INT(11);		-- Movimiento por consultas de ATM

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
	SET Mov_Pasivo 					:= 1;
	SET Mov_CompraDebito			:= 17;
	SET Tar_OperaPos				:= 2;
	SET Conta_tarjeta				:= 300;
	SET Var_EncabezadoNo			:= 'N';
	SET Var_AltaMovAhoSI			:= 'S';
	SET Var_AltaPolTarSI			:= 'S';
	SET Nat_Cargo					:= 'C';
	SET Nat_Abono					:= 'A';
	SET Entero_Cien					:= 100;
	SET Mov_ComisionAhoTD			:= 86;
	SET Mov_IVAComisionAhoTD		:= 88;
	SET Tar_OperacionATM			:= 1;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXNIPCONSULTAPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		-- Fecha del sistema
		SELECT 	FechaSistema,		MonedaBaseID
		INTO	Var_FechaSistema,	Var_MonedaID
		FROM PARAMETROSSIS;

		-- Validacion de datos nulos
		SET Par_NumeroTarjeta			:= IFNULL(Par_NumeroTarjeta, Cadena_Vacia);
		SET Par_TipoOperacion			:= IFNULL(Par_TipoOperacion, Entero_Cero);
		SET Par_MontoRemplazo			:= IFNULL(Par_MontoRemplazo, Decimal_Cero);
		SET Par_OriCodigoAutorizacion	:= IFNULL(Par_OriCodigoAutorizacion, Cadena_Vacia);
		SET Par_MontoTransaccion		:= IFNULL(Par_MontoTransaccion, Decimal_Cero);
		SET Par_MontoComision			:= IFNULL(Par_MontoComision, Decimal_Cero);

		-- Se hace el cargo cuando monto comision sea mayor a cero
		IF(Par_MontoComision > Decimal_Cero)THEN
			-- Se invoca el proceso que valida la tarjeta
			CALL ISOTRXTARJETADEBVAL(
					Par_TipoOperacion,	Par_NumeroTarjeta,		Var_ClienteID,		Var_CuentaAhoID,	Nat_Cargo,
					Par_MontoComision,	Par_MontoAdicional,		Par_GiroComercial,
					SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				);
			-- Se evalua el error
			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Se consulta el saldo actual del cliente
			SELECT	SaldoDispon
			INTO	Var_SaldoDisponible
			FROM CUENTASAHO
			WHERE CuentaAhoID = Var_CuentaAhoID;

			SET Var_SaldoDisponible := IFNULL(Var_SaldoDisponible, Decimal_Cero);
			-- El monto de la comision no puede ser mayor al saldo disponible
			IF(Par_MontoComision > Var_SaldoDisponible)THEN
				SET Par_NumErr	:= 1010;
				SET Par_ErrMen	:= 'El Monto de la Comision es mayor al saldo disponible de la cuenta.';
				SET Var_Control	:= 'montoComision';
				LEAVE ManejoErrores;
			END IF;

			-- Se obtiene la descripcipcion por tipo de operacion
			SELECT	Descripcion
			INTO	Var_DesOperacion
			FROM CATTIPOPERACIONISOTRX
			WHERE CodigoOperacion = Par_TipoOperacion;

			-- Validacion de datos nulos
			SET Var_DesOperacion := IFNULL(Var_DesOperacion, Cadena_Vacia);
			-- CONCADENACION DE LA DESCRIPCION DE LA OPERACION PARA LAS OPERACIONES CONTABLES
			SET Var_Descripcion := LEFT(CONCAT(Var_DesOperacion," ",Par_NombreComercio),Entero_Cien);

			-- DESCRIPCION PARA EL IVA DE LA COMISION
			SET Var_DescripcionIVA := LEFT(CONCAT("IVA COMISION ",Var_DesOperacion," ",Par_NombreComercio),Entero_Cien);

			-- Se obtiene la sucursal del cliente
			SELECT	SucursalOrigen,			PagaIVA
			INTO	Var_SucursalCliente,	Var_ClientePagaIVA
			FROM CLIENTES
			WHERE ClienteID = Var_ClienteID;
			-- validacion de datos nulos
			SET Var_SucursalCliente		:= IFNULL(Var_SucursalCliente, Entero_Cero);
			SET Var_ClientePagaIVA		:= IFNULL(Var_ClientePagaIVA, Con_NO);
			SET Var_MontoIVAComision	:= Decimal_Cero;

			-- CUANDO EL CLIENTE PAGA IVA
			IF(Var_ClientePagaIVA = Con_SI)THEN
				SELECT	IVA
				INTO	Var_IVA
				FROM SUCURSALES
				WHERE SucursalID = Var_SucursalCliente;
				-- validacion de datos nulos
				SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);

				SET Var_MontoIVAComision	:= ROUND(Par_MontoComision * Var_IVA, 2);
			END IF;

			SET Par_MontoComision := (Par_MontoComision - Var_MontoIVAComision);

			-- Se realiza abono por el monto de la transaccion original
			CALL ISOTRXCONTAPRO(
					Var_CuentaAhoID,		Var_ClienteID,				Aud_NumTransaccion,			Var_FechaSistema,		Var_FechaSistema,
					Par_MontoComision,		Var_Descripcion,			Par_CodigoAutorizacion,		Mov_ComisionAhoTD,		Var_MonedaID,
					Mov_Pasivo	,			Tar_OperacionATM,			Conta_tarjeta,				Par_NumeroTarjeta,		Var_EncabezadoNo,
					Var_AltaMovAhoSI,		Var_AltaPolTarSI,			Nat_Cargo,					Par_Poliza,				SalidaNO,
					Par_NumErr,				Par_ErrMen,					Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion
				);
			-- Se evalua el error
			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- CUANDO SE COBRA EL IVA
			IF(Var_MontoIVAComision > Decimal_Cero)THEN
				-- Se realiza abono por el monto del iva de la comision
				CALL ISOTRXCONTAPRO(
						Var_CuentaAhoID,		Var_ClienteID,				Aud_NumTransaccion,			Var_FechaSistema,		Var_FechaSistema,
						Var_MontoIVAComision,	Var_DescripcionIVA,			Par_CodigoAutorizacion,		Mov_IVAComisionAhoTD,	Var_MonedaID,
						Mov_Pasivo	,			Tar_OperacionATM,			Conta_tarjeta,				Par_NumeroTarjeta,		Var_EncabezadoNo,
						Var_AltaMovAhoSI,		Var_AltaPolTarSI,			Nat_Cargo,					Par_Poliza,				SalidaNO,
						Par_NumErr,				Par_ErrMen,					Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion
					);
				-- Se evalua el error
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Operacion Realizada Exitosamente.';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$