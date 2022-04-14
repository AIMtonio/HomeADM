-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDEVALNIVELRIESGOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDEVALNIVELRIESGOACT`;DELIMITER $$

CREATE PROCEDURE `PLDEVALNIVELRIESGOACT`(
/*SP PARA ACTUALIZAR EL NIVEL DE RIESGO POR CLIENTE*/
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
	DECLARE Var_ClienteEvaluaMatriz	CHAR(1);		# Evalua nivel de riesgo
	DECLARE Var_TipoMatriz			INT(11);		# Tipo de Matriz

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		# Cadena Vacia
	DECLARE Entero_Cero				INT(11);		# Entero Cero
	DECLARE MatrizOrigina			INT(11);		# Matriz de Riesgo Original
	DECLARE MatrizPuntos			INT(11);		# Matriz de Riesgo basado en porcentajes
	DECLARE Salida_NO				CHAR(1);		# Salida No
	DECLARE Salida_SI				CHAR(1);		# Salida Si
	DECLARE Cons_SI					CHAR(1);		# Constante Si

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET MatrizOrigina				:= 1;
	SET MatrizPuntos				:= 2;
	SET Salida_NO					:= 'N';
	SET Salida_SI					:= 'S';
	SET Cons_SI						:= 'S';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDEVALNIVELRIESGOACT');
			SET Var_Control := 'sqlException';
		END;

		SET Var_TipoMatriz 			:= (SELECT PAR.TipoMatrizPLD FROM PARAMETROSSIS AS PAR);
		SET Var_ClienteEvaluaMatriz	:= (SELECT CTE.EvaluaXMatriz FROM CONOCIMIENTOCTE AS CTE WHERE ClienteID = Par_ClienteID);
		SET Var_ClienteEvaluaMatriz	:= IFNULL(Var_ClienteEvaluaMatriz, Cons_SI);


			IF(Var_TipoMatriz = 1) THEN
				CALL RIESGOPLDCTEVERANTPRO(
					Par_ClienteID,		Par_Salida,			Par_NumErr,			Par_ErrMen,			Aud_Empresa,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);
				IF(Par_NumErr!=Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			  ELSE
			  	IF(Var_ClienteEvaluaMatriz = Cons_SI) THEN
					CALL PLDNIVELRIESGOPUNTOSACT(
						Par_ClienteID,		Par_TipoEval,		Salida_NO,			Par_NumErr,			Par_ErrMen,
						Aud_Empresa,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr!=Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
		END IF;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$