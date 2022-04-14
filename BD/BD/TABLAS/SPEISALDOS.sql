-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEISALDOS
DELIMITER ;
DROP TABLE IF EXISTS `SPEISALDOS`;DELIMITER $$

CREATE TABLE `SPEISALDOS` (
  `EmpresaID` int(11) NOT NULL COMMENT 'ID de la Empresa',
  `SaldoActual` decimal(16,2) NOT NULL COMMENT 'Saldo Actual',
  `SaldoReservado` decimal(16,2) NOT NULL COMMENT 'Saldo Reservado',
  `MontoDisponible` decimal(16,2) NOT NULL COMMENT 'Monto Disponible',
  `BalanceCuenta` decimal(16,2) NOT NULL COMMENT 'Balance de Cuenta',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`EmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos de SPEI'$$