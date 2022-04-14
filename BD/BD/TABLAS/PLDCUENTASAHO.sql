-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCUENTASAHO
DELIMITER ;
DROP TABLE IF EXISTS `PLDCUENTASAHO`;DELIMITER $$

CREATE TABLE `PLDCUENTASAHO` (
  `CuentaAhoIDClie` varchar(20) NOT NULL COMMENT 'Identificador del cliente externo',
  `CuentaAhoID` bigint(20) NOT NULL COMMENT 'Identificador de la cuenta de ahorro del cliente en el SAFI',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`CuentaAhoIDClie`),
  KEY `FK_PLDCUENTASAHO_1` (`CuentaAhoID`),
  CONSTRAINT `FK_PLDCUENTASAHO_1` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla alterna a CUENTASAHO para clientes externos al SAFI	 '$$