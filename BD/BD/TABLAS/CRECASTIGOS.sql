-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOS
DELIMITER ;
DROP TABLE IF EXISTS `CRECASTIGOS`;
DELIMITER $$


CREATE TABLE `CRECASTIGOS` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID o Numero de Credito',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en que se Realizo el Castigo',
  `CapitalCastigado` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Capital Castigado',
  `InteresCastigado` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Interes Castigado',
  `TotalCastigo` decimal(14,2) DEFAULT NULL COMMENT 'Total del Monto Castigado del Credito',
  `MonRecuperado` decimal(14,2) DEFAULT NULL COMMENT 'Monto Recuperado o Pagado de Credito Castigado',
  `EstatusCredito` char(1) DEFAULT NULL COMMENT 'Estatus del Credito al momento del Castigo\nV.- Vigente\nB .- Vencido\n\n',
  `MotivoCastigoID` int(11) DEFAULT NULL COMMENT 'Motivo del Castigo Corresponde con la Tabla MOTIVOSCASTIGO',
  `Observaciones` varchar(500) DEFAULT NULL COMMENT 'Observaciones  ',
  `IntMoraCastigado` decimal(14,2) DEFAULT NULL COMMENT 'Interes Moratorio Castigado',
  `AccesorioCastigado` decimal(14,2) DEFAULT NULL COMMENT 'Accesorios, Comisiones Castigadas',
  `SaldoCapital` decimal(12,2) DEFAULT NULL COMMENT 'Saldo del Capital Castigado',
  `SaldoInteres` decimal(12,2) DEFAULT NULL COMMENT 'Saldo del Interes Castigado',
  `SaldoMoratorio` decimal(12,2) DEFAULT NULL COMMENT 'Saldo del Moratorios Castigado',
  `SaldoAccesorios` decimal(12,2) DEFAULT NULL COMMENT 'Saldo del Accesorios Castigado',
  `FecPrimAtraso` date DEFAULT NULL COMMENT 'Fecha del Primer Atraso',
  `FecUltPagoCap` date DEFAULT NULL COMMENT 'Fecha del último pago de Capital',
  `FecUltPagoInt` date DEFAULT NULL COMMENT 'fecha del último pago de Interés',
  `MonUltPagoCap` decimal(14,2) DEFAULT NULL COMMENT 'Monto del último pago de Capital',
  `MonUltPagoInt` decimal(14,2) DEFAULT NULL COMMENT 'Monto del último pago de Interes',
  `TipoCobranza` int(11) DEFAULT NULL COMMENT 'Tipo de Cobranza realizada sobre el Crédito al momento de ser castigado\n1;Ninguna, por declararse inmaterial\n2;Ninguna por declararse incobrable\n3;Extrajudicial propia\n4;Extrajudicial a cargo de terceros\n5;Judicial propia\n6;Judicial a cargo de terceros\n',
  `SaldoNotCargoRev` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de notas de cargo aplicadas para reversas',
  `SaldoNotCargoSinIVA` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de notas de cargo que no manejan IVA',
  `SaldoNotCargoConIVA` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de notas de cargo que manejan IVA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`),
  KEY `fk_CRECASTIGOS_1_idx` (`MotivoCastigoID`),
  KEY `CRECASTIGOS_IDX3` (`Fecha`),
  CONSTRAINT `fk_CRECASTIGOS_1` FOREIGN KEY (`MotivoCastigoID`) REFERENCES `MOTIVOSCASTIGO` (`MotivoCastigoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Castigos de Cartera'$$
