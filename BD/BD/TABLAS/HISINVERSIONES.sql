-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISINVERSIONES
DELIMITER ;
DROP TABLE IF EXISTS `HISINVERSIONES`;DELIMITER $$

CREATE TABLE `HISINVERSIONES` (
  `FechaCorte` date NOT NULL COMMENT 'Fecha en que se realiza el corte del Historico.',
  `InversionID` int(11) NOT NULL COMMENT 'Llave primaria de Inversion',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `TipoInversionID` int(11) NOT NULL COMMENT 'LLave FK Tipo de Inversion',
  `FechaInicio` date NOT NULL COMMENT 'Fecha de Inicio de Inversion',
  `FechaVencimiento` date NOT NULL COMMENT 'Fecha de Vencimiento de Inversion',
  `Monto` decimal(12,2) DEFAULT NULL,
  `Plazo` int(11) NOT NULL COMMENT 'Plazo en Dias',
  `Tasa` decimal(12,2) DEFAULT NULL,
  `TasaISR` decimal(12,2) DEFAULT NULL,
  `TasaNeta` decimal(12,2) DEFAULT NULL,
  `InteresGenerado` decimal(12,2) DEFAULT NULL,
  `InteresRecibir` decimal(12,2) DEFAULT NULL,
  `InteresRetener` decimal(12,2) DEFAULT NULL,
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la Inversion\n	''A''.- Alta (no autorizada)\n	''N''.- Vigente (cargada a cuenta)\n	''P''.- Pagada (abonada a cuenta)\n	''C''.- Cancelada',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario que autorizo la inversion',
  `Reinvertir` char(5) DEFAULT NULL COMMENT 'Tipo de Reinversion Automatica \nC = Capital \nCI = Capital mas interes \nN = Ninguna',
  `EstatusImpresion` char(1) DEFAULT NULL COMMENT 'Status de Impresión\n	I .- Impresa\n	N .- No Impresa',
  `InversionRenovada` int(11) DEFAULT NULL COMMENT 'Numero de Inversion Renovada. Inicialmente es\nCero, se llena cuando se realize la reinversion.',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda de la\nInversion',
  `Etiqueta` varchar(100) DEFAULT NULL COMMENT 'Etiqueta o \nReferencia del\nMotivo de Apertura\nde la Inversion',
  `SaldoProvision` decimal(12,2) DEFAULT NULL COMMENT 'Saldo o Acumulado\nDiario del\nInteres\nProvisionado',
  `ValorGat` decimal(12,2) DEFAULT NULL COMMENT 'Calculo GAT',
  `Beneficiario` char(1) DEFAULT NULL COMMENT 'Tipo de Beneficiario de la inversión, puede ser: Cuenta Socio "S"   o Propio de la Inversión "I"',
  `ValorGatReal` decimal(12,2) DEFAULT NULL,
  `ISRReal` decimal(12,2) DEFAULT '0.00' COMMENT 'La columna sirver paara acumular el sr Diario por socio solo cuando estee activa esta opcion en  PARAMGENERALES',
  `FechaVenAnt` date DEFAULT NULL COMMENT 'Fecha en que se vencio anticipadamente la inversion ',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InversionID`,`FechaCorte`),
  KEY `fk_HISINVERSIONES_1_idx` (`InversionID`),
  KEY `fk_HISINVERSIONES_2_idx` (`CuentaAhoID`),
  CONSTRAINT `fk_HISINVERSIONES_1` FOREIGN KEY (`InversionID`) REFERENCES `INVERSIONES` (`InversionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISINVERSIONES_2` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico de inversiones '$$