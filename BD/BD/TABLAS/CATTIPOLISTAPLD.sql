-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOLISTAPLD
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOLISTAPLD`;DELIMITER $$

CREATE TABLE `CATTIPOLISTAPLD` (
  `TipoListaID` varchar(45) NOT NULL COMMENT 'Tipo de Lista',
  `Descripcion` varchar(200) NOT NULL COMMENT 'Descripcion de la lista',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la lista\nA: Activo\nI: Inactivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`TipoListaID`),
  UNIQUE KEY `TipoListaID_UNIQUE` (`TipoListaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el catalogo de listas de PLD (Carga de listas)'$$