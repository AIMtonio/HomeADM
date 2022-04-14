-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCREDOM
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCREDOM`;DELIMITER $$

CREATE TABLE `CIRCULOCREDOM` (
  `fk_SolicitudID` varchar(10) NOT NULL COMMENT 'Es el numero de \nconsecutivo \nobtenido del \nprograma de \ncirculo de credito \nde la tabla de \nCIRCULOCRESOL',
  `Consecutivo` int(11) NOT NULL COMMENT 'Es el consecutivo\ndel numero de \nobjetos que se \nencuentran \nrelacionados a la\ntabla correspondiente\nen este caso son \nlas cuentas que \ntiene con el/los otorgante(s) \nla persona consultada',
  `Direccion` varchar(100) DEFAULT NULL,
  `ColPoblacion` varchar(100) DEFAULT NULL,
  `DelMunicipio` varchar(100) DEFAULT NULL,
  `Ciudad` varchar(45) DEFAULT NULL,
  `Estado` varchar(45) DEFAULT NULL,
  `CP` varchar(5) DEFAULT NULL,
  `FechaResidencia` date DEFAULT NULL,
  `NumTelefono` varchar(10) DEFAULT NULL,
  `TipoDomicilio` varchar(10) DEFAULT NULL COMMENT 'Es el tipo de domicilio\ndefinido en el manual\nesquema consulta y \nrespuesta en la seccion \nde Elementos \nDomicilio',
  PRIMARY KEY (`Consecutivo`,`fk_SolicitudID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene los domicios registrados de la persona consultada.'$$