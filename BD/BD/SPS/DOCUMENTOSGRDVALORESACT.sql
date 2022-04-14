-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCUMENTOSGRDVALORESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS DOCUMENTOSGRDVALORESACT;

DELIMITER $$
CREATE PROCEDURE `DOCUMENTOSGRDVALORESACT`(
	-- Store Procedure: De Actualizacion de Documentos de Guarda Valores
	-- Modulo Guarda Valores
	Par_DocumentoID 			BIGINT(20),		-- ID de tabla
	Par_AlmacenID				INT(11),		-- ID de Almacen
	Par_Ubicacion				VARCHAR(500),	-- Ubicacion del Documento
	Par_Seccion					VARCHAR(500),	-- Seccion/Anaquel/Cajon de Ubicacion del Documento
	Par_Observaciones			VARCHAR(500),	-- Comentarios del Documento

	Par_UsuarioRegistroID		INT(11),		-- Usuario que Realiza la Operacion del Documento
	Par_UsuarioPrestamoID		INT(11),		-- Usuario que Solicita el Prestamo del Documento
	Par_PrestamoDocGrdValoresID	BIGINT(20),		-- ID de tabla PRESTAMODOCGRDVALORES
	Par_SucursalID				INT(11),		-- ID de tabla SUCURSALES
	Par_DocSustitucionID		INT(11),		-- Tipo de Documento de sustitucion

	Par_NombreDocSustitucion	VARCHAR(100),	-- Nombre de Documento de sustitucion
	Par_ArchivoID 				BIGINT(20),		-- Numeor de Archivo
	Par_NumeroActualizacion		TINYINT UNSIGNED,-- Numero de Actualizacion

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_ControlValidacion	VARCHAR(100);	-- Variable de Retorno en Pantalla del SP Validacion
	DECLARE Var_DocumentoID			BIGINT(20);		-- Variable Numero de Documento
	DECLARE Var_AlmacenID			INT(11);		-- Variable Almacen ID
	DECLARE Var_UsuarioRegistroID	INT(11);		-- Variable Usuario de Registro

		-- Declaracion de Parametros
	DECLARE Par_FechaRegistro		DATE;			-- Fecha de Registro del Documento

	-- Declaracion de constantes
	DECLARE Hora_Vacia				TIME;
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO
	DECLARE Est_Registrado			CHAR(1);		-- Estatus Registrado
	DECLARE Est_Custodia			CHAR(1);		-- Estatus Custodia
	DECLARE Est_Prestamo 			CHAR(1);		-- Estatus Prestamo
	DECLARE Est_Baja				CHAR(1);		-- Estatus Baja
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Tipos de Actualizacion
	DECLARE Act_DocumentoCustodia		TINYINT UNSIGNED;-- Numero de Actualizacion 1.- Pase a Custodia(Est_Registrado --> Est_Custodia)
	DECLARE Act_DocumentoPrestamo		TINYINT UNSIGNED;-- Numero de Actualizacion 2.- Pase a Prestamo(Est_Custodia --> Est_Prestamo)
	DECLARE Act_DocumentoDevolucion		TINYINT UNSIGNED;-- Numero de Actualizacion 3.- Pase a Prestamo(Est_Prestamo --> Est_Custodia)
	DECLARE Act_DocumentoSustitucion	TINYINT UNSIGNED;-- Numero de Actualizacion 4.- Sustitucion de Documento (Est_Custodia --> Baja)
	DECLARE Act_DocumentoBaja			TINYINT UNSIGNED;-- Numero de Actualizacion 5.- Sustitucion de Documento (Est_Custodia --> Baja)

	-- Tipos de Validacion
	DECLARE Val_DocumentoCustodia		TINYINT UNSIGNED;-- Numero de Validacion 1.- Pase a Custodia
	DECLARE Val_DocumentoPrestamo		TINYINT UNSIGNED;-- Numero de Validacion 2.- Pase a Prestamo
	DECLARE Val_DocumentoDevolucion		TINYINT UNSIGNED;-- Numero de Validacion 3.- Pase a Devolucion
	DECLARE Val_DocumentoSustitucion	TINYINT UNSIGNED;-- Numero de Validacion 4.- Pase a Baja
	DECLARE Val_DocumentoBaja			TINYINT UNSIGNED;-- Numero de Validacion 5.- Pase a Baja
	DECLARE Val_DocumentoAutorizacion	TINYINT UNSIGNED;-- Numero de Validacion 6.- Autorización Baja

	-- Asignacion  de constantes
	SET Hora_Vacia				:= '00:00:00';
	SET Fecha_Vacia				:= '1900-01-01';
	SET	Cadena_Vacia			:= '';
	SET	Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';
	SET Est_Registrado			:= 'R';
	SET Est_Custodia 			:= 'C';
	SET Est_Prestamo			:= 'P';
	SET Est_Baja				:= 'B';
	SET	Entero_Cero				:= 0;
	SET	Decimal_Cero			:= 0.0;

	-- Asignacion de Tipos de Actualizacion
	SET Act_DocumentoCustodia		:= 1;
	SET Act_DocumentoPrestamo		:= 2;
	SET Act_DocumentoDevolucion		:= 3;
	SET Act_DocumentoSustitucion	:= 4;
	SET Act_DocumentoBaja 			:= 5;

	-- Asignacion de Tipos de Validacion
	SET Val_DocumentoCustodia		:= 1;
	SET Val_DocumentoPrestamo		:= 2;
	SET Val_DocumentoDevolucion		:= 3;
	SET Val_DocumentoSustitucion	:= 4;
	SET Val_DocumentoBaja			:= 5;
	SET Val_DocumentoAutorizacion	:= 6;

	-- Asignacion General
	SET Var_Control				:= Cadena_Vacia;
	SET Par_Observaciones		:= IFNULL(Par_Observaciones, Cadena_Vacia);
	SELECT IFNULL( FechaSistema, Fecha_Vacia )
	INTO Par_FechaRegistro
	FROM PARAMETROSSIS
	LIMIT 1;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DOCUMENTOSGRDVALORESACT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Numero de Actualizacion 1.- Pase a Custodia(Est_Registrado --> Est_Custodia)
		IF( Par_NumeroActualizacion = Act_DocumentoCustodia ) THEN

			-- Validacion de Actualizacion
			CALL DOCUMENTOSGRDVALORESVAL(
				Par_DocumentoID,		Par_AlmacenID,		Par_Ubicacion,		Par_Seccion,			Entero_Cero,
				Par_UsuarioRegistroID,	Entero_Cero,		Entero_Cero,		Entero_Cero,			Entero_Cero,
				Cadena_Vacia,			Cadena_Vacia,		Cadena_Vacia,		Var_ControlValidacion,	Val_DocumentoCustodia,
				Salida_NO,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Var_Control := Var_ControlValidacion;
				LEAVE ManejoErrores;
			END IF;

			SET Par_Observaciones := UPPER(CONCAT('EL DOCUMENTO: ', Par_DocumentoID,' PASO A CUSTODIA EL DIA ',FNFECHATEXTO(Par_FechaRegistro),'.'));
			SET Aud_FechaActual		:= NOW();

			UPDATE DOCUMENTOSGRDVALORES SET
				AlmacenID		= Par_AlmacenID,
				Ubicacion		= Par_Ubicacion,
				Seccion			= Par_Seccion,
				Observaciones	= Par_Observaciones,
				Estatus			= Est_Custodia,
				FechaCustodia	= Par_FechaRegistro,
				UsuarioProcesaID= Par_UsuarioRegistroID,
				EmpresaID 		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE DocumentoID = Par_DocumentoID;

			CALL BITACORADOCGRDVALORESALT(
				Par_DocumentoID,	Par_UsuarioRegistroID,	Entero_Cero,		Est_Registrado,		Est_Custodia,
				Par_Observaciones,	Salida_NO,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID, ' ha pasado a Custodia Exitosamente.');
			SET Var_Control	:= 'tipoInstrumento';
		END IF;

		-- Numero de Actualizacion 2.- Pase a Prestamo(Est_Custodia --> Est_Prestamo)
		IF( Par_NumeroActualizacion = Act_DocumentoPrestamo ) THEN

			-- Validacion de Actualizacion
			CALL DOCUMENTOSGRDVALORESVAL(
				Par_DocumentoID,		Entero_Cero,			Cadena_Vacia,				Cadena_Vacia,			Par_Observaciones,
				Par_UsuarioRegistroID,	Par_UsuarioPrestamoID,	Par_PrestamoDocGrdValoresID,Entero_Cero,			Entero_Cero,
				Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,				Var_ControlValidacion,	Act_DocumentoPrestamo,
				Salida_NO,				Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,			Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Var_Control := Var_ControlValidacion;
				LEAVE ManejoErrores;
			END IF;

			SET Aud_FechaActual	:= NOW();

			UPDATE DOCUMENTOSGRDVALORES SET
				Observaciones			= Par_Observaciones,
				Estatus					= Est_Prestamo,
				PrestamoDocGrdValoresID = Par_PrestamoDocGrdValoresID,
				EmpresaID 				= Aud_EmpresaID,
				Usuario					= Aud_Usuario,
				FechaActual				= Aud_FechaActual,
				DireccionIP				= Aud_DireccionIP,
				ProgramaID				= Aud_ProgramaID,
				Sucursal				= Aud_Sucursal,
				NumTransaccion			= Aud_NumTransaccion
			WHERE DocumentoID = Par_DocumentoID;

			CALL BITACORADOCGRDVALORESALT(
				Par_DocumentoID,	Par_UsuarioRegistroID,	Par_UsuarioPrestamoID,	Est_Custodia,		Est_Prestamo,
				Par_Observaciones,	Salida_NO,				Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID, ' ha prestado Exitosamente.');
			SET Var_Control	:= 'documentoID';
		END IF;

		-- Numero de Actualizacion 3.- Pase a Custodia(Est_Prestamo --> Est_Custodia)
		IF( Par_NumeroActualizacion = Act_DocumentoDevolucion ) THEN

			-- Validacion de Actualizacion
			CALL DOCUMENTOSGRDVALORESVAL(
				Par_DocumentoID,		Entero_Cero,			Cadena_Vacia,					Cadena_Vacia,			Par_Observaciones,
				Par_UsuarioRegistroID,	Entero_Cero,			Par_PrestamoDocGrdValoresID,	Entero_Cero,			Entero_Cero,
				Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,					Var_ControlValidacion,	Val_DocumentoDevolucion,
				Salida_NO,				Par_NumErr,				Par_ErrMen,						Aud_EmpresaID,			Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,			Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Var_Control := Var_ControlValidacion;
				LEAVE ManejoErrores;
			END IF;

			SET Par_Observaciones := IFNULL(Par_Observaciones, Cadena_Vacia);
			SET Aud_FechaActual	:= NOW();

			UPDATE DOCUMENTOSGRDVALORES SET
				Observaciones			= Par_Observaciones,
				Estatus					= Est_Custodia,
				PrestamoDocGrdValoresID = Entero_Cero,
				EmpresaID 				= Aud_EmpresaID,
				Usuario					= Aud_Usuario,
				FechaActual				= Aud_FechaActual,
				DireccionIP				= Aud_DireccionIP,
				ProgramaID				= Aud_ProgramaID,
				Sucursal				= Aud_Sucursal,
				NumTransaccion			= Aud_NumTransaccion
			WHERE DocumentoID = Par_DocumentoID;

			CALL BITACORADOCGRDVALORESALT(
				Par_DocumentoID,	Par_UsuarioRegistroID,	Entero_Cero,		Est_Prestamo,		Est_Custodia,
				Par_Observaciones,	Salida_NO,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('La Devolución del Documento: ', Par_DocumentoID, ' Se ha realizado Correctamente.');
			SET Var_Control	:= 'documentoID';
		END IF;

		-- Numero de Actualizacion 4.- Sustitucion de Documento (Est_Custodia --> Baja)
		IF( Par_NumeroActualizacion = Act_DocumentoSustitucion ) THEN

			-- Validacion de Actualizacion
			CALL DOCUMENTOSGRDVALORESVAL(
				Par_DocumentoID,			Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,			Par_Observaciones,
				Par_UsuarioRegistroID,		Entero_Cero,		Entero_Cero, 		Par_SucursalID,			Par_DocSustitucionID,
				Par_NombreDocSustitucion,	Cadena_Vacia,		Cadena_Vacia,		Var_ControlValidacion,	Val_DocumentoSustitucion,
				Salida_NO,					Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,
				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Var_Control := Var_ControlValidacion;
				LEAVE ManejoErrores;
			END IF;

			SET Par_Observaciones 		 := IFNULL(Par_Observaciones, Cadena_Vacia);
			SET Par_DocSustitucionID 	 := IFNULL(Par_DocSustitucionID, Entero_Cero);
			SET Par_NombreDocSustitucion := IFNULL(Par_NombreDocSustitucion, Cadena_Vacia);
			SET Aud_FechaActual	:= NOW();

			UPDATE DOCUMENTOSGRDVALORES SET
				Observaciones		 = Par_Observaciones,
				Estatus				 = Est_Baja,
				UsuarioBajaID		 = Par_UsuarioRegistroID,
				SucursalBajaID		 = Par_SucursalID,
				FechaBaja			 = Par_FechaRegistro,
				DocSustitucionID	 = Par_DocSustitucionID,
				NombreDocSustitucion = Par_NombreDocSustitucion,
				EmpresaID 			 = Aud_EmpresaID,
				Usuario				 = Aud_Usuario,
				FechaActual			 = Aud_FechaActual,
				DireccionIP			 = Aud_DireccionIP,
				ProgramaID			 = Aud_ProgramaID,
				Sucursal			 = Aud_Sucursal,
				NumTransaccion		 = Aud_NumTransaccion
			WHERE DocumentoID = Par_DocumentoID;

			CALL BITACORADOCGRDVALORESALT(
				Par_DocumentoID,	Par_UsuarioRegistroID,	Entero_Cero,		Est_Custodia,		Est_Baja,
				Par_Observaciones,	Salida_NO,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL DOCUMENTOSGRDVALORESPRO(
				Par_DocumentoID,	Par_UsuarioRegistroID,	Par_DocSustitucionID,	Par_NombreDocSustitucion,	Par_ArchivoID,
				Salida_NO,			Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,				Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('La Sustitucion del Documento: ', Par_DocumentoID, ' Se ha realizado Correctamente.');
			SET Var_Control	:= 'documentoID';
		END IF;

		-- Numero de Actualizacion 5.- Baja de Documento (Est_Custodia --> Baja)
		IF( Par_NumeroActualizacion = Act_DocumentoBaja ) THEN

			-- Validacion de Actualizacion
			CALL DOCUMENTOSGRDVALORESVAL(
				Par_DocumentoID,			Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,			Par_Observaciones,
				Par_UsuarioRegistroID,		Entero_Cero,		Entero_Cero, 		Par_SucursalID,			Par_DocSustitucionID,
				Par_NombreDocSustitucion,	Cadena_Vacia,		Cadena_Vacia,		Var_ControlValidacion,	Val_DocumentoBaja,
				Salida_NO,					Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,
				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Var_Control := Var_ControlValidacion;
				LEAVE ManejoErrores;
			END IF;

			SET Par_Observaciones := IFNULL(Par_Observaciones, Cadena_Vacia);
			SET Aud_FechaActual	:= NOW();

			UPDATE DOCUMENTOSGRDVALORES SET
				Observaciones		 = Par_Observaciones,
				Estatus				 = Est_Baja,
				UsuarioBajaID		 = Par_UsuarioRegistroID,
				SucursalBajaID		 = Par_SucursalID,
				FechaBaja			 = Par_FechaRegistro,
				EmpresaID 			 = Aud_EmpresaID,
				Usuario				 = Aud_Usuario,
				FechaActual			 = Aud_FechaActual,
				DireccionIP			 = Aud_DireccionIP,
				ProgramaID			 = Aud_ProgramaID,
				Sucursal			 = Aud_Sucursal,
				NumTransaccion		 = Aud_NumTransaccion
			WHERE DocumentoID = Par_DocumentoID;

			CALL BITACORADOCGRDVALORESALT(
				Par_DocumentoID,	Par_UsuarioRegistroID,	Entero_Cero,		Est_Custodia,		Est_Baja,
				Par_Observaciones,	Salida_NO,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('La Baja del Documento: ', Par_DocumentoID, ' Se ha realizado Correctamente.');
			SET Var_Control	:= 'documentoID';
		END IF;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_DocumentoID AS Consecutivo;
	END IF;

END TerminaStore$$