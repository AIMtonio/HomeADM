DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTARJETADEBGIROVAL;
DELIMITER $$

CREATE PROCEDURE ISOTRXTARJETADEBGIROVAL(
	-- Descripcion: Proceso que realiza la validacion de las tarjetas el monto y giro permitidos
	-- Modulo: Procesos de ISOTRX
	Par_NumeroTarjeta		VARCHAR(16),		-- Numero de tarjeta
	Par_MontoTransaccion	DECIMAL(12,2),		-- Monto de la transaccion
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
	DECLARE Var_CuentaAhoID 		BIGINT(12);		-- Cuenta de ahorro
	DECLARE Var_ClienteID   		INT(11);		-- Numero de lciente
	DECLARE Var_SaldoDisp   		DECIMAL(12,2);	-- Saldo disponible
	DECLARE Var_SaldoDispoAct  		DECIMAL(12,2);	-- Saldo disponible actual
	DECLARE Var_SaldoContable		DECIMAL(12,2);	-- Saldo contable
	DECLARE Var_TipoTarjetaDeb 		INT(11);		-- Tipo de tarjeta
	DECLARE Val_Giro           		CHAR(4);		-- Variable de giro
	DECLARE Var_BloqueID       		INT(11);		-- Bloque
	DECLARE Var_BloqPOS        		VARCHAR(5);		-- Bloqueo pos
	DECLARE Var_MontoCompLibre		DECIMAL(12,2);	-- Monto compra libre
	DECLARE Var_MontoCompraMes		DECIMAL(12,2);	-- Monto compra al mes
	DECLARE Var_LimiteCompraMes		DECIMAL(12,2);	-- Limite de compra
	DECLARE Var_MontoCompraDiario   DECIMAL(12,2);	-- monto compra diario
	DECLARE Var_LimiteCompraDiario  DECIMAL(12,2);	-- limite de compra diario
	DECLARE Var_NatMovimiento       CHAR(1);		-- naturaleza del movimiento
	DECLARE Var_TipoBloqID          INT(11);		-- tipo de bloqueo
	DECLARE Var_Continuar			INT(11);		-- variable continuar
	DECLARE Var_GiroComercial		VARCHAR(4);		-- Giro comercial

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    		CHAR(1);		-- cadena vacia
	DECLARE Entero_Cero     		INT(11);		-- entero cero
	DECLARE Salida_NO       		CHAR(1);		-- salida no
	DECLARE Salida_SI       		CHAR(1);		-- salida si
	DECLARE Decimal_Cero    		DECIMAL(12,2);	-- decimal cero
	DECLARE CompraEnLineaSI 		CHAR(1);		-- compra linea si
	DECLARE CompraEnLineaNO 		CHAR(1);		-- compra line no
	DECLARE Error_Key               INT(11);		-- error de key
	DECLARE BloqPOS_SI              CHAR(1);		-- bloqueo pos si
	DECLARE Fecha_Vacia				DATE;			-- fecha vacia
	DECLARE Est_Registrado			CHAR(1);		-- estatus registrado
	DECLARE Con_BloqPOS         	INT(11);		-- bloqueo pos
	DECLARE Con_CompraDiario    	INT(11);		-- compra diario
	DECLARE Con_DispoDiario     	INT(11);		-- disponible diario
	DECLARE Con_CompraMes       	INT(11);		-- compra por mes
	DECLARE Con_DispoMes        	INT(11);		-- disponible al mes
	DECLARE Cadena_Cero				CHAR(4);		-- constante de cero cadena

	-- Asignacion de constantes
	SET Con_BloqPOS     			:= 2;
	SET Con_CompraDiario			:= 3;
	SET Con_DispoDiario 			:= 1;
	SET Con_CompraMes   			:= 4;
	SET Con_DispoMes    			:= 2;
	SET Cadena_Vacia    			:= '';
	SET Entero_Cero     			:= 0;
	SET Salida_NO       			:= 'N';
	SET Salida_SI       			:= 'S';
	SET Decimal_Cero    			:= 0.00;
	SET CompraEnLineaSI 			:= 'S';
	SET Error_Key       			:= Entero_Cero;
	SET BloqPOS_SI      			:= 'S';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Var_Continuar 				:= Entero_Cero;
	SET Cadena_Cero					:= '0';
	SET Aud_FechaActual				:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXTARJETADEBGIROVAL');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SELECT	CuentaAhoID,	TipoTarjetaDebID,
				FUNCIONLIMITEBLOQ(tar.TarjetaDebID, tar.ClienteID, tar.TipoTarjetaDebID, Con_BloqPOS),
				tar.MontoCompraDiario,
				FUNCIONLIMITEMONTO(tar.TarjetaDebID, tar.ClienteID, tar.TipoTarjetaDebID, Con_CompraDiario),
				tar.MontoCompraMes,
				FUNCIONLIMITEMONTO(tar.TarjetaDebID, tar.ClienteID, tar.TipoTarjetaDebID, Con_CompraMes)
		INTO	Var_CuentaAhoID,		Var_TipoTarjetaDeb,
				Var_BloqPOS,			Var_MontoCompraDiario,		Var_LimiteCompraDiario,
				Var_MontoCompraMes,		Var_LimiteCompraMes
		FROM TARJETADEBITO tar
		WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

		SELECT	ClienteID
		INTO	Var_ClienteID
		FROM CUENTASAHO
		WHERE CuentaAhoID = Var_CuentaAhoID;

		-- VALIDACION DE DATOS NULO
		SET Par_MontoAdicional	:= IFNULL(Par_MontoAdicional, Decimal_Cero);
		SET Var_CuentaAhoID		:= IFNULL(Var_CuentaAhoID, Entero_Cero);
		SET Var_ClienteID		:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Par_GiroComercial	:= IFNULL(Par_GiroComercial, Entero_Cero);
		SET Var_GiroComercial	:= LEFT(LPAD(Par_GiroComercial,4,Entero_Cero),4);

		SET Val_Giro := (SELECT FUNCIONGIRO (Par_NumeroTarjeta, Var_ClienteID, Var_TipoTarjetaDeb, Var_GiroComercial));

		IF ( Val_Giro = Cadena_Cero ) THEN

			IF (Var_LimiteCompraDiario = Decimal_Cero) THEN
				SET Var_Continuar := Entero_Cero;
			ELSE
				IF (Var_MontoCompraDiario < Var_LimiteCompraDiario) THEN
					SET Var_MontoCompLibre = Var_LimiteCompraDiario - Var_MontoCompraDiario ;
					IF (Par_MontoTransaccion <= Var_MontoCompLibre) THEN
						SET Var_Continuar := Entero_Cero;
					ELSE
						SET Par_NumErr	:= 0008;
						SET Par_ErrMen	:= 'Limite Monto de Compra diario de la Tarjeta Excedido.';
						SET Var_Control	:= 'numeroTarjeta';
						LEAVE ManejoErrores;
					END IF;
				ELSE
					SET Par_NumErr	:= 0008;
					SET Par_ErrMen	:= 'Limite de compras diario de la tarjeta Excedido.';
					SET Var_Control	:= 'numeroTarjeta';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Var_LimiteCompraMes = Decimal_Cero) THEN
				SET Var_Continuar := Entero_Cero;
			ELSE
				IF (Var_MontoCompraMes < Var_LimiteCompraMes) THEN
					SET Var_MontoCompLibre := Var_LimiteCompraMes - Var_MontoCompraMes;
					IF (Par_MontoTransaccion <= Var_MontoCompLibre) THEN
						SET Var_Continuar := Entero_Cero;
					ELSE
						SET Par_NumErr	:= 0008;
						SET Par_ErrMen	:= 'Limite Monto de Compra por Mes Excedido.';
						SET Var_Control	:= 'numeroTarjeta';
						LEAVE ManejoErrores;
					END IF;
				ELSE
					SET Par_NumErr	:= 0008;
					SET Par_ErrMen	:= 'Limite de Compras por Mes Excedido.';
					SET Var_Control	:= 'numeroTarjeta';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF ( Var_Continuar = Entero_Cero) THEN
				IF (IFNULL(Par_MontoTransaccion, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr	:= 1110;
					SET Par_ErrMen	:= 'Error en el Monto de Transaccion';
					SET Var_Control	:= 'montoTransaccion';
					LEAVE ManejoErrores;
				END IF;

				IF (Par_MontoTransaccion = Decimal_Cero )THEN

					SET Par_NumErr	:= 1110;
					SET Par_ErrMen	:= 'Error en el Monto de Transaccion';
					SET Var_Control	:= 'montoTransaccion';
					LEAVE ManejoErrores;
				END IF;

				IF (Par_MontoAdicional >=  Par_MontoTransaccion) THEN
					SET Par_NumErr	:= 1110;
					SET Par_ErrMen	:= 'Error en el Monto de Transaccion';
					SET Var_Control	:= 'montoTransaccion';
					LEAVE ManejoErrores;
				END IF;

				SELECT IFNULL(SaldoDispon, Decimal_Cero)
				INTO	Var_SaldoDisp
				FROM CUENTASAHO
				WHERE CuentaAhoID = Var_CuentaAhoID;

				IF (Var_SaldoDisp = Decimal_Cero ) THEN
					SET Par_NumErr	:= 0003;
					SET Par_ErrMen	:= 'Saldo Insuficiente de la Cuenta de Ahorro';
					SET Var_Control	:= 'cuentaAhoID';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_SaldoDisp < Par_MontoTransaccion ) THEN
					SET Par_NumErr	:= 0003;
					SET Par_ErrMen	:= 'El Saldo disponible de la cuenta es Menor al Monto de la Transaccion';
					SET Var_Control	:= 'cuentaAhoID';
					LEAVE ManejoErrores;
				ELSE

					IF( Var_SaldoDisp - Par_MontoTransaccion < Entero_Cero) THEN
						SET Par_NumErr	:= 0003;
						SET Par_ErrMen	:= 'Saldo Insuficiente de la cuenta de Ahorro';
						SET Var_Control	:= 'cuentaAhoID';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;
			IF (Error_Key = Entero_Cero) THEN
				SET Par_NumErr	:= 000;
				SET Var_Control	:= 'numeroTarjeta';
				SET Par_ErrMen	:= 'Tarjeta Valida Exitosamente.';
				LEAVE ManejoErrores;
			ELSE
				SET Par_NumErr	:= 1118;
				SET Par_ErrMen	:= 'Ocurrio un error a validar la Tarjeta';
				SET Var_Control	:= 'numeroTarjeta';
			END IF;
		ELSE
			SET Par_NumErr	:= 0007;
			SET Par_ErrMen	:= 'Giro Comercial No Permitido';
			SET Var_Control	:= 'numeroTarjeta';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= 'Tarjeta Valida Exitosamente.';

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$