-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATSUBSECTORSCIAN
DELIMITER ;
DROP TABLE IF EXISTS `CATSUBSECTORSCIAN`;DELIMITER $$

CREATE TABLE `CATSUBSECTORSCIAN` (
  `CveSectorSCIAN` int(11) NOT NULL COMMENT 'Clave del Sector de acuerdo al SCIAN',
  `CveSubsectorSCIAN` int(11) NOT NULL COMMENT 'Clave ID del Subsector SCIAN',
  `NombreSubsectorSCIAN` varchar(200) NOT NULL COMMENT 'Nombre del Subsector SCIAN',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CveSubsectorSCIAN`,`CveSectorSCIAN`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Subsectores SCIAN (Sistema de Clasificación Industrial de América del Norte)'$$