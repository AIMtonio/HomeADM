DELIMITER ;

DROP PROCEDURE IF EXISTS `SEGUSUARIOWSROLLIS`;

DELIMITER $$

CREATE PROCEDURE `SEGUSUARIOWSROLLIS` (
	-- SP para consultar los roles de los usuarios permitidos para ejecutar un Web Service

	Par_UsuarioID 					INT(11),					-- ID del usuario
	Par_RolID 						INT(11),					-- ID del rol

	Par_NumLis						TINYINT,					-- Numero de lista

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
	DECLARE Lis_RolesUsuario		TINYINT;					-- Lista de roles por usuario

	-- Asignacion de constantes
	SET	Lis_RolesUsuario			:= 1;						-- Lista de roles por usuario

	IF(Par_NumLis = Lis_RolesUsuario)
	THEN
		SELECT SEGUSUARIOWSROL.UsuarioID, SEGUSUARIOWSROL.RolID, SEGROL.NombreRol, SEGROL.Descripcion
			FROM SEGUSUARIOWSROL
			INNER JOIN SEGROL ON SEGROL.RolID = SEGUSUARIOWSROL.RolID
			WHERE SEGUSUARIOWSROL.UsuarioID = Par_UsuarioID;
	END IF;
END TerminaStore$$