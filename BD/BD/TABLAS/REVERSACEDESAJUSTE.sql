-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSACEDESAJUSTE
DELIMITER ;
DROP TABLE IF EXISTS `REVERSACEDESAJUSTE`;DELIMITER $$

CREATE TABLE `REVERSACEDESAJUSTE` (
  `CedeMejora` int(11) DEFAULT NULL COMMENT 'Cede que hace la Mejora.',
  `CedeMejorada` int(11) DEFAULT NULL COMMENT 'Cede que se Mejora con el Anclaje.',
  `Tasa` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Original de la Cede Mejorada.',
  `TasaNeta` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Neta Original de la Cede Mejorada.',
  `TasaBase` int(11) DEFAULT NULL COMMENT 'Tasa Base Original de la Cede Mejorada. ',
  `SobreTasa` decimal(12,4) DEFAULT NULL COMMENT 'Sobre Tasa Original de la Cede Mejorada.',
  `PisoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Piso Tasa Original de la Cede Mejorada.',
  `TechoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Techo Tasa Original de la Cede Mejorada.',
  `CalculoInteres` int(2) DEFAULT NULL COMMENT 'Calculo Interes Original de la Cede Mejorada.',
  `ValorGat` decimal(12,2) DEFAULT NULL COMMENT 'Valor del Gat Original de la Cede Mejorada.',
  `ValorGatReal` decimal(12,2) DEFAULT NULL COMMENT 'Valor del Gat Real Original de la Cede Mejorada.',
  `InteresGenerado` decimal(18,2) DEFAULT NULL COMMENT 'Interes Generado Original de la Cede Mejorada.',
  `InteresRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Interes Recibir Original de la Cede Mejorada.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro Auditoria EmpresaID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria DireccionIP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria NumTransaccion',
  KEY `CedeMejora` (`CedeMejora`),
  KEY `CedeMejorada` (`CedeMejorada`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para Reversas de Anclajes.'$$