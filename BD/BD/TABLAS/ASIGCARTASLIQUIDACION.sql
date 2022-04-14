-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGCARTASLIQUIDACION
DELIMITER ;
DROP TABLE IF EXISTS `ASIGCARTASLIQUIDACION`;
DELIMITER $$

CREATE TABLE `ASIGCARTASLIQUIDACION` (
  `AsignacionCartaID` bigint(11) NOT NULL COMMENT 'ID de Asignación de la Carta.',
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'ID de la Solicitud de Crédito.',
  `CasaComercialID` bigint(11) DEFAULT NULL COMMENT 'ID de la Casa Comercial.',
  `Monto` decimal(18,2) DEFAULT '0.00' COMMENT 'Monto de la Carta de Liquidación.',
  `MontoDispersion` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto de Dispersion de la Carta de Liquidacion',
  `FechaVigencia` date DEFAULT '1900-01-01' COMMENT 'Fecha de Vencimiento de la Carta de Liquidación.',
  `Estatus` char(1) DEFAULT 'N' COMMENT 'Estatus de la Carta de Asignación con respecto a Dispersion .\nS: si Dispersada \n N: No Dispersada',
  `ArchivoIDCarta` int(11) NOT NULL COMMENT 'ID de los Archivos de Expediente con respecto a la Carta de Liquidacion',
  `ArchivoIDPago` int(11) NOT NULL COMMENT 'ID de los Archivos de Expediente con respecto a la Comprobante de Pago',
  `DispImportada` char(1) DEFAULT 'N' COMMENT 'Movimiento Importada en Dispersiones S- SI Impirtada  N- NO Importada',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`AsignacionCartaID`),
  KEY `FK_ASIGCARTASLIQUIDACION_1_idx` (`SolicitudCreditoID`),
  KEY `FK_ASIGCARTASLIQUIDACION_2_idx` (`CasaComercialID`),
  CONSTRAINT `FK_ASIGCARTASLIQUIDACION_1` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ASIGCARTASLIQUIDACION_2` FOREIGN KEY (`CasaComercialID`) REFERENCES `CASASCOMERCIALES` (`CasaComercialID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que guarda la relación de las Cartas de Liquidación asignadas a una Solicitud de Crédito.'$$
