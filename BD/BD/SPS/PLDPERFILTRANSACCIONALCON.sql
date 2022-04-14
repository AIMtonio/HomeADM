-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPERFILTRANSACCIONALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPERFILTRANSACCIONALCON`;
DELIMITER $$

CREATE PROCEDURE `PLDPERFILTRANSACCIONALCON`(
	-- SP para consultar el Perfil Transaccional del Cliente o Usuario de Servcios.
	Par_PersonaID				INT(11),				-- Número de identificación del cliente o usuario de servicios.
	Par_NumCon					TINYINT UNSIGNED,		-- Número de consulta que se realizará.

	-- Parametros de Auditoria
	Aud_EmpresaID               INT(11),                -- Parámetro de auditoría ID de la empresa.
    Aud_Usuario                 INT(11),                -- Parámetro de auditoría ID del usuario.
    Aud_FechaActual             DATETIME,               -- Parámetro de auditoría fecha actual.
    Aud_DireccionIP             VARCHAR(15),            -- Parámetro de auditoría direccion IP.
    Aud_ProgramaID              VARCHAR(50),            -- Parámetro de auditoría programa.
    Aud_Sucursal                INT(11),                -- Parámetro de auditoría ID de la sucursal.
    Aud_NumTransaccion          BIGINT(20)              -- Parámetro de auditoría numero de transaccion.
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);			-- Constante número cero (o).
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante cadena vacia ''.
	DECLARE Cons_NO					CHAR(1);			-- Constante no 'N'.
	DECLARE Con_PrincipalCliente	INT(11);			-- Consulta principal perfil transaccional cliente.
	DECLARE Con_PrincipalUsuario	INT(11);			-- Consulta de la informacion de perfil transacional del cliente  para WS

	DECLARE Con_PrinUsrServicios	INT(11);			-- Consulta principal perfil transaccional usuario de servicios.

	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:= 'S';
	SET Cons_NO						:= 'S';
	SET Con_PrincipalCliente		:= 1;
	SET Con_PrincipalUsuario		:= 2;

	SET Con_PrinUsrServicios		:= 3;

	-- 3. Consulta principal del perfil transaccional de un cliente.
	-- Pantalla: Prevencion LD > Registro > Perfil Transaccional.
	IF(Par_NumCon = Con_PrincipalCliente) THEN
		SELECT
			ClienteID,			DepositosMax,			RetirosMax,			NumDepositos,			NumRetiros,
			NumDepoApli,		NumRetiApli,			CatOrigenRecID,		CatDestinoRecID,		ComentarioOrigenRec,
			ComentarioDestRec
			FROM PLDPERFILTRANS
				WHERE
				ClienteID = Par_PersonaID;
	END IF;

	-- 2.- -- Consulta de la informacion de perfil transacional del cliente para WS
	IF(Par_NumCon = Con_PrincipalUsuario) THEN
		SELECT	TRANS.ClienteID,		CLI.NombreCompleto AS NombreCliente,	TRANS.DepositosMax,			TRANS.RetirosMax,				TRANS.NumDepositos,
				TRANS.NumRetiros,		TRANS.CatOrigenRecID,					TRANS.CatDestinoRecID,		TRANS.ComentarioOrigenRec,		TRANS.ComentarioDestRec
			FROM PLDPERFILTRANS TRANS
			INNER JOIN CLIENTES CLI ON CLI.ClienteID = TRANS.ClienteID
		WHERE TRANS.ClienteID = Par_PersonaID;
	END IF;

	-- 3. Consulta principal del perfil transaccional de un usuario de servicios.
	-- Pantalla: Prevencion LD > Registro > Perfil Transaccional.
	IF(Par_NumCon = Con_PrinUsrServicios) THEN
		SELECT
			UsuarioServicioID,	DepositosMax,	RetirosMax,			NumDepositos,		NumRetiros,
			NumDepoApli,		NumRetiApli,	CatOrigenRecID,		CatDestinoRecID,	ComentarioOrigenRec,
			ComentarioDestRec
		FROM PLDPERFILTRANS
		WHERE UsuarioServicioID = Par_PersonaID;
	END IF;

END TerminaStore$$