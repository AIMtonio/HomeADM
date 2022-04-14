-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCUMENTOSGRDVALORESVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS DOCUMENTOSGRDVALORESVAL;

DELIMITER $$
CREATE PROCEDURE `DOCUMENTOSGRDVALORESVAL`(
	-- Store Procedure: De Validacion de Documentos de Guarda Valores
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
	Par_ClaveUsuario 			VARCHAR(45),	-- Clave de Usuario
	Par_Contrasenia 			VARCHAR(45),	-- Contrasenia de Autorizacion
	INOUT Par_Control			VARCHAR(100),	-- Variable de Retorno en Pantalla del SP Validacion
	Par_NumeroValidacion		TINYINT UNSIGNED,-- Numero de Actualizacion

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
	DECLARE Var_Control					VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE	Var_PuestoFacultado			VARCHAR(10);	-- Variable Puestao Facultado
	DECLARE Var_Contrasenia				VARCHAR(45);	-- Contrasenia del Usuario
	DECLARE Var_ClavePuestoID			VARCHAR(45);	-- Clave Puesto del Usuario

	DECLARE Var_DocumentoID				BIGINT(20);		-- Variable Numero de Documento
	DECLARE Var_PrestamoDocGrdValoresID	BIGINT(20);		-- Variable Numero de Prestamo
	DECLARE Var_NumeroInstrumento		BIGINT(20);		-- Numero de Instrumento

	DECLARE Var_ClienteID				INT(11);		-- Variable Cliente ID
	DECLARE Var_AlmacenID				INT(11);		-- Variable Almacen ID
	DECLARE Var_UsuarioRegistroID		INT(11);		-- Variable Usuario de Registro
	DECLARE Var_UsuarioAutorizaID		INT(11);		-- Variable Usuario de Autorizacion
	DECLARE Var_NumeroPrestamo			INT(11);		-- Variable de Numero de Prestamos
	DECLARE Var_UsuarioFacultadoID		INT(11);		-- Variable de Numero  Usuario Facultado
	DECLARE Var_TipoDocumentoID 		INT(11);		-- Variable de Tipo de Documento
	DECLARE Var_TipoDocumento 			INT(11);		-- Variable de Validacion para Documento Autorizado
	DECLARE Var_SucursalID 				INT(11);		-- Variable de Sucursal
	DECLARE Var_CreditosActivos			INT(11);		-- Creditos Vigentes del Cliente
	DECLARE Var_RealizaConsulta			INT(11);		-- Validador para consulta
	DECLARE Var_TipoInstrumento			INT(11);		-- Numero de Instrumento
	DECLARE Var_UsuarioAdmin			INT(11);		-- Variable Usuario Admon
	DECLARE Var_OrigenDocumento			INT(11);		-- Variable Origen de Documento
	DECLARE Var_EstDocumento			CHAR(1);		-- Variable de Estatus de Documento
	DECLARE Var_EstUsuario				CHAR(1);		-- Variable de Estatus del Usuario
	DECLARE Var_EstPrestamo				CHAR(1);		-- Variable de Estatus del Prestamo
	DECLARE Var_EstUsuarioAutorizaID 	CHAR(1);		-- Variable de Estatus del usuario que Autoriza

		-- Declaracion de Parametros
	DECLARE Par_FechaRegistro		DATE;			-- Fecha de Registro del Documento

	-- Declaracion de constantes
	DECLARE Hora_Vacia				TIME;
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO
	DECLARE Est_Registrado			CHAR(1);		-- Estatus Documento Registrado
	DECLARE Est_Custodia			CHAR(1);		-- Estatus Documento Custodia
	DECLARE Est_Prestamo 			CHAR(1);		-- Estatus Documento Prestamo
	DECLARE Est_Baja				CHAR(1);		-- Estatus Documento Baja
	DECLARE Est_Activo				CHAR(1);		-- Estatus Almacen Activo
	DECLARE Est_Vigente				CHAR(1);		-- Estatus Prestamo Vigente
	DECLARE Est_Finalizado			CHAR(1);		-- Estatus Prestamo Finalizado
	DECLARE Est_Inactivo			CHAR(1);		-- Estatus Credito Inactivo
	DECLARE Est_Pagado				CHAR(1);		-- Estatus Credito Pagado
	DECLARE Est_AvalAutorizado		CHAR(1);		-- Estatus Aval Autorizado
	DECLARE Est_ObliAutorizado		CHAR(1);		-- Estatus Obligado Solidario Autorizado
	DECLARE Est_GarAutorizada		CHAR(1);		-- Estatus Garantia Autorizada
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE InstrumentoCredito		INT(11);		-- Instrumento Credito
	DECLARE Origen_NoAplica			INT(11);		-- Origen no Aplica
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Tipos de Validacion
	DECLARE Val_DocumentoCustodia		TINYINT UNSIGNED;-- Numero de Validacion 1.- Pase Custodia
	DECLARE Val_DocumentoPrestamo		TINYINT UNSIGNED;-- Numero de Validacion 2.- Pase a Prestamo
	DECLARE Val_DocumentoDevolucion		TINYINT UNSIGNED;-- Numero de Validacion 3.- Pase a Devolucion
	DECLARE Val_DocumentoSustitucion	TINYINT UNSIGNED;-- Numero de Validacion 4.- Pase a Sustitucion
	DECLARE Val_DocumentoBaja			TINYINT UNSIGNED;-- Numero de Validacion 5.- Pase a Baja
	DECLARE Val_DocumentoAutorizacion	TINYINT UNSIGNED;-- Numero de Validacion 6.- Autorización de Documentos Prestamo
	DECLARE Val_DocumentoAutoBajaSus	TINYINT UNSIGNED;-- Numero de Validacion 6.- Autorización de Documentos Baja y Sustitucion

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
	SET Est_Activo				:= 'A';
	SET Est_Vigente				:= 'V';
	SET Est_Finalizado			:= 'F';
	SET Est_Inactivo			:= 'I';
	SET Est_Pagado				:= 'P';

	SET Est_AvalAutorizado		:= 'U';
	SET Est_ObliAutorizado		:= 'U';
	SET Est_GarAutorizada		:= 'U';
	SET	Entero_Cero				:= 0;
	SET Origen_NoAplica			:= 3;
	SET InstrumentoCredito		:= 6;
	SET	Decimal_Cero			:= 0.0;

	-- Asignacion de Tipos de Validacion
	SET Val_DocumentoCustodia		:= 1;
	SET Val_DocumentoPrestamo		:= 2;
	SET Val_DocumentoDevolucion		:= 3;
	SET Val_DocumentoSustitucion	:= 4;
	SET Val_DocumentoBaja			:= 5;
	SET Val_DocumentoAutorizacion	:= 6;
	SET Val_DocumentoAutoBajaSus	:= 7;



	-- Asignacion General
	SET Var_Control				:= Cadena_Vacia;
	SELECT IFNULL( FechaSistema, Fecha_Vacia )
	INTO Par_FechaRegistro
	FROM PARAMETROSSIS
	LIMIT 1;

	SELECT UsuarioAdmon
	INTO Var_UsuarioAdmin
	FROM PARAMGUARDAVALORES LIMIT 1;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DOCUMENTOSGRDVALORESVAL');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Bloque de Validacion General para todas las actualizaciones
		-- Validacion para el Numero de Documento
		IF( IFNULL(Par_DocumentoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero de Documento esta Vacio.';
			SET Var_Control	:= 'documentoID';
			SET Par_Control := Var_Control;
			LEAVE ManejoErrores;
		END IF;

		SELECT DocumentoID
		INTO Var_DocumentoID
		FROM DOCUMENTOSGRDVALORES
		WHERE DocumentoID = Par_DocumentoID;

		-- validacion que el Documento existe
		IF( IFNULL(Var_DocumentoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Documento: ',Par_DocumentoID,' No Existe.');
			SET Var_Control	:= 'documentoID';
			SET Par_Control := Var_Control;
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el usuario de Registro
		IF( IFNULL(Par_UsuarioRegistroID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Numero de Usuario esta Vacio.';
			SET Var_Control	:= Cadena_Vacia;
			SET Par_Control := Var_Control;
			LEAVE ManejoErrores;
		END IF;

		SELECT UsuarioID, 			Estatus
		INTO Var_UsuarioRegistroID, Var_EstUsuario
		FROM USUARIOS
		WHERE UsuarioID = Par_UsuarioRegistroID;

		-- Validacion para el usuario de Registro
		IF( IFNULL(Var_UsuarioRegistroID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= CONCAT('El Usuario: ',Par_UsuarioRegistroID,' que Realiza la Operacion No Existe.');
			SET Var_Control	:= Cadena_Vacia;
			SET Par_Control := Var_Control;
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el usuario de Registro
		IF( IFNULL(Var_EstUsuario, Cadena_Vacia) <> Est_Activo ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= CONCAT('El Usuario: ',Par_UsuarioRegistroID,' No se encuentra Activo.');
			SET Var_Control	:= Cadena_Vacia;
			SET Par_Control := Var_Control;
			LEAVE ManejoErrores;
		END IF;
		-- Fin Bloque de Validacion General para todas las actualizaciones

		-- Numero de Validacion 1.- Pase Custodia
		IF( Par_NumeroValidacion = Val_DocumentoCustodia ) THEN

			-- Validacion para el Numero de Almacen
			IF( IFNULL(Par_AlmacenID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= 'El Numero de Almacen esta Vacio.';
				SET Var_Control	:= 'almacenID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT AlmacenID
			INTO Var_AlmacenID
			FROM ALMACENES
			WHERE AlmacenID = Par_AlmacenID
			  AND Estatus = Est_Activo;

			IF( IFNULL(Var_AlmacenID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= CONCAT('El Almacen: ',Par_AlmacenID,' No Existe o esta Inactivo.');
				SET Var_Control	:= 'almacenID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Ubicacion de Documento
			IF( IFNULL(Par_Ubicacion, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 007;
				SET Par_ErrMen	:= CONCAT('La Ubicacion del Documento: ',Par_Ubicacion,' esta Vacia.');
				SET Var_Control	:= 'ubicacion';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Seccion de Documento
			IF( IFNULL(Par_Seccion, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 008;
				SET Par_ErrMen	:= CONCAT('El Cajon, Gabeta o Anaquel del Documento: ',Par_Seccion,' esta Vacio.');
				SET Var_Control	:= 'seccion';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT Estatus
			INTO Var_EstDocumento
			FROM DOCUMENTOSGRDVALORES
			WHERE DocumentoID = Par_DocumentoID;

			-- Validacion para el Estatus del Documento: Si no esta en Estatus Registrado no realiza la operacion
			IF( IFNULL(Var_EstDocumento, Cadena_Vacia) <> Est_Registrado) THEN
				SET Par_NumErr	:= 007;
				SET Par_ErrMen	:= CONCAT('El Documento: ',Par_DocumentoID,' se encuentra en un Estatus diferente de Registrado y no puede pasar a Custodia.');
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Numero de Validacion 2.- Pase a Prestamo
		IF( Par_NumeroValidacion = Val_DocumentoPrestamo ) THEN

			SELECT Estatus
			INTO Var_EstDocumento
			FROM DOCUMENTOSGRDVALORES
			WHERE DocumentoID = Par_DocumentoID;

			-- Validacion para el Estatus del Documento
			IF( IFNULL(Var_EstDocumento, Cadena_Vacia) <> Est_Custodia) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= CONCAT('El Documento: ',Par_DocumentoID,' se encuentra en un Estatus diferente de Custodia y no puede Prestarse.');
				SET Var_Control	:=  'documentoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el usuario de Registro
			IF( IFNULL(Par_UsuarioPrestamoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= 'El Numero de Usuario de Prestamo esta Vacio.';
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT UsuarioID,			Estatus
			INTO Var_UsuarioRegistroID,	Var_EstUsuario
			FROM USUARIOS
			WHERE UsuarioID = Par_UsuarioPrestamoID;

			-- Validacion para el usuario de Prestamo
			IF( IFNULL(Var_UsuarioRegistroID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 007;
				SET Par_ErrMen	:= CONCAT('El Usuario de Prestamo: ',Par_UsuarioPrestamoID,' que Realiza la Operacion No Existe.');
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el usuario de Prestamo
			IF( IFNULL(Var_EstUsuario, Cadena_Vacia) <> Est_Activo ) THEN
				SET Par_NumErr	:= 008;
				SET Par_ErrMen	:= CONCAT('El Usuario de Prestamo: ',Par_UsuarioPrestamoID,' No se encuentra Activo.');
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para Numero de Prestamo usuario de Registro
			IF( IFNULL(Par_PrestamoDocGrdValoresID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= 'El Numero de Usuario de Prestamo esta Vacio.';
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT PrestamoDocGrdValoresID, 	Estatus
			INTO Var_PrestamoDocGrdValoresID, 	Var_EstPrestamo
			FROM PRESTAMODOCGRDVALORES
			WHERE PrestamoDocGrdValoresID = Par_PrestamoDocGrdValoresID
			  AND Estatus = Est_Vigente;

			-- Validacion para el usuario de Prestamo
			IF( IFNULL(Var_PrestamoDocGrdValoresID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 010;
				SET Par_ErrMen	:= CONCAT('El Numero de Prestamo: ',Par_PrestamoDocGrdValoresID,' No Existe.');
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el usuario de Prestamo
			IF( IFNULL(Var_EstPrestamo, Cadena_Vacia) <> Est_Vigente ) THEN
				SET Par_NumErr	:= 011;
				SET Par_ErrMen	:= CONCAT('El Numero de Prestamo: ',Par_PrestamoDocGrdValoresID,' No se encuentra Vigente.');
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT IFNULL(COUNT(PrestamoDocGrdValoresID), Entero_Cero)
			INTO Var_NumeroPrestamo
			FROM DOCUMENTOSGRDVALORES
			WHERE PrestamoDocGrdValoresID = Par_PrestamoDocGrdValoresID
			  AND Estatus = Est_Prestamo;

			-- Validacion para el usuario de Prestamo
			-- El Numero de Prestamos debe ser unico en la tabla de Documentos e irrepetible
			IF( IFNULL(Var_NumeroPrestamo, Cadena_Vacia) <> Entero_Cero ) THEN
				SET Par_NumErr	:= 011;
				SET Par_ErrMen	:= CONCAT('El Numero de Prestamo: ',Par_PrestamoDocGrdValoresID,' Esta asociado a otro Documento.');
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Numero de Validacion 3.- Pase a Devolucion
		IF( Par_NumeroValidacion = Val_DocumentoDevolucion ) THEN

			SELECT Estatus
			INTO Var_EstDocumento
			FROM DOCUMENTOSGRDVALORES
			WHERE DocumentoID = Par_DocumentoID;

			-- Validacion para el Estatus del Documento
			IF( IFNULL(Var_EstDocumento, Cadena_Vacia) <> Est_Prestamo) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= CONCAT('El Documento: ',Par_DocumentoID,' se encuentra en un Estatus diferente de Prestamo y no puede Devolverse.');
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para Numero de Prestamo usuario de Registro
			IF( IFNULL(Par_PrestamoDocGrdValoresID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= 'El Numero de Usuario de Prestamo esta Vacio.';
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT PrestamoDocGrdValoresID, 	Estatus
			INTO Var_PrestamoDocGrdValoresID, 	Var_EstPrestamo
			FROM PRESTAMODOCGRDVALORES
			WHERE PrestamoDocGrdValoresID = Par_PrestamoDocGrdValoresID
			  AND Estatus = Est_Finalizado;

			-- Validacion para el usuario de Prestamo
			IF( IFNULL(Var_PrestamoDocGrdValoresID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 010;
				SET Par_ErrMen	:= CONCAT('El Numero de Prestamo: ',Par_PrestamoDocGrdValoresID,' No Existe.');
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el usuario de Prestamo
			IF( IFNULL(Var_EstPrestamo, Cadena_Vacia) <> Est_Finalizado ) THEN
				SET Par_NumErr	:= 011;
				SET Par_ErrMen	:= CONCAT('El Numero de Prestamo: ',Par_PrestamoDocGrdValoresID,' No se encuentra Finalizado.');
				SET Var_Control	:= Cadena_Vacia;
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Numero de Validacion 4.- Pase a Sustitucion
		IF( Par_NumeroValidacion = Val_DocumentoSustitucion ) THEN

			SELECT Estatus
			INTO Var_EstDocumento
			FROM DOCUMENTOSGRDVALORES
			WHERE DocumentoID = Par_DocumentoID;

			-- Validacion para el Estatus del Documento
			IF( IFNULL(Var_EstDocumento, Cadena_Vacia) <> Est_Custodia) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= CONCAT('El Documento: ',Par_DocumentoID,' se encuentra en un Estatus diferente de Custodia y no puede Sustituirte.');
				SET Var_Control	:= 'documentoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para las Observaciones
			IF( IFNULL(Par_Observaciones, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= 'El Motivo de Sustitucion esta Vacio.';
				SET Var_Control	:= 'observaciones';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Sucursal
			IF( IFNULL(Par_SucursalID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 007;
				SET Par_ErrMen	:= 'El Numero de Sucursal Esta Vacia.';
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
				SET Par_NumErr	:= 008;
				SET Par_ErrMen	:= CONCAT('La Sucursal: ',Par_SucursalID,' No Existe.');
				SET Var_Control	:= 'sucursalID';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Numero de Validacion 5.- Pase a Baja
		IF( Par_NumeroValidacion = Val_DocumentoBaja ) THEN

			SELECT Estatus,			TipoInstrumento,	 NumeroInstrumento
			INTO Var_EstDocumento,	Var_TipoInstrumento, Var_NumeroInstrumento
			FROM DOCUMENTOSGRDVALORES
			WHERE DocumentoID = Par_DocumentoID;

			-- Validacion para el Estatus del Documento
			IF( IFNULL(Var_EstDocumento, Cadena_Vacia) <> Est_Custodia) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= CONCAT('El Documento: ',Par_DocumentoID,' se encuentra en un Estatus diferente de Custodia y no se puede dar de Baja.');
				SET Var_Control	:= 'documentoID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para las Observaciones
			IF( IFNULL(Par_Observaciones, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= 'El Motivo de Sustitucion esta Vacio.';
				SET Var_Control	:= 'observaciones';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Sucursal
			IF( IFNULL(Par_SucursalID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 007;
				SET Par_ErrMen	:= 'El Numero de Sucursal Esta Vacia.';
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
				SET Par_NumErr	:= 008;
				SET Par_ErrMen	:= CONCAT('La Sucursal: ',Par_SucursalID,' No Existe.');
				SET Var_Control	:= 'sucursalID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			IF( Var_TipoInstrumento = InstrumentoCredito) THEN

				SELECT ClienteID
				INTO Var_ClienteID
				FROM CREDITOS
				WHERE CreditoID = Var_NumeroInstrumento;

				SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);

				IF( Var_ClienteID = Entero_Cero ) THEN
					SET Par_NumErr	:= 009;
					SET Par_ErrMen	:= CONCAT('El Credito: ',Var_NumeroInstrumento,' No tiene un Cliente Asignado.');
					SET Var_Control	:= 'numeroInstrumento';
					SET Par_Control := Var_Control;
					LEAVE ManejoErrores;
				END IF;

				-- Creditos Activos del Cliente
				SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);
				SET Var_CreditosActivos := Entero_Cero;

				SELECT IFNULL(COUNT(CreditoID), Entero_Cero)
				INTO Var_CreditosActivos
				FROM CREDITOS
				WHERE ClienteID = Var_ClienteID
				  AND Estatus NOT IN (Est_Inactivo, Est_Pagado);

				IF( Var_CreditosActivos <> Entero_Cero ) THEN
					SET Par_NumErr	:= 010;
					SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID,' asociado al participante: ',Var_ClienteID,'
											   No puede darse de baja, debido a que tiene ',Var_CreditosActivos ,' Creditos Activos.');
					SET Var_Control	:= 'numeroInstrumento';
					SET Par_Control := Var_Control;
					LEAVE ManejoErrores;
				END IF;

				-- Creditos Activos del Cliente
				SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);
				SET Var_CreditosActivos := Entero_Cero;

				SELECT IFNULL(COUNT(CreditoID), Entero_Cero)
				INTO Var_CreditosActivos
				FROM CREDITOSCONT
				WHERE ClienteID = Var_ClienteID
				  AND Estatus NOT IN (Est_Inactivo, Est_Pagado);

				IF( Var_CreditosActivos <> Entero_Cero ) THEN
					SET Par_NumErr	:= 010;
					SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID,' asociado al participante: ',Var_ClienteID,'
											   No puede darse de baja, debido a que tiene ',Var_CreditosActivos ,' Creditos Contigente Activos.');
					SET Var_Control	:= 'numeroInstrumento';
					SET Par_Control := Var_Control;
					LEAVE ManejoErrores;
				END IF;

				-- Creditos Activos del Cliente como Aval
				SET Var_CreditosActivos := Entero_Cero;
				SET Var_RealizaConsulta := Entero_Cero;

				SELECT IFNULL(COUNT(SolicitudCreditoID), Entero_Cero)
				INTO Var_RealizaConsulta
				FROM AVALESPORSOLICI
				WHERE ClienteID = Var_ClienteID AND Estatus = Est_AvalAutorizado;

				IF(Var_RealizaConsulta > Entero_Cero ) THEN
					SELECT IFNULL(COUNT(CreditoID), Entero_Cero)
					INTO Var_CreditosActivos
					FROM CREDITOS
					WHERE SolicitudCreditoID IN (SELECT SolicitudCreditoID FROM AVALESPORSOLICI WHERE ClienteID = Var_ClienteID AND Estatus = Est_AvalAutorizado)
					  AND Estatus NOT IN (Est_Inactivo, Est_Pagado);

					IF( Var_CreditosActivos <> Entero_Cero ) THEN
						SET Par_NumErr	:= 010;
						SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID,' asociado al participante: ',Var_ClienteID,'
												   No puede darse de baja, debido a que tiene ',Var_CreditosActivos ,' Creditos Activos como Aval.');
						SET Var_Control	:= 'numeroInstrumento';
						SET Par_Control := Var_Control;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- Creditos Activos del Cliente como Obligado Solidario
				SET Var_CreditosActivos := Entero_Cero;
				SET Var_RealizaConsulta := Entero_Cero;

				SELECT IFNULL(COUNT(SolicitudCreditoID), Entero_Cero)
				INTO Var_RealizaConsulta
				FROM OBLSOLIDARIOSPORSOLI
				WHERE ClienteID = Var_ClienteID AND Estatus = Est_ObliAutorizado;

				IF(Var_RealizaConsulta > Entero_Cero ) THEN
					SELECT IFNULL(COUNT(CreditoID), Entero_Cero)
					INTO Var_CreditosActivos
					FROM CREDITOS
					WHERE SolicitudCreditoID IN( SELECT SolicitudCreditoID FROM OBLSOLIDARIOSPORSOLI WHERE ClienteID = Var_ClienteID AND Estatus = Est_ObliAutorizado)
					  AND Estatus NOT IN (Est_Inactivo, Est_Pagado);

					IF( Var_CreditosActivos <> Entero_Cero ) THEN
						SET Par_NumErr	:= 011;
						SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID,' asociado al participante: ',Var_ClienteID,'
												   No puede darse de baja, debido a que tiene ',Var_CreditosActivos ,' Creditos Activos como Obligado Solidario.');
						SET Var_Control	:= 'numeroInstrumento';
						SET Par_Control := Var_Control;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- Creditos Activos con Garantia del Cliente
				SET Var_CreditosActivos := Entero_Cero;
				SET Var_RealizaConsulta := Entero_Cero;

				SELECT IFNULL(COUNT(GarantiaID), Entero_Cero)
				INTO Var_RealizaConsulta
				FROM GARANTIAS
				WHERE ClienteID = Var_ClienteID;

				IF(Var_RealizaConsulta > Entero_Cero ) THEN
					SET Var_RealizaConsulta := Entero_Cero;

					SELECT IFNULL(COUNT(CreditoID ), Entero_Cero)
					INTO Var_RealizaConsulta
					FROM ASIGNAGARANTIAS
					WHERE GarantiaID IN (SELECT GarantiaID FROM GARANTIAS WHERE ClienteID = Var_ClienteID)
					   AND CreditoID <> Entero_Cero
					   AND Estatus = Est_GarAutorizada;

					IF( Var_RealizaConsulta > Entero_Cero) THEN

						SELECT IFNULL(COUNT(CreditoID), Entero_Cero)
						INTO Var_CreditosActivos
						FROM CREDITOS
						WHERE CreditoID IN
							(SELECT CreditoID FROM ASIGNAGARANTIAS
							 WHERE GarantiaID IN (SELECT GarantiaID FROM GARANTIAS WHERE ClienteID = Var_ClienteID)
							   AND CreditoID <> Entero_Cero
							   AND Estatus = Est_GarAutorizada)
						  AND Estatus NOT IN (Est_Inactivo, Est_Pagado);

						IF( Var_CreditosActivos <> Entero_Cero ) THEN
							SET Par_NumErr	:= 012;
							SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID,' asociado al participante: ',Var_ClienteID,'
													   No puede darse de baja, debido a que tiene ',Var_CreditosActivos ,' Creditos Activos Amparados por Garantias.');
							SET Var_Control	:= 'numeroInstrumento';
							SET Par_Control := Var_Control;
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

			END IF;
			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Numero de Validacion 6.- Guarda Valores --> Registro --> Pantalla Administracion Documentos
		IF( Par_NumeroValidacion = Val_DocumentoAutorizacion ) THEN

			-- Validacion para el usuario que Autoriza el Prestamo
			IF( IFNULL(Par_ClaveUsuario, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'La Clave de Usuario esta Vacia.';
				SET Var_Control	:= 'usuarioAutorizaID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT UsuarioID, 			Estatus,				  Contrasenia,	   ClavePuestoID
			INTO Var_UsuarioAutorizaID, Var_EstUsuarioAutorizaID, Var_Contrasenia, Var_ClavePuestoID
			FROM USUARIOS
			WHERE Clave = Par_ClaveUsuario;

			-- Validacion para el Usuario que Autoriza el Prestamo
			IF( IFNULL(Var_UsuarioAutorizaID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= CONCAT('El Usuario  que Autoriza No Existe.');
				SET Var_Control	:= 'usuarioAutorizaID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el Estatus del Usuario que Autoriza el Prestamo
			IF( IFNULL(Var_EstUsuarioAutorizaID, Cadena_Vacia) <> Est_Activo ) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= CONCAT('El Usuario de Autoriza No se Encuentra Activo.');
				SET Var_Control	:= 'usuarioAutorizaID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Contrasenia
			IF( IFNULL(Par_Contrasenia, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= 'La Contraseña esta Vacia.';
				SET Var_Control	:= 'contrasenia';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Contrasenia
			IF( IFNULL(Var_Contrasenia, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= 'La Contraseña esta Vacia.';
				SET Var_Control	:= 'contrasenia';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Contrasenia
			IF( Var_Contrasenia <> Par_Contrasenia ) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= 'La Contraseña de Autorizacion no es correcta.';
				SET Var_Control	:= 'contrasenia';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Si el Usuario que autoriza es el Administrador No se Evalua
			IF(Var_UsuarioAdmin <> Var_UsuarioAutorizaID) THEN

				SELECT IFNULL(COUNT(PuestoFacultado), Entero_Cero)
				INTO Var_PuestoFacultado
				FROM USRGUARDAVALORES
				WHERE PuestoFacultado = Var_ClavePuestoID;

				-- Si la Clave o Puesto del Usuario que Autoriza no esta Parametrizado
				-- Se consulta Si es una usuario Especial
				IF( Var_PuestoFacultado = Entero_Cero ) THEN

					SELECT IFNULL(COUNT(UsuarioFacultadoID), Entero_Cero)
					INTO Var_UsuarioFacultadoID
					FROM USRGUARDAVALORES
					WHERE UsuarioFacultadoID = Var_UsuarioAutorizaID;

					-- Si el Usuario que Autoriza no esta Parametrizado no se Autoriza el Prestamo
					IF( Var_UsuarioFacultadoID = Entero_Cero ) THEN
						SET Par_NumErr	:= 007;
						SET Par_ErrMen	:= 'El Usuario que Autoriza No cuenta con los Permisos para Realizar la Operacion.';
						SET Var_Control	:= 'usuarioAutorizaID';
						SET Par_Control := Var_Control;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;


			-- Tipo de Documento
			SELECT TipoDocumentoID,		OrigenDocumento
			INTO Var_TipoDocumentoID,	Var_OrigenDocumento
			FROM DOCUMENTOSGRDVALORES
			WHERE DocumentoID = Par_DocumentoID;

			IF( IFNULL( Var_OrigenDocumento, Entero_Cero) <> Origen_NoAplica) THEN

				SET Var_TipoDocumentoID := IFNULL(Var_TipoDocumentoID, Entero_Cero);

				SELECT IFNULL(COUNT(DocumentoID), Entero_Cero)
				INTO Var_TipoDocumento
				FROM DOCGUARDAVALORES
				WHERE DocumentoID = Var_TipoDocumentoID;

				-- Si el Documento no esta Parametrizado No se Autoriza el Prestamo
				IF( Var_TipoDocumento = Entero_Cero ) THEN
					SET Par_NumErr	:= 008;
					SET Par_ErrMen	:= 'El Tipo de Documento No esta Parametrizado para esta Operacion.';
					SET Var_Control	:= 'tipoDocumentoID';
					SET Par_Control := Var_Control;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_UsuarioRegistroID = Var_UsuarioAutorizaID) THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= 'El usuario que realiza la operacion y el usuario que autoriza no puede ser el mismo.';
				SET Var_Control	:= 'claveUsuario';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;

			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('La Autorizacion es Correcta.');
			SET Var_Control	:= Cadena_Vacia;
		END IF;

		-- Numero de Validacion 6.- Guarda Valores --> Registro --> Pantalla Administracion Documentos
		IF( Par_NumeroValidacion = Val_DocumentoAutoBajaSus ) THEN

			-- Validacion para el usuario que Autoriza el Prestamo
			IF( IFNULL(Par_ClaveUsuario, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'La Clave de Usuario esta Vacia.';
				SET Var_Control	:= 'usuarioAutorizaID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SELECT UsuarioID, 			Estatus,				  Contrasenia,	   ClavePuestoID
			INTO Var_UsuarioAutorizaID, Var_EstUsuarioAutorizaID, Var_Contrasenia, Var_ClavePuestoID
			FROM USUARIOS
			WHERE Clave = Par_ClaveUsuario;

			-- Validacion para el Usuario que Autoriza el Prestamo
			IF( IFNULL(Var_UsuarioAutorizaID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= CONCAT('El Usuario  que Autoriza No Existe.');
				SET Var_Control	:= 'usuarioAutorizaID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el Estatus del Usuario que Autoriza el Prestamo
			IF( IFNULL(Var_EstUsuarioAutorizaID, Cadena_Vacia) <> Est_Activo ) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= CONCAT('El Usuario de Autoriza No se Encuentra Activo.');
				SET Var_Control	:= 'usuarioAutorizaID';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Contrasenia
			IF( IFNULL(Par_Contrasenia, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= 'La Contraseña esta Vacia.';
				SET Var_Control	:= 'contrasenia';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Contrasenia
			IF( IFNULL(Var_Contrasenia, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= 'La Contraseña esta Vacia.';
				SET Var_Control	:= 'contrasenia';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la Contrasenia
			IF( Var_Contrasenia <> Par_Contrasenia ) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= 'La Contraseña de Autorizacion no es correcta.';
				SET Var_Control	:= 'contrasenia';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			-- Si el Usuario que autoriza es el Administrador No se Evalua
			IF(Var_UsuarioAdmin <> Var_UsuarioAutorizaID) THEN

				SELECT IFNULL(COUNT(PuestoFacultado), Entero_Cero)
				INTO Var_PuestoFacultado
				FROM USRGUARDAVALORES
				WHERE PuestoFacultado = Var_ClavePuestoID;

				-- Si la Clave o Puesto del Usuario que Autoriza no esta Parametrizado
				-- Se consulta Si es una usuario Especial
				IF( Var_PuestoFacultado = Entero_Cero ) THEN

					SELECT IFNULL(COUNT(UsuarioFacultadoID), Entero_Cero)
					INTO Var_UsuarioFacultadoID
					FROM USRGUARDAVALORES
					WHERE UsuarioFacultadoID = Var_UsuarioAutorizaID;

					-- Si el Usuario que Autoriza no esta Parametrizado no se Autoriza el Prestamo
					IF( Var_UsuarioFacultadoID = Entero_Cero ) THEN
						SET Par_NumErr	:= 007;
						SET Par_ErrMen	:= 'El Usuario que Autoriza No cuenta con los Permisos para Realizar la Operacion.';
						SET Var_Control	:= 'usuarioAutorizaID';
						SET Par_Control := Var_Control;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF(Par_UsuarioRegistroID = Var_UsuarioAutorizaID) THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= 'El usuario que realiza la operacion y el usuario que autoriza no puede ser el mismo.';
				SET Var_Control	:= 'claveUsuario';
				SET Par_Control := Var_Control;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('La Autorizacion es Correcta.');
			SET Var_Control	:= Cadena_Vacia;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID, ' se Valido Correctamente.');
		SET Var_Control	:= 'documentoID';
		SET Par_Control := Var_Control;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_DocumentoID AS Consecutivo;
	END IF;

END TerminaStore$$