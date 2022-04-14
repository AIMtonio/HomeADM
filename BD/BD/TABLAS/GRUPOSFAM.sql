-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSFAM
DELIMITER ;
DROP TABLE IF EXISTS `GRUPOSFAM`;DELIMITER $$

CREATE TABLE `GRUPOSFAM` (
  `ClienteID` bigint(12) NOT NULL COMMENT 'ID del Cliente a quien le pertenece el grupo.',
  `FamClienteID` int(11) NOT NULL COMMENT 'ID del Cliente Familiar.',
  `TipoRelacionID` int(11) DEFAULT NULL COMMENT 'ID del Tipo de Relación del Familiar (TIPORELACIONES).',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ClienteID`,`FamClienteID`),
  KEY `IDX_GRUPOSFAM_1` (`ClienteID`),
  KEY `IDX_GRUPOSFAM_2` (`FamClienteID`),
  KEY `IDX_GRUPOSFAM_3` (`TipoRelacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Grupos Famiiares de un Cliente.'$$