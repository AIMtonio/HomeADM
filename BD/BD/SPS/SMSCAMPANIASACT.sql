-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCAMPANIASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCAMPANIASACT`;DELIMITER $$

CREATE PROCEDURE `SMSCAMPANIASACT`(
# ========================================================
# ---------- SP PARA ACTUALIZAR LAS CAMPANIAS SMS---------
# ========================================================
	Par_CampaniaID		INT(11),
	Par_NumAct			TINYINT UNSIGNED,

	Par_Salida			CHAR(1),
	INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(1),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


	-- Declaracion de Variables
	DECLARE Var_Reserv		CHAR(1);
	DECLARE Var_Clasific	CHAR(1);
	DECLARE Var_Categoria	CHAR(1);
    DECLARE VarControl 		VARCHAR(100);
	DECLARE Var_NumCam		INT(11);

	-- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE ReservAplic		CHAR(1); -- constantes para valor R (reservado de la aplicacion, (campanias que solo agrega efisys))
	DECLARE EstatusCancel	CHAR(1);
	DECLARE ActCancela		INT(11);


	-- Asignacion de constantes
	SET	Entero_Cero		:= 0;
	SET SalidaSI		:= 'S';
	SET SalidaNO		:= 'N';
	SET	Cadena_Vacia	:= '';
	SET	ReservAplic		:= 'R';
	SET	EstatusCancel	:= 'C';
	SET ActCancela		:= 4;  -- trasaccion 4 en el servicio de java
	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSCAMPANIASACT');
			SET VarControl = 'SQLEXCEPTION';
		END;


		IF(IFNULL(Par_CampaniaID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= 'La Campania esta Vacia';
			SET	VarControl	:= 'tipo';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumAct = ActCancela) THEN

			SET Aud_FechaActual := CURRENT_TIMESTAMP();

			UPDATE SMSCAMPANIAS SET
				Estatus			= EstatusCancel,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE CampaniaID = Par_CampaniaID;

		END IF;

		SET	Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= CONCAT("Campania Actualizada Exitosamente: ", CONVERT(Par_CampaniaID, CHAR));
		SET Var_NumCam	:= Par_CampaniaID;

	END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'campaniaID' AS control,
				Var_NumCam AS consecutivo;

	END IF;

END TerminaStore$$