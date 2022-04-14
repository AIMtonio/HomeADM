-- EDOCTAV2RESUMCAPTALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2RESUMCAPTALIS`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2RESUMCAPTALIS`(
	-- Store procedure que lista la informacion del resumen de cuentas de ahorro en los estados de cuenta de clientes nuevos en tronco principal
	Par_ClienteID						INT(11),					-- Identificador del cliente
	Par_NumLis							TINYINT UNSIGNED,			-- Numero de lista
	Par_EmpresaID						INT(11),					-- Parametro de Auditoria
	Aud_Usuario							INT(11),					-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal						INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT(12)					-- Parametro de Auditoria
)

TerminaStore:BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Lis_Principal				INT(11);					-- Consulta principal
	-- ASIGNACION DE CONSTANTES
	SET Lis_Principal					:= 1;						-- Consulta principal de las cuentas de ahorro y inversiones de plazo

	-- Lista del resumen de cuenta por cliente
	IF (Par_NumLis = Lis_Principal)THEN
		SELECT		Etiqueta,		InstrumentoID AS NumeroCuenta,	SaldoAnterior AS SaldoMesAnterior,		SaldoActual,		SaldoPromedio
			FROM	EDOCTAV2RESUMCAPTA
			WHERE	ClienteID = Par_ClienteID
			ORDER BY TipoInstrumento, InstrumentoID;
	END IF;

END TerminaStore$$
