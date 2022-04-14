-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDARCHIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDARCHIVOSALT`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDARCHIVOSALT`(
	/* SP QUE DA DE ALTA LOS DOCUMENTOS DEL CLIENTE */
	Par_SolicitudCreditoID	BIGINT(20),			-- ID de la solicitud de credito
	Par_TipoDocumentoID		INT(11),			-- ID del tipo documento
	Par_Comentario			VARCHAR(200),		-- Comentario del documento
	Par_Recurso				VARCHAR(200),		-- Recurso del documento
	Par_Extension			VARCHAR(20),		-- Extension del documento

	Par_Salida				CHAR(1),			-- Salida S:Si N:No
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	-- Parametros de Auditoria --
	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
		)

TerminaStore: BEGIN


	/* Declaracion de Variables	*/
	DECLARE	Var_NombreArchivo	VARCHAR(25);
	DECLARE NumeroArchivo       INT(11);
	DECLARE VarControl          CHAR(15);

	/*  Declaracion de   Constantes   */
	DECLARE	Con_Cadena_Vacia	CHAR(1);
	DECLARE	Con_Fecha_Vacia		DATETIME;
	DECLARE	Con_Entero_Cero		INT(11);
	DECLARE	Con_Str_SI			CHAR(1);
	DECLARE	Con_Str_NO			CHAR(1);


	/*  asignacion de Constantes   */
	SET	Con_Cadena_Vacia        := '';              -- Cadena Vacia
	SET Con_Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
	SET Con_Entero_Cero         := 0;
	SET Con_Str_SI              := 'S';
	SET Con_Str_NO              := 'N';
	SET Aud_FechaActual 		:= NOW();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						 'esto le ocasiona. Ref: SP-SOLICITUDARCHIVOSALT');
				SET VarControl = 'sqlException' ;
			END;

			IF(NOT EXISTS(SELECT SolicitudCreditoID FROM SOLICITUDCREDITO
							WHERE SolicitudCreditoID	= Par_SolicitudCreditoID)) THEN

						SET Par_NumErr	:=01;
						SET Par_ErrMen	:='El Numero de Solicitud no existe';
						SET Varcontrol	:='solicitudCreditoID';
						LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT ClasificaTipDocID FROM CLASIFICATIPDOC
							WHERE ClasificaTipDocID = Par_TipoDocumentoID) THEN

						SET Par_NumErr	:=02;
						SET Par_ErrMen	:='El Tipo de documento no Existe.';
						SET Varcontrol	:='solicitudCreditoID';
						LEAVE ManejoErrores;
			END IF;

			SET	NumeroArchivo	:= (SELECT IFNULL(MAX(DigSolID),Con_Entero_Cero)+1
										FROM SOLICITUDARCHIVOS );

			SET	Var_NombreArchivo	:=  CONCAT(RIGHT(CONCAT("0000000000",CONVERT(NumeroArchivo, CHAR)), 10), Par_Extension);
			SET	Par_Recurso	:= CONCAT(Par_Recurso, CONVERT(Var_NombreArchivo, CHAR));

			INSERT INTO SOLICITUDARCHIVOS
					(	DigSolID,   		SolicitudCreditoID,			TipoDocumentoID,		Comentario,   		Recurso,
						VoBoAnalista,		ComentarioAnalista,
						EmpresaID,			Usuario,    				FechaActual,    		DireccionIP,  		ProgramaID,
						Sucursal,			NumTransaccion)

				VALUES  (NumeroArchivo,		Par_SolicitudCreditoID,   	Par_TipoDocumentoID,	Par_Comentario,  	Par_Recurso,
						Con_Cadena_Vacia,	Con_Cadena_Vacia,
						Par_EmpresaID,  	Aud_Usuario,     			Aud_FechaActual,    	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,   	Aud_NumTransaccion);

			SET Par_NumErr := 000;
			SET Par_ErrMen := 'El archivo se ha digitalizado Exitosamente';
			SET	VarControl := '';

	END ManejoErrores;

	IF(Par_Salida =Con_Str_SI) THEN
		SELECT  Par_NumErr AS NumErr,
		Par_ErrMen  AS ErrMen,
		VarControl AS control,
		NumeroArchivo AS consecutivo,
		Par_Recurso AS NombreArchivo;
	END IF;

END TerminaStore$$