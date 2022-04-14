-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPERACIONPLD
DELIMITER ;
DROP TABLE IF EXISTS `TIPOPERACIONPLD`;DELIMITER $$

CREATE TABLE `TIPOPERACIONPLD` (
  `TipoOperacionID` int(11) DEFAULT NULL COMMENT 'Tipo de operacion\nOPR1, OPR2, \nOPR3, OPE,OPS1',
  `Nombre` varchar(25) DEFAULT NULL COMMENT 'Nombre corto',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del campo',
  `EmpresaID` varchar(45) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros del modulo de detección y prevención de lavado de'$$