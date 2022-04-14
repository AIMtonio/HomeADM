-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSCEDESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOSCEDESBAJ`;DELIMITER $$

CREATE PROCEDURE `MONTOSCEDESBAJ`(
# ===========================================================
# ----------- SP PARA ELIMINAR LOS MONTOS DE CEDES----------
# ===========================================================
	Par_TipoCedeID		INT(11),

    Par_Salida			CHAR(1),
    INOUT Par_NumErr	INT(11),
    INOUT Par_ErrMen	VARCHAR(400),

	Par_Empresa			INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
    DECLARE Salida_SI		CHAR(1);
    DECLARE Var_Control		VARCHAR(40);

	-- Asignacion de constantes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
    SET Salida_SI		:= 'S';

    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-MONTOSCEDESBAJ');
				SET Var_Control = 'SQLEXCEPTION' ;
		END;

		IF EXISTS (SELECT TipoCedeID
						FROM TASASCEDES
							WHERE TipoCedeID = Par_TipoCedeID) THEN
			SET Par_NumErr	:= 001;
			SET	Par_ErrMen	:= 'Estos Rangos de Montos ya han sido Asignados';
			SET Var_Control	:= 'TipoCedeID';
            LEAVE ManejoErrores;
        END IF;

		DELETE
			FROM MONTOSCEDES
			WHERE	TipoCedeID	= Par_TipoCedeID;

		SET Par_NumErr	:= 000;
		SET	Par_ErrMen	:= 'Montos de CEDES Eliminados Exitosamente';
		SET Var_Control	:= 'TipoCedeID';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
                Entero_Cero		AS consecutivo;
	END IF;

END TerminaStore$$