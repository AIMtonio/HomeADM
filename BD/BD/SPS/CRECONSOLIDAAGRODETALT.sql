

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGRODETALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGRODETALT`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAAGRODETALT`(
	-- =======================================================================================
	-- ----------SP PARA DAR DE ALTA EL DETALLE DE LOS CREDITOS CONSOLIDADOS -----------
	-- =======================================================================================
	Par_FolioConsolida          BIGINT(12),           -- ID o Referencia de Consolidacion
	Par_SolicitudCreditoID		BIGINT(20),			-- ID de la Solicitud de Credito
	Par_Transaccion				BIGINT(20),     	-- Numero de Transaccion de la tabla en sesion

	Par_Salida					CHAR(1),			-- Indica si se muestra mensaje de exito o no
	INOUT Par_NumErr			INT(11),			-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID				INT(11),			-- Parametro de auditoria
	Aud_Usuario					INT(11),			-- Parametro de auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal				INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control		        VARCHAR(100);
	DECLARE Var_FolioCons           BIGINT(12);         -- Folio de Consolidacion
	DECLARE Var_SolicitudCreditoID	BIGINT(20);			-- ID de Solicitud de Credito

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero            DECIMAL(12,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE SalidaSi  				CHAR(1);

	DECLARE SalidaNo  				CHAR(1);
	DECLARE Cons_SI                 CHAR(1);
	DECLARE Cons_NO                 CHAR(1);
	DECLARE Est_Inactivo			CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero     			:= 0;               -- Entero Cero
	SET Decimal_Cero     			:= 0.0;             -- Decimal Cero
	SET Cadena_Vacia    			:= '';              -- String Vacio
	SET Fecha_Vacia     			:= '1900-01-01';    -- Fecha Vacia
	SET SalidaSi					:= 'S';             -- Salida SI

	SET SalidaNo					:= 'N';             -- Salida NO
	SET Cons_SI                     := 'S';             -- Constante SI
	SET Cons_NO                     := 'N';             -- Constante NO
	SET Est_Inactivo				:= 'N';				-- Estatus Inactivo


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							  'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONSOLIDAAGRODETALT');
			SET Var_Control := 'sqlexception';
		END;

		SELECT FolioConsolida
		INTO Var_FolioCons
		FROM CRECONSOLIDAAGROENC
			WHERE FolioConsolida = Par_FolioConsolida;

		SET Var_FolioCons := IFNULL(Var_FolioCons, Entero_Cero);

		IF(Var_FolioCons = Entero_Cero)THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Folio de Consolidacion No Existe.';
			SET Var_Control := 'folioConsolida';
			LEAVE ManejoErrores;
		END IF;

		SELECT SolicitudCreditoID
		INTO Var_SolicitudCreditoID
		FROM SOLICITUDCREDITO
			  WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		SET Var_SolicitudCreditoID := IFNULL(Var_SolicitudCreditoID, Entero_Cero);

		IF(Var_SolicitudCreditoID = Entero_Cero)THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'La Solicitud de Credito No Existe.';
			SET Var_Control := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_Transaccion := IFNULL(Par_Transaccion,Entero_Cero);
		IF(Par_Transaccion = Entero_Cero)THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Numero de Transaccion No Existe.';
			SET Var_Control := 'numTransaccion';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();
		SET @DetConsolidaID := Entero_Cero;

		INSERT INTO CRECONSOLIDAAGRODET(
			DetConsolidaID,
			FolioConsolida,		SolicitudCreditoID,			CreditoID,			MontoCredito,		MontoProyeccion,
			Estatus,			EmpresaID,					Usuario,			FechaActual,		DireccionIP,
			ProgramaID,			Sucursal,					NumTransaccion)
		SELECT
			(@DetConsolidaID:=@DetConsolidaID +1),
			FolioConsolida,			Par_SolicitudCreditoID,	CreditoID,			MontoCredito,		MontoProyeccion,
			Est_Inactivo,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
		FROM CREDCONSOLIDAAGROGRID
		WHERE FolioConsolida = Par_FolioConsolida
		  AND Transaccion = Par_Transaccion;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= 'Credito Consolidado Agregado Exitosamente';
		SET Var_Control	:= 'solicitudCreditoID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$