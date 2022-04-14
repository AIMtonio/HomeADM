-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZASMOD`;DELIMITER $$

CREATE PROCEDURE `PLAZASMOD`(

    Par_PlazaID			INT(11),
	Par_Nombre			VARCHAR(100),
	Par_PlazaCLABE		CHAR(3),

    -- Parametros de Control
    Par_Salida			CHAR(1),
    INOUT Par_NumErr	INT(11),
    INOUT Par_ErrMen	VARCHAR(150),

    -- Parametros de Auditoria
    Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_NumProductos	INT(11);		-- Almacena los productos que tienen la misma clave SPEI
	DECLARE Var_NumPlazas		INT(11);		-- Almacena las plazas que tienen la misma clave SPEI
	DECLARE Var_Control 		VARCHAR(50);	-- Variable de control para el manejo de errores
	DECLARE Var_Consecutivo		VARCHAR(50);	-- Variable para el consecutivo

	-- Declaracion de Constantes
	DECLARE	Estatus_Activo	CHAR(1);
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
    DECLARE Salida_SI		CHAR(1);		-- Salida si = S

	-- Asignacion de Constates
	SET	Estatus_Activo	:= 'A';				-- Estatus Activo
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
    SET Salida_SI		:= 'S';

    ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-PLAZASMOD');
			SET Var_Control = 'sqlException' ;
		END;

		SET Aud_FechaActual	:= NOW();


		IF(NOT EXISTS(SELECT PlazaID
					FROM PLAZAS
					WHERE PlazaID = Par_PlazaID)) THEN
			SET Par_NumErr 		:= '01';
			SET Par_ErrMen 		:= 'La Plaza no existe.';
			SET Var_Control		:= 'plazaID';
			SET Var_Consecutivo	:= Par_PlazaID;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Nombre,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 		:= '02';
			SET Par_ErrMen 		:= 'El nombre esta Vacio.';
			SET Var_Control		:= 'nombre';
			SET Var_Consecutivo	:= Par_Nombre;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_PlazaCLABE, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 		:= '03';
			SET Par_ErrMen 		:= 'La CLABE esta Vacia.';
			SET Var_Control		:= 'plazaCLABE';
			SET Var_Consecutivo	:= Par_PlazaCLABE;
			LEAVE ManejoErrores;
		END IF;

		-- se verifica que la cuenta clabe introducida no sea la misma que otro producto
		SELECT COUNT(ProducCreditoID) INTO Var_NumProductos
		FROM PRODUCTOSCREDITO
		WHERE ProductoCLABE = Par_PlazaCLABE;

		IF(IFNULL(Var_NumProductos, Entero_Cero) <> Entero_Cero) THEN
			SET Par_NumErr    	:= 04;
			SET Par_ErrMen   	:= 'El numero de CLABE pertenece a un Producto de Credito.';
			SET Var_Control   	:= 'plazaCLABE';
			SET Var_Consecutivo	:= Par_PlazaID;
			LEAVE ManejoErrores;
		END IF;

		-- se verifica que la cuenta clabe introducida no sea la misma que el de una plaza
		SELECT COUNT(PlazaID) INTO Var_NumPlazas
		FROM PLAZAS
		WHERE PlazaCLABE = Par_PlazaCLABE AND PlazaID <> Par_PlazaID;

		IF(IFNULL(Var_NumPlazas, Entero_Cero) <> Entero_Cero) THEN
			SET Par_NumErr    	:= 05;
			SET Par_ErrMen    	:= 'El numero de CLABE pertenece a otra Plaza.';
			SET Var_Control   	:= 'plazaCLABE';
			SET Var_Consecutivo	:= Par_PlazaID;
			LEAVE ManejoErrores;
		END IF;

		UPDATE PLAZAS SET
			Nombre			= Par_Nombre,
			PlazaCLABE		= Par_PlazaCLABE,
			EmpresaID		= Par_EmpresaID,

			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion

		WHERE PlazaID = Par_PlazaID;

		SET Par_NumErr 		:= '000';
		SET Par_ErrMen 		:= CONCAT('Plaza Modificada exitosamente: ',CAST(Par_PlazaID AS CHAR) );
		SET Var_Control		:= 'plazaID';
		SET Var_Consecutivo	:= Par_PlazaID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$