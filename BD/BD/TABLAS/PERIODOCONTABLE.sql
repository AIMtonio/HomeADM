-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERIODOCONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `PERIODOCONTABLE`;DELIMITER $$

CREATE TABLE `PERIODOCONTABLE` (
  `EjercicioID` int(11) NOT NULL COMMENT 'Numero de \nEjercicio',
  `PeriodoID` int(11) NOT NULL COMMENT 'ID del \nPeriodo',
  `TipoPeriodo` char(1) DEFAULT NULL COMMENT 'Tipo de Periodo:\nmensual: M,\nbimestral: B,\ntrimestral: T',
  `Inicio` date DEFAULT NULL COMMENT 'Fecha de Inicio\ndel Periodo',
  `Fin` date DEFAULT NULL COMMENT 'Fecha de Fin\ndel Periodo',
  `FechaCierre` date DEFAULT NULL COMMENT 'Fecha en que se\nRelizo el Cierre',
  `UsuarioCierre` int(11) DEFAULT NULL COMMENT 'Usuario que \nRealiza el Cierre\nContable',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del \nPeriodo\n\nC .- Cerrado\nN.- No Cerrado',
  `PolizaFinal` bigint(12) DEFAULT '0' COMMENT 'Campo para guardar la ultima poliza',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EjercicioID`,`PeriodoID`),
  KEY `fk_PERIODOCONTABLE_1` (`EjercicioID`),
  CONSTRAINT `fk_PERIODOCONTABLE_1` FOREIGN KEY (`EjercicioID`) REFERENCES `EJERCICIOCONTABLE` (`EjercicioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Informacion de los Periodos Contables'$$