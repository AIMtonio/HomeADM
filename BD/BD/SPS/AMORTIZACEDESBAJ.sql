-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZACEDESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZACEDESBAJ`;DELIMITER $$

CREATE PROCEDURE `AMORTIZACEDESBAJ`(
# ==================================================================
# ----------- SP PARA ELIMINAR LAS AMORTIZACIONES DE CEDES----------
# ==================================================================
    Par_CedeID          INT(11),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE VarControl  VARCHAR(300);

	-- Declaracion de constantes
	DECLARE SalidaSI    CHAR(1);

	-- Asignacion de constantes
	SET SalidaSI    	:= 'S';
	SET VarControl  	:= '';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	=	999;
			SET Par_ErrMen	=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: AMORTIZACEDESBAJ');
		END;


		DELETE FROM AMORTIZACEDES WHERE CedeID = Par_CedeID;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Amortizaciones Eliminadas.' ;

	END ManejoErrores;

	IF(Par_Salida =SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				VarControl AS control,
				Par_CedeID AS consecutivo;
	END IF;

END TerminaStore$$