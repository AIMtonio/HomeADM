-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREPAGNOMINA
DELIMITER ;
DROP TABLE IF EXISTS `AMORTICREPAGNOMINA`;
DELIMITER $$

CREATE TABLE `AMORTICREPAGNOMINA` (
  `ConsecutivoID` INT(11) NOT NULL COMMENT 'ID del registro de la tabla',
  `CreditoID` BIGINT(15) NOT NULL COMMENT 'ID del credito',
  `AmortizacionID` INT(11) NOT NULL COMMENT 'ID de lac amortizacion',
  `MontoAmorti` DECIMAL(18,2) NOT NULL COMMENT 'monto del pago de la Amortizacion',
  `MontoPorAplicar` DECIMAL(18,2) DEFAULT 0.0 COMMENT 'Monto aplicado para la Amortizacion',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY ` INDEX_AMORTICREPAGNOMINA_1` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Amortizaciones que se van a afectar para el Pago de Inst.'$$