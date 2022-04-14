-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERCEDEBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPERCEDEBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPERCEDEBAJ`(
# =======================================================================
# ------ SP PARA ELIMINAR LAS SUBCUENTAS DE TIPOS PERSONA DE CEDES------
# =======================================================================
	Par_ConceptoCedeID	INT(11),

	Par_Salida			CHAR(1),
	INOUT Par_NumErr 	INT(11),
	INOUT Par_ErrMen  	VARCHAR(400),

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control		VARCHAR(50);
	DECLARE Var_Consecutivo	INT(11);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT(3);
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE SalidaSI		CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
    SET SalidaSI			:= 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCTATIPERCEDEBAJ');
			END;


		DELETE
		FROM 		SUBCTATIPERCEDE
		WHERE  ConceptoCedeID 	= Par_ConceptoCedeID;

		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'SubCuenta Contable Eliminada Exitosamente';
		SET Var_Control	:= 'fisica';
		SET Var_Consecutivo:=Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$