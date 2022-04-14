-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAAPORTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZAAPORTBAJ`;DELIMITER $$

CREATE PROCEDURE `AMORTIZAAPORTBAJ`(
# ==================================================================
# ------ SP PARA ELIMINAR LAS AMORTIZACIONES DE APORTACIONES--------
# ==================================================================
	Par_AportacionID	INT(11),		-- NÚMERO DE APORTACIÓN.
	Par_Salida          CHAR(1),		-- TIPO DE SALIDA.
	INOUT Par_NumErr    INT(11),		-- NÚM. DE ERROR.
	INOUT Par_ErrMen    VARCHAR(400),	-- MENSAJE DE ERROR.
	/* Parámetos de Auditoría */
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
			SET Par_NumErr :=	999;
			SET Par_ErrMen :=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: AMORTIZAAPORTBAJ');
		END;

		DELETE FROM AMORTIZAAPORT WHERE AportacionID = Par_AportacionID;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Amortizaciones Eliminadas.' ;

	END ManejoErrores;

	IF(Par_Salida =SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				VarControl AS control,
				Par_AportacionID AS consecutivo;
	END IF;

END TerminaStore$$