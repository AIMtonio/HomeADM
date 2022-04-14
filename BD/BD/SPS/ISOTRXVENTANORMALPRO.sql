DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXVENTANORMALPRO;
DELIMITER $$

CREATE PROCEDURE ISOTRXVENTANORMALPRO(
	-- Descripcion: Proceso operativo que realiza la afectacion cuando la transacion sea de tipo venta normal
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
	DECLARE Var_Descripcion			VARCHAR(250);	-- Descripcion de la operacion
	DECLARE Var_DescripcionRetiro	VARCHAR(250);	-- Descripcion de la operacion por retiro
	DECLARE Var_DesOperacion		VARCHAR(250);	-- Descripcion de la operacion

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

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXVENTANORMALPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		-- Fecha del sistema
		SELECT 	FechaSistema,		MonedaBaseID
		INTO	Var_FechaSistema,	Var_MonedaID
		FROM PARAMETROSSIS;

		-- Validacion de datos nulos
		SET Par_NumeroTarjeta	:= IFNULL(Par_NumeroTarjeta, Cadena_Vacia);
		SET Par_TipoOperacion	:= IFNULL(Par_TipoOperacion, Entero_Cero);
		SET Par_MontoAdicional	:= IFNULL(Par_MontoAdicional, Decimal_Cero);
		SET Par_NombreComercio	:= IFNULL(Par_NombreComercio, Cadena_Vacia);

		-- Se invoca el proceso que valida la tarjeta
		CALL ISOTRXTARJETADEBVAL(
				Par_TipoOperacion,		Par_NumeroTarjeta,		Var_ClienteID,		Var_CuentaAhoID,	Nat_Cargo,
				Par_MontoTransaccion,	Par_MontoAdicional,		Par_GiroComercial,
				SalidaNO,				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);
		-- Se evalua el error
		IF(Par_NumErr <> Entero_Cero)THEN
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

		-- Cuando el monto adicional sea mayor a cero, se le debe restar
		IF(Par_MontoAdicional > Decimal_Cero)THEN
			SET Par_MontoTransaccion := (Par_MontoTransaccion - Par_MontoAdicional);
		END IF;

		-- CARGO A LA CUENTA DE AHORRO , ABONO A LA CUENTA DE "Operaciones POS" de Tarjetas
		CALL ISOTRXCONTAPRO(
				Var_CuentaAhoID,		Var_ClienteID,			Aud_NumTransaccion,			Var_FechaSistema,		Var_FechaSistema,
				Par_MontoTransaccion,	Var_Descripcion,		Par_CodigoAutorizacion,		Mov_CompraDebito,		Var_MonedaID,
				Mov_Pasivo	,			Tar_OperaPos,			Conta_tarjeta,				Par_NumeroTarjeta,		Var_EncabezadoNo,
				Var_AltaMovAhoSI,		Var_AltaPolTarSI,		Nat_Cargo,					Par_Poliza,				SalidaNO,
				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
			);
		-- Se evalua el error
		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- SE REALIZA UN NUEVO CARGO POR EL MONTO ADICIONAL, ESTO PARA LOS RETIROS DE EFECTIVO
		IF(Par_MontoAdicional > Decimal_Cero)THEN

			SET Var_DescripcionRetiro := LEFT(CONCAT("RETIRO ",Var_DesOperacion," ",Par_NombreComercio),Entero_Cien);
			-- CARGO A LA CUENTA DE AHORRO , ABONO A LA CUENTA DE "Operaciones POS" de Tarjetas
			CALL ISOTRXCONTAPRO(
					Var_CuentaAhoID,		Var_ClienteID,			Aud_NumTransaccion,			Var_FechaSistema,		Var_FechaSistema,
					Par_MontoAdicional,		Var_DescripcionRetiro,	Par_CodigoAutorizacion,		Mov_CompraDebito,		Var_MonedaID,
					Mov_Pasivo	,			Tar_OperaPos,			Conta_tarjeta,				Par_NumeroTarjeta,		Var_EncabezadoNo,
					Var_AltaMovAhoSI,		Var_AltaPolTarSI,		Nat_Cargo,					Par_Poliza,				SalidaNO,
					Par_NumErr,				Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
				);
			-- Se evalua el error
			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
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