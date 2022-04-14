

-- SP DEMPARAMETROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS DEMPARAMETROACT;

DELIMITER $$
CREATE PROCEDURE `DEMPARAMETROACT`(
	-- SP para actualizar los parametros del Demonio y sus tareas
	Par_TareaID					INT(11),			-- Identificador de la tarea
	Par_Parametro				VARCHAR(20),		-- Parametro
	Par_Valor					VARCHAR(200),		-- Valor
	Par_NumAct 					TINYINT UNSIGNED, 	-- Numero de Actualizacion
	Par_Salida					CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida

	INOUT Par_NumErr			INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen			VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error
	Aud_EmpresaID				INT(11),			-- Parametros de Auditoria
	Aud_Usuario					INT(11),			-- Parametros de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de Auditoria

	Aud_DireccionIP				VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal				INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN

-- Declaracion de Constantes.
DECLARE Var_SalidaSi			CHAR(1);			-- Indica que si se devuelve un mensaje de salida
DECLARE Cadena_Vacia			CHAR(1);			-- Cadena Vacia
DECLARE Fecha_Vacia				DATE;				-- Fecha Vacia
DECLARE Entero_Cero				INT(11);			-- Entero Cero
DECLARE Act_ValorParametro		TINYINT UNSIGNED; 	-- Actualizacion del valor del parametro

-- Declaracion de Variables
DECLARE Var_Control				VARCHAR(50);		-- Variable de Control
DECLARE Var_Consecutivo			INT(11); 			-- Consecutivo
DECLARE Var_Pametro				VARCHAR(20); 		-- Nombre del Parametro

-- Asignacion de Constantes
SET	Var_SalidaSi				:= 'S';				-- El SP si genera una salida
SET Cadena_Vacia				:= '';				-- Cadena Vacia
SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
SET Entero_Cero					:= 0;				-- Entero Cero
SET Act_ValorParametro			:= 1; 				-- Actualizacion del valor del parametro

-- Valores por default
SET Par_TareaID					:= IFNULL(Par_TareaID, Entero_Cero);
SET Par_Parametro				:= IFNULL(Par_Parametro, Cadena_Vacia);
SET Par_Valor					:= IFNULL(Par_Valor, Cadena_Vacia);

SET Aud_EmpresaID				:= IFNULL(Aud_EmpresaID, Entero_Cero);
SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DEMPARAMETROACT');
		SET Var_Control:= 'sqlException';
	END;

	IF(Par_NumAct = Act_ValorParametro) THEN
		SET Var_Pametro := (SELECT Parametro FROM DEMPARAMETRO WHERE Parametro = Par_Parametro);

		IF(IFNULL(Var_Pametro,Cadena_Vacia)=Cadena_Vacia) THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'No se encontro el parametro especificado';
			SET Var_Control := 'parametro';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		UPDATE DEMPARAMETRO
		SET Valor 				= Par_Valor,
			EmpresaID			= Aud_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,

			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE Parametro = Par_Parametro;

		SET	Par_NumErr 	:= 0;
		SET	Par_ErrMen	:= 'Actualizacion de Parametro Realizado Exitosamente';
		SET Var_Control := 'parametro';
		LEAVE ManejoErrores;
	END IF;

	SET	Par_NumErr 	:= 1;
	SET	Par_ErrMen	:= 'No se Encontro El Numero de Actualizacion.';
	SET Var_Control := 'parametro';
	SET Var_Consecutivo := Entero_Cero;

END ManejoErrores; -- Fin del bloque manejo de errores

IF (Par_Salida = Var_SalidaSi) THEN
	SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
END IF;

END TerminaStore$$ 

