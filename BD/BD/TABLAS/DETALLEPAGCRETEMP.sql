-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGCRETEMP
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEPAGCRETEMP`;DELIMITER $$

CREATE TABLE `DETALLEPAGCRETEMP` (
  `AmortizacionID` int(4) NOT NULL COMMENT 'No. de Amortizacion',
  `CreditoID` int(11) NOT NULL COMMENT 'Id del Credito',
  `FechaPago` date NOT NULL COMMENT 'Fecha de\nVencimiento',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero o ID del Cliente',
  `MontoTotPago` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total del Pago APLICADO',
  `MontoCapOrd` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Capital Ordinario',
  `MontoCapAtr` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Capital Atrasado',
  `MontoCapVen` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Capital Vencido',
  `MontoIntOrd` decimal(14,4) DEFAULT NULL COMMENT 'Monto Aplicado Interes Ordinario',
  `MontoIntAtr` decimal(14,4) DEFAULT NULL COMMENT 'Monto Aplicado Interes Atrasado',
  `MontoIntVen` decimal(14,4) DEFAULT NULL COMMENT 'Monto Aplicado Interes Vencico',
  `MontoIntMora` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Mora',
  `MontoIVA` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado IVA',
  `MontoComision` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Comisiones',
  `MontoGastoAdmon` decimal(14,2) DEFAULT NULL COMMENT 'Monto de Gastos de Administracion.\nLiquidacion Anticipada, Finiquito',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$