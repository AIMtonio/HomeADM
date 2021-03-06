DELIMITER ;
DROP TABLE IF EXISTS `AMORTICREDITOVTA`;
DELIMITER $$

CREATE TABLE `AMORTICREDITOVTA` (
  `AmortizacionID` int(4) NOT NULL COMMENT 'No\nAmortizacion',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente',
  `CuentaID` bigint(12) DEFAULT NULL,
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio\n',
  `FechaVencim` date DEFAULT NULL COMMENT 'Fecha de\nVencimiento',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigible\nde Pago\n',
  `Estatus` varchar(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nA.- Atrasado\n',
  `FechaLiquida` date DEFAULT NULL COMMENT 'Fecha de \nLiquidacion o\nTerminacion\n',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Capital',
  `Interes` decimal(14,2) DEFAULT NULL COMMENT 'Interes',
  `IVAInteres` decimal(10,2) DEFAULT NULL COMMENT 'IVA Interes',
  `SaldoCapVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente, en el alta nace con ceros',
  `SaldoCapAtrasa` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Atrasado, en el alta nace con ceros',
  `SaldoCapVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido, en el alta nace con ceros',
  `SaldoCapVenNExi` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido no Exigible, en al alta nace con ceros',
  `SaldoInteresOrd` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Ordinario, en el alta nace con ceros',
  `SaldoInteresAtr` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado, en el alta nace con ceros',
  `SaldoInteresVen` decimal(14,4) DEFAULT NULL COMMENT 'Saldos de Interes Vencido, en el alta nace con ceros',
  `SaldoInteresPro` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Provision, en el alta nace con ceros',
  `SaldoIntNoConta` decimal(12,4) DEFAULT NULL COMMENT 'Saldo de Interes\nNo Contabilizado',
  `SaldoIVAInteres` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Interes, en el alta nace con ceros',
  `SaldoMoratorios` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Moratorios, en el alta nace con ceros',
  `SaldoIVAMorato` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Mora, en el alta nace con ceros',
  `SaldoComFaltaPa` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Comision Falta Pago, en el alta nace con ceros',
  `SaldoIVAComFalP` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Com Falta Pago, en el alta nace con ceros',
  `SaldoComServGar` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision por Servicio de Garantia Agro',
  `SaldoIVAComSerGar` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Iva Comision por Servicio de Garantia Agro',
  `MontoOtrasComisiones` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto a Cobrar de Otras Comisiones',
  `MontoIVAOtrasComisiones` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto a Cobrar del IVA de Otras Comisiones',
  `SaldoOtrasComis` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Otras Comisiones, en el alta nace con ceros',
  `SaldoIVAComisi` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Otras Com, en el alta nace con ceros',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision\nAcumulada ',
  `SaldoCapital` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Capital',
  `NumProyInteres` int(11) DEFAULT NULL COMMENT 'Numero de Veces que se ha Realizado la Proyeccion de Intereses\nen un Pago Anticipado',
  `SaldoMoraVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
  `SaldoMoraCarVen` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
  `MontoSeguroCuota` decimal(12,2) DEFAULT '0.00' COMMENT 'Monto del seguro por cuota',
  `IVASeguroCuota` decimal(12,2) DEFAULT '0.00' COMMENT 'Monto de Iva para el seguro por cuota',
  `SaldoSeguroCuota` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Monto Seguro Cuota',
  `SaldoIVASeguroCuota` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo IVA Seguro Cuota',
  `SaldoComisionAnual` decimal(14,2) DEFAULT '0.00' COMMENT 'Comision Anual',
  `SaldoComisionAnualIVA` decimal(14,2) DEFAULT '0.00' COMMENT 'IVA por comision por anualidad',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`AmortizacionID`,`CreditoID`),
  KEY `fk_AMORTICREDITOVTA_2` (`ClienteID`),
  KEY `fk_AMORTICREDITOVTA_3` (`CuentaID`),
  KEY `fk_AMORTICREDITOVTA_1` (`CreditoID`),
  KEY `IDX_AMORTICREDITOVTA_4_Estat` (`Estatus`),
  KEY `IDX_AMORTICREDITOVTA_5_FecExi` (`FechaExigible`),
  KEY `IDX_AMORTICREDITOVTA_6_FecVen` (`FechaVencim`),
  CONSTRAINT `fk_AMORTICREDITOVTA_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_AMORTICREDITOVTA_2` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_AMORTICREDITOVTA_3` FOREIGN KEY (`CuentaID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='RESPALDO DE Tabla de Amortizaciones de los Creditos EN VENTA DE CARTERA ';$$


