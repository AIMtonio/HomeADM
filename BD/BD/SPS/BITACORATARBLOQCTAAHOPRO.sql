-- BITACORATARBLOQCTAAHOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS BITACORATARBLOQCTAAHOPRO;
DELIMITER $$

CREATE PROCEDURE BITACORATARBLOQCTAAHOPRO(
	-- SP PARA REALIZAR EL ALTA DE BITACORA DE LAS CUENTAS BLOQUEADAS
	Par_CuentaAhoID			BIGINT(12),				-- Cuenta de ahorro
	Par_ClienteID			INT(11),				-- ID del cliente
	Par_TipoCuentaID		INT(11),				-- Tipo de cuenta
	Par_Saldo				DECIMAL(12,2),			-- Parametro del salo real
	Par_SaldoDispon			DECIMAL(12,2),			-- Parametro del saldo disponible

	Par_SaldoBloq			DECIMAL(12,2),			-- Parametro del saldo bloqueado
	Par_SaldoSBC 			DECIMAL(12,2),			-- Parametro de saldo buen cobro
	Par_UsuarioBloqueoID	INT(11),				-- Parametro del usuario bloqueo
	Par_FechaBloqueo		DATE,					-- Parametro de fecha del bloqueo

	Par_NumPro				TINYINT UNSIGNED,		-- Numero de Proceso: Alta masiva 1

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
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de cadena vacia
	DECLARE	Fecha_Vacia			DATE;				-- Constante de fecha vacia
	DECLARE	Entero_Cero			INT(11);			-- Constante de entero cero
	DECLARE	Pro_AltaMasiva		INT(11);			-- Proceso que realiza la alta masiva de la bitacora
	DECLARE	SalidaNO			CHAR(1);			-- Salida no
	DECLARE	SalidaSI			CHAR(1);			-- Salida si
	DECLARE Con_No				CHAR(1);			-- Constante no

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Pro_AltaMasiva			:= 1;
	SET	SalidaSI				:= 'S';
	SET	SalidaNO				:= 'N';
	SET Aud_FechaActual 		:= NOW();
	SET Con_No					:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACORATARBLOQCTAAHOPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		-- ALTA MASIVA DE LA BITACORA
		IF(Par_NumPro = Pro_AltaMasiva) THEN
			IF(IFNULL(Par_UsuarioBloqueoID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= CONCAT('El Numero de Usuario esta Vacio.');
				SET Var_Control	:= 'usuarioID' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaBloqueo,Fecha_Vacia)) = Fecha_Vacia THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= CONCAT('La Fecha esta Vacia.');
				SET Var_Control	:= 'fechaApertura';
				LEAVE ManejoErrores;
			END IF;

			IF( NOT EXISTS(SELECT UsuarioID FROM USUARIOS WHERE UsuarioID = Par_UsuarioBloqueoID))THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= CONCAT('El Usuario que realiza el Bloqueo de Cuentas no existe ', '[',Par_UsuarioBloqueoID,']');
				SET Var_Control	:= 'usuarioID';
				LEAVE ManejoErrores;
			END IF;

			INSERT BITACORATARBLOQCTAAHO
					(CuentaAhoID,							ClienteID,							TipoCuentaID,			Saldo,							SaldoDisponible,
					SaldoBloqueo,							SaldoSBC,							UsuarioBloqueoID,		FechaBloqueo,					PIDTarea,
					EmpresaID,								Usuario,							FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,								NumTransaccion
					)
			SELECT	Tmp.CuentaAhoID,						Cta.ClienteID,						Cta.TipoCuentaID,		IFNULL(Cta.Saldo,Entero_Cero),	IFNULL(Cta.SaldoDispon,Entero_Cero),
					IFNULL(Cta.SaldoBloq, Entero_Cero),		IFNULL(Cta.SaldoSBC,Entero_Cero),	Par_UsuarioBloqueoID,	Par_FechaBloqueo,				Tmp.PIDTarea,
					Par_EmpresaID,							Aud_Usuario,						Aud_FechaActual,		Aud_DireccionIP,				Aud_ProgramaID,
					Aud_Sucursal,							Aud_NumTransaccion
			FROM TMPBLOQUEOCUENTASAHO Tmp
			INNER JOIN CUENTASAHO Cta ON Tmp.CuentaAhoID = Cta.CuentaAhoID
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Alta de Bitacora Realizada Exitosamente';
			SET Var_Control	:= 'cuentaAhoID' ;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control;
	END IF;

END TerminaStore$$