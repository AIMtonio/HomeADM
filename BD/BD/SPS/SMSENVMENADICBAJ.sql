-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSENVMENADICBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSENVMENADICBAJ`;DELIMITER $$

CREATE PROCEDURE `SMSENVMENADICBAJ`(
	-- SP para dar de baja los mensajes ya enviados o que fallaron al momento del envio
	Par_Salida			CHAR(1),		-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr    INT(11),		-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen    VARCHAR(400),	-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID		INT(11),		-- Parametros de auditoria
	Aud_Usuario			INT(11),		-- Parametros de auditoria
	Aud_FechaActual		DATETIME,		-- Parametros de auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametros de auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametros de auditoria
	Aud_Sucursal		INT(11),		-- Parametros de auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);			-- Entero Cero
	DECLARE SalidaSI			CHAR(1);			-- Salida SI
	DECLARE SalidaNO			CHAR(1);			-- Salida NO
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;				-- Fecha vacia

	-- Asignacion de constantes
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET	SalidaSI				:= 'S';				-- Salida SI
	SET	SalidaNO				:= 'N';				-- Salida NO
	SET	Cadena_Vacia			:= '';				-- Cadena vacia
	SET	Fecha_Vacia     		:= '1900-01-01';	-- Fecha vacia

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSENVMENADICBAJ');
			SET Var_Control = 'sqlException';
		END;

		DELETE sms
			FROM SMSENVMENADIC AS sms
			INNER JOIN HISSMSENVMENADIC AS his ON sms.EnvioID = his.EnvioID;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Registros eliminados exitosamente';
		SET Var_Control	:= Cadena_Vacia;
	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control,
				Entero_Cero	AS consecutivo;
	END IF;
END TerminaStore$$