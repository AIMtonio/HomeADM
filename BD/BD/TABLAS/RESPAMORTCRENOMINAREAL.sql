-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESPAMORTCRENOMINAREAL
DELIMITER ;
DROP TABLE IF EXISTS `RESPAMORTCRENOMINAREAL`;
DELIMITER $$

CREATE TABLE `RESPAMORTCRENOMINAREAL` (
  `RegistroID` BIGINT UNSIGNED AUTO_INCREMENT,
  `TranRespaldo` BIGINT(20) NOT NULL COMMENT 'No de Transaccion Respaldo',
  `FolioNominaID` INT(11) NOT NULL COMMENT 'ID del registro de la tabla',
  `FolioProceso` INT(11) NOT NULL COMMENT 'ID del Folio en el que se realizo la Carga',
  `CreditoID` BIGINT(15) NOT NULL COMMENT 'ID del credito',
  `AmortizacionID` INT(11) NOT NULL COMMENT 'ID de lac amortizacion',
  `FechaVencimiento` DATE DEFAULT '1900-01-01' COMMENT 'Fecha en que vence la cuota',
  `FechaExigible` DATE DEFAULT '1900-01-01' COMMENT 'Fecha en que en que se genera exigible de la cuota',
  `FechaPagoIns` DATE DEFAULT '1900-01-01' COMMENT 'Fecha de pago en la institucion',
  `Estatus` CHAR(1) DEFAULT 'A' COMMENT 'Estatus del registro A:Activo/P:Pagado',
  `EstatusPagoBan` CHAR(1) DEFAULT 'V' COMMENT 'Estatus de pago del banco V:Vigente/A:Aplicado',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`RegistroID`),
  KEY `INDEX_RESPNOMINAREAL_1` (`TranRespaldo`),
  KEY `INDEX_RESPNOMINAREAL_2` (`FolioNominaID`),
  KEY `INDEX_RESPNOMINAREAL_3` (`FolioProceso`),
  KEY `INDEX_RESPNOMINAREAL_4` (`CreditoID`),
  KEY `INDEX_RESPNOMINAREAL_5` (`AmortizacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Respaldo de la Tabla Real de Pagos de Creditos de Nomina'$$