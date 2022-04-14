-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDNIVELRIESGOPUNTOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDNIVELRIESGOPUNTOSACT`;DELIMITER $$

CREATE PROCEDURE `PLDNIVELRIESGOPUNTOSACT`(
/*SP que realiza el proceso de asignacion del nivel de riesgo basado en la matriz de riesgo por puntos*/
	Par_ClienteID			INT(11),			# ID del Cliente CLIENTES
	Par_TipoEval			INT(11),			# Tipo de Evaluación 1.Individual		2.Masiva
	Par_Salida 				CHAR(1), 			# Salida S:Si N:No
	INOUT	Par_NumErr		INT(11),			# Numero de error
	INOUT	Par_ErrMen		VARCHAR(400),		# Mensaje de error

	/* Parametros de Auditoria */
	Aud_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Consecutivo			VARCHAR(50);	# Consecutivo que se mostrara en pantalla
	DECLARE Var_Control				VARCHAR(20);	# Campo para el id del control de pantalla
	DECLARE Var_ClienteEvaluaMatriz	INT(11);		# Evalua nivel de riesgo
	DECLARE Var_TipoMatriz			INT(11);		# Tipo de Matriz

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		# Cadena Vacia
	DECLARE Entero_Cero				INT(11);		# Entero Cero
	DECLARE EvaluacionInd			INT(11);		# Evaluacion Individual
	DECLARE EvaluacionMas			INT(11);		# Evaluacion Masiva
	DECLARE Salida_NO				CHAR(1);		# Salida No
	DECLARE Salida_SI				CHAR(1);		# Salida Si
	DECLARE Cons_SI					CHAR(1);		# Constante Si

		-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET EvaluacionInd				:= 1;
	SET EvaluacionMas				:= 2;
	SET Salida_NO					:= 'N';
	SET Salida_SI					:= 'S';
	SET Cons_SI						:= 'S';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDNIVELRIESGOPUNTOSACT');
			SET Var_Control := 'sqlException';
		END;
		IF(Par_TipoEval = EvaluacionInd)THEN
			CALL PLDNIVELRIESGOPUNTOSINDACT(
				Par_ClienteID,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Empresa,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		  ELSEIF(Par_TipoEval = EvaluacionMas)THEN
			CALL PLDNIVELRIESGOPUNTOSMASACT(
				Salida_NO,			Par_NumErr,			Par_ErrMen,				Aud_Empresa,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$