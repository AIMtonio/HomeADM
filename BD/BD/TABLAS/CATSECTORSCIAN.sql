-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATSECTORSCIAN
DELIMITER ;
DROP TABLE IF EXISTS `CATSECTORSCIAN`;DELIMITER $$

CREATE TABLE `CATSECTORSCIAN` (
  `CveSectorSCIAN` int(11) NOT NULL DEFAULT '0' COMMENT 'Clave del Sector de acuerdo al SCIAN',
  `NombreSectorSCIAN` varchar(120) NOT NULL COMMENT 'Descripción del Sector de acuerdo SCIAN (Sistema de Clasificación Industrial de América del Norte)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CveSectorSCIAN`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Sectores SCIAN (Sistema de Clasificación Industrial de América del Norte)'$$