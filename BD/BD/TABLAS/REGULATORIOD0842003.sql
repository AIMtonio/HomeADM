-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOD0842003
DELIMITER ;
DROP TABLE IF EXISTS `REGULATORIOD0842003`;DELIMITER $$

CREATE TABLE `REGULATORIOD0842003` (
  `Consecutivo` int(11) NOT NULL COMMENT 'Consecutivo del registro',
  `Anio` int(11) NOT NULL COMMENT 'Ano del periodo',
  `Mes` int(11) NOT NULL COMMENT 'Mes del Periodo',
  `Periodo` varchar(6) NOT NULL COMMENT 'Perido Concatenado',
  `ClaveEntidad` varchar(6) NOT NULL COMMENT 'Clave de la Entidad',
  `Formulario` char(5) NOT NULL COMMENT 'Numero de Subreporte',
  `NumeroIden` varchar(6) NOT NULL COMMENT 'Numero de Identificacion',
  `TipoPrestamista` int(11) NOT NULL COMMENT 'Tipo de organo prestamista',
  `PaisEntidadExt` int(11) NOT NULL COMMENT 'Pais del organismo o entidad financiera extranjera',
  `NumeroCuenta` varchar(22) NOT NULL COMMENT 'Numero de cuenta',
  `NumeroContrato` varchar(22) NOT NULL COMMENT 'Numero de contrato',
  `ClasificaConta` varchar(22) NOT NULL COMMENT 'Clasificacion contable del pretasmo',
  `FechaContra` date NOT NULL COMMENT 'Fecha de Contratacion',
  `FechaVencim` date NOT NULL COMMENT 'Fecha de Vencimiento',
  `PlazoVencimiento` int(11) DEFAULT NULL COMMENT 'Plazo en dias del vencimiento del prestamo',
  `PeriodoPago` int(11) NOT NULL COMMENT 'Periodicidad del plan de pagos',
  `MontoInicial` decimal(21,2) NOT NULL COMMENT 'Monto Original Recibido en su Moneda Origen',
  `MontoInicialMNX` decimal(21,2) NOT NULL COMMENT 'Monto Original Recibido en Pesos',
  `TipoTasa` int(11) NOT NULL COMMENT 'Tipo de tasa sobre el patron del credito',
  `ValorTasa` decimal(16,6) NOT NULL COMMENT 'Valor de la tasa originalmente pactada',
  `ValorTasaInt` decimal(16,6) NOT NULL COMMENT 'Valor de la tasa originalmente  de intereses pactada',
  `TasaIntReferencia` int(11) NOT NULL COMMENT 'Tasa de interes de referencia',
  `DifTasaReferencia` decimal(16,6) NOT NULL COMMENT 'Diferencial sobre taza de referecia',
  `OperaDifTasaRefe` int(11) NOT NULL COMMENT 'Operacion diferencial sobre tasa de referencia',
  `FrecRevTasa` int(11) NOT NULL COMMENT 'Numero de dias transcurridos entre revisiones de la tasa',
  `TipoMoneda` int(11) NOT NULL COMMENT 'Tipo de moneda segun catalogo en SITI',
  `PorcentajeComision` decimal(16,6) NOT NULL COMMENT 'Porcentaje de comision',
  `ImporteComision` decimal(21,2) NOT NULL COMMENT 'Importe de la comision',
  `PeriodoComision` int(11) NOT NULL COMMENT 'Periodicidad del pago de la comision',
  `TipoDispCredito` int(11) NOT NULL COMMENT 'Tipo de Disposicion de credito',
  `DestinoCredito` int(11) NOT NULL COMMENT 'Clave destino del credito',
  `ClasificaCortLarg` int(11) NOT NULL COMMENT 'Clasificacion Corto Largo Plazo',
  `SaldoIniPeriodo` decimal(21,2) NOT NULL COMMENT 'Saldo al inicio del periodo',
  `PagosPeriodo` decimal(21,2) NOT NULL COMMENT 'Monto de Pagos Realizadops en el periodo',
  `ComPagadasPeriodo` decimal(21,2) NOT NULL COMMENT 'Monto de Comisiones pagadas en el periodo',
  `InteresPagado` decimal(21,2) NOT NULL COMMENT 'Monto de Intereses pagados en el periodo',
  `InteresDevengados` decimal(21,2) NOT NULL COMMENT 'Monto de Intereses Devengados no pagados',
  `SaldoCierre` decimal(21,2) NOT NULL COMMENT 'Saldo al cierre del periodo',
  `PorcentajeLinRev` decimal(16,6) NOT NULL COMMENT 'Porcenteje dispuesto de linea revolvente',
  `FechaUltPago` date NOT NULL COMMENT 'Fecha de ultimo pago',
  `PagoAnticipado` int(11) NOT NULL COMMENT 'Indica pago anbticipado SI/NO',
  `MontoUltimoPago` decimal(21,2) NOT NULL COMMENT 'monto del ultimo pago relaizado',
  `FechaPagoSig` date NOT NULL COMMENT 'Fecha de pago inmediato siguiente',
  `MontoPagImediato` decimal(21,2) NOT NULL COMMENT 'Monto pago inmediato Siguiente',
  `TipoGarantia` int(11) NOT NULL COMMENT 'Tipo de garantia del credito',
  `MontoGarantia` decimal(21,2) NOT NULL COMMENT 'Monto o valor de garantia',
  `FechaValuaGaran` date NOT NULL COMMENT 'Fecha valuacion garantia',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usario ID',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa ID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`Consecutivo`,`Anio`,`Mes`),
  KEY `INDEX_REGULATORIOD0842003` (`Anio`,`Mes`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$