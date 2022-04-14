-- SP CHECKLISTREMESASWSALT

DELIMITER ;

DROP PROCEDURE IF EXISTS `CHECKLISTREMESASWSALT`;

DELIMITER $$

CREATE PROCEDURE `CHECKLISTREMESASWSALT`(
# ====================================================================
# --- STORE PARA DAR DE ALTA DOCUMENTOS DE CHECK LIST DE REMESAS -----
# ====================================================================
	Par_RemesaFolioID		VARCHAR(45),		-- Indica la referencia de pago de la Remesa
	Par_CheckListRemWSID	BIGINT(20),			-- Identificador de Check List de Remesas
	Par_TipoDocumentoID		INT(11),			-- Identificador de Tipo de Documento
	Par_Descripcion			VARCHAR(200),		-- Descripcion en la digitalizacion del Archivo
	Par_Recurso				VARCHAR(1000),		-- Recurso del Archivo digitalizado

	Par_Extension			VARCHAR(20),		-- Extension del Archivo digitalizado

	Par_Salida				CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
		)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_RemesaFolioID		VARCHAR(45);		-- Almacena la referencia de pago.
	DECLARE Var_CheckListRemWSID 	BIGINT(20);			-- ID Del check list
	DECLARE Var_Control         	CHAR(100);			-- Control de Retorno en pantalla
	DECLARE Var_TipoDocumentoID		INT(11);			-- Almacena el Tipo de Documento
    DECLARE Var_RemesaWSID			BIGINT(20);			-- Identificador de la remesa

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena Vacia
	DECLARE Entero_Cero				INT(1);				-- Entero Cero
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Salida_SI				CHAR(1);			-- Salida: SI
    DECLARE Salida_NO				CHAR(1);			-- Salida: NO

	-- ASIGNACIKON DE CONSTANTES
	SET Cadena_Vacia				:= '';				-- Cadena Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Decimal_Cero				:= 0.0;				-- Decimal Cero
    SET Salida_SI					:= 'S';				-- Salida: SI
    SET Salida_NO					:= 'N';				-- Salida: NO

	ManejoErrores: BEGIN
		 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-CHECKLISTREMESASWSALT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control	= 'SQLEXCEPTION';
		END;

	    -- SE OBTIENE LA FECHA ACTUAL
	    SET Aud_FechaActual 	:= NOW();

	    -- SE OBTIENEN LOS DATOS DE LA REFERENCIA DE PAGO
		SELECT RemesaWSID,		RemesaFolioID
		INTO Var_RemesaWSID,	Var_RemesaFolioID
		FROM REMESASWS
		WHERE RemesaFolioID = Par_RemesaFolioID;

		SET Var_RemesaWSID 		:= IFNULL(Var_RemesaWSID,Entero_Cero);
		SET Var_RemesaFolioID	:= IFNULL(Var_RemesaFolioID, Cadena_Vacia);

		IF(Var_RemesaFolioID = Cadena_Vacia) THEN
		    SET Par_NumErr := 001;
		    SET Par_ErrMen := CONCAT('La Referencia: ',Par_RemesaFolioID,' No Existe.');
		    LEAVE ManejoErrores;
		END IF;

		-- SE VERIFICA SI EL TIPO DE DOCUMENTO EXISTE
		SELECT TipoDocumentoID
		INTO Var_TipoDocumentoID
        FROM TIPOSDOCUMENTOS
        WHERE TipoDocumentoID = Par_TipoDocumentoID;

        SET Var_TipoDocumentoID := IFNULL(Var_TipoDocumentoID,Entero_Cero);

		IF(Var_TipoDocumentoID = Entero_Cero) THEN
	        SET Par_NumErr := 002;
	        SET Par_ErrMen := CONCAT('El Tipo de Documento: ',Par_TipoDocumentoID,' No Existe.');
	        LEAVE ManejoErrores;
		END IF;

		-- SE VERIFICA SI EXISTE EL ID DEL CHECK LIST DE REMESAS
		SELECT CheckListRemWSID
		INTO Var_CheckListRemWSID
        FROM CHECKLISTREMESASWS
        WHERE CheckListRemWSID = Par_CheckListRemWSID
        AND RemesaWSID = Var_RemesaWSID;

        SET Var_CheckListRemWSID	:= IFNULL(Var_CheckListRemWSID,Entero_Cero);
		SET Par_Extension 			:= IFNULL(Par_Extension,Cadena_Vacia);

		-- SI EL ID DEL CHECK LIST DE REMESAS SI EXISTE SE ACTUALIZA LA RUTA DEL ARCHIVO
        IF(Var_CheckListRemWSID > Entero_Cero)THEN
			SET	Par_Recurso	:= CONCAT(Par_Recurso, RIGHT(CONCAT("0000000000",CONVERT(Var_CheckListRemWSID, CHAR)), 10), Par_Extension);

        	UPDATE CHECKLISTREMESASWS
        	SET Archivo = Par_Recurso
        	WHERE CheckListRemWSID = Var_CheckListRemWSID
        	AND RemesaWSID = Var_RemesaWSID;
        END IF;

        -- SI EL ID DEL CHECK LIST DE REMESAS NO EXISTE
        IF(Var_CheckListRemWSID = Entero_Cero)THEN
			-- SE OBTIENE EL VALOR CONSECUTIVO PARA EL REGISTRO EN LA TABLA CHECKLISTREMESASWS
			SET	Var_CheckListRemWSID	:= (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero)+1 FROM CHECKLISTREMESASWS);

			SET	Par_Recurso	:= CONCAT(Par_Recurso, RIGHT(CONCAT("0000000000",CONVERT(Var_CheckListRemWSID, CHAR)), 10), Par_Extension);

			-- SE REGISTRA LA INFORMACION EN LA TABLA CHECKLISTREMESASWS
			INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
	            Sucursal, 					NumTransaccion)
			VALUES(
				Var_CheckListRemWSID,		Var_RemesaWSID,			Par_TipoDocumentoID, 	Par_Recurso,			Par_Descripcion,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);
        END IF;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= CONCAT("El Archivo se ha Digitalizado Exitosamente: ", CONVERT(Var_CheckListRemWSID, CHAR));
		SET	Var_Control := '';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen  	AS ErrMen,
				Var_Control 	AS Control,
				Var_CheckListRemWSID AS Consecutivo,
				Par_Recurso 	AS NombreArchivo;
	END IF;

END TerminaStore$$