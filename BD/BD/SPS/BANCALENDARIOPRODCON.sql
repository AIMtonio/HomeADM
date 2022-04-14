-- BANCALENDARIOPRODCON
DELIMITER ;
DROP PROCEDURE IF EXISTS BANCALENDARIOPRODCON;
DELIMITER $$


CREATE PROCEDURE BANCALENDARIOPRODCON (
-- CONSULTA EL ESQUEMA DE CALENDARIOS POR PRODUCTO DE CREDITO.
	Par_ProduCredID			INT(11),			-- Numero del producto de credito.
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta.

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria ID de la Empresa
	Aud_Usuario				INT(11),			-- Parametro de Auditoria ID del Usuario
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria Fecha Actual

	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(60),		-- Parametro de Auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria ID de la Sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria Numero de la Transaccion
)

TerminaStore: BEGIN
	-- DECLARACION DE CONSTANTES
	DECLARE Con_Principal	INT(11);

	-- ASIGNACION DE CONSTANTES
	SET	Con_Principal		:= 1;		-- Consulta Principal

	-- 1.CONSULTA PRINCIPAL
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	ProductoCreditoID,	FecInHabTomar,		AjusFecExigVenc,	PermCalenIrreg,		AjusFecUlAmoVen,
				TipoPagoCapital,	IguaCalenIntCap,	DiaPagoCapital,		DiaPagoInteres,		TipoDispersion,
				DiaPagoQuincenal,	DiasReqPrimerAmor
			FROM CALENDARIOPROD
			WHERE ProductoCreditoID = Par_ProduCredID;
	END IF;

END TerminaStore$$