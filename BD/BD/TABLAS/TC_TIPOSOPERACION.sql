-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_TIPOSOPERACION
DELIMITER ;
DROP TABLE IF EXISTS `TC_TIPOSOPERACION`;DELIMITER $$

CREATE TABLE `TC_TIPOSOPERACION` (
  `TipoOperacionID` varchar(2) NOT NULL COMMENT 'ID del tipo de operacion de tarjetas',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion de la Operacoion',
  `Concepto` varchar(150) NOT NULL COMMENT 'Concepto de la Operacion',
  `Naturaleza` char(1) DEFAULT NULL COMMENT 'Naturaleza de los movimientos que aplican por transaccion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(20) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`TipoOperacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Catalogo de Tipos de Operacion de Tarjetas'$$