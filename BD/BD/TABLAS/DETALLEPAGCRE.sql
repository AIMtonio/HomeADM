-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGCRE
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEPAGCRE`;
DELIMITER $$

CREATE TABLE `DETALLEPAGCRE` (
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
  `MontoIVAComision` DECIMAL(12,2) NULL DEFAULT 0.00 COMMENT 'Almacena el importe de IVA de las comisiones',
  `MontoAccesorios` DECIMAL(12,2) NULL DEFAULT 0.00 COMMENT 'Almacena el importe de los accesorios',
  `MontoIVAAccesorios` DECIMAL(12,2) NULL DEFAULT 0.00 COMMENT 'Almacena el importe de IVA de los accesorios',
  `MontoNotasCargo` DECIMAL(14,2) NOT NULL DEFAULT 0.00 COMMENT 'Monto pagado por Notas de Cargo',
  `MontoIVANotasCargo` DECIMAL(14,2) NOT NULL DEFAULT 0.00 COMMENT 'Monto de IVA pagado por Notas de Cargo',
  `MontoComServGar` decimal(14,2) DEFAULT 0.00 COMMENT 'Monto Comision por Servicio de Garantia Agro',
  `MontoIvaComServGar` decimal(14,2) DEFAULT 0.00 COMMENT 'Monto Iva Comision por Servicio de Garantia Agro',
  `MontoIntAccesorios` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto pagado por Interes de Accesorios',
  `MontoIVAIntAccesorios` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto pagado por IVA de Interes de Accesorios',
  `OrigenPago` varchar(2) DEFAULT '' COMMENT 'Origen de Pago S: SPEI,\\nV: Ventanilla,\\nC: Cargo A Cta,\\nN: Nomina,\\nD: Domiciliado,\\nR: Depositos Referenciados,\\nW: WebService,\\nO: Otros',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Monto seguro Cuota',
  PRIMARY KEY (`CreditoID`,`FechaPago`,`Transaccion`,`AmortizacionID`),
  KEY `fk_DETALLEPAGCRE_1` (`AmortizacionID`),
  KEY `fk_DETALLEPAGCRE_3` (`ClienteID`),
  KEY `fk_DETALLEPAGCRE_4` (`CreditoID`,`FechaPago`,`Transaccion`),
  CONSTRAINT `fk_DETALLEPAGCRE_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_DETALLEPAGCRE_3` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Pagos de Credito'$$
