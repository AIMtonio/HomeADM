-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORADOCGRDVALORESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS BITACORADOCGRDVALORESALT;

DELIMITER $$
CREATE PROCEDURE `BITACORADOCGRDVALORESALT`(
	-- Store Procedure: De Alta en la Bitacora de Guarda Valores
	-- Modulo Guarda Valores
	Par_DocumentoID				BIGINT(20),		-- ID de tabla DOCUMENTOSGRDVALORES
	Par_UsuarioRegistroID		INT(11),		-- Usuario que Registra la Modificacion del Documento
	Par_UsuarioPrestamoID		INT(11),		-- Usuario que Solicita el Prestamo del Documento
	Par_EstatusPrevio			CHAR(1),		-- Estatus Previo del Documento \nR = Registrado \nC= Custodia \nP=  Préstamo \nB= Baja, D=Demanda.
	Par_EstatusActual			CHAR(1),		-- Estatus Actual del Documento \nR = Registrado \nC= Custodia \nP=  Préstamo \nB= Baja, D=Demanda.

	Par_Observaciones			VARCHAR(500),	-- Observaciones del Cambio de estatus

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
	DECLARE Var_DocumentoID			BIGINT(20);		-- Variable Numero de DocumentoID
	DECLARE Var_UsuarioRegistro		INT(11);		-- Variable Usuario de Registro
	DECLARE Var_UsuarioPrestamoID	INT(11);		-- Variable Usuario de Prestamo
	DECLARE Var_EstUsuario			CHAR(1);		-- Variable de Estatus del Usuario

		-- Declaracion de Parametros
	DECLARE Par_BitacoraDocGrdValoresID	BIGINT(20);		-- ID de Tabla
	DECLARE Par_FechaRegistro			DATE;			-- Fecha de Registro del Documento
	DECLARE Par_HoraRegistro			TIME;			-- Hora de Registro del Documento

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
	DECLARE Est_Activo				CHAR(1);		-- Estatus Usuario Activo
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Asignacion  de constantes
	SET Hora_Vacia			:= '00:00:00';
	SET Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';
	SET	Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Est_Registrado		:= 'R';
	SET Est_Custodia 		:= 'C';
	SET Est_Prestamo		:= 'P';
	SET Est_Baja			:= 'B';
	SET Est_Activo			:= 'A';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Var_Control			:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACORADOCGRDVALORESALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el Numero de Documento
		IF( IFNULL(Par_DocumentoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El numero de Documento esta Vacio.';
			SET Var_Control	:= 'documentoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT DocumentoID
		INTO Var_DocumentoID
		FROM DOCUMENTOSGRDVALORES
		WHERE DocumentoID = Par_DocumentoID;

		IF( IFNULL(Var_DocumentoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Documento: ',Par_DocumentoID,' No Existe.');
			SET Var_Control	:= 'documentoID';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el usuario de Registro
		IF( IFNULL(Par_UsuarioRegistroID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Usuario que Registra Esta Vacio.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SELECT UsuarioID
		INTO Var_UsuarioRegistro
		FROM USUARIOS
		WHERE UsuarioID = Par_UsuarioRegistroID;

		-- Validacion para el usuario de Registro
		IF( IFNULL(Var_UsuarioRegistro, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= CONCAT('El Usuario: ', Par_UsuarioRegistroID,' que Registra No Existe.');
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SET Par_UsuarioPrestamoID := IFNULL(Par_UsuarioPrestamoID, Entero_Cero);
		SET Par_EstatusPrevio	  := IFNULL(Par_EstatusPrevio, Cadena_Vacia);
		SET Par_EstatusActual	  := IFNULL(Par_EstatusActual, Cadena_Vacia);
		SET Par_Observaciones	  := IFNULL(Par_Observaciones, Cadena_Vacia);

		-- Validaciones para el origen por check list
		IF( Par_UsuarioPrestamoID <> Entero_Cero ) THEN

			-- Validacion para el usuario de Prestamo
			SELECT UsuarioID,			Estatus
			INTO Var_UsuarioPrestamoID,	Var_EstUsuario
			FROM USUARIOS
			WHERE UsuarioID = Par_UsuarioPrestamoID;

			-- Validacion para el usuario de Prestamo
			IF( IFNULL(Var_UsuarioPrestamoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= CONCAT('El Usuario: ', Par_UsuarioPrestamoID ,' de Prestamo No Existe.');
				SET Var_Control	:= Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el usuario de Prestamo
			IF( IFNULL(Var_EstUsuario, Cadena_Vacia) <> Est_Activo ) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= CONCAT('El Usuario de Prestamo: ',Par_UsuarioPrestamoID,' No se encuentra Activo.');
				SET Var_Control	:= Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Validaciones para el Estatus Previo del Documento
		IF( Par_EstatusPrevio NOT IN (Est_Registrado, Est_Custodia, Est_Prestamo, Est_Baja) ) THEN
			SET Par_NumErr	:= 006;
			SET Par_ErrMen	:= CONCAT('El Estatus Previo del Documento: ', Par_DocumentoID,' no es Valido.');
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		-- Validaciones para el Estatus Actual del Documento
		IF( Par_EstatusActual NOT IN (Est_Registrado, Est_Custodia, Est_Prestamo, Est_Baja) ) THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen	:= CONCAT('El Estatus Actual del Documento: ', Par_DocumentoID,' no es Valido.');
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL( FechaSistema, Fecha_Vacia )
		INTO Par_FechaRegistro
		FROM PARAMETROSSIS
		LIMIT 1;

		SET Par_HoraRegistro := IFNULL(TIME(NOW()), Hora_Vacia);

		CALL FOLIOSAPLICAACT('BITACORADOCGRDVALORES', Par_BitacoraDocGrdValoresID);
		SET Aud_FechaActual		:= NOW();

		INSERT INTO BITACORADOCGRDVALORES (
			BitacoraDocGrdValoresID,		DocumentoID,			FechaRegistro,			HoraRegistro,		UsuarioRegistroID,
			UsuarioPrestamoID,				EstatusPrevio,			EstatusActual,			Observaciones,		EmpresaID,
			Usuario,						FechaActual,			DireccionIP,			ProgramaID,			Sucursal,
			NumTransaccion)
		VALUES(
			Par_BitacoraDocGrdValoresID,	Par_DocumentoID,		Par_FechaRegistro,		Par_HoraRegistro,	Par_UsuarioRegistroID,
			Par_UsuarioPrestamoID,			Par_EstatusPrevio,		Par_EstatusActual,		Par_Observaciones,	Aud_EmpresaID,
			Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Bitacora de Documento: ', Par_DocumentoID,' Registrada Correctamente.');
		SET Var_Control	:= 'documentoID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_BitacoraDocGrdValoresID AS Consecutivo;
	END IF;

END TerminaStore$$