-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWRESFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `CRWRESFONDEO`;
DELIMITER $$

CREATE TABLE `CRWRESFONDEO` (
  `TranRespaldo` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion de respaldo',
  `SolFondeoID` bigint(20) DEFAULT NULL COMMENT 'ID del Fondeo Crowdfunding.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero o ID de Cliente',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Numero de credito',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Cuenta de Ahorro del Cliente o Inversionista',
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero de solicitud',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Numero Consecutivo de Fondeo por Solicitud',
  `Folio` varchar(20) CHARACTER SET dec8 DEFAULT NULL COMMENT 'Folio del Fondeo Numero de Credito +  Consecutivo, convertidos a  Char',
  `CalcInteresID` int(11) DEFAULT NULL COMMENT 'Formula para el calculo de Interes',
  `TasaBaseID` int(11) DEFAULT NULL COMMENT 'Tasa Base, necesario dependiendo de la Formula',
  `SobreTasa` decimal(12,4) DEFAULT NULL COMMENT 'Si es formula dos (Tasa base mas puntos), aqui se definen Los puntos',
  `TasaFija` decimal(12,4) DEFAULT NULL COMMENT 'Si es formula uno (Tasa Fija), aqui se especifica el valor de dicha tasa fija',
  `PisoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Piso, Si es formula tres',
  `TechoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Techo, Si es formula tres',
  `MontoFondeo` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Fondeo',
  `PorcentajeFondeo` decimal(10,6) DEFAULT NULL COMMENT 'Porcentaje del Fondeo',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de vencimiento',
  `TipoFondeo` int(11) DEFAULT NULL COMMENT 'Tipo de FondeoID',
  `NumCuotas` int(11) DEFAULT NULL COMMENT 'Numero de Cuotas o Amortizaciones de Fondeo',
  `NumRetirosMes` int(11) DEFAULT NULL COMMENT 'Numero de  Retiros en el Mes',
  `PorcentajeMora` decimal(8,4) DEFAULT NULL,
  `PorcentajeComisi` decimal(8,4) DEFAULT NULL,
  `Estatus` char(1) CHARACTER SET big5 DEFAULT NULL COMMENT 'Estatus del Fondeo	N .- Vigente o en Proceso P .- Pagada V .- Vencida',
  `SaldoCapVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente',
  `SaldoCapExigible` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Exigible o en Atraso',
  `SaldoInteres` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes',
  `SaldoIntMoratorio` decimal(14,2) DEFAULT NULL,
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision Acumulada ',
  `MoratorioPagado` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de Moratorios Pagados al Inversionista CRW.',
  `ComFalPagPagada` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de  Comision por Falta de Pago Pagados al Inversionista CRW.',
  `IntOrdRetenido` decimal(14,4) DEFAULT NULL COMMENT 'Acumulado de Interes Ordinario Retenido al Inversionista CRW.',
  `IntMorRetenido` decimal(12,4) DEFAULT NULL COMMENT 'Acumulado de  Interes Moratorio Retenido al Inversionista CRW.',
  `ComFalPagRetenido` decimal(12,4) DEFAULT NULL COMMENT 'Acumulado de Comisio Falta Pago Retenido el Inversionista CRW.',
  `Gat` decimal(12,2) DEFAULT NULL COMMENT 'Calculo GAT',
  `CapitalCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'Capital que se encuentra en las cuentas de orden(capital que se uso para aplicar la garantia del credito)',
  `InteresCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'interes que se encuentra en cuentas de Orden(interes que se uso para aplicar la garantia al credito)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` date DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  KEY `INDEX_CRWRESFONDEO_1` (`TranRespaldo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Contiene el respaldo de la tabla CRWFONDEO.'$$
