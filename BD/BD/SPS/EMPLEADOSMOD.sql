-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMPLEADOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMPLEADOSMOD`;DELIMITER $$

CREATE PROCEDURE `EMPLEADOSMOD`(
# =====================================================================================
# ----- STORED PARA MODIFICAR UN EMPLEADO --------------
# =====================================================================================
	Par_EmpleadoID			INT(11),		-- Clave del Empleado
	Par_ClavePuestoID 		VARCHAR(10),	-- Clave del Puesto
	Par_ApellidoPat			VARCHAR(50),	-- Apellido Paterno
	Par_ApellidoMat			VARCHAR(50),	-- Apellido Materno
	Par_PrimerNombre		VARCHAR(50),	-- Primer Nombre

	Par_SegundoNombre		VARCHAR(50),	-- Segundo Nombre
	Par_FechaNac			DATE,			-- Fecha de Nacimiento
	Par_RFC					VARCHAR(13),    -- RFC del Empleado
	Par_SucursalID			INT(11),		-- Sucursal del Empleado
	Par_Nacion				CHAR(1),		-- Nacionalidad del Empleado

    Par_PaisNacimiento		INT(11),    	-- Pais de Nacimiento
    Par_EstadoID			INT(11),		-- Estado de Nacimiento
    Par_Genero				CHAR(1),		-- Genero
    Par_CURP				CHAR(18),		-- CURP del Empleado

    Par_Salida          	CHAR(1),			-- Indica el tipo de salida S.- SI N.- No
	INOUT Par_NumErr    	INT,				-- Numero de Error
	INOUT Par_ErrMen    	VARCHAR(400),		-- Mensaje de Error

	# Parametros de Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore: BEGIN

/* Declaracion de Variables */
	DECLARE	Estatus_Empleado	CHAR(1);
	DECLARE	Nombre_Completo		VARCHAR(200);
	DECLARE	Puesto				VARCHAR(10);
	DECLARE Estatus_Activo		CHAR(1);
    DECLARE Var_Control			VARCHAR(50);

/* Declaracion de Constantes */
	DECLARE Entero_Cero       	INT(11);
	DECLARE	Cadena_Vacia	    CHAR(1);

/* Asignacion de Constantes */
	SET	Estatus_Empleado		:= 'A';
	SET Estatus_Activo			:= 'A';
	SET Entero_Cero		 		:=0;
	SET Cadena_Vacia			:= '';
	SET Par_PrimerNombre    	:= RTRIM(LTRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia)));
	SET Par_SegundoNombre   	:= RTRIM(LTRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia)));
	SET Par_ApellidoPat     	:= RTRIM(LTRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia)));
	SET Par_ApellidoMat     	:= RTRIM(LTRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia)));

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-EMPLEADOSMOD');
			SET Var_Control := 'sqlException' ;
		END;

	IF(NOT EXISTS(SELECT EmpleadoID
						FROM EMPLEADOS
						WHERE  EmpleadoID = Par_EmpleadoID)) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen = 'El Empleado no Existe';
		SET Var_Control := 'empleadoID' ;
		LEAVE ManejoErrores;

	END IF;

	IF(IFNULL(Par_ClavePuestoID,Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen = 'La Clave del Puesto esta Vacio';
		SET Var_Control := 'clavePuestoID' ;
		LEAVE ManejoErrores;
	END IF;

	SET Puesto := (SELECT ClavePuestoID FROM PUESTOS WHERE ClavePuestoID=Par_ClavePuestoID AND Estatus='V');
	IF(IFNULL(Puesto, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen = 'El Puesto no existe';
		SET Var_Control := 'clavePuestoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_SucursalID, Entero_Cero) = Entero_Cero )THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen = 'Indique la Sucursal';
		SET Var_Control := 'sucursalID' ;
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS ( SELECT SucursalID FROM SUCURSALES WHERE SucursalID = Par_SucursalID
							AND Estatus = Estatus_Activo)THEN

		SET Par_NumErr := 5;
		SET Par_ErrMen = 'La Sucursal No Existe';
		SET Var_Control := 'sucursalID' ;
		LEAVE ManejoErrores;
	END IF;

	-- VALIDACIONES
	IF (IFNULL(Par_Nacion, Cadena_Vacia) = Cadena_Vacia )THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen = 'La Nacionalidad esta Vacia';
		SET Var_Control := 'nacion' ;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_PaisNacimiento, Entero_Cero) = Entero_Cero )THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen = 'El Pais de Nacimiento esta Vacio';
		SET Var_Control := 'lugarNacimiento' ;
		LEAVE ManejoErrores;
	END IF;


	IF (IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero )THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen = 'El Estado esta Vacio';
		SET Var_Control := 'estadoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia )THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen = 'El Genero esta Vacio';
		SET Var_Control := 'sexo' ;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia )THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen = 'La CURP esta Vacia';
		SET Var_Control := 'CURP' ;
		LEAVE ManejoErrores;
	END IF;


	SET Nombre_Completo := CONCAT(RTRIM(LTRIM(IFNULL(Par_PrimerNombre, '')))
		,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_SegundoNombre, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_SegundoNombre, '')))) ELSE '' END
		,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_ApellidoPat, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_ApellidoPat, '')))) ELSE '' END
		,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_ApellidoMat, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_ApellidoMat, '')))) ELSE '' END
	);


	SET Aud_FechaActual := CURRENT_TIMESTAMP();


	UPDATE EMPLEADOS  SET

	EmpleadoID		= Par_EmpleadoID,
	ClavePuestoID 	= Par_ClavePuestoID,
	ApellidoPat		= Par_ApellidoPat,
	ApellidoMat		= Par_ApellidoMat,
	PrimerNombre	= Par_PrimerNombre,
	SegundoNombre	= Par_SegundoNombre,
	FechaNac		= Par_FechaNac,
	RFC				= Par_RFC	,
	NombreCompleto	= Nombre_Completo,
	SucursalID		= Par_SucursalID,
	Estatus			= Estatus_Empleado,
	Nacionalidad	= Par_Nacion,
    LugarNacimiento = Par_PaisNacimiento,
    EstadoID		= Par_EstadoID,
    Sexo			= Par_Genero,
    CURP			= Par_CURP,
	EmpresaID		= Aud_EmpresaID,
	Usuario			= Aud_Usuario,
	FechaActual		= Aud_FechaActual,
	DireccionIP		= Aud_DireccionIP,
	ProgramaID		= Aud_ProgramaID,
	Sucursal		= Aud_Sucursal,
	NumTransaccion 	= Aud_NumTransaccion

	WHERE EmpleadoID= Par_EmpleadoID;

	SET Par_NumErr := 0;
	SET Par_ErrMen = CONCAT("Empleado Modificado Exitosamente: ", Par_EmpleadoID);
	SET Var_Control := 'empleadoID' ;

END ManejoErrores;

SELECT Par_NumErr 		AS NumErr ,
	   Par_ErrMen 		AS ErrMen,
	   Var_Control 		AS control,
	   Par_EmpleadoID   AS consecutivo;

END TerminaStore$$