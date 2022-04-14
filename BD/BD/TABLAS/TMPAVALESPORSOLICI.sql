-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALESPORSOLICI
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALESPORSOLICI`;DELIMITER $$

CREATE TABLE `TMPAVALESPORSOLICI` (
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Solicitud de credito',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Numero consecutivo de los avales por solicitud',
  `AvalID` bigint(11) DEFAULT NULL COMMENT 'Id del Aval, puede ser cliente, aval o prospecto.',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre completo del aval',
  `Telefono` varchar(20) DEFAULT NULL COMMENT 'Telefono del aval',
  `Calle` varchar(50) DEFAULT NULL COMMENT 'Calle del aval',
  `Numero` varchar(10) DEFAULT NULL COMMENT 'Numero del domicilio del aval',
  `CP` varchar(5) DEFAULT NULL COMMENT 'Codigo postal del aval',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'ID del estado del aval',
  `NombreEstado` varchar(100) DEFAULT NULL COMMENT 'Nombre del estado del aval',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Id del municipio del aval',
  `NombreMunicipio` varchar(150) DEFAULT NULL COMMENT 'Nombre del municipio del aval',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'Id de la localidad del aval',
  `NombreLocalidad` varchar(200) DEFAULT NULL COMMENT 'Nombre de la localidad del aval',
  `ColoniaID` int(11) DEFAULT NULL COMMENT 'ID de la Colonia del aval',
  `NombreColonia` varchar(400) DEFAULT NULL COMMENT 'Nombre de la colonia del aval',
  KEY `INDEX_TMPAVALESPORSOLICI_1` (`SolicitudCreditoID`),
  KEY `INDEX_TMPAVALESPORSOLICI_2` (`Consecutivo`),
  KEY `INDEX_TMPAVALESPORSOLICI_3` (`AvalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para la generacion del reporte de saldos de cartera para la gestion de cobranza'$$