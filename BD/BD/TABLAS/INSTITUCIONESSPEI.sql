-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUCIONESSPEI
DELIMITER ;
DROP TABLE IF EXISTS `INSTITUCIONESSPEI`;DELIMITER $$

CREATE TABLE `INSTITUCIONESSPEI` (
  `InstitucionID` int(5) NOT NULL COMMENT 'ID de la institucion catalogo',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion de la institucion',
  `NumCertificado` int(11) NOT NULL COMMENT 'Numero de certificado de la institucion',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la institucion',
  `EstatusRecep` char(1) NOT NULL COMMENT 'Estatus de recepcion',
  `EstatusBloque` char(1) NOT NULL COMMENT 'Activo (A), Inactivo (I)',
  `FechaUltAct` datetime NOT NULL COMMENT 'Fecha de la ultima actualizacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`InstitucionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de instituciones spei'$$