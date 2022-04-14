-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPRESPUESTAORDPAGO
DELIMITER ;
DROP TABLE IF EXISTS `DISPRESPUESTAORDPAGO`;
DELIMITER $$

CREATE TABLE `DISPRESPUESTAORDPAGO` (
  `NombreArchivo`     VARCHAR(100) DEFAULT '' COMMENT 'Nombre del archivo', 
  `ContVencido`			  INT(11) DEFAULT '0' COMMENT 'Contador de estatus Vencido',
  `ContCancelado`		  INT(11) DEFAULT '0' COMMENT 'Contador de estatus Cancelado',
  `ContLiquidado`		  INT(11) DEFAULT '0' COMMENT 'Contador de estatus Liquidado',
  `ContPendiente`		  INT(11) DEFAULT '0' COMMENT 'Contador de estatus Pendiente de Cobro',
  `EmpresaID` 			  INT(11) DEFAULT '0' COMMENT 'Empresa',
  `Usuario` 			    INT(11) DEFAULT '1',
  `FechaActual` 		  DATETIME DEFAULT '1900-01-01',
  `DireccionIP` 		  VARCHAR(15) DEFAULT '',
  `ProgramaID` 			  VARCHAR(50) DEFAULT '',
  `Sucursal` 			    INT(11) DEFAULT '0',
  `NumTransaccion` 		BIGINT(20) DEFAULT '0',
  INDEX (NombreArchivo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla que contiene el control de las dispersiones procesadas de Ordene de Pagos'$$

