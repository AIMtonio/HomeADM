-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSPENDIENTESNOM
DELIMITER ;
DROP TABLE IF EXISTS `FOLIOSPENDIENTESNOM`;
DELIMITER $$

CREATE TABLE `FOLIOSPENDIENTESNOM` (
  `Folio` INT(11) NOT NULL COMMENT 'ID del registro de la tabla',
  `FolioNominaID` int(11) NOT NULL COMMENT 'Folio consecutivo de la Carga del Archivo de pagos de Nomina',
  `FolioCargaID` INT(11) NOT NULL COMMENT 'ID del folio de carga del archivo de descuento',
  `CreditoID` BIGINT(15) NOT NULL COMMENT 'ID del credito',
  `MontoPago` DECIMAL(18,2) NOT NULL COMMENT 'monto del pago',
  `MontoAplicado` DECIMAL(18,2) DEFAULT 0.0 COMMENT 'Monto aplicado del pago',
  `MontoPendiente` DECIMAL(18,2) DEFAULT 0.0 COMMENT 'Monto Pendiente por Aplicar',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`Folio`),
  KEY `INDEX_FOLIOSPENDIENTESNOM_1` (`CreditoID`),
  KEY `INDEX_FOLIOSPENDIENTESNOM_2` (`FolioCargaID`),
  KEY `INDEX_FOLIOSPENDIENTESNOM_3` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para guardar los folios con saldo pendiente por aplicar de pagos de instituciones de nomina'$$