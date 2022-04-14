-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSCIERRECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSCIERRECON`;

DELIMITER $$
CREATE PROCEDURE `PARAMETROSCIERRECON`(
	-- --------------------------------------------------------------------
	-- SP QUE REALIZA LA CONSULTA DE LOS PARAMETOS DE CIERRE
	-- --------------------------------------------------------------------
	)
TerminaStore: BEGIN

	SELECT RutaResCierre,		BasesDatosCierre,		ServidorCierre,		UsuarioCierre,		ContraCierre,
			CorreoRemCierre,	CierreAutomatico,		FechaSistema,		3306
	FROM PARAMETROSSIS;

END TerminaStore$$
