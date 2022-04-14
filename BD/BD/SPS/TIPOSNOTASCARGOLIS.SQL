-- SP TIPOSNOTASCARGOLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS TIPOSNOTASCARGOLIS;

DELIMITER $$

CREATE PROCEDURE `TIPOSNOTASCARGOLIS`(
	-- Stored procedure para listar los registros de la tabla de tipos de notas de cargo
	Par_NombreCorto					VARCHAR(50),			-- Nombre corto de la nota de cargo

	Par_NumLis						TINYINT UNSIGNED,		-- Numero de Lista

	Par_EmpresaID					INT(11),				-- Parametro de Auditoria de la Empresa
	Aud_Usuario						INT(11),				-- Parametro de Auditoria del Usuario
	Aud_FechaActual					DATETIME,				-- Parametro de Auditoria de la Fecha Actual
	Aud_DireccionIP					VARCHAR(15),			-- Parametro de Auditoria de la Direccion IP
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de Auditoria del ID del Programa
	Aud_Sucursal					INT(11),				-- Parametro de Auditoria de Sucursal
	Aud_NumTransaccion  			BIGINT(20)				-- Parametro de Auditoria del numero de Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Var_EstActivo			CHAR(1);				-- Estatus A : Activo
	DECLARE Var_ListaAyuda			TINYINT UNSIGNED;		-- Lista de ayuda para la pantalla de tipos de notas de cargo
	DECLARE Var_ListaCombo			TINYINT UNSIGNED;		-- Lista para llenar el combo de tipos de notas de cargo

	-- Asignacion de Constantes
	SET Var_EstActivo				:= 'A';					-- Estatus A : Activo
	SET Var_ListaAyuda				:= 1;					-- Lista de ayuda para la pantalla de tipos de notas de cargo
	SET Var_ListaCombo				:= 2;					-- Lista para llenar el combo de tipos de notas de cargo

	-- Lista de ayuda para la pantalla de tipos de notas de cargo
	IF (Par_NumLis = Var_ListaAyuda) THEN

		SELECT		TipoNotaCargoID,		NombreCorto
			FROM	TIPOSNOTASCARGO
			WHERE	NombreCorto LIKE CONCAT('%', Par_NombreCorto, '%')
			LIMIT	0, 15;

	END IF;

	-- Lista para llenar el combo de tipos de notas de cargo
	IF (Par_NumLis = Var_ListaCombo) THEN

		SELECT		TipoNotaCargoID,		NombreCorto
			FROM	TIPOSNOTASCARGO
			WHERE	Estatus = Var_EstActivo
			ORDER BY TipoNotaCargoID ASC;

	END IF;

END TerminaStore$$
