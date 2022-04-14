-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFLACIONACTUAL
DELIMITER ;
DROP TABLE IF EXISTS `INFLACIONACTUAL`;DELIMITER $$

CREATE TABLE `INFLACIONACTUAL` (
  `InflacionID` int(11) NOT NULL,
  `InflacionProy` decimal(5,2) DEFAULT NULL,
  `FechaActualizacion` datetime DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`InflacionID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$