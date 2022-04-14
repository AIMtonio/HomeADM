-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSPLANTILLABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSPLANTILLABAJ`;DELIMITER $$

CREATE PROCEDURE `SMSPLANTILLABAJ`(
# ========================================================
# -------- SP PARA DAR DE BAJA LAS PLANTILLAS SMS---------
# ========================================================
	Par_PlantillaID     INT(11),
	Par_Salida			CHAR(1),

	INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaración de constatantes
	DECLARE Entero_Cero		INT(11);
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);

    	-- Declaracion de variables
	DECLARE Var_Consecutivo	INT(11);
    DECLARE Var_Control 	VARCHAR(100);

	-- Asignación de constantes
	SET Entero_Cero 		:= 0;		-- Entero Cero
	SET SalidaSI			:= 'S';		-- Salida Si
	SET SalidaNO			:= 'N';		-- Salida No

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSPLANTILLABAJ');
			SET Var_Control = 'SQLEXCEPTION';
		END;


		IF(IFNULL(Par_PlantillaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'La plantilla no existe.';
			SET	Var_Control 	:= 'campaniaID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(EXISTS(SELECT P.PlantillaID
				FROM SMSPLANTILLA P, SMSCAMPANIAS C
				WHERE P.PlantillaID  = Par_PlantillaID
				AND P.PlantillaID = C.PlantillaID)) THEN
			SET	Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'La plantilla es usada actualmente';
			SET	Var_Control 	:= 'plantillaID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		DELETE FROM  SMSPLANTILLA
		WHERE Par_PlantillaID=PlantillaID;


		SET	Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('Plantilla: ',Par_PlantillaID,' Eliminada Exitosamente.');

	END ManejoErrores;

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'plantillaID' AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$