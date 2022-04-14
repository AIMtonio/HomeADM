-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPLOCALIDADESACT
DELIMITER ;
DROP TABLE IF EXISTS `TMPLOCALIDADESACT`;DELIMITER $$

CREATE TABLE `TMPLOCALIDADESACT` (
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Numero de Estado',
  `NombreEstado` varchar(100) DEFAULT NULL COMMENT 'Nombre de la Empresa',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Numero de Municipio',
  `NombreMunicipio` varchar(150) DEFAULT NULL COMMENT 'Nombre del Municipio',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'ID Localidad',
  `NombreLocalidad` varchar(200) DEFAULT NULL COMMENT 'Nombre de la localidad',
  `LocalidadIDSAFI` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$