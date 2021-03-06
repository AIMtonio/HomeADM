-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCREDITOS
DELIMITER ;
DROP TABLE IF EXISTS `SALDOSCREDITOS`;
DELIMITER $$

CREATE TABLE `SALDOSCREDITOS` (
  `SaldosCreditosID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID de la tabla',
  `CreditoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID del Credito',
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
  `SaldoComServGar` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision por Servicio de Garantia Agro',
  `SalOtrasComisi` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision Otras Comisiones',
  `SalIVAInteres` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Interes',
  `SalIVAMoratorios` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Moratorios',
  `SalIVAComFalPago` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Comision Falta Pago',
  `SaldoIVAComSerGar` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Iva Comision por Servicio de Garantia Agro',
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
  `FechaLiquida` date DEFAULT NULL COMMENT 'Fecha Liquidaci??n',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'id de producto',
  `EstatusCredito` char(1) DEFAULT NULL COMMENT 'Estatus credito al cierre de mes',
  `SaldoPromedio` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Original Credito',
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
  `SalMontoAccesorio` decimal(12,2) DEFAULT '0.00' COMMENT 'Almacena el importe de accesorios',
  `SalIVAAccesorio` decimal(12,2) DEFAULT '0.00' COMMENT 'Almacena el importe de IVA de los accesorios',
  `SalIntAccesorio` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Almacena el importe de interes de accesorios',
  `SalIVAIntAccesorio` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Almacena el importe de IVA de interes de los accesorios',
`SaldoComisionAnual`    DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Saldo Comision por Anualidad',
`SaldoSeguroCuota`      DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Saldo Saldo Seguro Cuota',
`SaldoComisionAnualIVA` DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Saldo Iva Comision por Anualidad',
`SaldoIVASeguroCuota`   DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Saldo Iva Seguro Cuota',
`SolicitudCreditoID`    BIGINT(12)      DEFAULT '0'             COMMENT 'ID de la solicitud de Credito Asociado al Credito',
`TipoCredito`           CHAR(1)         DEFAULT ''              COMMENT 'Indica el tratamiento al credito \nN=nuevo, \nR=reestructura, \nO=renovacion',
`PlazoID`               VARCHAR(20)     DEFAULT ''              COMMENT 'Plazo del credito',
`TasaFija`              DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Tasa fija anual que fue pactada con el credito.',
`TasaBase`              DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Tasa Base anualizada, esto solo aplica en caso que el credito maneje tasa variable',
`SobreTasa`             DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Sobre tasa que le aplica a la tasa base, esto solo si fue pactada una sobre tasa en el credito.',
`PisoTasa`              DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Piso tasa que le aplica a la tasa base, esto solo si fue pactada una sobre tasa en el credito.',
`TechoTasa`             DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Techo tasa que le aplica a la tasa base, esto solo si fue pactada una sobre tasa en el credito.',
`TipoCartera`           VARCHAR(2)      DEFAULT ''              COMMENT 'Se refiere el tipo de cartera que corresponde el cr????dito conforme a su origen (reestructurada, renovada, normal):\nNO = Normal \nRE = Reestructura \nRN = Renovada.',
`TipCobComMorato`       CHAR(1)         DEFAULT ''              COMMENT 'Campo que indica como se generan los moratorios:\nN = Indica que la mora se calcula con N veces la tasa ordinaria \nT = Indica que es una tasa fija para el calculo de moratorios.',
`FactorMora`            DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Factor de Moratorio',
`CreditoOrigen`         VARCHAR(200)    DEFAULT ''              COMMENT 'Numero de credito de acuerdo a SAFI. Es el credito a reestructurar o a renovar seg????n sea el caso, es decir, credito que se va a liquidar con la renovaci????n o la reestrutura.',
`ConGarPrenda`          CHAR(1)         DEFAULT ''              COMMENT 'Requiere Garantia Prendaria(mobiliaria)',
`ConGarLiq`             CHAR(1)         DEFAULT ''              COMMENT 'Requiere Garantia liquida',
`TotalParticipantes`    INT(11)         DEFAULT '0'             COMMENT 'Total Participantes del Credito o Solicitud Credito',
`FechaProximoPago`      DATE            DEFAULT '1900-01-01'    COMMENT 'Fecha de Proximo Pago inmediato',
`MontoProximoPago`      DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Monto de Proximo Pago inmediato',
`SaldoParaFiniq`        DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Monto para Finiquitar el Credito',
`CuotasPagadas`         INT(11)         DEFAULT '0.00'          COMMENT 'Numero de cuotas pagadas del credito',
`ValorCAT`              DECIMAL(12,4)   DEFAULT '0.00'          COMMENT 'Valor de CAT que tiene el credito',
`CapitalProxPago`       DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Capital a Pagar en el Proximo Pago',
`InteresProxPago`       DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Interes Ordinario a pagar en el Proximo Pago',
`IvaProxPago`           DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'IVA de Intereses a pagar en el Proximo Pago',
`SalInteresExigible`    DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Saldo de Interes Exigible, Tendra valor cuando el credito tiene al menos una cuota de atraso',
`IVAInteresExigible`    DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'IVA de Interes Exigible, Tendra valor cuando el credito tiene al menos una cuota de atraso',
`PagoIntOrdMes`         DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Monto de Intereses Ordinarios pagadas en el Mes',
`PagoIVAIntOrdMes`      DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Monto de IVA de Intereses Ordinarios pagadas en el Mes',
`PagoMoraMes`           DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Monto de Interes Moratorio pagado en el Mes',
`PagoIVAMoraMes`        DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Monto de IVA de Interes Moratorio pagado en el Mes',
`PagoComisiMes`         DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Monto de Comisiones pagadas en el Mes',
`OtrosCargosApagar`     DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Monto que suma Moratorios y Comisiones',
`IVAOtrosCargosApagar`  DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Monto de IVA de la suma de Moratorios y Comisiones',
`PagoIVAComisiMes`      DECIMAL(14,2)   DEFAULT '0.00'          COMMENT 'Monto de IVA de Comisiones pagadas en el Mes',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (SaldosCreditosID, FechaCorte),
  KEY `IDX_SALDOSCREDITOS_1_FechaCorte` (`FechaCorte`) USING BTREE,
  KEY `IDX_SALDOSCREDITOS_2_CredFecha` (`CreditoID`,`FechaCorte`),
  KEY `IDX_SALDOSCREDITOS_3_Credito` (`CreditoID`),
  KEY `IDX_SALDOSCREDITOS_4_Estat` (`EstatusCredito`),
  KEY `IDX_SALDOSCREDITOS_5_FecEstat` (`FechaCorte`,`EstatusCredito`),
  KEY `IDX_SALDOSCREDITOS_6_ID` (SaldosCreditosID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos Diarios de Credito'
PARTITION BY RANGE ( YEAR(FechaCorte))
SUBPARTITION BY HASH ( MONTH (FechaCorte))
SUBPARTITIONS 12
(PARTITION SALDOSCREDITOS_anio2018 VALUES LESS THAN (2019) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2019 VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2020 VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2021 VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2022 VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2023 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2024 VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2025 VALUES LESS THAN (2026) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2026 VALUES LESS THAN (2027) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2027 VALUES LESS THAN (2028) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2029 VALUES LESS THAN (2029) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2030 VALUES LESS THAN (2030) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2031 VALUES LESS THAN (2031) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2032 VALUES LESS THAN (2032) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2033 VALUES LESS THAN (2033) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2034 VALUES LESS THAN (2034) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_anio2035 VALUES LESS THAN (2035) ENGINE = InnoDB,
 PARTITION SALDOSCREDITOS_pmax VALUES LESS THAN MAXVALUE ENGINE = InnoDB)$$