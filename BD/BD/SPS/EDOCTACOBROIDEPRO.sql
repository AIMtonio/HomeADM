-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACOBROIDEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTACOBROIDEPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTACOBROIDEPRO`(

    Par_AnioMes     INT(11)
)
TerminaStore: BEGIN


DECLARE	Con_Cadena_Vacia	VARCHAR(1);
DECLARE	Con_Fecha_Vacia		DATE;
DECLARE	Con_Entero_Cero		INT(11);
DECLARE	Con_Moneda_Cero		DECIMAL(14,2);


SET Con_Cadena_Vacia			= '';
SET Con_Fecha_Vacia			= '1900-01-01';
SET Con_Entero_Cero			= 0;
SET Con_Moneda_Cero			= 0.00;

SET SQL_SAFE_UPDATES=0;


INSERT INTO EDOCTACOBROIDE
SELECT  Par_AnioMes,		Con_Entero_Cero,		ClienteID, 		MAX(PeriodoID),			Con_Moneda_Cero,
        Con_Moneda_Cero,	Con_Moneda_Cero,		Con_Moneda_Cero
FROM COBROIDEMENS
GROUP BY ClienteID;


UPDATE EDOCTACOBROIDE Edo, COBROIDEMENS Ide
SET Edo.Cantidad = Ide.Cantidad,
    Edo.MontoIDE = Ide.MontoIDE,
    Edo.CantidadCob = Ide.CantidadCob,
    Edo.CantidadPen = Ide.CantidadPen
WHERE Edo.ClienteID = Ide.ClienteID
  AND Edo.PeriodoID = Ide.PeriodoID;

DELETE FROM EDOCTACOBROIDE WHERE CantidadPen = Con_Moneda_Cero;

UPDATE EDOCTACOBROIDE Edo, CLIENTES Cli
SET Edo.SucursalID = Cli.SucursalOrigen
WHERE Edo.ClienteID = Cli.ClienteID;


END TerminaStore$$