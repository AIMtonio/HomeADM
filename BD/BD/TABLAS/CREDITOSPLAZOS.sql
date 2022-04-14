-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSPLAZOS
DELIMITER ;
DROP TABLE IF EXISTS `CREDITOSPLAZOS`;DELIMITER $$

CREATE TABLE `CREDITOSPLAZOS` (
  `PlazoID` varchar(20) NOT NULL COMMENT 'Num consecutivo',
  `Dias` int(11) NOT NULL COMMENT 'Numero de dias',
  `Frecuencia` char(1) DEFAULT NULL COMMENT 'S .- Semanal,\r\nC .- Catorcenal\r\nQ .- Quincenal\r\nM .- Mensual\r\nB.-Bimestral \r\nT.-Trimestral \r\nR.-TetraMestral\r\nE.-Semestral \r\nA.-Anual',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PlazoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Plazos de Credito'$$