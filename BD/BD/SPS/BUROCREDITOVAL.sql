
-- BUROCREDITOVAL --

DELIMITER ;
DROP PROCEDURE IF EXISTS `BUROCREDITOVAL`;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `BUROCREDITOVAL`(
	Par_ApellidoPaterno		VARCHAR(26),
	Par_ApellidoMaterno		VARCHAR(26),
	Par_PrimerNombre		VARCHAR(26),
	Par_SegundoNombre		VARCHAR(26),
	Par_RFC					VARCHAR(13),

	Par_FechaNacimiento		DATE,
	Par_Calle				VARCHAR(40),
	Par_Manzana				VARCHAR(10),
	Par_Lote				VARCHAR(10),
	Par_NumeroExt			VARCHAR(10),

	Par_NumeroInt			VARCHAR(10),
	Par_NombreColonia		VARCHAR(100),
	Par_NombreMunicipio		VARCHAR(40),
	Par_ClaveEstado			VARCHAR(4),
	Par_CP					VARCHAR(5),

	Par_Salida				CHAR(1),
    INOUT	Par_NumErr		INT,
    INOUT	Par_ErrMen		VARCHAR(400),
	Par_EmpresaID			INT,
    Aud_Usuario         	INT,

    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT,
    Aud_NumTransaccion  	BIGINT
)
TerminaStore: BEGIN


DECLARE Var_TipoCta 	VARCHAR(2);
DECLARE Valida_RFC		INT;
DECLARE Valida_CURP		CHAR(18);
DECLARE VarControl		CHAR(15);
DECLARE Valida_Estado	CHAR(5);
DECLARE Var_Alfa		CHAR(4);
DECLARE Var_Año 		INT;
DECLARE Var_Mes			INT;
DECLARE Var_Dia			INT;
DECLARE Var_Tamano		INT;


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Fecha_Alta		DATE;
DECLARE	Salida_SI       CHAR(1);
DECLARE	Var_NO			CHAR(1);
DECLARE	Estatus_Activo	CHAR(1);
DECLARE Tel_Vacio		INT;


SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Entero_Cero			:= 0;
SET Par_NumErr  		:= 0;
SET Par_ErrMen  		:='DATOS CORRECTOS';
SET Salida_SI			:='S';
SET Var_NO				:='N';
SET	Estatus_Activo		:='A';
SET Tel_Vacio			:='00000';

ManejoErrores:BEGIN


SET Par_ApellidoPaterno := IFNULL(Par_ApellidoPaterno, Cadena_Vacia);

IF(LENGTH(Par_ApellidoPaterno)>26 ) THEN
		SET Par_NumErr   := 05;
		SET Par_ErrMen   := 'El Apellido Paterno rebasa los 26 caracteres permitidos';
		SET VarControl   := 'ApellidoPaterno';
		LEAVE ManejoErrores;
END IF;



IF(LENGTH(Par_ApellidoMaterno)>26 ) THEN
		SET Par_NumErr   := 05;
		SET Par_ErrMen   := 'El Apellido Materno rebasa los 26 caracteres permitidos';
		SET VarControl   := 'ApellidoMaterno';
		LEAVE ManejoErrores;
END IF;


SET Par_PrimerNombre := IFNULL(Par_PrimerNombre, Cadena_Vacia);
IF(Par_PrimerNombre = Cadena_Vacia) THEN
		SET Par_NumErr   := 07;
		SET Par_ErrMen   := 'El Primer Nombre no debe estar vacío';
		SET VarControl   := 'Nombres';
		LEAVE ManejoErrores;
END IF;
IF(LENGTH(Par_PrimerNombre)>30 ) THEN
		SET Par_NumErr   := 07;
		SET Par_ErrMen   := 'El Primer Nombre no debe rebasar los 30 caracteres';
		SET VarControl   := 'Nombres';
		LEAVE ManejoErrores;
END IF;
SET Par_SegundoNombre := IFNULL(Par_SegundoNombre, Cadena_Vacia);
IF(LENGTH(Par_SegundoNombre)>26 ) THEN
		SET Par_NumErr   := 07;
		SET Par_ErrMen   := 'El Segundo Nombre no debe rebasar los 26 caracteres';
		SET VarControl   := 'Nombres';
		LEAVE ManejoErrores;
END IF;


SET Par_FechaNacimiento := IFNULL(Par_FechaNacimiento, Cadena_Vacia);
IF(Par_FechaNacimiento = Fecha_Vacia ) THEN
		SET Par_NumErr   := 08;
		SET Par_ErrMen   := 'La Fecha de Nacimiento está vacía o el Valor es Incorrecto';
		SET VarControl   := 'FechaNacimiento';
		LEAVE ManejoErrores;
END IF;


SET Par_RFC := IFNULL(Par_RFC, Cadena_Vacia);
IF(Par_RFC != Cadena_Vacia)THEN
	IF(LENGTH(Par_RFC) >13 ) THEN
		SET Par_NumErr   := 09;
		SET Par_ErrMen   := 'El RFC no debe ser mayor a 13 caracteres';
		SET VarControl   := 'RFC';
		LEAVE ManejoErrores;

	END IF;
	IF(LENGTH(Par_RFC) <13 ) THEN
		SET Par_NumErr   := 09;
		SET Par_ErrMen   := 'El RFC no es Correcto';
		SET VarControl   := '';
		LEAVE ManejoErrores;

	END IF;

	SET Var_Alfa :=SUBSTRING(Par_RFC, 1, 4);
	SET Var_Año  :=SUBSTRING(Par_RFC, 5, 2);
	SET Var_Mes	 :=SUBSTRING(Par_RFC, 7, 2);
	SET Var_Dia	 :=SUBSTRING(Par_RFC, 9, 2);

	IF (LOCATE('1', Var_Alfa) > 0 OR LOCATE('2', Var_Alfa) > 0 OR LOCATE('3', Var_Alfa) > 0 OR LOCATE('4', Var_Alfa) > 0 OR LOCATE('5', Var_Alfa) > 0 OR
			LOCATE('6', Var_Alfa) > 0 OR LOCATE('7', Var_Alfa) > 0 OR LOCATE('8', Var_Alfa) > 0 OR LOCATE('9', Var_Alfa) > 0 OR LOCATE('0', Var_Alfa) > 0 )THEN
		SET Par_NumErr   := 09;
		SET Par_ErrMen   := 'Posiciones 1 al 4  del RFC deben contener letras.';
		SET VarControl   := 'RFC';
		LEAVE ManejoErrores;
	END IF;
	IF(Var_Año < 0 OR Var_Año >99  )THEN
		SET Par_NumErr   := 09;
		SET Par_ErrMen   := 'Posiciones 5 y 6 del RFC deben contener un número entre 00 y 99';
		SET VarControl   := 'RFC';
		LEAVE ManejoErrores;
	END IF;
	IF(Var_Mes < 1 OR Var_Mes > 12)THEN
		SET Par_NumErr   := 09;
		SET Par_ErrMen   := 'Posiciones 7 y 8 del RFC deben contener un número entre 01 y 12';
		SET VarControl   := 'RFC';
		LEAVE ManejoErrores;
	END IF;
	IF(Var_Dia < 1 OR Var_Dia > 31)THEN
		SET Par_NumErr   := 09;
		SET Par_ErrMen   := 'Posiciones 9 y 10 del RFC deben contener un número entre 01 y 31';
		SET VarControl   := 'RFC';
		LEAVE ManejoErrores;
	END IF;
END IF;


SET Par_NombreColonia := IFNULL(Par_NombreColonia, Cadena_Vacia);
IF(Par_NombreColonia != Cadena_Vacia)THEN
	IF(LENGTH(Par_NombreColonia)>65) THEN
		SET Par_NumErr   := 17;
		SET Par_ErrMen   := 'La Colonia rebasa los 65 caracteres permitidos';
		SET VarControl   := 'ColoniaPoblacion';
		LEAVE ManejoErrores;
	END IF;
END IF;


SET Par_NombreMunicipio := IFNULL(Par_NombreMunicipio, Cadena_Vacia);
IF(Par_NombreMunicipio = Cadena_Vacia) THEN
		SET Par_NumErr   := 18;
		SET Par_ErrMen   := 'El Municipio no debe estar vacío';
		SET VarControl   := 'Direccion';
		LEAVE ManejoErrores;
END IF;
IF(LENGTH(Par_NombreMunicipio)>65) THEN
		SET Par_NumErr   := 18;
		SET Par_ErrMen   := 'El Municipio rebasa los 65 caracteres permitidos';
		SET VarControl   := 'DelMunicipio';
		LEAVE ManejoErrores;
END IF;


SET Par_ClaveEstado := IFNULL(Par_ClaveEstado, Cadena_Vacia);
IF(Par_ClaveEstado = Cadena_Vacia) THEN
		SET Par_NumErr   := 19;
		SET Par_ErrMen   := 'El Estado no debe estar vacío';
		SET VarControl   := 'Direccion';
		LEAVE ManejoErrores;
END IF;
IF(LENGTH(Par_ClaveEstado) > 4) THEN
		SET Par_NumErr   := 19;
		SET Par_ErrMen   := 'El Estado rebasa los 4 caracteres permitidos';
		SET VarControl   := 'DelMunicipio';
		LEAVE ManejoErrores;
END IF;


SET Par_CP := IFNULL(Par_CP, Cadena_Vacia);
IF(Par_CP = Cadena_Vacia) THEN
		SET Par_NumErr   := 20;
		SET Par_ErrMen   := 'El Codigo Postal no debe estar vacío';
		SET VarControl   := 'CP';
		LEAVE ManejoErrores;
END IF;
IF(LENGTH(Par_CP) > 5) THEN
		SET Par_NumErr   := 20;
		SET Par_ErrMen   := 'El CodigoPstal rebasa los 5 caracteres permitidos';
		SET VarControl   := 'CP';
		LEAVE ManejoErrores;
END IF;


END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
  IF(Par_NumErr = Entero_Cero) THEN
	SELECT Par_NumErr AS NumErr,
		   Par_ErrMen AS ErrMen,
		   Cadena_Vacia AS control,
		   Cadena_Vacia	 AS consecutivo;
  ELSE
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Cadena_Vacia AS control,
			Cadena_Vacia	 AS consecutivo;
   END IF;
END IF;

END TerminaStore$$