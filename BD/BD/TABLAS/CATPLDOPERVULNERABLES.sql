-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPLDOPERVULNERABLES
DELIMITER ;
DROP TABLE IF EXISTS `CATPLDOPERVULNERABLES`;
DELIMITER $$


CREATE TABLE `CATPLDOPERVULNERABLES` (
  `InstitucionID` int(11) NOT NULL COMMENT 'Frecuencia',
  `ClaveEntidadColegiada` varchar(20) DEFAULT NULL COMMENT 'Clave de la entidad de la financiera',
  `ClaveSujetoObligado` varchar(20) DEFAULT NULL COMMENT 'Clave del sujeto obligado de la financiera',
  `ClaveActividad` char(10) DEFAULT NULL COMMENT 'Clave de la actividad de la financiera',
  `Exento` int(11) DEFAULT NULL COMMENT 'Exento de la financiera',
  `DominioPlataforma` varchar(100) DEFAULT NULL COMMENT 'Dominio de la plataforma de la financiera',
  `ReferenciaAviso` int(11) DEFAULT NULL COMMENT 'Referencia del aviso',
  `Prioridad` int(11) DEFAULT NULL COMMENT 'Prioridad del aviso',
  `FolioModificacion` bigint(20) DEFAULT NULL COMMENT 'Folio de Modificacion',
  `DescripcionModificacion` varchar(3000) DEFAULT NULL COMMENT 'Descripcion de la modificacion',
  `TipoAlerta` int(11) DEFAULT NULL COMMENT 'Tipo d alerta',
  `DescripcionAlerta` varchar(3000) DEFAULT NULL COMMENT 'Descripcion alerta',
  `RutaArchivo`	varchar(100) COMMENT 'Ruta en donde se generara el archvo XML',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`InstitucionID`),
  CONSTRAINT `CATPLDOPERVULNERABLES_ibfk_1` FOREIGN KEY (`InstitucionID`) REFERENCES `INSTITUCIONES` (`InstitucionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Operaciones Vulnerables';$$
