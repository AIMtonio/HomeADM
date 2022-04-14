-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRECADEN
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCRECADEN`;DELIMITER $$

CREATE TABLE `CIRCULOCRECADEN` (
  `fk_SolicitudID` varchar(10) NOT NULL COMMENT 'Es el numero de \nconsecutivo \nobtenido del \nprograma de \ncirculo de credito\nde la tabla \nCIRCULOCRESOL',
  `CadenaEnviada` mediumblob,
  PRIMARY KEY (`fk_SolicitudID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de las cadenas enviadas a circulo de credito'$$