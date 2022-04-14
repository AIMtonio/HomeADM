-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURASPROVREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURASPROVREP`;DELIMITER $$

CREATE PROCEDURE `FACTURASPROVREP`(
	Par_FechaInicio		DATE,
	Par_FechaFin		DATE,
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT,
	Aud_FechaActual		DATE,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT(20)		)
TerminaStore: BEGIN
-- Declaracion de Variables --
DECLARE	Var_Sentencia	TEXT(80000);
-- Declaracion de Constantes --
DECLARE Fac_Pagada 		CHAR(1);
DECLARE Retenido  		CHAR(1);
DECLARE Gravado			CHAR(1);
-- Asignacion de Constantes --
SET Fac_Pagada 	:= 'L';
SET Retenido	:= 'R';
SET Gravado		:= 'G';

SET Var_Sentencia :=' (SELECT cef.Descripcion as CCostoCXP,fa.CenCostoManualID as CCostoOrigen,  ce.Descripcion as SucursalGasto, ';
SET Var_Sentencia :=CONCAT(Var_Sentencia,' de.CentroCostoID as CentroCostoGasto, (sum( case when im.GravaRetiene = "',Gravado,'" then ifnull(de.Importe + di.ImporteImpuesto,0.00) else 0.00 end)-');
SET Var_Sentencia :=CONCAT(Var_Sentencia,'  sum( case when im.GravaRetiene = "',Retenido,'" then ifnull(di.ImporteImpuesto,0.00) else 0.00 end)) as MontoPagado, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' fa.FechaFactura as Fecha, "Factura Proveedor" as TipoRegistro ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' from FACTURAPROV fa ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN DETALLEFACTPROV de ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' on de.NoFactura = fa.NoFactura ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' and de.ProveedorID = fa.ProveedorID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN CENTROCOSTOS ce ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' on ce.CentroCostoID = de.CentroCostoID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN CENTROCOSTOS cef ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' on cef.CentroCostoID = fa.CenCostoManualID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN DETALLEIMPFACT di on di.NoFactura = fa.NoFactura and di.ProveedorID = fa.ProveedorID');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN IMPUESTOS im on di.ImpuestoID = im.ImpuestoID');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' where fa.FechaFactura between ? and ? ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' and de.CentroCostoID <> fa.CenCostoManualID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' and fa.Estatus = "', Fac_Pagada,'"');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' GROUP BY fa.FechaFactura, fa.CenCostoManualID, de.CentroCostoID, cef.Descripcion, ce.Descripcion  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' Order by fa.FechaFactura,fa.CenCostoManualID,de.CentroCostoID) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' union all ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT cef.Descripcion as CCostoCXP,fa.CenCostoAntID as CCostoOrigen,  ce.Descripcion as SucursalGasto, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' de.CentroCostoID as CentroCostoGasto, (sum( case when im.GravaRetiene = "',Gravado,'" then ifnull(de.Importe + di.ImporteImpuesto,0.00) else 0.00 end)-');
SET Var_Sentencia :=CONCAT(Var_Sentencia,'  sum( case when im.GravaRetiene = "',Retenido,'" then ifnull(di.ImporteImpuesto,0.00) else 0.00 end)) as MontoPagado, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' fa.FechaFactura as Fecha, "Factura Proveedor" as TipoRegistro ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' from FACTURAPROV fa ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN DETALLEFACTPROV de ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' on de.NoFactura = fa.NoFactura ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' and de.ProveedorID = fa.ProveedorID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN CENTROCOSTOS ce ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' on ce.CentroCostoID = de.CentroCostoID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN CENTROCOSTOS cef ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' on cef.CentroCostoID = fa.CenCostoAntID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN DETALLEIMPFACT di on di.NoFactura = fa.NoFactura and di.ProveedorID = fa.ProveedorID');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN IMPUESTOS im on di.ImpuestoID = im.ImpuestoID');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' where fa.FechaFactura between ? and ? ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' and de.CentroCostoID <> fa.CenCostoAntID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' and fa.Estatus = "',Fac_Pagada,'" ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' GROUP BY fa.FechaFactura, fa.CenCostoAntID, de.CentroCostoID, cef.Descripcion, ce.Descripcion  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' Order by fa.FechaFactura,fa.CenCostoAntID,de.CentroCostoID) ');

SET @Sentencia		= (Var_Sentencia);
SET @FechaInicio	= Par_FechaInicio;
SET @FechaFin		= Par_FechaFin;

PREPARE STFACTURASPROVREP FROM @Sentencia;
EXECUTE STFACTURASPROVREP  USING @FechaInicio, @FechaFin,@FechaInicio, @FechaFin;
DEALLOCATE PREPARE STFACTURASPROVREP;



END TerminaStore$$