-- EDOCTAV2RESUMCREDITOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2RESUMCREDITOSLIS`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2RESUMCREDITOSLIS`(
	-- SP PARA LISTAR EL RESUMEN DE CREDITOS PARA EL ESTADO DE CUENTA BIENESTAR
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

		SELECT		Producto,		CreditoID,		SaldoInsoluto,		FechaLeyenda,		FechaProxPago,
					MontoProximoPago AS TotalPagar
			FROM	EDOCTAV2RESUMCREDITOS
			WHERE	ClienteID = Par_ClienteID
			ORDER BY CreditoID;

	END IF;

END TerminaStore$$