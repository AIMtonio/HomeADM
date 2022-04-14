-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMORTIFOGAFIGRUPO
DELIMITER ;
DROP TABLE IF EXISTS `TMPAMORTIFOGAFIGRUPO`;DELIMITER $$

CREATE TABLE `TMPAMORTIFOGAFIGRUPO` (
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del Credito',
  `AmortizacionID` int(4) NOT NULL COMMENT 'Numero de Amortizacion',
  `MontoExigible` decimal(14,2) DEFAULT NULL COMMENT 'Monto Exigible de Garantia',
  `MontoAplicar` decimal(14,2) DEFAULT NULL COMMENT 'Monto a Aplicar de Garantia',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `TMPAMORTIFOGAFIGRUPO_1` (`NumTransaccion`),
  KEY `TMPAMORTIFOGAFIGRUPO_2` (`NumTransaccion`,`CreditoID`,`AmortizacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal para almacenar el exigible de Garantia FOGAFI requerido por amortizacion de cada credito.'$$