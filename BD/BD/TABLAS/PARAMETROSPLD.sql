-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSPLD
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSPLD`;
DELIMITER $$


CREATE TABLE `PARAMETROSPLD` (
  `FolioID` int(11) NOT NULL COMMENT 'Folio de parametros para el sistema de Alertas en el Pago de Remesas y Op. que exceden los limites mensuales.',
  `ClaveEntCasfim` char(6) DEFAULT NULL COMMENT 'clave de la entidad financiera',
  `ClaveOrgSupervisor` char(6) DEFAULT NULL COMMENT 'clave del órgano supervisor',
  `ClaveOrgSupervisorExt` char(3) DEFAULT NULL COMMENT 'extension del órgano supervisor',
  `FechaVigencia` date DEFAULT NULL COMMENT 'Fecha de Vigencia',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus\nV=Vigente\nB=Baja',
  `TipoITF` char(6) DEFAULT NULL COMMENT 'Tipo de Institucion Tecnologica Financiera',
  `PrioridadReporte` char(6) DEFAULT NULL COMMENT 'Prioridad del reporte (para XML)',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FolioID`),
  KEY `index1` (`ClaveEntCasfim`),
  KEY `index2` (`ClaveOrgSupervisor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros para generar el nombre de los reportes que se le envia a la CNBV'$$