-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDES
DELIMITER ;
DROP TABLE IF EXISTS `CEDES`;DELIMITER $$

CREATE TABLE `CEDES` (
  `CedeID` int(11) NOT NULL COMMENT 'id de la tabla',
  `TipoCedeID` int(11) DEFAULT NULL COMMENT 'Tipo de CEDE',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Cuenta de ahorro',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente ID',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de inicio de la CEDE',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de vencimiento',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha de pago',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la CEDE',
  `Plazo` int(11) DEFAULT NULL COMMENT 'Plazo de la CEDE',
  `TasaFija` decimal(14,4) DEFAULT NULL COMMENT 'tasa fija',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'tasa ISR',
  `TasaNeta` decimal(12,4) DEFAULT NULL COMMENT 'tasa Neta',
  `CalculoInteres` int(1) DEFAULT NULL COMMENT 'Calculo de interes',
  `TasaBase` int(1) DEFAULT NULL COMMENT 'tasa base',
  `SobreTasa` decimal(12,4) DEFAULT NULL COMMENT 'sobre tasa',
  `PisoTasa` decimal(12,4) DEFAULT NULL COMMENT 'piso tasa',
  `TechoTasa` decimal(12,4) DEFAULT NULL COMMENT 'techo tasa',
  `InteresGenerado` decimal(18,2) DEFAULT NULL COMMENT 'interes generado',
  `InteresRecibir` decimal(18,2) DEFAULT NULL COMMENT 'interes a recibir',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'interes a retener',
  `SaldoProvision` decimal(18,2) DEFAULT NULL COMMENT 'Se Inicializa al Inicio de cada mes',
  `ValorGat` decimal(12,4) DEFAULT NULL COMMENT 'valor del Gat',
  `ValorGatReal` decimal(12,4) DEFAULT NULL COMMENT 'valor del Gat real ',
  `EstatusImpresion` char(1) DEFAULT NULL COMMENT 'Estatus de la impresion ',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'ID de la moneda',
  `FechaVenAnt` date DEFAULT NULL COMMENT 'decha de vencimiento anticipado ',
  `FechaApertura` date DEFAULT NULL COMMENT 'fecha de apertura ',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus\nN =vigente\nP =Pagada\nC =Cancelada\nA =Registrada',
  `TipoPagoInt` char(1) DEFAULT NULL COMMENT 'Indica la forma de pago de interes.\nV - Vencimiento\nF - Fin del Mes\nP - Por Periodo',
  `DiasPeriodo` int(11) DEFAULT '0' COMMENT 'Indica el numero de dias si la forma de pago de interes es por PERIODO.',
  `PagoIntCal` char(2) DEFAULT '' COMMENT 'Indica el tipo de pago de interes.\nI - Iguales\nD - Devengado',
  `CedeRenovada` int(11) DEFAULT '0' COMMENT 'Numero de Cede que Fue Renovada. ',
  `PlazoOriginal` int(11) DEFAULT NULL COMMENT 'Plazo Original de la Cede',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal donde fue Autorizada la CEDE.',
  `Reinversion` char(1) DEFAULT NULL COMMENT 'Especifica si realiza Reinversion Automatica\nS.- Si realiza Reinversion Automatica\nN.- No Realiza Reinversion',
  `Reinvertir` char(3) DEFAULT NULL COMMENT 'Tipo de Reinversion Automatica \nC = Capital \nCI = Capital mas interes \nN = Ninguna',
  `FechaCancela` date DEFAULT NULL COMMENT 'Fecha de cancelacion de el CEDE',
  `UsuarioAut` int(11) DEFAULT NULL COMMENT 'Usuario que realiza la autorizacion de la cancelacion o el vencimiento anticipado de la cede',
  `CajaRetiro` int(11) DEFAULT NULL COMMENT 'Sucursal en la que se retirara el monto de la inversion al finalizar.',
  `ISRReal` decimal(14,2) DEFAULT '0.00' COMMENT 'La columna sirver paara acumular el ISR Diario por socio solo cuando este activa esta opcion en PARAMGENERALES',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`CedeID`),
  KEY `fk_CEDES_1_idx` (`ClienteID`),
  KEY `fk_CEDES_2_idx` (`CuentaAhoID`),
  KEY `fk_CEDES_3_idx` (`MonedaID`),
  KEY `fk_CEDES_4_idx` (`TipoCedeID`),
  CONSTRAINT `fk_CEDES_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CEDES_3` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CEDES_4` FOREIGN KEY (`TipoCedeID`) REFERENCES `TIPOSCEDES` (`TipoCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$