-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSAPORTACIONESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOSAPORTACIONESBAJ`;DELIMITER $$

CREATE PROCEDURE `MONTOSAPORTACIONESBAJ`(
# ==================================================================
# ----------- SP PARA ELIMINAR LOS MONTOS DE APORTACIONES ----------
# ==================================================================
	Par_TipoAportacionID	INT(11),			-- ID del tipo de aportacion

    Par_Salida				CHAR(1),			-- Especifica salida
    INOUT Par_NumErr		INT(11),			-- Numero de error
    INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	Par_Empresa				INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria

)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
    DECLARE Salida_SI		CHAR(1);
    DECLARE Var_Control		VARCHAR(40);

	-- Asignacion de constantes
	SET	Cadena_Vacia	:= '';				-- Cadena vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero		:= 0;				-- Entero cero
    SET Salida_SI		:= 'S';				-- Indica salida

    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-MONTOSAPORTACIONESBAJ');
				SET Var_Control = 'SQLEXCEPTION' ;
		END;

		IF EXISTS (SELECT TipoAportacionID
						FROM TASASAPORTACIONES
							WHERE TipoAportacionID = Par_TipoAportacionID) THEN
			SET Par_NumErr	:= 001;
			SET	Par_ErrMen	:= 'Estos Rangos de Montos ya han sido Asignados';
			SET Var_Control	:= 'TipoAportacionID';
            LEAVE ManejoErrores;
        END IF;

		DELETE
			FROM MONTOSAPORTACIONES
			WHERE	TipoAportacionID	= Par_TipoAportacionID;

		SET Par_NumErr	:= 000;
		SET	Par_ErrMen	:= 'Montos de Aportacion Eliminados Exitosamente';
		SET Var_Control	:= 'TipoAportacionID';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
                Entero_Cero		AS consecutivo;
	END IF;

END TerminaStore$$