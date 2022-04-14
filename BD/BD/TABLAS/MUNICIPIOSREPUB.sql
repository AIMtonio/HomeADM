-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MUNICIPIOSREPUB
DELIMITER ;
DROP TABLE IF EXISTS `MUNICIPIOSREPUB`;DELIMITER $$

CREATE TABLE `MUNICIPIOSREPUB` (
  `EstadoID` int(11) NOT NULL COMMENT 'Numero de Estado',
  `MunicipioID` int(11) NOT NULL COMMENT 'Numero de Municipio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Numero de Empresa',
  `Nombre` varchar(150) DEFAULT NULL COMMENT 'Nombre del Municipio',
  `Ciudad` varchar(150) NOT NULL COMMENT 'Nombre de la ciudad. Si el municipio correspondiente no es considerado una ciudad el campo se queda vacio',
  `Localidad` varchar(10) DEFAULT NULL COMMENT 'Codigo de la\nLocalidad del\nMunicipio o\nDelegacion\nSegun Banco de\nMexico',
  `EqCNBV` varchar(200) DEFAULT NULL COMMENT ' Equivalencia del Municipio contra el catalogo de la CNBV',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EstadoID`,`MunicipioID`),
  KEY `MunicipioIDX` (`MunicipioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Municipios o Delgaciones de la Republica'$$