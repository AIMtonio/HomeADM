-- SP TIPOSNOTASCARGOCON

DELIMITER ;

DROP PROCEDURE IF EXISTS TIPOSNOTASCARGOCON;

DELIMITER $$

CREATE PROCEDURE `TIPOSNOTASCARGOCON`(
	-- Stored procedure para consultar los registros de la tabla de tipos de notas de cargo
	Par_TipNotCarID				INT(11),				-- Identificador del registro

	Par_NumCon					TINYINT UNSIGNED,		-- Numero de Consulta

	Par_EmpresaID				INT(11),				-- Parametro de Auditoria de la Empresa
	Aud_Usuario					INT(11),				-- Parametro de Auditoria del Usuario
	Aud_FechaActual				DATETIME,				-- Parametro de Auditoria de la Fecha Actual
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de Auditoria de la Direccion IP
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de Auditoria del ID del Programa
	Aud_Sucursal				INT(11),				-- Parametro de Auditoria de Sucursal
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de Auditoria del numero de Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Var_ConPrincipal	TINYINT UNSIGNED;		-- Consulta principal

	-- Asignacion de Constantes y variables
	SET Var_ConPrincipal		:= 1;					-- Consulta principal

	-- Consulta principal
	IF (Par_NumCon = Var_ConPrincipal) THEN

		SELECT		TipoNotaCargoID,		NombreCorto,		Descripcion,		Estatus,		CobraIVA
			FROM	TIPOSNOTASCARGO
			WHERE	TipoNotaCargoID = Par_TipNotCarID
			LIMIT	1;

	END IF;

END TerminaStore$$