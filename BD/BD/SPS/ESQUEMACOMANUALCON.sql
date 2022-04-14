-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMANUALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACOMANUALCON`;DELIMITER $$

CREATE PROCEDURE `ESQUEMACOMANUALCON`(
	/*SP PARA LA CONSULTA DE LOS ESQUEMAS DE COBRO DE COMISION ANUAL DE LOS CREDITOS*/
	Par_ProducCreditoID		INT(11),			-- Id del producto de credito
	Par_TipoConsulta		TINYINT,			-- Numero de consulta
	/* Parametros de Auditoria */
	Aud_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Consulta_Principal		INT(11);		-- Consulta principal

	-- Asignacion de constantes
	SET Consulta_Principal			:= 1;

	/**
	Consulta 1: Consulta Principal
	**/
	IF(Par_TipoConsulta = Consulta_Principal) THEN
		SELECT
			ProducCreditoID,	CobraComision,		TipoComision,	BaseCalculo,	MontoComision,
			PorcentajeComision,	DiasGracia
		FROM ESQUEMACOMANUAL
			WHERE ProducCreditoID = Par_ProducCreditoID;
	END IF;

END TerminaStore$$