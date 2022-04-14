-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCARTASLIQUIDACIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS TMPCARTASLIQUIDACIONALT;


DELIMITER $$

CREATE PROCEDURE TMPCARTASLIQUIDACIONALT(
	Par_ConsolidaCartaID	INT(11),		-- Folio de consolidación de créditos
	Par_CartaLiquidaID		INT(11),		-- ID Consecutivo de la tabla de Cartas Liquidación
	Par_RecursoCartaLiq		MEDIUMBLOB,		-- Carta de liquidación en binario relacionadas con la consolidación

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
	DECLARE Var_Cuenta				INT;			-- Variable para contar registros
	DECLARE Var_Consecutivo			INT;			-- Consecutivo
	DECLARE Entero_Uno				INT;
	DECLARE SalidaNO				CHAR(1);
	DECLARE Var_ConsCartaID			INT(11);

	-- Inicialización de constantes
	SET Entero_Cero			:= 0;			-- Constante entero cero
	SET Decimal_Cero		:= 0.0;			-- Constante DECIMAL cero
	SET Var_SalidaSI		:= 'S';			-- Constante de SI
	SET Var_Vacio			:= '';			-- Constante de vacío
	SET Var_Estatus			:= 'A';			-- Estatus A = Activa
	SET Entero_Uno			:= 1;
	SET SalidaNO			:= 'N';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSOLIDACIONCARTALIQALT');

			SET Var_Control:= 'sqlException';
		END;

		IF NOT EXISTS (SELECT ConsolidaCartaID
						 FROM CONSOLIDACIONCARTALIQ
						WHERE ConsolidaCartaID = Par_ConsolidaCartaID) THEN

			SET Par_NumErr		:= 10;
			SET Par_ErrMen		:= 'El número de consolidación no es válido.' ;
			SET Var_Control		:= 'consolidaCartaID';
			SET Var_Consecutivo	:= Par_ConsolidaCartaID;
			LEAVE ManejoErrores;

		END IF;

		IF NOT EXISTS (SELECT CartaLiquidaID
						 FROM CARTALIQUIDACION
						WHERE CartaLiquidaID = Par_CartaLiquidaID) THEN

			SET Par_NumErr		:= 20;
			SET Par_ErrMen		:= 'La carta de Liquidación no es válida.' ;
			SET Var_Control		:= 'cartaLiquidaID';
			SET Var_Consecutivo	:= Par_CartaLiquidaID;
			LEAVE ManejoErrores;

		END IF;

		IF EXISTS (SELECT ConsolidaCartaID
						 FROM TMPCARTASLIQUIDACION
						WHERE ConsolidaCartaID = Par_ConsolidaCartaID
						  AND CartaLiquidaID = Par_CartaLiquidaID ) THEN

			SET Par_NumErr		:= 30;
			SET Par_ErrMen		:= 'La consolidación de carta interna ya existe.' ;
			SET Var_Control		:= 'cartaLiquidaID';
			SET Var_Consecutivo	:= Par_CartaLiquidaID;
			LEAVE ManejoErrores;

		END IF;

		SELECT ConsolidaCartaID
		  INTO Var_ConsCartaID
		  FROM TMPCARTASLIQUIDACION
		 WHERE CartaLiquidaID = Par_CartaLiquidaID
		 LIMIT 1;

		IF (Var_ConsCartaID > Entero_Cero ) THEN

			SET Par_NumErr		:= 40;
			SET Par_ErrMen		:= CONCAT('La Carta Interna ya fue Asignada en la Consolidación: ', Var_ConsCartaID) ;
			SET Var_Control		:= 'cartaLiquidaID';
			SET Var_Consecutivo	:= Par_CartaLiquidaID;
			LEAVE ManejoErrores;

		END IF;

		SELECT ConsolidaCartaID
		  INTO Var_ConsCartaID
		  FROM CONSOLIDACARTALIQDET
		 WHERE CartaLiquidaID = Par_CartaLiquidaID
		 LIMIT 1;

		IF (Var_ConsCartaID > Entero_Cero ) THEN

			SET Par_NumErr		:= 40;
			SET Par_ErrMen		:= CONCAT('La carta interna ya fue asignada en la consolidación: ', Var_ConsCartaID) ;
			SET Var_Control		:= 'cartaLiquidaID';
			SET Var_Consecutivo	:= Par_CartaLiquidaID;
			LEAVE ManejoErrores;

		END IF;


		SET	Aud_FechaActual	:= CURRENT_TIMESTAMP();

		-- Inserta Cartas de liquidación internas
		INSERT INTO TMPCARTASLIQUIDACION (
					ConsolidaCartaID,	CartaLiquidaID,		RecursoCartaLiq,	EmpresaID,	Usuario,
					FechaActual,		DireccionIP,		ProgramaID,			Sucursal,	NumTransaccion)

		VALUES	(
				Par_ConsolidaCartaID,	Par_CartaLiquidaID,		Par_RecursoCartaLiq,	Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);


			-- Ejecuta la actualización de la consolidación de acuerdo con su clarificación, relacionado, tipo de Credito
			CALL CONSOLIDACIONCARTALIQACT(
						Entero_Cero,			Par_ConsolidaCartaID,	Var_Vacio,			Entero_Uno, 		SalidaNO,
						Par_NumErr,		 		Par_ErrMen,				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr > Entero_Cero) THEN
				SET Par_NumErr := Par_NumErr;
				SET Par_ErrMen := Par_ErrMen;
				SET Var_Control:= 'Par_ConsolidaCartaID';

				LEAVE ManejoErrores;
			END IF;


		SET		Par_NumErr	:= 0;
		SET		Par_ErrMen	:= CONCAT('Consolidación Agregada Exitosamente: ', CONVERT(Par_ConsolidaCartaID, CHAR));
		SET		Var_Control	:= 'consolidaCartaID';

END ManejoErrores;

		IF(Par_Salida = Var_SalidaSI) THEN
			SELECT  Par_NumErr				AS NumErr,
					Par_ErrMen				AS ErrMen,
					Var_Control				AS control,
					Par_ConsolidaCartaID	AS consecutivo; -- Enviar siempre en exito el numero de consolidacion
		END IF;

END TerminaStore$$