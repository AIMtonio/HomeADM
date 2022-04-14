-- SP NOTASCARGOCON

DELIMITER ;

DROP PROCEDURE IF EXISTS NOTASCARGOCON;

DELIMITER $$

CREATE PROCEDURE `NOTASCARGOCON`(
	-- Stored procedure para hacer consultas con relacion a notas de cargo
	Par_AmortizacionID			INT(11),				-- Identificador de la amortizacion
	Par_CreditoID				BIGINT(12),				-- Identificador del credito

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
	DECLARE Entero_Cero			INT(1);					-- Entero cero
	DECLARE Var_ConAmort		TINYINT UNSIGNED;		-- Consulta de amortizacion de credito con nota de cargo

	-- Asignacion de Constantes y variables
	SET Entero_Cero				:= 0;					-- Entero cero
	SET Var_ConAmort			:= 1;					-- Consulta de amortizacion de credito con nota de cargo

	-- Consulta de amortizacion de credito con nota de cargo
	IF (Par_NumCon = Var_ConAmort) THEN

		SELECT		AMO.AmortizacionID,		AMO.Estatus,		IFNULL(NTC.NotaCargoID, Entero_Cero) NotaCargoID
			FROM	AMORTICREDITO AMO
			LEFT JOIN NOTASCARGO NTC ON NTC.AmortizacionID = AMO.AmortizacionID AND NTC.CreditoID = AMO.CreditoID
			WHERE AMO.AmortizacionID = Par_AmortizacionID
			  AND AMO.CreditoID = Par_CreditoID;

	END IF;

END TerminaStore$$