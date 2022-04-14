-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGFON
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEPAGFON`;DELIMITER $$

CREATE TABLE `DETALLEPAGFON` (
  `AmortizacionID` int(4) NOT NULL COMMENT 'No. de Amortizacion',
  `CreditoFondeoID` bigint(20) NOT NULL COMMENT 'Id del Credito Pasivo',
  `FechaPago` date NOT NULL COMMENT 'Fecha de\nVencimiento',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `MontoTotPago` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total del Pago APLICADO',
  `MontoCapVig` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Capital Vigente',
  `MontoCapAtr` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Capital Atrasado',
  `MontoIntPro` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Provisionado',
  `MontoIntAtr` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Atrasado',
  `MontoIntMora` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Mora',
  `MontoIVA` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado IVA',
  `MontoComision` decimal(12,2) DEFAULT NULL COMMENT 'Monto Aplicado Comisiones',
  `CreditoID` bigint(20) DEFAULT NULL COMMENT 'Credito Activo Relacionado al Pago de Credito Pasivo',
  `FolioPagoActivo` bigint(20) DEFAULT NULL COMMENT 'Numero de la Transaccion con que se realiza el pago del Credito Activo,',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria ',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria ',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`AmortizacionID`,`CreditoFondeoID`,`FechaPago`,`Transaccion`),
  KEY `fk_DETALLEPAGFON_1_idx` (`CreditoFondeoID`),
  CONSTRAINT `fk_DETALLEPAGFON_1` FOREIGN KEY (`CreditoFondeoID`) REFERENCES `CREDITOFONDEO` (`CreditoFondeoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Pagos de Credito Pasivo'$$