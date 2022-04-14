-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDIASSINPAGOBAN
DELIMITER ;
DROP TABLE IF EXISTS `TMPDIASSINPAGOBAN`;
DELIMITER $$

CREATE TABLE `TMPDIASSINPAGOBAN` (
  `CreditoID` BIGINT(15) NOT NULL COMMENT 'ID del credito',
  `FechaVencimiento` DATE DEFAULT '1900-01-01' COMMENT 'Fecha en que vence la cuota',
  `DiasSinPago` INT(11) DEFAULT '0' COMMENT 'Dias sin pago en bancos',
  `DiasMaximo` INT(11) DEFAULT '0' COMMENT 'Dias maximos sin pago en bancos',
  `InstitNominaID` INT(11) DEFAULT '0' COMMENT 'Institucion de Nomina',
  `ProductoCreditoID` INT(11) DEFAULT '0' COMMENT 'Producto credito',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`CreditoID`),
  KEY `IDX_TMPDIASSINPAGOBAN_1` (`InstitNominaID`,`ProductoCreditoID`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1 COMMENT='Tab: Temporal que indica a que creditos crearle su tabla real';
