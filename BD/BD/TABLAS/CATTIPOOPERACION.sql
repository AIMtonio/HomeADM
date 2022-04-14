-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOOPERACION
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOOPERACION`;DELIMITER $$

CREATE TABLE `CATTIPOOPERACION` (
  `TipoOperacionID` int(11) NOT NULL COMMENT 'Codigo de Tipo de Operacion',
  `Descripcion` varchar(50) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoOperacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipo de Operacion D2441 y D2442'$$