-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCAMPANIASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCAMPANIASMOD`;DELIMITER $$

CREATE PROCEDURE `SMSCAMPANIASMOD`(
# ========================================================
# ------ SP PARA MODIFICAR LAS CAMPANIAS SMS------
# ========================================================
	Par_CampaniaID		INT(11),
	Par_Nombre			VARCHAR(50),
	Par_Clasific		CHAR(1),
	Par_Categoria		CHAR(1),
	Par_Tipo			INT(11),

	Par_FecLimRes		DATE,
	Par_MsgRecepcion	VARCHAR(50),
	Par_PlantillaID		INT(11),

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

	-- Declaracion de variables
	DECLARE Var_NumCam		INT;
    DECLARE VarControl 		VARCHAR(30);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	SalidaSI		CHAR(1);
	DECLARE	SalidaNO		CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';				-- String Vacio
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacía
	SET	Entero_Cero			:= 0;				-- Entero Cero
	SET SalidaSI			:='S';				-- Salida Si
	SET SalidaNO			:='N';				-- Salida No

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSCAMPANIASMOD');
			SET VarControl = 'sqlException';
		END;

		IF(IFNULL(Par_CampaniaID, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= 'La Campania esta Vacia';
			SET	VarControl 	:= 'tipo';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Nombre, Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 	:= 2;
			SET Par_ErrMen 	:= 'El Nombre esta Vacio.';
			SET	VarControl 	:= 'nombre';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Clasific, Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 	:= 3;
			SET Par_ErrMen 	:= 'La Clasificacion esta Vacia';
			SET	VarControl 	:= 'clasificacion';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Categoria, Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 	:= 4;
			SET Par_ErrMen 	:= 'La Categoria esta Vacia';
			SET	VarControl 	:= 'categoria';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Tipo, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 	:= 5;
			SET Par_ErrMen 	:= 'El Tipo esta Vacio';
			SET	VarControl 	:= 'tipo';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(EXISTS(SELECT 	C.CampaniaID
					FROM	SMSCAMPANIAS C
					WHERE 	C.MsgRecepcion 		 = Par_MsgRecepcion
					AND 	Par_CampaniaID 		!= CampaniaID
					AND 	Par_MsgRecepcion	!= Cadena_Vacia )) THEN
			SET	Par_NumErr 	:= 9;
			SET Par_ErrMen 	:= 'El Mensaje de campania ya existe';
			SET	VarControl 	:= 'msgRecepcion';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE SMSCAMPANIAS SET
				Nombre			= Par_Nombre,
				Clasificacion	= Par_Clasific,
				Categoria		= Par_Categoria,
				Tipo			= Par_Tipo,
				FechaLimiteRes	= Par_FecLimRes,
				MsgRecepcion	= Par_MsgRecepcion,
				PlantillaID		= Par_PlantillaID,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
		WHERE	CampaniaID 		= Par_CampaniaID;

		SET	Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT( 'Campania: ',Par_CampaniaID,' Modificada Exitosamente.');
        SET Var_NumCam		:= Par_CampaniaID;

	END ManejoErrores;  -- End del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'campaniaID' AS control,
				Var_NumCam AS consecutivo;

	END IF;

END TerminaStore$$