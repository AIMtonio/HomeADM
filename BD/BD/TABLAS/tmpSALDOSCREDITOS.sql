-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmpSALDOSCREDITOS
DELIMITER ;
DROP TABLE IF EXISTS `tmpSALDOSCREDITOS`;DELIMITER $$

CREATE TABLE `tmpSALDOSCREDITOS` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del Credito',
  `FechaCorte` date NOT NULL COMMENT 'Fecha de Corte',
  `SalCapVigente` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Vigente',
  `SalCapAtrasado` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Atrasado',
  `SalCapVencido` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Vencido',
  `SalCapVenNoExi` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Vencido no Exigible',
  `SalIntOrdinario` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes Ordinario',
  `SalIntAtrasado` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes Atrasado',
  `SalIntVencido` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes Vencido',
  `SalIntProvision` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Provision',
  `SalIntNoConta` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes no Contabilizado',
  `SalMoratorios` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Moratorios',
  `SaldoMoraVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
  `SaldoMoraCarVen` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
  `SalComFaltaPago` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision Falta Pago',
  `SalOtrasComisi` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision Otras Comisiones',
  `SalIVAInteres` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Interes',
  `SalIVAMoratorios` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Moratorios',
  `SalIVAComFalPago` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Comision Falta Pago',
  `SalIVAComisi` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Otras Comisiones',
  `PasoCapAtraDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Capital que paso a Atrasado dia de hoy',
  `PasoCapVenDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Capital que paso a Vencido dia de hoy',
  `PasoCapVNEDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Capital que paso a VNE dia de hoy',
  `PasoIntAtraDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Interes que paso a Atrasado dia de hoy',
  `PasoIntVenDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Interes que paso a Vencido dia de hoy',
  `CapRegularizado` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto del Capital Regularizado al dia',
  `IntOrdDevengado` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto de interes Ordinario Devengado',
  `IntMorDevengado` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto de interes Moratorio Devengado',
  `ComisiDevengado` decimal(12,2) DEFAULT '0.00' COMMENT 'Monto de Comision por Falta de Pago',
  `PagoCapVigDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Capital Vigente del Dia',
  `PagoCapAtrDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Capital Atrasado del Dia',
  `PagoCapVenDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Capital Vencido del Dia',
  `PagoCapVenNexDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Capital VNE del Dia',
  `PagoIntOrdDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Interes Ordinario del Dia',
  `PagoIntVenDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Interes  Vencido del Dia',
  `PagoIntAtrDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Interes  Atrasado del Dia',
  `PagoIntCalNoCon` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Interes No Contabilizado del Dia',
  `PagoComisiDia` decimal(12,2) DEFAULT '0.00' COMMENT 'Pagos de Interes No Comisiones del Dia',
  `PagoMoratorios` decimal(14,2) DEFAULT NULL COMMENT 'Pagos de\nMoratorio del Dia',
  `PagoIvaDia` decimal(12,2) DEFAULT '0.00' COMMENT 'Pagos de IVAS del Dia',
  `IntCondonadoDia` decimal(14,2) DEFAULT NULL COMMENT 'Interes Codonado\nDel Dia',
  `MorCondonadoDia` decimal(14,2) DEFAULT NULL COMMENT 'Moratorios\nCodonados\nDel Dia',
  `DiasAtraso` int(11) DEFAULT '0' COMMENT 'Numero de Dias de Atraso Al Dia',
  `NoCuotasAtraso` int(11) DEFAULT '0' COMMENT 'Numero de Cuotas en Atraso al Dia',
  `MaximoDiasAtraso` int(11) DEFAULT NULL COMMENT 'Numero de Maximo Dias de atraso, historico',
  `LineaCreditoID` int(11) DEFAULT NULL COMMENT 'Id de linea de Credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id de cliente',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Id de moneda',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha Vencimiento',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigibilidad',
  `FechaLiquida` date DEFAULT NULL COMMENT 'Fecha Liquidación',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'id de producto',
  `EstatusCredito` char(1) DEFAULT NULL COMMENT 'Estatus credito al cierre de mes',
  `SaldoPromedio` decimal(14,2) DEFAULT NULL COMMENT 'Monto Original Credito',
  `MontoCredito` decimal(14,2) DEFAULT NULL,
  `FrecuenciaCap` char(1) DEFAULT NULL,
  `PeriodicidadCap` int(11) DEFAULT NULL COMMENT 'Periodicidad',
  `FrecuenciaInt` char(1) DEFAULT NULL COMMENT 'Frecuencia de Pago de las Amortizaciones de Interes\\nS .- Semanal, C .- Catorcenal Q .- Quincenal M .- Mensual P .- Periodo\\nB.-Bimestral  T.-Trimestral  R.-TetraMestral E.-Semestral  A.-Anual',
  `PeriodicidadInt` int(11) DEFAULT NULL,
  `NumAmortizacion` int(11) DEFAULT NULL COMMENT 'Numero de Amortizaciones o Cuotas \\n',
  `FechTraspasVenc` date DEFAULT NULL COMMENT 'Fecha de Traspaso a Vencido',
  `FechAutoriza` date DEFAULT NULL,
  `ClasifRegID` int(11) DEFAULT NULL COMMENT 'Clasificacion Segun Reportes Regulatorios',
  `DestinoCreID` int(11) DEFAULT NULL,
  `Calificacion` char(2) DEFAULT NULL COMMENT 'Calificacion de Cartera',
  `PorcReserva` decimal(14,2) DEFAULT NULL COMMENT 'Porcentaje de Reserva',
  `TipoFondeo` char(1) DEFAULT NULL COMMENT 'Tipo de Fondeo:\nP .- Recursos Propios\nF .- Institucion de Fondeo',
  `InstitFondeoID` int(11) DEFAULT NULL COMMENT 'Insitucion de Fondeo, puede no escoger linea de fondeo',
  `IntDevCtaOrden` decimal(14,2) DEFAULT NULL COMMENT 'Interes Devengado de Cartera Vencida, \nCuentas de Orden',
  `CapCondonadoDia` decimal(14,2) DEFAULT NULL COMMENT 'Capital Condonado del Dia',
  `ComAdmonPagDia` decimal(14,2) DEFAULT NULL COMMENT 'Comision por Admon, Pagad en el Dia',
  `ComCondonadoDia` decimal(14,2) DEFAULT NULL COMMENT 'Comision Condonado en el Dia',
  `DesembolsosDia` decimal(14,2) DEFAULT NULL COMMENT 'Comision Condonado en el Dia',
  `CapVigenteExi` decimal(14,2) DEFAULT NULL COMMENT 'Capital vigente exigible',
  `MontoTotalExi` decimal(14,2) DEFAULT NULL COMMENT 'Monto total exigible',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$