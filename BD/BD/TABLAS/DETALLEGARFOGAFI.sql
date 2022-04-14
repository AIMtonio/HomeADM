-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEGARFOGAFI
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEGARFOGAFI`;DELIMITER $$

CREATE TABLE `DETALLEGARFOGAFI` (
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Numero de Solicitud de Credito',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'Indica el numero de producto de credito',
  `AmortizacionID` int(11) NOT NULL COMMENT 'Numero de Amortizacion',
  `Estatus` char(1) NOT NULL DEFAULT 'I' COMMENT 'Estatus de la cuota de garantia',
  `FechaPago` date DEFAULT '1900-01-01' COMMENT 'Fecha a pagar el credito',
  `FechaLiquida` date DEFAULT '1900-01-01' COMMENT 'Fecha en que se liquida la garantia',
  `MontoCuota` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto de garantia requerido por cuota',
  `SaldoFOGAFI` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo pendiente de Pago de la Garantia FOGAFI',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CreditoID`,`SolicitudCreditoID`,`AmortizacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Control de saldos y detalle de garantia liquida'$$