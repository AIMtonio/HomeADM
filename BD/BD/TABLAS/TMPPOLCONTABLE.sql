-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPOLCONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `TMPPOLCONTABLE`;DELIMITER $$

CREATE TABLE `TMPPOLCONTABLE` (
  `PolizaID` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Numero de Poliza',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de la \nAfectacion',
  `Tipo` char(1) DEFAULT NULL COMMENT 'Tipo de Poliza:\nManual\nAutomatica\nProgramada',
  `ConceptoID` int(11) DEFAULT NULL COMMENT 'Corresponde a algun ID de la tabla CONCEPTOSCONTA',
  `Concepto` varchar(150) DEFAULT NULL COMMENT 'Concepto o \nDescripcion de la\nPoliza',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PolizaID`),
  KEY `POLIZA_FECHA` (`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Poliza Contable'$$