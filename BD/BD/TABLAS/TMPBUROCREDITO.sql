-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBUROCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `TMPBUROCREDITO`;DELIMITER $$

CREATE TABLE `TMPBUROCREDITO` (
  `Relacion` int(11) DEFAULT NULL,
  `AvalID` bigint(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(200) DEFAULT NULL,
  `RFC` char(13) DEFAULT NULL,
  `EstadoCivil` char(2) DEFAULT NULL,
  `FolioConsulta` varchar(30) DEFAULT NULL,
  `FechaConsulta` datetime DEFAULT NULL,
  `ProspectoID` int(11) DEFAULT NULL,
  `DiasVigencia` int(11) DEFAULT NULL,
  `Calle` varchar(50) DEFAULT NULL,
  `EstadoID` int(11) DEFAULT NULL,
  `MunicipioID` int(11) DEFAULT NULL,
  `CP` varchar(5) DEFAULT NULL,
  `Oficial` char(1) DEFAULT NULL,
  `FolioCirculo` varchar(30) DEFAULT NULL,
  `FechaCirculo` datetime DEFAULT NULL,
  `DiasVigenciaC` int(11) DEFAULT NULL,
  `RealizaConsultasCC` char(1) DEFAULT NULL,
  `TipoContratoCCID` varchar(2) DEFAULT NULL,
  KEY `INDICE_TMPBUROCREDITO_1` (`Relacion`),
  KEY `INDICE_TMPBUROCREDITO_2` (`AvalID`),
  KEY `INDICE_TMPBUROCREDITO_3` (`ClienteID`),
  KEY `INDICE_TMPBUROCREDITO_4` (`ProspectoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$