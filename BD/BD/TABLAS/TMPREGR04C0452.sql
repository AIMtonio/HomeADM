-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREGR04C0452
DELIMITER ;
DROP TABLE IF EXISTS `TMPREGR04C0452`;DELIMITER $$

CREATE TABLE `TMPREGR04C0452` (
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Identificador del reporte generado',
  `IdenCreditoCNBV` varchar(29) DEFAULT NULL COMMENT 'Identificador del Credito Utilizando Metodologia CNBV',
  `NumeroDispo` bigint(12) NOT NULL COMMENT 'Numero de Credito, sigue la misma nomenclatura que usa las cuentas de ahorro\n',
  `ClasifConta` varchar(12) CHARACTER SET utf8 NOT NULL COMMENT 'CLASIFICACION CONTABLE (R01 CATALOGO MINIMO) ',
  `FechaCorte` date DEFAULT NULL COMMENT 'FECHA DE CORTE ',
  `SalInsolutoInicial` decimal(21,2) DEFAULT NULL COMMENT 'SALDO INSOLUTO INICIAL A LA FECHA DE CORTE',
  `MontoDispuesto` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DISPUESTO EN LA FECHA DE CORTE ',
  `SalIntOrdin` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE INTERESES ORDINARIOS A LA FECHA DE CORTE ',
  `SalIntMora` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE INTERESES MORATORIOS A LA FECHA DE CORTE',
  `MontoComision` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE COMISIONES GENERADAS EN LA FECHA',
  `SaldoIVA` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DEL IMPUESTO AL VALOR AGREGADO A LA FECHA',
  `SalCapitalExigible` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DEL PAGO DE CAPITAL EXIGIBLE AL ACREDITADO A LA FECHA DE CORTE',
  `SalIntExigible` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DEL PAGO DE INTERESES EXIGIBLE A LA FECHA DE CORTE',
  `MontoComisionExigible` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DEL PAGO DE COMISIONES EXIGIBLE A LA FECHA DE CORTE',
  `CapitalPagado` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE CAPITAL PAGADO EFECTIVAMENTE',
  `IntOrdiPagado` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LOS INTERESES ORDINARIOS PAGADOS EFECTIVAMENTE',
  `IntMoraPagado` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LOS INTERESES MORATORIOS PAGADOS EFECTIVAMENTE',
  `MtoComisiPagado` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LAS COMISIONES PAGADAS EFECTIVAMENTE ',
  `OtrAccesoriosPagado` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE OTROS ACCESORIOS PAGADOS EFECTIVAMENTE',
  `TasaAnual` decimal(6,2) DEFAULT NULL COMMENT 'TASA ORDINARIA ANUAL A LA FECHA DE CORTE',
  `TasaMora` double(6,2) DEFAULT NULL COMMENT 'TASA MORATORIA ANUAL A LA FECHA DE CORTE',
  `SaldoInsoluto` decimal(21,2) DEFAULT NULL COMMENT 'SALDO INSOLUTO DEL CREDITO A LA FECHA DE CORTE ',
  `FechaUltDispo` date DEFAULT NULL COMMENT 'FECHA DE LA ULTIMA DISPOSICION DEL CREDITO',
  `PlazoVencimiento` int(11) DEFAULT NULL COMMENT 'PLAZO AL VENCIMIENTO DE LA LINEA DE CREDITO ',
  `SaldoPrincipalFP` decimal(21,2) DEFAULT NULL COMMENT 'SALDO DEL PRINCIPAL AL INICIO DEL PERIODO ',
  `MontoDispuestoFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DISPUESTO DE LA LINEA DE CREDITO EN EL MES',
  `CredDisponibleFP` decimal(21,2) DEFAULT NULL COMMENT 'CREDITO DISPONIBLE DE LA LINEA DE CREDITO ',
  `TasaAnualFP` decimal(6,2) DEFAULT NULL COMMENT 'TASA DE INTERES ANUAL ORDINARIA EN EL PERIODO',
  `TasaMoraFP` decimal(6,2) DEFAULT NULL COMMENT 'TASA DE INTERES ANUAL MORATORIA EN EL PERIODO',
  `SalIntOrdinFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE INTERESES ORDINARIOS EN EL PERIODO ',
  `SalIntMoraFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE INTERESES MORATORIOS EN EL PERIODO',
  `IntereRefinanFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE INTERESES REFINANCIADOS O RECAPITALIZADOS',
  `IntereReversoFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE INTERESES POR REVERSOS DE COBROS EN EL PERIODO',
  `SaldoPromedioFP` decimal(21,2) DEFAULT NULL COMMENT 'SALDO BASE PARA EL CALCULO DE INTERESES (SALDO PROMEDIO DIARIO)',
  `NumDiasIntFP` int(8) DEFAULT NULL COMMENT 'NUMERO DE DIAS UTILIZADOS PARA EL CALCULO DE INTERESES',
  `MontoComisionFP` decimal(21,2) DEFAULT NULL COMMENT 'COMISIONES GENERADAS EN EL PERIODO',
  `MontoCondonaFP` decimal(37,2) DEFAULT NULL COMMENT 'MONTO RECONOCIDO POR CONDONACION EN EL PERIODO',
  `MontoQuitasFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO RECONOCIDO POR QUITA O CASTIGOS ',
  `MontoBonificaFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO BONIFICADO POR LA ENTIDAD FINANCIERA ',
  `MontoDescuentoFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO RECONOCIDO POR DESCUENTOS',
  `MtoAumenDecrePrincFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE OTROS AUMENTOS O DECREMENTOS DEL PRINCIPAL',
  `CapitalPagadoFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE CAPITAL PAGADO EFECTIVAMENTE',
  `IntOrdiPagadoFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LOS INTERESES ORDINARIOS PAGADOS EFECTIVAMENTE',
  `IntMoraPagadoFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LOS INTERESES MORATORIOS PAGADOS EFECTIVAMENTE',
  `MtoComisiPagadoFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LAS COMISIONES PAGADAS EFECTIVAMENTE',
  `OtrAccesoriosPagadoFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE OTROS ACCESORIOS PAGADOS',
  `MontoPagadoEfecFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO TOTAL PAGADO EFECTIVAMENTE ',
  `SalCapitalFP` decimal(21,2) DEFAULT NULL COMMENT 'SALDO DEL PRINCIPAL AL FINAL DEL PERIODO',
  `SaldoInsolutoFP` decimal(21,2) DEFAULT NULL COMMENT 'SALDO INSOLUTO AL FINAL DEL PERIODO',
  `SituacContable` varchar(1) DEFAULT NULL COMMENT 'SITUACION DEL CREDITO ',
  `TipoRecuperacion` int(11) DEFAULT NULL COMMENT 'TIPO DE RECUPERACION DEL CREDITO',
  `NumDiasAtraso` int(11) DEFAULT '0' COMMENT 'Numero de Dias de Atraso Al Dia',
  `FecUltPagoCapFP` date DEFAULT NULL COMMENT 'FECHA DEL ULTIMO PAGO COMPLETO EXIGIBLE REALIZADO',
  `MontoUltiPagoFP` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DEL ULTIMO PAGO COMPLETO EXIGIBLE ',
  `FecPrimAorNoCubFP` date DEFAULT NULL COMMENT 'FECHA DE PRIMERA AMORTIZACION NO CUBIERTA',
  `TipoGarantia` int(11) NOT NULL DEFAULT '0' COMMENT 'Tipo de Garantia',
  `NumGarantias` bigint(11) DEFAULT NULL COMMENT 'NUMERO DE GARANTIAS',
  `ProgramaCred` bigint(11) DEFAULT NULL COMMENT 'PROGRAMA DE CREDITO DEL GOBIERNO FEDERAL',
  `MontoTotGarantias` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LA GARANTIA',
  `PorcentajeGarantia` decimal(21,2) DEFAULT NULL COMMENT 'PORCENTAJE QUE REPRESENTA LA GARANTIA DEL SALDO ',
  `GradoPrelacionGar` bigint(11) DEFAULT NULL COMMENT 'GRADO DE PRELACION DE LA GARANTIA',
  `FechaValuacionGar` date DEFAULT NULL COMMENT 'FECHA DE VALUACION DE LA GARANTIA',
  `NumeroAvales` bigint(11) DEFAULT NULL COMMENT 'NUMERO DE AVALES',
  `PorcentajeAvales` decimal(6,2) DEFAULT NULL COMMENT 'PORCENTAJE QUE GARANTIZA EL AVAL O AVALES',
  `NombreGarante` varchar(250) CHARACTER SET utf8 DEFAULT NULL COMMENT 'NOMBRE DEL GARANTE O AVAL',
  `RFCGarante` varchar(13) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'RFC DEL GARANTE O AVAL',
  `TipoCartera` bigint(11) DEFAULT NULL COMMENT 'TIPO DE CARTERA PARA FINES DE CALIFICACION ',
  `CredClas` char(1) DEFAULT NULL COMMENT 'CALIFICACION DE LA PARTE CUBIERTA CONFORME A LA METODOLOGIA DE INSTITUCIONES DE CREDITO',
  `CalifCubierta` varchar(2) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'CALIFICACION DE LA PARTE CUBIERTA ',
  `CalifExpuesta` varchar(2) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'CALIFICACION DE LA PARTE EXPUESTA',
  `ZonaMarginada` bigint(11) DEFAULT NULL COMMENT 'ZONA MARGINADA',
  `ClaveSIC` varchar(7) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT 'CLAVE DE PREVENCION',
  `TipoRecursos` int(11) DEFAULT NULL COMMENT 'FUENTE DE FONDEO DEL CREDITO ',
  `PorcentajeCubierto` decimal(6,2) DEFAULT NULL COMMENT 'PORCENTAJE DE ESTIMACIONES PREVENTIVAS A APLICAR CUBIERTO',
  `MontoCubierto` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DEL CREDITO CUBIERTO',
  `ReservaCubierta` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE ESTIMACIONES PREVENTIVAS PARTE CUBIERTA',
  `PorcentajeExpuesto` decimal(6,2) DEFAULT NULL COMMENT 'PORCENTAJE DE ESTIMACIONES PREVENTIVAS A APLICAR  EXPUESTO ',
  `MontoExpuesto` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DEL CREDITO EXPUESTO ',
  `ReservaExpuesta` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE ESTIMACIONES PREVENTIVAS PARTE EXPUESTA',
  `ReservaTotal` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LAS ESTIMACIONES PREVENTIVAS TOTALES',
  `ReservaSIC` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LAS ESTIMACIONES PREVENTIVAS ADICIONALES (SIC)',
  `ReservaAdicional` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LAS ESTIMACIONES PREVENTIVAS ADICIONALES  (BALANCE)',
  `ReservaAdiCNBV` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LAS ESTIMACIONES PREVENTIVAS ADICIONALES (FEDERACION )',
  `ResevaAdiTotal` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LAS ESTIMACIONES PREVENTIVAS ADICIONALES  TOTALES',
  `ResevaAdiCtaOrden` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE LAS ESTIMACIONES PREVENTIVAS ADICIONALES POR INTERESES DEVENGADOS NO COBRADOS  CREDITOS VENCIDOS (CUENTAS DE ORDEN)',
  `EstimaPrevenMesAnt` decimal(21,2) DEFAULT NULL COMMENT 'ESTIMACIONES PREVENTIVAS TOTALES DERIVADAS DE LA CALIFICACION DEL MES INMEDIATO ANTERIOR ',
  `CreditoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID del Credito',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del\nTipo de Producto',
  `TipoAmorti` int(11) DEFAULT NULL COMMENT 'TIPO DE AMORTIZACION',
  `SucursalID` varchar(11) CHARACTER SET utf8 DEFAULT NULL COMMENT 'Identificador de Sucursal',
  `DestinoCreID` int(11) DEFAULT NULL COMMENT 'DESTINO DEL CREDITO',
  `ClasifRegID` bigint(11) DEFAULT NULL COMMENT 'CLASIFICACION DEL CREDITO',
  `MontoCredito` decimal(21,2) DEFAULT NULL COMMENT 'Monto del Credito',
  `PeriodicidadCap` bigint(11) DEFAULT NULL COMMENT 'PERIODICIDAD DE PAGO DE CAPITAL',
  `PeriodicidadInt` bigint(11) DEFAULT NULL COMMENT 'PERIODICIDAD DE PAGO DE INTERES',
  `UltimaAmorti` int(11) DEFAULT NULL COMMENT 'ULTIMA AMORTIZACION ',
  `FecUltPagoCap` date DEFAULT NULL COMMENT 'FECHA DE ULTIMO PAGO DE CAPITAL',
  `FecUltPagoInt` date DEFAULT NULL COMMENT 'FECHA DE ULTIMO PAGO DE INTERES',
  `FechaQuitas` date DEFAULT NULL COMMENT 'FECHA DE QUITAS Y CONDONACIONES',
  `TipoCredito` varchar(1) CHARACTER SET utf8 NOT NULL COMMENT 'TIPO DEL CREDITO',
  `EstatusCredito` char(1) DEFAULT NULL COMMENT 'Estatus credito al cierre de mes',
  `SalIntCtaOrden` decimal(21,2) DEFAULT '0.00' COMMENT 'Saldo de Interes no Contabilizado',
  `SalMoraCtaOrden` decimal(21,2) DEFAULT NULL COMMENT 'SALDO DE INTERES MORATORIO EN CUENTAS DE ORDEN',
  `EPRCAdiCarVen` decimal(21,2) DEFAULT NULL COMMENT 'EPRC ADICIONAL DE CARTERA VENCIDA',
  `EPRCAdiSIC` bigint(11) DEFAULT NULL COMMENT 'EPRC ADICIONAL SIC',
  `EPRCAdiCNVB` bigint(11) DEFAULT NULL COMMENT 'EPRC ADICIONAL DE LA CNBV',
  `GtiaCtaAhorro` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE GARANTIAS DE CUENTA DE AHORRO (LIQUIDA)',
  `GtiaInversion` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE GARANTIAS DE INVERSION',
  `GtiaHisInver` decimal(21,2) DEFAULT NULL COMMENT 'MONTO DE GARANTIAS DEL HOSTORICO DE INVERSIONES',
  `GtiaHipotecaria` decimal(21,2) DEFAULT NULL COMMENT 'Monto de garantia hipotecaria',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del estado del cliente',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del muncipio del cliente',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'Numero de Localidad Correspondiente al Municipio',
  `ClasiDestinCred` char(1) DEFAULT NULL COMMENT 'CLASIFICACION DESTINO DEL C??EDITO',
  `GtiaMobiliaria` decimal(21,2) DEFAULT NULL COMMENT 'GARANTIA INMOBILIARIA',
  `SolicitudCreditoID` int(11) DEFAULT NULL COMMENT 'Solicitud de Credito. Sera una tabla de solicitudes\nPor el momento Es capturable, es un entero',
  `TipoPersona` int(11) DEFAULT NULL COMMENT 'Tipo de Persona',
  `NoCuotasAtraso` int(11) DEFAULT '0' COMMENT 'Numero de Cuotas en Atraso al Dia',
  `InstitFondeoID` int(11) DEFAULT NULL COMMENT 'Instituto de Fondeo',
  KEY `idx_TMPREGR04C0452_1` (`NumTransaccion`),
  KEY `idx_TMPREGR04C0452_2` (`CreditoID`,`NumTransaccion`),
  KEY `idx_TMPREGR04C0452_3` (`CreditoID`,`UltimaAmorti`,`NumTransaccion`),
  KEY `idx_TMPREGR04C0452_4` (`SolicitudCreditoID`,`NumTransaccion`),
  KEY `idx_TMPREGR04C0452_5` (`CreditoID`,`FecUltPagoCapFP`,`MontoUltiPagoFP`,`NumTransaccion`),
  KEY `idx_TMPREGR04C0452_6` (`NumTransaccion`,`EstadoID`,`MunicipioID`,`LocalidadID`),
  KEY `idx_TMPREGR04C0452_7` (`DestinoCreID`,`NumTransaccion`),
  KEY `idx_TMPREGR04C0452_8` (`ClasifRegID`,`NumTransaccion`),
  KEY `idx_TMPREGR04C0452_9` (`TipoPersona`,`NumTransaccion`),
  KEY `idx_TMPREGR04C0452_10` (`TipoRecursos`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA TEMPORAL PARA EL REGULATORIO C452'$$