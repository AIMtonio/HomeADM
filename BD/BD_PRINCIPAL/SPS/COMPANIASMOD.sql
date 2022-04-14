-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMPANIASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMPANIASMOD`;DELIMITER $$

CREATE PROCEDURE `COMPANIASMOD`(

	Par_CompaniaID			INT(11),
	Par_RazonSocial			VARCHAR(100),
	Par_DireccionCompleta	VARCHAR(45),
	Par_OrigenDatos			VARCHAR(45),
	Par_Prefijo				VARCHAR(45),

    Par_MostrarPrefijo		CHAR(1),
	Par_Desplegado			VARCHAR(45),
    Par_Subdominio			VARCHAR(50),
	Par_Salida            	CHAR(1),      	#
    INOUT Par_NumErr      	INT,        	# Numero de error

    INOUT Par_ErrMen      	VARCHAR(400),   # Mensaje de error
	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

    Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN

DECLARE Var_Control			VARCHAR(50);

-- Declaracion de Constantes
DECLARE		Estatus_Activo	CHAR(1);	-- estatus Activo
DECLARE		Cadena_Vacia	CHAR(1);	-- cadena vacia
DECLARE		Fecha_Vacia		DATE;		-- fecha vacia
DECLARE		Entero_Cero		INT;		-- entero en cero
DECLARE 	Salida_SI		CHAR(1);


-- Asignacion de Constantes
SET	Estatus_Activo	:= 'A';
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Salida_SI		:= 'S';


ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
            'esto le ocasiona. Ref: SP-COMPANIASMOD');
    END;

		IF(IFNULL(Par_RazonSocial,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr 	:= 2;
			SET Par_ErrMen 	:= 'La Razon Social esta Vacia.';
            SET Var_Control := 'razonSocial';
            LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_DireccionCompleta,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 3;
			SET Par_ErrMen 	:= 'La Direccion esta Vacia.';
            SET Var_Control := 'direccionCompleta';
            LEAVE ManejoErrores;

		END IF;


		IF(IFNULL(Par_OrigenDatos,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 4;
			SET Par_ErrMen 	:= 'Origen de Datos esta Vacio.' ;
            SET Var_Control	:= 'origenDatos';
            LEAVE ManejoErrores;

		END IF;


		IF(IFNULL(Par_Prefijo,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 5;
			SET Par_ErrMen 	:= 'El Prefijo esta Vacio.' ;
            SET Var_Control := 'prefijo';
            LEAVE ManejoErrores;

		END IF;

		IF(IFNULL(Par_Desplegado,Cadena_Vacia) = Cadena_Vacia) THEN

            SET Par_NumErr 	:= 6;
			SET Par_ErrMen 	:= 'El Desplegado esta Vacio.';
            SET Var_Control	:= 'desplegado';
            LEAVE ManejoErrores;

		END IF;

        IF EXISTS (SELECT CompaniaID FROM COMPANIA WHERE Prefijo = Par_Prefijo
									AND CompaniaID  <> Par_CompaniaID) THEN

            SET Par_NumErr 	:= 7;
			SET Par_ErrMen 	:= 'El Prefijo esta ocupado.';
            SET Var_Control	:= 'prefijo';
            LEAVE ManejoErrores;

        END IF;

         IF EXISTS (SELECT CompaniaID  FROM COMPANIA WHERE Subdominio = Par_Subdominio
										AND CompaniaID  <> Par_CompaniaID) THEN

            SET Par_NumErr 	:= 8;
			SET Par_ErrMen 	:= 'Subdominio duplicado.';
            SET Var_Control	:= 'subdominio';
            LEAVE ManejoErrores;

        END IF;

		UPDATE COMPANIA SET
			RazonSocial				= Par_RazonSocial,
			DireccionCompleta		= Par_DireccionCompleta,
			OrigenDatos				= Par_OrigenDatos,
			Prefijo					= Par_Prefijo,
			MostrarPrefijo			= Par_MostrarPrefijo,

            Desplegado				= Par_Desplegado,
            Subdominio				= Par_Subdominio,
			EmpresaID				= Par_EmpresaID,
			Aud_Usuario				= Aud_Usuario,
			Aud_FechaActual 		= Aud_FechaActual,

            Aud_DireccionIP 		= Aud_DireccionIP,
			Aud_ProgramaID  		= Aud_ProgramaID,
			Aud_Sucursal			= Aud_Sucursal,
			Aud_NumTransaccion		= Aud_NumTransaccion

		WHERE CompaniaID		= Par_CompaniaID;


		SET Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= CONCAT('Compania Modificada Exitosamente: ', CONVERT(Par_CompaniaID,CHAR)) ;
		SET Var_Control	:= 'companiaID';

END ManejoErrores;

IF Par_Salida = Salida_SI THEN

	SELECT  Par_NumErr 		AS NumErr,
			  Par_ErrMen 	AS ErrMen,
			  Var_Control 	AS Control,
			  Par_CompaniaID AS Consecutivo;

END IF;


END TerminaStore$$