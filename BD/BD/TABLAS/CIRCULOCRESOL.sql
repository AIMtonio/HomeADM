-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRESOL
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCRESOL`;DELIMITER $$

CREATE TABLE `CIRCULOCRESOL` (
  `SolicitudID` char(10) NOT NULL COMMENT 'Numero de solicitud\nobtenida directamente\ndel programa de \ncirculo de credito, ademas\nde ser la FK de \nlas tablas de circulo \nde credito',
  `Status` varchar(5) DEFAULT NULL,
  `Fecha` datetime NOT NULL,
  `FolConOtorgan` varchar(45) DEFAULT NULL,
  `ClaveOtorgante` varchar(45) DEFAULT NULL,
  `ExpEncontrado` varchar(45) DEFAULT NULL,
  `FolioConsulta` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`SolicitudID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='La tabla principal de las solicitudes hechas al programa de '$$