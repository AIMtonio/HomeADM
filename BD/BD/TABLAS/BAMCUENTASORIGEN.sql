-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMCUENTASORIGEN
DELIMITER ;
DROP TABLE IF EXISTS `BAMCUENTASORIGEN`;DELIMITER $$

CREATE TABLE `BAMCUENTASORIGEN` (
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del Usuario',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Cuenta de ahorro sobre la cual hacer los cargos, disposiciones o pagos.\n',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la asignacion de la cuenta. A.-Activo I.-Inactivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`CuentaAhoID`),
  KEY `FK_CUENTASAHO_idx` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas de Ahorro o Bancarias que desea esten disponibles en el movil, para realizar operaciones sobre estas cuentas de\nPagos, transferencias, etc. Por Default no todas sus cuentas estan disponibles'$$