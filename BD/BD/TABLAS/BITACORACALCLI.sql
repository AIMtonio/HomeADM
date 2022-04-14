-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACALCLI
DELIMITER ;
DROP TABLE IF EXISTS `BITACORACALCLI`;
DELIMITER $$


CREATE TABLE `BITACORACALCLI` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fecha` date NOT NULL COMMENT 'Fecha del Proceso',
  `Proceso` varchar(200) NOT NULL COMMENT 'Descripcion del Proceso',
  `Tiempo` int(11) NOT NULL COMMENT 'Tiempo en\nMinutos que tomo\nel Proceso',
  `Empresa` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bitacora de la Calificacion del Cliente'$$
