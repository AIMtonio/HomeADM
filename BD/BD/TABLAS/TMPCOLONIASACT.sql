-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCOLONIASACT
DELIMITER ;
DROP TABLE IF EXISTS `TMPCOLONIASACT`;DELIMITER $$

CREATE TABLE `TMPCOLONIASACT` (
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Numero de Estado',
  `NombreEstado` varchar(100) DEFAULT NULL COMMENT 'Nombre de la Empresa',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Numero de Municipio',
  `NombreMunicipio` varchar(150) DEFAULT NULL COMMENT 'Nombre del Municipio',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'ID Localidad',
  `NombreLocalidad` varchar(200) DEFAULT NULL COMMENT 'Nombre de la localidad',
  `ColoniaID` int(11) DEFAULT NULL,
  `NombreColonia` varchar(200) DEFAULT NULL,
  `Tipo` varchar(200) DEFAULT NULL,
  `CP` char(5) DEFAULT NULL COMMENT 'Codigo Postal',
  `ColoniaIDSAFI` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$