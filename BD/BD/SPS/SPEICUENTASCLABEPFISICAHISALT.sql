-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEICUENTASCLABEPFISICAHISALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEICUENTASCLABEPFISICAHISALT`;
DELIMITER $$

CREATE PROCEDURE `SPEICUENTASCLABEPFISICAHISALT`(
    Par_CuentaClabePFisicaID  	INT(11),				-- Cuenta Clabe a pasar al historico

	Par_Salida          		CHAR(1),				-- Identificador de SAlida
	INOUT Par_NumErr 			INT(11),				-- Numero de Error
	INOUT Par_ErrMen  			VARCHAR(400),			-- Mensaje de Error

	Aud_EmpresaID				INT(11),				-- Parametro de Auditoria
	Aud_Usuario					INT(11),				-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal				INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT					-- Parametro de Auditoria
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
	DECLARE Est_PendAut					CHAR(1);					-- Estatus Pendiente de Autorizacion
	DECLARE Est_Inactivo 				CHAR(1);					-- Estatus Inactivo
	DECLARE Est_Baja					CHAR(1);					-- Estatus Baja

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
	SET Est_PendAut					:= 'P';						-- Estatus Pendiente de Autorizacion
	SET Est_Inactivo				:= 'I';						-- Estatus Inactivo
	SET Est_Baja					:= 'B';						-- Estatus Baja

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-SPEICUENTASCLABEPFISICAHISALT');
				SET Var_Control := 'SQLEXCEPTION';
			END;

		

		SELECT 		CuentaClabePFisicaID
			INTO 	Var_CuentaClabePFisicaID
			FROM SPEICUENTASCLABEPFISICA
			WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;

		IF(IFNULL(Var_CuentaClabePFisicaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Cuenta clabe para persona fisica no encontrado.';
			SET Var_Control := 'cuentaClabe';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO SPEICUENTASCLABEPFISICAHIS (
					CuentaClabePFisicaID,		ClienteID,					TipoInstrumento,				Instrumento,				CuentaClabe,
					FechaCreacion,				Estatus,					Comentario,						PIDTarea,					Nombre,
					ApellidoPaterno,			ApellidoMaterno,			EmpresaSTP,						RFC,						CURP,
					Genero,						FechaNacimiento,			EstadoID,						Calle,						NumExterior,
					NumInterior,				CodigoPostal,				ClavePaisNacSTP,				CorreoElectronico,			Identificacion,
					Telefono,					Firma,						IDRespuesta,					DescripcionRespuesta,		NumIntentos,
					EmpresaID,					Usuario,					FechaActual,					DireccionIP,				ProgramaID,
					Sucursal,					NumTransaccion
			)
			SELECT 	CuentaClabePFisicaID,		ClienteID,					TipoInstrumento,				Instrumento,				CuentaClabe,
					FechaCreacion,				Estatus,					Comentario,						PIDTarea,					Nombre,
					ApellidoPaterno,			ApellidoMaterno,			EmpresaSTP,						RFC,						CURP,
					Genero,						FechaNacimiento,			EstadoID,						Calle,						NumExterior,
					NumInterior,				CodigoPostal,				ClavePaisNacSTP,				CorreoElectronico,			Identificacion,
					Telefono,					Firma,						IDRespuesta,					DescripcionRespuesta,		NumIntentos,
					Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,				Aud_NumTransaccion
				FROM SPEICUENTASCLABEPFISICA
				WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;


		DELETE FROM SPEICUENTASCLABEPFISICA
			WHERE CuentaClabePFisicaID = Par_CuentaClabePFisicaID;

		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT('Cuentas Clabe registrada en historico correctamente.');
		SET Var_Control := 'cuentaClabe';
		SET Var_Consecutivo := Par_CuentaClabePFisicaID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;/*Enviar siempre en exito el numero de Solicitud*/
	END IF;

END TerminaStore$$ 
