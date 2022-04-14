-- SP NOMESQUEMATASACREDBAJ
DELIMITER ;

DROP PROCEDURE IF EXISTS NOMESQUEMATASACREDBAJ;

DELIMITER $$

CREATE PROCEDURE NOMESQUEMATASACREDBAJ(
	-- STORE PROCEDURE PARA ELIMINAR ESQUEMA DE TASAS DE CREDITO
	Par_CondicionCredID		BIGINT(20),		-- Identificador de Condicion Credito
	Par_Salida				CHAR(1),		-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),		-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID			INT(11),		-- Parametros de auditoria
	Aud_Usuario				INT(11),		-- Parametros de auditoria
	Aud_FechaActual			DATETIME,		-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametros de auditoria
	Aud_Sucursal			INT(11),		-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametros de auditoria
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(1);				-- Entero Cero
	DECLARE SalidaSI				CHAR(1);			-- Cadena SI

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET SalidaSI					:= 'S';				-- Cadena SI

	-- Asignacion de valores por defecto
	SET Par_CondicionCredID			:= IFNULL(Par_CondicionCredID, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-NOMESQUEMATASACREDBAJ');
			SET Var_Control	= 'sqlException';
		END;

		IF(Par_CondicionCredID = Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen 		:= 'El numero del condicion credito esta vacio';
			SET Var_Control		:= 'condicionCredID';
			LEAVE ManejoErrores;
		END IF;
        
		DELETE FROM NOMESQUEMATASACRED
			WHERE CondicionCredID = Par_CondicionCredID;

		-- El registro se elimino exitosamente
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Los esquemas de tasa de credito se han eliminado exitosamente: ', CAST(Par_CondicionCredID AS CHAR));
		SET Var_Control	:= 'condicionCredID';
	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	Control;
	END IF;

END TerminaStore$$
