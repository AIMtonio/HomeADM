-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSCON`;DELIMITER $$

CREATE PROCEDURE `USUARIOSCON`(
	Par_NumUsuario	 	CHAR(16),
	Par_Clave			VARCHAR(45),
	Par_Contrasenia		VARCHAR(45),
	Par_NombreCom		VARCHAR(150),
	Par_SucursalUsuario	INT(11),

	Par_NumCon			TINYINT UNSIGNED,
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

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Con_Clave		INT(11);

-- Asignacion de Variables
-- Asignacion de Constantes
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Con_Clave		:= 3;

IF(Par_NumCon = Con_Clave) THEN
	SELECT	Clave,				Rol.Descripcion,	Estatus,		LoginsFallidos,		EstatusSesion,
			Clave AS Semilla,	Usu.OrigenDatos, 	RutaReportes,	RutaImgReportes,	LogoCtePantalla,
			com.RazonSocial,	com.Subdominio
	FROM 	USUARIOS Usu,
			ROLES Rol,
            COMPANIA com
	WHERE 	Usu.Clave 	= Par_Clave
	AND	Usu.RolId	= Rol.RolID
	AND	Usu.OrigenDatos = com.OrigenDatos
	AND Rol.EmpresaID = com.CompaniaID ;

END IF;

END TerminaStore$$