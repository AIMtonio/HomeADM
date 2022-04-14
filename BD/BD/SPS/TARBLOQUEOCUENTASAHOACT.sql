-- TARBLOQUEOCUENTASAHOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS TARBLOQUEOCUENTASAHOACT;
DELIMITER $$

CREATE PROCEDURE TARBLOQUEOCUENTASAHOACT(
	-- SP PARA REALIZAR LA ACTUALIZACION DE BLOQUEO MASIVO DE CUENTAS DE AHORRO
	Par_CuentaAhoID			BIGINT(12),				-- Cuenta de ahorro
	Par_UsuarioID			INT(11),				-- Usuario ID que autoriza
	Par_Fecha				DATE,					-- Fecha del bloqueo
	Par_Motivo				VARCHAR(100),			-- Motivo del bloqueo
	Par_NumAct				TINYINT UNSIGNED,		-- Numero de Actualizacion Bloqueo:1

	Par_Salida				CHAR(1),				-- Salida S:Si No:No
	INOUT Par_NumErr		INT(11),				-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de error
	-- Auditoria
	Par_EmpresaID			INT(11),				-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),				-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,				-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),				-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  			-- Parametro de auditoria Numero de la transaccion
	)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE	Fecha_Vacia			DATE;				-- Fecha vacia
	DECLARE	Entero_Cero			INT(11);			-- Entero cero
	DECLARE	Act_Bloqueo			INT(11);			-- Actualizacion de bloqueo masivo de cuentas
	DECLARE	SalidaNO			CHAR(1);			-- Salida no
	DECLARE	SalidaSI			CHAR(1);			-- Salida si
	DECLARE	Decimal_Cero		DECIMAL(12,2);		-- Decimal cero
	DECLARE	Estatus_Bloqueada	CHAR(1);			-- Estatus bloqueada
	DECLARE Alta_Masiva			INT(11);			-- Proceso de alta masiva de la bitacora

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Decimal_Cero			:= 0.0;
	SET	Act_Bloqueo				:= 1;
	SET	SalidaSI				:= 'S';
	SET	SalidaNO				:= 'N';
	SET Aud_FechaActual 		:= NOW();
	SET	Estatus_Bloqueada		:= 'B';
	SET Alta_Masiva				:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TARBLOQUEOCUENTASAHOACT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		-- BLOQUEO MASIVO DE CUENTAS DE AHORRO
		IF(Par_NumAct = Act_Bloqueo) THEN
			IF(IFNULL(Par_UsuarioID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= CONCAT('El Numero de Usuario que realiza el bloqueo esta Vacio.');
				SET Var_Control	:= 'usuarioID' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Fecha,Fecha_Vacia)) = Fecha_Vacia THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= CONCAT('La Fecha del bloqueo esta Vacia.');
				SET Var_Control	:= 'fechaApertura';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Motivo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= CONCAT('El Motivo del bloqueo esta Vacio.');
				SET Var_Control	:= 'motivo' ;
				LEAVE ManejoErrores;
			END IF;

			IF( NOT EXISTS(SELECT UsuarioID FROM USUARIOS WHERE UsuarioID = Par_UsuarioID))THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= CONCAT('El Usuario que realiza el Bloqueo de Cuentas no existe ', '[',Par_UsuarioID,']');
				SET Var_Control	:= 'usuarioID';
				LEAVE ManejoErrores;
			END IF;

			CALL BITACORATARBLOQCTAAHOPRO (
				Entero_Cero,		Entero_Cero,		Entero_Cero,		Decimal_Cero,		Decimal_Cero,
				Decimal_Cero,		Decimal_Cero,		Par_UsuarioID,		Par_Fecha,			Alta_Masiva,
				SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);
			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			UPDATE CUENTASAHO Aho
			INNER JOIN TMPBLOQUEOCUENTASAHO Tmp ON Aho.CuentaAhoID = Tmp.CuentaAhoID
			SET
				Aho.UsuarioBloID	= Par_UsuarioID,
				Aho.FechaBlo		= Par_Fecha,
				Aho.MotivoBlo		= Par_Motivo,
				Aho.Estatus			= Estatus_Bloqueada,

				Aho.EmpresaID		= Par_EmpresaID,
				Aho.Usuario			= Aud_Usuario,
				Aho.FechaActual 	= Aud_FechaActual,
				Aho.DireccionIP 	= Aud_DireccionIP,
				Aho.ProgramaID  	= Aud_ProgramaID,
				Aho.Sucursal		= Aud_Sucursal,
				Aho.NumTransaccion	= Aud_NumTransaccion
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('Cuenta Bloqueada Exitosamente.');
			SET Var_Control	:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control;
	END IF;

END TerminaStore$$