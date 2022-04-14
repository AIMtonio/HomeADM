-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFGARANTIAS
DELIMITER ;
DROP TABLE IF EXISTS `CLASIFGARANTIAS`;DELIMITER $$

CREATE TABLE `CLASIFGARANTIAS` (
  `ClasifGarantiaID` int(11) NOT NULL,
  `TipoGarantiaID` int(11) NOT NULL,
  `Descripcion` varchar(70) DEFAULT NULL,
  `EsGarantiaReal` char(1) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(45) DEFAULT NULL,
  `ProgramaID` varchar(70) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClasifGarantiaID`,`TipoGarantiaID`),
  KEY `fk_CLASIFGARANTIAS_1` (`TipoGarantiaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='catalogo de clasificación de garantias '$$