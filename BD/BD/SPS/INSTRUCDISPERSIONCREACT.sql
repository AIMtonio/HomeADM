-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTRUCDISPERSIONCREACT
DELIMITER ;
DROP PROCEDURE IF EXISTS INSTRUCDISPERSIONCREACT;


DELIMITER $$
CREATE PROCEDURE INSTRUCDISPERSIONCREACT(
# =====================================================================================
# ------- STORE PARA ACTUALIZAR DISPESIONES DE SOLICITUDES DE CREDITOS---------
# =====================================================================================
	Par_SolicCredID		BIGINT(20),
	Par_NumAct			TINYINT UNSIGNED,

	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),
	-- Parametros de Auditoria
	Aud_EmpresaID       INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
	)

	TerminaStore: BEGIN
		-- Declara variables y constantes
		DECLARE Entero_Cero   	    INT(11);		-- Constante entero cero
		DECLARE Act_Disp			INT(11);		-- Varible para validar la existencia de la dispersión
		DECLARE Var_NumAct			INT(11);		-- Constante actualiza dispersión
		DECLARE Var_NumActR			INT(11);		-- Constante reistra dispersión
		DECLARE Var_Estatus			CHAR(1);		-- Variable para el estatus de la dispesriòn
		DECLARE Var_EstatusR			CHAR(1);		-- Variable para el estatus de la dispesriòn
		DECLARE Var_Control			VARCHAR(100);	-- Variable de control
		DECLARE SalidaSI			CHAR(1);		-- Parametro de salida
		DECLARE Var_MontoDispersion DECIMAL(14,2);
		DECLARE var_Monto_Ext		DECIMAL(14,2);
		DECLARE Var_Monto_Int		DECIMAL(14,2);
		DECLARE Var_TipoCarta		CHAR(1);

		-- Inicializa Valores
		SET	Entero_Cero		:= 0;	-- Constante entero cero
		SET Var_NumAct		:= 1;	-- Actualiza dispersiòn
		SET Var_NumActR		:= 2;	-- Actualiza dispersiòn
		SET Var_Estatus		:= 'A';	-- Estatus Autorizado
		SET Var_EstatusR	:= 'R';	-- Estatus
		SET SalidaSI		:= 'S';	-- Salida SI
		SET Var_TipoCarta	:= 'I';


ManejoErrores:BEGIN


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-INSTRUCDISPERSIONCREACT');

		SET Var_Control:= 'sqlException';
	END;

	IF (Par_NumAct = Var_NumAct) THEN

		IF NOT EXISTS (SELECT SolicitudCreditoID
						   FROM INSTRUCDISPERSIONCRE
						  WHERE SolicitudCreditoID = Par_SolicCredID) THEN

			SET Par_NumErr := 001;
			SET Par_ErrMen := CONCAT('La solicitud de crédito no existe: ', CONVERT(Par_SolicCredID, CHAR));
			SET Var_Control:= 'solicitudCreditoID';

			LEAVE ManejoErrores;

		END IF;
	
		SELECT	sum(ASI.Monto) INTO var_Monto_Ext
			FROM CONSOLIDACIONCARTALIQ		AS CONS
			INNER JOIN ASIGCARTASLIQUIDACION	AS ASI ON CONS.SOLICITUDCREDITOID	= ASI.SOLICITUDCREDITOID
			INNER JOIN CASASCOMERCIALES		AS CAS ON ASI.CasaComercialID		= CAS.CasaComercialID
			WHERE ASI.SolicitudCreditoID 		= Par_SolicCredID;


		SELECT	sum(CDET.MontoLiquidar) INTO Var_Monto_Int
			FROM CONSOLIDACIONCARTALIQ			AS LIQ
			INNER JOIN CONSOLIDACARTALIQDET		AS LDET	ON LIQ.ConsolidaCartaID	= LDET.ConsolidaCartaID AND LDET.TIPOCARTA = Var_TipoCarta
			INNER JOIN CARTALIQUIDACION			AS Cliq	ON LDET.CartaLiquidaID	= Cliq.CartaLiquidaID
			INNER JOIN CARTALIQUIDACIONDET		AS CDET ON Cliq.CartaLiquidaID	= CDET.CartaLiquidaID
			WHERE	LIQ.SolicitudCreditoID	= Par_SolicCredID;

		SELECT SUM(MontoDispersion) INTO Var_MontoDispersion
			FROM BENEFICDISPERSIONCRE WHERE SolicitudCreditoID = Par_SolicCredID AND PermiteModificar IN (2,3);

		SET Var_MontoDispersion := IFNULL(Var_MontoDispersion, Entero_Cero);
		SET var_Monto_Ext		:= IFNULL(var_Monto_Ext, Entero_Cero);
		SET Var_Monto_Int		:= IFNULL(Var_Monto_Int, Entero_Cero);

		IF (Var_MontoDispersion <> (var_Monto_Ext + Var_Monto_Int) ) THEN
		-- validación.
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'Es Necesario Guardar las Instrucciones de Dispersión. Favor de Verificar.';
			SET Var_Control:= 'solicitudCreditoID';

			LEAVE ManejoErrores;
		END IF;

		UPDATE INSTRUCDISPERSIONCRE
		   SET Estatus = Var_Estatus
		 WHERE SolicitudCreditoID = Par_SolicCredID;

	END IF;

	IF(Par_NumAct = Var_NumActR) THEN
		UPDATE INSTRUCDISPERSIONCRE
		   SET Estatus = Var_EstatusR
		 WHERE SolicitudCreditoID = Par_SolicCredID;
	END IF;


	SET Par_NumErr 		:= 000;
	SET Par_ErrMen 		:= CONCAT('El estatus se actualizó exitosamente : ',CONVERT(Par_SolicCredID, CHAR));
	SET Var_Control 	:= 'solicitudCreditoID';


END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT
			Par_NumErr		AS NumErr,
			Par_ErrMen		AS ErrMen,
			Var_Control		AS Control,
			Par_SolicCredID AS Consecutivo;
	END IF;

END TerminaStore$$