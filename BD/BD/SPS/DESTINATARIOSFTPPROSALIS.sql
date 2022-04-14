-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINATARIOSFTPPROSALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS DESTINATARIOSFTPPROSALIS;

DELIMITER $$
CREATE PROCEDURE `DESTINATARIOSFTPPROSALIS`(
	-- Store Procedure: Que Lista los destinatarios
	Par_Usuario					INT(11),			-- ID del destinatario
	Par_NumLista				TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_UsuarioID				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);			-- Constante de Entero Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Con_EstatusAct			CHAR(1);			-- Constante de estatus activa
	DECLARE Lis_Principal			TINYINT UNSIGNED;	-- Lista Principal

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Lis_Principal			:= 1;
	SET Con_EstatusAct			:= 'A';
	SET Aud_FechaActual			:= NOW();

	-- Se realiza la Lista principal
	IF( Par_NumLista = Lis_Principal ) THEN
		/*SELECT USU.RemitenteID,	USU.CorreoSalida
		FROM DESTINATARIOSFTPPROSA DEST
		INNER JOIN TARENVIOCORREOPARAM USU ON DEST.Usuario = USU.RemitenteID;*/
		SELECT USU.UsuarioID AS RemitenteID,	USU.Correo AS CorreoSalida
		FROM DESTINATARIOSFTPPROSA DEST
		INNER JOIN USUARIOS USU ON DEST.Usuario = USU.UsuarioID;
	END IF;
END TerminaStore$$
