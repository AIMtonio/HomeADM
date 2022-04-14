-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPAGOXREFERENCIA
DELIMITER ;
DROP TABLE IF EXISTS `HISPAGOXREFERENCIA`;DELIMITER $$

CREATE TABLE `HISPAGOXREFERENCIA` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Número de Transaccion',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Número de Cliente',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Número de crédito que se afecto',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Número de Cuenta de Ahorro que hizo el pago',
  `Referencia` varchar(20) DEFAULT NULL COMMENT 'Número de Referencia de Pago',
  `FechaApli` date DEFAULT NULL COMMENT 'Fecha en la que se aplica el pago',
  `Hora` time DEFAULT NULL COMMENT 'Hora en la que se realiza la operación',
  `Monto` decimal(16,2) DEFAULT NULL COMMENT 'Monto del Pago de la Referencia',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Pago de la Referencia P:Pendiente A:Aplicado S:Solo Abono',
  `SaldoCtaAntesPag` decimal(16,2) DEFAULT NULL COMMENT 'Se mostrará el saldo total de la cuenta ligada al crédito',
  `SaldoBloqRefere` decimal(16,2) DEFAULT NULL COMMENT 'Se mostrará el saldo aún bloqueado de la referencia',
  `CapitalPag` decimal(16,2) DEFAULT NULL COMMENT 'Capital Pagado',
  `InteresPag` varchar(45) DEFAULT NULL COMMENT 'Intereses Pagados',
  `MoratoriosPag` varchar(45) DEFAULT NULL COMMENT 'Se mostrarán los moratorios pagados',
  `ComisionesPag` varchar(45) DEFAULT NULL COMMENT 'Se mostrarán las comisiones pagadas',
  `IVAPag` varchar(45) DEFAULT NULL COMMENT ' Se mostrará el IVA total pagado',
  `TotalPag` varchar(45) DEFAULT NULL COMMENT 'TotalPagado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TransaccionID`),
  KEY `IDX_PAGOXREFERENCIA_1` (`ClienteID`),
  KEY `IDX_PAGOXREFERENCIA_2` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='HIS:Tabla Historica que almacena los pagos x referencia.'$$