-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMGUARDAVALORESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS PARAMGUARDAVALORESCON;

DELIMITER $$
CREATE PROCEDURE `PARAMGUARDAVALORESCON`(
	-- Store Procedure: Que Consulta la configuracion de los Parametros de Guarda Valores
	-- Modulo Guarda Valores
	Par_ParamGuardaValoresID	INT(11),			-- Numero de Proceso
	Par_UsuarioAdmon			INT(11),			-- ID de Usuario Administrancio
	Par_NumConsulta				TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Con_Principal		TINYINT UNSIGNED;	-- Consulta Principal
	DECLARE Con_Foranea			TINYINT UNSIGNED;	-- Consulta Foranea
	DECLARE Con_UsuarioAdmon	TINYINT UNSIGNED;	-- Consulta Usuario Administracion

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Con_Principal			:= 1;
	SET Con_Foranea				:= 2;
	SET Con_UsuarioAdmon		:= 3;

	-- Se realiza la consulta principal
	IF( Par_NumConsulta = Con_Principal) THEN

		SELECT	Par.ParamGuardaValoresID,	Par.UsuarioAdmon,	Par.CorreoRemitente,
				Par.NombreEmpresa,			Usr.NombreCompleto AS NombreUsuarioAdmon,
				Par.ServidorCorreo,			Par.Puerto,			Par.UsuarioServidor,
				Par.Contrasenia
		FROM PARAMGUARDAVALORES Par
		INNER JOIN USUARIOS Usr ON Usr.UsuarioID = Par.UsuarioAdmon
		WHERE ParamGuardaValoresID = Par_ParamGuardaValoresID;

	END IF;

	-- Se realiza la consulta para validar que existan los parametros
	IF( Par_NumConsulta = Con_Foranea) THEN

		SELECT	IFNULL(MAX(ParamGuardaValoresID), Entero_Cero) AS ParamGuardaValoresID
		FROM PARAMGUARDAVALORES;

	END IF;

	-- Se realiza la consulta para validar que existan los parametros
	IF( Par_NumConsulta = Con_UsuarioAdmon) THEN

		SELECT IFNULL(COUNT(UsuarioAdmon), Entero_Cero) AS ParamGuardaValoresID
		FROM PARAMGUARDAVALORES
		WHERE UsuarioAdmon = Par_UsuarioAdmon;

	END IF;

END TerminaStore$$