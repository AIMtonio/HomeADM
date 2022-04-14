-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORARCHIVOSBAJALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORARCHIVOSBAJALT`;
DELIMITER $$

CREATE PROCEDURE `BITACORARCHIVOSBAJALT`(
# =========================================================================
# ----- SP PARA LA BITACORA DE LOS ARCHIVOS ELIMINADOS DE LOS INSTRUMENTOS-----
# =========================================================================
	Par_ArchivoBajID		BIGINT(20),		-- Numero Consecutivo
	Par_TipoInstrumento		INT(11),		-- Tipo de Instrumento, ID de Tabla CATINSTGRDVALORES
	Par_NumeroInstrumento	BIGINT(20),		-- ID del Instrumento: ClienteID, CuentaAhoID, SolicitudCreditoID, CreditoID, ProspectoID
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),
	Par_EmpresaID			INT,			-- Parametro Auditoria
	Aud_Usuario				INT,			-- Parametro Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro Auditoria
	Aud_Sucursal			INT(11),		-- Parametro Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Consecutivo			VARCHAR(200);	-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_Control				VARCHAR(50);	-- ID del Control en pantalla
	DECLARE Var_Fechasistema		DATE;			-- Fecha del Sistema
	DECLARE Var_ArchBajID 			INT(11);		-- ID consecutivo a agregar en a bitacora
	DECLARE Var_NumInstrum			BIGINT(20);		-- Numero de Instrumento IALDANA T_14952 Se cambia INT por BIGINT

	DECLARE Var_NomUsuario			VARCHAR(400);	-- Nombre del Usuario que elimina el archivo
	DECLARE Var_TipoDocID			INT(11);		-- Tipo de Documento del archivo a eliminar
	DECLARE Var_ArchivoID			INT(11);		-- Identificador del archivo a eliminar
	DECLARE Var_TipoInstrumento		INT(11);		-- Tipo Instrumento del Archivo a eliminar
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE	Entero_Cero				INT(11);		-- Constante Entero_Cero
	DECLARE	Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE	SalidaSI				CHAR(1);		-- Constante Salida Si

	DECLARE	Instrum_Cliente			INT(11);		-- Constante Tipo Instrumento Cliente
	DECLARE	Instrum_Prospecto		INT(11);		-- Constante Tipo Instrumento Prospecto
	DECLARE	Instrum_Cuenta			INT(11);		-- Constante Tipo Instrumento Cuenta
	DECLARE	Instrum_SolCred			INT(11);		-- Constante Tipo Instrumento Solicitud de Credito
	DECLARE	Instrum_Cred			INT(11);        -- Constante Tipo Instrumento Credito
	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';
	SET Entero_Cero				:= 0;
	SET Fecha_Vacia				:= '1900-01-01';
	SET SalidaSI				:= 'S';
	SET Aud_FechaActual	 		:= CURRENT_TIMESTAMP();

	SET Instrum_Cliente			= 4;
	SET	Instrum_Prospecto		= 32;
	SET	Instrum_Cuenta			= 2;
	SET	Instrum_SolCred			= 33;
	SET	Instrum_Cred			= 11;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
			'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACORARCHIVOSBAJALT');
			SET Var_Control		:= 'sqlException' ;
		END;

		IF(IFNULL(Par_TipoInstrumento, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := '001';
			SET Par_ErrMen := 'El Tipo Instrumento esta Vacio.' ;
			SET Var_Control	:= 'tipoInstrumento';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT	TipoInstrumentoID
		INTO	Var_TipoInstrumento
		FROM 	TIPOINSTRUMENTOS
		WHERE	TipoInstrumentoID = Par_TipoInstrumento;

		IF(IFNULL(Var_TipoInstrumento, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := '002';
			SET Par_ErrMen := 'El Tipo Instrumento No Existe.' ;
			SET Var_Control	:= 'tipoInstrumento';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_TipoInstrumento, Entero_Cero)) IN(Instrum_Cuenta,Instrum_SolCred,Instrum_Cred) THEN
			IF(IFNULL(Par_NumeroInstrumento, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := '003';
				SET Par_ErrMen := 'El Numero Instrumento esta Vacio.' ;
				SET Var_Control	:= 'numeroInstrumento';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Var_TipoInstrumento, Entero_Cero))= Instrum_Cliente THEN
			SELECT	ClienteArchivosID,	ClienteID,		TipoDocumento
			INTO	Var_ArchivoID,		Var_NumInstrum,	Var_TipoDocID
			FROM	CLIENTEARCHIVOS
			WHERE	ClienteArchivosID = Par_ArchivoBajID;
		END IF;

		IF(IFNULL(Var_TipoInstrumento, Entero_Cero))= Instrum_Prospecto THEN
			SELECT	ClienteArchivosID,	ProspectoID,	TipoDocumento
			INTO 	Var_ArchivoID,		Var_NumInstrum,	Var_TipoDocID
			FROM 	CLIENTEARCHIVOS
			WHERE	ClienteArchivosID = Par_ArchivoBajID;
		END IF;

		IF(IFNULL(Var_TipoInstrumento, Entero_Cero))= Instrum_Cuenta THEN
			SELECT  ArchivoCtaID,		CuentaAhoID,	TipoDocumento
			INTO 	Var_ArchivoID,		Var_NumInstrum,	Var_TipoDocID
			FROM	CUENTAARCHIVOS
			WHERE	CuentaAhoID = Par_NumeroInstrumento
            AND ArchivoCtaID = Par_ArchivoBajID;
		END IF;

		IF(IFNULL(Var_TipoInstrumento, Entero_Cero))= Instrum_SolCred THEN
			SELECT  DigSolID,			SolicitudCreditoID,	TipoDocumentoID
			INTO 	Var_ArchivoID,		Var_NumInstrum,		Var_TipoDocID
			FROM 	SOLICITUDARCHIVOS
			WHERE	DigSolID = Par_ArchivoBajID
            AND SolicitudCreditoID = Par_NumeroInstrumento;
		END IF;

		IF(IFNULL(Var_TipoInstrumento, Entero_Cero))= Instrum_Cred THEN
			SELECT  DigCreaID,			CreditoID,		TipoDocumentoID
			INTO 	Var_ArchivoID,		Var_NumInstrum,	Var_TipoDocID
			FROM	CREDITOARCHIVOS
			WHERE 	DigCreaID = Par_ArchivoBajID
            AND CreditoID = Par_NumeroInstrumento;
		END IF;

		SET Var_ArchivoID = IFNULL(Var_ArchivoID,	Entero_Cero);

		IF(IFNULL(Var_ArchivoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := '001';
			SET Par_ErrMen := 'El Documento No Existe' ;
			SET Var_Control	:= 'clienteID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT	FechaSistema
		INTO Var_Fechasistema
		FROM PARAMETROSSIS LIMIT 1;

		SET Var_Fechasistema:= IFNULL(Var_Fechasistema,Fecha_Vacia);

		SET Var_NomUsuario := (SELECT NombreCompleto FROM USUARIOS WHERE UsuarioID = Aud_Usuario);

		SET Var_ArchBajID := (SELECT IFNULL(Max(ArchivoBajID),Entero_Cero)+1 FROM BITACORARCHIVOSBAJ);

		INSERT INTO BITACORARCHIVOSBAJ(
			ArchivoBajID,			TipoInstrumento,		NumeroInstrumento,	TipoDocumento,		FechaBaja,
			UsuarioBaja,			NombreUsuarioBaja,
			EmpresaID,				Usuario,				FechaActual,		DireccionIP,   		 ProgramaID,
			Sucursal,				NumTransaccion)
		VALUES  (
			Var_ArchBajID,			Var_TipoInstrumento,	IFNULL(Var_NumInstrum,Entero_Cero),	IFNULL(Var_TipoDocID,Entero_Cero),	Var_Fechasistema,
			Aud_Usuario,			IFNULL(Var_NomUsuario,Cadena_Vacia),
			Par_EmpresaID,			Aud_Usuario,    		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('El archivo se ha Digitalizado Exitosamente.');
		SET Var_Control 	:= 'archivoBajID' ;
		SET Var_Consecutivo	:= Var_ArchBajID;
	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$
