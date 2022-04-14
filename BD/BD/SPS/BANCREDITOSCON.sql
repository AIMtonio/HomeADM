DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCREDITOSCON`;
DELIMITER $$
CREATE PROCEDURE `BANCREDITOSCON`(
-- --------------------------------------------------------------------
-- SP DE CONSULTA DE LOS CREDITOS
-- --------------------------------------------------------------------
	Par_CreditoID		BIGINT(12),			-- Numero de Credito
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	CALL CREDITOSCON(	Par_CreditoID,		Par_NumCon,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

END TerminaStore$$