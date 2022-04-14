-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCUMENTOSGRDVALORESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS DOCUMENTOSGRDVALORESPRO;

DELIMITER $$
CREATE PROCEDURE `DOCUMENTOSGRDVALORESPRO`(
	-- Store Procedure: De Proceso de Documentos de Guarda Valores para la sustitucion de documentos
	-- Modulo Guarda Valores
	Par_DocumentoID				BIGINT(20),		-- ID de tabla
	Par_UsuarioRegistroID		INT(11),		-- Usuario que Realiza la Operacion del Documento
	Par_DocSustitucionID		INT(11),		-- Tipo de Documento de sustitucion
	Par_NombreDocSustitucion	VARCHAR(100),	-- Nombre de Documento de sustitucion
	Par_ArchivoID 				BIGINT(20),		-- ID de Archivo

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

		-- Declaracion de Parametros
	DECLARE Par_FechaRegistro		DATE;			-- Fecha de Registro del Documento
	DECLARE Par_NumeroInstrumento	BIGINT(20);		-- ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, CreditoID, SolicitudCreditoID, ProspectoID, AportacionID
	DECLARE Par_NumeroExpedienteID	BIGINT(20);		-- ID de tabla EXPEDIENTEGRDVALORES
	DECLARE Par_TipoInstrumento		INT(11);		-- Tipo de Intrumento
	DECLARE Par_OrigenDocumento		INT(11);		-- ID de Tabla CATORIGENESDOCUMENTOS

	DECLARE Par_GrupoDocumentoID	INT(11);		-- Grupo de Documento
	DECLARE Par_SucursalID			INT(11);		-- ID de Sucursal
	DECLARE Par_AlmacenID			INT(11);		-- ID de Almacen
	DECLARE Par_Ubicacion			VARCHAR(500);	-- Ubicacion del Documento
	DECLARE Par_Seccion				VARCHAR(500);	-- Seccion	 del Documento
	DECLARE Par_Observaciones		VARCHAR(500);	-- Observacion del Documento

	-- Declaracion de constantes
	DECLARE Hora_Vacia				TIME;			-- Constante de hora Vacia
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO

	DECLARE Est_Registrado			CHAR(1);		-- Estatus Registrado
	DECLARE Est_Custodia			CHAR(1);		-- Estatus Custodia
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
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Var_Control			:= Cadena_Vacia;

	SELECT FechaSistema
	INTO Par_FechaRegistro
	FROM PARAMETROSSIS
	LIMIT 1;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DOCUMENTOSGRDVALORESPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Se obtiene lso Datos del Documento
		SELECT	NumeroExpedienteID,		TipoInstrumento,		NumeroInstrumento,		AlmacenID,		Ubicacion,
				OrigenDocumento,		GrupoDocumentoID,		SucursalID,				Seccion
		INTO	Par_NumeroExpedienteID,	Par_TipoInstrumento,	Par_NumeroInstrumento,	Par_AlmacenID,	Par_Ubicacion,
				Par_OrigenDocumento,	Par_GrupoDocumentoID,	Par_SucursalID,			Par_Seccion
		FROM DOCUMENTOSGRDVALORES
		WHERE DocumentoID = Par_DocumentoID;

		-- Se registra el Documento
		SET Aud_FechaActual		:= NOW();
		CALL DOCUMENTOSGRDVALORESALT(
			Par_NumeroExpedienteID,		Par_TipoInstrumento,		Par_NumeroInstrumento,	Par_OrigenDocumento,	Par_GrupoDocumentoID,
			Par_DocSustitucionID,		Par_NombreDocSustitucion,	Par_UsuarioRegistroID,	Par_SucursalID,			Par_ArchivoID,
			Salida_NO,					Par_NumErr,					Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Asignacion de Comentarios
		SET Par_Observaciones := UPPER(CONCAT('PASE A CUSTODIA AUTOMATICO POR SUSTITUCION DEL DOCUMENTO: ', Par_DocumentoID, ' DIA ',FNFECHATEXTO(Par_FechaRegistro),'.'));
		SET Aud_FechaActual		:= NOW();
		SET Par_DocumentoID := Entero_Cero;

		-- Obtenemos el ID del Documento Nuevo
		SELECT DocumentoID
		INTO Par_DocumentoID
		FROM DOCUMENTOSGRDVALORES
		WHERE NumTransaccion = Aud_NumTransaccion
		ORDER BY DocumentoID DESC
		LIMIT 1;

		-- Se realiza el Pase a Custodia
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


		SET Aud_FechaActual		:= NOW();
		CALL BITACORADOCGRDVALORESALT(
			Par_DocumentoID,	Par_UsuarioRegistroID,	Entero_Cero,			Est_Registrado,		Est_Custodia,
			Par_Observaciones,	Salida_NO,				Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('El Documento: ', Par_DocumentoID,' se sustituyo Correctamente.');
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