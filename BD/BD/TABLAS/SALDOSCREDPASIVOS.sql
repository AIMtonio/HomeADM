-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCREDPASIVOS
DELIMITER ;
DROP TABLE IF EXISTS `SALDOSCREDPASIVOS`;DELIMITER $$

CREATE TABLE `SALDOSCREDPASIVOS` (
  `CreditoFondeoID` int(11) NOT NULL COMMENT 'ID del Credito',
  `FechaCorte` date NOT NULL COMMENT 'Fecha de Corte',
  `LineaFondeoID` int(11) DEFAULT NULL COMMENT 'Id de linea',
  `InstitutFondID` int(11) DEFAULT NULL COMMENT 'Id de la Institucion',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Id de moneda',
  `EstatusCredito` char(1) DEFAULT NULL COMMENT 'Estatus credito',
  `MontoCredito` decimal(14,2) DEFAULT NULL,
  `NumAmortizacion` int(11) DEFAULT NULL COMMENT 'Numero de Amortizaciones o Cuotas',
  `SaldoCapVigente` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Vigente',
  `SaldoCapAtrasad` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Atrasado',
  `SaldoInteresPro` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Provision',
  `SaldoInteresAtra` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes Atrasado',
  `SaldoMoratorios` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Moratorios',
  `SaldoComFaltaPa` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision Falta Pago',
  `SaldoOtrasComis` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision Otras Comisiones',
  `SalIVAInteres` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Interes',
  `SalIVAMoratorios` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Moratorios',
  `SalIVAComFalPago` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Comision Falta Pago',
  `SalIVAComisi` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Otras Comisiones',
  `SalRetencion` decimal(12,2) DEFAULT '0.00' COMMENT 'Retencion Acumulada',
  `PasoCapAtraDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Capital que paso a Atrasado dia de hoy',
  `PasoIntAtraDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Interes que paso a Atrasado dia de hoy',
  `IntOrdDevengado` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto de interes Ordinario Devengado',
  `IntMorDevengado` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto de interes Moratorio Devengado',
  `ComisiDevengado` decimal(12,2) DEFAULT '0.00' COMMENT 'Monto de Comision por Falta de Pago',
  `PagoCapVigDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Capital Vigente del Dia',
  `PagoCapAtrDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Capital Atrasado del Dia',
  `PagoIntOrdDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Interes Ordinario del Dia',
  `PagoIntAtrDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Interes  Atrasado del Dia',
  `PagoComisiDia` decimal(12,2) DEFAULT '0.00' COMMENT 'Pagos de Interes No Comisiones del Dia',
  `PagoMoratorios` decimal(14,2) DEFAULT NULL COMMENT 'Pagos de\nMoratorio del Dia',
  `PagoIvaDia` decimal(12,2) DEFAULT '0.00' COMMENT 'Pagos de IVAS del Dia',
  `ISRDelDia` decimal(14,2) DEFAULT NULL COMMENT 'Interes Retenido en el Día\n',
  `DiasAtraso` int(11) DEFAULT '0' COMMENT 'Numero de Dias de Atraso Al Dia',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`FechaCorte`,`CreditoFondeoID`),
  KEY `Idx_SALDOSCREDPASIVOS_1` (`FechaCorte`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos Diarios de Creditos Pasivos'$$