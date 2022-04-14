-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPANALITICOCARTFOND
DELIMITER ;
DROP TABLE IF EXISTS `TMPANALITICOCARTFOND`;DELIMITER $$

CREATE TABLE `TMPANALITICOCARTFOND` (
  `HoraEmision` time DEFAULT NULL COMMENT 'Hora de la Emision',
  `CreditoFondeoID` int(11) NOT NULL COMMENT 'ID del Credito',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Credito de la Tabla de CREDITOS',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `FechaMinistrado` date DEFAULT NULL COMMENT 'Fecha de ministración del credito',
  `FechaProxPag` varchar(20) DEFAULT NULL COMMENT 'Fecha del Proximo Pago',
  `MontoProx` varchar(18) DEFAULT NULL COMMENT 'Monto del Proximo pago',
  `FechaUltVenc` date DEFAULT NULL COMMENT 'Fecha del Ultimo Venc',
  `TasaFija` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Pasiva',
  `NumSocios` int(11) DEFAULT NULL COMMENT 'Numero de Socios que tiene el Credito Pasivo',
  `InstitutFondID` int(11) DEFAULT NULL COMMENT 'Id de la Institucion',
  `NombreInstitFon` varchar(200) DEFAULT NULL COMMENT 'Nombre Corto Institucion Fondeo\n',
  `LineaFondeoID` int(11) DEFAULT NULL COMMENT 'Id de linea',
  `DescripLinea` varchar(200) DEFAULT NULL COMMENT 'Descripcion de la linea\n',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Id de moneda',
  `EstatusCredito` varchar(7) CHARACTER SET utf8 DEFAULT NULL COMMENT 'Estatus del Crédito',
  `MontoCredito` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Crédito',
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
  KEY `IDX_TMPANALITICOCARTFOND_1` (`CreditoFondeoID`),
  KEY `IDX_TMPANALITICOCARTFOND_2` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal que almacena l informacion del reporte analitico de cartera'$$