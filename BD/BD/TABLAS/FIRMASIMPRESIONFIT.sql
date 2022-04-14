-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FIRMASIMPRESIONFIT
DELIMITER ;
DROP TABLE IF EXISTS `FIRMASIMPRESIONFIT`;DELIMITER $$

CREATE TABLE `FIRMASIMPRESIONFIT` (
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Id de la cuenta de ahorro',
  `FechaImpresion` date DEFAULT NULL COMMENT 'Fecha de Impresion del formato de firmas\n',
  `FechaModificacion` date DEFAULT NULL COMMENT 'Fecha de modificacion del registro de firmas',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`CuentaAhoID`),
  KEY `index2` (`CuentaAhoID`),
  CONSTRAINT `fk_FIRMASIMPRESIONFIT_1` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Lleva el registro de la impresion y modificacion a la lista de firmates autorizados de la cuenta.'$$