-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEPAGARRENDA`;DELIMITER $$

CREATE TABLE `DETALLEPAGARRENDA` (
  `ArrendaAmortiID` int(4) NOT NULL COMMENT 'No. de Amortizacion del arrendamiento',
  `ArrendaID` bigint(12) NOT NULL COMMENT 'Id del Arrendamiento',
  `FechaPago` date NOT NULL COMMENT 'Fecha de real de pago',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero o ID del Cliente',
  `MontoTotPago` decimal(14,4) NOT NULL COMMENT 'Monto Total del Pago APLICADO',
  `CapitalRenta` decimal(14,4) NOT NULL COMMENT 'Monto Total del capital de la renta',
  `InteresRenta` decimal(14,4) NOT NULL COMMENT 'Monto Total del interés de la renta',
  `Renta` decimal(14,4) NOT NULL COMMENT 'Monto Total de la renta',
  `IVARenta` decimal(14,4) NOT NULL COMMENT 'Monto Total del IVA de la renta',
  `MontoCapVig` decimal(14,4) NOT NULL COMMENT 'Monto Aplicado Capital Vigente',
  `MontoCapAtr` decimal(14,4) NOT NULL COMMENT 'Monto Aplicado Capital Atrasado',
  `MontoCapVen` decimal(14,4) NOT NULL COMMENT 'Monto Aplicado Capital Vencido',
  `MontoIntVig` decimal(14,4) NOT NULL COMMENT 'Monto Aplicado Interes Vigente',
  `MontoIntAtr` decimal(14,4) NOT NULL COMMENT 'Monto Aplicado Interes Atrasado',
  `MontoIntVen` decimal(14,4) NOT NULL COMMENT 'Monto Aplicado Interes Vencido',
  `MontoIVAInteres` decimal(14,4) NOT NULL COMMENT 'Monto Aplicado IVA del interes',
  `MontoIVACapital` decimal(14,4) NOT NULL COMMENT 'Monto Aplicado IVA del capital',
  `MontoMoratorios` decimal(14,4) NOT NULL COMMENT 'Monto de Intereses Moratorios',
  `MontoIVAMora` decimal(14,4) NOT NULL COMMENT 'Monto del IVA sobre el Interés Moratorio',
  `MontoComision` decimal(14,4) NOT NULL COMMENT 'Monto Aplicado por otras comisiones',
  `MontoIVAComi` decimal(14,4) NOT NULL COMMENT 'Monto del IVA por otras comisiones',
  `MontoComFaltPago` decimal(14,4) NOT NULL COMMENT 'Monto por comisión por falta de pago',
  `MontoIVAComFalPag` decimal(14,4) NOT NULL COMMENT 'Monto por IVA de la comisión por falta de pago',
  `MontoSeguro` decimal(14,4) NOT NULL COMMENT 'Monto pagado por seguro inmobiliario por cuota',
  `MontoIVASeguro` decimal(14,4) NOT NULL COMMENT 'IVA Seguro inmobiliario por Cuota',
  `MontoSeguroVida` decimal(14,4) NOT NULL COMMENT 'Monto pagado por seguro de vida por cuota',
  `MontoIVASeguroVida` decimal(14,4) NOT NULL COMMENT 'IVA del seguro de vida por Cuota',
  `FormaPago` char(1) NOT NULL COMMENT 'Guarda forma de pago \nE = Efectivo\nC = Cargo a cuenta',
  `EmpresaID` int(11) NOT NULL COMMENT 'Id de la empresa (auditoria)',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario (auditoria)',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha atual del sistema(auditoria)',
  `DireccionIP` varchar(20) NOT NULL COMMENT 'Dirección IP(auditoria)',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Id del programa que graba(auditoria)',
  `Sucursal` int(11) NOT NULL COMMENT 'Id de la sucursal(auditoria)',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de transacción(auditoria)',
  PRIMARY KEY (`ArrendaAmortiID`,`ArrendaID`,`FechaPago`,`Transaccion`),
  KEY `FK_DETALLEPAGARRENDAMIENTO_1` (`ArrendaAmortiID`),
  KEY `FK_DETALLEPAGARRENDAMIENTO_3` (`ClienteID`),
  KEY `FK_DETALLEPAGARRENDAMIENTO_4` (`ArrendaID`,`FechaPago`,`Transaccion`),
  CONSTRAINT `FK_DETALLEPAGARRENDAMIENTO_1` FOREIGN KEY (`ArrendaID`) REFERENCES `ARRENDAMIENTOS` (`ArrendaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_DETALLEPAGARRENDAMIENTO_3` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Pagos de Arrendamiento'$$