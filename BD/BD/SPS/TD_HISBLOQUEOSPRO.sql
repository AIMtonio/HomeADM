-- TD_HISBLOQUEOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_HISBLOQUEOSPRO`;

DELIMITER $$
CREATE PROCEDURE `TD_HISBLOQUEOSPRO`(
	-- SP para el pase a Historico de un bloqueo o desbloqueo automatico de una tarjeta de debito
	-- Modulo Tarjetas Debito --> Registro
	Par_BloqueoID			INT(11), 		-- ID de Bloqueo

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

	-- Declaracion de variables
	DECLARE Var_BloqueoID		INT(11);		-- Numero de Bloqueo
	DECLARE Var_Control			VARCHAR(100);	-- Retorno en pantalla

	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Salida_SI			CHAR(1);		-- Salida en Pantalla SI
	DECLARE Salida_NO			CHAR(1);		-- Salida en Pantalla NO
	DECLARE Con_SI				CHAR(1);		-- Constante SI
	DECLARE Con_NO				CHAR(1);		-- Constante NO

	DECLARE Entero_Cero			INT(11);		-- Entero Cero
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante Decimal Cero
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Con_SI				:= 'S';
	SET Con_NO 				:= 'N';

	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.00;
	SET Fecha_Vacia			:= '1900-01-01';

	-- Asignacion de Variables
	SET Aud_FechaActual		:= CURRENT_TIMESTAMP();

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 1299;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TD_HISBLOQUEOSPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SET Par_BloqueoID	:= IFNULL(Par_BloqueoID, Entero_Cero);

		SELECT	BloqueoID
		INTO	Var_BloqueoID
		FROM TD_BLOQUEOS
		WHERE BloqueoID = Par_BloqueoID;

		IF( Par_BloqueoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1201;
			SET Par_ErrMen	:= 'El Numero de Bloqueo esta Vacio.';
			SET Var_Control	:= 'bloqueoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_BloqueoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1214;
			SET Par_ErrMen	:= CONCAT('El Numero de Bloqueo no existe: ',Par_BloqueoID);
			SET Var_Control	:= 'bloqueoID';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO TD_HISBLOQUEOS (
			BloqueoID,			TarjetaDebID,		NatMovimiento,		FechaMovimiento,		MontoBloqueo,
			FechaDesbloqueo,	TiposBloqID,		Descripcion,		Referencia,				FolioBloqueo,
			TerminalID,			NombreTerminal,		LocacionTerminal,	NumAutorizacionAct,		NumAutorizacionAnt,
			EmpresaID,			Usuario,			FechaActual,		DireccionIP,			ProgramaID,
			Sucursal,			NumTransaccion)
		SELECT
			BloqueoID,			TarjetaDebID,		NatMovimiento,		FechaMovimiento,		MontoBloqueo,
			FechaDesbloqueo,	TiposBloqID,		Descripcion,		Referencia,				FolioBloqueo,
			TerminalID,			NombreTerminal,		LocacionTerminal,	NumAutorizacionAct,		NumAutorizacionAnt,
			EmpresaID,			Usuario,			FechaActual,		DireccionIP,			ProgramaID,
			Sucursal,			NumTransaccion
		FROM TD_BLOQUEOS
		WHERE BloqueoID = Par_BloqueoID;

		DELETE FROM TD_BLOQUEOS WHERE BloqueoID = Par_BloqueoID;

		SET Par_ErrMen	:= 'Pase a Historico Realizado Correctamente.';
		SET Par_NumErr	:= Entero_Cero;
		SET Var_Control	:= 'bloqueoID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_BloqueoID AS Consecutivo;
	END IF;

END TerminaStore$$