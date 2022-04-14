-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPVALIDACREDITOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPVALIDACREDITOS`;
DELIMITER $$

CREATE TABLE `TMPVALIDACREDITOS` (
  `ConsecutivoID` INT(11) AUTO_INCREMENT COMMENT 'Campo consecutivo',
  `CreditoID` BIGINT(12) NOT NULL COMMENT 'ID del credito',
  `ProductoCreditoID` INT(11) NOT NULL COMMENT 'ID producto de credito',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `fk_ConsecutivoID_1_idx` (`ConsecutivoID`)
  INDEX `IDX_AMORTCRENOMINAREAL_1`(`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de parametros para tabla real'$$