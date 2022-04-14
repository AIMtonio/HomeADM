-- ----------------------------
-- Table structure for SERVICIOSXSOLCRED
-- ----------------------------
DELIMITER ;
DROP TABLE IF EXISTS `SERVICIOSXSOLCRED`;
DELIMITER $$

CREATE TABLE `SERVICIOSXSOLCRED` (
  `ServicioSolID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la tabla que relaciona los servicios adicionales con solicitud crédito/crédito',
  `ServicioID` int(11) NOT NULL COMMENT 'Identificador del servicio adicional',
  `SolicitudCreditoID` int(11) NOT NULL COMMENT 'Identificador de la solicitu de crédito',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Identificador del crédito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parámetro de auditoría',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parámetro de auditoría',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parámetro de auditoría',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parámetro de auditoría',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parámetro de auditoría',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parámetro de auditoría',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parámetro de auditoría',
  PRIMARY KEY (`ServicioSolID`),
  KEY `FK_SERVICIOSXSOLCRED_1` (`ServicioID`),
  CONSTRAINT `FK_SERVICIOSXSOLCRED_1` FOREIGN KEY (`ServicioID`) REFERENCES `SERVICIOSADICIONALES` (`ServicioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que Guarda la relación de servicio con Solicitud y Crédito'$$
