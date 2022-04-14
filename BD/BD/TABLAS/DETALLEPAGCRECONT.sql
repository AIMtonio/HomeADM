-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGCRECONT
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEPAGCRECONT`;DELIMITER $$

CREATE TABLE `DETALLEPAGCRECONT` (
  `AmortizacionID` int(4) NOT NULL COMMENT 'No. de Amortizacion',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
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
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Guarda forma de pago \nE = Efectivo\nC = Cargo a cuenta',
  `MontoSeguroCuota` decimal(12,2) DEFAULT NULL COMMENT 'Monto pagado por seguro por cuota\n',
  `MontoIVASeguroCuota` decimal(12,2) DEFAULT NULL COMMENT 'IVA Seguro por Cuota',
  `MontoComAnual` decimal(14,2) DEFAULT NULL COMMENT 'Monto Pagado por Comision Anual',
  `MontoComAnualIVA` decimal(14,2) DEFAULT NULL COMMENT 'Monto Pagado por IVA de Comision Anual\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Monto seguro Cuota',
  PRIMARY KEY (`AmortizacionID`,`CreditoID`,`FechaPago`,`Transaccion`),
  KEY `fk_DETALLEPAGCRE_1` (`AmortizacionID`),
  KEY `fk_DETALLEPAGCRE_3` (`ClienteID`),
  KEY `fk_DETALLEPAGCRE_4` (`CreditoID`,`FechaPago`,`Transaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Pagos de Creditos Contingentes'$$