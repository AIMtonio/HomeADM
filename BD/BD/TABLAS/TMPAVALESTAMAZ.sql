-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALESTAMAZ
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALESTAMAZ`;DELIMITER $$

CREATE TABLE `TMPAVALESTAMAZ` (
  `AvalID` int(11) DEFAULT NULL COMMENT 'ID de AVALES.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID de CLIENTES.',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'ID de PROSPECTOS.',
  `Rol` char(1) DEFAULT '' COMMENT 'Tipo de Rol ID.',
  `NombreCompleto` varchar(500) DEFAULT NULL COMMENT 'Nombre Completo.',
  `RFC` varchar(20) DEFAULT NULL COMMENT 'RFC.',
  `IFE` varchar(20) DEFAULT '' COMMENT 'IFE.',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Direccion Completa.',
  `ColoniaID` int(11) DEFAULT NULL COMMENT 'Id de la colonia.',
  `NomColonia` varchar(500) DEFAULT NULL COMMENT 'Nombre de la colonia.',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'Id de la localidad.',
  `NomLocalidad` varchar(500) DEFAULT NULL COMMENT 'Nombre de la localidad.',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Id del municipio.',
  `NomMunicipio` varchar(500) DEFAULT NULL COMMENT 'Nombre del municipio.',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Id del Estado.',
  `NomEstado` varchar(500) DEFAULT NULL COMMENT 'Nombre del Estado.',
  `Pais` varchar(500) DEFAULT 'MÉXICO' COMMENT 'Nombre del Pais.',
  `CP` char(5) DEFAULT NULL COMMENT 'Codigo Postal.',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Número del Crédito.',
  KEY `IDX_TMPAVALESTAMAZ_1` (`CreditoID`),
  KEY `IDX_TMPAVALESTAMAZ_2` (`AvalID`),
  KEY `IDX_TMPAVALESTAMAZ_3` (`ClienteID`),
  KEY `IDX_TMPAVALESTAMAZ_4` (`ColoniaID`),
  KEY `IDX_TMPAVALESTAMAZ_5` (`LocalidadID`),
  KEY `IDX_TMPAVALESTAMAZ_6` (`MunicipioID`),
  KEY `IDX_TMPAVALESTAMAZ_7` (`EstadoID`),
  KEY `IDX_TMPAVALESTAMAZ_8` (`ProspectoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Temporal para la generación del pagaré tamazula.'$$