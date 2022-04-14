-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCREEMPLE
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCREEMPLE`;DELIMITER $$

CREATE TABLE `CIRCULOCREEMPLE` (
  `fk_SolicitudID` varchar(10) NOT NULL COMMENT 'Es el numero de \nconsecutivo \nobtenido del \nprograma de \ncirculo de credito \nde la tabla de \nCIRCULOCRESOL',
  `Consecutivo` int(11) NOT NULL COMMENT 'Es el consecutivo\ndel numero de \nobjetos que se \nencuentran \nrelacionados a la\ntabla correspondiente\nen este caso son \nlas cuentas que \ntiene con el/los otorgante(s) \nla persona consultada',
  `NombreEmpresa` varchar(45) DEFAULT NULL,
  `Direccion` varchar(100) DEFAULT NULL,
  `ColPoblacion` varchar(100) DEFAULT NULL,
  `DelMunicipio` varchar(100) DEFAULT NULL,
  `Ciudad` varchar(45) DEFAULT NULL,
  `Estado` varchar(45) DEFAULT NULL,
  `CP` varchar(5) DEFAULT NULL,
  `NumTelefono` varchar(10) DEFAULT NULL,
  `Extension` varchar(10) DEFAULT NULL,
  `Fax` varchar(45) DEFAULT NULL,
  `Puesto` varchar(45) DEFAULT NULL,
  `FecContratacion` date DEFAULT NULL,
  `ClaveMoneda` varchar(45) DEFAULT NULL,
  `SalarioMensual` decimal(14,2) DEFAULT NULL,
  `FecUltEmpleo` date DEFAULT NULL,
  `FechaVerEmpleo` date DEFAULT NULL COMMENT 'FechaVerificacionEmple \nsegun el manual Esquema\nConsulta y Respuesta',
  PRIMARY KEY (`fk_SolicitudID`,`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene los empleos registrados por los otorgantes relacion'$$