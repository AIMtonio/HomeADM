-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASINVERSION
DELIMITER ;
DROP TABLE IF EXISTS `DIASINVERSION`;DELIMITER $$

CREATE TABLE `DIASINVERSION` (
  `DiaInversionID` int(11) NOT NULL,
  `TipoInversionID` int(11) NOT NULL,
  `PlazoInferior` int(11) NOT NULL,
  `PlazoSuperior` int(11) NOT NULL,
  `EmpresaID` varchar(45) DEFAULT NULL,
  `Usuario` varchar(45) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(15) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DiaInversionID`),
  KEY `FK_TIPOINVERSION` (`TipoInversionID`),
  CONSTRAINT `FK_TIPOINVERSION` FOREIGN KEY (`TipoInversionID`) REFERENCES `CATINVERSION` (`TipoInversionID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de los rangos de dias de inversion'$$