-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSDOCUMENTOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSDOCUMENTOSMOD`;

DELIMITER $$
CREATE PROCEDURE `TIPOSDOCUMENTOSMOD`(
	-- Store Procedure para Modificar los Tipos de Documentos
	-- Modulo: Admon --> Catalogos -->Catalogo de Documentos
	Par_TipoDocumentoID		INT(11),		-- Numero de Tipo de Documento
	Par_Descripcion			VARCHAR(60),	-- Descripcion del Documento
	Par_RequeridoEn			VARCHAR(50),	-- Opcion a Requerir
	Par_Estatus				CHAR(1),		-- Estatus del Documento

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria Empresa ID
	Par_Salida				CHAR(1),		-- parametro de Salida
	INOUT Par_NumErr		INT(11),		-- parametro Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- parametro Mensaje de Error
	Aud_Usuario				INT(11),		-- Parametro de Auditoria Usuario ID
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria Programa ID
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria Sucursal ID
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria Numero de Transaccion
)
TerminaStore:BEGIN

	DECLARE Entero_Cero		INT(11);		-- Constante Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE SalidaSI		CHAR(1);		-- Constante Salida SI
	DECLARE Consecutivo		INT(11);		-- Numero de Tipo de Documento

	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET SalidaSI			:= 'S';

	-- Bloque de Manejo de Errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-TIPOSDOCUMENTOSMOD');
		END;

		SET Par_Descripcion := IFNULL(Par_Descripcion, Cadena_Vacia);
		SET Par_RequeridoEn := IFNULL(Par_RequeridoEn, Cadena_Vacia);
		SET Par_TipoDocumentoID := IFNULL(Par_TipoDocumentoID, Entero_Cero);

		IF( Par_Descripcion = Cadena_Vacia ) THEN
			SET	Par_NumErr 	:= 2;
			SET	Par_ErrMen	:= "La Descripcion esta Vacia.";
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoDocumentoID = Entero_Cero ) THEN
			SET	Par_NumErr 	:= 3;
			SET	Par_ErrMen	:= "El Tipo de Documento esta vacio.";
			LEAVE ManejoErrores;
		END IF;

		IF( Par_RequeridoEn = Cadena_Vacia ) THEN
			SET	Par_NumErr 	:= 4;
			SET	Par_ErrMen	:= "El Campo Requerido En esta Vacio.";
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual:=NOW();
		UPDATE TIPOSDOCUMENTOS SET
			Descripcion		= Par_Descripcion,
			RequeridoEn		= Par_RequeridoEn,
			Estatus			= Par_Estatus,
			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion 	= Aud_NumTransaccion
		WHERE TipoDocumentoID = Par_TipoDocumentoID;

		SET	Par_NumErr 	:= Entero_Cero;
		SET	Par_ErrMen	:= CONCAT("Tipo de Documento Modificado Exitosamente: ",Par_TipoDocumentoID);
		SET Par_TipoDocumentoID := Consecutivo;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'tipoDocumentoID' AS control,
				Par_TipoDocumentoID AS consecutivo;
	END IF;

END TerminaStore$$