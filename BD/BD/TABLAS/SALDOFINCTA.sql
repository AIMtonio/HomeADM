-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOFINCTA
DELIMITER ;
DROP TABLE IF EXISTS `SALDOFINCTA`;DELIMITER $$

CREATE TABLE `SALDOFINCTA` (
  `CuentaContable` char(25) NOT NULL COMMENT 'Cuenta Contable Completa',
  `Fecha` date NOT NULL COMMENT 'Fecha del Saldo final',
  `SaldoFinal` decimal(18,2) DEFAULT NULL COMMENT 'Saldo final del dia',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CuentaContable`,`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos finales del dia por cuenta contable, esta tabla se actualiza en el cierre'$$