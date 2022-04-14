-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMINV
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTARESUMINV`;DELIMITER $$

CREATE TABLE `EDOCTARESUMINV` (
  `AnioMes` int(11) NOT NULL,
  `SucursalID` int(11) NOT NULL,
  `ClienteID` int(11) NOT NULL,
  `InversionID` int(11) NOT NULL,
  `FechaInicio` date DEFAULT NULL,
  `FechaVence` date DEFAULT NULL,
  `Etiqueta` varchar(100) DEFAULT NULL,
  `Capital` decimal(14,2) DEFAULT NULL,
  `Tasa` decimal(14,2) DEFAULT NULL,
  `Plazo` int(11) DEFAULT NULL,
  `Interes` decimal(14,2) DEFAULT NULL,
  `ISR` decimal(14,2) DEFAULT NULL,
  `InteresNeto` decimal(14,2) DEFAULT NULL,
  `Descripcion` varchar(45) DEFAULT NULL COMMENT 'Nombre del producto',
  `GatInformativo` decimal(12,2) DEFAULT NULL COMMENT 'Gat Informativo',
  `Estatus` char(1) DEFAULT NULL COMMENT ' ''A''.- Alta (no autorizada)\n ''N''.- Vigente (cargada a cuenta)\n ''P''.- Pagada (abonada a cuenta)\n ''C''.- Cancelada\n ''V''.- Vencida',
  `EstatusDescri` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`AnioMes`,`SucursalID`,`ClienteID`,`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Resumen  de las inversiones del Cliente'$$