-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSADESCNOMINAREAL
DELIMITER ;
DROP TABLE IF EXISTS `REVERSADESCNOMINAREAL`;
DELIMITER $$

CREATE TABLE `REVERSADESCNOMINAREAL` (
  `FolioReversaID` INT(11) NOT NULL COMMENT 'ID del folio de DESCNOMINAREAL',
  `FolioCargaID` INT(11) NOT NULL COMMENT 'ID del folio de carga del archivo de descuento',
  `CreditoID` BIGINT(15) NOT NULL COMMENT 'ID del credito',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`FolioReversaID`,  `NumTransaccion`),
  KEY `INDEX_REVERSADESCNOMINAREAL_1` (`FolioCargaID`),
  KEY `INDEX_REVERSADESCNOMINAREAL_2` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de guia para dar Reversa los registros de la Tabla Real'$$