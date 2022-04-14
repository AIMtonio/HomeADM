-- EDOCTAV2CAROBJETADOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2CAROBJETADOSLIS`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2CAROBJETADOSLIS`(
	-- SP PARA LISTAR LOS CARGOS OBJETADOS POR EL CLIENTE PARA EL ESTADO DE CUENTA BIENESTAR
	Par_ClienteID						INT(11),			-- Identificador del cliente
	Par_NumLis							TINYINT UNSIGNED,	-- Numero de lista
	Par_EmpresaID 						INT(11),			-- Parametros de auditoria
	Aud_Usuario							INT(11),			-- Parametros de auditoria
	Aud_FechaActual						DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP						VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID						VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal						INT(11), 			-- Parametros de auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Parametros de auditoria
)

TerminaStore: BEGIN
	-- DECLARACION DE CONSTANTES
	DECLARE Var_LisPrincipal			TINYINT UNSIGNED;	-- Numero de lista principal

	-- ASIGNACION DE CONSTANTES
	SET Var_LisPrincipal				:= 1;				-- Numero de lista principal

	IF (Par_NumLis = Var_LisPrincipal) THEN

		SELECT		Instrumento,		FechaIncidencia,		Descripcion,		MontoObjetado,		FechaReporte,
					CargoObjetadoID
			FROM	EDOCTAV2CAROBJETADOS
			WHERE	ClienteID = Par_ClienteID
			ORDER BY FechaReporte;
	END IF;

END TerminaStore$$