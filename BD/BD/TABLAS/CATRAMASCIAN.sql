-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATRAMASCIAN
DELIMITER ;
DROP TABLE IF EXISTS `CATRAMASCIAN`;DELIMITER $$

CREATE TABLE `CATRAMASCIAN` (
  `CveRamaSCIAN` int(11) NOT NULL COMMENT 'Clave de la Rama SCIAN',
  `NombreRamaSCIAN` varchar(150) NOT NULL COMMENT 'Nombre de la rama SCIAN',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CveRamaSCIAN`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Ramas SCIAN (Sistema de Clasificación Industrial de América del Norte)'$$