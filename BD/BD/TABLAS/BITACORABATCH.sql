-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORABATCH
DELIMITER ;
DROP TABLE IF EXISTS `BITACORABATCH`;DELIMITER $$

CREATE TABLE `BITACORABATCH` (
  `ProcesoBatchID` int(11) NOT NULL COMMENT 'ID del Proceso\nBatch',
  `Fecha` date NOT NULL COMMENT 'Fecha del Proceso',
  `Tiempo` int(11) NOT NULL COMMENT 'Tiempo en\nMinutos que tomo\nel Proceso',
  `Orden` int(11) DEFAULT '0' COMMENT 'Indica el numero de orden en que se ejecuto el proceso en el cierre',
  `Empresa` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProcesoBatchID`,`Fecha`),
  KEY `fk_BITACORABASH_1` (`ProcesoBatchID`),
  CONSTRAINT `fk_BITACORABASH_1` FOREIGN KEY (`ProcesoBatchID`) REFERENCES `PROCESOSBATCH` (`ProcesoBatchID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bitacora de los Procesos Batch'$$