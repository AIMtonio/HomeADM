-- SP NOMESQUEMATASACREDLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMESQUEMATASACREDLIS;

DELIMITER $$

CREATE PROCEDURE NOMESQUEMATASACREDLIS (
	-- STORE PROCEDURE PARA LISTAS DE LA TABLA NOMESQUEMATASACRED
	Par_CondicionCredID		BIGINT(20),			-- Identificador de Condicion de Credito
	Par_NumLis				TINYINT,			-- Numero de lista

	Par_EmpresaID 			INT(11), 			-- Parametros de auditoria
	Aud_Usuario				INT(11),			-- Parametros de auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal			INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de auditoria
)

TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Var_LisGrid		TINYINT UNSIGNED;	-- Lista grid de la tabla NOMESQUEMATASACRED

	-- Asignacion de constantes
	SET Var_LisGrid			:= 2;				-- Lista grid de la tabla de NOMESQUEMATASACRED

	IF (Par_NumLis = Var_LisGrid) THEN
		SELECT 	EsqTasaCredID,			SucursalID,				TipoEmpleadoID,	 PlazoID,	MinCred,
				MaxCred,				MontoMin,				MontoMax,		Tasa
			FROM NOMESQUEMATASACRED
			WHERE CondicionCredID	= Par_CondicionCredID;
	END IF;

END TerminaStore$$

