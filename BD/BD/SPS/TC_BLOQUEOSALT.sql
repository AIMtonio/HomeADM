-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BLOQUEOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_BLOQUEOSALT`;

DELIMITER $$
CREATE PROCEDURE `TC_BLOQUEOSALT`(
	-- SP para el bloqueo automatico de saldo de una tarjeta de credito
	-- Modulo Tarjetas Credito --> Registro
	Par_BloqueoID			INT(11), 		-- Requerido solo si se trata de un desbloqueo.
	Par_NatMovimiento		CHAR(1),		-- "B" indica un Bloqueo  / "D" indica un desbloqueo
	Par_TarjetaCreditoID	BIGINT(12),		-- Indica la cuenta de ahorro de la que se hara el movimiento
	Par_FechaMovimiento		DATE,			-- fecha en que hace el movimiento
	Par_MontoBloqueo		DECIMAL(12,2),	-- Cantidad del movimiento

	Par_FechaDesbloqueo		DATETIME,		-- Requerido solo si se trata de un desbloqueo
	Par_TiposBloqID			INT,			-- Corresponde con la tabla TIPOSBLOQUEOS
	Par_Descripcion			VARCHAR(150),	-- Indica la descripcion del bloqueo
	Par_Referencia			CHAR(12),		-- Referencia del bloqueo
	Par_TerminalID			CHAR(16),		-- ID de la terminal - TPV o ATM(limitado a 16 caracteres. ISO8583 - DE37 (PROSA))

	Par_NombreTerminal		CHAR(50),		-- Nombre del comercio donde se realizo la operacion(limitado a 50 caracteres.  ISO8583 - DE43.1 (PROSA))
	Par_LocacionTerminal	CHAR(50),		-- Datos de la localidad de la terminal(limitado a 50 caracteres.  ISO8583 - DE43.2 (PROSA))
	Par_NumAutorizacionAct	CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.)
	Par_NumAutorizacionAnt	CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.)

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- declaracion de variables
	DECLARE Var_Estatus				CHAR(1);		-- Estatus de Linea de Credito
	DECLARE Var_TarjetaCreditoID	CHAR(16);		-- Numero de Tarjeta de Credito
	DECLARE Var_FechaHora			CHAR(20);		-- Fecha con Hora
	DECLARE Var_BloqueoID			INT(11);		-- Numero de Bloqueo
	DECLARE Var_NumBloqueoID		INT(11);		-- Numero de Bloqueo

	DECLARE Var_FolioBloq			INT(11);		-- Folio de Bloque
	DECLARE Var_TiposBloq			INT(11);		-- Tipo de Bloqueo
	DECLARE Var_UsuarioID			INT(11);		-- Numero de Usuario
	DECLARE Var_TipoBloqOrig		INT(11);		-- Tipo de Bloqueo Original
	DECLARE Var_LineaTarCredID		INT(11);		-- Linea de Tarjeta de Credito

	DECLARE Var_EstatusTarjeta		INT(11);		-- Estatus de la Tarjeta corresponde con tabla ESTATUSTD
	DECLARE Var_Fecha				DATE;			-- Fecha de Operacion
	DECLARE Var_FechaMovimiento		DATETIME;		-- Fecha de Movimiento
	DECLARE Var_MontoBloqueado		DECIMAL(12,2);	-- Monto de Bloqueo
	DECLARE Var_MontoDisponible		DECIMAL(12,2);	-- monto Disponible

	DECLARE Var_MontoBloqueo		DECIMAL(12,2);	-- Monto de Bloqueo
	DECLARE Var_Control				VARCHAR(100);	-- Retorno en pantalla
	DECLARE Var_Contrasenia			VARCHAR(500);	-- Contrasenia de Usuario

	-- declaracion de constantes
	DECLARE Entero_Cero			INT(11);		-- Entero Cero
	DECLARE Blo_AutoDis			INT(11);		-- Tipo de desbloqueo Automatico en por dispersion
	DECLARE Con_TarjetaActiva	INT(11);		-- Constante Estatus Activo de Tarjetas
	DECLARE Blo_AutoDep			INT(11);		-- Tipo de Bloqueo Automatico en cada Deposito
	DECLARE Des_RevAbonocta		INT(11);		-- Reversa por bloqueo automatico por tipo de cuenta (Abono a Cuenta)

	DECLARE Blo_CancelSoc		INT(11);		-- tipo de bloqueo para cancelacion de socio
	DECLARE LongitudTarjeta		INT(11);		-- Constante Longitud Tarjeta
	DECLARE Con_BloqueoTarjeta	INT(11);		-- Tipo de Bloqueo por tarjeta de Debito corresponde con Tipos de bloqueos
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia

	DECLARE Nat_Bloqueo			CHAR(1);		-- Naturaleza Bloqueo
	DECLARE Nat_Desbloqueo		CHAR(1);		-- Naturaleza Desbloqueo
	DECLARE Salida_SI			CHAR(1);		-- Salida en Pantalla SI
	DECLARE Salida_NO			CHAR(1);		-- Salida en Pantalla NO
	DECLARE Est_Vigente			CHAR(1);		

	DECLARE Reg_Movimiento		CHAR(1);		-- Registra Movimiento
	DECLARE Con_SI				CHAR(1);		-- Constante SI
	DECLARE Codigo_Vacio		CHAR(6);		-- Codigo de Autorizacion Vacio
	DECLARE Con_NO				CHAR(1);		-- Constante NO
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante Decimal Cero

	-- Declaracion de Actualizaciones
	DECLARE Act_BloqueoSaldo	INT(11);		-- Actualizacion de Bloqueo de Saldo
	DECLARE Act_DesbloqueoSaldo	INT(11);		-- Actualizacion de Desbloqueo de Saldo

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET Blo_AutoDis			:= 1;
	SET Con_TarjetaActiva	:= 7;
	SET Blo_AutoDep			:= 13;
	SET Des_RevAbonocta		:= 14;

	SET Blo_CancelSoc		:= 15;
	SET LongitudTarjeta		:= 16;
	SET Con_BloqueoTarjeta	:= 23;
	SET Fecha_Vacia			:= '1900-01-01';
	SET Cadena_Vacia		:= '';

	SET Nat_Bloqueo			:= 'B';
	SET Nat_Desbloqueo		:= 'D';
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Est_Vigente			:= 'V';

	SET Reg_Movimiento		:= 'N';
	SET Con_SI				:= 'S';
	SET Con_NO 				:= 'N';
	SET Codigo_Vacio		:= '000000';
	SET Decimal_Cero		:= 0.00;

	-- Asignacion de Actualizaciones
	SET Act_BloqueoSaldo	:=  2;
	SET Act_DesbloqueoSaldo	:=  3;

	-- Asignacion de Variables
	SET Aud_FechaActual		:= CURRENT_TIMESTAMP();

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 1299;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_BLOQUEOSALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Asignacion de variables
		SELECT	BloqueoID,		FolioBloqueo,	MontoBloqueo,		IFNULL(TiposBloqID,Entero_Cero)
		INTO	Var_BloqueoID,	Var_FolioBloq,	Var_MontoBloqueo,	Var_TipoBloqOrig
		FROM TC_BLOQUEOS
		WHERE BloqueoID = Par_BloqueoID;

		SET Var_BloqueoID		:= IFNULL(Var_BloqueoID, Entero_Cero);
		SET Var_FolioBloq		:= IFNULL(Var_FolioBloq, Entero_Cero);
		SET Var_MontoBloqueo	:= IFNULL(Var_MontoBloqueo, Entero_Cero);
		SET Var_TipoBloqOrig	:= IFNULL(Var_TipoBloqOrig, Entero_Cero);

		SET Par_TiposBloqID 	:= IFNULL(Par_TiposBloqID, Entero_Cero);
		SET Par_MontoBloqueo	:= IFNULL(Par_MontoBloqueo, Decimal_Cero);
		SET Par_NatMovimiento	:= IFNULL(Par_NatMovimiento, Cadena_Vacia);
		SET Par_TarjetaCreditoID:= IFNULL(Par_TarjetaCreditoID, Cadena_Vacia);
		SET Par_Descripcion		:= IFNULL(Par_Descripcion, Cadena_Vacia);
		SET Par_Referencia		:= IFNULL(Par_Referencia, Cadena_Vacia);
		SET Par_TerminalID		:= IFNULL(Par_TerminalID, Cadena_Vacia);

		SET Par_NombreTerminal		:= IFNULL(Par_NombreTerminal, Cadena_Vacia);
		SET Par_LocacionTerminal	:= IFNULL(Par_LocacionTerminal, Cadena_Vacia);
		SET Par_NumAutorizacionAct	:= IFNULL(Par_NumAutorizacionAct, Codigo_Vacio);
		SET Par_NumAutorizacionAnt	:= IFNULL(Par_NumAutorizacionAnt, Codigo_Vacio);

		IF( Par_TiposBloqID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1201;
			SET Par_ErrMen	:= CONCAT("Tipo de bloqueo esta vacio.");
			SET Var_Control	:= 'tarjetaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	TiposBloqID
		INTO	Var_TiposBloq
		FROM TIPOSBLOQUEOS
		WHERE TiposBloqID = Par_TiposBloqID;

		SET Var_TiposBloq	:= IFNULL(Var_TiposBloq, Entero_Cero);

		IF( Var_TiposBloq = Entero_Cero ) THEN
			SET Par_NumErr	:= 1202;
			SET Par_ErrMen	:= 'El tipo de Bloqueo/Desbloqueo no existe(TIPOSBLOQUEOS).';
			SET Var_Control	:= 'natMovimiento';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NatMovimiento = Cadena_Vacia) THEN
			SET Par_NumErr	:= 1203;
			SET Par_ErrMen	:= 'La naturaleza del bloqueo esta vacia.';
			SET Var_Control	:= 'natMovimiento';
		END IF;

		IF( Par_TarjetaCreditoID = Cadena_Vacia )THEN
			SET Par_NumErr	:= 1404;
			SET Par_ErrMen	:= 'El Numero de Tarjeta de Credito esta vacio.';
			SET Var_Control	:= 'tarjetaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( CHAR_LENGTH(Par_TarjetaCreditoID) != LongitudTarjeta ) THEN
			SET Par_NumErr	:= 1404;
			SET Par_ErrMen	:= 'El Numero de la Tarjeta de Credito esta Incorrecto.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_MontoBloqueo = Entero_Cero AND Par_NatMovimiento = Nat_Bloqueo ) THEN
			SET Par_NumErr	:= 1305;
			SET Par_ErrMen	:= 'El monto esta vacio.';
			SET Var_Control	:= 'montoBloqueo';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Descripcion = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1206;
			SET Par_ErrMen	:= 'La descripcion esta vacia.';
			SET Var_Control	:= 'tarjetaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumAutorizacionAct = Codigo_Vacio ) THEN
			SET Par_NumErr	:= 1207;
			SET Par_ErrMen	:= 'El Codigo de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			LEAVE ManejoErrores;
		END IF;

		SELECT LineaTarCredID,		TarjetaCredID
		INTO Var_LineaTarCredID,	Var_TarjetaCreditoID
		FROM TARJETACREDITO
		WHERE TarjetaCredID = Par_TarjetaCreditoID;
		SET Var_TarjetaCreditoID := IFNULL(Var_TarjetaCreditoID, Cadena_Vacia);
		SET Var_LineaTarCredID 	 := IFNULL(Var_LineaTarCredID, Entero_Cero);

		IF( Var_TarjetaCreditoID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1408;
			SET Par_ErrMen	:= CONCAT('El Numero de Tarjeta de Credito no Existe: ',Par_TarjetaCreditoID);
			SET Var_Control	:= 'tarjetaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusTarjeta <> Con_TarjetaActiva ) THEN
			SET Par_NumErr	:= 1409;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Credito: ',Par_TarjetaCreditoID, ' No esta Activa');
			SET Var_Control	:= 'tarjetaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_LineaTarCredID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1210;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Credito: ',Par_TarjetaCreditoID,' no cuenta con Linea de Credito.');
			SET Var_Control	:= 'tarjetaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	Estatus,		MontoDisponible,		MontoBloqueado
		INTO	Var_Estatus,	Var_MontoDisponible,	Var_MontoBloqueado
		FROM LINEATARJETACRED
		WHERE LineaTarCredID = Var_LineaTarCredID;

		IF( Var_Estatus != Est_Vigente ) THEN
			SET Par_NumErr	:= 1409;
			SET Par_ErrMen	:= 'La Linea de la Tarjeta de Credito no esta activa.';
			SET Var_Control	:= 'tarjetaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TiposBloqID != Con_BloqueoTarjeta ) THEN
			SET Par_NumErr	:= 1210;
			SET Par_ErrMen	:= CONCAT('El Tipo de bloqueo no es Valido: ',Par_TiposBloqID);
			SET Var_Control	:= 'tarjetaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NatMovimiento = Nat_Bloqueo ) THEN
			IF( Par_Referencia = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 1211;
				SET Par_ErrMen	:= 'La referencia esta vacia.';
				SET Var_Control	:= 'tarjetaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_MontoBloqueo = Decimal_Cero OR Par_MontoBloqueo < Decimal_Cero) THEN
				SET Par_NumErr	:= 1312;
				SET Par_ErrMen	:= 'La Cantidad debe de ser mayor que cero.';
				SET Var_Control	:= 'tarjetaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_MontoBloqueo > Var_MontoDisponible) THEN
				SET Par_NumErr	:= 1313;
				SET Par_ErrMen	:= CONCAT("Saldo a bloquear es mayor al disponible. Tarjeta de Credito: ", Par_TarjetaCreditoID, ".");
				SET Var_Control	:= 'BloqueoID';
				LEAVE ManejoErrores;
			END IF;

			-- Bloqueo de Saldo
			CALL LINEATARJETACREDACT(
				Var_LineaTarCredID,	Par_FechaMovimiento,	Par_MontoBloqueo,	Act_BloqueoSaldo,
				Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Par_NumErr	:= 1214;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF( Par_NatMovimiento = Nat_Desbloqueo ) THEN

			IF( Par_BloqueoID = Entero_Cero ) THEN
				SET Par_NumErr	:= 1214;
				SET Par_ErrMen	:= 'El Numero de Bloqueo esta Vacio.';
				SET Var_Control	:= 'bloqueoID';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_BloqueoID = Entero_Cero ) THEN
				SET Par_NumErr	:= 1214;
				SET Par_ErrMen	:= 'El Numero de Bloqueo no existe.';
				SET Var_Control	:= 'bloqueoID';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_FolioBloq <> Entero_Cero ) THEN
				SET Par_NumErr	:= 1215;
				SET Par_ErrMen	:= 'El registro ya se encuentra desbloqueado.';
				SET Var_Control	:= 'folioBloqueo';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_TiposBloqID <> Var_TipoBloqOrig ) THEN
				SET Par_NumErr	:= 1216;
				SET Par_ErrMen	:= 'El Tipo Desbloqueo no coincide con el Tipo de Bloqueo Orignal.';
				SET Var_Control	:= 'folioBloqueo';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_MontoBloqueo > Var_MontoBloqueado ) THEN
				SET Par_NumErr	:= 1317;
				SET Par_ErrMen	:= CONCAT("Saldo a desbloquear es mayor al bloqueado. Tarjeta de Credito ", Par_TarjetaCreditoID, ".");
				SET Var_Control	:= 'montoBloqueo';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_NumAutorizacionAnt = Codigo_Vacio ) THEN
				SET Par_NumErr	:= 1218;
				SET Par_ErrMen	:= 'El Codigo de Autorizacion Anterior esta Vacio.';
				SET Var_Control	:= 'authorizationNumber';
				LEAVE ManejoErrores;
			END IF;

			-- Desbloqueo de Saldo
			CALL LINEATARJETACREDACT(
				Var_LineaTarCredID,	Par_FechaMovimiento,	Par_MontoBloqueo,	Act_DesbloqueoSaldo,
				Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Par_NumErr	:= 1219;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		SET Var_FechaHora		:= (CONCAT(Par_FechaMovimiento,' ',CONVERT(CURTIME(),CHAR(8))));
		SET Var_FechaMovimiento	:= (SELECT CAST(Var_FechaHora AS DATETIME));
		SET Var_NumBloqueoID 	:= (SELECT IFNULL(MAX(BloqueoID),Entero_Cero)+1 FROM TC_BLOQUEOS FOR UPDATE);

		IF( Par_BloqueoID > Entero_Cero AND
			Par_NatMovimiento = Nat_Desbloqueo ) THEN

			SET Var_FechaHora		:= (CONCAT(DATE(Par_FechaDesbloqueo),' ',CONVERT(CURTIME(),CHAR(8))));
			SET Par_FechaDesbloqueo	:= (SELECT CAST(Var_FechaHora AS DATETIME));

			INSERT INTO TC_BLOQUEOS (
				BloqueoID,				TarjetaCreditoID,		NatMovimiento,			FechaMovimiento,		MontoBloqueo,
				FechaDesbloqueo,		TiposBloqID,			Descripcion,			Referencia,				FolioBloqueo,
				TerminalID,				NombreTerminal,			LocacionTerminal,		NumAutorizacionAct,		NumAutorizacionAnt,
				EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
				Sucursal,				NumTransaccion)
			VALUES (
				Var_NumBloqueoID,		Par_TarjetaCreditoID,	Par_NatMovimiento,		Var_FechaMovimiento,	Var_MontoBloqueo,
				Par_FechaDesbloqueo,	Par_TiposBloqID,		UPPER(Par_Descripcion),	Par_Referencia,			Entero_Cero,
				Par_TerminalID,			Par_NombreTerminal,		Par_LocacionTerminal,	Par_NumAutorizacionAct,	Par_NumAutorizacionAnt,
				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

			UPDATE TC_BLOQUEOS SET
				FolioBloqueo	= Var_NumBloqueoID,
				FechaDesbloqueo	= Par_FechaDesbloqueo,
				EmpresaID 		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID 		= Aud_ProgramaID,
				Sucursal 		= Aud_Sucursal,
				NumTransaccion 	= Aud_NumTransaccion
			WHERE BloqueoID = Par_BloqueoID;

			-- Se realiza el pase historico del Bloqueo
			CALL TC_HISBLOQUEOSPRO(
				Par_BloqueoID,
				Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			-- Se realiza el pase historico del Desbloqueo
			CALL TC_HISBLOQUEOSPRO(
				Var_NumBloqueoID,
				Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_ErrMen	:= 'Desbloqueo Registrado Correctamente.';
		END IF;

		IF(Par_NatMovimiento = Nat_Bloqueo)THEN

			INSERT INTO TC_BLOQUEOS (
				BloqueoID,				TarjetaCreditoID,		NatMovimiento,			FechaMovimiento,		MontoBloqueo,
				FechaDesbloqueo,		TiposBloqID,			Descripcion,			Referencia,				FolioBloqueo,
				TerminalID,				NombreTerminal,			LocacionTerminal,		NumAutorizacionAct,		NumAutorizacionAnt,
				EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
				Sucursal,				NumTransaccion)
			VALUES (
				Var_NumBloqueoID,		Par_TarjetaCreditoID,	Par_NatMovimiento,		Var_FechaMovimiento,	Par_MontoBloqueo,
				Par_FechaDesbloqueo,	Par_TiposBloqID,		UPPER(Par_Descripcion),	Par_Referencia, 		Entero_Cero,
				Par_TerminalID,			Par_NombreTerminal,		Par_LocacionTerminal,	Par_NumAutorizacionAct,	Par_NumAutorizacionAnt,
				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

			SET Par_ErrMen	:= 'Bloqueo Registrado Correctamente.';
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Var_Control	:= 'bloqueoID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_NumBloqueoID AS Consecutivo;
	END IF;

END TerminaStore$$
