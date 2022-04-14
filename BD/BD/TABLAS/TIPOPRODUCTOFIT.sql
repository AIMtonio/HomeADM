-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPRODUCTOFIT
DELIMITER ;
DROP TABLE IF EXISTS `TIPOPRODUCTOFIT`;DELIMITER $$

CREATE TABLE `TIPOPRODUCTOFIT` (
  `TipoCuentaID` int(11) NOT NULL COMMENT 'Numero de Tipo de Cuenta, hace referencia a la tabla TIPOSCUENTAS',
  `TipoProductoRep` char(1) DEFAULT NULL COMMENT 'Tipo de producto del que se trate\nO, Cuenta Operativa\nI, Ahorro Infantil\nJ, Ahorro Juvenil\nF, Ahorro FIT ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`TipoCuentaID`),
  KEY `index2` (`TipoCuentaID`),
  CONSTRAINT `fk_TIPOPRODUCTOFIT_1` FOREIGN KEY (`TipoCuentaID`) REFERENCES `TIPOSCUENTAS` (`TipoCuentaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Contiene el mapeo por tipo de producto, se indica el formato a mostrar en el reporte, para la financiera Tamazula'$$