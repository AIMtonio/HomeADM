-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSPLANTILLAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSPLANTILLAALT`;DELIMITER $$

CREATE PROCEDURE `SMSPLANTILLAALT`(
# ========================================================
# ---------- SP PARA REGISTRAR LAS PLANTILLAS SMS---------
# ========================================================
	Par_Nombre			VARCHAR(45),
	Par_Descripcion		VARCHAR(1500),
	Par_Salida			CHAR(1),

	INOUT Par_NumErr    INT(12),
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

	-- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);
	DECLARE Cadena_Vacia	CHAR(1);

	-- Declaracion de variables
	DECLARE VarPlantillaID	INT(11);
	DECLARE Var_Consecutivo	INT(11);
    DECLARE Var_Control 	VARCHAR(100);

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;		-- Entero Cero
	SET SalidaSI			:='S';		-- Salida Si
	SET SalidaNO			:='N';		-- Salida No
	SET	Cadena_Vacia		:= '';		-- String Vacío
	SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSPLANTILLAALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;


		SET VarPlantillaID := (SELECT IFNULL(MAX(PlantillaID),Entero_Cero)+ 1 FROM SMSPLANTILLA);

		IF(IFNULL(Par_Nombre, Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El Nombre esta Vacio.';
			SET	Var_Control 	:= 'nombre';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Descripcion, Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'La Descripcion esta Vacia.';
			SET	Var_Control 	:= 'descripcion';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		INSERT INTO SMSPLANTILLA (
			PlantillaID,		Nombre,				Descripcion,		EmpresaID,		Usuario,
			FechaActual,		DireccionIP,		ProgramaID, 		Sucursal,		NumTransaccion)
		VALUES(
			VarPlantillaID,		Par_Nombre,			Par_Descripcion,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET	Par_NumErr := 000;
		SET Par_ErrMen := CONCAT("Plantilla: ", CAST(VarPlantillaID AS CHAR)," Registrada Exitosamente.");


	END ManejoErrores;

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'plantillaID' AS control,
				VarPlantillaID AS consecutivo;

	END IF;

END TerminaStore$$