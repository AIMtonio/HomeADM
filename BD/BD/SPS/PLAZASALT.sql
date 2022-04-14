-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZASALT`;DELIMITER $$

CREATE PROCEDURE `PLAZASALT`(
	Par_Nombre			VARCHAR(100),
	Par_PlazaCLABE		CHAR(3),

    Par_Salida			CHAR(1),	-- Parametros de Control
    INOUT Par_NumErr	INT(11),
    INOUT Par_ErrMen	VARCHAR(150),

	Par_EmpresaID		INT(11),		-- Parametros de Auditoria --
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control 		VARCHAR(50);	-- Variable de control para el manejo de errores
	DECLARE Var_Consecutivo		VARCHAR(50);	-- Variable para el consecutivo
	DECLARE	Var_PlazaID			INT(11);
	DECLARE Var_NumProductos	INT(11);		-- Almacena los productos que tienen la misma clave SPEI
	DECLARE Var_NumPlazas		INT(11);		-- Almacena las plazas que tienen la misma clave SPEI

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT(11);
    DECLARE	Entero_Uno		INT(11);
    DECLARE Salida_SI		CHAR(1);		-- Salida si = S

	-- Asignacion de constantes
	SET	Cadena_Vacia	:= '';
	SET	Entero_Cero		:= 0;
    SET	Entero_Uno		:= 1;
    SET Salida_SI		:= 'S';

    ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-PLAZASALT');
		SET Var_Control = 'sqlException' ;
	END;

    IF( IFNULL(Par_Nombre, Cadena_Vacia) = Cadena_Vacia )THEN
		SET Par_NumErr 		:= '01';
		SET Par_ErrMen 		:= 'Especifique el nombre';
		SET Var_Control		:= 'nombre';
		SET Var_Consecutivo	:= Par_Nombre;
		LEAVE ManejoErrores;
	END IF;

    IF( IFNULL(Par_PlazaCLABE, Cadena_Vacia) = Cadena_Vacia )THEN
		SET Par_NumErr 		:= '02';
		SET Par_ErrMen 		:= 'Especifique la CLABE';
		SET Var_Control		:= 'plazaCLABE';
		SET Var_Consecutivo	:= Par_PlazaCLABE;
		LEAVE ManejoErrores;
	END IF;

     -- se verifica que la cuenta clabe introducida no sea la misma que otro producto
	SELECT COUNT(ProducCreditoID) INTO Var_NumProductos
	FROM PRODUCTOSCREDITO
	WHERE ProductoCLABE = Par_PlazaCLABE;

	IF(IFNULL(Var_NumProductos, Entero_Cero) <> Entero_Cero) THEN
		SET Par_NumErr    	:= 03;
		SET Par_ErrMen   	:= 'El numero de CLABE pertenece a un Producto de Credito.';
		SET Var_Control   	:= 'plazaCLABE';
		LEAVE ManejoErrores;
	END IF;

	-- se verifica que la cuenta clabe introducida no sea la misma que el de una plaza
	SELECT COUNT(PlazaID) INTO Var_NumPlazas
	FROM PLAZAS
	WHERE PlazaCLABE = Par_PlazaCLABE;

	IF(IFNULL(Var_NumPlazas, Entero_Cero) <> Entero_Cero) THEN
		SET Par_NumErr    	:= 04;
		SET Par_ErrMen    	:= 'El numero de CLABE pertenece a otra Plaza.';
		SET Var_Control   	:= 'plazaCLABE';
		LEAVE ManejoErrores;
	END IF;

    SET Var_PlazaID := (SELECT IFNULL(MAX(PlazaID),Entero_Cero) + Entero_Uno
	FROM PLAZAS);
	SET Aud_FechaActual := CURRENT_TIMESTAMP();


	INSERT INTO `PLAZAS`(
		`PlazaID`,			`EmpresaID`,		`Nombre`,		`PlazaCLABE`, 	`Usuario`,
        `FechaActual`, 		`DireccionIP`,		`ProgramaID`,	`Sucursal`,		`NumTransaccion`
    )
	VALUES(
		Var_PlazaID, 		Par_EmpresaID,		Par_Nombre,		Par_PlazaCLABE,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
	);

    SET Par_NumErr 		:= '000';
	SET Par_ErrMen 		:= CONCAT('Plaza agregada exitosamente: ',CAST(Var_PlazaID AS CHAR) );
	SET Var_Control		:= 'plazaID';
	SET Var_Consecutivo	:= Var_PlazaID;

	END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$