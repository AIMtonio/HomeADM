-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCUMENTOSGRDVALORESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS DOCUMENTOSGRDVALORESALT;

DELIMITER $$
CREATE PROCEDURE `DOCUMENTOSGRDVALORESALT`(
	-- Store Procedure: De Alta de Documentos de Guarda Valores
	-- Modulo Guarda Valores
	Par_NumeroExpedienteID		BIGINT(20),		-- ID de tabla EXPEDIENTEGRDVALORES
	Par_TipoInstrumento			INT(11),		-- Tipo de Intrumento \n1.- Cliente \n2.- Cuenta Ahorro \n3.- CEDE \n 4.- INVERSION
												-- \n5.- Solicitud Credito \n6.- Credito \n7. Prospecto \n8.- Aportaciones
	Par_NumeroInstrumento		BIGINT(20),		-- ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, CreditoID, SolicitudCreditoID, ProspectoID, AportacionID
	Par_OrigenDocumento			INT(11),		-- ID de Tabla CATORIGENESDOCUMENTOS
	Par_GrupoDocumentoID		INT(11),		-- Grupo de Documento

	Par_TipoDocumentoID			INT(11),		-- Tipo de Documento
	Par_NombreDocumento			VARCHAR(100),	-- Nombre de Documento en caso de que No Aplique
	Par_UsuarioRegistroID		INT(11),		-- Usuario que Registra el Documento
	Par_SucursalID				INT(11),		-- ID de Sucursal
	Par_ArchivoID				BIGINT(20),		-- Numero de Archivo

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
	DECLARE Var_Mensaje				VARCHAR(500);	-- Variable de Mensaje de Alta
	DECLARE Var_NombreOrigen 		VARCHAR(50);	-- Variable Nombre de Origen
	DECLARE Var_DescripcionGpo 		VARCHAR(100);	-- Variable Descripcion del Grupo de Documento
	DECLARE Var_DescripcionDoc 		VARCHAR(60);	-- Variable Descripcion del Documento

	DECLARE Var_NumeroInstrumento	BIGINT(20);		-- Variable Numero de Instrumento
	DECLARE Var_NumeroExpedienteID	BIGINT(20);		-- Variable Numero de Expediente
	DECLARE Var_DocumentoID 		BIGINT(20);		-- Variable de Numero de Documento

	DECLARE Var_SucursalID			INT(11);		-- Variable Sucursal ID
	DECLARE Var_UsuarioRegistro		INT(11);		-- Variable Usuario de Registro
	DECLARE Var_TipoInstrumentoID	INT(11);		-- Variable Catalogo de Instrumentos
	DECLARE Var_TipoDocumentoID		INT(11);		-- Tipo de Documento
	DECLARE Var_GrupoDocumentoID	INT(11);		-- Grupo de Documentos
	DECLARE Var_CatOrigenDocumentoID INT(11);		-- Origen de Documento

		-- Declaracion de Parametros
	DECLARE Par_DocumentoID			BIGINT(20);		-- ID de Tabla
	DECLARE Par_FechaRegistro		DATE;			-- Fecha de Registro del Documento
	DECLARE Par_HoraRegistro		TIME;			-- Hora de Registro del Documento
	DECLARE Par_TipoPersona			CHAR(1);		-- Tipo Persona \nC = Cliente, \nP=Prospecto \nE= Empresa Nomina o Institucion \nP= o Proveedor
	DECLARE Par_ParticipanteID		BIGINT(20);		-- Numero de Participante

	-- Catalogo de Instrumentos
	DECLARE Inst_Cliente			INT(11);			-- Instrumento cliente
	DECLARE Inst_CuentaAho			INT(11);			-- Instrumento Cuenta de Ahorro
	DECLARE Inst_Cede				INT(11);			-- Instrumento CEDE
	DECLARE Inst_Inversion			INT(11);			-- Instrumento Inversion
	DECLARE Inst_SolicitudCredito	INT(11);			-- Instrumento Solicitud de Credito
	DECLARE Inst_Credito			INT(11);			-- Instrumento Credito
	DECLARE Inst_Prospecto			INT(11);			-- Instrumento Prospecto
	DECLARE Inst_Aportacion			INT(11);			-- Instrumento Aportacion

	-- Declaracion de constantes
	DECLARE Hora_Vacia				TIME;
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO
	DECLARE Est_Registrado			CHAR(1);		-- Estatus Registrado
	DECLARE Est_Baja				CHAR(1);		-- Estatus Baja
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE Origen_Check 			INT(11);		-- Origen Check List
	DECLARE Origen_Digital			INT(11);		-- Origen Digitalizacion
	DECLARE Origen_NoAplica			INT(11);		-- Origen no Aplica
	DECLARE Ope_Participante		TINYINT UNSIGNED;-- Numero de Operacion para obtener el ID del participante
	DECLARE Ope_Instrumento			TINYINT UNSIGNED;-- Numero de Operacion para obtener el ID del Instrumento
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Catalogo de Instrumentos
	SET Inst_Cliente			:= 1;
	SET Inst_CuentaAho			:= 2;
	SET Inst_Cede				:= 3;
	SET Inst_Inversion			:= 4;
	SET Inst_SolicitudCredito	:= 5;
	SET Inst_Credito			:= 6;
	SET Inst_Prospecto			:= 7;
	SET Inst_Aportacion			:= 8;

	-- Asignacion  de constantes
	SET Hora_Vacia			:= '00:00:00';
	SET Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';
	SET	Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Est_Registrado		:= 'R';
	SET Est_Baja			:= 'B';
	SET	Entero_Cero			:= 0;
	SET Origen_Check 		:= 1;
	SET Origen_Digital		:= 2;
	SET Origen_NoAplica		:= 3;
	SET Ope_Participante	:= 1;
	SET Ope_Instrumento		:= 2;
	SET	Decimal_Cero		:= 0.0;
	SET Var_Control			:= Cadena_Vacia;
	SET Aud_FechaActual		:= NOW();

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DOCUMENTOSGRDVALORESALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el Numero de Expediente
		IF( IFNULL(Par_NumeroExpedienteID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El numero de Expediente esta Vacio.';
			SET Var_Control	:= 'numeroExpedienteID';
			LEAVE ManejoErrores;
		END IF;

		SELECT NumeroExpedienteID
		INTO Var_NumeroExpedienteID
		FROM EXPEDIENTEGRDVALORES
		WHERE NumeroExpedienteID = Par_NumeroExpedienteID;

		IF( IFNULL(Var_NumeroExpedienteID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Expediente: ',Par_NumeroExpedienteID,' No Existe.');
			SET Var_Control	:= 'numeroExpedienteID';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el Tipo de Instrumento
		IF( IFNULL(Par_TipoInstrumento, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Tipo de Instrumento esta Vacio.';
			SET Var_Control	:= 'tipoInstrumento';
			LEAVE ManejoErrores;
		END IF;

		SELECT CatInsGrdValoresID
		INTO Var_TipoInstrumentoID
		FROM CATINSTGRDVALORES
		WHERE CatInsGrdValoresID = Par_TipoInstrumento;

		IF( IFNULL(Var_TipoInstrumentoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= CONCAT('El Tipo de Instrumento: ',Par_TipoInstrumento,' No Existe.');
			SET Var_Control	:= 'tipoInstrumento';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el Numero de Instrumento
		IF( IFNULL(Par_NumeroInstrumento, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= 'El Numero de Instrumento esta Vacio.';
			SET Var_Control	:= 'numeroInstrumento';
			LEAVE ManejoErrores;
		END IF;

		SET Var_NumeroInstrumento := IFNULL(FNPARTICIPANTEGRDVALORES(Par_TipoInstrumento,Par_NumeroInstrumento, Ope_Instrumento), Entero_Cero);
		SET Par_ParticipanteID 	  := IFNULL(FNPARTICIPANTEGRDVALORES(Par_TipoInstrumento,Par_NumeroInstrumento, Ope_Participante), Entero_Cero);
		SET Par_TipoPersona 	  := FNTIPOPARTICIPANTEGRDVALORES(Par_TipoInstrumento,Par_NumeroInstrumento);

		IF( Var_NumeroInstrumento = Entero_Cero ) THEN
			SET Par_NumErr	:= 006;
			SET Par_ErrMen	:= 'El Numero de Instrumento No Existe.';
			SET Var_Control	:= 'numeroInstrumento';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ParticipanteID = Entero_Cero ) THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen	:= 'El Participante No Existe o Esta Vacio.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para la Sucursal
		IF( IFNULL(Par_SucursalID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen	:= 'El Numero de Sucursal Esta Vacia.';
			SET Var_Control	:= 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		SELECT SucursalID
		INTO Var_SucursalID
		FROM SUCURSALES
		WHERE SucursalID = Par_SucursalID;

		-- Validacion para la Sucursal
		IF( IFNULL(Var_SucursalID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 009;
			SET Par_ErrMen	:= CONCAT('La Sucursal: ',Par_SucursalID,' No Existe.');
			SET Var_Control	:= 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el usuario de Registro
		IF( IFNULL(Par_UsuarioRegistroID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 010;
			SET Par_ErrMen	:= 'El Numero de Usuario esta Vacio.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SELECT UsuarioID
		INTO Var_UsuarioRegistro
		FROM USUARIOS
		WHERE UsuarioID = Par_UsuarioRegistroID;

		-- Validacion para el usuario de Registro
		IF( IFNULL(Var_UsuarioRegistro, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 011;
			SET Par_ErrMen	:= CONCAT('El Usuario: ',Par_UsuarioRegistroID,' que Registra No Existe.');
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoPersona = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 012;
			SET Par_ErrMen	:= 'El Tipo de Persona esta Vacio.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_OrigenDocumento, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:= 013;
			SET Par_ErrMen	:= 'El Origen del Documento esta Vacio.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SELECT CatOrigenDocumentoID,	NombreOrigen
		INTO Var_CatOrigenDocumentoID,	Var_NombreOrigen
		FROM CATORIGENESDOCUMENTOS
		WHERE CatOrigenDocumentoID = Par_OrigenDocumento;

		-- Validacion para el usuario de Registro
		IF( IFNULL(Var_CatOrigenDocumentoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 013;
			SET Par_ErrMen	:= CONCAT('El Origen: ',Par_UsuarioRegistroID,' No Existe.');
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SET Par_ArchivoID 		:= IFNULL(Par_ArchivoID, Entero_Cero);
		-- Validaciones para el origen por check list
		IF( Par_OrigenDocumento = Origen_Check ) THEN

			IF( Par_TipoInstrumento IN (Inst_SolicitudCredito, Inst_Credito)) THEN

				IF( IFNULL(Par_GrupoDocumentoID, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr	:= 014;
					SET Par_ErrMen	:= 'El Grupo del Documento esta Vacio.';
					SET Var_Control	:= Cadena_Vacia;
					LEAVE ManejoErrores;
				END IF;

				SELECT ClasificaTipDocID,	ClasificaDesc
				INTO Var_GrupoDocumentoID,	Var_DescripcionGpo
				FROM CLASIFICATIPDOC
				WHERE ClasificaTipDocID = Par_GrupoDocumentoID;

				IF( IFNULL(Var_GrupoDocumentoID, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr	:= 015;
					SET Par_ErrMen	:= 'El Grupo de Documentos No Existe.';
					SET Var_Control	:= Cadena_Vacia;
					LEAVE ManejoErrores;
				END IF;

			ELSE
				IF( IFNULL(Par_GrupoDocumentoID, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr	:= 014;
					SET Par_ErrMen	:= 'El Grupo del Documento esta Vacio.';
					SET Var_Control	:= Cadena_Vacia;
					LEAVE ManejoErrores;
				END IF;

				SELECT GrupoDocumentoID,	Descripcion
				INTO Var_GrupoDocumentoID,	Var_DescripcionGpo
				FROM GRUPODOCUMENTOS
				WHERE GrupoDocumentoID = Par_GrupoDocumentoID;

				IF( IFNULL(Var_GrupoDocumentoID, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr	:= 015;
					SET Par_ErrMen	:= 'El Grupo de Documentos No Existe.';
					SET Var_Control	:= Cadena_Vacia;
					LEAVE ManejoErrores;
				END IF;

			END IF;

			IF( IFNULL(Par_TipoDocumentoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 016;
				SET Par_ErrMen	:= 'El Tipo de Documento esta Vacio.';
				SET Var_Control	:= Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;

			SELECT TipoDocumentoID,		Descripcion
			INTO Var_TipoDocumentoID,	Var_DescripcionDoc
			FROM TIPOSDOCUMENTOS
			WHERE TipoDocumentoID = Par_TipoDocumentoID;

			IF( IFNULL(Var_TipoDocumentoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 017;
				SET Par_ErrMen	:= 'El Tipo de Documento No Existe.';
				SET Var_Control	:= Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;

			SELECT DocumentoID
			INTO  Var_DocumentoID
			FROM DOCUMENTOSGRDVALORES
			WHERE TipoInstrumento = Par_TipoInstrumento
			  AND NumeroInstrumento = Par_NumeroInstrumento
			  AND OrigenDocumento = Par_OrigenDocumento
			  AND GrupoDocumentoID = Par_GrupoDocumentoID
			  AND TipoDocumentoID = Par_TipoDocumentoID
			  AND ParticipanteID = Par_ParticipanteID
			  AND TipoPersona = Par_TipoPersona
			  AND Estatus <> Est_Baja;

			SET Var_DocumentoID := IFNULL(Var_DocumentoID, Entero_Cero);

			IF( Var_DocumentoID <> Entero_Cero ) THEN
				SET Var_NombreOrigen 	:= IFNULL(Var_NombreOrigen,   Cadena_Vacia);
				SET Var_DescripcionGpo 	:= IFNULL(Var_DescripcionGpo, Cadena_Vacia);
				SET Var_DescripcionDoc 	:= IFNULL(Var_DescripcionDoc, Cadena_Vacia);
					SET Par_ErrMen := CONCAT('El Siguiente Documento ya esta capturado o repetido:<br>',
											 'Origen: <b>', Var_NombreOrigen,'</b><br>',
											 'Tipo Documento: <b>', Var_DescripcionGpo,'</b><br>',
											 'Documento: <b>', Var_DescripcionDoc,'</b><br>',
											 'No. Instrumento: <b>',Par_NumeroInstrumento,'</b>');
				SET Par_NumErr	:= 018;
				SET Var_Control	:= Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NombreDocumento := Cadena_Vacia;
		END IF;

		-- Validaciones para el origen por Digitalizacion
		IF( Par_OrigenDocumento = Origen_Digital ) THEN

			IF( IFNULL(Par_TipoDocumentoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 016;
				SET Par_ErrMen	:= 'El Tipo de Documento esta Vacio.';
				SET Var_Control	:= Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;

			SELECT TipoDocumentoID,		Descripcion
			INTO Var_TipoDocumentoID,	Var_DescripcionDoc
			FROM TIPOSDOCUMENTOS
			WHERE TipoDocumentoID = Par_TipoDocumentoID;

			IF( IFNULL(Var_TipoDocumentoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 017;
				SET Par_ErrMen	:= 'El Tipo de Documento No Existe.';
				SET Var_Control	:= Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoInstrumento IN (Inst_Cliente, Inst_CuentaAho, Inst_SolicitudCredito, Inst_Credito)) THEN

				SELECT DocumentoID
				INTO  Var_DocumentoID
				FROM DOCUMENTOSGRDVALORES
				WHERE TipoInstrumento = Par_TipoInstrumento
				  AND NumeroInstrumento = Par_NumeroInstrumento
				  AND OrigenDocumento = Par_OrigenDocumento
				  AND GrupoDocumentoID = Par_GrupoDocumentoID
				  AND TipoDocumentoID = Par_TipoDocumentoID
				  AND ParticipanteID = Par_ParticipanteID
				  AND TipoPersona = Par_TipoPersona
				  AND ArchivoID = Par_ArchivoID;

				SET Var_DocumentoID := IFNULL(Var_DocumentoID, Entero_Cero);

				IF( Var_DocumentoID <> Entero_Cero ) THEN
					SET Var_NombreOrigen 	:= IFNULL(Var_NombreOrigen,   Cadena_Vacia);
					SET Var_DescripcionGpo 	:= IFNULL(Var_DescripcionGpo, Cadena_Vacia);
					SET Var_DescripcionDoc 	:= IFNULL(Var_DescripcionDoc, Cadena_Vacia);
					SET Par_ErrMen := CONCAT('El Siguiente Documento ya esta capturado o repetido:<br>',
											 'Documento: <b>', Var_DescripcionDoc,'</b><br>',
											 'Origen: <b>', Var_NombreOrigen,'</b><br>',
											 'No. Instrumento: <b>',Par_NumeroInstrumento,'</b><br>',
											 'No. Archivo: <b>',Par_ArchivoID,'</b>');
					SET Par_NumErr	:= 018;
					SET Var_Control	:= Cadena_Vacia;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Par_NombreDocumento  := Cadena_Vacia;
			SET Par_GrupoDocumentoID := Entero_Cero;
		END IF;

		-- Validaciones para el origen por No Aplica
		IF( Par_OrigenDocumento = Origen_NoAplica ) THEN

			IF( IFNULL(Par_NombreDocumento, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 018;
				SET Par_ErrMen	:= 'El Grupo del Documento esta Vacio.';
				SET Var_Control	:= Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;

			SET Par_TipoDocumentoID  := Entero_Cero;
			SET Par_GrupoDocumentoID := Entero_Cero;
		END IF;

		SELECT IFNULL( FechaSistema, Fecha_Vacia )
		INTO Par_FechaRegistro
		FROM PARAMETROSSIS
		LIMIT 1;

		SET Par_HoraRegistro := IFNULL(TIME(NOW()), Hora_Vacia);

		CALL FOLIOSAPLICAACT('DOCUMENTOSGRDVALORES', Par_DocumentoID);
		SET Var_Mensaje := CONCAT('REGISTRO DE DOCUMENTO.');

		INSERT INTO DOCUMENTOSGRDVALORES (
			DocumentoID,			NumeroExpedienteID,		TipoInstrumento,		NumeroInstrumento,		OrigenDocumento,
			GrupoDocumentoID,		TipoDocumentoID,		NombreDocumento,		ParticipanteID,			TipoPersona,
			AlmacenID,				Ubicacion,				Seccion,				Observaciones,			Estatus,
			UsuarioRegistroID,		UsuarioProcesaID,		SucursalID,				FechaRegistro,			HoraRegistro,
			FechaCustodia,			UsuarioBajaID,			SucursalBajaID,			FechaBaja,				PrestamoDocGrdValoresID,
			DocSustitucionID,		NombreDocSustitucion,	ArchivoID,
			EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion)
		VALUES(
			Par_DocumentoID,		Par_NumeroExpedienteID,	Par_TipoInstrumento,	Par_NumeroInstrumento,	Par_OrigenDocumento,
			Par_GrupoDocumentoID,	Par_TipoDocumentoID,	Par_NombreDocumento,	Par_ParticipanteID,		Par_TipoPersona,
			Entero_Cero,			Cadena_Vacia,			Cadena_Vacia,			Var_Mensaje,			Est_Registrado,
			Par_UsuarioRegistroID,	Entero_Cero,			Par_SucursalID,			Par_FechaRegistro,		Par_HoraRegistro,
			Fecha_Vacia,			Entero_Cero,			Entero_Cero,			Fecha_Vacia,			Entero_Cero,
			Entero_Cero,			Cadena_Vacia,			Par_ArchivoID,
			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		-- Alta de Bitacora por cambio de Estatus
		CALL BITACORADOCGRDVALORESALT(
			Par_DocumentoID,	Par_UsuarioRegistroID,	Entero_Cero,		Est_Registrado,		Est_Registrado,
			Var_Mensaje,		Salida_NO,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID,' se ha Registrado Correctamente.');
		SET Var_Control	:= 'documentoID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_DocumentoID AS Consecutivo;
	END IF;

END TerminaStore$$