-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESAMORTICONT
DELIMITER ;
DROP TABLE IF EXISTS `RESAMORTICONT`;
DELIMITER $$


CREATE TABLE `RESAMORTICONT` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `TranRespaldo` bigint(20) DEFAULT NULL COMMENT 'No de Transaccion Respaldo',
  `AmortizacionID` int(4) DEFAULT NULL COMMENT 'No\nAmortizacion Respaldo',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Credito Respaldo',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente Respaldo',
  `CuentaID` bigint(12) DEFAULT NULL COMMENT 'CuentaID',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio\n Respaldo',
  `FechaVencim` date DEFAULT NULL COMMENT 'Fecha de\nVencimiento Respaldo',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigible\nde Pago\n',
  `Estatus` varchar(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nA.- Atrasado\n Respaldo',
  `FechaLiquida` date DEFAULT NULL COMMENT 'Fecha de \nLiquidacion o\nTerminacion\n Respaldo',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Capital Respaldo',
  `Interes` decimal(14,2) DEFAULT NULL COMMENT 'Interes Respaldo',
  `IVAInteres` decimal(10,2) DEFAULT NULL COMMENT 'IVA Interes Respaldo',
  `SaldoCapVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente, en el alta nace con ceros Respaldo',
  `SaldoCapAtrasa` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Atrasado, en el alta nace con ceros Respaldo',
  `SaldoCapVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido, en el alta nace con ceros Respaldo',
  `SaldoCapVenNExi` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido no Exigible, en al alta nace con ceros Respaldo',
  `SaldoInteresOrd` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Ordinario, en el alta nace con ceros Respaldo',
  `SaldoInteresAtr` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado, en el alta nace con ceros Respaldo',
  `SaldoInteresVen` decimal(14,4) DEFAULT NULL COMMENT 'Saldos de Interes Vencido, en el alta nace con ceros Respaldo',
  `SaldoInteresPro` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Provision, en el alta nace con ceros Respaldo',
  `SaldoIntNoConta` decimal(12,4) DEFAULT NULL COMMENT 'Saldo de Interes\nNo Contabilizado Respaldo',
  `SaldoIVAInteres` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Interes, en el alta nace con ceros Respaldo',
  `SaldoMoratorios` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Moratorios, en el alta nace con ceros Respaldo',
  `SaldoIVAMorato` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Mora, en el alta nace con ceros Respaldo',
  `SaldoComFaltaPa` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Comision Falta Pago, en el alta nace con ceros Respaldo',
  `SaldoIVAComFalP` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Com Falta Pago, en el alta nace con ceros Respaldo',
  `SaldoOtrasComis` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Otras Comisiones, en el alta nace con ceros Respaldo',
  `SaldoIVAComisi` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Otras Com, en el alta nace con ceros Respaldo',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision\nAcumulada Respaldo',
  `SaldoCapital` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Capital Respaldo',
  `NumProyInteres` int(11) DEFAULT NULL COMMENT 'Numero de Veces que se ha Realizado la Proyeccion de Intereses\nen un Pago Anticipado Respaldo',
  `SaldoMoraVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
  `SaldoMoraCarVen` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
  `MontoSeguroCuota` decimal(12,2) DEFAULT NULL COMMENT 'Monto del seguro por cuota',
  `IVASeguroCuota` decimal(12,2) DEFAULT NULL COMMENT 'Monto de Iva para el seguro por cuota',
  `SaldoSeguroCuota` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Monto Seguro Cuota',
  `SaldoIVASeguroCuota` decimal(12,2) DEFAULT NULL COMMENT 'Saldo IVA Seguro Cuota',
  `SaldoComisionAnual` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Comision Anual',
  `SaldoComisionAnualIVA` decimal(14,2) DEFAULT NULL COMMENT 'Saldo IVA Comision Anual',
  `SalCapitalOriginal` DECIMAL(16,2) NOT NULL COMMENT 'Saldo Capital Original del Crédito Activo',
  `SalInteresOriginal` DECIMAL(16,2) NOT NULL COMMENT 'Saldo Interés Original del Crédito Activo',
  `SalMoraOriginal` DECIMAL(16,2) NOT NULL COMMENT 'Saldo Moratorio Original del Crédito Activo',
  `SalComOriginal` DECIMAL(16,2) NOT NULL COMMENT 'Saldo Comisiones Original del Crédito Activo',
  `SaldoCapitalAnt` DECIMAL(16,2) NOT NULL COMMENT 'Saldo Capital Original del Crédito Activo no afectado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  KEY `TranRespaldo` (`TranRespaldo`),
  KEY `CreditoID` (`CreditoID`),
  KEY `AmortizacionID` (`AmortizacionID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Respaldo por reversa de pago para Amortizacion Contingentes'$$
