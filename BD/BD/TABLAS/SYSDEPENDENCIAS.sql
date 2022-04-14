-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SYSDEPENDENCIAS
DELIMITER ;
DROP TABLE IF EXISTS `SYSDEPENDENCIAS`;DELIMITER $$

CREATE TABLE `SYSDEPENDENCIAS` (
  `NombreTabla` varchar(64) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `NombreProcedimiento` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `TipoProcedimiento` varchar(1) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `TipoActualizacion` varchar(10) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Usuario` varchar(10) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `FechaActual` datetime DEFAULT NULL,
  PRIMARY KEY (`NombreTabla`,`NombreProcedimiento`),
  KEY `IDXTABLA` (`NombreTabla`),
  KEY `IDXPROX` (`NombreProcedimiento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$