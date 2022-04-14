-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNACARTALIQALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNACARTALIQALT`;

DELIMITER $$
CREATE PROCEDURE `ASIGNACARTALIQALT`(
/* SP REGISTRA LA ASIGNACION DE CARTAS DE LIQUIDACION DE CARTERA */
	Par_SolicitudCreditoID		BIGINT(20),		-- ID del Solicitud de Credito
	Par_CasaComercialID			BIGINT(11),		-- ID de Casa Comercial
	Par_Monto					DECIMAL(18,2),	-- Monto Asignado para la Carta de Liq de acuerdo a la Casa Comercial
	Par_FechaVigencia			DATE,			-- Fecha de Vigencia de la Carta de Liquidacion
	Par_ArchivoCartaID			INT(11),		-- ID de la Carga de Archivo de Carta de Liquidacion Tab SOLICITUDARCHIVOS
	Par_ArchivoPagoID			INT(11),		-- ID de la Carga de Archivo de Comprobante de Pago Tab SOLICITUDARCHIVOS

	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	-- Parametros de Auditoria
	Par_EmpresaID				INT(11),		-- Parametros de Auditoria
	Aud_Usuario					INT(11),		-- Parametros de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametros de Auditoria
	Aud_Sucursal				INT(11),		-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Var_Control			CHAR(25);			-- Var Control del Manejo de Errores
	DECLARE Var_Casa			BIGINT(11);			-- Var de Casa Comercial
	DECLARE Var_EstCasa			CHAR(1);			-- Var para el Estatus de la Casa Comercial

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	SalidaSI			CHAR(1);
	DECLARE	SalidaNO			CHAR(1);

	DECLARE EstCasa_Activo		CHAR(1);
	DECLARE EstCasa_Inactivo	CHAR(1);
	DECLARE Var_AsignaID		BIGINT(11);
	DECLARE Est_NoDispersada	CHAR(1);
	DECLARE Entero_Uno			INT;
	DECLARE Entero_Dos			INT(11);


	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET	SalidaSI				:= 'S';				-- Salida Si
	SET	SalidaNO				:= 'N'; 			-- Salida No
	SET EstCasa_Activo			:= 'A';				-- Estatus Activo
	SET EstCasa_Inactivo		:= 'I';				-- Estatus Inactivo
	SET Est_NoDispersada		:= 'N';				-- Estatus No Dispersada para la Carta
	SET Entero_Uno				:= 1;
	SET Entero_Dos				:= 2;

	SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ASIGNACARTALIQALT');
			SET Var_Control:= 'sqlException' ;
		END;

	SET Par_ArchivoCartaID := IFNULL(Par_ArchivoCartaID,Entero_Cero );
	SET Par_ArchivoPagoID := IFNULL(Par_ArchivoPagoID,null);

	IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'La Solicitud de Credito esta Vacia.';
		SET Var_Control:= 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CasaComercialID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'La Casa Comercial Esta Vacia.';
		SET Var_Control:= 'casaComercialID' ;
		LEAVE ManejoErrores;
	END IF;

	SELECT CasaComercialID, Estatus
			INTO Var_Casa, Var_EstCasa
	  FROM CASASCOMERCIALES
	 WHERE CasaComercialID =  Par_CasaComercialID;

	SET Var_Casa := IFNULL(Var_Casa,Entero_Cero);
	SET Var_EstCasa := IFNULL (Var_EstCasa, Cadena_Vacia);

	IF(Var_Casa = Entero_Cero) THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'La Casa Comercial Asignada No Existe.';
		SET Var_Control:= 'casaComercialID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Var_EstCasa != EstCasa_Activo) THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := 'El Estatus de la Casa Comercial No Esta Vigente.';
		SET Var_Control:= 'casaComercialID' ;
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_Monto, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'El Monto para la Carta esta Vacio.';
		SET Var_Control:= 'monto' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaVigencia, Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'La Fecha de Vigencia Esta Vacia.';
		SET Var_Control:= 'fechaVencimiento' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ArchivoCartaID = Entero_Cero) THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'No se Guardo correctamente el Archivo.';
		SET Var_Control:= 'archivoCartaID' ;
		LEAVE ManejoErrores;
	END IF;

	SET Var_AsignaID := (SELECT IFNULL(MAX(AsignacionCartaID),Entero_Cero) + 1 FROM ASIGCARTASLIQUIDACION);

	INSERT INTO ASIGCARTASLIQUIDACION(
		AsignacionCartaID, 		SolicitudCreditoID, 		CasaComercialID, 		Monto,
		FechaVigencia,			Estatus,					ArchivoIDCarta,			ArchivoIDPago,
		EmpresaID, 				Usuario, 					FechaActual,			DireccionIP, 	ProgramaID,
		Sucursal, 				NumTransaccion)
	VALUES(
		Var_AsignaID, 			Par_SolicitudCreditoID, 	Par_CasaComercialID, 	Par_Monto,
		Par_FechaVigencia,		Est_NoDispersada,			Par_ArchivoCartaID,		Par_ArchivoPagoID,
		Par_EmpresaID,			Aud_Usuario, 				Aud_FechaActual,    	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion);

	CALL INSTRUCDISPERSIONCREACT(
				Par_SolicitudCreditoID,		Entero_Dos,		SalidaNO,			Par_NumErr,			Par_ErrMen,
				Par_EmpresaID,				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Carta de Liquidacion Asignada Correctamente';
		SET Var_Control:= 'solicitudCreditoID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT	Par_NumErr		AS NumErr,
			Par_ErrMen		AS ErrMen,
			Var_Control	AS Control,
			Var_AsignaID	AS Consecutivo;
END IF;

END TerminaStore$$
