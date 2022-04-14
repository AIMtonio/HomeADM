-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATUBICANEGOCIO
DELIMITER ;
DROP TABLE IF EXISTS `CATUBICANEGOCIO`;DELIMITER $$

CREATE TABLE `CATUBICANEGOCIO` (
  `UbicaNegocioID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID Consecutivo de la tabla',
  `Ubicacion` varchar(300) DEFAULT NULL COMMENT 'Descripcion de la \nubicacion del negocio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la \nempresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`UbicaNegocioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de ubicacion de negocio'$$