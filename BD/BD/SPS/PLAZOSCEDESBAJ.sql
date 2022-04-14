-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSCEDESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZOSCEDESBAJ`;DELIMITER $$

CREATE PROCEDURE `PLAZOSCEDESBAJ`(
# ===========================================================
# ----------- SP PARA ELIMINAR LOS PLAZOS DE CEDES----------
# ===========================================================
	Par_TipoCedeID			INT(11),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen		VARCHAR(400),

	Par_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control		VARCHAR(200);
	DECLARE Var_Consecutivo	INT(11);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE Salida_SI		CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
    SET Salida_SI			:= 'S';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := '999';
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-PLAZOSCEDESBAJ');
				SET Var_Control := 'SQLEXCEPTION' ;
			END;


		DELETE	FROM PLAZOSCEDES
				WHERE TipoCedeID	= Par_TipoCedeID;


		SET Par_NumErr 	:= 000;
		SET Par_ErrMen 	:= 'Plazos Eliminados Exitosamente.';
		SET Var_Control	:= 'tipoCedeID';
		SET Var_Consecutivo := Entero_Cero;


END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$