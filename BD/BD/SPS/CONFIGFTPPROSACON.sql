-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONFIGFTPPROSACON
DELIMITER ;
DROP PROCEDURE IF EXISTS CONFIGFTPPROSACON;

DELIMITER $$
CREATE PROCEDURE `CONFIGFTPPROSACON`(
	-- Store Procedure: Que Consulta de CONFIGFTPPROSA
	Par_ConfigFTPProsaID		INT(11),			-- ID de la configuracion
	Par_NumConsulta				TINYINT UNSIGNED,	-- Numero de Consulta

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
	DECLARE Est_Activo				CHAR(1);			-- Estatus Activo
	DECLARE Con_Principal			TINYINT UNSIGNED;	-- Consulta Principal

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Con_Principal			:= 1;

	-- Se realiza la consulta principal
	IF( Par_NumConsulta = Con_Principal ) THEN

		SELECT	CONF.ConfigFTPProsaID,		CONF.Servidor,			CONF.Usuario,	CONF.Contrasenia,	CONF.Puerto,
				CONF.Ruta,					CONF.HoraInicio,		CONF.HoraFin,	CONF.IntervaloMin,	CONF.NumIntentos,	
				CONF.Mensaje,				CONF.UsuarioRemiten
		FROM CONFIGFTPPROSA CONF
		WHERE CONF.ConfigFTPProsaID = Par_ConfigFTPProsaID;
	END IF;

END TerminaStore$$
