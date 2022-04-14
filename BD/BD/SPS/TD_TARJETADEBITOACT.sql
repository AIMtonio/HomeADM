-- TD_TARJETADEBITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_TARJETADEBITOACT`;

DELIMITER $$
CREATE PROCEDURE `TD_TARJETADEBITOACT`(
	-- Store Procedure que Actualiza campos de las Tarjetas de Debito
	Par_TarjetaDebitoID	CHAR(16),		-- Numero de Tarjeta de Debito
	Par_MontoOperacion		DECIMAL(12,2),	-- Monto en pesos de la transaccion
	Par_NatMovimiento		CHAR(1),		-- Naturaleza de la Operacion

	Par_NumActualizacion	TINYINT UNSIGNED,-- Numero de Operacion

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	DECLARE Var_TarjetaDebitoID		CHAR(16);		-- Numero de Tarjeta de Debito
	DECLARE Var_Control				VARCHAR(100);	-- Control de Retorno en Pantalla
	DECLARE Mov_Cantidad 			DECIMAL(12,2);	-- Monto en pesos de la transaccion
	DECLARE Num_Movimientos			INT(11);		-- Numero de Movimientos

	DECLARE Var_NumConsultaMes		INT(11);		-- Numero de Consulta configurados por Tarjeta
	DECLARE Var_NoConsultaSaldoMes	INT(11);		-- Numero de Consulta de la Tarjeta

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);	-- Constante Cadena Vacia
	DECLARE Salida_SI				CHAR(1);	-- Constante Salida NO
	DECLARE Estatus_Pro				CHAR(1);	-- Constante Estatus Procesado
	DECLARE Nat_Cargo				CHAR(1);	-- Constante Naturaleza Cargo
	DECLARE Nat_Abono				CHAR(1);	-- Constante Naturaleza Abono

	DECLARE Entero_Cero				INT(11);	-- Constante Entero Cero
	DECLARE Entero_Uno				INT(11);	-- Constante Entero Uno

	-- Declaracion de Actualizaciones
	DECLARE Act_MovCompra			INT(11);	-- Constante Movimiento Compra POS
	DECLARE Act_MovRetiro			INT(11);	-- Constante Movimiento Retro ATM
	DECLARE Act_MovConsulta			INT(11);	-- Constante Movimiento Consulta ATM

	-- Declaracion de Operaciones
	DECLARE Con_OpeConsulta			INT(11);	-- Consulta para obtener Numero de Consultas de Saldo al Mes

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Salida_SI			:= 'S';
	SET Estatus_Pro			:= 'P';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';

	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;

	-- Asignacion de Actualizaciones
	SET Act_MovCompra		:= 1;
	SET Act_MovRetiro		:= 2;
	SET Act_MovConsulta		:= 3;

	-- Asignacion de Operaciones
	SET Con_OpeConsulta		:= 1;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-TD_TARJETADEBITOACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Par_TarjetaDebitoID := IFNULL(Par_TarjetaDebitoID, Entero_Cero);
		SET Par_MontoOperacion 	 := IFNULL(Par_MontoOperacion, Entero_Cero);
		SET Par_NatMovimiento 	 := IFNULL(Par_NatMovimiento, Cadena_Vacia);
		SET Par_NumActualizacion := IFNULL(Par_NumActualizacion, Entero_Cero);

		IF( Par_TarjetaDebitoID = Entero_Cero) THEN
			SET Par_NumErr:= 1401;
			SET Par_ErrMen:= 'El Numero de Tarjeta de Debito esta Vacio';
			SET Var_Control	:= 'tarjetaDebID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	TarjetaDebID
		INTO 	Var_TarjetaDebitoID
		FROM TARJETADEBITO
		WHERE TarjetaDebID = Par_TarjetaDebitoID;

		SET Var_TarjetaDebitoID := IFNULL(Var_TarjetaDebitoID, Entero_Cero);

		IF( Var_TarjetaDebitoID = Entero_Cero) THEN
			SET Par_NumErr:= 1402;
			SET Par_ErrMen:= CONCAT('El Numero de Tarjeta de Debito:', Par_TarjetaDebitoID,' No Existe');
			SET Var_Control	:= 'tarjetaDebID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumActualizacion NOT IN (Act_MovConsulta) ) THEN
			IF( Par_MontoOperacion <= Entero_Cero ) THEN
				SET Par_NumErr	:= 1303;
				SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
				SET Var_Control	:= 'montoOperacion';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_NatMovimiento = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 1204;
				SET Par_ErrMen	:= 'La Naturaleza de la Operacion esta Vacia.';
				SET Var_Control	:= 'naturaleza';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_NatMovimiento NOT IN (Nat_Cargo,Nat_Abono) ) THEN
				SET Par_NumErr	:= 1204;
				SET Par_ErrMen	:= 'La Naturaleza de la Operacion No es Valida.';
				SET Var_Control	:= 'naturaleza';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF( Par_NumActualizacion = Entero_Cero ) THEN
			SET Par_NumErr	:= 1205;
			SET Par_ErrMen	:= 'El Numero de Actualizacion esta Vacio.';
			SET Var_Control	:= 'numActualizacion';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumActualizacion NOT IN (Act_MovCompra, Act_MovRetiro, Act_MovConsulta) ) THEN
			SET Par_NumErr	:= 1206;
			SET Par_ErrMen	:= 'El Numero de Actualizacion No es Valido.';
			SET Var_Control	:= 'numActualizacion';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumActualizacion = Act_MovCompra ) THEN

			SET Mov_Cantidad	:= Par_MontoOperacion;
			SET Num_Movimientos := Entero_Uno;

			IF( Par_NatMovimiento = Nat_Abono ) THEN
				SET Mov_Cantidad 	:= Mov_Cantidad * - Entero_Uno;
				SET Num_Movimientos := Num_Movimientos * - Entero_Uno;
			END IF;

			-- Actualiza Numero de Compras por Dia, por Mes, y Montos de Compra por Dia y Mes
			UPDATE TARJETADEBITO SET
				NoCompraDiario		= IFNULL(NoCompraDiario,Entero_Cero) + Num_Movimientos,
				NoCompraMes			= IFNULL(NoCompraMes, Entero_Cero) + Num_Movimientos,
				MontoCompraDiario	= IFNULL(MontoCompraDiario, Entero_Cero) + Mov_Cantidad,
				MontoCompraMes		= IFNULL(MontoCompraMes, Entero_Cero) + Mov_Cantidad,
				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE TarjetaDebID = Par_TarjetaDebitoID;

			SET Par_NumErr:= Entero_Cero;
			SET Par_ErrMen:= CONCAT('Actualizacion de Tarjeta de Debito: ',Par_TarjetaDebitoID,' Exitoso');
			LEAVE ManejoErrores;
		END IF;


		IF( Par_NumActualizacion = Act_MovRetiro ) THEN

			SET Mov_Cantidad	:= Par_MontoOperacion;
			SET Num_Movimientos := Entero_Uno;

			IF( Par_NatMovimiento = Nat_Abono ) THEN
				SET Mov_Cantidad 	:= Mov_Cantidad * - Entero_Uno;
				SET Num_Movimientos := Num_Movimientos * - Entero_Uno;
			END IF;

			-- Actualiza Numero de Disposiciones por Dia, por Mes, y Montos de Disposicion por Dia y Mes
			UPDATE TARJETADEBITO SET
				NoDispoDiario		= IFNULL(NoDispoDiario,Entero_Cero) + Num_Movimientos,
				NoDispoMes			= IFNULL(NoDispoMes, Entero_Cero) + Num_Movimientos,
				MontoDispoDiario	= IFNULL(MontoDispoDiario, Entero_Cero) + Mov_Cantidad,
				MontoDispoMes		= IFNULL(MontoDispoMes, Entero_Cero) + Mov_Cantidad,
				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE TarjetaDebID = Par_TarjetaDebitoID;

			SET Par_NumErr:= Entero_Cero;
			SET Par_ErrMen:= CONCAT('Actualizacion de Tarjeta de Debito: ',Par_TarjetaDebitoID,' Exitoso');
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumActualizacion = Act_MovConsulta ) THEN

			IF( Par_NatMovimiento = Nat_Cargo ) THEN

				SELECT	NoConsultaSaldoMes,
						IFNULL(TD_FNNUMCONSULTAS(Tar.TarjetaDebID, Tar.ClienteID, Tar.TipoTarjetaDebID, Con_OpeConsulta), Entero_Cero)
				INTO 	Var_NoConsultaSaldoMes,	Var_NumConsultaMes
				FROM  TARJETADEBITO Tar
				WHERE TarjetaDebID = Par_TarjetaDebitoID;

				SET Var_NumConsultaMes := IFNULL(Var_NumConsultaMes, Entero_Cero);
				SET Var_NoConsultaSaldoMes := IFNULL(Var_NoConsultaSaldoMes, Entero_Cero);

				IF( Var_NumConsultaMes > Entero_Cero AND (Var_NoConsultaSaldoMes + Entero_Uno) > Var_NumConsultaMes ) THEN
					SET Par_NumErr	:= 1207;
					SET Par_ErrMen	:= CONCAT('La Tarjeta: ',Par_TarjetaDebitoID,' alcanzo el Numero de Consultas Permitidas.');
					SET Var_Control	:= 'numActualizacion';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Num_Movimientos := Entero_Uno;

			IF( Par_NatMovimiento = Nat_Abono ) THEN
				SET Num_Movimientos := Num_Movimientos * - Entero_Uno;
			END IF;

			-- Actualiza Numero de Consulta por Dia y Mes
			UPDATE TARJETADEBITO SET
				NoConsultaSaldoMes	= IFNULL(NoConsultaSaldoMes,Entero_Cero) + Num_Movimientos,
				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE TarjetaDebID = Par_TarjetaDebitoID;

			SET Par_NumErr:= Entero_Cero;
			SET Par_ErrMen:= CONCAT('Actualizacion de Tarjeta de Debito: ',Par_TarjetaDebitoID,' Exitoso');
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$
