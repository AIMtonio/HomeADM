-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLIDACIONCARTALIQALT
DELIMITER ;
DROP PROCEDURE IF EXISTS CONSOLIDACIONCARTALIQALT;


DELIMITER $$

CREATE PROCEDURE CONSOLIDACIONCARTALIQALT(
	Par_ClienteID			INT(11),		-- Identificador del cliente

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
	DECLARE Var_ConsolidaCartaID	INT;			-- Consecutivo de ConsolidaCartaID
	DECLARE Con_EsConsolidado		CHAR(1);		-- Constante EsConsolidado "S"
	DECLARE Con_FlujoOrigen			CHAR(1);		-- Constante FlujoOrigen "C"
	-- Inicialización de constantes
	SET Entero_Cero			:= 0;			-- Constante entero cero
	SET Decimal_Cero		:= 0.0;			-- Constante DECIMAL cero
	SET Var_SalidaSI		:= 'S';			-- Constante de SI
	SET Var_Vacio			:= '';			-- Constante de vacío
	SET Var_Estatus			:= 'A';			-- Estatus A = Activa
	SET Con_EsConsolidado	:= 'S';			-- Constante EsConsolidado "S"
	SET Con_FlujoOrigen		:= 'C';			-- Constante FlujoOrigen "C"

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSOLIDACIONCARTALIQALT');

			SET Var_Control:= 'sqlException';
		END;

		IF NOT EXISTS(SELECT ClienteID
						FROM CLIENTES
						WHERE ClienteID = Par_ClienteID) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := CONCAT('El Cliente ', CONVERT(Par_ClienteID, CHAR), ' no Existe');
			LEAVE ManejoErrores;
		END IF;

		SET	Aud_FechaActual	:= CURRENT_TIMESTAMP();

		SELECT IFNULL(MAX(ConsolidaCartaID)+1,1) INTO Var_ConsolidaCartaID
		  FROM CONSOLIDACIONCARTALIQ;

		-- Inserta el nuevo folio de consolidación.
		INSERT INTO CONSOLIDACIONCARTALIQ(
						ConsolidaCartaID,	ClienteID,		SolicitudCreditoID,		Estatus,		EsConsolidado,
						FlujoOrigen,		EmpresaID,		Usuario,				FechaActual,	DireccionIP,
						ProgramaID,			Sucursal,		NumTransaccion)
		VALUES	(
				Var_ConsolidaCartaID,	Par_ClienteID,		Entero_Cero,		Var_Estatus,		Con_EsConsolidado,
				Con_FlujoOrigen,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
				);

		SET		Par_NumErr	:= 0;
		SET		Par_ErrMen	:= CONCAT('Consolidacion Agregada Exitosamente: ', CONVERT(Var_ConsolidaCartaID, CHAR));
		SET		Var_Control	:= 'consolidaCartaID';

END ManejoErrores;

		IF(Par_Salida = Var_SalidaSI) THEN
			SELECT  Par_NumErr				AS NumErr,
					Par_ErrMen				AS ErrMen,
					Var_Control				AS control,
					Var_ConsolidaCartaID	AS consecutivo; -- Enviar siempre en exito el numero de consolidacion
		END IF;

END TerminaStore$$




