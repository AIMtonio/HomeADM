-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-TASASBASE
DELIMITER ;
DROP TABLE IF EXISTS `HIS-TASASBASE`;
DELIMITER $$


CREATE TABLE `HIS-TASASBASE` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fecha` datetime NOT NULL,
  `TasaBaseID` int(11) NOT NULL COMMENT 'ID de la tabla base',
  `Valor` decimal(12,4) DEFAULT NULL COMMENT 'Valor de la Tasa',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_HIS-TASASBASE_1` (`TasaBaseID`),
  CONSTRAINT `fk_HIS-TASASBASE_1` FOREIGN KEY (`TasaBaseID`) REFERENCES `TASASBASE` (`TasaBaseID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico de Tasas Base\n'$$
