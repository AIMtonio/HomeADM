DELIMITER ;
DROP PROCEDURE IF EXISTS PERFILESANALISTASCON;
DELIMITER $$

CREATE PROCEDURE PERFILESANALISTASCON(
	-- SP para el proceso de consultas de perfiles de analista
	-- Modulo: Bandeja de Solicitudes
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta
	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminAStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Con_Analista		CHAR(1);		-- Tipo perfil Analista
	DECLARE Con_Ejecutivo		CHAR(1);        -- Tipo Perfil Ejecutivo
	DECLARE Con_PerfilAnalista	INT(11);		-- Consulta solo de tipo perfil analista
	DECLARE Con_PerfilEjecutivo	INT(11);		-- Consulta solo de tipo perfil Ejecutivo
	DECLARE Entero_Cero			INT(11);		-- Consulta solo de tipo perfil analista
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante de cadena vacia

	-- ASignacion de Constantes
	SET Con_Analista		    := 'A';		-- A  para tipo Analista
	SET Con_Ejecutivo		    := 'E';		-- A  para tipo Analista
	SET	Con_PerfilAnalista		:= 1;		-- Consulta el perfil del analista
	SET	Con_PerfilEjecutivo		:= 2;		-- Consulta el perfil del analista
	SET Entero_Cero				:= 0;		-- entero cero
	SET Cadena_Vacia			:= '';		-- cadena vacia

	IF(Par_NumCon = Con_PerfilAnalista) THEN
		SELECT 	Perfil.PerfilID,	Perfil.RolID,	Perfil.TipoPerfil
		FROM PERFILESANALISTAS Perfil
		INNER JOIN ROLES Rol ON Perfil.RolID = Rol.RolID
		INNER JOIN USUARIOS Usua ON Rol.RolID = Usua.RolID
		WHERE Perfil.TipoPerfil = Con_Analista
			AND Usua.UsuarioID = Aud_Usuario
		LIMIT 0,1;
	END IF;
	
	IF(Par_NumCon = Con_PerfilEjecutivo) THEN
		SELECT 	Perfil.PerfilID,	Perfil.RolID,	Perfil.TipoPerfil
		FROM PERFILESANALISTAS Perfil
		INNER JOIN ROLES Rol ON Perfil.RolID = Rol.RolID
		INNER JOIN USUARIOS Usua ON Rol.RolID = Usua.RolID
		WHERE Perfil.TipoPerfil = Con_Ejecutivo
			AND Usua.UsuarioID = Aud_Usuario
		LIMIT 0,1;
	END IF;

END TerminAStore$$
