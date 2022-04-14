-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDOPEINUMAYOREXI
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDOPEINUMAYOREXI`;DELIMITER $$

CREATE TABLE `TMPPLDOPEINUMAYOREXI` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Cuenta',
  `AmortizacionID` int(4) NOT NULL COMMENT 'No. de Amortizacion',
  `MontoCuota` decimal(18,2) DEFAULT NULL,
  `VarPagos` decimal(14,2) DEFAULT NULL COMMENT '% de variacion maxima  positiva antes de reportar pagos del cliente vs cuotas exigibles (OPI3b)',
  `MontoHolgura` decimal(31,2) DEFAULT NULL,
  `MontoTotPago` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total del Pago APLICADO',
  `TotalPagado` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Pagado',
  `Estatus` varchar(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nA.- Atrasado\n'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$