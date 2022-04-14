-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOKUBO
DELIMITER ;
DROP TABLE IF EXISTS `FONDEOKUBO`;DELIMITER $$

CREATE TABLE `FONDEOKUBO` (
  `FondeoKuboID` bigint(20) NOT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero o ID del Cliente',
  `CreditoID` int(11) DEFAULT NULL COMMENT 'Numero de Credito',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero de Solicitud',
  `Consecutivo` bigint(20) DEFAULT NULL COMMENT 'Numero Consecutivo de Fondeo por Solicitud\n',
  `Folio` varchar(20) DEFAULT NULL COMMENT 'Folio del Fondeo\nNumero de\nCredito + \nConsecutivo,\nconvertidos a\n Char',
  `CalcInteresID` int(11) DEFAULT NULL COMMENT 'Formula para el calculo de Interes',
  `TasaBaseID` int(11) DEFAULT NULL COMMENT 'Tasa Base, necesario dependiendo de la Formula',
  `SobreTasa` decimal(12,4) DEFAULT NULL COMMENT 'Si es formula dos (Tasa base mas puntos), aqui se definen\n Los puntos',
  `TasaFija` decimal(12,4) DEFAULT NULL COMMENT 'Si es formula uno (Tasa Fija), aqui se especifica el valor de dicha\ntasa fija',
  `PisoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Piso, Si es formula tres',
  `TechoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Techo, Si es formula tres',
  `MontoFondeo` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Fondeo',
  `PorcentajeFondeo` decimal(8,4) DEFAULT NULL COMMENT 'Porcentaje del Fondeo',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `TipoFondeo` int(11) NOT NULL COMMENT 'Tipo de FondeoID',
  `NumCuotas` int(11) DEFAULT NULL COMMENT 'Numero de Cuotas o Amortizaciones de Fondeo',
  `NumRetirosMes` int(11) DEFAULT NULL COMMENT 'Numero de \nRetiros en el\nMes',
  `PorcentajeMora` decimal(8,4) DEFAULT NULL COMMENT 'Porcentaje de Participacion en la Mora',
  `PorcentajeComisi` decimal(8,4) DEFAULT NULL COMMENT 'Porcentaje de Participacion en Comisiones',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del Fondeo	\nN .- Vigente o en Proceso\nP .- Pagada\nV .- Vencida',
  `SaldoCapVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nVigente',
  `SaldoCapExigible` decimal(14,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nExigible o\nen Atraso',
  `SaldoInteres` decimal(14,4) DEFAULT NULL COMMENT 'Saldo\nde Interes',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision\nAcumulada ',
  `MoratorioPagado` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de \nMoratorios\nPagados al\nInversionista\nkubo',
  `ComFalPagPagada` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de \nComision por Falta de Pago\nPagados al\nInversionista\nkubo',
  `IntOrdRetenido` decimal(14,4) DEFAULT NULL COMMENT 'Acumulado de \nInteres Ordinario\nRetenido\nal Inversionista\nkubo',
  `IntMorRetenido` decimal(12,4) DEFAULT NULL COMMENT 'Acumulado de \nInteres Moratorio\nRetenido\nal Inversionista\nkubo',
  `ComFalPagRetenido` decimal(12,4) DEFAULT NULL COMMENT 'Acumulado de \nComisio Falta Pago\nRetenido\nal Inversionista\nkubo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FondeoKuboID`),
  KEY `FK_CLIENTE_FONDEOKUBO` (`ClienteID`),
  KEY `FK_SOLICITUDCREDITO_FONDEOKUBO` (`SolicitudCreditoID`),
  KEY `FK_TASABASE_FONDEOKUBO` (`TasaBaseID`),
  KEY `FK_MONEDA_FONDEOKUBO` (`MonedaID`),
  KEY `FK_CONSECUTIVO_FONDEOKUBO` (`Consecutivo`),
  KEY `FK_CUENTA_AHO` (`CuentaAhoID`),
  KEY `fk_FONDEOKUBO_1` (`TipoFondeo`),
  KEY `fk_FONDEOKUBO_2_idx` (`SolicitudCreditoID`),
  CONSTRAINT `FK_CLIENTE_FONDEOKUBO` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CUENTA_AHO` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_MONEDA_FONDEOKUBO` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_FONDEOKUBO_1` FOREIGN KEY (`TipoFondeo`) REFERENCES `TIPOSFONDEADORES` (`TipoFondeadorID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_FONDEOKUBO_2` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Fondeos de Credito'$$