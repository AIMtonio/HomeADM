-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSPLANTILLA
DELIMITER ;
DROP TABLE IF EXISTS `SMSPLANTILLA`;DELIMITER $$

CREATE TABLE `SMSPLANTILLA` (
  `PlantillaID` int(11) NOT NULL COMMENT 'ID de la Plantilla',
  `Nombre` varchar(45) DEFAULT NULL COMMENT 'Nombre de la plantilla',
  `Descripcion` varchar(1500) DEFAULT NULL COMMENT 'Descripcion de la plantilla\\\\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PlantillaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$