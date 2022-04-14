-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESAMORTICRWFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `RESAMORTICRWFONDEO`;

DELIMITER $$
CREATE TABLE `RESAMORTICRWFONDEO` (
  `TranRespaldo` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion de respaldo',
  `SolFondeoID` bigint(20) DEFAULT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'Id de la Amortizacion o Calendario',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha de Exigibilidad de la Amortizacion.',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Capital',
  `InteresGenerado` decimal(14,2) DEFAULT NULL COMMENT 'Interes Generado o Calculado',
  `InteresRetener` decimal(14,2) DEFAULT NULL COMMENT 'Interes o ISR a Retener',
  `PorcentajeInteres` decimal(9,6) DEFAULT NULL COMMENT 'Porcentaje Interés Respecto al Interés En la Parte Activa',
  `PorcentajeCapital` decimal(9,6) DEFAULT NULL COMMENT 'Porcentaje de Capital Respecto a la parte activa (AMORTICREDITO)',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Amortizacion N .- Vigente o en Proceso P .- Pagada A .- Atrasado',
  `SaldoCapVigente` decimal(12,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente',
  `SaldoCapExigible` decimal(12,2) DEFAULT NULL COMMENT 'Saldo de Capital Exigible o en Atraso',
  `SaldoInteres` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes',
  `SaldoIntMoratorio` decimal(14,4) DEFAULT NULL,
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision Acumulada ',
  `RetencionIntAcum` decimal(14,4) DEFAULT NULL COMMENT 'Monto de la Retencion de Interes Acumulada Diaria',
  `MoratorioPagado` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de Moratorios Pagados al Inversionista CRW.',
  `ComFalPagPagada` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de Comision por Falta de Pago pagados al Inversionista CRW.',
  `IntOrdRetenido` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de Interes Ordinario Retenido al Inversionista CRW.',
  `IntMorRetenido` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de Interes Moratorio Retenido al Inversionista CRW.',
  `ComFalPagRetenido` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de Comisio Falta Pago Retenido al Inversionista CRW.',
  `FechaLiquida` date DEFAULT NULL COMMENT 'Fecha real en la que se termina de pagar la amortizacion',
  `CapitalCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'Capital que se encuentra en las cuentas de orden(capital que se uso para aplicar la garantia del credito)',
  `InteresCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'interes que se encuentra en cuentas de Orden(interes que se uso para aplicar la garantia al credito)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  KEY `INDEX_RESAMORTICRWFONDEO_1` (`TranRespaldo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Contiene el respaldo de tabla AMORTICRWFONDEO.'$$