-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSDOCUMENTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSDOCUMENTOSALT`;

DELIMITER $$
CREATE PROCEDURE `TIPOSDOCUMENTOSALT`(
	-- Store Procedure para el Alta de Tipos de Documentos
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


	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);		-- Constante Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE SalidaSI		CHAR(1);		-- Constante Salida SI
    DECLARE Consecutivo     INT(11);


	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET SalidaSI			:= 'S';
    SET Consecutivo             :=(select MAX(TipoDocumentoID) FROM TIPOSDOCUMENTOS)+1;


	-- Bloque de Manejo de Errores
	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                    "estamos trabajando para resolverla. Disculpe las molestias que ",
                                    "esto le ocasiona. Ref: SP-TIPOSDOCUMENTOSALT");
        END;

		IF( Par_Descripcion = Cadena_Vacia ) THEN
			SET	Par_NumErr 	:= 2;
			SET	Par_ErrMen	:= "La Descripcion esta Vacia.";
			LEAVE ManejoErrores;
		END IF;

		IF( Par_RequeridoEn = Cadena_Vacia ) THEN
			SET	Par_NumErr 	:= 4;
			SET	Par_ErrMen	:= "El Campo Requerido En esta Vacio.";
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		INSERT INTO TIPOSDOCUMENTOS (
			TipoDocumentoID,		Descripcion,		RequeridoEn,		Estatus,		EmpresaID,
			Usuario,				FechaActual,		DireccionIP,		ProgramaID ,	Sucursal ,
			NumTransaccion)
		VALUES (
			Consecutivo,	Par_Descripcion,	Par_RequeridoEn,	Par_Estatus,	Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

		SET	Par_NumErr 	:= Entero_Cero;
		SET	Par_ErrMen	:= CONCAT("Tipo de Documento Grabado Exitosamente: ",Consecutivo);
		SET Par_TipoDocumentoID := Consecutivo;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'tipoDocumentoID' AS control,
				Par_TipoDocumentoID AS consecutivo;
	END IF;

END TerminaStore$$