-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMORTICREDCONT
DELIMITER ;
DROP TABLE IF EXISTS `TMPAMORTICREDCONT`;
DELIMITER $$

CREATE TABLE `TMPAMORTICREDCONT` (
  `AmortizacionID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Numero consecutivo',
  `CreditoID` bigint(11) NOT NULL COMMENT 'Numero de credito',
  `FechaInicio` date DEFAULT '1900-01-01' COMMENT 'Fecha inicio del credito',
  `FechaVen` date DEFAULT '1900-01-01' COMMENT 'Fecha vencimiento del credito',
  `Estatus` char(1) NOT NULL DEFAULT '' COMMENT 'Estatus de credito',
  `MontoAplica` decimal(16,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto aplica',
  `MontoReal` decimal(16,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto real',
  `SalCapitalOriginal` DECIMAL(16,2) NOT NULL COMMENT 'Saldo Capital Original del Crédito Activo',
  `SalInteresOriginal` DECIMAL(16,2) NOT NULL COMMENT 'Saldo Interés Original del Crédito Activo',
  `SalMoraOriginal` DECIMAL(16,2) NOT NULL COMMENT 'Saldo Moratorio Original del Crédito Activo',
  `SalComOriginal` DECIMAL(16,2) NOT NULL COMMENT 'Saldo Comisiones Original del Crédito Activo',
  `EmpresaID` INT(11) NOT NULL COMMENT 'ID de la empresa',
  `Usuario` INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
  `FechaActual` DATETIME NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
  `DireccionIP` VARCHAR(15) NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
  `ProgramaID` VARCHAR(50) NOT NULL COMMENT 'Parámetro de auditoría Programa',
  `Sucursal` INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
  `NumTransaccion` BIGINT(20) NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
  PRIMARY KEY (`AmortizacionID`,`CreditoID`),
  KEY `IDX_TMPAMORTICREDCONT_1` (`CreditoID`,`NumTransaccion`),
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Tabla de paso para creacion de creditos contingentes'$$