-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSMOD`;DELIMITER $$

CREATE PROCEDURE `USUARIOSMOD`(
	-- Modificacion de de usuario
	Par_Clave			VARCHAR(50),
	Par_RolID			INT,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

-- declaracion de variables
DECLARE	NombComp		VARCHAR(150);
DECLARE	varRolID		INT(11);
DECLARE	varClave		VARCHAR(50);

-- declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);	-- cadena vacia
DECLARE	Fecha_Vacia		DATE;		-- fecha vacia
DECLARE	Entero_Cero		INT;		-- entero en cero

-- asignacion de constantes
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;

-- asignacion de variables
-- se guarda el valor del rol id para validar que  exista
SET varRolID		:= (SELECT RolID FROM ROLES WHERE RolID = Par_RolID  AND EmpresaID = Par_EmpresaID);


IF(IFNULL(varRolID,Entero_Cero) = Entero_Cero )THEN
	SELECT '005' AS NumErr,
			'El Rol indicado no existe.' AS ErrMen,
			'rolID' AS control,
			Cadena_Vacia AS Consecutivo;
	LEAVE TERMINASTORE;
END IF;



-- se guarda el valor de la clave para validar que no exista
SELECT 	Clave  INTO	varClave
FROM USUARIOS
WHERE Clave LIKE Par_Clave LIMIT 1;

IF(IFNULL(varClave,Cadena_Vacia) = Cadena_Vacia) THEN
	SELECT '007' AS NumErr,
			'La clave indicada no existe. ' AS ErrMen,
			'clave' AS control,
			Cadena_Vacia AS Consecutivo;
	LEAVE TERMINASTORE;
END IF;



SET Aud_FechaActual := CURRENT_TIMESTAMP();

UPDATE USUARIOS SET

	RolID				= Par_RolID,
	EmpresaID			= Par_EmpresaID,
	Usuario				= Aud_Usuario,
	FechaActual 		= Aud_FechaActual,
	DireccionIP 		= Aud_DireccionIP,
	ProgramaID  		= Aud_ProgramaID,
	Sucursal			= Aud_Sucursal,
	NumTransaccion		= Aud_NumTransaccion
WHERE Clave			= Par_Clave;

SELECT '000' AS NumErr ,
		CONCAT('Usuario Modificado Exitosamente: ', CONVERT(Par_Clave,CHAR)) AS ErrMen,
		'usuarioID' AS control,
		Par_Clave AS consecutivo;

END TerminaStore$$