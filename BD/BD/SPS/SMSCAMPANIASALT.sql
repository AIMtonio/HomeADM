-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCAMPANIASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCAMPANIASALT`;DELIMITER $$

CREATE PROCEDURE `SMSCAMPANIASALT`(
# ========================================================
# ---------- SP PARA REGISTRAR LAS CAMPANIAS SMS----------
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


	-- Declaracion de Variables
	DECLARE Var_Reserv		CHAR(1);
	DECLARE Var_Clasific	CHAR(1);
	DECLARE Var_Categoria	CHAR(1);
	DECLARE VarControl 		VARCHAR(100);
	DECLARE Var_NumCam		INT;

	-- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE ReservAplic		CHAR(1); -- constantes para valor R (reservado de la aplicacion, (campanias que solo agrega efisys))
	DECLARE EstatusVigente	CHAR(1);


	-- Asignacion de constantes
	SET	Entero_Cero			:= 0;		-- Entero Cero
	SET SalidaSI			:= 'S';		-- Salida Si
	SET SalidaNO			:= 'N';		-- Salida No
	SET	Cadena_Vacia		:= '';		-- Cadena Vacía
	SET	ReservAplic			:= 'R';		-- Reservada por la aplicacion
	SET EstatusVigente		:= 'V';		-- Estatus Vigente
	SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSCAMPANIASALT');
			SET VarControl = 'SQLEXCEPTION';
		END;


		IF(IFNULL(Par_CampaniaID, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr	:= 1;
			SET Par_ErrMen 	:= 'La Campania esta Vacia';
			SET	VarControl 	:= 'tipo';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Nombre, Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr	:= 2;
			SET Par_ErrMen 	:= 'El Nombre esta Vacio.';
			SET	VarControl 	:= 'nombre';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Clasific, Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen 	:= 'La Clasificacion esta Vacia';
			SET	VarControl 	:= 'clasificacion';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Categoria, Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen 	:= 'La Categoria esta Vacia';
			SET	VarControl 	:= 'categoria';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Tipo, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr	:= 5;
			SET Par_ErrMen 	:= 'El Tipo esta Vacio';
			SET	VarControl 	:= 'tipo';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(Par_Clasific != Var_Clasific) THEN
			SET	Par_NumErr 	:= 7;
			SET Par_ErrMen	:= 'La Clasificacion de la Campania no Coincide con la del Tipo';
			SET	VarControl 	:= 'clasificacion';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(Par_Categoria != Var_Categoria) THEN
			SET	Par_NumErr	:= 8;
			SET Par_ErrMen 	:= 'La Categoria de la Campania no Coincide con la del Tipo';
			SET	VarControl 	:= 'categoria';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(EXISTS(SELECT 	C.CampaniaID
					FROM	SMSCAMPANIAS C
					WHERE	C.MsgRecepcion 	  = Par_MsgRecepcion
                    AND		Par_MsgRecepcion != Cadena_Vacia)) THEN
			SET	Par_NumErr 	:= 9;
			SET Par_ErrMen 	:= 'El mensaje de campania ya existe';
			SET	VarControl 	:= 'msgRecepcion';
			SET Var_NumCam 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		INSERT INTO SMSCAMPANIAS (
			CampaniaID,			Nombre,				Clasificacion,		Categoria,			Tipo,
			Estatus,			FechaLimiteRes,		MsgRecepcion,		PlantillaID, 		EmpresaID,
            Usuario,			FechaActual,        DireccionIP,		ProgramaID,			Sucursal,
            NumTransaccion)
		VALUES(
			Par_CampaniaID,		Par_Nombre,			Par_Clasific,		Par_Categoria,		Par_Tipo,
			EstatusVigente,		Par_FecLimRes,  	Par_MsgRecepcion,	Par_PlantillaID,	Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion);

		SET	Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= CONCAT("Campania Agregada Exitosamente: ", CONVERT(Par_CampaniaID, CHAR));
		SET Var_NumCam 	:= Par_CampaniaID;

	END ManejoErrores;  -- END del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'campaniaID' AS control,
				Var_NumCam AS consecutivo;

	END IF;

END TerminaStore$$