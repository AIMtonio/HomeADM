-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAUSASDEVSPEI
DELIMITER ;
DROP TABLE IF EXISTS `CAUSASDEVSPEI`;DELIMITER $$

CREATE TABLE `CAUSASDEVSPEI` (
  `CausaDevID` int(2) NOT NULL COMMENT 'ID de causas de devolucion',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion de la causa de devolucion',
  `Estatus` char(1) NOT NULL COMMENT 'Activo (A), Inactivo (I).',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CausaDevID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Causas de devolucion'$$