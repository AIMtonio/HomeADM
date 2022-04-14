-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAAGROPRO`(
	# =========================================================================
	# ----------SP PARA DAR DE ALTA LOS CREDITOS CONSOLIDADOS-----------
	# =========================================================================
	Par_FolioConsolida			BIGINT(12),			-- Folio de Consolidacion
	Par_SolicitudCreditoID		BIGINT(20),			-- ID de la Solicitud de Credito
	Par_Transaccion				BIGINT(20),			-- Numero de Transaccion de la tabla en sesion
	Par_FechaDesembolso			DATE,				-- Fecha de Desembolso
	Par_AltaGarAval				CHAR(1),			-- Alta de Garantia y Avales

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
	DECLARE Var_Estatus				CHAR(1);            -- Variable Estatus del Credito
	DECLARE Var_EsAgropecuario      CHAR(1);            -- Variable Es Agropecuario
	DECLARE Var_CreditoID 			BIGINT(12);         -- Credito Pivote con el cual se realizara las validaciones
	DECLARE Var_FolioCons           BIGINT(12);         -- Variable Folio de Consolidacion
	DECLARE Var_SolicitudCreditoID	BIGINT(20);			-- ID de Solicitud de Credito
	DECLARE Var_NumConsolida		INT(11);			-- Numero de Registros Consolidados
	DECLARE Var_ClienteOrigen		INT(11);			-- Cliente Origen de los Creditos Consolidados
	DECLARE Var_ClienteConsolida	INT(11);			-- Cliente del Credito a Consolidar
	DECLARE Var_Contador			INT(11);			-- Contador para el Ciclo

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE SalidaSi  				CHAR(1);
	DECLARE SalidaNo  				CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Var_FechaSis			DATE;
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Est_Vigente             CHAR(1);
	DECLARE Est_Vencido             CHAR(1);
	DECLARE Cons_SI                 CHAR(1);
	DECLARE Cons_NO                 CHAR(1);
	DECLARE BajaDetalle				INT(11);
	DECLARE BajaFolioGRID			INT(11);
	DECLARE Act_Cabecera			TINYINT UNSIGNED;

	-- Asignacion de constantes
	SET Cadena_Vacia    			:= '';              -- String Vacio
	SET Fecha_Vacia     			:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero     			:= 0;               -- Entero en Cero
	SET SalidaSi					:= 'S';             -- Salida SI
	SET SalidaNo					:= 'N';             -- Salida NO
	SET Est_Vigente                 := 'V';             -- Estatus Vigente
	SET Est_Vencido                 := 'B';             -- Estatus Vigente
	SET Cons_SI                     := 'S';             -- Constante SI
	SET Cons_NO                     := 'N';             -- Constante NO
	SET BajaDetalle					:= 3;				-- Baja de Detalle de Consolidacion
	SET BajaFolioGRID				:= 2;				-- Baja de Detalla Tabla Espejo
	SET Act_Cabecera				:= 1;				-- Actualizar Cabecera de Folio de Consolidacion

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							  'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONSOLIDAAGROPRO');
			SET Var_Control := 'sqlexception';
		END;

		SET Par_FolioConsolida 	:= IFNULL(Par_FolioConsolida,Entero_Cero);
		SET Par_AltaGarAval 	:= IFNULL(Par_AltaGarAval, Cons_NO);

		SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_FechaSis := IFNULL(Var_FechaSis,Fecha_Vacia);

		SELECT FolioConsolida
		INTO Var_FolioCons
		FROM CRECONSOLIDAAGROENC
			  WHERE FolioConsolida = Par_FolioConsolida;

		SET Var_FolioCons := IFNULL(Var_FolioCons,Entero_Cero);

		IF(Var_FolioCons  = Entero_Cero) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Folio de Consolidacion No Existe.';
			SET Var_Control  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT SolicitudCreditoID
		INTO Var_SolicitudCreditoID
		FROM SOLICITUDCREDITO
		  WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		SET Var_SolicitudCreditoID := IFNULL(Var_SolicitudCreditoID, Entero_Cero);

		IF(Var_SolicitudCreditoID = Entero_Cero) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'La Solicitud de Credito No Existe.';
			SET Var_Control := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_Transaccion := IFNULL(Par_Transaccion,Entero_Cero);
		IF(Par_Transaccion = Entero_Cero) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Numero de Transaccion No Existe.';
			SET Var_Control := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_FechaDesembolso := IFNULL(Par_FechaDesembolso, Fecha_Vacia);
		IF( Par_FechaDesembolso = Entero_Cero) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'La Fecha de Desembolso esta Vacia';
			SET Var_Control := 'fechaDesembolso';
			LEAVE ManejoErrores;
		END IF;

		-- Se realiza la Baja de los Registros del Folio de Consolidacion en el Detalle
		CALL CRECONSOLIDAAGROBAJ(
			Par_FolioConsolida,		Entero_Cero,		Entero_Cero,		Entero_Cero,		BajaDetalle,
			SalidaNo,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- SP de Alta de detalle Tabla Real
		CALL CRECONSOLIDAAGRODETALT(
			Par_FolioConsolida,		Par_SolicitudCreditoID,		Par_Transaccion,	SalidaNo,           Par_NumErr,
			Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,   		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- WHILE Para comparar que el folio de la cabecera
		-- de la cabecera obtener la Solicitud, de la Solicitud obtener el Cliente Origen
		-- y del cliente origen debe de coicidir con el cliente del credito consolidado

		SELECT COUNT(*)
		INTO Var_NumConsolida
		FROM CRECONSOLIDAAGRODET
		WHERE FolioConsolida = Par_FolioConsolida
		  AND SolicitudCreditoID = Par_SolicitudCreditoID;

		SELECT DeudorOriginalID
		INTO Var_ClienteOrigen
		FROM SOLICITUDCREDITO
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		SET Var_Contador := 1;

		WHILE (Var_Contador <= Var_NumConsolida)DO
			SELECT Cre.ClienteID,		Con.CreditoID
			INTO Var_ClienteConsolida, 	Var_CreditoID
			FROM CRECONSOLIDAAGRODET AS Con
				INNER JOIN CREDITOS AS Cre ON Con.CreditoID = Cre.CreditoID
			WHERE FolioConsolida = Par_FolioConsolida
				AND DetConsolidaID = Var_Contador;

			SET Var_ClienteConsolida := IFNULL(Var_ClienteConsolida, Entero_Cero);
			SET Var_CreditoID 		 := IFNULL(Var_CreditoID, Entero_Cero);

			IF(Var_ClienteOrigen != Var_ClienteConsolida)THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  := CONCAT('El Credito ', Var_CreditoID,' No Corresponde al Cliente Origen.');
				SET Var_Control  := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para la alta de Avales
			IF( Par_AltaGarAval = Cons_SI ) THEN

				CALL CRECONSOLIDAGARAVALAGROPRO (
					Par_FolioConsolida,		Par_SolicitudCreditoID,		Var_CreditoID,		SalidaNo,			Par_NumErr,
					Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Var_Contador := Var_Contador + 1;
			SET Var_ClienteConsolida := Entero_Cero;
			SET Var_CreditoID := Entero_Cero;

		END WHILE;

		-- SP de Actualizacion de Cabecera de Creditos Consolidados
		CALL CRECONSOLIDAAGROACT(
			Par_FolioConsolida,		Par_SolicitudCreditoID,		Entero_Cero,		Par_FechaDesembolso,	Act_Cabecera,
			SalidaNo,				Par_NumErr,					Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se realiza la Baja de los Registros del Folio de Consolidacion De Espejo
		CALL CRECONSOLIDAAGROBAJ(
			Par_FolioConsolida,		Entero_Cero,		Entero_Cero,		Par_Transaccion,	BajaFolioGRID,
			SalidaNo,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= 'Credito Consolidado Agregado Exitosamente';
		SET Var_Control	:= 'solicitudCreditoID';

	END ManejoErrores;

		IF (Par_Salida = SalidaSi) THEN
			SELECT 	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Par_FolioConsolida AS consecutivo;
		END IF;

END TerminaStore$$