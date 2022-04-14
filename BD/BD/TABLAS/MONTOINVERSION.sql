-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOINVERSION
DELIMITER ;
DROP TABLE IF EXISTS `MONTOINVERSION`;DELIMITER $$

CREATE TABLE `MONTOINVERSION` (
  `MontoInversionID` int(11) NOT NULL,
  `TipoInversionID` int(11) NOT NULL,
  `PlazoInferior` decimal(12,2) DEFAULT NULL,
  `PlazoSuperior` decimal(12,2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MontoInversionID`),
  KEY `FK_TIPOINVERSION1` (`TipoInversionID`),
  CONSTRAINT `FK_TIPOINVERSION1` FOREIGN KEY (`TipoInversionID`) REFERENCES `CATINVERSION` (`TipoInversionID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo  de los dias de inversion'$$