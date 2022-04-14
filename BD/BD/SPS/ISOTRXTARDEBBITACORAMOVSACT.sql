DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTARDEBBITACORAMOVSACT;
DELIMITER $$

CREATE PROCEDURE ISOTRXTARDEBBITACORAMOVSACT(
	-- Descripcion: Proceso que realiza la actualizacion a la bitacora de movimiento de ISOTRX
	-- Modulo: Procesos de ISOTRX
	Par_TipoOperacion		INT(11),			-- Tipo de operacion a realizar
	Par_NumeroTarjeta 		VARCHAR(16),		-- Numero de tarjeta
	Par_TarDebMovID			INT(11),			-- Consecutivo del movimiento de tarjeta

	Par_NumAct				INT(11),			-- Numero de actualizacion

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
	DECLARE Var_MonedaID			INT(11);		-- Moneda id de la cuenta
	DECLARE Var_FechaSistema		DATE;			-- Fecha del sistema

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;			-- Fecha vacia
	DECLARE Entero_Cero				INT(11);		-- Entero cero
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Decimal cero
	DECLARE SalidaSI				CHAR(1); 		-- Salida SI
	DECLARE SalidaNO				CHAR(1); 		-- Salida NO
	DECLARE Con_SI					CHAR(1); 		-- Constante SI
	DECLARE Con_NO					CHAR(1); 		-- Constante NO
	DECLARE Est_Procesado			CHAR(1);		-- Estatus procesado

	-- Declaracion de numero de actualizaciones
	DECLARE Act_Principal			INT(11);		-- Actualizacion principal que actualiza el movimiento a procesada

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
	SET Est_Procesado				:= 'P';

	-- Asignacion de numero de actualizaciones
	SET Act_Principal				:= 1;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXTARDEBBITACORAMOVSACT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		-- Validacion de datos nulos
		SET Par_NumeroTarjeta	:= IFNULL(Par_NumeroTarjeta, Cadena_Vacia);
		SET Par_TipoOperacion	:= IFNULL(Par_TipoOperacion, Entero_Cero);
		SET Par_TarDebMovID		:= IFNULL(Par_TarDebMovID, Entero_Cero);

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

		IF NOT EXISTS(SELECT TarjetaDebID FROM TARJETADEBITO WHERE TarjetaDebID = Par_NumeroTarjeta)THEN
			SET Par_NumErr  := 0005;
			SET Par_ErrMen  := 'El número de tarjeta no existe.';
			SET Var_Control	:= 'numeroTarjeta';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TarDebMovID = Entero_Cero)THEN
			SET Par_NumErr  := 1320;
			SET Par_ErrMen  := 'El Consecutivo de Movimiento de la Tarjeta se encuentra vacio.';
			SET Var_Control	:= 'numeroTarjeta';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT TarDebMovID FROM TARDEBBITACORAMOVS WHERE TarDebMovID = Par_TarDebMovID)THEN
			SET Par_NumErr  := 1321;
			SET Par_ErrMen  := 'El Consecutivo de Movimiento de la Tarjeta no existe.';
			SET Var_Control	:= 'numeroTarjeta';
			LEAVE ManejoErrores;
		END IF;

		-- ACTUALIZACION PRINCIPAL QUE ACTUALIZA EL ESTATUS
		IF(Par_NumAct = Act_Principal)THEN
			UPDATE TARDEBBITACORAMOVS
				SET
					Estatus			= Est_Procesado,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
			WHERE TarDebMovID = Par_TarDebMovID;
		END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Actualizacion Realizada Exitosamente.';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$