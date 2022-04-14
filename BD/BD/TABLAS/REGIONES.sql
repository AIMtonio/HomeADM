-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGIONES
DELIMITER ;
DROP TABLE IF EXISTS `REGIONES`;DELIMITER $$

CREATE TABLE `REGIONES` (
  `RegionID` int(11) NOT NULL COMMENT 'ID de la region, consecutivo de la tabla',
  `Nombre` varchar(150) DEFAULT NULL COMMENT 'Nombre de la region',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RegionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Regiones donde la Institucion tiene operaciones'$$