-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISRIESGOCTEPLD
DELIMITER ;
DROP TABLE IF EXISTS `HISRIESGOCTEPLD`;DELIMITER $$

CREATE TABLE `HISRIESGOCTEPLD` (
  `ClienteID` int(11) NOT NULL,
  `Consecutivo` int(4) DEFAULT NULL,
  `FechaAsignacion` date DEFAULT NULL,
  `NivelRiesgoID` int(11) DEFAULT NULL,
  `MotivoNRiesgoID` char(3) DEFAULT NULL,
  `ProNriesgoCteID` char(3) DEFAULT NULL,
  `UsuarioID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico de cambios en el riesgo de los clientes y usuarios'$$