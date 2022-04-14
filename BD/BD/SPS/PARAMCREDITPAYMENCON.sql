-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMCREDITPAYMENCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMCREDITPAYMENCON`;
DELIMITER $$

CREATE PROCEDURE `PARAMCREDITPAYMENCON`(
	-- SP PARA CONSULTAR LA TABLA PARAMCREDITPAYMENT DE LAS PARAMETRIZACIONES DE PAGO WS CREDITO PAYMENT
	Par_ParamCreditPaymentID	INT(11),		-- Numero o ID de la tabla de Parametros de web service credito Payment
	Par_ProducCreditoID			INT(11),		-- ID o Numero del producto de credito,
	Par_NumCon					TINYINT,		-- Numero de Consulta

	Aud_EmpresaID				INT(11),		-- Parametro de Auditoria
	Aud_Usuario					INT(11),		-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria
)TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Con_Principal			TINYINT;	-- Consulta Principal

	-- ASIGNACION DE CONSTANTES
	SET Con_Principal				:= 1;		-- Consulta Principal

	-- 1.- Consulta Principal
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	ParamCreditPaymentID,		ProducCreditoID,		PagoCredAutom,		Exigible,		Sobrante,
				AplicaCobranzaRef
			FROM PARAMCREDITPAYMENT
			WHERE ProducCreditoID = Par_ProducCreditoID;
	END IF;

END TerminaStore$$
