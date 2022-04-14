-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDEPOSITOREFEREN
DELIMITER ;
DROP TABLE IF EXISTS `TMPDEPOSITOREFEREN`;
DELIMITER $$


CREATE TABLE `TMPDEPOSITOREFEREN` (
  `Consecutivo` bigint(17) NOT NULL COMMENT 'Incremental de la tabla temporal',
  `CuentaAhoID` varchar(20) NOT NULL COMMENT 'ID de la Cuenta de ahorro',
  `InstitucionID` int(11) NOT NULL COMMENT 'Id Del Banco (Institucion) de donde es la Cuenta',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento  C=Cargo, A=Abono',
  `MontoMov` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Movimiento',
  `ReferenciaMov` varchar(40) DEFAULT NULL COMMENT 'Referencia del Movimiento Debe ser el CREDITO o CUENTA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'auditoria',
  PRIMARY KEY (`Consecutivo`,`CuentaAhoID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Auxiliar en la reversa de Pagos de creditos con origen de Depositos referenciados'$$