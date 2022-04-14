-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOSOLICITUD
DELIMITER ;
DROP TABLE IF EXISTS `FONDEOSOLICITUD`;DELIMITER $$

CREATE TABLE `FONDEOSOLICITUD` (
  `SolFondeoID` int(11) NOT NULL COMMENT 'ID de la solicitud de Fondeo\n',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Numero de Solicitud o ID',
  `Consecutivo` int(11) NOT NULL COMMENT 'Numero Consecutivo de Fondeo por Solicitud',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente o ID, del Inversionista o  Fondeador',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha del Registro del Fondeo',
  `MontoFondeo` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Fondeo',
  `PorcentajeFondeo` decimal(10,6) DEFAULT NULL COMMENT 'Porcentaje del Fondeo',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Fondeo de la Solicitud	\n	F .- En Proceso de Fondeo\n	C .- Cancelada\n	N .- Vigente o Inversion Creada',
  `TasaActiva` decimal(8,4) unsigned NOT NULL COMMENT 'Tasa Activa	',
  `TasaPasiva` decimal(8,4) NOT NULL COMMENT 'TasaPasiva',
  `FondeoKuboID` bigint(20) DEFAULT NULL COMMENT 'Numero o ID de\nFondeo, \nconsecutivo.\nNota: \nInicialmente esta\nvacio hasta que\nse formaliza el\ncredito\nY se asignan los\nfondeadores',
  `TipoFondeadorID` int(11) DEFAULT NULL,
  `ProdInvKuboID` int(11) NOT NULL COMMENT 'ID o Numero Unico del Producto de Inv. Kubo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SolFondeoID`),
  KEY `FK_CLIENTE_FONDEOSOLICITUD` (`ClienteID`),
  KEY `FK_MONEDA_FONDEOSOLICITUD` (`MonedaID`),
  KEY `FK_SOLICITUDCREDITO_FONDEOSOLICITUD` (`SolicitudCreditoID`),
  KEY `FK_FONDEOKUBO_FONDEOSOLICITUD` (`FondeoKuboID`),
  KEY `FK_TIPOSFONDEADORES_FONDEOSOLICITUD` (`TipoFondeadorID`),
  KEY `FK_FONDEOSOLICITUD_CTA` (`CuentaAhoID`),
  KEY `fk_FONDEOSOLICITUD_PRODINVERSION` (`ProdInvKuboID`),
  KEY `fk_FONDEOSOLICITUD_1_idx` (`SolicitudCreditoID`),
  CONSTRAINT `FK_CLIENTE_FONDEOSOLICITUD` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_FONDEOSOLICITUD_CTA` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_MONEDA_FONDEOSOLICITUD` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_FONDEOSOLICITUD_1` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_FONDEOSOLICITUD_PRODINVERSION` FOREIGN KEY (`ProdInvKuboID`) REFERENCES `PRODUCTOSINVKUBO` (`ProdInvKuboID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Inversionistas o Fondeo por Solicitud de Credito'$$