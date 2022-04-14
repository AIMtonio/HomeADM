-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATSUBRAMASCIAN
DELIMITER ;
DROP TABLE IF EXISTS `CATSUBRAMASCIAN`;DELIMITER $$

CREATE TABLE `CATSUBRAMASCIAN` (
  `CveRamaSCIAN` int(11) NOT NULL COMMENT 'Clave ID de la Rama (CATRAMASCIAN)',
  `CveSubramaSCIAN` int(11) NOT NULL COMMENT 'Clave de la Subrama',
  `NombreSubramaSCIAN` varchar(200) NOT NULL COMMENT 'Nombre de la subrama',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CveRamaSCIAN`,`CveSubramaSCIAN`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de SubRamas SCIAN (Sistema de Clasificación Industrial de América del Norte)'$$