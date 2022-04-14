-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAGARAVALAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAGARAVALAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAGARAVALAGROPRO`(
	-- Proceso de Alta de Avales y Garantias Agro
	-- Solicitud de Credito Agro --> Registro --> Registro de Consolidacion
	Par_FolioConsolidacionID	BIGINT(12),			-- ID de la Consolidacion
	Par_SolicitudCreditoID		BIGINT(20),			-- ID de la Solicitud de Credito
	Par_CreditoID				BIGINT(12),			-- ID de la Credito

	Par_Salida					CHAR(1),			-- Indica si se muestra mensaje de exito o no
	INOUT Par_NumErr			INT(11),			-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID				INT(11),			-- Parametro de auditoria Empresa ID
	Aud_Usuario					INT(11),			-- Parametro de auditoria Usuario ID
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Fecha Actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa ID
	Aud_Sucursal				INT(11),			-- Parametro de auditoria Sucursal ID
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FechaRegistro			DATE;		-- Fecha de Registro
	DECLARE Var_RequiereAvales 			CHAR(1);	-- Requiere Aval
	DECLARE Var_RequiereGarantia		CHAR(1);	-- Requiere Garantia
	DECLARE Var_NumGarantias			INT(11);	-- Numero de Garantias
	DECLARE Var_NumAvales				INT(11);	-- Numero de avales
	DECLARE Var_ProductoCreditoID		INT(11);	-- ID Producto de Credito
	DECLARE Var_CantidadAvales			INT(11);	-- Numero de Creditos por Avalar

	DECLARE Var_AvalID					INT(11);	-- ID de Aval
	DECLARE Var_ClienteID				INT(11);	-- ID de Cliente
	DECLARE Var_ProspectoID				INT(11);	-- ID de Prospecto
	DECLARE Var_TipoRelacionID			INT(11);	-- ID de Tipo de Relacion
	DECLARE Var_NumRegistros			INT(11);	-- Numero de Creditos Avalados
	DECLARE Var_Contador				INT(11);	-- Contador de Ciclo
	DECLARE Var_AsignaAval				INT(11);	-- Verificador para Asignacion de Aval

	DECLARE Var_CreditoID 				BIGINT(12);	-- ID de Credito
	DECLARE Var_FolioConsolidacionID	BIGINT(12);	-- ID de Consolidacion
	DECLARE Var_SolicitudCreditoOrigen	BIGINT(20);	-- ID de Solicitud de Credito Origen
	DECLARE Var_SolicitudCreditoID		BIGINT(20);	-- ID de Solicitud de Credito
	DECLARE Var_Control					VARCHAR(100);	-- Control de retorno a pantalla
	DECLARE Var_TiempoDeConocido		DECIMAL(12,2);	-- Consatnte Decimal Cero

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);		-- Constante Entero Cero
	DECLARE Entero_Uno				INT(11);		-- Constante Entero Uno
	DECLARE SalidaSI  				CHAR(1);		-- Constante Salida SI
	DECLARE SalidaNO				CHAR(1);		-- Constante Salida NO
	DECLARE Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacio
	DECLARE Est_Autorizada			CHAR(1);		-- Constante Estatus Autorizado para Aval o Garantia

	DECLARE Est_Asignada			CHAR(1);		-- Constante Estatus Asignado para Aval o Garantia
	DECLARE Est_Origen				CHAR(1);		-- Constante Estatus Origen para Aval o Garantia
	DECLARE Con_SI					CHAR(1);		-- Constante SI
	DECLARE Con_NO					CHAR(1);		-- Constante NO
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Consatnte Decimal Cero

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;
	SET Entero_Uno					:= 1;
	SET SalidaSI					:= 'S';
	SET SalidaNO					:= 'N';
	SET Cadena_Vacia				:= '';
	SET Est_Autorizada				:= 'U';

	SET Est_Asignada				:= 'A';
	SET Est_Origen					:= 'O';
	SET Con_SI						:= 'S';
	SET Con_NO						:= 'N';
	SET Decimal_Cero				:= 0.00;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONSOLIDAGARAVALAGROPRO');
			SET Var_Control := 'sqlexception';
		END;

		SET Par_FolioConsolidacionID := IFNULL(Par_FolioConsolidacionID, Entero_Cero);
		SET Par_SolicitudCreditoID	 := IFNULL(Par_SolicitudCreditoID, Entero_Cero);
		SET Par_CreditoID			 := IFNULL(Par_CreditoID, Entero_Cero);

		IF( Par_FolioConsolidacionID = Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Folio de Consolidacion esta vacio.';
			SET Var_Control	:= 'folioConsolidacionID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_SolicitudCreditoID = Entero_Cero) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El Numero de Solicitud de Credito esta vacio.';
			SET Var_Control	:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Numero de Credito esta vacio.';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FolioConsolida
		INTO Var_FolioConsolidacionID
		FROM CRECONSOLIDAAGROENC
		WHERE FolioConsolida = Par_FolioConsolidacionID;

		SELECT ProductoCreditoID,	SolicitudCreditoID
		INTO Var_ProductoCreditoID,	Var_SolicitudCreditoID
		FROM SOLICITUDCREDITO
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID
		  AND EsConsolidacionAgro = Con_SI;

		SELECT CreditoID
		INTO Var_CreditoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_FolioConsolidacionID := IFNULL(Var_FolioConsolidacionID, Entero_Cero);
		SET Var_ProductoCreditoID 	 := IFNULL(Var_ProductoCreditoID, Entero_Cero);
		SET Var_SolicitudCreditoID	 := IFNULL(Var_SolicitudCreditoID, Entero_Cero);
		SET Var_CreditoID 			 := IFNULL(Var_CreditoID, Entero_Cero);

		IF( Var_FolioConsolidacionID = Entero_Cero) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'El Folio de Consolidacion no existe.';
			SET Var_Control	:= 'folioConsolidacionID';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_ProductoCreditoID = Entero_Cero) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'El Numero de Producto de Credito no existe o esta Vacio.';
			SET Var_Control	:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_SolicitudCreditoID = Entero_Cero) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= 'El Numero de Solicitud de Credito no existe.';
			SET Var_Control	:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= 'El Numero de Credito no existe.';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT 	RequiereAvales,		CantidadAvales,		RequiereGarantia
		INTO 	Var_RequiereAvales, Var_CantidadAvales,	Var_RequiereGarantia
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Var_ProductoCreditoID;

		SET Var_RequiereAvales		:= IFNULL(Var_RequiereAvales, Con_NO);
		SET Var_RequiereGarantia	:= IFNULL(Var_RequiereGarantia, Con_NO);
		SET Var_CantidadAvales		:= IFNULL(Var_CantidadAvales, Entero_Cero);

		IF(Var_RequiereAvales = Con_NO AND Var_RequiereGarantia = Con_NO ) THEN
			SET Par_NumErr 	:= Entero_Cero;
			SET Par_ErrMen 	:= 'Asignacion de Garantias y Avales Realizada Exitosamente';
			SET Var_Control	:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT SolicitudCreditoID
		INTO Var_SolicitudCreditoOrigen
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_SolicitudCreditoOrigen := IFNULL(Var_SolicitudCreditoOrigen, Entero_Cero);

		SELECT IFNULL(COUNT(SolicitudCreditoID), Entero_Cero)
		INTO Var_NumGarantias
		FROM ASIGNAGARANTIAS
		WHERE SolicitudCreditoID = Var_SolicitudCreditoOrigen
		  AND CreditoID = Par_CreditoID
		  AND Estatus = Est_Autorizada;

		SELECT IFNULL(COUNT(Aval.SolicitudCreditoID), Entero_Cero)
		INTO Var_NumAvales
		FROM AVALESPORSOLICI Aval
		INNER JOIN SOLICITUDCREDITO Sol ON Aval.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN CREDITOS Cre ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
		WHERE Aval.SolicitudCreditoID = Var_SolicitudCreditoOrigen
		  AND Aval.Estatus = Est_Autorizada;

		SET Var_NumGarantias := IFNULL(Var_NumGarantias, Entero_Cero);
		SET Var_NumAvales	 := IFNULL(Var_NumAvales, Entero_Cero);

		-- Si el Credito no tiene aval y garantias termino el proceso
		IF( Var_NumGarantias = Entero_Cero AND Var_NumAvales = Entero_Cero ) THEN
			SET Par_NumErr 	:= Entero_Cero;
			SET Par_ErrMen 	:= 'Asignacion de Garantias y Avales Realizada Exitosamente';
			SET Var_Control	:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_NumGarantias > Entero_Cero ) THEN

			SELECT FechaSistema
			INTO Var_FechaRegistro
			FROM PARAMETROSSIS
			LIMIT 1;

			SET Var_FechaRegistro	:= IFNULL(Var_FechaRegistro, DATE(NOW()));
			SET Aud_FechaActual		:= NOW();

			INSERT INTO ASIGNAGARANTIAS (
				SolicitudCreditoID,		CreditoID,			GarantiaID,		MontoAsignado,	FechaRegistro,
				Estatus,				EstatusSolicitud,	SustituyeGL,	EmpresaID,		Usuario,
				FechaActual,			DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
			SELECT
				Par_SolicitudCreditoID, Par_CreditoID,		GarantiaID,		IFNULL(MontoAsignado, Decimal_Cero),	Var_FechaRegistro,
				Est_Asignada,			Est_Origen,			Con_NO,			Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
			FROM ASIGNAGARANTIAS
			WHERE SolicitudCreditoID = Var_SolicitudCreditoOrigen
			  AND CreditoID = Par_CreditoID
			  AND Estatus = Est_Autorizada;

		END IF;

		IF( Var_NumAvales > Entero_Cero ) THEN

			SET @RegistroID := Entero_Cero;

			INSERT INTO TMPAVALESPORSOLICICONAGRO (
				Transaccion,		ConsecutivoID,
				CreditoID,			SolicitudCreditoID,		AvalID,								ClienteID,
				ProspectoID,		TipoRelacionID,												TiempoDeConocido,
				EmpresaID,			Usuario,				FechaActual,	DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
			SELECT
				Aud_NumTransaccion,	@RegistroID:=(@RegistroID + Entero_Uno),
				Par_CreditoID, 		Aval.SolicitudCreditoID,IFNULL( Aval.AvalID, Entero_Cero),	IFNULL(Aval.ClienteID, Entero_Cero),
				IFNULL(Aval.ProspectoID, Entero_Cero),		Aval.TipoRelacionID,				Aval.TiempoDeConocido,
				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			FROM AVALESPORSOLICI Aval
			INNER JOIN SOLICITUDCREDITO Sol ON Aval.SolicitudCreditoID = Sol.SolicitudCreditoID
			INNER JOIN CREDITOS Cre ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
			WHERE Aval.SolicitudCreditoID = Var_SolicitudCreditoOrigen
			  AND Aval.Estatus = Est_Autorizada;

			SELECT IFNULL(COUNT(ConsecutivoID), Entero_Cero)
			INTO Var_NumRegistros
			FROM TMPAVALESPORSOLICICONAGRO
			WHERE Transaccion = Aud_NumTransaccion;

			SET Var_Contador	:= Entero_Uno;
			SET Var_AvalID		:= Entero_Cero;
			SET Var_CreditoID	:= Entero_Cero;
			SET Var_ClienteID	:= Entero_Cero;
			SET Var_ProspectoID	:= Entero_Cero;
			SET Var_TipoRelacionID		:= Entero_Cero;
			SET Var_TiempoDeConocido	:= Decimal_Cero;
			SET Var_SolicitudCreditoID	:= Entero_Cero;

			WHILE (Var_Contador <= Var_NumRegistros) DO

				SELECT	CreditoID,			SolicitudCreditoID,		AvalID,		ClienteID,		ProspectoID,
						TipoRelacionID,		TiempoDeConocido
				INTO	Var_CreditoID,		Var_SolicitudCreditoID,	Var_AvalID,	Var_ClienteID,	Var_ProspectoID,
						Var_TipoRelacionID,	Var_TiempoDeConocido
				FROM TMPAVALESPORSOLICICONAGRO
				WHERE Transaccion = Aud_NumTransaccion
				  AND ConsecutivoID = Var_Contador;

				SET Var_AvalID				:= IFNULL(Var_AvalID, Entero_Cero);
				SET Var_ClienteID			:= IFNULL(Var_ClienteID, Entero_Cero);
				SET Var_CreditoID			:= IFNULL(Var_CreditoID, Entero_Cero);
				SET Var_ProspectoID			:= IFNULL(Var_ProspectoID, Entero_Cero);
				SET Var_TipoRelacionID		:= IFNULL(Var_TipoRelacionID, Entero_Cero);
				SET Var_TiempoDeConocido	:= IFNULL(Var_TiempoDeConocido, Decimal_Cero);
				SET Var_SolicitudCreditoID	:= IFNULL(Var_SolicitudCreditoID, Entero_Cero);

				SELECT IFNULL(COUNT(Aval.SolicitudCreditoID), Entero_Cero)
				INTO Var_AsignaAval
				FROM AVALESPORSOLICI Aval
				INNER JOIN SOLICITUDCREDITO Sol ON Aval.SolicitudCreditoID = Sol.SolicitudCreditoID
				INNER JOIN CREDITOS Cre ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
				WHERE Aval.SolicitudCreditoID <> Var_SolicitudCreditoOrigen
				  AND Aval.AvalID = Var_AvalID
				  AND Aval.ClienteID = Var_ClienteID
				  AND Aval.ProspectoID = Var_ProspectoID
				  AND Aval.Estatus = Est_Autorizada;

				IF( Var_AsignaAval < Var_CantidadAvales ) THEN

					IF( Var_TiempoDeConocido = Decimal_Cero) THEN
						SET Var_TiempoDeConocido := Entero_Uno;
					END IF;
					SET Aud_FechaActual			:= NOW();

					CALL AVALESPORSOLIALT (
						Par_SolicitudCreditoID,		Var_AvalID,				Var_ClienteID,		Var_ProspectoID,	Est_Asignada,
						Var_TipoRelacionID,			Var_TiempoDeConocido,	SalidaNO,			Par_NumErr,			Par_ErrMen,
						Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,				Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						SET Var_Control := 'avalID';
						LEAVE ManejoErrores;
					END IF;

				END IF;

				SET Var_Contador			:= Var_Contador + Entero_Uno;
				SET Var_AsignaAval			:= Entero_Cero;
				SET Var_AvalID				:= Entero_Cero;
				SET Var_CreditoID			:= Entero_Cero;
				SET Var_ClienteID			:= Entero_Cero;
				SET Var_ProspectoID			:= Entero_Cero;
				SET Var_TipoRelacionID		:= Entero_Cero;
				SET Var_TiempoDeConocido	:= Decimal_Cero;
				SET Var_SolicitudCreditoID	:= Entero_Cero;
			END WHILE;

			DELETE FROM TMPAVALESPORSOLICICONAGRO WHERE Transaccion = Aud_NumTransaccion;
		END IF;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= 'Asignacion de Garantias y Avales Realizada Exitosamente';
		SET Var_Control	:= 'solicitudCreditoID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$