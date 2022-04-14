-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBAMORTICREDITOWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBAMORTICREDITOWSLIS`;DELIMITER $$

CREATE PROCEDURE `CRCBAMORTICREDITOWSLIS`(
	/*SP para listar las amortizaciones de credito para WS Crediclub*/
	Par_CreditoID			BIGINT(12),
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

    -- Constantes
    DECLARE Con_Amortizaciones  INT;

    SET 	Con_Amortizaciones := 4;

    CALL `AMORTICREDITOLIS`(Par_CreditoID,		Con_Amortizaciones,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);



END TerminaStore$$