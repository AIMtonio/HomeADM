-- SPEICUENTASCLABPMORALACT
DELIMITER ;
	DROP PROCEDURE IF EXISTS SPEICUENTASCLABPMORALACT;
DELIMITER $$

CREATE PROCEDURE SPEICUENTASCLABPMORALACT(
	Par_SpeiCuentaPMoralID				INT(11),
	Par_CuentaClabe       				VARCHAR(18),		-- Cuenta Clabe registrado ante STP
    Par_PIDTarea						VARCHAR(50),		-- ID de Proceso del Demonio
    Par_IDRespuesta						INT(11),			-- Numero de respuesta de STP (0 = El proceso se ejecuto de manera correcta, > 0 Ocurrio un error durante el procesamiento)
    Par_DescripcionRespuesta			VARCHAR(256),		-- Descripcion de respuesta de STP

    Par_Comentario						VARCHAR(512),		-- Comentario por Baja de Cuenta Clabe
	Par_NumAct							TINYINT UNSIGNED,

	Par_Salida          				CHAR(1),
	INOUT Par_NumErr    				INT(11),
	INOUT Par_ErrMen    				VARCHAR(400),

	Par_EmpresaID						INT(11),
	Aud_Usuario							INT(11),
	Aud_FechaActual						DATETIME,
	Aud_DireccionIP						VARCHAR(20),
	Aud_ProgramaID						VARCHAR(50),
	Aud_Sucursal						INT(11),
	Aud_NumTransaccion					BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Entero_Cero					INT(11);			-- Entero Cero
	DECLARE Decimal_Cero				DECIMAL(18,2);		-- Decimal _cero
	DECLARE Fecha_Vacia					DATE;				-- Fecha Vacia
	DECLARE Salida_SI					CHAR(1);			-- Salida si
	DECLARE Salida_NO					CHAR(1);			-- Salida no
	DECLARE EstAutorizado				CHAR(1);			-- Estatus Autorizado
	DECLARE Est_PendAut					CHAR(1);			-- Estatus por autorizar
	DECLARE EstBaja						CHAR(1);			-- Estatus baja
	DECLARE Est_Inactivo 				CHAR(1);			-- Estatus Inactivo
	DECLARE ActAutoriza					INT(11);			-- Actualizacion autorizado.
	DECLARE ActPorAutorizar				INT(11);			-- Actualizacion por autorizar
	DECLARE ActBaja						INT(11);			-- Actualizacion baja
	DECLARE Act_PIDTarea 				INT(11);			-- Actualizacion del PID para la tarea de registro de cuenta clabe.
	DECLARE Act_NumIntentos 			INT(11);			-- Actualizacion de numero de intentos de registro de cuenta clabe.

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(200);		-- Variable de control
	DECLARE Var_Estatus					CHAR(1);			-- Estatus
	DECLARE Var_Consecutivo				INT(11);			-- Consecutivo
	DECLARE Var_SpeiCuentaPMoralID		INT(11);			-- ID del registro por actualizar
	
	-- Asignacion de Constantes
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Decimal_Cero					:= 0.0;				-- Decimal cero
	SET Salida_SI						:= 'S';				-- Salida SI
	SET Salida_NO						:= 'N';				-- Salida NO
	SEt EstAutorizado					:= 'A';				-- Estatus Autorizado
	SET Est_PendAut						:= 'P';				-- Estatus por autorizar
	SET EstBaja							:= 'B';				-- Estatu Baja
	SET Est_Inactivo					:= 'I';				-- Estatus Inactivo
	SET ActAutoriza						:= 1;				-- Actualiza el estatus
	SET ActPorAutorizar					:= 2;				-- actualizacion por autorizar
	SET ActBaja							:= 3;				-- Actualizacion baja.
	SET Act_PIDTarea 					:= 4;				-- Actualizacion del PID para la tarea de registro de cuenta clabe.
	SET Act_NumIntentos 				:= 5;				-- Actualizacion de numero de intentos de registro de cuenta clabe.

	-- Establecemos valores por defecto
	SET Par_Comentario := IFNULL(Par_Comentario, Cadena_Vacia);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEICUENTASCLABPMORALACT');
				SET Var_Control	:= 'sqlException';
			END;

		-- Atualizacion de la cuenta clabe a autorizado.
		IF(Par_NumAct = ActAutoriza) THEN
			SELECT 		Estatus,			SpeiCuentaPMoralID
				INTO 	Var_Estatus,		Var_SpeiCuentaPMoralID
				FROM SPEICUENTASCLABPMORAL
				WHERE SpeiCuentaPMoralID = Par_SpeiCuentaPMoralID;
			
			IF (IFNULL(Var_SpeiCuentaPMoralID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'No se encontro informacion de la cuenta clabe por actualizar.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus <> Est_PendAut) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'La cuenta clabe No se puede autorizar, ya que tiene un estatus diferente a Pendiente por autorizar';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			UPDATE SPEICUENTASCLABPMORAL
				SET Estatus = EstAutorizado,
					Comentario = Par_Comentario,

					EmpresaID = Par_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE SpeiCuentaPMoralID = Par_SpeiCuentaPMoralID;

			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Cuenta Clabe actualizada correctamente.');
			SET Var_Control := 'cuentaClabe';
			SET Var_Consecutivo := Par_SpeiCuentaPMoralID;
		END IF;

		-- Atualizacion de la cuenta clabe a pendiente por autorizar.
		IF(Par_NumAct = ActPorAutorizar) THEN
			SELECT 		Estatus,			SpeiCuentaPMoralID
				INTO 	Var_Estatus,		Var_SpeiCuentaPMoralID
				FROM SPEICUENTASCLABPMORAL
				WHERE SpeiCuentaPMoralID = Par_SpeiCuentaPMoralID;
			
			IF (IFNULL(Var_SpeiCuentaPMoralID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'No se encontro informacion de la cuenta clabe por actualizar.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus <> Est_Inactivo) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'La cuenta clabe ya fue actualizada previamente.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			UPDATE SPEICUENTASCLABPMORAL
				SET Estatus = Est_peNdaut,

					EmpresaID = Par_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE SpeiCuentaPMoralID = Par_SpeiCuentaPMoralID;

			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Cuenta Clabe actualizada correctamente.');
			SET Var_Control := 'cuentaID';
			SET Var_Consecutivo := Par_SpeiCuentaPMoralID;
		END IF;

		-- Atualizacion de la cuenta clabe a baja.
		IF(Par_NumAct = ActBaja) THEN
			SELECT 		Estatus,			SpeiCuentaPMoralID
				INTO 	Var_Estatus,		Var_SpeiCuentaPMoralID
				FROM SPEICUENTASCLABPMORAL
				WHERE SpeiCuentaPMoralID = Par_SpeiCuentaPMoralID;
			
			IF (IFNULL(Var_SpeiCuentaPMoralID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'No se encontro informacion de la cuenta clabe por actualizar.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus <> Est_Inactivo AND Var_Estatus <> Est_PendAut) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'La cuenta clabe no se puede dar de baja debido a que su estatus no esta como inactivo.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			UPDATE SPEICUENTASCLABPMORAL
				SET Estatus = EstBaja,
					Comentario = Par_Comentario,

					EmpresaID = Par_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE SpeiCuentaPMoralID = Par_SpeiCuentaPMoralID;

			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Cuenta Clabe actualizada correctamente.');
			SET Var_Control := 'cuentaClabe';
			SET Var_Consecutivo := Par_SpeiCuentaPMoralID;
		END IF;

		-- Actualizacion masiva para la tarea de registro de cuentas clabes
		IF(Par_NumAct = Act_PIDTarea) THEN
			UPDATE SPEICUENTASCLABPMORAL
				SET PIDTarea = Par_PIDTarea,

					EmpresaID = Par_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE Estatus = Est_Inactivo AND PIDTarea = Cadena_Vacia;

			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Cuentas Clabe actualizadas correctamente.');
			SET Var_Control := 'creditoID';
			SET Var_Consecutivo := Entero_Cero;
		END IF;

		-- Actualizacio de numero de intento para la tarea de Registro de cuentas clabes.
		IF(Par_NumAct = Act_NumIntentos) THEN
			SELECT 		Estatus,			SpeiCuentaPMoralID
				INTO 	Var_Estatus,		Var_SpeiCuentaPMoralID
				FROM SPEICUENTASCLABPMORAL
				WHERE SpeiCuentaPMoralID = Par_SpeiCuentaPMoralID;
			
			IF (IFNULL(Var_SpeiCuentaPMoralID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'No se encontro informacion de la cuenta clabe por actualizar.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			UPDATE SPEICUENTASCLABPMORAL
				SET NumIntentos = NumIntentos + 1,
					PIDTarea = Cadena_Vacia,

					EmpresaID = Par_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE SpeiCuentaPMoralID = Par_SpeiCuentaPMoralID;

			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Cuenta Clabe actualizada correctamente.');
			SET Var_Control := 'cuentaID';
			SET Var_Consecutivo := Par_SpeiCuentaPMoralID;
		END IF;
	END ManejoErrores;
	
	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;
		
END TerminaStore$$
