-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRENOMB
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCRENOMB`;DELIMITER $$

CREATE TABLE `CIRCULOCRENOMB` (
  `fk_SolicitudID` varchar(10) NOT NULL COMMENT 'Es el numero de \nconsecutivo \nobtenido del \nprograma de \ncirculo de credito \nde la tabla de \nCIRCULOCRESOL',
  `ApePaterno` varchar(45) DEFAULT NULL,
  `ApeMaterno` varchar(45) DEFAULT NULL,
  `ApeAdicional` varchar(45) DEFAULT NULL,
  `Nombres` varchar(45) DEFAULT NULL,
  `FechaNacimiento` date DEFAULT NULL,
  `RFC` varchar(45) DEFAULT NULL,
  `CURP` varchar(45) DEFAULT NULL,
  `Nacionalidad` varchar(45) DEFAULT NULL,
  `Residencia` varchar(45) DEFAULT NULL,
  `EstadoCivil` varchar(45) DEFAULT NULL,
  `Sexo` varchar(45) DEFAULT NULL,
  `ClaveIFE` varchar(45) DEFAULT NULL,
  `NumDependiente` int(11) DEFAULT NULL,
  `FechaDefuncion` datetime DEFAULT NULL,
  PRIMARY KEY (`fk_SolicitudID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene los nombres y datos de la persona consultada sobre '$$