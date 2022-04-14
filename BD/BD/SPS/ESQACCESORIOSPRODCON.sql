-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQACCESORIOSPRODCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQACCESORIOSPRODCON`;
DELIMITER $$


CREATE PROCEDURE `ESQACCESORIOSPRODCON`(
-- =====================================================================================
-- ----- SP QUE CONSULTA LOS ACCESORIOS COBRADOS POR PRODUCTO DE CREDITO --------
-- =====================================================================================
	Par_ProducCreditoID 		INT(11), 	-- ID del Producto de Crédito
	Par_AcesorioID 				INT(11), 	-- ID del Accesorio
    Par_InstitNominaID			INT(11),	-- ID de la Institucion de Nomina
	Par_TipoConsulta			INT(11), 	-- Tipo de Consulta

	# Parametros de Auditoria
	Aud_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
  	Aud_FechaActual 		DATETIME,
  	Aud_DireccionIP 		VARCHAR(15),
  	Aud_ProgramaID 			VARCHAR(50),
  	Aud_Sucursal 			INT(11),
  	Aud_NumTransaccion 		BIGINT(20)
)

TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Con_Principal	INT(11); 	-- Constante Consulta Principal : 1

	-- Asignacion de Constantes
	SET Con_Principal 	:= 1; 			-- Constante Consulta Principal

	IF(Par_TipoConsulta=Con_Principal)THEN
		SELECT
			ProductoCreditoID, 		AccesorioID, 	InstitNominaID,     CobraIVA,		GeneraInteres,
			CobraIVAInteres, 		TipoFormaCobro, TipoPago, 			BaseCalculo
		FROM ESQUEMAACCESORIOSPROD
		WHERE ProductoCreditoID = Par_ProducCreditoID
		AND AccesorioID = Par_AcesorioID
        AND InstitNominaID = Par_InstitNominaID;
	END IF;

END TerminaStore$$
