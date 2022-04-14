-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXCEPCIONBATCH
DELIMITER ;
DROP TABLE IF EXISTS `EXCEPCIONBATCH`;
DELIMITER $$


CREATE TABLE `EXCEPCIONBATCH` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `ProcesoBatchID` int(11) NOT NULL COMMENT 'ID del proceso\nBatch',
  `Fecha` date NOT NULL COMMENT 'Fecha',
  `Instrumento` varchar(45) NOT NULL COMMENT 'Instrumento\n',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'EmpresaID',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_EXCEPCIONBATCH_1` (`ProcesoBatchID`),
  CONSTRAINT `fk_EXCEPCIONBATCH_1` FOREIGN KEY (`ProcesoBatchID`) REFERENCES `PROCESOSBATCH` (`ProcesoBatchID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bitacora de las Expeciones Registradas durantes los Cierres'$$
