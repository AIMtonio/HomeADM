-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESTAMODOCGRDVALORESVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS PRESTAMODOCGRDVALORESVAL;

DELIMITER $$
CREATE PROCEDURE `PRESTAMODOCGRDVALORESVAL`(
	-- Store Procedure: De Validacion de Prestamo de Documentos de Guarda Valores
	-- Modulo Guarda Valores
	Par_PrestamoDocGrdValoresID		BIGINT(20),		-- ID de tabla
	Par_CatMovimientoID				INT(11),		-- ID de Tabla CATMOVDOCGRDVALORES
	Par_DocumentoID					BIGINT(20),		-- ID de Tabla DOCUMENTOSGRDVALORES
	Par_UsuarioRegistroID			INT(11),		-- Usuario que Registra el Documento a Prestamo
	Par_UsuarioPrestamoID			INT(11),		-- Usuario que Solicita el Documento a Prestamo

	Par_UsuarioAutorizaID			INT(11),		-- Usuario que Autoriza el Documento a Prestamo
	Par_UsuarioDevolucionID			INT(11),		-- Usuario que Devuelve el Documento a Custodia
	Par_Observaciones				VARCHAR(500),	-- Comentarios del Prestamo
	Par_SucursalID					INT(11),		-- Sucursal Origen del Prestamo
	INOUT Par_Control				VARCHAR(100),	-- Variable de Retorno en Pantalla del SP Validacion

	Par_NumeroValidacion			TINYINT UNSIGNED,-- Numero de Validacion

	Par_Salida						CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr				INT(11),		-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID					INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario						INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual					DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP					VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID					VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal					INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion				BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control 				VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_Contrasenia 			VARCHAR(45);	-- Contrasenia del usuario
	DECLARE Var_ClavePuestoID			VARCHAR(10);	-- Clave o Puesto del Usuario que Autoriza
	DECLARE Var_DocumentoID				BIGINT(20);		-- Numero de Documento
	DECLARE Var_PrestamoDocGrdValoresID	BIGINT(20);		-- Numero de Prestamo

	DECLARE Var_CatMovimientoID			INT(11);		-- Tipo de movimiento del catalogo de guarda valores
	DECLARE Var_UsuarioRegistroID		INT(11);		-- Numero de Usuario que Registra el Prestamo
	DECLARE Var_UsuarioPrestamoID		INT(11);		-- Numero de Usuario que Solicita el Prestamo
	DECLARE Var_UsuarioAutorizaID		INT(11);		-- Numero de Usuario que Autoriza el Prestamo

	DECLARE Var_UsuarioDevolucionID		INT(11);		-- Numero de Usuario que Devuelve el Prestamo
	DECLARE Var_SucursalID				INT(11);		-- Numero de Sucursal de Prestamo
	DECLARE Var_PuestoFacultado 		INT(11);		-- Clave o Puesto en Guarda Valores
	DECLARE Var_UsuarioFacultadoID 		INT(11);		-- Usuario Facultado den Guarda Valores
	DECLARE Var_TipoDocumentoID 		INT(11);		-- Tipo de Documento

	DECLARE Var_TipoDocumento 			INT(11);		-- Verificador de que el Documento Puede Prestarse
	DECLARE Var_EstCatMovimiento		CHAR(1);		-- Estatus del Tipo Movimiento
	DECLARE Var_EstDocumento			CHAR(1);		-- Estatus de Documento
	DECLARE Var_EstUsuarioRegistroID	CHAR(1);		-- Estatus del Usuario que Registra el Prestamo
	DECLARE Var_EstUsuarioPrestamoID	CHAR(1);		-- Estatus del Usuario que Solicita el Prestamo

	DECLARE Var_EstUsuarioAutorizaID	CHAR(1);		-- Estatus del Usuario que Autoriza el Prestamo
	DECLARE Var_EstUsuarioDevolucionID	CHAR(1);		-- Estatus del Usuario que Devuelve el Prestamo
	DECLARE Var_EstatusPrestamo			CHAR(1);		-- Estatus de Prestamo|

	-- Declaracion de constantes
	DECLARE Hora_Vacia				TIME;			-- Constante de Hora Vacia
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO

	DECLARE Est_Activo 				CHAR(1);		-- Estatus Activo
	DECLARE Est_Custodia			CHAR(1);		-- Estatus del Documento Custodia
	DECLARE Est_Vigente 			CHAR(1);		-- Estatus Vigente
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Declaracion de Constantes para Validacion
	DECLARE Val_AltaPrestamo		TINYINT UNSIGNED;	-- Validacion 1.- Guarda Valores --> Registro --> Pantalla Administracion Documentos
	DECLARE Val_DevolucionPrestamo	TINYINT UNSIGNED;	-- Validacion 2.- Guarda Valores --> Registro --> Pantalla Administracion Documentos

	-- Asignacion  de constantes
	SET Fecha_Vacia		:= '1900-01-01';
	SET Hora_Vacia		:= '00:00:00';
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET Salida_NO		:= 'N';

	SET Est_Activo		:= 'A';
	SET Est_Custodia	:= 'C';
	SET Est_Vigente		:= 'V';
	SET	Entero_Cero		:= 0;
	SET	Decimal_Cero	:= 0.0;

	SET Var_Control		:= Cadena_Vacia;

	-- Asignacion de Constantes para Validacion
	SET Val_AltaPrestamo		:= 1;
	SET Val_DevolucionPrestamo	:= 2;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PRESTAMODOCGRDVALORESVAL');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion 1.- Guarda Valores --> Registro --> Pantalla Solicitud Prestamo Documentos
		IF( Par_NumeroValidacion = Val_AltaPrestamo ) THEN

			-- Validacion para Catalogo de Movimiento
			IF( IFNULL(Par_CatMovimientoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'El Tipo de Movimiento esta Vacio.';
				SET Var_Control	:= 'catMovimientoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT CatMovimientoID,   Estatus
			INTO Var_CatMovimientoID, Var_EstCatMovimiento
			FROM CATMOVDOCGRDVALORES
			WHERE CatMovimientoID = Par_CatMovimientoID;

			-- Validacion para Catalogo de Movimiento
			IF( IFNULL(Var_CatMovimientoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= CONCAT('El Tipo de Movimiento: ', Par_CatMovimientoID,' No Existe.');
				SET Var_Control	:= 'catMovimientoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para Estatus del Catalogo de  Movimiento
			IF( IFNULL(Var_EstCatMovimiento, Cadena_Vacia) <> Est_Activo ) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= CONCAT('El Tipo de Movimiento: ', Par_CatMovimientoID,' No se Encuentra Activo.');
				SET Var_Control	:= 'catMovimientoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el Numero de Documento
			IF( IFNULL(Par_DocumentoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= 'El Numero de Documento esta Vacio.';
				SET Var_Control	:= 'catMovimientoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT DocumentoID,   Estatus
			INTO Var_DocumentoID, Var_EstDocumento
			FROM DOCUMENTOSGRDVALORES
			WHERE DocumentoID = Par_DocumentoID;

			-- Validacion para el Numero de Documento
			IF( IFNULL(Var_DocumentoID, Entero_Cero)  = Entero_Cero ) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= CONCAT('El Documento : ', Par_DocumentoID,' No Existe.');
				SET Var_Control	:= 'documentoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el Estatus de Numero de Documento
			IF( IFNULL(Var_EstDocumento, Cadena_Vacia) <> Est_Custodia ) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID,' No Esta en Estatus de Custodia.');
				SET Var_Control	:= 'documentoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el usuario de Registro de Prestamo
			IF( IFNULL(Par_UsuarioRegistroID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 007;
				SET Par_ErrMen	:= 'El Usuario de Registro esta Vacio.';
				SET Var_Control	:= 'usuarioRegistroID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT UsuarioID, 			Estatus
			INTO Var_UsuarioRegistroID, Var_EstUsuarioRegistroID
			FROM USUARIOS
			WHERE UsuarioID = Par_UsuarioRegistroID;

			-- Validacion para el Usuario de Registro de Prestamo
			IF( IFNULL(Var_UsuarioRegistroID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 008;
				SET Par_ErrMen	:= CONCAT('El Usuario: ', Par_UsuarioRegistroID,' No Existe.');
				SET Var_Control	:= 'usuarioRegistroID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el Estatus del Usuario de Prestamo
			IF( IFNULL(Var_EstUsuarioRegistroID, Cadena_Vacia) <> Est_Activo ) THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= CONCAT('El Usuario: ', Par_UsuarioRegistroID,' No se Encuentra Activo.');
				SET Var_Control	:= 'usuarioRegistroID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el usuario que Solicita el Prestamo
			IF( IFNULL(Par_UsuarioPrestamoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 010;
				SET Par_ErrMen	:= 'El Usuario de Registro esta Vacio.';
				SET Var_Control	:= 'usuarioPrestamoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT UsuarioID, 			Estatus
			INTO Var_UsuarioPrestamoID, Var_EstUsuarioPrestamoID
			FROM USUARIOS
			WHERE UsuarioID = Par_UsuarioPrestamoID;

			-- Validacion para el Usuario que Solicita el Prestamo
			IF( IFNULL(Var_UsuarioPrestamoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 011;
				SET Par_ErrMen	:= CONCAT('El Usuario de Prestamo: ', Par_UsuarioPrestamoID,' No Existe.');
				SET Var_Control	:= 'usuarioPrestamoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el Estatus del Usuario  que Solicita el Prestamo
			IF( IFNULL(Var_EstUsuarioPrestamoID, Cadena_Vacia) <> Est_Activo ) THEN
				SET Par_NumErr	:= 012;
				SET Par_ErrMen	:= CONCAT('El Usuario de Prestamo: ', Par_UsuarioPrestamoID,' No se Encuentra Activo.');
				SET Var_Control	:= 'usuarioPrestamoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el usuario que Autoriza el Prestamo
			IF( IFNULL(Par_UsuarioAutorizaID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 013;
				SET Par_ErrMen	:= 'El Usuario que Autoriza esta Vacio.';
				SET Var_Control	:= 'usuarioAutorizaID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT UsuarioID, 			Estatus
			INTO Var_UsuarioAutorizaID, Var_EstUsuarioAutorizaID
			FROM USUARIOS
			WHERE UsuarioID = Par_UsuarioAutorizaID;

			-- Validacion para el Usuario que Autoriza el Prestamo
			IF( IFNULL(Var_UsuarioAutorizaID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 014;
				SET Par_ErrMen	:= CONCAT('El Usuario que Autoriza: ',Par_UsuarioAutorizaID,' No Existe.');
				SET Var_Control	:= 'usuarioAutorizaID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el Estatus del Usuario que Autoriza el Prestamo
			IF( IFNULL(Var_EstUsuarioAutorizaID, Cadena_Vacia) <> Est_Activo ) THEN
				SET Par_NumErr	:= 015;
				SET Par_ErrMen	:= CONCAT('El Usuario que Autoriza: ',Par_UsuarioAutorizaID,' no se Encuentra Activo.');
				SET Var_Control	:= 'usuarioAutorizaID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para las Observaciones
			IF( IFNULL(Par_Observaciones, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 016;
				SET Par_ErrMen	:= 'El Motivo de Prestamo esta Vacio.';
				SET Var_Control	:= 'observaciones';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Sucursal
			IF( IFNULL(Par_SucursalID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 016;
				SET Par_ErrMen	:= 'La Sucursal de Prestamo esta Vacia.';
				SET Var_Control	:= 'sucursalID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT SucursalID
			INTO Var_SucursalID
			FROM SUCURSALES
			WHERE SucursalID = Par_SucursalID;

			-- Validacion para la Sucursal
			IF( IFNULL(Var_SucursalID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 017;
				SET Par_ErrMen	:= CONCAT('La Sucursal de Prestamo: ', Par_SucursalID,' No Existe.');
				SET Var_Control	:= 'sucursalID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= 	Entero_Cero;
			SET Par_ErrMen	:= CONCAT('Solicitud de Prestamo Verifica Correctamente.');
			SET Var_Control	:= Cadena_Vacia;
		END IF;

		-- Validacion 2.- Guarda Valores --> Registro --> Pantalla Administracion Documentos
		IF( Par_NumeroValidacion = Val_DevolucionPrestamo ) THEN

			-- Validacion para el Numero de Prestamo
			IF( IFNULL(Par_PrestamoDocGrdValoresID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= CONCAT('El Numero de Prestamo esta Vacio.');
				SET Var_Control	:= 'prestamoDocGrdValoresID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT PrestamoDocGrdValoresID, Estatus
			INTO Var_PrestamoDocGrdValoresID, Var_EstatusPrestamo
			FROM PRESTAMODOCGRDVALORES
			WHERE PrestamoDocGrdValoresID = Par_PrestamoDocGrdValoresID;

			-- Validacion para el Numero de Prestamo
			IF( IFNULL(Var_PrestamoDocGrdValoresID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= CONCAT('El Numero de Prestamo:', Par_PrestamoDocGrdValoresID,' no Existe.');
				SET Var_Control	:= 'prestamoDocGrdValoresID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el Estatus del Usuario que Autoriza el Prestamo
			IF( IFNULL(Var_EstatusPrestamo, Cadena_Vacia) <> Est_Vigente ) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= CONCAT('El Numero de Prestamo:', Par_PrestamoDocGrdValoresID,' esta en un Estatus diferente de Vigente.');
				SET Var_Control	:= 'prestamoDocGrdValoresID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el usuario que Realiza la Devolucion del Prestamo
			IF( IFNULL(Par_UsuarioDevolucionID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= 'El Usuario que realiza la Devolucion esta Vacio.';
				SET Var_Control	:= 'usuarioDevolucionID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT UsuarioID, 			Estatus
			INTO Var_UsuarioDevolucionID, Var_EstUsuarioDevolucionID
			FROM USUARIOS
			WHERE UsuarioID = Par_UsuarioDevolucionID;

			-- Validacion para el usuario que Realiza la Devolucion del Prestamo
			IF( IFNULL(Var_UsuarioDevolucionID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= CONCAT('El Usuario que realiza la Devolucion: ',Par_UsuarioDevolucionID,' No Existe.');
				SET Var_Control	:= 'usuarioDevolucionID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el Estatus del Usuario que Realiza la Devolucion del Prestamo
			IF( IFNULL(Var_EstUsuarioDevolucionID, Cadena_Vacia) <> Est_Activo ) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= CONCAT('El Usuario que realiza la Devolucion: ',Par_UsuarioDevolucionID,' no se Encuentra Activo.');
				SET Var_Control	:= 'usuarioDevolucionID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= 	Entero_Cero;
			SET Par_ErrMen	:= CONCAT('Solicitud de Prestamo Verifica Correctamente.');
			SET Var_Control	:= Cadena_Vacia;
		END IF;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_PrestamoDocGrdValoresID AS Consecutivo;
	END IF;

END TerminaStore$$