-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPRENDIMIENTOAPORT
DELIMITER ;
DROP TABLE IF EXISTS `TMPRENDIMIENTOAPORT`;DELIMITER $$

CREATE TABLE `TMPRENDIMIENTOAPORT` (
  `AportacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Identificador de la Aportación.',
  `FechaCalculo` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha en la que se esta Realizando el Rendimiento de la Aportación.',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la Aportación.',
  `TipoAportacionID` int(11) DEFAULT NULL COMMENT 'Tipo de Aportación.',
  `TipoPagoInt` varchar(1) DEFAULT '' COMMENT 'Indica la forma de pago de interes.\nV - Vencimiento\nF - Fin del Mes\nP - Por Periodo.\nE.- Programado',
  `DiasPeriodo` int(11) DEFAULT '0' COMMENT 'Indica el numero de dias si la forma de pago de interes es por PERIODO.',
  `PagoIntCal` char(2) DEFAULT '' COMMENT 'Indica el tipo de pago de interes.\nI - Iguales\nD - Devengado',
  `TasaFV` char(1) DEFAULT NULL COMMENT 'Tipo Tasa\nF.-Fija\nV.-Variable.',
  `Tasa` decimal(12,4) DEFAULT NULL COMMENT 'Valor de la Tasa a Aplicar.',
  `TasaNeta` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Neta.',
  `CalculoInteres` int(1) DEFAULT NULL COMMENT 'Calculo Interes\n1.- Tasa Fija\n2.- Tasa Inicio de Mes + Puntos\n3.- Tasa Apertura + Puntos\n4.- Tasa Promedio Mes + Puntos\n5.- Tasa Inicio de Mes + Puntos con Piso y Techo\n6.- Tasa Apertura + Puntos con Piso y Techo\n7.- Tasa Promedio Mes + Puntos con Piso y Techo.',
  `TasaBase` int(2) DEFAULT NULL COMMENT 'TasaBaseID a Utilizar en Caso de Rendimiento Variable.',
  `SobreTasa` decimal(12,4) DEFAULT NULL COMMENT 'Son los Puntos Utilzados Dependiendo el Calculo de Interes.',
  `PisoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Minima Dependiendo el Calculo de Interes.',
  `TechoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Maxima Dependiendo el Calculo de Interes.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio de la Aportación.',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Aportación.',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda.',
  `SaldoProvision` decimal(18,2) DEFAULT NULL COMMENT 'Saldo Provision Acumulado',
  `SaldoISR` decimal(18,2) DEFAULT '0.00' COMMENT 'Saldo del devengo diario de ISR',
  `InteresGenerado` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Percibir Exacto para el Rendimiento Fijo, Aproximado para el Rendimiento Variable.',
  `ISRDiario` decimal(18,2) DEFAULT NULL COMMENT 'ISR Diario',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'TasaISR.',
  `PagaISR` char(1) DEFAULT NULL COMMENT 'Paga isr\nS.-Si\nN-No.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa.',
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Sucursal Origen del Cliente.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha de pago de la Aportación.',
  `FechaPagoAmo` date DEFAULT NULL COMMENT 'Fecha de pago de la amortizacion.',
  `FechaInicioAmo` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Inicio de la amortizacion',
  `FechaVencimAmo` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la amortizaciones.',
  `InteresAmo` decimal(18,2) DEFAULT NULL COMMENT 'Interes generado de la amortizacion',
  `IntRetenerAmo` decimal(18,2) DEFAULT NULL COMMENT 'Fecha de Inicio de la amortizacion',
  `SaldoProvAmo` decimal(18,2) DEFAULT NULL COMMENT 'Saldo provision de la amortizacion',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'Id de la amortizacion',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial',
  `TipoPeriodo` char(1) DEFAULT '' COMMENT 'Tipo de Periodo para el Cálculo de Interés e ISR.\nR.- Periodo Regular.\nI.- Periodo Irregular.',
  `PagoIntCapitaliza` char(1) DEFAULT 'I' COMMENT 'Indica si capitaliza interes S:Si, N:No, I:Indistinto',
  `SaldoCap` decimal(18,2) DEFAULT '0.00' COMMENT 'Saldo capital para aportaciones que capitalizan interes',
  `DiasAmo` int(11) DEFAULT '0' COMMENT 'Plazo en días de la amortización.',
  `TasaISRExt` decimal(12,2) DEFAULT '0.00' COMMENT 'Nuevo valor de la Tasa ISR cuando se trata de Residentes \nen el Extranjero.',
  `PaisResidencia` int(11) DEFAULT '0' COMMENT 'País de Residencia cuando se trata de Residentes \nen el Extranjero.',
  PRIMARY KEY (`AportacionID`,`FechaCalculo`),
  KEY `FK_TMPRENDIMIENTOAPORT_2` (`TipoAportacionID`),
  CONSTRAINT `FK_TMPRENDIMIENTOAPORT_1` FOREIGN KEY (`AportacionID`) REFERENCES `APORTACIONES` (`AportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_TMPRENDIMIENTOAPORT_2` FOREIGN KEY (`TipoAportacionID`) REFERENCES `TIPOSAPORTACIONES` (`TipoAportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Rendimientos de las aportaciones.'$$