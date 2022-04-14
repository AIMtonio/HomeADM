-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMCOBRANZAREFERCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMCOBRANZAREFERCON`;
DELIMITER $$

CREATE PROCEDURE `PARAMCOBRANZAREFERCON`(
	-- SP PARA CONSULTAR LA TABLA PARAMCOBRANZAREFER DE LAS PARAMETRIZACIONES DE COBRANZA REFERENCIADA
	Par_ConsecutivoID			INT(11),		-- ID Consecutivo de la tabla PARAMDEPREFER (PK)
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
		SELECT ParamCobranzaReferID,		ConsecutivoID,		AplicaCobranzaRef,		ProducCreditoID
			FROM PARAMCOBRANZAREFER
			WHERE ConsecutivoID = Par_ConsecutivoID
			AND ProducCreditoID = Par_ProducCreditoID;
	END IF;

END TerminaStore$$
