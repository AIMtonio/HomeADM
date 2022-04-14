-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMPANIASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMPANIASALT`;DELIMITER $$

CREATE PROCEDURE `COMPANIASALT`(
	/* *** SP PARA DAR DE ALTA COMPANIAS DE MULTIBASE *** */
	Par_CompaniaID			INT(11),
	Par_RazonSocial			VARCHAR(100),
	Par_DireccionCompleta	VARCHAR(100),
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
DECLARE 	NumeroCompania  INT;
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
            'esto le ocasiona. Ref: SP-COMPANIASALT');
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

        IF EXISTS (SELECT CompaniaID FROM COMPANIA WHERE Prefijo = Par_Prefijo) THEN

            SET Par_NumErr 	:= 7;
			SET Par_ErrMen 	:= 'El Prefijo esta ocupado.';
            SET Var_Control	:= 'prefijo';
            LEAVE ManejoErrores;

        END IF;

        SET Par_Subdominio := IFNULL(Par_Subdominio,Cadena_Vacia);

        IF EXISTS (SELECT CompaniaID  FROM COMPANIA WHERE Subdominio = Par_Subdominio) THEN

            SET Par_NumErr 	:= 8;
			SET Par_ErrMen 	:= 'Subdominio duplicado.';
            SET Var_Control	:= 'subdominio';
            LEAVE ManejoErrores;

        END IF;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		SET NumeroCompania := (SELECT IFNULL(MAX(CompaniaID),Entero_Cero) + 1  FROM COMPANIA);

		INSERT INTO COMPANIA (
			CompaniaID,     	RazonSocial,    	DireccionCompleta,        OrigenDatos,		Prefijo,
			MostrarPrefijo,		Desplegado,			Subdominio,				  EmpresaID,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     	  Aud_Sucursal,		Aud_NumTransaccion)
			VALUES(
			NumeroCompania,		Par_RazonSocial,      Par_DireccionCompleta,	Par_OrigenDatos,	Par_Prefijo,
			Par_MostrarPrefijo,	Par_Desplegado,		  Par_Subdominio,			Par_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,  	  Aud_ProgramaID,		    Aud_Sucursal,      	Aud_NumTransaccion);

		SET Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= CONCAT("Compania Agregada exitosamente: ", CONVERT(NumeroCompania, CHAR));
		SET Var_Control	:= 'companiaID';

END ManejoErrores;

IF Par_Salida = Salida_SI THEN

	SELECT  Par_NumErr 		AS NumErr,
			  Par_ErrMen 	AS ErrMen,
			  Var_Control 	AS Control,
			  IFNULL(NumeroCompania,Entero_Cero) AS Consecutivo;

END IF;

END	TerminaStore$$