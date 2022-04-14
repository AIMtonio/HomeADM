-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCAMPANIASBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCAMPANIASBAJ`;DELIMITER $$

CREATE PROCEDURE `SMSCAMPANIASBAJ`(
# ========================================================
# --------- SP PARA DAR DE BAJA LAS CAMPANIAS SMS---------
# ========================================================
	Par_CampaniaID		INT(11),
	Par_Salida			CHAR(1),

	 INOUT Par_NumErr   INT(11),
     INOUT Par_ErrMen   VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_NumCam		INT;
    DECLARE VarControl 		VARCHAR(100);
    DECLARE Var_CampaniaID	INT;

	-- Declaración de constantes
	DECLARE Entero_Cero		INT;
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);

	-- Asignación de constantes
	SET Entero_Cero 		:=0;		-- Entero Cero
	SET SalidaSI			:='S';		-- Salida Si
	SET SalidaNO			:='N';		-- Salida No


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSCAMPANIASBAJ');
			SET VarControl = 'sqlException';
		END;

		IF(IFNULL(Par_CampaniaID,Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr	:= 1;
			SET Par_ErrMen 	:= 'La campania no existe.';
			SET	VarControl 	:= 'campaniaID';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(EXISTS(SELECT 	C.CampaniaID
					FROM 	SMSENVIOMENSAJE EM, SMSCAMPANIAS C
					WHERE 	C.CampaniaID  = Par_CampaniaID
					AND 	EM.CampaniaID = C.CampaniaID)) THEN
			SET	Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El campania es usada actualmente';
			SET	VarControl 	:= 'tipoCampaniaID';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT C.CampaniaID INTO Var_CampaniaID
		FROM 	HISSMSENVIOMENSAJE EM, SMSCAMPANIAS C
		WHERE 	C.CampaniaID  = Par_CampaniaID
		  AND 	EM.CampaniaID = C.CampaniaID;

		IF(Var_CampaniaID != Entero_Cero)THEN
			SET	Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El campania es usada actualmente';
			SET	VarControl 	:= 'tipoCampaniaID';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		DELETE FROM  SMSCAMPANIAS
		WHERE Par_CampaniaID=CampaniaID ;


		SET	Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('Campania: ',CAST(Par_CampaniaID AS CHAR), '  Eliminada Exitosamente.');
        SET Var_NumCam := Entero_Cero;

	END ManejoErrores;  -- End del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'campaniaID' AS control,
				Var_NumCam AS consecutivo;

	END IF;

END TerminaStore$$