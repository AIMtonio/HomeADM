-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEICUENTASCLABEPFISICAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEICUENTASCLABEPFISICAACT`;
DELIMITER $$

CREATE PROCEDURE `SPEICUENTASCLABEPFISICAACT`(
# =============================================================================================================================
# ----------- SP PARA ACTUALIZAR LA INFORMACION DE CUENTAS CLABE PERSONAS FISICAS ----------------------------
# =============================================================================================================================
    Par_CuentaClabePFisicaID			INT(11),					-- Identificador de la tabla
    Par_CuentaClabe       				VARCHAR(18),				-- Cuenta Clabe registrado ante STP
    Par_PIDTarea						VARCHAR(50),				-- ID de Proceso del Demonio
    Par_IDRespuesta						INT(11),					-- Numero de respuesta de STP (0 = El proceso se ejecuto de manera correcta, > 0 Ocurrio un error durante el procesamiento)
    Par_DescripcionRespuesta			VARCHAR(256),				-- Descripcion de respuesta de STP
    Par_Comentario						VARCHAR(512),				-- Comentario por Baja de Cuenta Clabe
    Par_NumAct							INT(11),					-- Numero de Actualizacion

    Par_Salida          				CHAR(1),					-- Parametro de Salida
    INOUT Par_NumErr    				INT(11),
    INOUT Par_ErrMen    				VARCHAR(400),

    Aud_EmpresaID						INT(11),				-- Parametro de Auditoria
	Aud_Usuario							INT(11),				-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal						INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT					-- Parametro de Auditoria
)
TerminaStore: BEGIN
    -- Declaracion de constantes
	DECLARE SalidaNO					CHAR(1);					-- Constante Salida NO
	DECLARE SalidaSI					CHAR(1);					-- Constante Salida SI
	DECLARE Entero_Cero					INT(11);					-- Entero Cero
	DECLARE Cadena_Vacia				VARCHAR(10);				-- Cadena Vacia
	DECLARE Act_PendAut					TINYINT;					-- Numero de Actualizacion para cambio de estatus a pendiente de Autorizacion
	DECLARE Act_PIDTarea 				TINYINT;					-- Opcion para actualizacion de PID Tarea
	DECLARE Act_NumIntentos				TINYINT;					-- Actualizacion de numero de Intentos
	DECLARE Act_EstBaja					TINYINT;					-- Actualizacion del estatus de la Cuenta Clabe a Baja
	DECLARE Act_EstAuto					TINYINT;					-- Actualizacion del estatus de la cuenta clabe a autorizado
	DECLARE Est_PendAut					CHAR(1);					-- Estatus Pendiente de Autorizacion
	DECLARE Est_Inactivo 				CHAR(1);					-- Estatus Inactivo
	DECLARE Est_Baja					CHAR(1);					-- Estatus Baja
	DECLARE Est_Autorizado				CHAR(1);					-- Estatus de Autorizado

	-- Declaracion de Variables
	DECLARE Var_Respuesta				VARCHAR(70);				-- Cadena con la respuesta
	DECLARE Var_UsuarioID				INT(11);					-- Numero de Usuario
	DECLARE Var_Control             	VARCHAR(100);				-- Variable con el nombre del control
	DECLARE Var_Estatus					CHAR(1);					-- Estatus
	DECLARE Var_Consecutivo				INT(11);					-- Consecutivo
	DECLARE Var_CuentaClabePFisicaID	INT(11);					-- ID del registro por actualizar

	-- Asignacion de valor a constantes
	SET SalidaNO					:= 'N';						-- Constante Salida NO
	SET SalidaSI					:= 'S';						-- Constante Salida SI
	SET Entero_Cero					:= 0;						-- Entero Cero
	SET Cadena_Vacia				:= '';						-- Cadena vacía.
	SET Act_PendAut					:= 1;						-- Numero de Actualizacion para cambio de estatus a pendiente de Autorizacion
	SET Act_PIDTarea 				:= 2;						-- Opcion para actualizacion de PID Tarea
	SET Act_NumIntentos				:= 3;						-- Actualizacion de numero de Intentos
	SET Act_EstBaja					:= 4;						-- Actualizacion del estatus de la Cuenta Clabe a Baja
	SET Act_EstAuto					:= 5;						-- Actualizacion del estatus de la cuenta clabe a autorizado
	SET Est_PendAut					:= 'P';						-- Estatus Pendiente de Autorizacion
	SET Est_Inactivo				:= 'I';						-- Estatus Inactivo
	SET Est_Baja					:= 'B';						-- Estatus Baja
	SET Est_Autorizado				:= 'A';						-- Estatus autorizado.

	-- Establecemos valores por defecto
	SET Par_Comentario := IFNULL(Par_Comentario, Cadena_Vacia);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-SPEICUENTASCLABEPFISICAACT');
				SET Var_Control := 'SQLEXCEPTION';
			END;

		IF(Par_NumAct = Act_PendAut) THEN
			SELECT 		Estatus,			CuentaClabePFisicaID
				INTO 	Var_Estatus,		Var_CuentaClabePFisicaID
				FROM SPEICUENTASCLABEPFISICA
				WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;

			IF(IFNULL(Var_CuentaClabePFisicaID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'Cuenta clabe para persona fisica no encontrado.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus <> Est_Inactivo) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'La cuenta clabe para persona fisica ya fue actualizado previamente.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;


			UPDATE SPEICUENTASCLABEPFISICA
				SET Estatus = Est_PendAut,
					EmpresaID = Aud_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;

			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Cuenta Clabe actualizada correctamente.');
			SET Var_Control := 'creditoID';
			SET Var_Consecutivo := Par_CuentaClabePFisicaID;
		END IF;

		IF(Par_NumAct = Act_PIDTarea) THEN
			UPDATE SPEICUENTASCLABEPFISICA
				SET PIDTarea = Par_PIDTarea,
					EmpresaID = Aud_EmpresaID,
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
			SET Var_Consecutivo := Par_CuentaClabePFisicaID;
		END IF;

		IF(Par_NumAct = Act_NumIntentos) THEN
			SELECT 		Estatus,			CuentaClabePFisicaID
				INTO 	Var_Estatus,		Var_CuentaClabePFisicaID
				FROM SPEICUENTASCLABEPFISICA
				WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;

			IF(IFNULL(Var_CuentaClabePFisicaID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'Cuenta clabe para persona fisica no encontrado.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;


			UPDATE SPEICUENTASCLABEPFISICA
				SET NumIntentos = NumIntentos + 1,
					PIDTarea = Cadena_Vacia,
					EmpresaID = Aud_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;

			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Cuenta Clabe actualizada correctamente.');
			SET Var_Control := 'creditoID';
			SET Var_Consecutivo := Par_CuentaClabePFisicaID;
		END IF;

		IF(Par_NumAct = Act_EstBaja) THEN
			SELECT 		Estatus,			CuentaClabePFisicaID
				INTO 	Var_Estatus,		Var_CuentaClabePFisicaID
				FROM SPEICUENTASCLABEPFISICA
				WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;

			IF(IFNULL(Var_CuentaClabePFisicaID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'Cuenta clabe para persona fisica no encontrado.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus <> Est_Inactivo AND Var_Estatus <> Est_PendAut) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'La cuenta clabe no se puede dar de baja debido a que su estatus no esta como inactivo.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			UPDATE SPEICUENTASCLABEPFISICA
				SET Estatus = Est_Baja,
					Comentario = Par_Comentario,
					EmpresaID = Aud_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;

			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Cuenta Clabe actualizada correctamente.');
			SET Var_Control := 'cuentaClabe';
			SET Var_Consecutivo := Par_CuentaClabePFisicaID;
		END IF;
		
		IF(Par_NumAct = Act_EstAuto) THEN
			SELECT 		Estatus,			CuentaClabePFisicaID
				INTO 	Var_Estatus,		Var_CuentaClabePFisicaID
				FROM SPEICUENTASCLABEPFISICA
				WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;

			IF(IFNULL(Var_CuentaClabePFisicaID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'Cuenta clabe para persona fisica no encontrado.';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus <> Est_PendAut) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'La cuenta clabe No se puede autorizar, ya que tiene un estatus diferente a Pendiente por autorizar';
				SET Var_Control := 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;

			UPDATE SPEICUENTASCLABEPFISICA
				SET Estatus = Est_Autorizado,
					Comentario = Par_Comentario,
					EmpresaID = Aud_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;

			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Cuenta Clabe actualizada correctamente.');
			SET Var_Control := 'cuentaClabe';
			SET Var_Consecutivo := Par_CuentaClabePFisicaID;
		END IF;
	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;/*Enviar siempre en exito el numero de Solicitud*/
	END IF;
END TerminaStore$$ 
