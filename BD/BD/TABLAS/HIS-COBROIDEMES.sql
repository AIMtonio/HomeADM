-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-COBROIDEMES
DELIMITER ;
DROP TABLE IF EXISTS `HIS-COBROIDEMES`;DELIMITER $$

CREATE TABLE `HIS-COBROIDEMES` (
  `ClienteID` int(11) NOT NULL,
  `PeriodoID` int(11) DEFAULT NULL,
  `Cantidad` decimal(12,2) DEFAULT NULL,
  `MontoIDE` decimal(12,2) DEFAULT NULL,
  `CantidadCob` decimal(12,2) DEFAULT NULL COMMENT 'Cantidad Cobrada',
  `CantidadPen` decimal(12,2) DEFAULT NULL COMMENT 'Cantidad Pendiente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `index1` (`ClienteID`),
  KEY `index2` (`PeriodoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='historico de COBROIDEMENS'$$