-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-POLIZACONTA
DELIMITER ;
DROP TABLE IF EXISTS `HIS-POLIZACONTA`;DELIMITER $$

CREATE TABLE `HIS-POLIZACONTA` (
  `PolizaID` bigint(20) NOT NULL COMMENT 'Numero de Poliza',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Fecha` date NOT NULL COMMENT 'Fecha de la \nAfectacion',
  `Tipo` char(1) NOT NULL COMMENT 'Tipo de Poliza:\nManual\nAutomatica\nProgramada',
  `ConceptoID` int(11) DEFAULT NULL COMMENT 'Corresponde a algun ID de la tabla CONCEPTOSCONTA',
  `Concepto` varchar(150) NOT NULL COMMENT 'Concepto o \nDescripcion de la\nPoliza',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PolizaID`),
  KEY `POLIZA_FECHA` (`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='HISTORIAL DE Poliza Contable '$$