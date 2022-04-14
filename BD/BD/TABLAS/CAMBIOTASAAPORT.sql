-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAMBIOTASAAPORT
DELIMITER ;
DROP TABLE IF EXISTS `CAMBIOTASAAPORT`;
DELIMITER $$

CREATE TABLE `CAMBIOTASAAPORT` (
  `ConsecutivoID` bigint(20) NOT NULL COMMENT 'ID Consecutivo',
  `AportacionID` bigint(20) DEFAULT NULL COMMENT 'ID de la aportacion',
  `TasaSugerida` decimal(12,2) DEFAULT NULL COMMENT 'Tasa sugerida por SAFI',
  `TasaNueva` decimal(12,2) DEFAULT NULL COMMENT 'Tasa nueva asignada manualmente',
  `Comentario` varchar(100) DEFAULT NULL COMMENT 'Comentario',
  `ClaveUsuario` varchar(50) DEFAULT NULL COMMENT 'Clave del usuario',
  `TipoRegistro` int(11) DEFAULT 0 COMMENT 'Tipo de Registro. 1: Alta de aportaciones. 2: Alta de condiciones de vencimiento.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_CAMBIOTASAAPORT_1` (`AportacionID`),
  KEY `INDEX_CAMBIOTASAAPORT_2` (`TipoRegistro`),
  KEY `INDEX_CAMBIOTASAAPORT_3` (`ProgramaID`),
  KEY `INDEX_CAMBIOTASAAPORT_4` (`AportacionID`, `TipoRegistro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que guarda los cambios manuales de tasas.'$$