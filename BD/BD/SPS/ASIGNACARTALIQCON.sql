-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNACARTALIQCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNACARTALIQCON`;
DELIMITER $$

CREATE PROCEDURE `ASIGNACARTALIQCON`(
	/* SP DE CONSULTA DE ASIGACION DE CARTAS DE LIQUIDACION */
    Par_SolicitudCreditoID 	INT(11),            -- Solicitud de Credito ID
    Par_TipConsulta     	TINYINT UNSIGNED,   -- Tipo de Consulta

    Par_EmpresaID	    	INT(11),			-- Parametros de Auditoria
    Aud_Usuario	       		INT(11),            -- Parametros de Auditoria
    Aud_FechaActual			DATETIME ,          -- Parametros de Auditoria
    Aud_DireccionIP			VARCHAR(15),        -- Parametros de Auditoria
    Aud_ProgramaID	    	VARCHAR(70),        -- Parametros de Auditoria
    Aud_Sucursal	    	INT(11),            -- Parametros de Auditoria
    Aud_NumTransaccion		BIGINT(20)          -- Parametros de Auditoria
)
TerminaStore: BEGIN

	/* Declaracion de Variables */

	/* Declaracion de Constantes */
	DECLARE Entero_Cero     	INT(11);
	DECLARE Decimal_Cero    	INT(11);
	DECLARE Con_Principal   	TINYINT UNSIGNED;


	/* Asignacion de Constantes */
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero    	:= 0.00;
    SET Con_Principal   	:= 1;      -- Consulta Principal


	IF(Par_TipConsulta = Con_Principal) THEN
        SELECT CasaComercialID,     Monto,      FechaVigencia
        FROM ASIGCARTASLIQUIDACION
        WHERE SolicitudCreditoID = Par_SolicitudCreditoID
        ORDER BY AsignacionCartaID ASC ;
		
	END IF;

	
END TerminaStore$$