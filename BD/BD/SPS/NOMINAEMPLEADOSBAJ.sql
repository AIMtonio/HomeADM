
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMINAEMPLEADOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMINAEMPLEADOSBAJ`;
DELIMITER $$


CREATE PROCEDURE `NOMINAEMPLEADOSBAJ`(
-- ==========================================================
-- SP PARA DAR DE BAJA LOS ACCESORIOS A COBRAR DE UN CREDITO
-- ==========================================================
	Par_NominaEmpleadoID		INT(11),		-- Empleado de Nomima
    Par_InstitNominaID			INT(11),		-- Institucion
        
	Par_Salida           		CHAR(1),		# Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT,			# Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	# Mensaje de Error

    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	Var_Control     		CHAR(15); 		-- Variable de Control en Pantalla
DECLARE	Var_Consecutivo 		INT(11); 		-- Varibale de Consecutivo en Pantalla

-- DECLARACION DE CONSTANTES
DECLARE SalidaSI				CHAR(1);		-- Salida SI
DECLARE Entero_Cero				INT(11);		-- Entero Cero

-- ASIGNACION DE CONSTANTES
SET SalidaSI					:= "S";
SET Entero_Cero					:= 0;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-NOMINAEMPLEADOSBAJ');
			SET Var_Control:= 'SQLEXCEPTION' ;
		END;


    DELETE FROM NOMINAEMPLEADOS
		WHERE NominaEmpleadoID = Par_NominaEmpleadoID
        AND InstitNominaID = Par_InstitNominaID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Proceso realizado exitosamente.';
	SET Var_Control:= 'clienteID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$