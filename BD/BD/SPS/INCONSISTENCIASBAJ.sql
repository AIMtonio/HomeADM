-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INCONSISTENCIASBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `INCONSISTENCIASBAJ`;DELIMITER $$

CREATE PROCEDURE `INCONSISTENCIASBAJ`(
-- ============================================================================================================
-- SP PARA ELIMINAR LAS INCONSISTENCIAS QUE EXISTEN EN LOS NOMBRES DE CLIENTES, PROSPECTOS, AVALES Y GARANTES
-- ============================================================================================================

	Par_ClienteID			INT(11),		-- ID del Cliente
	Par_ProspectoID			BIGINT(20),		-- ID del Prospecto
	Par_AvalID				BIGINT(20),		-- ID del Aval
	Par_GaranteID			INT(11),		-- ID del Garante

	Par_Salida				CHAR(1),		# Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),		# Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	# Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
  	Aud_FechaActual 		DATETIME,
  	Aud_DireccionIP 		VARCHAR(15),
  	Aud_ProgramaID 			VARCHAR(50),
  	Aud_Sucursal 			INT(11),
  	Aud_NumTransaccion 		BIGINT(20)

)
TerminaStore: BEGIN

-- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Entero_Cero		INT(11);
    DECLARE Cons_SI			CHAR(1);


	-- Declaracion de variables
	DECLARE Var_Control 		VARCHAR(50); 		-- Variable Control Pantalla
    DECLARE	Var_Consecutivo 	INT(11); 			-- Variable Consecutivo
	DECLARE Var_NombreCampo		VARCHAR(20);		-- Nombre del campo en el que se posicionara el foco en caso de un mensaje de exito


-- Asignacion  de constantes
	SET Cadena_Vacia 		:= '';		-- Constante: Cadena Vacia
    SET Entero_Cero			:= 0;		-- Constante: Entero Cero
    SET Cons_SI				:= 'S';		-- Constante: SI

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-INCONSISTENCIASBAJ');
				SET Var_Control	:='SQLEXCEPTION';
		END;

    IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero AND IFNULL(Par_ProspectoID,Entero_Cero) = Entero_Cero
		AND IFNULL(Par_AvalID,Entero_Cero) = Entero_Cero AND IFNULL(Par_GaranteID,Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 01;
        SET Par_ErrMen := 'Especifique un valor.';
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
    END IF;


	# Se actualiza el registro
	DELETE FROM INCONSISTENCIAS
	WHERE 	ClienteID	= Par_ClienteID
    AND 	ProspectoID	= Par_ProspectoID
	AND		AvalID 		= Par_AvalID
    AND		GaranteID 	= Par_GaranteID;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := 'Registro Eliminado Exitosamente';
	SET Var_Control := 'clienteID';

	END ManejoErrores;

    IF(Par_Salida = Cons_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
                Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$