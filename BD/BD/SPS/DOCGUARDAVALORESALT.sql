-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCGUARDAVALORESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS DOCGUARDAVALORESALT;

DELIMITER $$
CREATE PROCEDURE `DOCGUARDAVALORESALT`(
	-- Store Procedure: De alta los parametros del menu de Guarda Valores
	-- Modulo Guarda Valores
	Par_ParamGuardaValoresID	INT(11),		-- ID de Tabla PARAMGUARDAVALORES
	Par_DocumentoID				INT(11),		-- ID de Tabla TIPOSDOCUMENTOS

	Par_Salida					CHAR(1), 		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr			INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen			VARCHAR(400),	-- Parametro de salida mensaje de error

	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Par_DocGuardaValoresID		INT(11);		-- Numero de Pametro
	DECLARE Var_DocumentoID				INT(11);		-- Numero de Documento
	DECLARE Var_TipoDocumentoID			INT(11);		-- Numero de Documento en la tabla TIPOSDOCUMENTOS
	DECLARE Var_Control					VARCHAR(100);	-- Variable de Retorno en Pantalla

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia				CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI					CHAR(1);		-- Constante de Salida SI
	DECLARE	Entero_Cero					INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno					INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero				DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET Var_Control		:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-DOCGUARDAVALORESALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		IF( IFNULL(Par_ParamGuardaValoresID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Numero Unico de Guarda Valores esta vacio';
			SET Var_Control := 'paramGuardaValoresID';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_DocumentoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'Ingrese un Tipo de Documento';
			SET Var_Control := 'documentoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT TipoDocumentoID
		INTO Var_TipoDocumentoID
		FROM TIPOSDOCUMENTOS
		WHERE TipoDocumentoID = Par_DocumentoID;
		SET Var_TipoDocumentoID := IFNULL(Var_TipoDocumentoID, Entero_Cero);

		IF( Var_TipoDocumentoID = Entero_Cero ) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := CONCAT('El Numero de Documento ',Par_DocumentoID,' no Existe en el Catalogo de Documentos');
			SET Var_Control := 'documentoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(COUNT(DocumentoID), Entero_Cero)
		INTO Var_DocumentoID
		FROM DOCGUARDAVALORES
		WHERE ParamGuardaValoresID = Par_ParamGuardaValoresID
		  AND DocumentoID = Par_DocumentoID;

		IF( Var_DocumentoID > Entero_Cero ) THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := CONCAT('El Numero de Documento ',Par_DocumentoID,' ya existe en la configuracion de Guarda Valores');
			SET Var_Control := 'documentoID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		SELECT IFNULL(MAX(DocGuardaValoresID), Entero_Cero) + Entero_Uno
		INTO Par_DocGuardaValoresID
		FROM DOCGUARDAVALORES;

		INSERT INTO DOCGUARDAVALORES (
			DocGuardaValoresID,			ParamGuardaValoresID,		DocumentoID,		EmpresaID,		Usuario,
			FechaActual,				DireccionIP,				ProgramaID,			Sucursal,		NumTransaccion)
		VALUES(
			Par_DocGuardaValoresID,		Par_ParamGuardaValoresID,	Par_DocumentoID,	Aud_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Parametro de Documento Agregado Exitosamente.';
		SET Var_Control:= 'paramGuardaValoresID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI)THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control,
				Par_ParamGuardaValoresID AS consecutivo;
	END IF;

END TerminaStore$$