-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOGARANTIAS
DELIMITER ;
DROP TABLE IF EXISTS `TIPOGARANTIAS`;DELIMITER $$

CREATE TABLE `TIPOGARANTIAS` (
  `TipoGarantiasID` int(11) NOT NULL COMMENT 'cONSECUTIVO',
  `Descripcion` varchar(45) DEFAULT NULL COMMENT 'DESCRIPCION DE EL TIPO DE GARANTIA',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL COMMENT 'Consecutivo del tipo de garantia',
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(70) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoGarantiasID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de tipo de garantias'$$