-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATACTIVIDADSIANFIRA
DELIMITER ;
DROP TABLE IF EXISTS `CATACTIVIDADSIANFIRA`;DELIMITER $$

CREATE TABLE `CATACTIVIDADSIANFIRA` (
  `CveSectorSCIAN` int(11) NOT NULL,
  `CveSubsectorSCIAN` int(11) NOT NULL COMMENT 'Clave Subsector SCIAN',
  `CveRamaSCIAN` int(11) NOT NULL COMMENT 'Clave Rama SCIAN',
  `CveSubramaSCIAN` int(11) NOT NULL COMMENT 'Clave Subrama SCIAN',
  `CveCadena` int(11) DEFAULT NULL COMMENT 'Clave Cadena Productiva',
  `CveSCIAN` int(11) DEFAULT NULL COMMENT 'Clave SCIAN',
  `NombreSCIAN` varchar(200) DEFAULT NULL COMMENT 'Nombre SCIAN',
  `FecActINEGI` varchar(200) DEFAULT NULL COMMENT 'Fecha Act INEGI',
  `CveActividadFIRA` int(11) DEFAULT NULL COMMENT 'Clave Actividad FIRA',
  `CveSubactividadFIRA` int(11) DEFAULT NULL COMMENT 'Clave Sub Actividad FIRA',
  `CveRamaFIRA` int(11) DEFAULT NULL COMMENT 'Clave Rama FIRA',
  `CveSubramaFIRA` int(11) DEFAULT NULL COMMENT 'Clave SubRama FIRA',
  `Prioritaria` varchar(200) DEFAULT NULL COMMENT 'Prioridad',
  `EstatusSCIANFIRA` varchar(200) DEFAULT NULL COMMENT 'Estatus SCIANFIRA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$