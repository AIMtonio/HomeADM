-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREGUNTASSEGURIDADBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREGUNTASSEGURIDADBAJ`;DELIMITER $$

CREATE PROCEDURE `PREGUNTASSEGURIDADBAJ`(
	-- Baja de Preguntas de Seguridad
    Par_ClienteID		INT(11),			-- Numero de Cliente
    Par_Salida 			CHAR(1),			-- Indica si espera un SELECT de Salida
	INOUT Par_NumErr 	INT(11),			-- Numero de Error
	INOUT Par_ErrMen 	VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

     -- Declaracion de variables
	 DECLARE Var_Control 	VARCHAR(100);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Salida_SI		CHAR(1);

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';           	-- Constante cadena vacia
	SET	Fecha_Vacia		:= '1900-01-01'; 	-- Constante fecha vacia
	SET	Entero_Cero		:= 0;            	-- Constante entero cero
	SET Salida_SI 		:= 'S';				-- Constante: SI


	 ManejoErrores: BEGIN

	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-PREGUNTASSEGURIDADBAJ');

		END;

		DELETE FROM PREGUNTASSEGURIDAD WHERE ClienteID = Par_ClienteID;

        SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= 'Preguntas de Seguridad Eliminadas Exitosamente.';
		SET Var_Control	:= 'cuentasBcaMovID';

	END ManejoErrores;

    IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$