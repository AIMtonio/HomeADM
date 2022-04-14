DELIMITER ;

DROP PROCEDURE IF EXISTS `SEGUSUARIOWSCON`;

DELIMITER $$

CREATE PROCEDURE `SEGUSUARIOWSCON`(
	-- SP para consultar los usuarios permitidos para ejecutar un Web Service
	Par_UsuarioID	 				INT(11),					-- ID del Usuario
	Par_Clave						VARCHAR(50),				-- Clave del usuario
	Par_Contrasenia					VARCHAR(50),				-- Contrasenia del usuario
	Par_NombreCompleto				VARCHAR(250),				-- Nombre completo del usuario

	Par_NumCon						TINYINT,					-- Numero de consulta

	Par_EmpresaID					INT(11),					-- Parametros de Auditoria
	Aud_Usuario						INT(11),					-- Parametros de Auditoria
	Aud_FechaActual					DATETIME,					-- Parametros de Auditoria
	Aud_DireccionIP					VARCHAR(15),				-- Parametros de Auditoria
	Aud_ProgramaID					VARCHAR(50),				-- Parametros de Auditoria
	Aud_Sucursal					INT(11),					-- Parametros de Auditoria
	Aud_NumTransaccion				BIGINT(20)					-- Parametros de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE	Con_Clave			INT(11);				-- Consulta de Usuarios por clave
	DECLARE	Est_Activo 			CHAR(1);				-- Estatus activo
    DECLARE Con_OrigenDatos		INT(11);				-- Consulta 4: origen datos del usuario

	-- Asignacion de constantes
	SET	Con_Clave			:= 3;						-- Consulta de Usuarios por clave
	SET	Est_Activo 			:= 'A';						-- Estatus activo
    SET Con_OrigenDatos		:= 4;						-- Consulta 4: origen datos del usuario

	IF(Par_NumCon = Con_Clave)THEN
		SELECT	UsuarioID,		NombreCompleto,			Clave,			Contrasenia,		Estatus,
				Semilla,		IFNULL(OrigenDatos,"") AS OrigenDatos
		FROM SEGUSUARIOWS
		WHERE Clave = Par_Clave
			AND Estatus = Est_Activo;
	END IF;
	
    -- Consulta 4: Origen de datos usuario
	IF(Par_NumCon = Con_OrigenDatos)THEN
		SELECT OrigenDatos
		FROM SEGUSUARIOWS
		WHERE UsuarioID = Par_UsuarioID;
	END IF;
    
END TerminaStore$$