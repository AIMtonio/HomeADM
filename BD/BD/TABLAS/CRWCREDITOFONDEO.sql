-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWCREDITOFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `CRWCREDITOFONDEO`;
DELIMITER $$


CREATE TABLE `CRWCREDITOFONDEO` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del credito',
  `SaldoCre` decimal(12,2) NOT NULL COMMENT 'Saldo del credito',
  `SaldoFondeo` decimal(12,2) NOT NULL COMMENT 'Saldo del fondeo',
  `MontoCredito` decimal(12,2) NOT NULL COMMENT 'Monto de credito',
  `CreditoEnEjec` char(1) NOT NULL COMMENT 'Credito en ejecucion S : Si, N : No',
  `FondeoEnEjec` int(12) NOT NULL COMMENT 'Fondeo en ejecucion',
  `EstatusCre` char(1) NOT NULL COMMENT 'Estatus del credito',
  `Estatus` char(1) NOT NULL COMMENT 'A .- Activo\nI .- Inactivo',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha actual',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Transaccion de auditoria',
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de creditos de fondeo'$$
