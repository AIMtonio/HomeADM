-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXPEDIENTEGRDVALORESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS EXPEDIENTEGRDVALORESALT;

DELIMITER $$
CREATE PROCEDURE `EXPEDIENTEGRDVALORESALT`(
	-- Store Procedure: De Alta del Expediente de Guarda Valores
	-- Modulo Guarda Valores
	Par_TipoInstrumento			INT(11),		-- Tipo de Intrumento \n1.- Cliente \n7. Prospecto
	Par_NumeroInstrumento		BIGINT(20),		-- ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, CreditoID, SolicitudCreditoID, ProspectoID, AportacionID
	Par_UsuarioRegistroID		INT(11),		-- Usuario que Registra el Expediente
	Par_SucursalID				INT(11),		-- ID de Sucursal

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
	DECLARE Var_NumeroInstrumento	BIGINT(20);		-- Variable Numero de Instrumento
	DECLARE Var_ExpedienteID 		BIGINT(20);		-- Variable Numero de Instrumento
	DECLARE Var_SucursalID			INT(11);		-- Variable Sucursal ID
	DECLARE Var_UsuarioRegistro		INT(11);		-- Variable Usuario de Registro
	DECLARE Var_TipoInstrumentoID	INT(11);		-- Variable Catalogo de Instrumentos

		-- Declaracion de Parametros
	DECLARE Par_NumeroExpedienteID	BIGINT(20);		-- ID de Tabla
	DECLARE Par_FechaRegistro		DATE;			-- Fecha de Registro del Documento
	DECLARE Par_HoraRegistro		TIME;			-- Hora de Registro del Documento
	DECLARE Par_TipoPersona			CHAR(1);		-- Tipo Persona \nC = Cliente, \nP=Prospecto \nE= Empresa Nomina o Institucion \nP= o Proveedor
	DECLARE Par_ParticipanteID		BIGINT(20);		-- Numero de Participante

	-- Declaracion de constantes
	DECLARE Hora_Vacia				TIME;
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO
	DECLARE Est_Activo				CHAR(1);		-- Estatus Activo
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE Ope_Participante		TINYINT UNSIGNED;-- Numero de Operacion para obtener el ID del participante
	DECLARE Ope_Instrumento			TINYINT UNSIGNED;-- Numero de Operacion para obtener el ID del Instrumento
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Asignacion  de constantes
	SET Hora_Vacia			:= '00:00:00';
	SET Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';
	SET	Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Est_Activo			:= 'A';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Ope_Participante	:= 1;
	SET Ope_Instrumento		:= 2;
	SET Var_Control			:= Cadena_Vacia;
	SET Aud_FechaActual		:= NOW();

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-EXPEDIENTEGRDVALORESALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el Tipo de Instrumento
		IF( IFNULL(Par_TipoInstrumento, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Tipo de Instrumento esta Vacio.';
			SET Var_Control	:= 'tipoInstrumento';
			LEAVE ManejoErrores;
		END IF;

		SELECT CatInsGrdValoresID
		INTO Var_TipoInstrumentoID
		FROM CATINSTGRDVALORES
		WHERE CatInsGrdValoresID = Par_TipoInstrumento;

		IF( IFNULL(Var_TipoInstrumentoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Tipo de Instrumento: ',Par_TipoInstrumento,' No Existe.');
			SET Var_Control	:= 'tipoInstrumento';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el Numero de Instrumento
		IF( IFNULL(Par_NumeroInstrumento, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Numero de Instrumento esta Vacio.';
			SET Var_Control	:= 'numeroInstrumento';
			LEAVE ManejoErrores;
		END IF;

		SET Var_NumeroInstrumento := IFNULL(FNPARTICIPANTEGRDVALORES(Par_TipoInstrumento,Par_NumeroInstrumento, Ope_Instrumento), Entero_Cero);
		SET Par_ParticipanteID 	  := IFNULL(FNPARTICIPANTEGRDVALORES(Par_TipoInstrumento,Par_NumeroInstrumento, Ope_Participante), Entero_Cero);
		SET Par_TipoPersona 	  := FNTIPOPARTICIPANTEGRDVALORES(Par_TipoInstrumento,Par_NumeroInstrumento);

		IF( Var_NumeroInstrumento = Entero_Cero ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= 'El Numero de Instrumento No Existe.';
			SET Var_Control	:= 'numeroInstrumento';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ParticipanteID = Entero_Cero ) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= 'El Participante No Existe o Esta Vacio.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;


		-- Inicio Documentos en Guarda Valores
		-- Verifco que existe el expediente
		SELECT NumeroExpedienteID
		INTO Var_ExpedienteID
		FROM EXPEDIENTEGRDVALORES
		WHERE TipoInstrumento = Par_TipoInstrumento
		  AND NumeroInstrumento = Par_NumeroInstrumento
		  AND ParticipanteID = Par_ParticipanteID
		  AND TipoPersona = Par_TipoPersona
		  AND SucursalID = Par_SucursalID;

		SET Var_ExpedienteID := IFNULL(Var_ExpedienteID, Entero_Cero);

		-- Si el Expediente es
		IF(Var_ExpedienteID > Entero_Cero) THEN
			SET Par_NumeroExpedienteID := Var_ExpedienteID;
			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= 'El Expediente Registrado Correctamente.';
			SET Var_Control	:= 'numeroExpedienteID';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para la Sucursal
		IF( IFNULL(Par_SucursalID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 006;
			SET Par_ErrMen	:= 'El Numero de Sucursal esta Vacio.';
			SET Var_Control	:= 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		SELECT SucursalID
		INTO Var_SucursalID
		FROM SUCURSALES
		WHERE SucursalID = Par_SucursalID;

		-- Validacion para la Sucursal
		IF( IFNULL(Var_SucursalID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen	:= CONCAT('La Sucursal: ', Par_SucursalID,' No Existe.');
			SET Var_Control	:= 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el usuario de Registro
		IF( IFNULL(Par_UsuarioRegistroID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen	:= 'El Usuario esta Vacio.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SELECT UsuarioID
		INTO Var_UsuarioRegistro
		FROM USUARIOS
		WHERE UsuarioID = Par_UsuarioRegistroID;

		-- Validacion para el usuario de Registro
		IF( IFNULL(Var_UsuarioRegistro, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 009;
			SET Par_ErrMen	:= CONCAT('El Usuario: ',Par_UsuarioRegistroID,' que Registra No Existe.');
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoPersona = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 010;
			SET Par_ErrMen	:= 'El Tipo de Persona esta Vacio.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL( FechaSistema, Fecha_Vacia )
		INTO Par_FechaRegistro
		FROM PARAMETROSSIS
		LIMIT 1;

		SET Par_HoraRegistro := IFNULL(TIME(NOW()), Hora_Vacia);

		CALL FOLIOSAPLICAACT('EXPEDIENTEGRDVALORES', Par_NumeroExpedienteID);

		INSERT INTO EXPEDIENTEGRDVALORES (
			NumeroExpedienteID,		TipoInstrumento,		SucursalID,				FechaRegistro,			NumeroInstrumento,
			HoraRegistro,			ParticipanteID,			TipoPersona,			UsuarioRegistroID,		Estatus,
			EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion)
		VALUES(
			Par_NumeroExpedienteID,	Par_TipoInstrumento,	Par_SucursalID,			Par_FechaRegistro,		Par_NumeroInstrumento,
			Par_HoraRegistro,		Par_ParticipanteID,		Par_TipoPersona,		Par_UsuarioRegistroID,	Est_Activo,
			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Expediente Registrado Correctamente.';
		SET Var_Control	:= 'numeroExpedienteID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_NumeroExpedienteID AS Consecutivo;
	END IF;

END TerminaStore$$