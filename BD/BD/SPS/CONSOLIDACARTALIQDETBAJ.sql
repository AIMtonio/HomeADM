-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLIDACARTALIQDETBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS CONSOLIDACARTALIQDETBAJ;

DELIMITER $$
CREATE  PROCEDURE CONSOLIDACARTALIQDETBAJ(
/* SP DE BAJA PARA DEL DETEALLA DE LAS CARTAS DE CONSOLIDACION */
	Par_ConsolidaCartaID		INT(11),		-- ID de Solicitud de Credito
	Par_TipoCarta				CHAR(1),		-- Tipo Carta de liquidacion

	Par_Salida 					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error

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
DECLARE	Var_Control			CHAR(18);
DECLARE	Var_Consecutivo		INT(11);
DECLARE	Var_SolicitudCreditoID		INT(11);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI		CHAR(1);
DECLARE	SalidaNO		CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI			:= 'S';				-- Salida Si
SET	SalidaNO			:= 'N'; 			-- Salida No
SET Aud_FechaActual		:= CURRENT_TIMESTAMP();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TMPCARTASLIQUIDACIONBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

		IF(Par_ConsolidaCartaID = Entero_Cero) THEN
			SET Par_NumErr		:= 10;
			SET Par_ErrMen		:= 'El folio de consolidación no es válido.';
			SET Var_Control		:= 'consolidaCartaID';
			SET Var_Consecutivo	:= Par_ConsolidaCartaID;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ConsolidaCartaID = Entero_Cero) THEN
			SET Par_NumErr		:= 20;
			SET Par_ErrMen		:= 'El tipo de carta no es válido.';
			SET Var_Control		:= 'tipoCarta';
			SET Var_Consecutivo	:= tipoCarta;
			LEAVE ManejoErrores;
		END IF;

		SET Var_SolicitudCreditoID := (Select SolicitudCreditoID from CONSOLIDACIONCARTALIQ where ConsolidaCartaID = Par_ConsolidaCartaID);


		DELETE
			FROM CONSOLIDACARTALIQDET
			WHERE ConsolidaCartaID = Par_ConsolidaCartaID AND TipoCarta = Par_TipoCarta;

		IF IFNULL(Var_SolicitudCreditoID,Entero_Cero) > Entero_Cero THEN
			CALL CONSOLIDACIONCARTALIQACT(Var_SolicitudCreditoID,		Par_ConsolidaCartaID,			Cadena_Vacia,		1, 		SalidaNO,
						Par_NumErr,					Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
			IF Par_NumErr <> Entero_Cero THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Detalle de Cartas Eliminadas Exitosamente.';
	SET Var_Control:= 'consolidaCartaID';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
