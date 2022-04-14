-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARENVIOCORREOPARAMCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARENVIOCORREOPARAMCON`;
DELIMITER $$


CREATE PROCEDURE `TARENVIOCORREOPARAMCON`(
	-- SP para la consulta de correos
	Par_RemitenteID			INT(11),					-- ID de la empresa
	Par_NumCon				TINYINT UNSIGNED,			-- Numero de consulta

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),					-- Parametro de auditoria
	Aud_Usuario				INT(11),					-- Parametro de auditoria

	Aud_FechaActual			DATETIME,					-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),				-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),				-- Parametro de auditoria
	Aud_Sucursal			INT(11),					-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)					-- Parametro de auditoria
)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);			-- Declaracion de Constante entero cero
	DECLARE Fecha_Vacia				DATE;				-- Declaracion de Constante fecha vacia
	DECLARE Cadena_Vacia			CHAR(1);			-- Declaracion de Constante cadena vacia
	DECLARE Con_Principal			INT(11);			-- Consulta principal
	DECLARE Con_CorreoUsu			INT(11);			-- Consulta correo usuario
	DECLARE Con_UsuarioAct			INT(11);			-- Consulta desc y correo usuario activo

	-- Asignacion de Constantes
	SET Entero_Cero					:= 0;    			-- Entero Cero
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha vacia
	SET Cadena_Vacia				:= '';				-- Cadena vacia
	SET Con_Principal				:= 1;				-- Consulta principal
	SET Con_CorreoUsu				:= 2;				-- Consulta correo usuario
	SET Con_UsuarioAct				:= 3;				-- Consulta desc y correo usuario activo

	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			RemitenteID, 	Descripcion,			ServidorSMTP,		PuertoServerSMTP, 	TipoSeguridad,
			CorreoSalida,	ConAutentificacion,		Contrasenia,		Estatus,            Comentario,
			AliasRemitente,	TamanioMax,				Tipo
			FROM TARENVIOCORREOPARAM
			WHERE RemitenteID = Par_RemitenteID;
	END IF;
	-- Consulta correo del usuario de safi
	IF(Par_NumCon = Con_CorreoUsu) THEN
		SELECT Correo AS Descripcion
		FROM USUARIOS
		WHERE UsuarioID = Par_RemitenteID;
	END IF;

	IF(Par_NumCon = Con_UsuarioAct) THEN
		SELECT RemitenteID, Descripcion, CorreoSalida
		FROM TARENVIOCORREOPARAM
			WHERE RemitenteID = Par_RemitenteID
			AND Estatus = 'A';
	END IF;

END TerminaStore$$