-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESCNOMINAREAL
DELIMITER ;
DROP TABLE IF EXISTS `DESCNOMINAREAL`;
DELIMITER $$

CREATE TABLE `DESCNOMINAREAL` (
  `FolioNominaID` INT(11) NOT NULL COMMENT 'ID del registro de la tabla',
  `FolioCargaID` INT(11) NOT NULL COMMENT 'ID del folio de carga del archivo de descuento',
  `EmpresaNominaID` INT(11) NOT NULL COMMENT 'ID de la institucion de nomina',
  `FechaCarga` DATE DEFAULT NULL COMMENT 'Fecha en que se carga el archivo',
  `CreditoID` BIGINT(15) NOT NULL COMMENT 'ID del credito',
  `AmortizacionID` INT(11) NOT NULL COMMENT 'ID de lac amortizacion',
  `MontoPago` DECIMAL(18,2) NOT NULL COMMENT 'monto del pago',
  `Estatus` CHAR(1) DEFAULT 'A' COMMENT 'Estatus del registro A:Activo/P:Procesado',
  `EstatPagBanco` CHAR(1) DEFAULT 'V' COMMENT 'Estatus del pago en banco V:Vigente / A:Aplicado',
  `FechaPagoIns` DATE DEFAULT '1900-01-01' COMMENT 'Fecha de pago en la institucion',
  `MontoAplicado` DECIMAL(18,2) DEFAULT 0.0 COMMENT 'Monto aplicado del pago',
  `FechaAplicacion` DATE DEFAULT '1900-01-01' COMMENT 'Fecha en que se aplica el pago',
  `FechaVencimiento` DATE DEFAULT '1900-01-01' COMMENT 'Fecha en que vence la cuota',
  `FechaExigible` DATE DEFAULT '1900-01-01' COMMENT 'Fecha en que en que se genera exigible de la cuota',
  `ClienteID` INT DEFAULT 0 COMMENT 'ID del Empleado de nomina',
  `FolioProcesoID` INT(11) DEFAULT 0 COMMENT 'ID del folio en la que se realizo el Proceso de Pago',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`FolioNominaID`),
  KEY `fk_FolioNominaID_1_idx` (`FolioNominaID`),
  KEY `INDEX_AMORTCRENOMINAREAL_2` (`FolioProcesoID`),
  KEY `INDEX_AMORTCRENOMINAREAL_3` (`CreditoID`),
  KEY `IDX_DESCNOMINAREAL_2` (`FolioCargaID` ASC)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para guardar los folios de aplicacion de pagos de instituciones de nomina'$$