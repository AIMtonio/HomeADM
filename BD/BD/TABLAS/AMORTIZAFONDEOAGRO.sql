-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAFONDEOAGRO
DELIMITER ;
DROP TABLE IF EXISTS `AMORTIZAFONDEOAGRO`;DELIMITER $$

CREATE TABLE `AMORTIZAFONDEOAGRO` (
  `CreditoFondeoID` bigint(20) NOT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha de Exigibilidad de la Amortizacion, por si la de',
  `FechaLiquida` date DEFAULT NULL COMMENT 'Fecha real en la que se termina de pagar la amortizacion\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Amortizacion\nN .- Vigente o en Proceso\nA .- Atrasada\nP .- Pagada',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Capital',
  `Interes` decimal(14,2) DEFAULT NULL COMMENT 'Interes',
  `IVAInteres` decimal(14,2) DEFAULT NULL COMMENT 'IVA Interes',
  `SaldoCapVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente, en el alta nace con ceros',
  `SaldoCapAtrasad` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Atrasado, en el alta nace con ceros',
  `SaldoInteresAtra` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado, en el alta nace con ceros',
  `SaldoInteresPro` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Provision, en el alta nace con ceros',
  `SaldoIVAInteres` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Interes, en el alta nace con ceros',
  `SaldoMoratorios` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Moratorios, en el alta nace con ceros',
  `SaldoIVAMora` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Mora, en el alta nace con ceros',
  `SaldoComFaltaPa` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Comision Falta Pago, en el alta nace con ceros',
  `SaldoIVAComFalP` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Com Falta Pago, en el alta nace con ceros',
  `SaldoOtrasComis` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Otras Comisiones, en el alta nace con ceros',
  `SaldoIVAComisi` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Otras Com, en el alta nace con ceros',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision\nAcumulada ',
  `SaldoCapital` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Capital',
  `SaldoRetencion` decimal(12,2) DEFAULT NULL COMMENT 'Saldo de Retencion',
  `Retencion` decimal(14,2) DEFAULT NULL COMMENT 'Valor de la retencion ISR\n',
  `EstatusDesembolso` char(1) DEFAULT 'N' COMMENT 'Estatus de Desembolso D:Desembolsada N: No desembolsada C: Cancelada',
  `MontoPendDesembolso` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Pendiente a Desembolsar\n',
  `MontoCancelado` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Cancelado. Puede ser el total de la amortización o un monto parcial.\nSe actualiza en el proceso de Cancelación.',
  `TmpMontoDesembolso` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto que se utiliza en el cursor para desembolsar, este dato se envia a CREDITOSMOVSAL',
  `TipoCalculoInteres` char(1) DEFAULT NULL COMMENT 'Tipo de Calculo de interes fechaPactada: P,  fechaReal: R',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CreditoFondeoID`,`AmortizacionID`),
  KEY `fk_AMORTIZAFONDEOAGRO_1` (`CreditoFondeoID`),
  KEY `AMOFONDEO_FECEXIYESTATUS` (`FechaExigible`,`Estatus`),
  KEY `INDEX_ESTATUS` (`Estatus`),
  CONSTRAINT `fk_AMORTIZAFONDEOAGRO_1` FOREIGN KEY (`CreditoFondeoID`) REFERENCES `CREDITOFONDEO` (`CreditoFondeoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Amortizaciones de Credito Pasivo Guarda el Calendario Ideal'$$