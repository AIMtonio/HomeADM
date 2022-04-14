-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPRENDIMIENTOCEDES
DELIMITER ;
DROP TABLE IF EXISTS `TMPRENDIMIENTOCEDES`;DELIMITER $$

CREATE TABLE `TMPRENDIMIENTOCEDES` (
  `CedeID` int(11) NOT NULL DEFAULT '0' COMMENT 'Identificador de la Cede.',
  `FechaCalculo` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha en la que se esta Realizando el Rendimiento de la Cede.',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la CEDE.',
  `TipoCedeID` int(11) DEFAULT NULL COMMENT 'Tipo CEDE',
  `TipoPagoInt` varchar(1) DEFAULT '' COMMENT 'Indica la forma de pago de interes.\nV - Vencimiento\nF - Fin del Mes\nP - Por Periodo',
  `DiasPeriodo` int(11) DEFAULT '0' COMMENT 'Indica el numero de dias si la forma de pago de interes es por PERIODO.',
  `PagoIntCal` char(2) DEFAULT '' COMMENT 'Indica el tipo de pago de interes.\nI - Iguales\nD - Devengado',
  `TasaFV` char(1) DEFAULT NULL COMMENT 'Tipo Tasa\nF.-Fija\nV.-Variable.',
  `Tasa` decimal(12,4) DEFAULT NULL COMMENT 'Valor de la Tasa a Aplicar.',
  `TasaNeta` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Neta.',
  `CalculoInteres` int(1) DEFAULT NULL COMMENT 'Calculo Interes\n1.- Tasa Fija\n2.- Tasa Inicio de Mes + Puntos\n3.- Tasa Apertura + Puntos\n4.- Tasa Promedio Mes + Puntos\n5.- Tasa Inicio de Mes + Puntos con Piso y Techo\n6.- Tasa Apertura + Puntos con Piso y Techo\n7.- Tasa Promedio Mes + Puntos con Piso y ',
  `TasaBase` int(2) DEFAULT NULL COMMENT 'TasaBaseID a Utilizar en Caso de Rendimiento Variable.',
  `SobreTasa` decimal(12,4) DEFAULT NULL COMMENT 'Son los Puntos Utilzados Dependiendo el Calculo de Interes.',
  `PisoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Minima Dependiendo el Calculo de Interes.',
  `TechoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Maxima Dependiendo el Calculo de Interes.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio de la CEDE.',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la CEDE.',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda.',
  `SaldoProvision` decimal(18,2) DEFAULT NULL COMMENT 'Saldo Provision Acumulado',
  `InteresGenerado` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Percibir Exacto para el Rendimiento Fijo, Aproximado para el Rendimiento Variable.',
  `ISRDiario` decimal(18,2) DEFAULT NULL COMMENT 'ISR Diario',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'TasaISR.',
  `PagaISR` char(1) DEFAULT NULL COMMENT 'Paga isr\nS.-Si\nN-No.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa.',
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Sucursal Origen del Cliente.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha de pago de la cede.',
  `FechaPagoAmo` date DEFAULT NULL COMMENT 'Fecha de pago de la amortizacion.',
  `FechaInicioAmo` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Inicio de la amortizacion',
  `FechaVencimAmo` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la amortizaciones.',
  `InteresAmo` decimal(18,2) DEFAULT NULL COMMENT 'Interes generado de la amortizacion',
  `IntRetenerAmo` decimal(18,2) DEFAULT NULL COMMENT 'Fecha de Inicio de la amortizacion',
  `SaldoProvAmo` decimal(18,2) DEFAULT NULL COMMENT 'Saldo provision de la amortizacion',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'Id de la amortizacion',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial',
  PRIMARY KEY (`CedeID`,`FechaCalculo`),
  KEY `FK_RENDIMIENTOCEDES_2` (`TipoCedeID`),
  CONSTRAINT `FK_TMPRENDIMIENTOCEDES_1` FOREIGN KEY (`CedeID`) REFERENCES `CEDES` (`CedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_TMPRENDIMIENTOCEDES_2` FOREIGN KEY (`TipoCedeID`) REFERENCES `TIPOSCEDES` (`TipoCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$