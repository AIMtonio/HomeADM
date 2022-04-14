-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGAPAGODESCNOMINAREAL
DELIMITER ;
DROP TABLE IF EXISTS `CARGAPAGODESCNOMINAREAL`;
DELIMITER $$

CREATE TABLE `CARGAPAGODESCNOMINAREAL` (
  `CargaID` INT(11) NOT NULL COMMENT 'ID del registro de la tabla',
  `FolioNominaID` INT(11) NOT NULL COMMENT 'ID del registro de Folio de Nomina',
  `FolioCargaID` INT(11) NOT NULL COMMENT 'ID del folio de carga del archivo de descuento',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`CargaID`,`NumTransaccion`),
  KEY `INDEX_CARGAPAGODESCNOMINAREAL_1` (`FolioNominaID`),
  KEY `INDEX_CARGAPAGODESCNOMINAREAL_2` (`FolioCargaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para guardar los folios a procesar la aplicacion de pagos de instituciones de nomina'$$