-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDITOFOGAFIGRUPO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDITOFOGAFIGRUPO`;DELIMITER $$

CREATE TABLE `TMPCREDITOFOGAFIGRUPO` (
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Indica el Número de Transacción',
  `AmortizacionID` int(11) NOT NULL COMMENT 'Credito',
  `MontoExigible` decimal(14,2) DEFAULT NULL COMMENT 'Monto Exigible',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `IDX_TMPCREDITOPAGOGRUPO_1` (`NumTransaccion`),
  KEY `IDX_TMPCREDITOPAGOGRUPO_2` (`NumTransaccion`,`AmortizacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal para almacenar el exigible de Garantia FOGAFI requerido por amortizacion de todo el grupo.'$$