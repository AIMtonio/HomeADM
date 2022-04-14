-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAPORTACIONESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAPORTACIONESBAJ`;DELIMITER $$

CREATE PROCEDURE `TASASAPORTACIONESBAJ`(
# =======================================================================
# ----------- SP PARA DAR DE BAJA LAS TASAS DE APORTACIONES -------------
# =======================================================================
	Par_TasaAportacionID	INT(11),		-- ID de la tasa
	Par_TipoAportacionID	INT(11),		-- ID del tipo de aportacion
	Par_NumBaj				INT(11),		-- Numero de baja

	Par_Salida          	CHAR(1),		-- Especifica salida
    INOUT Par_NumErr    	INT(11),		-- Numero de error
    INOUT Par_ErrMen    	VARCHAR(400),	-- Mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(400);	-- Control
	DECLARE Var_Consecutivo		INT(11);		-- Consecutivo

	-- Declaracion de constantes
	DECLARE TipoBajaTasa			INT(11);
	DECLARE TipoBajaMontoPlazo		INT(11);
	DECLARE Salida_SI				CHAR(1);

	-- Asignacion de constantes
	SET TipoBajaTasa				:=1;		-- Tipo de baja tasa
	SET TipoBajaMontoPlazo			:=2;		-- Tipo baja monto plazo
    SET Salida_SI					:= 'S';		-- Salida si

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-TASASAPORTACIONESBAJ');
				SET Var_Control = 'SQLEXCEPTION' ;
			END;


		IF (Par_NumBaj = TipoBajaTasa)THEN

			DELETE FROM TASASAPORTACIONES	WHERE TasaAportacionID = Par_TasaAportacionID;
			DELETE FROM TASAAPORTSUCURSALES	WHERE TasaAportacionID = Par_TasaAportacionID ;

		END IF;

		IF (TipoBajaMontoPlazo =Par_NumBaj) THEN

			DELETE FROM TASASAPORTACIONES	WHERE TipoAportacionID = Par_TipoAportacionID ;
			DELETE FROM TASAAPORTSUCURSALES	WHERE TipoAportacionID = Par_TipoAportacionID ;

		END IF;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('La Tasa se ha Eliminado Exitosamente: ',CONVERT(Par_TasaAportacionID,CHAR));
        SET Var_Control 	:= 'tasaAportacionID';
		SET Var_Consecutivo	:= 0;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$