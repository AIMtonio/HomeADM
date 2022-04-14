-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCREERROR
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCREERROR`;DELIMITER $$

CREATE TABLE `CIRCULOCREERROR` (
  `fk_SolicitudID` varchar(10) NOT NULL,
  `Consecutivo` int(11) NOT NULL,
  `Descripcion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`fk_SolicitudID`,`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de control de errores del programa de circulo de credi'$$