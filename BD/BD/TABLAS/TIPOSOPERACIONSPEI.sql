-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSOPERACIONSPEI
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSOPERACIONSPEI`;DELIMITER $$

CREATE TABLE `TIPOSOPERACIONSPEI` (
  `TipoOperacionID` int(2) NOT NULL COMMENT 'ID tipo operacion',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del Tipo de operacion',
  `Estatus` char(1) NOT NULL COMMENT 'Activo (A), Inactivo (I).',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TipoOperacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo Tipos de operacion'$$