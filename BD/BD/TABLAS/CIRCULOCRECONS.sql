-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRECONS
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCRECONS`;DELIMITER $$

CREATE TABLE `CIRCULOCRECONS` (
  `fk_SolicitudID` varchar(10) NOT NULL COMMENT 'Es el numero de \nconsecutivo \nobtenido del \nprograma de \ncirculo de credito.',
  `Consecutivo` int(11) NOT NULL COMMENT 'Es el consecutivo\ndel numero de \nobjetos que se \nencuentran \nrelacionados a la\ntabla correspondiente\nen este caso son \nlas consultas que \nse le han hecho a la\npersona consultada.',
  `FecConsulta` date DEFAULT NULL COMMENT 'Fecha en la que se\nconsulto al cliente\npor parte del \notorgante(la empresa\nque presta servicio\nu otorga un credito)\n',
  `ClaveOtorgante` varchar(45) DEFAULT NULL,
  `NomOtorgante` varchar(45) DEFAULT NULL,
  `TelOtorgante` varchar(12) DEFAULT NULL,
  `TipoCredito` varchar(45) DEFAULT NULL,
  `ClaveUniMon` varchar(45) DEFAULT NULL,
  `ImporteCredito` decimal(14,2) DEFAULT NULL,
  `TipRespons` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`fk_SolicitudID`,`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda las consultas que se han hecho  a circulo de crédito '$$