-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRECADRE
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCRECADRE`;DELIMITER $$

CREATE TABLE `CIRCULOCRECADRE` (
  `fk_SolicitudID` varchar(10) NOT NULL COMMENT 'Es el numero de \nconsecutivo \nobtenido del \nprograma de \ncirculo de credito\nde la tabla \nCIRCULOCRESOL',
  `CadenaEnviada` longblob,
  PRIMARY KEY (`fk_SolicitudID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de las cadenas recibidas a circulo de credito'$$