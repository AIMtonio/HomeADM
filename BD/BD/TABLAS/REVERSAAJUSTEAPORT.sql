-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSAAJUSTEAPORT
DELIMITER ;
DROP TABLE IF EXISTS `REVERSAAJUSTEAPORT`;DELIMITER $$

CREATE TABLE `REVERSAAJUSTEAPORT` (
  `AportMejora` int(11) DEFAULT NULL COMMENT 'Aportacion que hace la Mejora.',
  `AportMejorada` int(11) DEFAULT NULL COMMENT 'Aportacion que se Mejora con el Anclaje.',
  `Tasa` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Original de la Aportacion Mejorada.',
  `TasaNeta` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Neta Original de la Aportacion Mejorada.',
  `TasaBase` int(11) DEFAULT NULL COMMENT 'Tasa Base Original de la Aportacion Mejorada. ',
  `SobreTasa` decimal(12,4) DEFAULT NULL COMMENT 'Sobre Tasa Original de la Aportacion Mejorada.',
  `PisoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Piso Tasa Original de la Aportacion Mejorada.',
  `TechoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Techo Tasa Original de la Aportacion Mejorada.',
  `CalculoInteres` int(2) DEFAULT NULL COMMENT 'Calculo Interes Original de la Aportacion Mejorada.',
  `ValorGat` decimal(12,2) DEFAULT NULL COMMENT 'Valor del Gat Original de la Aportacion Mejorada.',
  `ValorGatReal` decimal(12,2) DEFAULT NULL COMMENT 'Valor del Gat Real Original de la Aportacion Mejorada.',
  `InteresGenerado` decimal(18,2) DEFAULT NULL COMMENT 'Interes Generado Original de la Aportacion Mejorada.',
  `InteresRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Interes Recibir Original de la Aportacion Mejorada.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro Auditoria EmpresaID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria DireccionIP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria NumTransaccion',
  KEY `AportMejora` (`AportMejora`),
  KEY `AportMejorada` (`AportMejorada`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Reversas de Anclajes en Aportaciones.'$$