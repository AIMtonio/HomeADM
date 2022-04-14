-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSPLANAHORROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSPLANAHORROCON`;DELIMITER $$

CREATE PROCEDURE `FOLIOSPLANAHORROCON`(
-- ========================================================
-- SP PARA REALIZAR LAS CONSULTAS DE LOS FOLIOS DEL CLIENTE
-- ========================================================
	Par_ClienteID 	INT(11),
	Par_CuentaID	INT(11),
	Par_PlanID		INT(11),
	Par_NumCon		INT(11),

	/* Parametros de Auditoria */
	Aud_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
  	Aud_FechaActual 		DATETIME,
  	Aud_DireccionIP 		VARCHAR(15),
  	Aud_ProgramaID 			VARCHAR(50),
  	Aud_Sucursal 			INT(11),
  	Aud_NumTransaccion 		BIGINT(20)
)
TerminaStore:BEGIN

	/*Declaracion de Constantes*/
	DECLARE ConPrinciapl 	INT(11);
    DECLARE ConImpTicket	INT(11);

	/*Asignacion de constantes*/
	SET ConPrinciapl	:= 1;
    SET ConImpTicket	:= 2;

	IF(Par_NumCon=ConPrinciapl)THEN
		SELECT 	Cli.ClienteID, 							MAX(Cli.NombreCompleto) AS NombreCompleto,
				MAX(Cue.CuentaAhoID) AS CuentaAhoID,	MAX(Cue.Etiqueta) AS Etiqueta,
                MAX(Tp.PlanID) AS PlanID,				MAX(Tp.Nombre) AS Nombre,
                MAX(Tp.DepositoBase) AS DepositoBase,	MAX(Tp.FechaLiberacion) AS FechaLiberacion,
                SUM(Fol.Monto) AS SaldoActual
		FROM FOLIOSPLANAHORRO Fol
			INNER JOIN TIPOSPLANAHORRO Tp
				ON	Fol.PlanID=Tp.PlanID AND Fol.PlanID=Par_PlanID
			INNER JOIN CUENTASAHO Cue
				ON	Fol.CuentaAhoID=Cue.CuentaAhoID AND Fol.CuentaAhoID=Par_CuentaID
			INNER JOIN CLIENTES Cli
				ON Fol.ClienteID = Cli.ClienteID
		WHERE Fol.PlanID=Par_PlanID
		AND Fol.CuentaAhoID=Par_CuentaID
		GROUP BY Cli.ClienteID;
	ELSEIF(Par_NumCon = ConImpTicket)THEN
		SELECT 	Cli.ClienteID, 							MAX(Cli.NombreCompleto) AS NombreCompleto,
			MAX(Fol.Fecha) AS Fecha,					MAX(Fol.NumTransaccion) AS NumTransaccion,
            MAX(Tp.Nombre) AS NombrePlan,				MAX(Tp.FechaLiberacion) AS FechaLiberacion,
            MAX(Tp.LeyendaTicket) AS LeyendaTicket,		GROUP_CONCAT(CONCAT(Tp.Prefijo,"-",Fol.Serie)) AS Folios
		FROM FOLIOSPLANAHORRO Fol
			INNER JOIN TIPOSPLANAHORRO Tp
				ON	Fol.PlanID=Tp.PlanID AND Fol.PlanID=Par_PlanID
			INNER JOIN CLIENTES Cli
				ON Fol.ClienteID = Cli.ClienteID
		WHERE Fol.PlanID=Par_PlanID
        AND Fol.NumTransaccion=Aud_NumTransaccion
		GROUP BY Cli.ClienteID;
    END IF;

END TerminaStore$$