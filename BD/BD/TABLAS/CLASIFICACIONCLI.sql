-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICACIONCLI
DELIMITER ;
DROP TABLE IF EXISTS `CLASIFICACIONCLI`;DELIMITER $$

CREATE TABLE `CLASIFICACIONCLI` (
  `ClasificaCliID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'clasificacion del cliente A, B, C',
  `RangoInferior` decimal(12,2) DEFAULT NULL COMMENT 'Valor del rango inferior',
  `RangoSuperior` decimal(12,2) DEFAULT NULL COMMENT 'Valor del rango superior',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`ClasificaCliID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena las diferentes clasificaciones que se le puede dar '$$