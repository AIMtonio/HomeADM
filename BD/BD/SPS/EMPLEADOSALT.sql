-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMPLEADOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMPLEADOSALT`;DELIMITER $$

CREATE PROCEDURE `EMPLEADOSALT`(
# =====================================================================================
# ----- STORED PARA DAR DE ALTA UN EMPLEADO --------------
# =====================================================================================
	Par_ClavePuestoID 		VARCHAR(10),	-- Clave del Puesto
	Par_ApellidoPat			VARCHAR(50),	-- Apellido Paterno
	Par_ApellidoMat			VARCHAR(50),	-- Apellido Materno
	Par_PrimerNombre		VARCHAR(50),	-- Primer Nombre
	Par_SegundoNombre		VARCHAR(50),	-- Segundo Nombre

    Par_FechaNac			DATE,			-- Fecha de Nacimiento
	Par_RFC					VARCHAR(13),	-- RFC del Empleado
	Par_SucursalID			INT(11),		-- Sucursal del Empleado
	Par_Nacion				CHAR(1),		-- Nacionalidad del Empleado
    Par_PaisNacimiento		INT(11),		-- Pais de Nacimiento

    Par_EstadoID			INT(11),		-- Estado del Empleado
    Par_Genero				CHAR(1),		-- Genero
    Par_CURP				CHAR(18),		-- CURP del Empleado

    Par_Salida          	CHAR(1),			-- Indica el tipo de salida S.- SI N.- No
	INOUT Par_NumErr    	INT,				-- Numero de Error
	INOUT Par_ErrMen    	VARCHAR(400),		-- Mensaje de Error

	# Parametros de Auditoria
	Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
    Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT(20)

)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE	Var_Empleado		INT;
DECLARE	Nombre_Comp			VARCHAR(200);
DECLARE	Estatus_Empleado	CHAR;
DECLARE	Puesto				VARCHAR(10);
DECLARE Var_Control			VARCHAR(50);

/* Declaracion de Constantes */
DECLARE  Entero_Cero        INT;
DECLARE  Decimal_Cero       DECIMAL(12,2);
DECLARE	 Cadena_Vacia		CHAR(1);
DECLARE  Estatus_Activo		CHAR(1);

/* Asignacion de Constantes */
SET Entero_Cero 			:=0;
SET Cadena_Vacia			:= '';
SET Decimal_Cero 			:=0.00;
SET Estatus_Activo			:= 'A';

SET	Estatus_Empleado		:= 'A';
SET Par_PrimerNombre        := RTRIM(LTRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia)));
SET Par_SegundoNombre       := RTRIM(LTRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia)));
SET Par_ApellidoPat     	:= RTRIM(LTRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia)));
SET Par_ApellidoMat      	:= RTRIM(LTRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia)));

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-EMPLEADOSALT');
			SET Var_Control := 'sqlException' ;
		END;

		IF(IFNULL(Par_ClavePuestoID,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 1;
            SET Par_ErrMen = 'El Puesto esta Vacio';
			SET Var_Control := 'clavePuesto' ;
			LEAVE ManejoErrores;
		END IF;

		IF(EXISTS(SELECT RFC
					FROM EMPLEADOS
					WHERE RFC = Par_RFC)) THEN
            SET Par_NumErr := 2;
            SET Par_ErrMen = 'El Empleado ya Existe';
			SET Var_Control := 'RFC' ;
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

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		SET Var_Empleado := (SELECT IFNULL(MAX(EmpleadoID),Entero_Cero) + 1
		FROM EMPLEADOS);

		SET Nombre_Comp := CONCAT(RTRIM(LTRIM(IFNULL(Par_PrimerNombre, '')))
			,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_SegundoNombre, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_SegundoNombre, '')))) ELSE '' END
			,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_ApellidoPat, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_ApellidoPat, '')))) ELSE '' END
			,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_ApellidoMat, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_ApellidoMat, '')))) ELSE '' END
		);


		INSERT INTO EMPLEADOS (EmpleadoID,		ClavePuestoID,			ApellidoPat,		ApellidoMat,	 	PrimerNombre,
							SegundoNombre,		FechaNac,				RFC,				SucursalID,			NombreCompleto,
							 Estatus,			FechaAlta,				Nacionalidad,		LugarNacimiento,	EstadoID,
                             Sexo,				CURP,           		EmpresaID,			Usuario,			FechaActual,
                             DireccionIP,		ProgramaID,	    		Sucursal,	     	NumTransaccion)

		 VALUES			    (Var_Empleado,		Par_ClavePuestoID,		Par_ApellidoPat,	Par_ApellidoMat,	Par_PrimerNombre,
							Par_SegundoNombre,	Par_FechaNac,			Par_RFC,			Par_SucursalID,		Nombre_Comp,
							Estatus_Empleado, 	DATE(Aud_FechaActual),	Par_Nacion,			Par_PaisNacimiento,	Par_EstadoID,
                            Par_Genero,			Par_CURP,               Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
                            Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

        SET Par_NumErr := 0;
		SET Par_ErrMen = CONCAT("Empleado Agregado Exitosamente: ", Var_Empleado);
		SET Var_Control := 'empleadoID' ;

END ManejoErrores;

SELECT Par_NumErr 	 AS NumErr ,
	   Par_ErrMen 	 AS ErrMen,
	   Var_Control 	 AS control,
	   Var_Empleado  AS consecutivo;

END TerminaStore$$