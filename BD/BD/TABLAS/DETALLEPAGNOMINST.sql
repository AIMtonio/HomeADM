-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGNOMINST
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEPAGNOMINST`;
DELIMITER $$

CREATE TABLE `DETALLEPAGNOMINST` (
  `DetalleID` INT(11) NOT NULL COMMENT 'ID del detalle del Folio',
  `FolioCargaID` INT(11) NOT NULL COMMENT 'ID del folio de carga del archivo de descuento',
  `NumRegistros` INT(11) DEFAULT NULL COMMENT 'Numero total de Registros del Folio',
  `NumPagosAplicados` INT(11) DEFAULT NULL COMMENT 'Numero total de Pagos Aplicados del Folio',
  `NumPagosImportados` INT(11) DEFAULT NULL COMMENT 'Numero total de Pagos que fueron Importados por otros Folios ',
  `MontoTotal` DECIMAL(12,2) DEFAULT NULL COMMENT 'Monto total de los pagos ',
  `MovConciliado` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion del Movimiento (se llena al conciliar)',
  `EmpresaID` INT(11) DEFAULT NULL,
  `Usuario` INT(11) DEFAULT NULL,
  `FechaActual` DATETIME DEFAULT NULL,
  `DireccionIP` VARCHAR(15) DEFAULT NULL,
  `ProgramaID` VARCHAR(50) DEFAULT NULL,
  `Sucursal` INT(11) DEFAULT NULL,
  `NumTransaccion` BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (`FolioCargaID`),
  KEY `INDEX_DETALLEPAGNOMINST_1` (`FolioCargaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Encabezado de Control de Pago de Instituciones'$$