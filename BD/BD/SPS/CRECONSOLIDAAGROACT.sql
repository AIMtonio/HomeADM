-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGROACT`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAAGROACT`(
	# =========================================================================
	# ----------SP PARA ACTUALIZAR LOS CREDITOS CONSOLIDADOS-----------
	# =========================================================================
	Par_FolioConsolida          BIGINT(12),			-- Folio de Consolidacion
	Par_SolicitudCreditoID      BIGINT(20),			-- ID de la Solicitud
	Par_CreditoID 				BIGINT(12),			-- ID de Credito
	Par_FechaDesembolso			DATE,				-- Fecha Desembolso
	Par_NumAct					TINYINT UNSIGNED,	-- Numero de Actualizacion

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
	DECLARE Var_SolicitudCreditoID  BIGINT(20);         -- Numero de Solicitud de credito
	DECLARE Var_CreditoID 			BIGINT(12);         -- Numero de credito
	DECLARE Var_FolioCons           BIGINT(12);         -- Varariable Folio de Consolidacion
	DECLARE Var_NumReg              INT(11);            -- Numero de Registros en el Detalle de Consolidacion

	DECLARE Var_FechaSistema		DATE;				-- Fecha del Sistema
	DECLARE Var_FechaDesembolso		CHAR(1);			-- Parametro Fecha de Desembolso

	DECLARE Var_Monto               DECIMAL(14,2);      -- Monto de los Creditos Consolidados
	DECLARE Var_MontoProyeccion		DECIMAL(14,2);      -- Monto de Interes Proyectado

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero            DECIMAL(12,2);
	DECLARE SalidaSi  				CHAR(1);
	DECLARE SalidaNo  				CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);

	DECLARE Fecha_Vacia     		DATE;
	DECLARE Cons_SI                 CHAR(1);
	DECLARE Cons_NO                 CHAR(1);
	DECLARE Est_Autorizada          CHAR(1);

	-- Declaracion de Actualizaciones
	DECLARE Act_Cabecera			TINYINT UNSIGNED;
	DECLARE Act_EstCabecera			TINYINT UNSIGNED;
	DECLARE Act_NumCredito			TINYINT UNSIGNED;
	DECLARE Act_EstDetalle			TINYINT UNSIGNED;


	-- Asignacion de constantes
	SET Cadena_Vacia    			:= '';              -- String Vacio
	SET Fecha_Vacia     			:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero     			:= 0;               -- Entero en Cero
	SET Decimal_Cero        		:= 0.0;             -- DECIMAL Cero
	SET SalidaSi					:= 'S';             -- Salida SI

	SET SalidaNo					:= 'N';             -- Salida NO
	SET Cons_SI                     := 'S';             -- Constante SI
	SET Cons_NO                     := 'N';             -- Constante NO
	SET Est_Autorizada              := 'A';             -- Estatus Autorizada

	-- Asignacion de Actualizaciones
	SET Act_Cabecera                := 1;               -- Actualizacion de Cabecera
	SET Act_EstCabecera             := 2;               -- Actualizacion de Estatus de Cabecera
	SET Act_NumCredito				:= 3;				-- Actualizacion de Numero de Credito
	SET Act_EstDetalle				:= 1;				-- Actualizacion de Estatus de Encabezado

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONSOLIDAAGROACT');
				SET Var_Control := 'sqlexception';
			END;

		SET Par_FolioConsolida := IFNULL(Par_FolioConsolida,Entero_Cero);
		IF( Par_FolioConsolida = Entero_Cero)THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Folio de Consolidacion esta Vacio.';
			SET Var_Control := 'folioConsolidacionID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FolioConsolida
		INTO Var_FolioCons
		FROM CRECONSOLIDAAGROENC
		WHERE FolioConsolida = Par_FolioConsolida;

		SET Var_FolioCons := IFNULL(Var_FolioCons, Entero_Cero);
		IF(Var_FolioCons = Entero_Cero)THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Folio de Consolidacion No Existe.';
			SET Var_Control  := 'folioConsolida';
			LEAVE ManejoErrores;
		END IF;

		-- Realiza la Actualizacion de la Cabecera de acuerdo al Detalle de Consolidaciones
		IF(Par_NumAct = Act_Cabecera)THEN

			SET Par_SolicitudCreditoID := IFNULL(Par_SolicitudCreditoID,Entero_Cero);
			IF( Par_SolicitudCreditoID = Entero_Cero)THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  := 'El Numero de Solicitud de Credito esta Vacio.';
				SET Var_Control := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT SolicitudCreditoID
			INTO Var_SolicitudCreditoID
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID
			  AND EsAgropecuario = Cons_SI
			  AND EsConsolidacionAgro = Cons_SI;

			SET Var_SolicitudCreditoID := IFNULL(Var_SolicitudCreditoID, Entero_Cero);
			IF(Var_SolicitudCreditoID = Entero_Cero)THEN
				SET Par_NumErr  := 4;
				SET Par_ErrMen  := 'El Numero de Solicitud de Credito No Existe.';
				SET Var_Control := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT COUNT(CreditoID), SUM(MontoCredito), SUM(MontoProyeccion)
			INTO Var_NumReg,        Var_Monto,			Var_MontoProyeccion
			FROM CRECONSOLIDAAGRODET
			WHERE FolioConsolida = Par_FolioConsolida
				AND SolicitudCreditoID = Par_SolicitudCreditoID;

			SET Var_NumReg := IFNULL(Var_NumReg,Entero_Cero);
			SET Var_Monto := IFNULL(Var_Monto,Decimal_Cero);

			IF(Var_NumReg = Entero_Cero)THEN
				SET Par_NumErr  := 5;
				SET Par_ErrMen  := 'No Existen Registros a Consolidar.';
				SET Var_Control := 'folioConsolida';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Monto = Decimal_Cero)THEN
				SET Par_NumErr  := 6;
				SET Par_ErrMen  := 'Los Registros no cuentan con Monto a Consolidar.';
				SET Var_Control := 'folioConsolida';
				LEAVE ManejoErrores;
			END IF;

			SET Par_FechaDesembolso := IFNULL(Par_FechaDesembolso, Fecha_Vacia);
			IF( Par_FechaDesembolso = Fecha_Vacia ) THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  := 'La fecha de Desembolso esta Vacia.';
				SET Var_Control := 'fechaDesembolso';
				LEAVE ManejoErrores;
			END IF;

			SELECT Pro.FechaDesembolso
			INTO Var_FechaDesembolso
			FROM SOLICITUDCREDITO Sol
			INNER JOIN PRODUCTOSCREDITO Pro ON Sol.ProductoCreditoID = Pro.ProducCreditoID
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			SET Var_FechaDesembolso := IFNULL(Var_FechaDesembolso, Cons_NO);
			IF( Var_FechaDesembolso = Cons_NO ) THEN

				SELECT FechaSistema
				INTO Var_FechaSistema
				FROM PARAMETROSSIS
				LIMIT 1;

				SET Par_FechaDesembolso := Var_FechaSistema;
				SET Var_MontoProyeccion = Entero_Cero;
			END IF;

			SET Aud_FechaActual := NOW();
			UPDATE CRECONSOLIDAAGROENC SET

				CantRegistros 		= Var_NumReg,
				MontoConsolidado 	= Var_Monto + Var_MontoProyeccion,
				SolicitudCreditoID 	= Par_SolicitudCreditoID,
				FechaDesembolso		= Par_FechaDesembolso,

				EmpresaID			= Par_EmpresaID,
				Usuario 			= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE FolioConsolida = Par_FolioConsolida;

		END IF;

		IF(Par_NumAct = Act_EstCabecera)THEN

			SET Aud_FechaActual := NOW();
			UPDATE CRECONSOLIDAAGROENC SET
				Estatus 		= Est_Autorizada,

				EmpresaID		= Par_EmpresaID,
				Usuario 		= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE FolioConsolida = Par_FolioConsolida;

			CALL CRECONSOLIDAAGRODETACT (
				Par_FolioConsolida,	Act_EstDetalle,
				SalidaNo,			Par_NumErr,			Par_ErrMen,
				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF( Par_NumAct = Act_NumCredito ) THEN

			SET Par_CreditoID := IFNULL(Par_CreditoID,Entero_Cero);
			IF( Par_CreditoID = Entero_Cero ) THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  := 'El Numero de Credito esta Vacio.';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT CreditoID
			INTO Var_CreditoID
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID
			  AND EsConsolidacionAgro = Cons_SI;

			SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);
			IF( Var_CreditoID = Entero_Cero ) THEN
				SET Par_NumErr  := 4;
				SET Par_ErrMen  := 'El Numero de Credito No Existe.';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_CreditoID := Entero_Cero;

			SELECT CreditoID
			INTO Var_CreditoID
			FROM CRECONSOLIDAAGROENC
			WHERE FolioConsolida = Par_FolioConsolida;

			SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);
			IF( Var_CreditoID <> Entero_Cero ) THEN
				SET Par_NumErr  := 5;
				SET Par_ErrMen  := CONCAT('El Folio de Consolidacion, ya se encuentra relacionado al credito: ',Var_CreditoID,'.');
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Aud_FechaActual := NOW();
			UPDATE CRECONSOLIDAAGROENC SET
				CreditoID 		= Par_CreditoID,

				EmpresaID		= Par_EmpresaID,
				Usuario 		= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= "CreditoDAO.altaCreditoAgro",
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE FolioConsolida = Par_FolioConsolida;
		END IF;

		SET Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= 'Credito Consolidado Actualizado Exitosamente';
		SET Var_Control	:= 'solicitudCreditoID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$