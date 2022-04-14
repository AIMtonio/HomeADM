-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNACARTALIQMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNACARTALIQMOD`;

DELIMITER $$
CREATE PROCEDURE `ASIGNACARTALIQMOD`(
/* SP MODIFICA EL MONTO DE LAS CARTAS DE LIQUIDACION */

	Par_SolicitudCreditoID		BIGINT(20), 	-- ID del Solicitud de Credito
	Par_AsignacionCartaID       BIGINT(11),     -- ID de la Asignacion de Carta
	Par_CasaComercialID			BIGINT(11), 	-- ID de Casa Comercial
	Par_Monto			        DECIMAL(18,2), 	-- Monto Asignado para la Carta de Liq de acuerdo a la Casa Comercial
	Par_FechaVigencia			DATE,	        -- Fecha de Vigencia de la Carta de Liquidacion
	Par_ArchivoCartaID			INT(11),	    -- ID de la Carga de Archivo de Carta de Liquidacion Tab SOLICITUDARCHIVOS
	Par_ArchivoPagoID			INT(11),	    -- ID de la Carga de Archivo de Comprobante de Pago Tab SOLICITUDARCHIVOS


	Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT(11),		-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error
    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),        -- Parametros de Auditoria
	Aud_Usuario					INT(11),        -- Parametros de Auditoria
	Aud_FechaActual				DATETIME,       -- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15),    -- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),    -- Parametros de Auditoria
	Aud_Sucursal				INT(11),        -- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)      -- Parametros de Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Constantes
    DECLARE	Var_Control         CHAR(25);           -- Var Control del Manejo de Errores
    DECLARE Var_Casa            BIGINT(11);         -- Var de Casa Comercial
    DECLARE Var_EstSol          CHAR(1);            -- Var para el Estatus de la Solicitud de Credito
	DECLARE Var_MontoDisp		DECIMAL(18,2);		-- Var Monto Dispersion de la Carta
	DECLARE Var_Estatus			CHAR(1);			-- Var Estatus de la Carta de Liquidacion
	DECLARE Var_CreditoID 		BIGINT(20);			-- Var Credito ID ligado a la Solicitud
	DECLARE Var_MontoCliente	DECIMAL(14,2);		-- Monto Correspondiente al Cliente con respecto a las Cartas de Liq

    -- Declaracion de Constantes
    DECLARE	Cadena_Vacia		VARCHAR(1);
    DECLARE	Fecha_Vacia			DATE;
    DECLARE	Entero_Cero			INT(11);
    DECLARE	SalidaSI        	CHAR(1);
    DECLARE	SalidaNO        	CHAR(1);
    DECLARE Estatus_Aut     	CHAR(1);
    DECLARE Estatus_Desm     	CHAR(1);
	DECLARE Est_Dispersado		CHAR(1);
	DECLARE Est_NoDispersado	CHAR(1);
	DECLARE Con_NO				CHAR(1);

    -- Asignacion de Constantes
    SET Cadena_Vacia			:= '';				-- Cadena vacia
    SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
    SET Entero_Cero				:= 0;				-- Entero Cero
    SET	SalidaSI        		:= 'S';				-- Salida Si
    SET	SalidaNO        		:= 'N'; 			-- Salida No
    SET Estatus_Aut             := 'A';             -- Estatus Autorizada de Solicitud
    SET Estatus_Desm            := 'D';             -- Estatus Desembolsada de Solicitud
	SET Est_Dispersado			:= 'S';				-- Estatus Dispersado ligado a la Carta de Liquidacion
	SET Est_NoDispersado		:= 'N';				-- Estatus No Dispersado ligado a la Carta de Liquidacion
	SET Var_MontoCliente		:= 0.0;
	SET Con_NO					:= 'N';				-- Constante NO

    SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ASIGNACARTALIQALT');
			SET Var_Control:= 'sqlException' ;
		END;


	IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'La Solicitud de Credito esta Vacia.';
		SET Var_Control:= 'solicitudCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Monto, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'El Monto para la Carta esta Vacio.';
		SET Var_Control:= 'monto' ;
		LEAVE ManejoErrores;
	END IF;

	SELECT MontoDispersion, Estatus
	  INTO Var_MontoDisp, Var_Estatus
	  FROM ASIGCARTASLIQUIDACION
	 WHERE AsignacionCartaID = Par_AsignacionCartaID;

	SET Var_Estatus		:= IFNULL(Var_Estatus, Est_NoDispersado);
	SET Var_MontoDisp	:= IFNULL(Var_MontoDisp, Entero_Cero);

	IF(Var_Estatus = Est_Dispersado)THEN
		IF(Par_Monto < Var_MontoDisp)THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := 'El Monto debe de Ser Mayor al Dispersado.';
			SET Var_Control:= 'fechaVencimiento' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_FechaVigencia, Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr := 006;
		SET Par_ErrMen := 'La Fecha de Vigencia Esta Vacia.';
		SET Var_Control:= 'fechaVencimiento' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ArchivoCartaID = Entero_Cero) THEN
		SET Par_NumErr := 007;
		SET Par_ErrMen := 'No se Guardo correctamente el Archivo.';
		SET Var_Control:= 'archivoCartaID' ;
		LEAVE ManejoErrores;
	END IF;

	UPDATE ASIGCARTASLIQUIDACION SET
			Monto				= Par_Monto,
			FechaVigencia		= Par_FechaVigencia,
			ArchivoIDCarta		= Par_ArchivoCartaID,
			ArchivoIDPago		= Par_ArchivoPagoID
	WHERE SolicitudCreditoID	= Par_SolicitudCreditoID
	  AND AsignacionCartaID		= Par_AsignacionCartaID
	  AND CasaComercialID		= Par_CasaComercialID;

	SET Var_CreditoID := (SELECT CreditoID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);
	SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);

	IF(Var_CreditoID > Entero_Cero) THEN
		CALL ASIGSALDOCLIENTEACT (
		Var_CreditoID,			Var_MontoCliente,		SalidaNo,			Par_NumErr,			Par_ErrMen,
		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
		END IF;

		IF(Par_Monto > Var_MontoDisp)THEN

			UPDATE CTRDISPERSIONCARTAS SET
				Estatus = Con_NO
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID
				AND AsignacionCartaID = Par_AsignacionCartaID;
		END IF;

	END IF;



	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Carta de Liquidacion Modificada Correctamente';
	SET Var_Control:= 'solicitudCreditoID' ;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_SolicitudCreditoID AS Consecutivo;
	END IF;

END TerminaStore$$
