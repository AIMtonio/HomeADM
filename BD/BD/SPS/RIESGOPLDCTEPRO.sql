-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOPLDCTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RIESGOPLDCTEPRO`;DELIMITER $$

CREATE PROCEDURE `RIESGOPLDCTEPRO`(
-- Store para consultar el Nivel de Riesgo Actual de un Cliente
	Par_ClienteID			BIGINT(11),		-- Cliente ID

	Par_Salida				CHAR(1),		-- Indica si el SP genera una salida
	INOUT Par_NumErr		INT,			-- No. error
	INOUT Par_ErrMen		VARCHAR(400),	-- Msg Error

	Par_EmpresaID			INT(11),		-- Auditoria
	Aud_Usuario				INT(11),		-- Auditoria
	Aud_FechaActual			DATETIME,		-- Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Auditoria
	Aud_Sucursal			INT(11),		-- Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_TipoMatriz		INT(11);

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Cero			CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE EvaluacionManual	INT;

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;		-- Entero en Cero
	SET Cadena_Vacia		:= '';		-- Cadena Vacia
	SET Cadena_Cero			:= '0';		-- Cadena Vacia
	SET SalidaSI			:= 'S';		-- Salida SI
	SET EvaluacionManual		:= 1;		-- Tipo de Evaluacion Manual

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-RIESGOPLDCTEPRO');
		END;

		CALL PLDEVALNIVELRIESGOACT(
			Par_ClienteID,			EvaluacionManual,	Par_Salida,			Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

END TerminaStore$$