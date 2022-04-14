-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMINV024PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMINV024PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTARESUMINV024PRO`(
	Par_AnioMes				INT(11),		-- Año mes
	Par_SucursalID			INT(11),		-- Identificador de la sucursal
	Par_FecIniMes			DATE,			-- Fecha inicio del mes
	Par_FecFinMes			DATE			-- Fecha fin del mes
)

TerminaStore: BEGIN
-- Declaracion de Constantes

DECLARE	Con_Cadena_Vacia	VARCHAR(1); 	-- Cadena Vacia
DECLARE	Con_Fecha_Vacia		DATE;			-- Fecha Vacia
DECLARE	Con_Entero_Cero		INT(11);		-- Entero Cero
DECLARE	Con_Moneda_Cero		DECIMAL(14,2);	-- Moneda Cero
DECLARE Con_StaVigente		CHAR(1);        -- Estado Vigente
DECLARE Con_StaVencido		CHAR(1);		-- Estado Vencido
DECLARE Con_StaPagado		CHAR(1);		-- Estado Pagado
DECLARE Con_StaCancelado	CHAR(1);		-- Estado Cancelado
DECLARE Var_SalidaSI		CHAR(1);		-- Salida si

-- Asignacion de Constantes
SET Con_Cadena_Vacia		= '';			-- Cadena Vacia
SET Con_Fecha_Vacia			= '1900-01-01';	-- Fecha Vacia
SET Con_Entero_Cero			= 0;			-- Entero Cero
SET Con_Moneda_Cero			= 0.00;			-- Moneda Cero
SET Con_StaVigente			= 'N';			-- Estado Vigente
SET Con_StaVencido			= 'V';			-- Estado Vencido
SET Con_StaPagado			= 'P';			-- Estado Pagado
SET Con_StaCancelado		= 'C';			-- Estado Cancelado
SET SQL_SAFE_UPDATES		= 0;
SET Var_SalidaSI			= 'S';			-- Salida si

INSERT INTO EDOCTARESUM024INV
SELECT  Par_AnioMes,
		Con_Entero_Cero,
		Inv.ClienteID,
		Inv.InversionID,
		Inv.FechaInicio,
		Inv.FechaVencimiento,
		Inv.FechaVenAnt,
		IFNULL(Inv.Etiqueta, 'Sin Etiqueta Definida'),
		Inv.Monto,
		Inv.Tasa,
		Inv.Plazo,
		Inv.InteresGenerado,
		Inv.InteresRetener,
		Inv.InteresRecibir,
		Cat.Descripcion,
		IFNULL(Inv.GatInformativo, Con_Moneda_Cero),
		IFNULL(Inv.ValorGatReal, Con_Moneda_Cero),
		IFNULL(Inv.ValorGat, Con_Moneda_Cero),
		Inv.Estatus,

		CASE Inv.Estatus WHEN Con_StaVigente THEN 'VIGENTE'
						 WHEN Con_StaVencido THEN 'VENCIDA'
						 WHEN Con_StaPagado THEN 'PAGADA'
						 WHEN Con_StaCancelado THEN 'CANCELADA'
									 ELSE 'Estatus No Identificado'
		END,
		Con_Entero_Cero,
		Con_Entero_Cero,
		Con_Fecha_Vacia,
		Con_Cadena_Vacia,
		Con_Cadena_Vacia,
		Con_Entero_Cero,
		Con_Entero_Cero

FROM INVERSIONES Inv
INNER JOIN CATINVERSION Cat ON Inv.TipoInversionID = Cat.TipoInversionID
WHERE Inv.Estatus = Con_StaVigente
   OR (Inv.Estatus = Con_StaPagado AND Inv.FechaVencimiento >= Par_FecIniMes)
   OR (Inv.Estatus = Con_StaCancelado AND Inv.FechaVenAnt >= Par_FecIniMes)
ORDER BY Inv.ClienteID, Inv.InversionID;

UPDATE EDOCTARESUM024INV Edo, CLIENTES Cli
	SET Edo.SucursalID = Cli.SucursalOrigen
WHERE Edo.ClienteID = Cli.ClienteID;

UPDATE EDOCTADATOSCTECOM Cte, EDOCTARESUM024INV Edo
	SET Cte.EsSuperTasas = Var_SalidaSI
	WHERE Cte.ClienteID = Edo.ClienteID
	  AND Edo.Descripcion LIKE '%SUPER TASAS%';

END TerminaStore$$
