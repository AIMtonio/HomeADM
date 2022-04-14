-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLIDACARTALIQDETALT
DELIMITER ;
DROP PROCEDURE IF EXISTS CONSOLIDACARTALIQDETALT;


DELIMITER $$

CREATE PROCEDURE CONSOLIDACARTALIQDETALT(
	Par_SolicitudCreditoID	BIGINT(20),		-- ID del Solicitud de Credito
	Par_ConsolidaCartaID	INT(11),		-- Consecutivo de consolidación de acuerdo con la solicitud de crédito
	Par_AsigCartaID			BIGINT(20),		-- Identificador de la Carta de liquidacion en ASIGCARTASLIQUIDACION
	Par_CartaLiquidaID		INT(11),		-- Identificador de la Carta de liquidacion en CARTALIQUIDACION
	Par_TipoCarta			CHAR(1),		-- Tipo de Carta de liquidacion I = Internas, E = Externas

	Par_Salida				CHAR(1),		-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),		-- Control de Errores: Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Control de Errores: Descripcion del Error

	Aud_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
					)

TerminaStore: BEGIN
	-- Declaraciòn de variables y constantes
	DECLARE Entero_Cero				INT;			-- Constante Entero cero
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante Decimal cero
	DECLARE Var_Estatus				CHAR(1);		-- Variable de estatus activa o inactiva: A = Activa, I = Inactiva.
	DECLARE Var_Control				VARCHAR(100);	-- Variable de control
	DECLARE Var_SalidaSI			CHAR(1);		-- Constante de SI
	DECLARE Var_Vacio				CHAR(1);		-- Constante de vacío
	DECLARE Var_Interna				CHAR(1);		-- Constante de Interna
	DECLARE Var_Externa				CHAR(1);		-- Constante de Externa
	DECLARE Var_Cuenta				INT;			-- Variable para contar registros
	DECLARE Var_Consecutivo			INT;			-- Variable de salida de la consolidacion
	DECLARE Var_TipoCarta			VARCHAR(10);	-- Tipo de Carta de liquidacion I = Internas, E = Externas
	DECLARE Var_AsignacionCartaID	INT;			-- Consecutivo de la AsignacionCartaID
	DECLARE Entero_Uno				INT;
	DECLARE Entero_Dos				INT(11);
	DECLARE SalidaNO				CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Var_ConsCartaID			INT(11);

	-- Inicialización de constantes
	SET Entero_Cero			:= 0;				-- Constante entero cero
	SET Decimal_Cero		:= 0.0;				-- Constante DECIMAL cero
	SET Var_SalidaSI		:= 'S';				-- Constante de SI
	SET Var_Vacio			:= '';				-- Constante de vacío
	SET Var_Estatus			:= 'A';				-- Estatus A = Activa
	SET Var_Interna			:= 'I';				-- Carta Interna
	SET Var_Externa			:= 'E';				-- Carta Externa
	SET Var_TipoCarta		:= 'I,E'; 			-- Tipo de Carta de liquidacion I = Internas, E = Externas
	SET Entero_Uno			:= 1;
	SET Entero_Dos			:= 2;
	SET SalidaNO			:= 'N';
	SET Cadena_Vacia		:= '';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSOLIDACARTALIQDETALT');

			SET Var_Control:= 'sqlException';
		END;

		-- Valida el ID de consolidación
		IF NOT EXISTS (SELECT ConsolidaCartaID
						 FROM CONSOLIDACIONCARTALIQ
						WHERE ConsolidaCartaID = Par_ConsolidaCartaID) THEN

			SET Par_NumErr		:= 10;
			SET Par_ErrMen		:= 'El número de consolidación no es válido.' ;
			SET Var_Control		:= 'consolidaCartaID';
			SET Var_Consecutivo	:= Par_ConsolidaCartaID;
			LEAVE ManejoErrores;

		END IF;

		-- Valida el tipo de carta
		IF ((SELECT FIND_IN_SET(Par_TipoCarta,Var_TipoCarta)) = Entero_Cero) THEN

			SET Par_NumErr		:= 20;
			SET Par_ErrMen		:= 'El tipo carta no es válido.' ;
			SET Var_Control		:= 'tipoCarta';
			SET Var_Consecutivo	:= Var_Cuenta;
			LEAVE ManejoErrores;

		END IF;

		-- Si es carta interna, valida que exista la carta interna
		IF Par_TipoCarta = Var_Interna THEN

			IF NOT EXISTS (SELECT CartaLiquidaID
							 FROM CARTALIQUIDACION
							WHERE CartaLiquidaID = Par_CartaLiquidaID) THEN

				SET Par_NumErr		:= 30;
				SET Par_ErrMen		:= 'La carta de liquidación interna no es válida.' ;
				SET Var_Control		:= 'cartaLiquidaID';
				SET Var_Consecutivo	:= Par_CartaLiquidaID;
				LEAVE ManejoErrores;

			END IF;

			SELECT ConsolidaCartaID INTO Var_ConsCartaID
			 FROM CONSOLIDACARTALIQDET
			WHERE CartaLiquidaID = Par_CartaLiquidaID
			LIMIT 1;

			IF (Var_ConsCartaID > Entero_Cero) THEN

				SET Par_NumErr		:= 60;
				SET Par_ErrMen		:= CONCAT('La carta especificada ya fue asignada en la consolidación: ',Var_ConsCartaID) ;
				SET Var_Control		:= 'consolidaCartaID';
				SET Var_Consecutivo	:= Par_ConsolidaCartaID;
				LEAVE ManejoErrores;

			END IF;

			SET Var_AsignacionCartaID := Entero_Cero;

		END IF;

		-- si es carta externa
		IF Par_TipoCarta = Var_Externa THEN

			-- Valida que la carta externa exista
			IF NOT EXISTS (SELECT AsignacionCartaID
							 FROM ASIGCARTASLIQUIDACION
							WHERE AsignacionCartaID = Par_AsigCartaID) THEN

				SET Par_NumErr		:= 40;
				SET Par_ErrMen		:= 'La carta de liquidación externa no es válida.' ;
				SET Var_Control		:= 'asignacionCartaID';
				SET Var_Consecutivo	:= Par_AsigCartaID;
				LEAVE ManejoErrores;

			END IF;


		END IF;


		IF EXISTS (SELECT ConsolidaCartaID
							 FROM CONSOLIDACARTALIQDET
							WHERE ConsolidaCartaID		= Par_ConsolidaCartaID
							  AND AsignacionCartaID		= Par_AsigCartaID
							  AND CartaLiquidaID		= Par_CartaLiquidaID) THEN

			SET Par_NumErr		:= 50;
			SET Par_ErrMen		:= 'La carta especificada ya existe con el nro de consolidación' ;
			SET Var_Control		:= 'consolidaCartaID';
			SET Var_Consecutivo	:= Par_ConsolidaCartaID;
			LEAVE ManejoErrores;

		END IF;




		SET	Aud_FechaActual	:= CURRENT_TIMESTAMP();

		-- Inserta Detalle de consolidación
		INSERT INTO CONSOLIDACARTALIQDET (
			ConsolidaCartaID,	AsignacionCartaID,	CartaLiquidaID,		TipoCarta,		EmpresaID,
			Usuario,			FechaActual,		DireccionIP,		ProgramaID,		Sucursal,
			NumTransaccion)

		VALUES	(
			Par_ConsolidaCartaID,	Par_AsigCartaID,		Par_CartaLiquidaID,		Par_TipoCarta,		Aud_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		-- Ejecuta la actualización de la consolidación de acuerdo con su clasificación, relacionado, tipo de Credito
		CALL CONSOLIDACIONCARTALIQACT(
					Par_SolicitudCreditoID,		Entero_Cero,			Cadena_Vacia,		Entero_Uno, 		SalidaNO,
					Par_NumErr,					Par_ErrMen,				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr > Entero_Cero) THEN
			SET Par_NumErr := Par_NumErr;
			SET Par_ErrMen := Par_ErrMen;
			SET Var_Control:= 'creditoID';

			LEAVE ManejoErrores;
		END IF;

		CALL INSTRUCDISPERSIONCREACT(
				Par_SolicitudCreditoID,		Entero_Dos,		SalidaNO,			Par_NumErr,			Par_ErrMen,
				Aud_EmpresaID,				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

		IF (Par_NumErr > Entero_Cero) THEN
			SET Par_NumErr := Par_NumErr;
			SET Par_ErrMen := Par_ErrMen;
			SET Var_Control:= 'creditoID';

			LEAVE ManejoErrores;
		END IF;


		SET		Par_NumErr		:= 00;
		SET		Par_ErrMen		:= CONCAT('Detalle de consolidación Agregado Exitosamente: ', CONVERT(Par_ConsolidaCartaID, CHAR));
		SET		Var_Control		:= 'consolidaCartaID';
		SET 	Var_Consecutivo	:= Par_ConsolidaCartaID;

END ManejoErrores;

		IF(Par_Salida = Var_SalidaSI) THEN
			SELECT  Par_NumErr			AS NumErr,
					Par_ErrMen			AS ErrMen,
					Var_Control			AS control,
					Var_Consecutivo		AS consecutivo; -- Enviar siempre en exito el numero de consolidacion
		END IF;

END TerminaStore$$